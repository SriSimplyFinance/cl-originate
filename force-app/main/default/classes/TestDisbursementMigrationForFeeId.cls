@isTest
public class TestDisbursementMigrationForFeeId {
    
    public static testMethod void testMigration(){
        
        cllease.TestHelper.createSeedDataForTesting();
        cllease.TestHelper.systemDate = Date.parse('1/1/2016');
        
        //Create a Fee Set
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Class__c = clcommon.CLConstants.FEE_CLASS_EXPENSE;
        update dummyFee;

        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        
        clcommon__Fee_Junction__c dummyFeeJunction = new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee.ID,
                                                                                  clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert dummyFeeJunction;
        
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);

        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet, cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE);

        dummyLp.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE;
        update dummyLP;
        
        Account lessee = new Account(Name = 'TestAccount');
        insert(lessee);
        Date sysDate = Date.newInstance(2016, 01, 01);
        /**
         * Creating Contract
         */
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = sysDate;
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = sysDate;
        //leaseAccount.Product_Sub_Type__c = LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = sysDate;
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';


        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000, cllease__Life_In_Months__c = 18,
                                                            cllease__State_Province__c = 'ILLINOIS-IL',
                                                            cllease__City__c = 'SF',
                                                            cllease__County__c = 'TEST COUNTY',
                                                            cllease__Country__c = 'USA'));

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                                                cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c = 1000, cllease__Total_Payment__c = 1000,
                                                cllease__Payment_Date__c = sysDate));

        /**
         * Calling ContractBuilder for Contract Creation
         */

        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(null);
        cllease.RegenerateStreamsCtrl.FinregenerateStreams(leaseAccount.Id, '10000');
        
        cllease__Contract_Fees__c confFee = new cllease__Contract_Fees__c(cllease__Contract__c=leaseAccount.id,
                                                                          cllease__Fee_Definition__c=dummyfee.ID,
                                                                          cllease__Number_of_Periods__c=1,
                                                                          cllease__Start_Date__c = leaseAccount.cllease__Contract_Date__c,
                                                                          cllease__Fee_Type__c = dummyfee.Name,
                                                                          cllease__Frequency__c=cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                          cllease__Amount__c=1000, 
                                                                          cllease__Total_Payment_Amount__c=1000);
        insert(confFee);
        
        cllease__Expense_Fees__c feeConfig = new cllease__Expense_Fees__c();
        feeConfig.cllease__Contract__c = leaseAccount.id;
        feeConfig.cllease__Fee_Definition__c = dummyfee.id;
        insert feeConfig;
        
        Account account1 = new Account(Name='Test Account');
        insert(account1); 
        
        cllease__Contract_Parties__c party = cllease.TestHelper.createParty(account1, leaseAccount, 'SUPPLIER');       
        
        cllease__Contract_Fee_Payment__c feePayment = new cllease__Contract_Fee_Payment__c(cllease__Contract__c = leaseAccount.Id, 
                                                                                           cllease__Contract_Fee__c = feeConfig.Id, 
                                                                                           cllease__Pay_To__c = party.Id);
        insert(feePayment);
           
        leaseAccount.cllease__Lease_Status__c = cllease.LendingConstants.STATUS_APPROVED;
        update(leaseAccount);
        cllease.ActivateContractCtrl.activateContract(leaseAccount.Id);
        
        leaseAccount = [Select Id,cllease__Lease_Status__c From cllease__Lease_Account__c where id = :leaseAccount.Id];
        System.assertEquals(leaseAccount.cllease__Lease_Status__c, cllease.LendingConstants.STATUS_ACTIVE_GOOD_STANDING);
        
        List<clcommon__Disbursement_Transaction__c> disbTxns = [Select Id from clcommon__Disbursement_Transaction__c];
        for(clcommon__Disbursement_Transaction__c disb : disbTxns){
            disb.cllease__Contract_Fee__c = null;
        }
        update disbTxns;
        
        Test.startTest();
            Database.executeBatch(new DisbursementMigrationForFeeId());
        Test.stopTest();
           

        
    }
    

}