@isTest
public class TestStreamsUpdateJob {
    
    @testSetup
    static void setupDataForTest() {
        /**
         * 1. Creating SeedData for testing
         */
        cllease.TestHelper.createSeedDataForTesting();
    }

    
    @isTest
    static void testActivateContract() {
        /**
         * 2. Creating 2 fee and Fee Set part of configuration
         */
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Amount__c = 100;
        clcommon__Fee_Definition__c  dummyFee2 = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.Testhelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        Contact dummyClient = cllease.TestHelper.createClient(dummyOffice);
        Account dummyAccount = new Account(Name = 'Sample Account');
        insert dummyAccount;

        /**
         * 3. Creating Sample Product with rental and Dep Streams enabled
         */
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet, 'FINANCE LEASE');
        dummyLP.cllease__Rental_Accrual_Flag__c = true;
        dummyLP.cllease__Product_Sub_Type__c = 'FINANCE LEASE';
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
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c='MONTHLY',
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                cllease__Payment_Date__c=Date.parse('07/01/2016')));

        /**
         * Calling ContractBuilder for Contract Creation
         */
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        cllease__Lease_Account__c retrievedContract = builder.getContract();
        System.debug(logginglevel.Error,'leaseaccount -'+retrievedContract.Name);
        Database.executeBatch(new StreamsUpdateJob(retrievedContract.Name)); 

    }
    
        @isTest
    static void testActivateContract2() {
        /**
         * 2. Creating 2 fee and Fee Set part of configuration
         */
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Amount__c = 100;
        clcommon__Fee_Definition__c  dummyFee2 = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.Testhelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        Contact dummyClient = cllease.TestHelper.createClient(dummyOffice);
        Account dummyAccount = new Account(Name = 'Sample Account');
        insert dummyAccount;

        /**
         * 3. Creating Sample Product with rental and Dep Streams enabled
         */
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet, 'FINANCE LEASE');
        dummyLP.cllease__Rental_Accrual_Flag__c = true;
        dummyLP.cllease__Product_Sub_Type__c = 'FINANCE LEASE';
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
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c='MONTHLY',
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                cllease__Payment_Date__c=Date.parse('07/01/2016')));

        /**
         * Calling ContractBuilder for Contract Creation
         */
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        cllease__Lease_Account__c retrievedContract = builder.getContract();
        System.debug(logginglevel.Error,'leaseaccount -'+retrievedContract.Name);
        Database.executeBatch(new StreamsUpdateJob()); 

    }
}