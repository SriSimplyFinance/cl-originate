@isTest  
   global class SAF_Restructurefn_Test
{

    public static testMethod void getContract()
   { 
       clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        INSERT legal;
        
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.zoho_AccessEndpoint__c='dummy url';
        objSettings.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        INSERT acc;
        
        List<String> names = new List<String> {'Finance Lease'};
        //List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = 'Finance Lease';
        //pr1.RecordTypeId = 'LEASE';
        INSERT pr1;
            
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];
        cllease.TestHelper.createSeedDataForTesting();
        // Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        
        cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        
         //cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office1', true);
        //cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;
              
        UPDATE dummyLP;
        //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 1200;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
        genApp.genesis__Account__c = acc.Id;
        //genApp.Security_Deposit__c = 100;
        INSERT genApp;
        //Create UnderWritting
        Underwriting__c under = new Underwriting__c();
        under.genesis_Application__c = genApp.Id;
        under.genesis_Decision__c = 'ACCEPTED';
        under.genesis_Trade_value__c = 200;
        under.Asset_quality__c = 'B';
        under.genesis_Customer_quality__c = 'c';
        under.UREL__c = 780;
        under.Rate_Card__c = 'A';
        INSERT under;
        
        cllease__Payment_Mode__c paymentmode =new Cllease__payment_Mode__c();
        paymentmode.Name='Check';
        INSERT  paymentmode;
            
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = acc.ID;
        leaseAccount.Application__c                  = genApp.Id;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2017, 02, 01);
        leaseAccount.cllease__Term__c                = 12.0;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2017, 03, 01);
        leaseAccount.cllease__Product_Sub_Type__c    = 'FINANCE LEASE';
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2017, 02, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 1100.0;
        leaseAccount.cllease__Due_Day__c             = 1.0;
        leaseAccount.cllease__Lease_Status__c= 'ACTIVE - BAD STANDING';
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.Rental_Payment_Method__c=paymentmode.Id;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        leaseAccount.cllease__Active_flag__c = true;
        INSERT leaseAccount;  
       
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 5000,
                                                                    cllease__Status__c = 'LEASED',
                                                                    cllease__Life_In_Months__c=18,cllease__Contract__c=leaseAccount.id));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 5000, 
                                                                    cllease__Status__c = 'LEASED',
                                                                    cllease__Life_In_Months__c=18,cllease__Contract__c=leaseAccount.id));
        

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=1000,cllease__Total_Payment__c=1000,
                                                cllease__Payment_Date__c=Date.today().addMonths(-5),cllease__Contract__c=leaseAccount.id));

     List<cllease__Lease_Account__c> contractList = new List<cllease__Lease_Account__c>();
                     cllease__Rental_Accrual_Stream1__c rS = new cllease__Rental_Accrual_Stream1__c();
                     rS.cllease__Contract__c = leaseAccount.id;
                     insert rS;
                     
     cllease__Rental_Stream__c iS = new cllease__Rental_Stream__c();
        iS.cllease__Contract__c = leaseAccount.id;
        iS.cllease__Monthly_Income__c = 200.00;
        insert iS;
        
        iS.cllease__Monthly_Income__c = 400.00;
        update iS;
        
        List<cllease__Rental_Stream__c> iStream = new List<cllease__Rental_Stream__c>();
        iStream = [SELECT id,cllease__Contract__c from cllease__Rental_Stream__c where cllease__Contract__c = :leaseAccount.id];
        ID contractId = iStream.get(0).cllease__Contract__c;
         cllease__Lease_Account__c contractDetails = [Select id, 
                                                 Rst_Total_Income__c, 
                                                 Rst_Total_Residual_Income__c, 
                                                 Rst_Total_Receivable__c, 
                                                 cllease__Active_flag__c,
                                                 cllease__Residual_Amount__c,
                                                 Rst_Residual__c
                                                 from cllease__Lease_Account__c 
                                                 where id = :contractId];
        contractDetails.Rst_Residual__c = contractDetails.cllease__Residual_Amount__c;
        delete iStream;
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new Test_SAFDocumentUploadToSharePoint.SharePointmock ());
         Test.stopTest();
     /*   cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        cllease__Lease_Account__c leaseAccount1 = [SELECT Id,cllease__Account__c
                                                    FROM cllease__Lease_Account__c
                                                    LIMIT 1];
        return leaseAccount1; */
        
       }
    /*   @isTest
    public static void test1(){        
    
        cllease__Lease_Account__c contract = getContract();

        Test.startTest();    
            /*ResidualBurndown rb = new ResidualBurndown();
            database.executebatch(rb);*/
             /*List<cllease__Lease_Account__c> contractList = new List<cllease__Lease_Account__c>();
                     cllease__Rental_Accrual_Stream1__c rS = new cllease__Rental_Accrual_Stream1__c();
                     rS.cllease__Contract__c = contract.id;
                     insert rS;*/
             /*cllease.RegenerateStreamsCtrl.FinregenerateStreams(contract.id,'10000');
             contract.cllease__Lease_Status__c = 'Approved';
             contractList.add(contract);
             update contractList;*/
       /* Test.stopTest();
    }
    
    @isTest
    public static void test2(){
        cllease__Lease_Account__c contract = getContract();
        Test.startTest();
        cllease__Rental_Stream__c iS = new cllease__Rental_Stream__c();
        iS.cllease__Contract__c = contract.id;
        insert iS;
        
        List<cllease__Rental_Stream__c> iStream = new List<cllease__Rental_Stream__c>();
        iStream = [SELECT id,cllease__Contract__c from cllease__Rental_Stream__c where cllease__Contract__c = :contract.id];
        ID contractId = iStream.get(0).cllease__Contract__c;
         cllease__Lease_Account__c contractDetails = [Select id, 
                                                 Rst_Total_Income__c, 
                                                 Rst_Total_Residual_Income__c, 
                                                 Rst_Total_Receivable__c, 
                                                 cllease__Active_flag__c,
                                                 cllease__Residual_Amount__c,
                                                 Rst_Residual__c
                                                 from cllease__Lease_Account__c 
                                                 where id = :contractId];
        contractDetails.Rst_Residual__c = contractDetails.cllease__Residual_Amount__c;
        delete iStream;
        Test.stopTest();
    } */
     }