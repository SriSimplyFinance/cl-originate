@isTest
public with sharing class TestDataCorrectionJobs{
    public static cllease__Office_Name__c office;
    public static Map<String, Boolean> financeLeaseMap;
    public static cllease__Lease_Product__c leaseProd;
    public static clcommon__Fee_Set__c  feeSet;
    public static cllease__Payment_Spread__c pmtSpread;
    public static Account lessee;
    
    @testSetup
    public static void createTestSetupData() {
        cllease.TestHelper.createSeedDataForTesting();
        Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableAgreementTriggers__c= true;  
        UPSERT objSettings1;
        Date systemDate = Date.parse('1/1/2020');
        cllease.TestHelper.systemDate = systemDate;
        office = cllease.TestHelper.createOffice();
        System.debug(LoggingLevel.ERROR, 'office : ' + office);
        cllease.TestHelper.createSubTypes();
        office.cllease__Current_System_Date__c = Date.parse('1/1/2020');
        update office;
        pmtSpread = createSpread();
        feeSet = feeSetSetUp();
        financeLeaseMap = cllease.TestHelper1.getFinanceLeaseMap();
        leaseProd = createProd('finacneIRR', cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE, office,
                                   feeSet, pmtSpread, 'IRR',
                                   financeLeaseMap);
    }
    
    public static cllease__Lease_Product__c createProd(string prodName, string prodType, cllease__Office_Name__c officeName, 
                                                            clcommon__Fee_Set__c  feeSetName, cllease__Payment_Spread__c pmtSpread,
                                                            String calculationMethod, Map<string, Boolean> accrualFlag) {
        //Creating a dummy Lease Product
        cllease__Lease_Product__c leaseProd = cllease.TestHelper.createLeaseProduct(prodName,officeName, feeSetName);
        leaseProd.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseProd.cllease__Product_Sub_Type__c = prodType;
        leaseProd.cllease__Calculation_Method__c = calculationMethod;
        leaseProd.cllease__Depreciation_Stream_Basis__c = 'Equipment Cost';
        leaseProd.cllease__Payment_Spread__c = pmtSpread.ID;
        leaseProd.cllease__Streams_to_Accrue__c = '';
        
            
        //Operating Lease
        if(accrualFlag.get('Rent')){
            leaseProd.cllease__Streams_to_Accrue__c += 'Rent;';
        }
        if(accrualFlag.get('Dep')){
            leaseProd.cllease__Streams_to_Accrue__c += 'Depreciation;';
        }
        leaseProd.cllease__Dep_over_asset_life__c = accrualFlag.get('DepOverAsset');
        //Finance Lease
        if(accrualFlag.get('Residual')){
            leaseProd.cllease__Streams_to_Accrue__c += 'Residual;';
        }
        if(accrualFlag.get('Income')){
            leaseProd.cllease__Streams_to_Accrue__c += 'Income;';
        }
        //Common for both the product
        if(accrualFlag.get('IDC')){
            leaseProd.cllease__Streams_to_Accrue__c += 'IDC;';
        }
        if(accrualFlag.get('Subsidy')){
            leaseProd.cllease__Streams_to_Accrue__c += 'Subsidy;';
        }
        update leaseProd;
        cllease__Lease_Product__c test = [Select ID, cllease__Lease_Product_Type__c, cllease__Product_Sub_Type__c from cllease__Lease_Product__c where Name =:prodName];
        return leaseProd;
    }
    
    public static clcommon__Fee_Set__c  feeSetSetUp() {
        List<clcommon__Fee_Definition__c> fees = new List<clcommon__Fee_Definition__c>();
        Map<ID, clcommon__Fee_Definition__c> feeTypes = new Map<ID, clcommon__Fee_Definition__c>();

        clcommon__Fee_Definition__c AmortIncomeContTerm = new  clcommon__Fee_Definition__c(Name = 'Amort Contract Term',
                clcommon__Active__c = true,
                clcommon__Calculation_Method__c = 'FIXED',
                clcommon__Amount__c = 7.00,
                clcommon__Amortization_Method__c = 'STRAIGHT LINE',
                clcommon__Amortization_Period__c = 'CONTRACT TERM',
                clcommon__Class__c = 'Income',
                clcommon__Type__c = 'OTHER FEES',
                clcommon__Maximum_Amount__c = 1000.0,
                clcommon__Minimum_Amount__c = 0.0);
        fees.add(AmortIncomeContTerm);
        insert fees;
        // Creating new feeset
        clcommon__Fee_Set__c  feeSet = new clcommon__Fee_Set__c (Name = 'RestructureFees');
        insert feeSet;
        // Inserting fee in to feeSet
        List<clcommon__Fee_Junction__c> junctionList = new List<clcommon__Fee_Junction__c>();
        for (clcommon__Fee_Definition__c fee : fees) {
            junctionList.add(new  clcommon__Fee_Junction__c(clcommon__Fee__c = fee.ID, clcommon__Fee_Set__c  = feeSet.ID));
        }
        insert junctionList;
        return feeSet;
    }
    
    public static cllease__Payment_Spread__c createSpread() {
        cllease__Payment_Spread__c pmtSpread = new cllease__Payment_Spread__c(cllease__Enabled__c = true,
                                                                                cllease__Spread_Description__c = 'Default Spread',
                                                                                cllease__Tax_Configuration__c = 'TAX FIRST');
        insert pmtSpread;
        List<cllease__Spread_Detail__c> spreadList = new List<cllease__Spread_Detail__c>();
        spreadList.add(new cllease__Spread_Detail__c(cllease__Sort__c = 1,
                                            cllease__Balance_Type__c = 'TAX',
                                            cllease__Enabled__c = true,
                                            cllease__Payment_Spread__c = pmtSpread.Id));
        spreadList.add(new cllease__Spread_Detail__c(cllease__Sort__c = 2,
                                            cllease__Balance_Type__c = 'LEASE RECEIVABLE',
                                            cllease__Enabled__c = true,
                                            cllease__Payment_Spread__c = pmtSpread.Id));
        spreadList.add(new cllease__Spread_Detail__c(cllease__Sort__c = 3,
                                            cllease__Balance_Type__c = 'FEES',
                                            cllease__Enabled__c = true,
                                            cllease__Payment_Spread__c = pmtSpread.Id));
        insert spreadList;
        return pmtSpread;
    }
    
    public static void fetchData(String prodName) {
        leaseProd = [Select ID, 
                        cllease__Lease_Product_Type__c, 
                        cllease__Product_Sub_Type__c, 
                        cllease__Payment_Method__c, 
                        cllease__Calculate_Maturity_From__c 
                        from cllease__Lease_Product__c 
                        where Name = :prodName];
        lessee = new Account(Name = 'lessee');
        insert lessee;
        System.debug(LoggingLevel.ERROR, 'lessee : ' + lessee);
        office = [Select ID, Name, cllease__Tax_Basis__c, cllease__Tax_Method__c from cllease__Office_Name__c where Name = 'Cloud Lending Inc'];
        System.debug(LoggingLevel.ERROR, 'office 1 : ' + lessee);
    }
    
    static testMethod void createContractWithBadStreams() {
        fetchData('finacneIRR');
        office.cllease__Currency_Precision__c = 2;
        update office;
        
        
        
        
        // 1.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = lessee.Id;
        leaseAccount.cllease__Lease_Product_Name__c = leaseProd.Id;
        leaseAccount.cllease__Contract_Date__c      = Date.parse('1/1/2020');
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;

        // 1.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                        cllease__Status__c = 'LEASED'));
      
        // 1.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = Date.parse('1/1/2020'),
                           cllease__Total_Payment__c = 1200));

        // 2. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        leaseAccount = builder.getContract();
        
        List<cllease__Rental_Stream__c> incomeStream = [Select Id, 
                                                            cllease__Monthly_Income__c, 
                                                            cllease__Lease_Income__c 
                                                            From cllease__Rental_Stream__c
                                                            Where cllease__Contract__c = :leaseAccount.Id];
        
        // Manuplate wrong income values
        incomeStream[5].cllease__Lease_Income__c = -1000.00;
        update incomeStream;
        
        //Run Job
        Test.StartTest();
            ContractWithFaultyData job = new ContractWithFaultyData();
            Database.executeBatch(job);
        Test.StopTest();
        cllease__Lease_Account__c acc = [Select Id, faulty_Data_Contract__c from cllease__Lease_Account__c Where Id = :leaseAccount.Id];
        System.assertEquals(true, acc.faulty_Data_Contract__c);
    }
    
    static testMethod void fixContractWithBadStreams_Arr() {
        fetchData('finacneIRR');
        office.cllease__Currency_Precision__c = 2;
        update office;
        
        // 1.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = lessee.Id;
        leaseAccount.cllease__Lease_Product_Name__c = leaseProd.Id;
        leaseAccount.cllease__Contract_Date__c      = Date.parse('1/1/2020');
        leaseAccount.cllease__First_Payment_Date__c = Date.newInstance(2020, 01, 31);
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;
        leaseAccount.cllease__Payment_Method__c     = 'ARREARS';

        // 1.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                        cllease__Status__c = 'LEASED'));
      
        // 1.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = leaseAccount.cllease__First_Payment_Date__c,
                           cllease__Total_Payment__c = 1200));

        // 2. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        leaseAccount = builder.getContract();
        leaseAccount.Expected_Monthly_Income__c = true;
        leaseAccount.faulty_Data_Contract__c = true;
        update leaseAccount;
        
        List<cllease__Rental_Stream__c> incomeStream = [Select Id, 
                                                            cllease__Monthly_Income__c, 
                                                            cllease__Lease_Income__c 
                                                            From cllease__Rental_Stream__c
                                                            Where cllease__Contract__c = :leaseAccount.Id];
        
        // Manuplate wrong income values
        incomeStream[5].cllease__Lease_Income__c = -1000.00;
        update incomeStream;
        
        //Run Job
        Test.StartTest();
            DataCorrectionJob job = new DataCorrectionJob();
            Database.executeBatch(job);
        Test.StopTest();
        
        incomeStream = [Select Id, 
                            cllease__Monthly_Income__c, 
                            cllease__Lease_Income__c 
                            From cllease__Rental_Stream__c
                            Where cllease__Contract__c = :leaseAccount.Id];
        System.debug(LoggingLevel.ERROR, 'Income : ' + incomeStream[5].cllease__Lease_Income__c);
        System.assertNotEquals(-1000.00, incomeStream[5].cllease__Lease_Income__c);
    }
    
    static testMethod void fixContractWithBadStreams_Adv() {
        fetchData('finacneIRR');
        office.cllease__Currency_Precision__c = 2;
        update office;
        
        // 1.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = lessee.Id;
        leaseAccount.cllease__Lease_Product_Name__c = leaseProd.Id;
        leaseAccount.cllease__Contract_Date__c      = Date.parse('1/1/2020');
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;

        // 1.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                        cllease__Status__c = 'LEASED'));
      
        // 1.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = Date.parse('1/1/2020'),
                           cllease__Total_Payment__c = 1200));

        // 2. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        leaseAccount = builder.getContract();
        leaseAccount.Expected_Monthly_Income__c = true;
        leaseAccount.faulty_Data_Contract__c = true;
        update leaseAccount;
        
        List<cllease__Rental_Stream__c> incomeStream = [Select Id, 
                                                            cllease__Monthly_Income__c, 
                                                            cllease__Lease_Income__c 
                                                            From cllease__Rental_Stream__c
                                                            Where cllease__Contract__c = :leaseAccount.Id];
        
        // Manuplate wrong income values
        incomeStream[5].cllease__Lease_Income__c = -1000.00;
        update incomeStream;
        
        //Run Job
        Test.StartTest();
            DataCorrectionJob job = new DataCorrectionJob();
            Database.executeBatch(job);
        Test.StopTest();
        
        incomeStream = [Select Id, 
                            cllease__Monthly_Income__c, 
                            cllease__Lease_Income__c 
                            From cllease__Rental_Stream__c
                            Where cllease__Contract__c = :leaseAccount.Id];
        System.debug(LoggingLevel.ERROR, 'Income : ' + incomeStream[5].cllease__Lease_Income__c);
        System.assertNotEquals(-1000.00, incomeStream[5].cllease__Lease_Income__c);
    }
}