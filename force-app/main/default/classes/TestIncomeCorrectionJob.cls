@isTest
public class TestIncomeCorrectionJob {
    @testSetup
    static void setupDataForTest() {
        cllease.TestHelper.systemDate = Date.parse('01/01/2021');
        Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableAgreementTriggers__c= true;  
        UPSERT objSettings1;
        cllease.TestHelper.createSeedDataForTesting();
    }
    
    @isTest
    static void testIncomStreamsCorrection() {
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.Testhelper.createFeeJunction(dummyFee.Id, dummyFeeSet.Id);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        Contact dummyClient = cllease.TestHelper.createClient(dummyOffice);
        Account dummyAccount = new Account(Name = 'Sample Account');
        insert dummyAccount;
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet, 'FINANCE LEASE');
        dummyLP.cllease__Streams_to_Accrue__c = 'Income; Residual; IDC; Tax; Subsidy;';
        dummyLP.cllease__Product_Sub_Type__c = 'FINANCE LEASE';
        dummyLP.cllease__Calculation_Method__c = 'IRR';
        update dummyLP;

        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Contact__c             = dummyClient.ID;
        leaseaccount.cllease__Account__c             = dummyAccount.ID;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.parse('01/01/2021');
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.parse('01/01/2021');
        leaseAccount.cllease__Product_Sub_Type__c    = 'FINANCE LEASE';
        leaseAccount.cllease__Amort_Start_Date__c    = Date.parse('01/01/2021');
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Days_Convention__c     = '30/360';
        leaseAccount.cllease__Financed_Amount__c     = 30000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Calculation_Method__c  = 'IRR';
        leaseAccount.cllease__Accrual_Streams__c = 'Income; Residual; IDC; Tax; Subsidy;';
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';

                
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));


        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c='MONTHLY',
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                cllease__Payment_Date__c=Date.parse('01/01/2021')));

        
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
            
        cllease__Lease_Account__c retrievedContract = builder.getContract();
        System.debug(loggingLevel.error,'Status ' + retrievedContract.cllease__Lease_Status__c);
                System.debug(loggingLevel.error,'test ps ' + retrievedContract.cllease__Product_Sub_Type__c);
                System.debug(loggingLevel.error,'test cm ' + retrievedContract.cllease__Calculation_Method__c);

        List<cllease__Payment_Stream__c> pmntstr = [SELECT Id, Name FROM cllease__Payment_Stream__c 
                                                   WHERE cllease__Contract__c = :retrievedContract.Id];
        System.debug(loggingLevel.error, pmntstr.size());
        System.assertEquals(12, pmntstr.size());
        
        List<cllease__Rental_Stream__c> incomeStrms = [SELECT Id, Name, cllease__Lease_Income__c 
                                                       FROM cllease__Rental_Stream__c
                                                      WHERE cllease__Contract__c = :retrievedContract.Id];
        System.debug(loggingLevel.error, incomeStrms.size());
        System.assertEquals(12, incomeStrms.size());
        
        Test.startTest();
        incomeStrms[11].cllease__Lease_Income__c -= 20;
        update incomeStrms[11];
        Database.executeBatch(new IncomeCorrectionJob());
        Test.stopTest();
    }    
}