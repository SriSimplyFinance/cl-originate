@isTest(SeeAllData = True)

Public class SAF_HelperTest{
  Public static testMethod void Helper1() {      
       
        Test.startTest();
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;
         Saf_setting__c objSetting1 = Saf_setting__c.getOrgDefaults();
        objSetting1.GlSolution_QueryLimit__c = 2000; 
        objSetting1.GlSolution_PageSize__c = 10;
        objSetting1.DisableCustomerTriggers__c = true;
        objSetting1.DisableAgreementTriggers__c = true;
        UPSERT objSetting1;
        
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());       
        //Create a Fee Set
        //clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        //System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.AccountNumber='6549821699';
        lessee.Name = 'TestAccountBBB';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        
        Account lessee1 = new Account();
        lessee1.RecordtypeID=rec.id;
        lessee1.AccountNumber='111111';
        lessee1.Name = 'HMAccountTESTBBB12';
        lessee1.Phone = '98734 678988';
        lessee1.Landline__c= '98734 678988';
        lessee1.BillingPostalCode = 'DC1 1HA1';
        lessee1.BillingCity = 'London';
        lessee1.ShippingPostalCode = 'DC1 1HA1'; 
        lessee1.ShippingCity = 'London';
        insert lessee1;
        
    
        
      /*  cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1]; */
          List<String> names = new List<String> {'Finance Lease'}; 
       // List<String> names = new List<String> {'Hire Purchase'};
       
      /* cllease__Office_Name__c off1 = new cllease__Office_Name__c ();
       off1.Name = 'Simply Asset';
       off1.cllease__Office_Short_Name__c = 'HQ';
       off1.cllease__Tax_Method__c = 'Exclusive';
       INSERT off1; */
       
       cllease__Office_Name__c off1 = [select Name, id from cllease__Office_Name__c limit 1];
       
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = ' Operating Lease ';
        //pr1.RecordTypeId = 'LEASE';
        INSERT pr1;
            
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];
        //cllease.TestHelper.createSeedDataForTesting();
       // cllease.TestHelper.createVATRateSetup();
        // Create a Fee Set
        
        clcommon__Fee_Definition__c dummyFee = [select id,name from clcommon__Fee_Definition__c limit 1]; 
        
       // clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        
        clcommon__Fee_Set__c dummyFeeSet = [select id,name from clcommon__Fee_Set__c limit 1];
       
       // clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        
        clcommon__Fee_Junction__c dummyFeeJunction = [select id, name from clcommon__Fee_Junction__c limit 1];
        
        //clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        // cllease.TestHelper.createOffice('Test Office', true);
        //cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        //Create a dummy Lease Product
        
        cllease__Lease_Product__c dummyLP  = [select id, name, cllease__Payment_Spread__c  from cllease__Lease_Product__c where cllease__Status__c='Active' limit 1];
        
       //cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(off1, dummyFeeSet);
       
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;              
        UPDATE dummyLP;
        
        //Create Application
        /*genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 12000;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = date.newInstance(2019, 12, 12);
        genApp.genesis__Account__c = acc.Id;    
        INSERT genApp;
     
        Underwriting__c under = new Underwriting__c();
        under.genesis_Application__c = genApp.Id;
        under.genesis_Decision__c = 'ACCEPTED';
        under.genesis_Trade_value__c = 200;
        under.Asset_quality__c = 'B';
        under.genesis_Customer_quality__c = 'c';
        under.UREL__c = 780;
        INSERT under;*/
        
        cllease__Payment_Mode__c paymentmode =new Cllease__payment_Mode__c();
        paymentmode.Name='Check';
        INSERT  paymentmode;
        
        
            
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee1.ID;
        //leaseAccount.Application__c                  = genApp.Id;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = off1.ID;    //pr1.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2019, 02, 01);
        leaseAccount.cllease__Term__c                = 12.0;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2019, 03, 01);
        leaseAccount.cllease__Product_Sub_Type__c    = 'FINANCE LEASE';
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2019, 02, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 1100.0;
        leaseAccount.cllease__Due_Day__c             = 1.0;
        leaseAccount.cllease__Lease_Status__c= 'ACTIVE - BAD STANDING';
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.Rental_Payment_Method__c=paymentmode.Id;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        INSERT leaseAccount;
      
      
          
        Test.stopTest();        
    }
    
 }