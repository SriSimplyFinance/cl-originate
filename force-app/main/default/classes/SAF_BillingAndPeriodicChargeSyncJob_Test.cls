@isTest(SeeallData=True)
Private class SAF_BillingAndPeriodicChargeSyncJob_Test{
    
    static testMethod void testMethod1(){
        
        Date date1 = system.today();
        string AgreementId;
        Test.startTest();
       cllease.TestHelper.createSeedDataForTesting();
         cllease.TestHelper.createOffice('Test Office', true);
         cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
         
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
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet .ID;
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
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        leaseAccount.cllease__Lease_Status__c =  'ACTIVE - GOOD STANDING';
             
         //string strstatus = 'ACTIVE - GOOD STANDING';
         //List<cllease__Lease_Account__c> lstAgreement = [select Id,Name,cllease__Lease_Status__c from cllease__Lease_Account__c where cllease__Lease_Status__c =: strstatus limit 1];
                                   
      
        SAF_BillingAndPeriodicChargeSyncJob.RunBillingDAG(leaseAccount.cllease__Lease_Status__c);
        
          Test.stopTest();
        //SAF_BillingAndPeriodicChargeSyncJob.AsyncExecutionPeriodicJob sf = new SAF_BillingAndPeriodicChargeSyncJob.AsyncExecutionPeriodicJob();    
       // SAF_BillingAndPeriodicChargeSyncJob.generateBillingAndPeriodicJob(AgreementId,'ACTIVE');
       // SAF_BillingAndPeriodicChargeSyncJob.generateBillingAndPeriodicJob(AgreementId,'Test');
      
    }
}