@isTest(SeeAllData=True)
private class XirrCalcUtils2_Test {

 static testMethod void Test1(){
 cllease.TestHelper.createSeedDataForTesting();
 saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());
 //Test.startTest();
   
       
        //Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.Name = 'TestAccount-phalguni';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
         lessee.ShippingPostalCode = 'BD1 1HA';
        lessee.ShippingCity = 'London';
        insert lessee;
         System.debug(LoggingLevel.ERROR, '*** lessee : ' + lessee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        //cllease.TestHelper.createOffice('Test Office', true);
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
        List<cllease__Lease_Account__c> clist = new List<cllease__Lease_Account__c>();
    
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 1000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';

 
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Contract__c= leaseAccount.Id,cllease__Equipment_Type__c =  'Agricultural Attachments (medium/large -identifiable)' ,cllease__Estimated_Selling_Price__c = 120, cllease__Life_In_Months__c=18,cllease__Equipment_Description__c ='OK',Net_Asset_Cost__c =120));
           System.debug(LoggingLevel.ERROR, '*** contractEquipments : ' + contractEquipments);
          /**
         * Creating Parties
         */
        List<cllease__Contract_Parties__c> contractParty = new List<cllease__Contract_Parties__c>();
        contractParty.add(new cllease__Contract_Parties__c( cllease__Party_Account_Name__c =  lessee.ID, cllease__Party_Type__c = 'DEALER', cllease__Contract__c =leaseAccount.Id));
          System.debug(LoggingLevel.ERROR, '*** contractParty : ' + contractParty);
 
        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=5,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=15000,
                                                cllease__Contract__c = leaseAccount.Id,
                                                cllease__Payment_Date__c=Date.newInstance(2018, 01, 01)));
           System.debug(LoggingLevel.ERROR, '*** paymentDetails : ' + paymentDetails );
           /**
         * Creating Fee 
         */
        List<cllease__Contract_Fees__c> feeDetails =  new List<cllease__Contract_Fees__c>();
        feeDetails.add(new cllease__Contract_Fees__c(cllease__Number_of_Periods__c=1,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Amount__c=300,cllease__Fee_Definition__c=dummyFee.ID,
                                                cllease__Contract__c = leaseAccount.Id,
                                                cllease__start_date__c=Date.newInstance(2018, 01, 01)));
           System.debug(LoggingLevel.ERROR, '*** feeDetails : ' + feeDetails );
        /**
         * Calling ContractBuilder for Contract Creation
         */
        
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(contractParty);
        builder.addChildObjects(paymentDetails);
       
     
/*String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
System.debug(Logginglevel.ERROR, '------------------ in test response: '+response);*/
//System.assert(response.containsIgnoreCase('Contract Creation Successful'));

        String response = builder.createContract(null);
        System.debug(LoggingLevel.ERROR, '*** response: ' + response);
        
        response = cllease.RegenerateStreamsCtrl.regenerateStreams(leaseAccount.Id);//,string.valueof(leaseAccount.cllease__Financed_Amount__c)
        
cllease__Payment_Stream__c streams = new cllease__Payment_Stream__c();
streams.cllease__Active__c = true;
streams.cllease__Contract__c = leaseAccount.Id;
streams.cllease__Date__c = Date.parse('03/05/2018');
streams.cllease__Payment_Type__c = 'RENT';
streams.cllease__Ending_Receivable__c = 12000.00;
streams.cllease__Beginning_Receivable__c = 15000.00;
streams.cllease__Rental_Amount__c = 3000.00;
//streams.cllease__Transaction_Sub_Type__c = 'a6z9E0000004EyL'; // 'PERIODIC RENT';
streams.cllease__Frequency__c = 'MONTHLY' ;
insert streams;
        System.debug(LoggingLevel.ERROR, '*** response streams: ' + response);
       // leaseAccount.cllease__Lease_Status__c = 'ACTIVE - GOOD STANDING';
       
        update leaseAccount;
        
         List<cllease__Payment_Stream__c> paymentstream =  [select Id,Name from cllease__Payment_Stream__c where cllease__Contract__c=:leaseAccount.Id];
           System.debug(LoggingLevel.ERROR, '*** paymentstream : ' + paymentstream.Size());
        //string response1 = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
         System.debug(LoggingLevel.ERROR, '*** Equipment: '+ [select count() from cllease__Contract_Equipment__c where cllease__Contract__c =: leaseAccount.Id]);
          System.debug(LoggingLevel.ERROR, '*** Party: '+ [select count() from cllease__Contract_Parties__c where cllease__Contract__c =: leaseAccount.Id]);
         
       // cllease.ActivateContractCtrl.activateContract(leaseAccount.id);
        system.debug('Contract ----'+leaseAccount.id);
        system.debug('Contract status----'+leaseAccount.cllease__lease_status__c);
        XirrCalcUtils2.xirrCalculation_1to5(leaseAccount.Id);
       
       
   //  Test.stopTest();
}
}