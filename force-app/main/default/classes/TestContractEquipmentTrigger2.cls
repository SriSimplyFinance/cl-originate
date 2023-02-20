@isTest(SeeAlldata = True)
public class TestContractEquipmentTrigger2 {


    public static cllease__Office_Name__c office;
    public static cllease__Lease_Product__c leaseProduct;
    public static clcommon__Fee_Set__c feeSet;
    
    @isTest
    public static void createEquipment()
    {
         
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_secret__c = 'testsecret';
        objSettings.refresh_token__c = 'testrefreshtoken';
        objSettings.grant_type__c ='testgrant';
        objSettings.saf_ZohoAccesstoken__c = 'testtoken';
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        objSettings.zoho_CretaOppEndpoint__c = 'dummy_Access_Endpoint';
        update objSettings;
        Test.startTest();
        Saf_ZohoAccounts_Mock mock = new Saf_ZohoAccounts_Mock();
        Test.setMock(HttpCalloutMock.class,mock);
        
        cllease.TestHelper.systemDate = Date.today().addMonths(-5);
        
     /*   cllease.TestHelper.createSeedDataForTesting();
        //Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        //clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createLeaseFeeJunction(dummyFee, dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee.ID,
                    clcommon__Fee_Set__c  = dummyFeeSet.ID);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Tax_Calculation_Source__c = 'Avalara'; 
        dummyOffice.cllease__Tax_Basis__c = 'Sales';
        update dummyOffice;
        system.debug('dummy office:' +dummyOffice);
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug('dummyLP:::'+dummyLP);
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        update dummyLP; */
        office = [SELECT Id    
                    FROM cllease__Office_Name__c 
                    LIMIT 1];
        leaseProduct = [SELECT Id,
                           Name,cllease__Status__c,
                           cllease__Dep_over_asset_life__c,
                           cllease__Product_Sub_Type__c,
                           cllease__Residual_Accrual_Flag__c,
                           cllease__Income_Accrual_Flag__c,
                           cllease__Rental_Accrual_Flag__c,
                           cllease__IDC_Accrual_Flag__c,
                           cllease__Payment_Spread__c
                       FROM cllease__Lease_Product__c where cllease__Status__c = 'Active' limit 1];
        feeSet = [SELECT Id    
                    FROM clcommon__Fee_Set__c 
                    LIMIT 1];
              
        Account lessee;
        try{
            lessee = new Account(Name = 'TestAccount12');
            insert lessee;
        }catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
     /**
         * Creating Contract
         */
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = feeSet.ID;
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
        
        //Create Collateral Category
        clcommon__Collateral_Category__c cltrlCategory = new clcommon__Collateral_Category__c();
        cltrlCategory.Name = 'Lease Category';
        insert cltrlCategory;
        
        // create collateral type
        clcommon__Collateral_Type__c cltrlType = new clcommon__Collateral_Type__c();
        cltrlType.Name = 'Equipment';
        insert cltrlType;
        // clcommon__Collateral_Category_Type_Association__c
        
        clcommon__Collateral_Category_Type_Association__c cltrlCategoryAssociation = new clcommon__Collateral_Category_Type_Association__c();
        cltrlCategoryAssociation.clcommon__Collateral_Category__c = cltrlCategory.Id;
        cltrlCategoryAssociation.clcommon__Collateral_Type__c = cltrlType.Id;
        insert cltrlCategoryAssociation;
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 5000,
                                                                  cllease__Equipment_Description__c = 'TestEquipment',
                                                                    cllease__Status__c = 'LEASED',
                                                                    cllease__Life_In_Months__c=18,cllease__Contract__c=leaseAccount.id));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 5000, 
                                                                  cllease__Equipment_Description__c = 'TestEquipment1',
                                                                    cllease__Status__c = 'LEASED',
                                                                    cllease__Life_In_Months__c=18,cllease__Contract__c=leaseAccount.id));
        
        insert contractEquipments;
        
        
        // update Contract Equipment 
       List<cllease__Contract_Equipment__C> updateEquipments = [select Id,cllease__Equipment_Description__c from cllease__Contract_Equipment__C
                                                               where cllease__Contract__c=:leaseAccount.id];
            for(cllease__Contract_Equipment__C eq: updateEquipments)
            {
                eq.cllease__Equipment_Description__c = 'updatetestdesc';
                update eq;
            }
        
        Test.stopTest();
    }
}