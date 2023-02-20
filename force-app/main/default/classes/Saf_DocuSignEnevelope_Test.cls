@isTest(SeeAllData=True)
private class Saf_DocuSignEnevelope_Test {
    public class SharePointmock implements HttpCalloutMock {
         public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String jsonbody=  '{"users":[{'+
                                '"country":"gb",'+
                                  '"role":{' +
                                        '"name":"SalesManager",'+
                                          '"id":"10777000001201297"'+
                                       '},'+      
                                  '"language":"en_TB",'+
                                  '"locale":"en_US",'+
                                  '" microsoft":"false",'+
                                //  '"Isonline":"false",'+
                                  '"Modified_By":{'+
                                                '"name":"System Admin",'+
                                                '"id":"10777000000140034"'+
                                                 '},' +
                                  '"id":"10777000001268001",'+
                                  '"country_locale":"US",'+
                                  '"first_name":"Paul",'+
                                  '"email":"paul.morrison@simply.finance",'+    
                                  '"created_time":"2019-08-01T15:35:00+05:30",'+
                                  '"Modified_Time":"2019-08-01T15:35:00+05:30",'+
                                  '"time_format":"hh:mm a",'+
                                  '"offset":"0",'+
                                  '"profile":{'+
                                           '"name":"Standard",'+
                                           '"id":"10777000001182794"'+
                                            '},'   +  
                                 '"last_name":"Morrison",'+
                                 '"time_zone":"GMT",'+
                                 '"created_by":{'+
                                           '"name":"System Admin",'+
                                               '"id":"10777000000140034"'+
                                          '},'+
                                '"zuid":"20067174770",'+
                            //      '"confirm":"true",'+
                                '"full_name":"PaulMorrison",'+
                                '"SFDC":"sfdc",'+
                                '"territories":[{'+
                                           '}],'+    
                               '"date_format":"MM/dd/yyyy",'+
                               '"status":"active"'+
                                '}],'+
                              '"info":{'+
                                       '"per_page":"200",'+
                                       '"count":"117",'+
                                       '"page":"1"'+
                                    //   '"more_records":"true"'+
                                       '},'+
                 '"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]'+
            '}';                 
            response.setBody(jsonbody);
            response.setStatusCode(200);
            response.setHeader('X-AUTH-TOKEN', 'aouthtoken12345');
            response.setStatus('Ok');
            return response; 
        }
    }
    @isTest static void CreateEnvelopeRequetbodyTest()
    { 
        Saf_setting__c objSettings = Saf_setting__c.getOrgDefaults();
        objSettings.saf_Docusign_clientid__c='385389435';
        upsert objSettings;
           
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        INSERT legal;
        
        /*saf_zoho__c objSettings1 = saf_zoho__c.getOrgDefaults();
        objSettings1.zoho_AccessEndpoint__c='dummy url';
        objSettings1.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings1;*/
           saf_zoho__c objSettings1 = saf_zoho__c.getOrgDefaults();
        objSettings1.client_id__c = 'Dummy client Id'; 
        objSettings1.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings1;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.clcommon__Email__c='yahoo@gmail.com';
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
        
        clcommon__Fee_Definition__c feedef=new clcommon__Fee_Definition__c();
        feedef.clcommon__Active__c=true;
        feedef.Name='Security Deposit';
        feedef.clcommon__Class__c='Income';
        feedef.clcommon__Calculation_Method__c='fixed';
        feedef.clcommon__Amount__c=998.9;
        insert feedef;
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
        genApp.Security_Deposit__c = 100;
        INSERT genApp;
        
       genesis__Equipment_Master__c eqpMas = new genesis__Equipment_Master__c();
       eqpMas.genesis__Equipment_Type__c = 'VEHICLE';
       insert eqpMas;
        
        genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
        appEqp.genesis__Application__c = acc.Id;
        appEqp.Equipment_Type__c ='Tractor';
        appEqp.genesis_Equipment_Description__c = 'test';
        appEqp.genesis_Net_Asset_Cost__c = 50000;
        appEqp.genesis_make__c ='test';
        appEqp.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp.genesis_County__c='count';
        appEqp.genesis_Street_Address__c='madiwala';
        appEqp.genesis_Equipment_Serial_Number__c='1232';
        appEqp.genesis__Application__c=genApp.id;
        appEqp.genesis__Equipment__c = eqpMas.id;
        insert appEqp;
        
       genesis__Payment_Stream__c genpyst = new genesis__Payment_Stream__c();
       genpyst.genesis__Application__c = genApp.Id;
       genpyst.genesis__Sequence__c=1;
       genpyst.genesis__Payment_Amount__c = 366.00;
       genpyst.genesis__Number_of_Payments__c = 12;
       Insert genpyst;
       genesis__Payment_Stream__c genpyst1 = new genesis__Payment_Stream__c();
       genpyst1.genesis__Application__c = genApp.Id;
       genpyst1.genesis__Sequence__c=2;
       genpyst1.genesis__Payment_Amount__c = 366.00;
       genpyst1.genesis__Number_of_Payments__c = 12;
       Insert genpyst1;
       genesis__Fee_Schedule__c genfee = new genesis__Fee_Schedule__c();
       genfee.genesis__Application__c = genApp.Id;
       genfee.genesis__Number_of_Periods__c = 1;
       genfee.genesis__Frequency__c = 'MONTHLY';
       genfee.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
       genfee.genesis__Fee_Definition__c= feedef.Id;
       genfee.genesis__Amount__c  = 300;
       Insert genfee;
        
        
        clcommon__Bank_Account__c BankAcc = new clcommon__Bank_Account__c();
        BankAcc.clcommon__Account__c=acc.id;
        BankAcc.clcommon__Bank_Account_Name__c='madina';
        BankAcc.Account_Number__c='6656756234';
        BankAcc.clcommon__Routing_Number__c='77777';
        BankAcc.clcommon__Active__c=True;
        insert BankAcc;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSignEnevelope_Mock());
        string gg=string.valueOf(acc.id);
        string ss='{"'+gg+gg+'":"'+gg+gg+'":"'+gg+gg+'"}';
        string sss=ss+':'+ss+':'+ss;
        System.debug('sss'+sss);
        Saf_DocuSignEnevelope.CreateEnvelopeRequetbody(sss,'{"objpartyId":"'+acc.Id+'"}', +string.valueof(genApp.id),+string.valueOf(acc.id));       
        //Saf_DocuSign.GetAllTemplates();
        Test.stopTest();
    }
    //Added by Megha
    @isTest static void CreateEnvelopeRequetbodyTest1()
    { 
        Saf_setting__c objSettings = Saf_setting__c.getOrgDefaults();
        objSettings.saf_Docusign_clientid__c='385389435';
        upsert objSettings;
           
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        INSERT legal;
        
        /*saf_zoho__c objSettings1 = saf_zoho__c.getOrgDefaults();
        objSettings1.zoho_AccessEndpoint__c='dummy url';
        objSettings1.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings1;*/
           saf_zoho__c objSettings1 = saf_zoho__c.getOrgDefaults();
        objSettings1.client_id__c = 'Dummy client Id'; 
        objSettings1.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings1;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.clcommon__Email__c='yahoo@gmail.com';
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
        
        clcommon__Fee_Definition__c feedef=new clcommon__Fee_Definition__c();
        feedef.clcommon__Active__c=true;
        feedef.Name='Security Deposit';
        feedef.clcommon__Class__c='Income';
        feedef.clcommon__Calculation_Method__c='fixed';
        feedef.clcommon__Amount__c=998.9;
        insert feedef;
        
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
        
       genesis__Equipment_Master__c eqpMas = new genesis__Equipment_Master__c();
       eqpMas.genesis__Equipment_Type__c = 'VEHICLE';
       insert eqpMas;
        
        genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
        appEqp.genesis__Application__c = acc.Id;
        appEqp.Equipment_Type__c ='Tractor';
        appEqp.genesis_Equipment_Description__c = 'test';
        appEqp.genesis_Net_Asset_Cost__c = 50000;
        appEqp.genesis_make__c ='test';
        appEqp.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp.genesis_County__c='count';
        appEqp.genesis_Street_Address__c='madiwala';
        appEqp.genesis_Equipment_Serial_Number__c='1232';
        appEqp.genesis__Application__c=genApp.id;
        appEqp.genesis__Equipment__c = eqpMas.id;
        insert appEqp;
        
       genesis__Payment_Stream__c genpyst = new genesis__Payment_Stream__c();
       genpyst.genesis__Application__c = genApp.Id;
       genpyst.genesis__Sequence__c=1;
       genpyst.genesis__Payment_Amount__c = 366.00;
       genpyst.genesis__Number_of_Payments__c = 1;
       Insert genpyst;
       genesis__Payment_Stream__c genpyst1 = new genesis__Payment_Stream__c();
       genpyst1.genesis__Application__c = genApp.Id;
       genpyst1.genesis__Sequence__c=2;
       genpyst1.genesis__Payment_Amount__c = 366.00;
       genpyst1.genesis__Number_of_Payments__c = 12;
       Insert genpyst1;
       genesis__Payment_Stream__c genpyst2 = new genesis__Payment_Stream__c();
       genpyst2.genesis__Application__c = genApp.Id;
       genpyst2.genesis__Sequence__c=3;
       genpyst2.genesis__Payment_Amount__c = 366.00;
       genpyst2.genesis__Number_of_Payments__c = 12;
       Insert genpyst2;
       genesis__Fee_Schedule__c genfee = new genesis__Fee_Schedule__c();
       genfee.genesis__Application__c = genApp.Id;
       genfee.genesis__Number_of_Periods__c = 1;
       genfee.genesis__Frequency__c = 'MONTHLY';
       genfee.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
       genfee.genesis__Fee_Definition__c= feedef.Id;
       genfee.genesis__Amount__c  = 300;
       Insert genfee;
        
        
        clcommon__Bank_Account__c BankAcc = new clcommon__Bank_Account__c();
        BankAcc.clcommon__Account__c=acc.id;
        BankAcc.clcommon__Bank_Account_Name__c='madina';
        BankAcc.Account_Number__c='6656756234';
        BankAcc.clcommon__Routing_Number__c='77777';
        BankAcc.clcommon__Active__c=True;
        insert BankAcc;
        
       Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSignEnevelope_Mock());
        string gg=string.valueOf(acc.id);
        string ss='{"'+gg+gg+'":"'+gg+gg+'":"'+gg+gg+'"}';
        string sss=ss+':'+ss+':'+ss;
        System.debug('sss'+sss);
        
        Saf_DocuSignEnevelope.CreateEnvelopeRequetbody(sss,'{"objpartyId":"'+acc.Id+'"}', +string.valueof(genApp.id),+string.valueOf(acc.id));       
        //Saf_DocuSign.GetAllTemplates();
        Test.stopTest();
    }
    //Megha Code End here
    @isTest static void GetAllTemplates_Test()
    { 
       Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSignEnevelope_Mock());
        
        Saf_DocuSign.GetAllTemplates();
        Test.stopTest();
    }
    @isTest static void CreateEnvelopeRequetbodyelseTest()
    { 
        Saf_setting__c objSettings = Saf_setting__c.getOrgDefaults();
        objSettings.saf_Docusign_clientid__c='385389435';
        upsert objSettings; 
           
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        INSERT legal;
        
        saf_zoho__c objSettings1 = saf_zoho__c.getOrgDefaults();
        objSettings1.zoho_AccessEndpoint__c='dummy url';
        objSettings1.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings1;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.clcommon__Email__c='yahoo@gmail.com';
        INSERT acc;
        
        //List<String> names = new List<String> {'Finance Lease'};
        List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = 'Hire Purchase';
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
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;
        
        clcommon__Fee_Definition__c feedef=new clcommon__Fee_Definition__c();
        feedef.clcommon__Active__c=true;
        feedef.Name='Security Deposit';
        feedef.clcommon__Class__c='Income';
        feedef.clcommon__Calculation_Method__c='fixed';
        feedef.clcommon__Amount__c=998.9;
        insert feedef;
              
        UPDATE dummyLP;
        //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 1200;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'Hire Purchase';
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
        
       genesis__Equipment_Master__c eqpMas = new genesis__Equipment_Master__c();
       eqpMas.genesis__Equipment_Type__c = 'VEHICLE';
       insert eqpMas;
        
        genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
        appEqp.genesis__Application__c = acc.Id;
        appEqp.Equipment_Type__c ='Tractor';
        appEqp.genesis_Equipment_Description__c = 'test';
        appEqp.genesis_Net_Asset_Cost__c = 50000;
        appEqp.genesis_make__c ='test';
        appEqp.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp.genesis_County__c='count';
        appEqp.genesis_Street_Address__c='madiwala';
        appEqp.genesis_Equipment_Serial_Number__c='1232';
        appEqp.genesis__Application__c=genApp.id;
        appEqp.genesis__Equipment__c = eqpMas.id;
        insert appEqp;
        
        genesis__Application_Equipment__c appEqp3 = new genesis__Application_Equipment__c();
        appEqp3.genesis__Application__c = acc.Id;
        appEqp3.Equipment_Type__c ='Tractor';
        appEqp3.genesis_Equipment_Description__c = 'test';
        appEqp3.genesis_Net_Asset_Cost__c = 50000;
        appEqp3.genesis_make__c ='test';
        appEqp3.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp3.genesis_County__c='count';
        appEqp3.genesis_Street_Address__c='madiwala';
        appEqp3.genesis_Equipment_Serial_Number__c='1232';
        appEqp3.genesis__Application__c=genApp.id;
        appEqp3.genesis__Equipment__c = eqpMas.id;
        insert appEqp3;
        
        genesis__Application_Equipment__c appEqp2 = new genesis__Application_Equipment__c();
        appEqp2.genesis__Application__c = acc.Id;
        appEqp2.Equipment_Type__c ='Tractor';
        appEqp2.genesis_Equipment_Description__c = 'test';
        appEqp2.genesis_Net_Asset_Cost__c = 50000;
        appEqp2.genesis_make__c ='test';
        appEqp2.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp2.genesis_County__c='count';
        appEqp2.genesis_Street_Address__c='madiwala';
        appEqp2.genesis_Equipment_Serial_Number__c='1232';
        appEqp2.genesis__Application__c=genApp.id;
        appEqp2.genesis__Equipment__c = eqpMas.id;
        insert appEqp2;
        
        genesis__Application_Equipment__c appEqp1 = new genesis__Application_Equipment__c();
        appEqp1.genesis__Application__c = acc.Id;
        appEqp1.Equipment_Type__c ='Tractor';
        appEqp1.genesis_Equipment_Description__c = 'test';
        appEqp1.genesis_Net_Asset_Cost__c = 50000;
        appEqp1.genesis_make__c ='test';
        appEqp1.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp1.genesis_County__c='count';
        appEqp1.genesis_Street_Address__c='madiwala';
        appEqp1.genesis_Equipment_Serial_Number__c='1232';
        appEqp1.genesis__Application__c=genApp.id;
        appEqp1.genesis__Equipment__c = eqpMas.id;
        insert appEqp1;
        
       genesis__Payment_Stream__c genpyst = new genesis__Payment_Stream__c();
       genpyst.genesis__Application__c = genApp.Id;
       genpyst.genesis__Sequence__c=1;
       genpyst.genesis__Payment_Amount__c = 366.00;
       genpyst.genesis__Number_of_Payments__c = 12;
       Insert genpyst;
        
       genesis__Payment_Stream__c genpyst1 = new genesis__Payment_Stream__c();
       genpyst1.genesis__Application__c = genApp.Id;
       genpyst1.genesis__Sequence__c=1;
       genpyst1.genesis__Payment_Amount__c = 366.00;
       genpyst1.genesis__Number_of_Payments__c = 12;
       Insert genpyst1;
        
        
      genesis__Payment_Stream__c genpyst2 = new genesis__Payment_Stream__c();
       genpyst2.genesis__Application__c = genApp.Id;
       genpyst2.genesis__Sequence__c=1;
       genpyst2.genesis__Payment_Amount__c = 366.00;
       genpyst2.genesis__Number_of_Payments__c = 12;
       Insert genpyst2;
        
          genesis__Payment_Stream__c genpyst3 = new genesis__Payment_Stream__c();
       genpyst3.genesis__Application__c = genApp.Id;
       genpyst3.genesis__Sequence__c=1;
       genpyst3.genesis__Payment_Amount__c = 366.00;
       genpyst3.genesis__Number_of_Payments__c = 12;
       Insert genpyst3;
        
          genesis__Payment_Stream__c genpyst4 = new genesis__Payment_Stream__c();
       genpyst4.genesis__Application__c = genApp.Id;
       genpyst4.genesis__Sequence__c=1;
       genpyst4.genesis__Payment_Amount__c = 366.00;
       genpyst4.genesis__Number_of_Payments__c = 12;
       Insert genpyst4;
       
       genesis__Fee_Schedule__c genfee = new genesis__Fee_Schedule__c();
       genfee.genesis__Application__c = genApp.Id;
       genfee.genesis__Number_of_Periods__c = 1;
       genfee.genesis__Frequency__c = 'MONTHLY';
       genfee.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
       genfee.genesis__Fee_Definition__c= feedef.Id;
       genfee.genesis__Amount__c  = 350;
       Insert genfee;
        
        clcommon__Bank_Account__c BankAcc = new clcommon__Bank_Account__c();
        BankAcc.clcommon__Account__c=acc.id;
        BankAcc.clcommon__Bank_Account_Name__c='madina';
        BankAcc.Account_Number__c='6656756234';
        BankAcc.clcommon__Routing_Number__c='77777';
        BankAcc.clcommon__Active__c=True;
        insert BankAcc;
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSignEnevelope_Mock());
        string gg=string.valueOf(acc.id);
        string ss='{"'+gg+gg+'":"'+gg+gg+'":"'+gg+gg+'"}';
        string sss=ss+':'+ss+':'+ss;
        System.debug('sss'+sss);
        Saf_DocuSignEnevelope.CreateEnvelopeRequetbody(sss,'{"objpartyId":"'+acc.Id+'"}', +string.valueof(genApp.id),+string.valueOf(acc.id));       
       
        Test.stopTest();
    }
    //Added by Megha
    @isTest static void CreateEnvelopeRequetbodyelseTest1()
    { 
        Saf_setting__c objSettings = Saf_setting__c.getOrgDefaults();
        objSettings.saf_Docusign_clientid__c='385389435';
        upsert objSettings; 
           
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        INSERT legal;
        
        saf_zoho__c objSettings1 = saf_zoho__c.getOrgDefaults();
        objSettings1.zoho_AccessEndpoint__c='dummy url';
        objSettings1.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings1;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.clcommon__Email__c='yahoo@gmail.com';
        INSERT acc;
        
        //List<String> names = new List<String> {'Finance Lease'};
        List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = 'Hire Purchase';
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
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;
        
        clcommon__Fee_Definition__c feedef=new clcommon__Fee_Definition__c();
        feedef.clcommon__Active__c=true;
        feedef.Name='Security Deposit';
        feedef.clcommon__Class__c='Income';
        feedef.clcommon__Calculation_Method__c='fixed';
        feedef.clcommon__Amount__c=998.9;
        insert feedef;
              
        UPDATE dummyLP;
        //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 1200;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'Hire Purchase';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
        genApp.genesis__Account__c = acc.Id;
        genApp.Security_Deposit__c = 100;
        INSERT genApp;
        
       genesis__Equipment_Master__c eqpMas = new genesis__Equipment_Master__c();
       eqpMas.genesis__Equipment_Type__c = 'VEHICLE';
       insert eqpMas;
        
        genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
        appEqp.genesis__Application__c = acc.Id;
        appEqp.Equipment_Type__c ='Tractor';
        appEqp.genesis_Equipment_Description__c = 'test';
        appEqp.genesis_Net_Asset_Cost__c = 50000;
        appEqp.genesis_make__c ='test';
        appEqp.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp.genesis_County__c='count';
        appEqp.genesis_Street_Address__c='madiwala';
        appEqp.genesis_Equipment_Serial_Number__c='1232';
        appEqp.genesis__Application__c=genApp.id;
        appEqp.genesis__Equipment__c = eqpMas.id;
        insert appEqp;
        
        genesis__Application_Equipment__c appEqp3 = new genesis__Application_Equipment__c();
        appEqp3.genesis__Application__c = acc.Id;
        appEqp3.Equipment_Type__c ='Tractor';
        appEqp3.genesis_Equipment_Description__c = 'test';
        appEqp3.genesis_Net_Asset_Cost__c = 50000;
        appEqp3.genesis_make__c ='test';
        appEqp3.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp3.genesis_County__c='count';
        appEqp3.genesis_Street_Address__c='madiwala';
        appEqp3.genesis_Equipment_Serial_Number__c='1232';
        appEqp3.genesis__Application__c=genApp.id;
        appEqp3.genesis__Equipment__c = eqpMas.id;
        insert appEqp3;
        
        genesis__Application_Equipment__c appEqp2 = new genesis__Application_Equipment__c();
        appEqp2.genesis__Application__c = acc.Id;
        appEqp2.Equipment_Type__c ='Tractor';
        appEqp2.genesis_Equipment_Description__c = 'test';
        appEqp2.genesis_Net_Asset_Cost__c = 50000;
        appEqp2.genesis_make__c ='test';
        appEqp2.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp2.genesis_County__c='count';
        appEqp2.genesis_Street_Address__c='madiwala';
        appEqp2.genesis_Equipment_Serial_Number__c='1232';
        appEqp2.genesis__Application__c=genApp.id;
        appEqp2.genesis__Equipment__c = eqpMas.id;
        insert appEqp2;
        
        genesis__Application_Equipment__c appEqp1 = new genesis__Application_Equipment__c();
        appEqp1.genesis__Application__c = acc.Id;
        appEqp1.Equipment_Type__c ='Tractor';
        appEqp1.genesis_Equipment_Description__c = 'test';
        appEqp1.genesis_Net_Asset_Cost__c = 50000;
        appEqp1.genesis_make__c ='test';
        appEqp1.genesis_Vehicle_Chassis_Number__c='2342432';
        appEqp1.genesis_County__c='count';
        appEqp1.genesis_Street_Address__c='madiwala';
        appEqp1.genesis_Equipment_Serial_Number__c='1232';
        appEqp1.genesis__Application__c=genApp.id;
        appEqp1.genesis__Equipment__c = eqpMas.id;
        insert appEqp1;
        
       genesis__Payment_Stream__c genpyst = new genesis__Payment_Stream__c();
       genpyst.genesis__Application__c = genApp.Id;
       genpyst.genesis__Sequence__c=1;
       genpyst.genesis__Payment_Amount__c = 366.00;
       genpyst.genesis__Number_of_Payments__c = 1;
       Insert genpyst;
        
          genesis__Payment_Stream__c genpyst1 = new genesis__Payment_Stream__c();
       genpyst1.genesis__Application__c = genApp.Id;
       genpyst1.genesis__Sequence__c=2;
       genpyst1.genesis__Payment_Amount__c = 366.00;
       genpyst1.genesis__Number_of_Payments__c = 12;
       Insert genpyst1;
        
        
      genesis__Payment_Stream__c genpyst2 = new genesis__Payment_Stream__c();
       genpyst2.genesis__Application__c = genApp.Id;
       genpyst2.genesis__Sequence__c=3;
       genpyst2.genesis__Payment_Amount__c = 366.00;
       genpyst2.genesis__Number_of_Payments__c = 12;
       Insert genpyst2;
        
        /*  genesis__Payment_Stream__c genpyst3 = new genesis__Payment_Stream__c();
       genpyst3.genesis__Application__c = genApp.Id;
       genpyst3.genesis__Sequence__c=1;
       genpyst3.genesis__Payment_Amount__c = 366.00;
       genpyst3.genesis__Number_of_Payments__c = 12;
       Insert genpyst3;
        
          genesis__Payment_Stream__c genpyst4 = new genesis__Payment_Stream__c();
       genpyst4.genesis__Application__c = genApp.Id;
       genpyst4.genesis__Sequence__c=1;
       genpyst4.genesis__Payment_Amount__c = 366.00;
       genpyst4.genesis__Number_of_Payments__c = 12;
       Insert genpyst4; */
       
       genesis__Fee_Schedule__c genfee = new genesis__Fee_Schedule__c();
       genfee.genesis__Application__c = genApp.Id;
       genfee.genesis__Number_of_Periods__c = 1;
       genfee.genesis__Frequency__c = 'MONTHLY';
       genfee.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
       genfee.genesis__Fee_Definition__c= feedef.Id;
       genfee.genesis__Amount__c  = 350;
       Insert genfee;
        
        clcommon__Bank_Account__c BankAcc = new clcommon__Bank_Account__c();
        BankAcc.clcommon__Account__c=acc.id;
        BankAcc.clcommon__Bank_Account_Name__c='madina';
        BankAcc.Account_Number__c='6656756234';
        BankAcc.clcommon__Routing_Number__c='77777';
        BankAcc.clcommon__Active__c=True;
        insert BankAcc;
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSignEnevelope_Mock());
        string gg=string.valueOf(acc.id);
        string ss='{"'+gg+gg+'":"'+gg+gg+'":"'+gg+gg+'"}';
        string sss=ss+':'+ss+':'+ss;
        System.debug('sss'+sss);
        Saf_DocuSignEnevelope.CreateEnvelopeRequetbody(sss,'{"objpartyId":"'+acc.Id+'"}', +string.valueof(genApp.id),+string.valueOf(acc.id));       
       
        Test.stopTest();
    }
}