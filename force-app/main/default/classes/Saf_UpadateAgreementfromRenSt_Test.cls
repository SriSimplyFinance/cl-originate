@isTest(SeeAllData=True)
private class Saf_UpadateAgreementfromRenSt_Test {
        static testmethod void test2() {        
        cllease.TestHelper.createSeedDataForTesting();
        //CreateRentalStreams();   
        ExposureTest();  
        test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<cllease__Lease_Account__c> lstTypes = new List<cllease__Lease_Account__c>();
        //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
        // Schedule the test job
        User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
        Date mydate = userRec.cllease__Current_Branch_s_System_Date__c;
        Date mydate1 = mydate.addmonths(1);
        system.debug('#### mydate : '+ mydate );
        //string query='select id,cllease__Contract__r.cllease__Excess__c,cllease__Lease_Account__c.cllease__Amount_to_Current__c,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c where (cllease__Contract__c != null and (cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - GOOD STANDING\' or cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - BAD STANDING\' ) and cllease__Date__c >=: mydate and cllease__Date__c <=: mydate1) order by cllease__Contract__c Limit 100';
         String query= 'select Id,Name,cllease__Lease_Status__c,Saf_Exposure__c,cllease__Account__c,cllease__Account__r.Id,cllease__Account__r.Name,cllease__Account__r.SAF_Exposure_Agreements__c from cllease__Lease_Account__c';// where cllease__Lease_Status__c NOT IN :strStatus';
        
        Saf_Exposure_1 ER = new  Saf_Exposure_1();
        ER.getRuntimeQuery();
        ER.doInitialize();
        ER.doStart(bc);
        QL = Database.getQueryLocator(query);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            cllease__Lease_Account__c objType = (cllease__Lease_Account__c)QIT.next();           
            System.debug('cllease__Lease_Account__c:'+objType);
            lstTypes.add(objType);
        }  
        
        system.debug('List of contracts '+lstTypes);     
        try{
            ER.execute(BC,lstTypes);
            ER.finish(BC); 
        }
        catch(Exception e){}
        //ER.finish(BC); 
        
        test.stopTest();
        
        // after the testing stops, assert records were updated properly
        /* for(cllease__Contract_Equipment__c objbill : lstbills)
{                
if(objbill.VLS__c == null)
{system.debug('Bills not updated properly: ' + objbill.cllease__Lease_Account__c);}
}*/
    }
 
    static testmethod void test() {        
        cllease.TestHelper.createSeedDataForTesting();
        //CreateRentalStreams();   
        ExposureTest();  
        test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<cllease__Rental_Stream__c> lstTypes = new List<cllease__Rental_Stream__c>();
        //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
        // Schedule the test job
        User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
        Date mydate = userRec.cllease__Current_Branch_s_System_Date__c;
        Date mydate1 = mydate.addmonths(1);
        system.debug('#### mydate : '+ mydate );
        string query='select id,cllease__Contract__r.cllease__Excess__c,cllease__Contract__r.cllease__Amount_to_Current__c,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c where (cllease__Contract__c != null and (cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - GOOD STANDING\' or cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - BAD STANDING\' ) and cllease__Date__c >=: mydate and cllease__Date__c <=: mydate1) order by cllease__Contract__c Limit 100';
        
        Saf_UpadateAgreementfromRentalstreams1 ER = new  Saf_UpadateAgreementfromRentalstreams1();
        ER.getRuntimeQuery();
        ER.doInitialize();
        ER.doStart(bc);
        QL = Database.getQueryLocator(query);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            cllease__Rental_Stream__c objType = (cllease__Rental_Stream__c)QIT.next();           
            System.debug('cllease__Rental_Stream__c :'+objType);
            lstTypes.add(objType);
        }  
        
        system.debug('List of streams'+lstTypes);     
        try{
            ER.execute(BC,lstTypes);
            ER.finish(BC); 
        }
        catch(Exception e){}
        //ER.finish(BC); 
        
        test.stopTest();
        
        // after the testing stops, assert records were updated properly
        /* for(cllease__Contract_Equipment__c objbill : lstbills)
{                
if(objbill.VLS__c == null)
{system.debug('Bills not updated properly: ' + objbill.cllease__Lease_Account__c);}
}*/
    }
    public static testMethod void CreateRentalStreams(){
        
        cllease__Rental_Stream__c rentalStream = new cllease__Rental_Stream__c();
        
        
        /*cllease__Office_Name__c ofcName = new cllease__Office_Name__c();
ofcName.Name = 'Simply Asset';
ofcName.cllease__Office_Short_Name__c = 'saf';
insert ofcName;*/
        
        
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.AccountNumber='6549821699';
        lessee.Name = 'TestAccount1';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        
        /*clcommon__Fee_Set__c feeSet = new clcommon__Fee_Set__c();
feeSet.Name = 'Hire Purchase';
insert feeSet;

cllease__Lease_Product__c prodName = new cllease__Lease_Product__c();
prodName.Name = 'Hire Purchases';
prodName.cllease__Calculation_Method__c = 'IRR';
prodName.cllease__Status__c = 'Active';
insert prodName;*/
        
        cllease__Payment_Spread__c paySpr = new cllease__Payment_Spread__c();
        paySpr.cllease__Enabled__c = true;
        paySpr.cllease__Spread_Description__c = 'test';
        paySpr.cllease__Tax_Configuration__c = 'RECEIVABLE FIRST';
        insert paySpr;
        
        //Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        
        System.debug(LoggingLevel.ERROR, '*** lessee : ' + lessee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        // cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        
        cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        
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
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.Id; //'a6N0O0000005JXyUAM';//ofcName.ID;
        leaseAccount.cllease__Payment_Spread__c      = paySpr.id;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 6;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        insert leaseAccount;
        
        List<Id> IdsRentalstreams =new List<Id>();
        rentalStream.cllease__Capital_Recovery__c = 3000;
        rentalStream.cllease__Lease_Income__c = 1000;
        rentalStream.cllease__Contract__c = leaseAccount.Id;
        rentalStream.cllease__Date__c = date.today() + 1;
        insert rentalStream;
        IdsRentalstreams.add(leaseAccount.Id);
        
        
        
    }
    
    public static testMethod void ExposureTest(){
        
        cllease__Rental_Stream__c rentalStream = new cllease__Rental_Stream__c();
        
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.AccountNumber='65498';
        lessee.Name = 'TestHMNew';
        lessee.Phone = '98767 678988';
        lessee.Landline__c= '98767 678988';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        
        
        cllease__Payment_Spread__c paySpr = new cllease__Payment_Spread__c();
        paySpr.cllease__Enabled__c = true;
        paySpr.cllease__Spread_Description__c = 'test';
        paySpr.cllease__Tax_Configuration__c = 'RECEIVABLE FIRST';
        insert paySpr;
        
        //Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        
        System.debug(LoggingLevel.ERROR, '*** lessee : ' + lessee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        // cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        
        cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        
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
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.Id; //'a6N0O0000005JXyUAM';//ofcName.ID;
        leaseAccount.cllease__Payment_Spread__c      = paySpr.id;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 6;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        leaseAccount.cllease__Lease_Status__c = 'TERMINATED';
        insert leaseAccount;
        
        system.debug('#### Status: '+leaseAccount.cllease__Lease_Status__c);
        User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
        Date mydate = userRec.cllease__Current_Branch_s_System_Date__c;
        system.debug('#### mydate : '+ mydate );
        List<Id> IdsRentalstreams =new List<Id>();
        rentalStream.cllease__Capital_Recovery__c = 3000;
        rentalStream.cllease__Lease_Income__c = 1000;
        rentalStream.cllease__Contract__c = leaseAccount.Id;
        rentalStream.cllease__Date__c = mydate.addmonths(-1);
        insert rentalStream;
        system.debug('#### Rental Stream Date: '+ rentalStream.cllease__Date__c);
        IdsRentalstreams.add(leaseAccount.Id);
        
        cllease__Lease_account_Due_Details__c bill = new cllease__Lease_account_Due_Details__c();
        
        bill.cllease__Account__c = lessee.ID;
        bill.cllease__Lease_Account__c = leaseAccount.Id;
        //bill.cllease__Lease_Account__r.cllease__Account__c = '';
        bill.cllease__Total_Due_Amount__c = 0.00;
        bill.cllease__Due_Type_Description__c = 'TERMINATION';
        
        insert bill;
        
        clcommon__CL_Product__c product = new clcommon__CL_Product__c();
        product.clcommon__Product_Name__c = 'Finance Lease';
        insert product;
        
        List<String> names = new List<String> {'Finance Lease'};
            //clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];
            
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
        genApp.genesis__Account__c = lessee.ID;
        //genApp.Security_Deposit__c = 100;
        insert genApp;
        
        genesis__Payment_Stream__c paymentStreams = new genesis__Payment_Stream__c();
        paymentStreams.genesis__Application__c = genApp.Id;
        paymentStreams.genesis__Number_of_Payments__c = 1;
        paymentStreams.genesis__Payment_Frequency__c = 'MONTHLY';
        paymentStreams.genesis__Payment_Amount__c = 100;
        paymentStreams.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        paymentStreams.genesis__Sequence__c = 1;
        insert paymentStreams;
        
        paymentStreams = new genesis__Payment_Stream__c();
        paymentStreams.genesis__Application__c = genApp.Id;
        paymentStreams.genesis__Number_of_Payments__c = 2;
        paymentStreams.genesis__Payment_Frequency__c = 'MONTHLY';
        paymentStreams.genesis__Payment_Amount__c = 100;
        paymentStreams.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        paymentStreams.genesis__Sequence__c = 2;
        insert paymentStreams;
    }
}