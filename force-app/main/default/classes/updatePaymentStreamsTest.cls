@isTest(SeeAllData=true) 
private class updatePaymentStreamsTest 
{
    @isTest 
    static void updatePaymentStreamsTest() {
    
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
        List<String> names = new List<String> {'Finance Lease'};
        //List<String> names = new List<String> {'Hire Purchase'};
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];

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
        insert genApp;
        
        HelperClass1.firstRun=true;
        genesis__Payment_Stream__c paymentStreams = new genesis__Payment_Stream__c();
        paymentStreams.genesis__Application__c = genApp.Id;
        paymentStreams.genesis__Number_of_Payments__c = 1;
        paymentStreams.genesis__Payment_Frequency__c = 'MONTHLY';
        paymentStreams.genesis__Payment_Amount__c = 100;
        paymentStreams.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        paymentStreams.genesis__Sequence__c = 1;
        insert paymentStreams;
        system.debug('paymet Streams: '+paymentStreams);
        
        HelperClass1.firstRun=true;
        paymentStreams = new genesis__Payment_Stream__c();
        paymentStreams.genesis__Application__c = genApp.Id;
        paymentStreams.genesis__Number_of_Payments__c = 2;
        paymentStreams.genesis__Payment_Frequency__c = 'MONTHLY';
        paymentStreams.genesis__Payment_Amount__c = 100;
        paymentStreams.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        paymentStreams.genesis__Sequence__c = 2;
        insert paymentStreams;
        system.debug('paymet Streams: '+paymentStreams);
        
        HelperClass1.firstRun=true;
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.INFO, '*** dummyFee : ' + dummyFee);
        
        HelperClass1.firstRun=true;
        clcommon__Fee_Definition__c dummyFee2 = cllease.TestHelper.createLeaseFee();
        dummyFee2.clcommon__Class__c = 'Expense';
        update dummyFee2;
        System.debug(LoggingLevel.INFO, '*** dummyFee : ' + dummyFee);
        
        HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule = new genesis__Fee_Schedule__c();
        feeSchedule.genesis__Application__c = genApp.Id;
        feeSchedule.genesis__Number_of_Periods__c = 1;
        feeSchedule.genesis__Frequency__c = 'MONTHLY';
        feeSchedule.genesis__Amount__c = 100;
        feeSchedule.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule.genesis__Fee_Definition__c= dummyFee.Id;
        insert feeSchedule;
        
        HelperClass1.firstRun=true;
        feeSchedule = new genesis__Fee_Schedule__c();
        feeSchedule.genesis__Application__c = genApp.Id;
        feeSchedule.genesis__Number_of_Periods__c = 1;
        feeSchedule.genesis__Frequency__c = 'MONTHLY';
        feeSchedule.genesis__Amount__c = 100;
        feeSchedule.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule.genesis__Fee_Definition__c= dummyFee2.Id;
        insert feeSchedule;
        
        Saf_setting__c objsetting = Saf_setting__c.getOrgDefaults();
        //select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.genesis_Option_to_purchase_Fee__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
        //    where genesis__Application__c In:AppIds and genesis__Fee_Definition__c =: objsetting.OTPFee__c
        //
        //select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.Security_Deposit__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
        //            where genesis__Application__c In:AppIds and genesis__Fee_Definition__c =: objsetting.Security_Fee__c
        //
        //select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.Documentation_Fee__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
        //        where genesis__Application__c In:AppIdsdoc and genesis__Fee_Definition__c =: objsetting.DcoumentFee__c
        //        
        //        objsetting.OTPFee__c, objsetting.Security_Fee__c, objsetting.DcoumentFee__c
        
        HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule1 = new genesis__Fee_Schedule__c();
        feeSchedule1.genesis__Application__c = genApp.Id;
        feeSchedule1.genesis__Number_of_Periods__c = 1;
        feeSchedule1.genesis__Frequency__c = 'MONTHLY';
        feeSchedule1.genesis__Amount__c = 100;
        feeSchedule1.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule1.genesis__Fee_Definition__c= objsetting.OTPFee__c;
        insert feeSchedule1;
        
        HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule2 = new genesis__Fee_Schedule__c();
        feeSchedule2.genesis__Application__c = genApp.Id;
        feeSchedule2.genesis__Number_of_Periods__c = 1;
        feeSchedule2.genesis__Frequency__c = 'MONTHLY';
        feeSchedule2.genesis__Amount__c = 100;
        feeSchedule2.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule2.genesis__Fee_Definition__c= objsetting.Security_Fee__c;
        insert feeSchedule2;
        
        HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule3 = new genesis__Fee_Schedule__c();
        feeSchedule3.genesis__Application__c = genApp.Id;
        feeSchedule3.genesis__Number_of_Periods__c = 1;
        feeSchedule3.genesis__Frequency__c = 'MONTHLY';
        feeSchedule3.genesis__Amount__c = 100;
        feeSchedule3.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule3.genesis__Fee_Definition__c= objsetting.DcoumentFee__c;
        insert feeSchedule3;
        
        HelperClass1.firstRun=true;
        genApp.genesis__Expected_Start_Date__c = Date.Today().adddays(-1);
        genApp.genesis__Expected_Start_Date__c = Date.Today().adddays(-1);
        update genApp;
        
        HelperClass1.firstRun=true;
        test.startTest();
        genApp.Security_Deposit__c = 150;
        update genApp;
        
        HelperClass1.firstRun=true;
        genApp.Security_Deposit__c = 0;
        update genApp;
        
        HelperClass1.firstRun=true;
        List<String> names1 = new List<String> {'Hire Purchase', 'Operating Lease','Sale & Hp Back'};
        clcommon__CL_Product__c product1 =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names1 limit 1 ];
        
        HelperClass1.firstRun=true;
        System.debug('*** Product Orig : ' + genApp.genesis__CL_Product__c + '*** Product modified : '+product1.Id);
        genApp.genesis__CL_Product__c = product1.Id;
        genApp.Security_Deposit__c = 200;
        genApp.genesis_Option_to_purchase_Fee__c = 145;
        update genApp;
        test.stopTest();
    }
    
    
    @isTest 
    static void updatePaymentStreamsTest1() {
    
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
        //List<String> names = new List<String> {'Finance Lease'};
        List<String> names = new List<String> {'Hire Purchase'};
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];

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
        insert genApp;
        
        HelperClass1.firstRun=true;
        genesis__Payment_Stream__c paymentStreams = new genesis__Payment_Stream__c();
        paymentStreams.genesis__Application__c = genApp.Id;
        paymentStreams.genesis__Number_of_Payments__c = 1;
        paymentStreams.genesis__Payment_Frequency__c = 'MONTHLY';
        paymentStreams.genesis__Payment_Amount__c = 100;
        paymentStreams.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        paymentStreams.genesis__Sequence__c = 1;
        insert paymentStreams;
        system.debug('paymet Streams: '+paymentStreams);
        
        HelperClass1.firstRun=true;
        paymentStreams = new genesis__Payment_Stream__c();
        paymentStreams.genesis__Application__c = genApp.Id;
        paymentStreams.genesis__Number_of_Payments__c = 2;
        paymentStreams.genesis__Payment_Frequency__c = 'MONTHLY';
        paymentStreams.genesis__Payment_Amount__c = 100;
        paymentStreams.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        paymentStreams.genesis__Sequence__c = 2;
        insert paymentStreams;
        system.debug('paymet Streams: '+paymentStreams);
        
        HelperClass1.firstRun=true;
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.INFO, '*** dummyFee : ' + dummyFee);
        
        HelperClass1.firstRun=true;
        clcommon__Fee_Definition__c dummyFee2 = cllease.TestHelper.createLeaseFee();
        dummyFee2.clcommon__Class__c = 'Expense';
        update dummyFee2;
        System.debug(LoggingLevel.INFO, '*** dummyFee : ' + dummyFee);
        
        HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule = new genesis__Fee_Schedule__c();
        feeSchedule.genesis__Application__c = genApp.Id;
        feeSchedule.genesis__Number_of_Periods__c = 1;
        feeSchedule.genesis__Frequency__c = 'MONTHLY';
        feeSchedule.genesis__Amount__c = 100;
        feeSchedule.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule.genesis__Fee_Definition__c= dummyFee.Id;
        insert feeSchedule;
        
        HelperClass1.firstRun=true;
        feeSchedule = new genesis__Fee_Schedule__c();
        feeSchedule.genesis__Application__c = genApp.Id;
        feeSchedule.genesis__Number_of_Periods__c = 1;
        feeSchedule.genesis__Frequency__c = 'MONTHLY';
        feeSchedule.genesis__Amount__c = 100;
        feeSchedule.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule.genesis__Fee_Definition__c= dummyFee2.Id;
        insert feeSchedule;
        
        Saf_setting__c objsetting = Saf_setting__c.getOrgDefaults();
        //select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.genesis_Option_to_purchase_Fee__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
        //    where genesis__Application__c In:AppIds and genesis__Fee_Definition__c =: objsetting.OTPFee__c
        //
        //select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.Security_Deposit__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
        //            where genesis__Application__c In:AppIds and genesis__Fee_Definition__c =: objsetting.Security_Fee__c
        //
        //select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.Documentation_Fee__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
        //        where genesis__Application__c In:AppIdsdoc and genesis__Fee_Definition__c =: objsetting.DcoumentFee__c
        //        
        //        objsetting.OTPFee__c, objsetting.Security_Fee__c, objsetting.DcoumentFee__c
        
        /*HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule1 = new genesis__Fee_Schedule__c();
        feeSchedule1.genesis__Application__c = genApp.Id;
        feeSchedule1.genesis__Number_of_Periods__c = 1;
        feeSchedule1.genesis__Frequency__c = 'MONTHLY';
        feeSchedule1.genesis__Amount__c = 100;
        feeSchedule1.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule1.genesis__Fee_Definition__c= objsetting.OTPFee__c;
        insert feeSchedule1;
        
        HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule2 = new genesis__Fee_Schedule__c();
        feeSchedule2.genesis__Application__c = genApp.Id;
        feeSchedule2.genesis__Number_of_Periods__c = 1;
        feeSchedule2.genesis__Frequency__c = 'MONTHLY';
        feeSchedule2.genesis__Amount__c = 100;
        feeSchedule2.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule2.genesis__Fee_Definition__c= objsetting.Security_Fee__c;
        insert feeSchedule2;
        
        HelperClass1.firstRun=true;
        genesis__Fee_Schedule__c feeSchedule3 = new genesis__Fee_Schedule__c();
        feeSchedule3.genesis__Application__c = genApp.Id;
        feeSchedule3.genesis__Number_of_Periods__c = 1;
        feeSchedule3.genesis__Frequency__c = 'MONTHLY';
        feeSchedule3.genesis__Amount__c = 100;
        feeSchedule3.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
        feeSchedule3.genesis__Fee_Definition__c= objsetting.DcoumentFee__c;
        insert feeSchedule3;*/
        
        HelperClass1.firstRun=true;
        genApp.genesis__Expected_Start_Date__c = Date.Today().adddays(-1);
        genApp.genesis__Expected_Start_Date__c = Date.Today().adddays(-1);
        update genApp;
        
        HelperClass1.firstRun=true;
        test.startTest();
        genApp.Security_Deposit__c = 150;
        update genApp;
        
        HelperClass1.firstRun=true;
        genApp.Security_Deposit__c = 0;
        update genApp;
        
        HelperClass1.firstRun=true;
        List<String> names1 = new List<String> {'Hire Purchase', 'Operating Lease','Sale & Hp Back'};
        clcommon__CL_Product__c product1 =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names1 limit 1 ];
        
        HelperClass1.firstRun=true;
        System.debug('*** Product Orig : ' + genApp.genesis__CL_Product__c + '*** Product modified : '+product1.Id);
        genApp.genesis__CL_Product__c = product1.Id;
        genApp.Security_Deposit__c = 200;
        genApp.genesis_Option_to_purchase_Fee__c = 145;
        update genApp;
        
        List<genesis__Applications__c> lstgenapp = new List<genesis__Applications__c>();
        lstgenapp.add(genApp);
        updatePaymentStreams.updateSaflinkRecords(lstgenapp);
        //updatePaymentStreams.updateSaflinkRecords2(lstgenapp);
        test.stopTest();
    }
}