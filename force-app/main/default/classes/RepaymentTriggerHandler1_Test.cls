@isTest
public class RepaymentTriggerHandler1_Test {
    
     @isTest
     public static void RepaymentTrgrHandlr()
    {
        
         cllease__Fee_Set__c fee = new cllease__Fee_Set__c();
        fee.name = 'sample fee';
        insert fee;
        
        cllease.TestHelper.createSeedDataForTesting();
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, 
                                              clcommon__Fee_Set__c  = dummyFeeSet.ID);

        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        Account dummyAccount = new Account(Name = 'Sample Account');
        //  dummyAccount.fee_set__c = fee.id;
        insert dummyAccount;
        
        
        try{        
        //   2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        //   cllease__Lease_Product__c dummyLP = new  cllease__Lease_Product__c();
        //dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        // dummyLP.cllease__Product_Sub_Type__c ='Hire Purchase';
        dummyLP.name='Finance Lease';
        update dummyLP;
        }
        catch(exception e)
        {}
        list<id> agrIds = new list<id>();
        // 3.Creating Contract
        Date currentDate = Date.today();//Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c contract      = new cllease__Lease_Account__c();
      
        contract.cllease__Account__c            = dummyAccount.ID;
        // contract.cllease__Lease_Product_Name__c = dummyLP.ID;
        contract.cllease__Contract_Date__c      = currentDate;
        contract.cllease__Financed_Amount__c    = 10000;
        contract.cllease__Term__c               = 12;
        contract.cllease__Lease_Status__c ='PARTIAL APPLICATION';
        contract.Conga_Docs__c = 'Full Settlement Quote';
        contract.cllease__Currency_Code__c = 'GBP';
        //contract.cllease__Lease_Product_Name__r.name = 'Hire Purchase';
        //contract.Termination_Interest_Rate__c = 100;
        contract.MaxFrequency__c = 'test';
        // contract.cllease__Currency_Code__c = null;
        insert contract;
                
        //Select 
            //Id, 
            //cllease__Contract__c, 
            //cllease__Rental_Amount__c FROM 
            //cllease__Payment_Streams__r where cllease__Period_Start_Date__c != null order by ID desc Limit 1)
        cllease__Payment_Stream__c pstreams = new cllease__Payment_Stream__c();
        pstreams.cllease__Contract__c = contract.id;
        pstreams.cllease__Rental_Amount__c = 1000.00;
        pstreams.cllease__Period_Start_Date__c = Date.today();
        pstreams.cllease__Date__c = Date.today();
        //cllease__Billed__c = false and cllease__Payment_Type__c = 'RENT'
        pstreams.cllease__Billed__c = false;
        pstreams.cllease__Payment_Type__c = 'RENT';
        
        insert pstreams; 
            
        agrIds.add(contract.id);
        
        cllease__Contract_Equipment__c equipmentNew = new cllease__Contract_Equipment__c();
        equipmentNew.cllease__Contract__c = contract.id;
        equipmentNew.cllease__Override_Tax_Flag__c = TRUE;
        equipmentNew.cllease__Override_Tax_Rate__c = 20.00;
        equipmentNew.cllease__Equipment_Type__c = 'Cars';// 'Transport'
        equipmentNew.cllease__Equipment_Description__c = 'Test';
        insert equipmentNew;
        
        cllease__Payment_Schedule__c paySch= new cllease__Payment_Schedule__c();
        paySch.cllease__Frequency__c = 'Monthly';
        paySch.cllease__Contract__c = contract.id;
        paySch.cllease__VAT__c      = 20.00;
        paySch.cllease__Total_Payment__c = 10000;
        paySch.cllease__Payment_Amount__c = 10000;
        insert paySch;
        
        cllease__Contract_Fees__c conFees = new cllease__Contract_Fees__c();
        conFees.cllease__Contract__c = contract.id;
        insert conFees;

        list<id> payStrms = new list<id>();
        cllease__Payment_Stream__c payStr = new cllease__Payment_Stream__c();
         payStr.cllease__Contract__c = contract.id;
        payStr.cllease__Billed__c = false;
        payStr.cllease__Date__c = currentDate;
        payStr.cllease__Payment_Type__c = 'RENT';
        payStr.cllease__Rental_Amount__c = 5000;
        payStr.cllease__Active__c = true;
        payStr.cllease__Contract_Fee__c = conFees.id;
        // payStr.cllease__Contract_Fee__c = 'GBP';
        insert payStr;

        payStrms.add(payStr.id);
        
        list<Payment_Schedule__c> psList = new list<Payment_Schedule__c>();
        
        Payment_Schedule__c ps = new Payment_Schedule__c();
        ps.Payment_Amount__c =  payStr.cllease__Rental_Amount__c;
        ps.Payment_Date__c =  payStr.cllease__Date__c ;
        ps.Payment_Count__c = 10;
        ps.LS_Contract__c = contract.id;
        psList.add(ps);
        insert psList;
        
        psList[0].Payment_Amount__c = 4000;
        update psList;
        
        payStr.cllease__Active__c = true;
        payStr.cllease__Rental_Amount__c = 6000;
        update payStr;
        
        test.startTest();
        RepaymentTriggerHandler1.PaymentStreamUpdate(agrIds);
       
        test.stopTest(); 
    }
    
}