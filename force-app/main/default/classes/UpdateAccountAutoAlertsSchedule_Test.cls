/**
*
* @Name                 : UpdateAccountAutoAlertsSchedule_Test 
* @Author               : Deepak - Happiest minds 
* @Modifiedby           : Megha - Happiest Minds
* @Description          : This test class is used to check for UpdateAccountAutoAlertsSchedule Schedule batch job class and UpdateAccountAutoAlerts class
* @Created date         : 25-09-2018
* @ModifiedDate         : 03-04-2020
**/
@istest
class UpdateAccountAutoAlertsSchedule_Test 
{
    static testmethod void test() 
    {
        Test.startTest();
               
        User objuser = [select Id, username,cllease__Current_Branch_s_System_Date__c from User where Id = :UserInfo.getUserId()];
        Date dt = Date.valueof(objuser.cllease__Current_Branch_s_System_Date__c); 
            
        List<cllease__Lease_account_Due_Details__c> lstbills = [SELECT id,cllease__Lease_Account__c FROM cllease__Lease_account_Due_Details__c WHERE cllease__Due_Date__c = :dt];
        // Schedule the test job
    
        /*String jobId = System.schedule('UpdateAccountAutoAlertsSchedule',
                                       UpdateAccountAutoAlertsSchedule.CRON_EXP, 
                                       new UpdateAccountAutoAlertsSchedule());
    
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
    
        // Verify the expressions are the same
        System.assertEquals(UpdateAccountAutoAlertsSchedule.CRON_EXP, 
                            ct.CronExpression);
    
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);*/
        
        Test.stopTest();
    }
    
    static testmethod void UpdateAccountAutoAlerts_Test1() 
    {        
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        
        Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;
        objSettings1.DisableAgreementTriggers__c = true;
        UPSERT objSettings1;
        
        cllease__Office_Name__c company = new cllease__Office_Name__c();// = 
            //[SELECT Id, Name,cllease__Current_System_Date__c FROM cllease__Office_Name__c Limit 1];
        company.Name = 'Test-Company';
        company.cllease__Current_System_Date__c = Date.newInstance(2018, 01, 01);
        company.cllease__Office_Short_Name__c = 'TC-Test';
        insert company;
        
        cllease.TestHelper.createSeedDataForTesting();
        // Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        
        // Create Account
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.Name = 'TestAccount-1';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA';
        lessee.ShippingCity = 'London';
        insert lessee;
        
        Account lessee1 = new Account();
        lessee1.RecordtypeID=rec.id;
        lessee1.Name = 'TestAccount-2';
        lessee1.Phone = '98767 678987';
        lessee1.Landline__c= '98767 678987';
        lessee1.BillingPostalCode = 'BD1 1HA';
        lessee1.BillingCity = 'London';
        lessee1.ShippingPostalCode = 'BD1 1HA';
        lessee1.ShippingCity = 'London';
        insert lessee1;
        
        Account lessee2 = new Account();
        lessee2.RecordtypeID=rec.id;
        lessee2.Name = 'TestAccount-3';
        lessee2.Phone = '98767 678987';
        lessee2.Landline__c= '98767 678987';
        lessee2.BillingPostalCode = 'BD1 1HA';
        lessee2.BillingCity = 'London';
        lessee2.ShippingPostalCode = 'BD1 1HA';
        lessee2.ShippingCity = 'London';
        insert lessee2;
        
        // Create contact
        Contact con = new contact();      
        con.Birthdate = Date.newInstance(1965, 10, 29);    
        con.LastName = 'TESTADAIR';
        con.Firstname = 'PETER';      
        con.accountid = lessee.id ;        
        insert con ;
    
        System.debug(LoggingLevel.ERROR, '*** lessee : ' + lessee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        
        // cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
                                                                                         cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
                                                                                cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP;
        
        // Create Agreements
        List<cllease__Lease_Account__c> clist = new List<cllease__Lease_Account__c>();
    
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c    = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        insert leaseAccount;

        List<cllease__Lease_account_Due_Details__c> lstbill = new List<cllease__Lease_account_Due_Details__c>();
        
        //cllease__Lease_account_Due_Details__c:
        cllease__Lease_account_Due_Details__c bills      = new cllease__Lease_account_Due_Details__c();
        bills.cllease__Lease_Account__c=leaseAccount.ID; 
        bills.cllease__Due_Date__c=Date.newInstance(2017, 03, 01);
        bills.cllease__Payment_Satisfied__c=false; 
        bills.cllease__Account__c=lessee.ID;
        //insert bills;        
        lstbill.add(bills);
        
        bills      = new cllease__Lease_account_Due_Details__c();
        bills.cllease__Lease_Account__c=leaseAccount.ID; 
        bills.cllease__Due_Date__c=Date.newInstance(2017, 03, 01);
        bills.cllease__Payment_Satisfied__c=false; 
        bills.cllease__Account__c=lessee.ID;
        lstbill.add(bills);
        
        bills      = new cllease__Lease_account_Due_Details__c();
        bills.cllease__Lease_Account__c=leaseAccount.ID; 
        bills.cllease__Due_Date__c=company.cllease__Current_System_Date__c.addMonths(-1);
        bills.cllease__Payment_Satisfied__c=false; 
        bills.cllease__Account__c=lessee1.ID;
        lstbill.add(bills);
        
        insert lstbill;
        
        User objuser = [select Id, username,cllease__Current_Branch_s_System_Date__c from User where Id = :UserInfo.getUserId()];
        Date dt = Date.valueof(objuser.cllease__Current_Branch_s_System_Date__c); 
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<cllease__Lease_account_Due_Details__c> lstbills = new List<cllease__Lease_account_Due_Details__c>();
        
       // UpdateAccountAutoAlerts1 autoAlerts = new UpdateAccountAutoAlerts1();
        UpdateAccountAutoAlerts3 autoAlerts = new UpdateAccountAutoAlerts3();
        autoAlerts.dostart(bc);
        autoAlerts.doInitialize();
        system.debug('List of loan accounts '+lstbill);   
        
        test.startTest();
        try
        {
           // Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
           // Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());
            autoAlerts.getRuntimeQuery();
            autoAlerts.doExecute(BC, lstbill);
            autoAlerts.doFinish(BC);
        }
        catch(Exception e)
        {}
        test.stopTest();
    }
}