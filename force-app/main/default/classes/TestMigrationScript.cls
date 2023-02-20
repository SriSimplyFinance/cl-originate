@isTest
public class TestMigrationScript {
 
  @isTest
  private static void Test1(){
        cllease.TestHelper.createSeedDataForTesting();
        //Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.Name = 'TestAccount';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        
        System.debug(LoggingLevel.ERROR, '*** lessee: ' + lessee.Id);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
                                                                                         cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
                                                                                cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP;  
 
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
 
 
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000, cllease__Life_In_Months__c=18,Net_Asset_Cost__c =0.0,cllease__Equipment_Description__c = 'ok'));
 
        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=1000,cllease__Total_Payment__c=12000,
                                                cllease__Payment_Date__c=Date.newInstance(2016, 01, 01)));
 
        /**
         * Calling ContractBuilder for Contract Creation
         */
        
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(null);
        System.debug(LoggingLevel.ERROR, '*** response: ' + response);
        
        cllease.RegenerateStreamsCtrl.regenerateStreams(leaseAccount.Id);
        leaseAccount.cllease__Lease_Status__c = 'APPROVED';
       
        update leaseAccount;
        cllease.ActivateContractCtrl.activateContract(leaseAccount.id);
        system.debug('Contract ----'+leaseAccount.id);
        system.debug('Contract status----'+leaseAccount.cllease__lease_status__c);
        
        AccountBalancesCorrector job = new AccountBalancesCorrector();
         database.executeBatch(job, 200);
    }
    
    @isTest
  private static void Test2(){
                cllease.TestHelper.createSeedDataForTesting();
        //Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.Name = 'TestAccount';
          lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        dummyLP.cllease__Residual_Accrual_Flag__c = true;
        dummyLP.cllease__Income_Accrual_Flag__c = true;
        dummyLP.cllease__Idc_Accrual_Flag__c = true;
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
                                                                                         cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
                                                                                cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP;  
 
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
 
 
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000, Net_Asset_Cost__c =0.0,cllease__Life_In_Months__c=18,cllease__Equipment_Description__c='Ok', cllease__Residual_Amount__c = 1000));
 
        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=1000,cllease__Total_Payment__c=12000,
                                                cllease__Payment_Date__c=Date.newInstance(2016, 01, 01)));
 
        /**
         * Calling ContractBuilder for Contract Creation
         */
        
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(null);
        
        cllease.RegenerateStreamsCtrl.regenerateStreams(leaseAccount.Id);
        leaseAccount.cllease__Lease_Status__c = 'APPROVED';
       
        update leaseAccount;
        cllease.ActivateContractCtrl.activateContract(leaseAccount.id);
        system.debug('Contract ----'+leaseAccount.id);
        system.debug('Contract status----'+leaseAccount.cllease__lease_status__c);
        
        AccountBalancesCorrector job = new AccountBalancesCorrector();
         database.executeBatch(job, 200);
    }
  
  @isTest
  private static void testCopyFieldValue(){
        cllease.Testhelper.createSeedDataForTesting();
        // 1. Pre-Setup
        // CL Lease Fee(deprecated) Configuration
        cllease__Fee__c clleaseFee = cllease.Testhelper.createFee();
        clleaseFee.Name = 'SampleFee';
        update clleaseFee;        
        cllease__Fee_Set__c clleaseFeeSet = cllease.Testhelper.createFeeSet();
        clleaseFeeSet.Name = 'SampleFeeSet';
        update clleaseFeeSet;        
        cllease.Testhelper.createFeeJunction(clleaseFee, clleaseFeeSet);
        
          MigrationScript1 mg = new MigrationScript1();
        mg.MigScript1();
         
         // Cl COmmon Fees Configuration
         clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.Name = 'SampleFee';
        update dummyFee;        
         clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        dummyFeeSet.Name = 'SampleFeeSet';
        update dummyFeeSet;        
         insert new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
            
         cllease__Office_Name__c dummyOffice = cllease.Testhelper.createOffice('Test Office', true);
         Account dummyAccount = new Account(Name = 'Sample Account');
         dummyAccount.Phone = '98767 678987';
         dummyAccount.Landline__c= '98767 678987';
         dummyAccount.BillingPostalCode = 'BD1 1HA';
         dummyAccount.BillingCity = 'London';
         dummyAccount.ShippingPostalCode = 'BD1 1HA'; 
         dummyAccount.ShippingCity = 'London';
         insert dummyAccount;
 
         // 2. Creating Sample Product with rental and Dep Streams enabled
         cllease__Lease_Product__c dummyLP                     = cllease.Testhelper.createLeaseProduct(dummyOffice, dummyFeeSet);
         dummyLP.cllease__Product_Sub_Type__c          = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
         update dummyLP;
        
         // 3.Creating Contract
         Date currentDate = Date.newInstance(2017, 01, 01);
         cllease__Lease_Account__c leaseAccount                = new cllease__Lease_Account__c();
         leaseaccount.cllease__Account__c                      = dummyAccount.ID;
         leaseAccount.cllease__Lease_Product_Name__c = dummyLP.ID;
         leaseAccount.cllease__Contract_Date__c        = currentDate;
         leaseaccount.cllease__Financed_Amount__c      = 10000;
         leaseAccount.cllease__Term__c                         = 12;
 
         // 3.a Adding Equipments to Contract
         List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
         contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,cllease__Life_In_Months__c=18,cllease__Equipment_Description__c ='OK',Net_Asset_Cost__c =10000 ));
         
         // 3.b Adding Payment Schedules to Contract
         List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
         paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                             cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                            cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = currentDate,
                            cllease__Total_Payment__c = 1200));
        // 3.c adding Fee Schedule
        List<cllease__Contract_Fees__c> contractFees =  new List<cllease__Contract_Fees__c>();
        contractFees.add(new cllease__Contract_Fees__c(cllease__VAT__c = 0.00, cllease__Total_Payment_Amount__c = 150,
                                              cllease__Contract__c = leaseAccount.id, cllease__Fee__c = clleaseFee.ID,
                                              cllease__Fee_Definition__c = dummyFee.Id,
                                              cllease__Fee_Type__c = 'OTHER FEES', cllease__Number_of_Periods__c = 1,
                                              cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                              cllease__Amount__c = 150, cllease__start_date__c = leaseAccount.cllease__Contract_Date__c));
 
         // 4. Calling ContractBuilder for Contract Creation
         cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
         builder.addChildObjects(contractEquipments);
         builder.addChildObjects(paymentDetails);
         String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
         System.debug(LoggingLevel.ERROR, '---Response: '+response);
        
        // Create Charge 
        cllease__Charge__c charge = new cllease__Charge__c(cllease__Lease_Account__c   = leaseAccount.Id, 
                                                                        cllease__Original_Amount__c    = 100, cllease__Paid_Amount__c = 0, 
                                                                        cllease__Principal_Due__c = 100, 
                                                                        cllease__Fee__c  = contractFees.get(0).cllease__Fee__c,
                                               cllease__Fee_Definition__c = contractFees.get(0).cllease__Fee_Definition__c, 
                                            cllease__Date__c = currentDate);
        insert charge;
        
        String namespacePrefix = 'cllease__';  
         String objectName;
         String sourceAPIName;
         String destFeeAPIName;
  
        //-------------- 1. CL Lease Records Updates ---------------//
        objectName = namespacePrefix + 'Lease_Account__c';
        sourceAPIName = namespacePrefix + 'fee_set__c';
        destFeeAPIName = namespacePrefix + 'fee_set1__c';
    
        CopyFieldValue job = new CopyFieldValue(objectName, sourceAPIName, destFeeAPIName, 'FEESET', namespacePrefix);
        Database.executeBatch(job, 1);
        
        //-------------- 1. Contract Fee Records Updates-----------------------------------------------------------------------------------------//
        objectName = namespacePrefix + 'Contract_Fees__c';
        sourceAPIName = namespacePrefix + 'Fee__c';
        destFeeAPIName = namespacePrefix + 'Fee_Definition__c';
    
        CopyFieldValue job1 = new CopyFieldValue(objectName, sourceAPIName, destFeeAPIName, 'FEE', namespacePrefix);
        Database.executeBatch(job1, 1);
        
        //--------------- 2. Charge Records Updates-----------------------------------------------------------------------------------------------//
        objectName = namespacePrefix + 'Charge__c';
        sourceAPIName = namespacePrefix + 'Fee__c';
        destFeeAPIName = namespacePrefix + 'Fee_Definition__c';
    
        CopyFieldValue job2 = new CopyFieldValue(objectName, sourceAPIName, destFeeAPIName, 'FEE', namespacePrefix);
        Database.executeBatch(job2, 1);

    }
  
  @isTest
  private static void TestExpenseFee(){
        cllease.Testhelper.createSeedDataForTesting();
        // 1. Pre-Setup
        // CL Lease Fee(deprecated) Configuration
        cllease__Fee__c clleaseFee = cllease.Testhelper.createFee();
        clleaseFee.Name = 'SampleFee';
        update clleaseFee;        
        cllease__Fee_Set__c clleaseFeeSet = cllease.Testhelper.createFeeSet();
        clleaseFeeSet.Name = 'SampleFeeSet';
        update clleaseFeeSet;        
        cllease.Testhelper.createFeeJunction(clleaseFee, clleaseFeeSet);
         
         // Cl COmmon Fees Configuration
         clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        dummyFee.Name = 'SampleFee';
        update dummyFee;        
         clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        dummyFeeSet.Name = 'SampleFeeSet';
        update dummyFeeSet;        
         insert new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
            
         cllease__Office_Name__c dummyOffice = cllease.Testhelper.createOffice('Test Office', true);
         Account dummyAccount = new Account(Name = 'Sample Account',Phone = '98767 678987' , Landline__c= '98767 678987', BillingPostalCode = 'BD1 1HA',BillingCity = 'London', ShippingPostalCode = 'BD1 1HA', ShippingCity = 'London' );
         insert dummyAccount;
 
         // 2. Creating Sample Product with rental and Dep Streams enabled
         cllease__Lease_Product__c dummyLP                     = cllease.Testhelper.createLeaseProduct(dummyOffice, dummyFeeSet);
         dummyLP.cllease__Product_Sub_Type__c          = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
         update dummyLP;
        
         // 3.Creating Contract
         Date currentDate = Date.newInstance(2017, 01, 01);
         cllease__Lease_Account__c leaseAccount                = new cllease__Lease_Account__c();
         leaseaccount.cllease__Account__c                      = dummyAccount.ID;
         leaseAccount.cllease__Lease_Product_Name__c = dummyLP.ID;
         leaseAccount.cllease__Contract_Date__c        = currentDate;
         leaseaccount.cllease__Financed_Amount__c      = 10000;
         leaseAccount.cllease__Term__c                         = 12;
 
         // 3.a Adding Equipments to Contract
         List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
         contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,cllease__Equipment_Description__c ='OK',Net_Asset_Cost__c =10000,cllease__Life_In_Months__c=18 ));
         
         // 3.b Adding Payment Schedules to Contract
         List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
         paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                            cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                            cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = currentDate,
                            cllease__Total_Payment__c = 1200));
        // 3.c adding Fee Schedule
        List<cllease__Contract_Fees__c> contractFees =  new List<cllease__Contract_Fees__c>();
        contractFees.add(new cllease__Contract_Fees__c(cllease__VAT__c = 0.00, cllease__Total_Payment_Amount__c = 150,
                                              cllease__Contract__c = leaseAccount.id, cllease__Fee__c = clleaseFee.ID,
                                              cllease__Fee_Definition__c = dummyFee.Id,
                                              cllease__Fee_Type__c = 'OTHER FEES', cllease__Number_of_Periods__c = 1,
                                              cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                              cllease__Amount__c = 150, cllease__start_date__c = leaseAccount.cllease__Contract_Date__c));
         
        List<cllease__Expense_Fees__c> oldExpenseFees =  new List<cllease__Expense_Fees__c>();
        oldExpenseFees.add(new cllease__Expense_Fees__c(
                                                               cllease__Account__c = dummyAccount.Id, 
                                                                 cllease__Amount__c = 100, 
                                                         cllease__Fee_Definition__c = dummyFee.Id,
                                                         cllease__Number_Of_Periods__c = 12));
        
         // 4. Calling ContractBuilder for Contract Creation
         cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
         builder.addChildObjects(contractEquipments);
         builder.addChildObjects(paymentDetails);
        builder.addChildObjects(oldExpenseFees);
         String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
         System.debug(LoggingLevel.ERROR, '---Response: '+response);
                
         ExpenseFeesDataMigrator job = new ExpenseFeesDataMigrator();
         Database.executeBatch(job);
    }
}