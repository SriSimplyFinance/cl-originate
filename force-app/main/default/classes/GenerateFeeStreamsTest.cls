@isTest
public class GenerateFeeStreamsTest {

    @testSetup
    static void setupDataForTest() {
        Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableAgreementTriggers__c= true;    
        UPSERT objSettings1;       
        cllease.TestHelper.createSeedDataForTesting();
    }
    @isTest
    static void testGenerateFeeStreams() {
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Amount__c = 100;
        dummyFee.clcommon__Class__c = 'Income';
        dummyFee.clcommon__Amortization_Period__c = 'CONTRACT TERM';
        dummyFee.clcommon__Amortization_Method__c = 'Income Basis';
        update dummyFee;
        clcommon__Fee_Definition__c  dummyFee2 = cllease.Testhelper.createLeaseFee();
 		dummyFee2.clcommon__Amount__c = 100;
        dummyFee2.clcommon__Class__c = 'Expense';       
        dummyFee2.clcommon__Amortization_Period__c = 'CONTRACT TERM';
        dummyFee2.clcommon__Amortization_Method__c = 'Income Basis';
        update dummyFee2;
        /*clcommon__Fee_Definition__c  dummyFee3 = cllease.Testhelper.createLeaseFee();
        dummyFee3.clcommon__Amount__c = 100;
        dummyFee3.clcommon__Class__c = 'Income';
        update dummyFee3;
        clcommon__Fee_Definition__c  dummyFee4 = cllease.Testhelper.createLeaseFee();
 		dummyFee4.clcommon__Amount__c = 100;
        dummyFee4.clcommon__Class__c = 'Expense';       
        update dummyFee4;*/
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.Testhelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        Contact dummyClient = cllease.TestHelper.createClient(dummyOffice);
        Account dummyAccount = new Account(Name = 'Sample Account');
        insert dummyAccount;


        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet, 'FINANCE LEASE');
        dummyLP.cllease__Rental_Accrual_Flag__c = true;
        dummyLP.cllease__Product_Sub_Type__c = 'FINANCE LEASE';
        //dummyLP.Dep_Stream_Accrual_Flag__c = true;
        update dummyLP;

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

                
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));


        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c='MONTHLY',
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                cllease__Payment_Date__c=Date.parse('07/01/2016')));

        
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        
        cllease__Lease_Account__c retrievedContract = builder.getContract();
        
        cllease__Contract_Fees__c contractFeesIncome = new cllease__Contract_Fees__c();
        contractFeesIncome.cllease__Amount__c = 200;
        contractFeesIncome.cllease__Contract__c = retrievedContract.Id;
        contractFeesIncome.cllease__Fee_Definition__c = dummyFee.Id;
        contractFeesIncome.cllease__start_date__c = Date.parse('07/01/2016');
        contractFeesIncome.cllease__Total_Payment_Amount__c = 2000;
        insert contractFeesIncome;
        cllease__Contract_Fees__c contractFeesExpense = new cllease__Contract_Fees__c();
        contractFeesExpense.cllease__Amount__c = 200;
        contractFeesExpense.cllease__Contract__c = retrievedContract.Id;
        contractFeesExpense.cllease__Fee_Definition__c = dummyFee2.Id;
        contractFeesExpense.cllease__start_date__c = Date.parse('07/01/2016');
        contractFeesExpense.cllease__Total_Payment_Amount__c = 2000;
        insert contractFeesExpense;
        
        /*cllease__Contract_Fees__c contractFeesIncome1 = new cllease__Contract_Fees__c();
        contractFeesIncome1.cllease__Amount__c = 200;
        contractFeesIncome1.cllease__Contract__c = retrievedContract.Id;
        contractFeesIncome1.cllease__Fee_Definition__c = dummyFee3.Id;
        contractFeesIncome1.cllease__start_date__c = Date.parse('07/01/2016');
        contractFeesIncome1.cllease__Total_Payment_Amount__c = 2000;
        insert contractFeesIncome1;
        cllease__Contract_Fees__c contractFeesExpense1 = new cllease__Contract_Fees__c();
        contractFeesExpense1.cllease__Amount__c = 200;
        contractFeesExpense1.cllease__Contract__c = retrievedContract.Id;
        contractFeesExpense1.cllease__Fee_Definition__c = dummyFee4.Id;
        contractFeesExpense1.cllease__start_date__c = Date.parse('07/01/2016');
        contractFeesExpense1.cllease__Total_Payment_Amount__c = 2000;
        insert contractFeesExpense1;*/
        
        cllease__Rental_Stream__c rentalStream = new cllease__Rental_Stream__c();
        rentalStream.cllease__Contract__c = retrievedContract.Id;
        rentalStream.cllease__Date__c = contractFeesExpense.cllease__start_date__c;
        rentalStream.cllease__Lease_Income__c = 1000;
        insert rentalStream;
       

        System.debug(logginglevel.Error,'leaseaccount -'+retrievedContract.Id);
        System.debug(logginglevel.Error,'leaseaccount -'+retrievedContract.cllease__Lease_Status__c);
        
        //Database.executeBatch(new GenerateFeeStreamsFromContractStartDtJob(retrievedContract.Id));
        //Database.executeBatch(new GenerateFeeStreamsFromContractStartDtJob());
        Database.executeBatch(new GenerateFeeStreamsJob(retrievedContract.Id));
        Database.executeBatch(new GenerateFeeStreamsJob());
    }
}