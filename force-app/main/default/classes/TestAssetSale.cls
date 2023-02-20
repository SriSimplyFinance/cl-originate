@isTest
public class TestAssetSale {

    public static cllease__Office_Name__c office;
    public static cllease__Lease_Product__c leaseProduct;
    public static cllease__Fee_Set__c feeSet;
    
        @isTest
        public static cllease__Lease_Account__c getContract() {
        
        cllease.TestHelper.systemDate = Date.today().addMonths(-5);
        
        cllease.TestHelper.createSeedDataForTesting();
        //Create a Fee Set
        cllease__Fee__c dummyFee = cllease.TestHelper.createFee();

        cllease__Fee_Set__c dummyFeeSet = cllease.TestHelper.createFeeSet();
        cllease__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee, dummyFeeSet);

        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Tax_Calculation_Source__c = 'Avalara'; 
        dummyOffice.cllease__Tax_Basis__c = 'Sales';
        update dummyOffice;
        system.debug('dummy office:' +dummyOffice);
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        update dummyLP;
    
         office = [SELECT Id    
                    FROM cllease__Office_Name__c 
                    LIMIT 1];
        leaseProduct = [SELECT Id,
                           Name,
                           cllease__Dep_over_asset_life__c,
                           cllease__Product_Sub_Type__c,
                           cllease__Residual_Accrual_Flag__c,
                           cllease__Income_Accrual_Flag__c,
                           cllease__Rental_Accrual_Flag__c,
                           cllease__IDC_Accrual_Flag__c,
                           cllease__Payment_Spread__c
                       FROM cllease__Lease_Product__c 
                       LIMIT 1];
         feeSet = [SELECT Id    
                    FROM cllease__Fee_Set__c 
                    LIMIT 1];
        
        Account lessee = new Account(Name = 'TestAccount');
        insert lessee;
        /**
         * Creating Contract
         */
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set__c             = feeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = leaseProduct.ID;
        leaseAccount.cllease__Branch__c              = office.ID;
        leaseAccount.cllease__Payment_Spread__c      = leaseProduct.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.today().addMonths(-5);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.today().addMonths(-5);
        leaseAccount.cllease__Product_Sub_Type__c    = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.today().addMonths(-5);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        insert leaseAccount;

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
        
        insert contractEquipments;
        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=1000,cllease__Total_Payment__c=1000,
                                                cllease__Payment_Date__c=Date.today().addMonths(-5),cllease__Contract__c=leaseAccount.id));
        
        insert paymentDetails;
        /**
         * Calling ContractBuilder for Contract Creation
         */
        
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        cllease__Lease_Account__c leaseAccount1 = [SELECT Id,cllease__Account__c
                                                    FROM cllease__Lease_Account__c
                                                    LIMIT 1];
        return leaseAccount1;
    }
    
    @isTest
    public static void test1(){
   
        //Creating Contract
        //ContractBuilder B                  = new ContractBuilder();
        cllease__Lease_Account__c contract = getContract();
        
        cllease__Fee__c dummyFee = cllease.TestHelper.createFee();
        dummyFee.name = 'ASSET SALE';  
        update dummyFee;
        
        
        //Retrive CL Equipment
        cllease__Contract_Equipment__C eq  = [SELECT id,name,cllease__Status__c FROM cllease__Contract_Equipment__C
                                              WHERE cllease__Contract__c = :contract.id LIMIT 1];
        system.debug('equipment:'+eq);
        
        //Creating Asset Sale 
        cllease__Asset_workbench__c awb     = new cllease__Asset_workbench__c();
        awb.cllease__Contract__c            = contract.id;
        awb.cllease__Contract_Equipment__c  = eq.id;
        awb.Date_Sold__c                    = Date.today().addMonths(-5);
        awb.Sale_Price__c                   = 1000;
        awb.Sold_to__c                      = contract.cllease__Account__c;
        awb.Process_Asset_Sale__c           = true;
        insert awb;
            
        Test.startTest();    
             AssetSaleProcessing.processAssetSale(awb.id);
        Test.stopTest();

     }
     @isTest
    public static void test2(){
  
        //Creating Contract
        //ContractBuilder B                  = new ContractBuilder();
        cllease__Lease_Account__c contract = getContract();
        
        cllease__Fee__c dummyFee = cllease.TestHelper.createFee();
        dummyFee.name = 'ASSET SALE';  
        update dummyFee;
             
        //Retrive CL Equipment
        cllease__Contract_Equipment__C eq  = [SELECT id,name,cllease__Status__c FROM cllease__Contract_Equipment__C
                                              WHERE cllease__Contract__c = :contract.id LIMIT 1];
        system.debug('equipment:'+eq);
        
        //Creating Asset Sale 
        cllease__Asset_workbench__c awb     = new cllease__Asset_workbench__c();
        awb.cllease__Contract__c            = contract.id;
        awb.cllease__Contract_Equipment__c  = eq.id;
        awb.Date_Sold__c                    = Date.today().addMonths(-5);
        awb.Sale_Price__c                   = 1000;
        awb.Sold_to__c                      = contract.cllease__Account__c;
        awb.Process_Asset_Sale__c           = true;
        insert awb;
        
      
        Test.startTest();    
             AssetSaleProcessing.multiAssetProcess();
        Test.stopTest();
    }
}