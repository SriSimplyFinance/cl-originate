@isTest
public with sharing class TestSubsidyUpdate {
    
     @isTest
    static void testSubsidy1() {
        
         /**
         * 1. Creating SeedData for testing
         */

        cllease.TestHelper.createSeedDataForTesting();
        
        /**
         * 2. Creating 2 fee and Fee Set part of configuration
         */

       
        clcommon__Fee_Definition__c  dummyFee = cllease.TestHelper.createLeaseFee();
        dummyFee.clcommon__Amount__c = 100;
        clcommon__Fee_Definition__c  dummyFee2 = cllease.TestHelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.ID, dummyFeeSet.ID);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        Contact dummyClient = cllease.TestHelper.createClient(dummyOffice);
        Account dummyAccount = new Account(Name = 'Sample Account');
        dummyAccount.BillingPostalCode = '123456';
        dummyAccount.BillingCity = 'QueensTown';
        dummyAccount.BillingStreet = '23';
        dummyAccount.Landline__c = '12345 123456';
        insert dummyAccount; 
        
        

        /**
         * 3. Creating Sample Product with rental and Dep Streams enabled
         */
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet, cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE);
        dummyLP.cllease__Rental_Accrual_Flag__c = true;
        dummyLP.cllease__Product_Sub_Type__c = 'FINANCE LEASE';
        // dummyLP.cllease__Streams_to_Accrue__c = 'Fee; IDC; Income; Residual; Subsidy;'; //changes
        //dummyLP.Dep_Stream_Accrual_Flag__c = true;
        update dummyLP;

        /**
         * Creating Contract
         */
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Contact__c             = dummyClient.ID;
        leaseaccount.cllease__Account__c             = dummyAccount.ID;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.parse('07/01/2016');
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.parse('07/01/2016');
        leaseAccount.cllease__Product_Sub_Type__c    = 'FINANCE LEASE';
        leaseAccount.cllease__Amort_Start_Date__c    = Date.parse('07/01/2016');
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Days_Convention__c     = '30/360';
        leaseAccount.cllease__Financed_Amount__c     = 30000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(Net_Asset_Cost__c = 10000 ,cllease__Equipment_Description__c = 'Test'));
        contractEquipments.add(new cllease__Contract_Equipment__C(Net_Asset_Cost__c = 20000 ,cllease__Equipment_Description__c = 'Test1'));
        contractEquipments.add(new cllease__Contract_Equipment__C(Net_Asset_Cost__c = 20000 ,cllease__Equipment_Description__c = 'Test2'));

        /**
         * Creating Payment Schedule
         */
        
       // Contract_Subsidy__c csc = new Contract_Subsidy__c();
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c=cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=5000,
                                                cllease__Payment_Date__c=Date.parse('07/01/2016')));

        /**
         * Calling ContractBuilder for Contract Creation
         */
        System.debug(Logginglevel.ERROR, '------------------ in test LeaseAccount: '+leaseaccount);
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        System.debug(Logginglevel.ERROR, 'builder: '+builder);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        System.debug(Logginglevel.ERROR, 'builder2: '+builder); 
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        System.debug(Logginglevel.ERROR, '------------------ in test response: '+response);
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        /**
         * Checking Contract Activation
         */
        cllease__Lease_Account__c retrievedContract = builder.getContract();
        System.assert(retrievedContract.cllease__Lease_Status__c == cllease.LendingConstants.STATUS_ACTIVE_GOOD_STANDING);

        set<String> contractName = new set<string>();
        contractName.add(retrievedContract.Name);
        
        cllease__Subsidy__c sub = new cllease__Subsidy__c();
        
        sub.cllease__Contract__c = leaseAccount.Id;
        sub.cllease__Amount__c = 200;
       
        for(cllease__Contract_Equipment__C eqp : contractEquipments){
            sub.cllease__Equipment__c = eqp.Id;
        }
        upsert sub;
        
        SubsidyUpdateBatch subUpd = new SubsidyUpdateBatch(contractName);
        
        Database.executeBatch(subUpd);
    }       
}