@isTest
public class TestRestructureJob {
	private static Cllease__Office_Name__c office;
    private static Cllease__Lease_Product__c leaseProduct;
    private static clcommon__Fee_Set__c  feeSet;
    
    @testSetup
    public static void testDataSetUp(){
        cllease__Lease_Account__c contract = createContract();
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];
    }

    public static cllease__Lease_Account__c createContract() {
        
        Saf_setting__c objSetting1 = Saf_setting__c.getOrgDefaults();
        objSetting1.DisableCustomerTriggers__c = true;
        objSetting1.DisableAgreementTriggers__c = true;
        UPSERT objSetting1;
        cllease.TestHelper.createSeedDataForTesting();
        // Setting Current System Date in Test Context
        Date currentSystemDate = Date.newInstance(2018, 03, 31);
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);

        clcommon__Fee_Definition__c  dummyFee2   = cllease.Testhelper.createLeaseFee();
        dummyFee2.clcommon__Type__c              = 'NSF Fees';
        dummyFee2.clcommon__Amount__c            = 25;
        update dummyFee2;

        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee2.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'NSF Fees');

        clcommon__Fee_Definition__c  latefee   = cllease.Testhelper.createLeaseFee();
        latefee.clcommon__Type__c              = 'Late Fees';
        latefee.clcommon__Calculation_Method__c= 'AMOUNT CALCULATED AS % OF RENT DUE';
        latefee.clcommon__Amount__c            = 25;
        update latefee;

        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = latefee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'Late Fees');



        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Current_System_Date__c = currentSystemDate;
        update dummyOffice;

        Account dummyAccount = new Account(Name = 'Sample Account');
        insert dummyAccount;

        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        dummyLP.cllease__Use_Open_Acct_Period__c = true;
        dummyLP.cllease__Streams_to_Accrue__c = 'Income;Residual;Fee;IDC';
        update dummyLP;

        clcommon__Agreement__c dealerProgram =new clcommon__Agreement__c(Name='NewCo');
        insert dealerProgram;

        // 3.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = dummyAccount.ID;
        leaseAccount.cllease__Lease_Product_Name__c = dummyLP.ID;
        leaseAccount.cllease__Contract_Date__c      = currentDate;
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        //leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;

        // 3.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                        cllease__life_in_months__c = 14,
                                        cllease__Status__c = 'LEASED'));
      
        // 3.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 3,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = Date.newInstance(2018, 01, 01),
                           cllease__Total_Payment__c = 1200));
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 2, cllease__Number_Of_Payments__c = 3,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = Date.newInstance(2018, 04, 01),
                           cllease__Total_Payment__c = 1200));
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 3, cllease__Number_Of_Payments__c = 3,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = Date.newInstance(2018, 07, 01),
                           cllease__Total_Payment__c = 1200));
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 4, cllease__Number_Of_Payments__c = 3,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = Date.newInstance(2018, 10, 01),
                           cllease__Total_Payment__c = 1200));

        // 4. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        System.debug(LoggingLevel.ERROR, ' Response from Contract Creation: '+response);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
      
        return builder.getContract();
    }	
    
    @isTest
    public static void testRestructure_Deffered(){
        cllease__Lease_Account__c contract = [SELECT Id, Name,  cllease__Contract_Date__c, cllease__Account__c,cllease__Restructured_Contract__c from Cllease__Lease_Account__c limit 1];
        List<cllease__Rental_Stream__c> incomeStrms = [SELECT Id, Name, cllease__Lease_Income__c 
                                                       FROM cllease__Rental_Stream__c
                                                      WHERE cllease__Contract__c = :contract.Id];
        System.debug('test ' + incomeStrms.size());
        ContractRestructureWrapper contractDetails = new ContractRestructureWrapper(Date.newInstance(2018, 03, 01), 
                                                                                     2, 
                                                                                     null, 
                                                                                     null);
        contractDetails.contractNames = new Set<String>{contract.Name};
        contractDetails.feeIdsToBeUpdated = new List<Id>();
        contractDetails.contractNamePmtAmtMap = new Map<String, String>{contract.Name => '0'};
        Restructure_Staging__c rest = new Restructure_Staging__c();
        rest.Name = contract.Name;
        rest.Restructure_Date__c=  Date.newInstance(2018, 03, 01);
        rest.LS_Contract__c = contract.id;
        insert rest;
        try{
            RestructureJob job = new RestructureJob(1);
            Database.executeBatch(job, 1);
            //Database.executeBatch(job, 1);
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        ErrorLogUtil logUtil = new ErrorLogUtil();
        logUtil.addError(contract.Id, contract.Id, 'error', cllease.SystemDateUtil.getCurrentSystemDate());
        logUtil.commitErrors();
        clcommon__Batch_Process_Log__c clog = new clcommon__Batch_Process_Log__c();
        clog.clcommon__Batch_Job_Id__c = contract.Id;
        clog.clcommon__Summary_Record_Id__c = contract.Id;
        clog.clcommon__Timestamp__c = cllease.SystemDateUtil.getCurrentSystemDate();
        clog.clcommon__Type__c = 'DISTRESS_MANAGEMENT';
        clog.clcommon__Message__c = 'error';
        insert clog;
        List<clcommon__Batch_Process_Log__c> clistlog = new List<clcommon__Batch_Process_Log__c>();
        clistlog.add(clog);
        
        logUtil.addAndCommitErrors(clistlog);
        logUtil.addError(clog);
                ImportDataFromCSVController importData = new ImportDataFromCSVController();
        importData.updateAccuralDates();
    }
    
    @isTest
    public static void testRestructure_FixedAmt(){
        cllease__Lease_Account__c contract = [SELECT Id, Name,  cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        ContractRestructureWrapper contractDetails = new ContractRestructureWrapper(Date.newInstance(2018, 03, 01), 
                                                                                     2, 
                                                                                     null, 
                                                                                     null);
        contractDetails.contractNames = new Set<String>{contract.Name};
        contractDetails.feeIdsToBeUpdated = new List<Id>();
        contractDetails.contractNamePmtAmtMap = new Map<String, String>{contract.Name => '100'};
        Restructure_Staging__c rest = new Restructure_Staging__c();
        rest.Name = contract.Name;
        rest.Restructure_Date__c=  Date.newInstance(2018, 03, 01);
        insert rest;
        Test.startTest();

        
        try{
            RestructureJob job = new RestructureJob(1);
            Database.executeBatch(job,1);
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testRestructure_Per(){
        cllease__Lease_Account__c contract = [SELECT Id, Name,  cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        ContractRestructureWrapper contractDetails = new ContractRestructureWrapper(Date.newInstance(2018, 03, 01), 
                                                                                     2, 
                                                                                     null, 
                                                                                     null);
        contractDetails.contractNames = new Set<String>{contract.Name};
        contractDetails.feeIdsToBeUpdated = new List<Id>();
        contractDetails.contractNamePmtAmtMap = new Map<String, String>{contract.Name => '10%'};
                    Restructure_Staging__c rest = new Restructure_Staging__c();
        rest.Name = contract.Name;
        rest.Restructure_Date__c=  Date.newInstance(2018, 03, 01);
        insert rest;
        try{
            RestructureJob job = new RestructureJob(1);
            Database.executeBatch(job,1);
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
    }
}