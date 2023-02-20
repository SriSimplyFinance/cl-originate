@isTest
public class TestRestructure{

    public static cllease__Office_Name__c office;
    public static cllease__Lease_Product__c leaseProduct;
    public static cllease__Fee_Set__c feeSet;
    
   
        @isTest
        public static cllease__Lease_Account__c getContract() {
        
        cllease.TestHelper.systemDate = Date.today().addMonths(-5);
        
       /* ContractBuilder B = new ContractBuilder();
        cllease__Lease_Account__c contract = B.getContract();
        

        update contract;*/
        
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
                
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        dummyLP.name= 'Evergreen';
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
        leaseAccount.cllease__Residual_Amount__c = 10000;
        //leaseAccount.Remaining_Residual_Amount__c = 10000;
        //leaseAccount.Residual_Burndown_Term__c = 12;
        //leaseAccount.cllease__Lease_Status__c = 'EVERGREEN';       
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
        

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=1000,cllease__Total_Payment__c=1000,
                                                cllease__Payment_Date__c=Date.today().addMonths(-5),cllease__Contract__c=leaseAccount.id));

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
    
        cllease__Lease_Account__c contract = getContract();

        Test.startTest();    
            /*ResidualBurndown rb = new ResidualBurndown();
            database.executebatch(rb);*/
             List<cllease__Lease_Account__c> contractList = new List<cllease__Lease_Account__c>();
                     cllease__Rental_Accrual_Stream1__c rS = new cllease__Rental_Accrual_Stream1__c();
                     rS.cllease__Contract__c = contract.id;
                     insert rS;
             /*cllease.RegenerateStreamsCtrl.FinregenerateStreams(contract.id,'10000');
             contract.cllease__Lease_Status__c = 'Approved';
             contractList.add(contract);
             update contractList;*/
        Test.stopTest();
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
    }
}