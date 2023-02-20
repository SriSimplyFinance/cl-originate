@isTest
public class TestUpdateRecordsToIncludeFee {

public static cllease__Office_Name__c office;

    @isTest
    static void testFeeValueAfterUpdatingRecords() {
        
    cllease.TestHelper.createSeedDataForTesting();
        //Create a Fee Set
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Amount__c = 100;
        clcommon__Fee_Definition__c  dummyFee2 = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        //clcommon__Fee_Junction__c dummyFeeJunction = cllease.Testhelper.createLeaseFeeJunction(dummyFee, dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee.ID,
                clcommon__Fee_Set__c  = dummyFeeSet.ID);
        if (Schema.sObjectType.clcommon__Fee_Junction__c.isCreateable()) {
            insert(dummyFeeJunction);
        }

        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Tax_Calculation_Source__c = 'Avalara'; 
        dummyOffice.cllease__Tax_Basis__c = 'Sales';
        update dummyOffice;
        system.debug('dummy office:' +dummyOffice);
        //Create a dummy Lease Product
                cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet, 'FINANCE LEASE');
        dummyLP.cllease__Rental_Accrual_Flag__c = true;
        dummyLP.cllease__Product_Sub_Type__c = 'FINANCE LEASE';
        update(dummyLP);

    
         office = [SELECT Id    
                    FROM cllease__Office_Name__c 
                    LIMIT 1];
        Contact dummyClient = cllease.TestHelper.createClient(dummyOffice);
        Account lessee = new Account(Name = 'TestAccount');
        lessee.BillingPostalCode = '123456';
        lessee.BillingCity = 'QueensTown';
        lessee.BillingStreet = '23';
        lessee.Landline__c = '12345 123456';
        insert lessee;

        /**
         * Creating Contract
         */
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Contact__c             = dummyClient.ID;
        leaseaccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = office.ID;
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

         
        leaseAccount.cllease__Accrual_Streams__c = 'Rent';
        insert leaseAccount;
        System.debug('Accrual_Streams__c before updation : '+leaseAccount.cllease__Accrual_Streams__c);
        
        /*
         * Updating contracts to include Fee value in Accrual_Streams__c Multi Picklist value
         */
        
        Test.startTest();
        List<cllease__Lease_Account__c> ls = new List<cllease__Lease_Account__c>();
        ls.add(leaseAccount);
        UpdateRecordsToIncludeFee job = new UpdateRecordsToIncludeFee(null);
    Database.BatchableContext ctx;
        job.start(ctx);
        job.execute(ctx, ls);
        job.finish(ctx);
        System.debug('Accrual_Streams__c after updation : '+leaseAccount.cllease__Accrual_Streams__c);
        System.assertEquals(true, leaseAccount.cllease__Accrual_Streams__c.contains('Fee'), 'Contracts updation failed');
        Test.stopTest();
    }
    
        @isTest
    static void testFeeValueAfterUpdatingRecords2() {
                 
         /**
         * 1. Creating SeedData for testing
         */

        cllease.TestHelper.createSeedDataForTesting();
        
        /**
         * 2. Creating 2 fee and Fee Set part of configuration
         */

        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Amount__c = 100;
        clcommon__Fee_Definition__c  dummyFee2 = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        //clcommon__Fee_Junction__c dummyFeeJunction = cllease.Testhelper.createLeaseFeeJunction(dummyFee, dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee.ID,
                clcommon__Fee_Set__c  = dummyFeeSet.ID);
        if (Schema.sObjectType.clcommon__Fee_Junction__c.isCreateable()) {
            insert(dummyFeeJunction);
        }
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        Contact dummyClient = cllease.TestHelper.createClient(dummyOffice);
        Account dummyAccount = new Account(Name = 'Sample Account');        
        dummyAccount.BillingPostalCode = '123456';
        dummyAccount.BillingCity = 'QueensTown';
        dummyAccount.BillingStreet = '23';
        dummyAccount.Landline__c = '12345 123456';
        insert(dummyAccount);

        /**
         * 3. Creating Sample Product with rental and Dep Streams enabled
         */
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet, 'FINANCE LEASE');
        dummyLP.cllease__Rental_Accrual_Flag__c = true;
        dummyLP.cllease__Product_Sub_Type__c = 'FINANCE LEASE';
        update(dummyLP);

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

         
        leaseAccount.cllease__Accrual_Streams__c = 'Rent';
        insert leaseAccount;
        System.debug('Accrual_Streams__c before updation : '+leaseAccount.cllease__Accrual_Streams__c);
        
        /*
         * Updating contracts to include Fee value in Accrual_Streams__c Multi Picklist value
         */
        Test.startTest();
        List<cllease__Lease_Account__c> ls = new List<cllease__Lease_Account__c>();
        ls.add(null);
        Set<String> contracts = new Set<String> {'xyz'};
        UpdateRecordsToIncludeFee job = new UpdateRecordsToIncludeFee(contracts);
    Database.BatchableContext ctx;
        job.start(ctx);
        job.execute(ctx, ls);
        job.finish(ctx);
        System.debug('Accrual_Streams__c after updation : '+leaseAccount.cllease__Accrual_Streams__c);
        System.assertEquals(false, leaseAccount.cllease__Accrual_Streams__c.contains('Fee'), 'Contracts updation failed');
        Test.stopTest();
    }
}