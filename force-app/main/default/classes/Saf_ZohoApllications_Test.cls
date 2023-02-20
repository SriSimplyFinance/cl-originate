@isTest
private class Saf_ZohoApllications_Test 
{
    public class Saf_ZohoApplications_Mock implements HttpCalloutMock
    {
        public HttpResponse respond(HttpRequest request)
        {
            HttpResponse response=new httpResponse();
            response.setStatusCode(200);
            response.setStatus('Success');
            response.setHeader('Content-Type', 'application/json');
            String json='{'+       
                                      '"users":[{'+
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
            response.setBody(json);
            response.setBody(json);
            return response;
        }
    }
    
    @isTest static void resultTest()
    {    
    
        //Broker app integration settings
        SAF_BrokerApp__c Settings = SAF_BrokerApp__c.getOrgDefaults();
        Settings.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
        UPSERT Settings;
    
        Saf_CompanyHouse__c CHSettings =  Saf_CompanyHouse__c.getOrgDefaults();
        CHSettings.AccessToken__c =null;
        CHSettings.Username__c = 'Phalguni@hm.com';
        CHSettings.Password__c = 'phalguni@123';
        CHSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        CHSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        upsert CHSettings;
        
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        objSettings.zoho_CretaOppEndpoint__c='sssss';
        objSettings.saf_getZohoAccount__c='hhh';
        UPSERT objSettings;
        
        List<Saf_ZohoApplicationFieldMapping__c> mcs = Saf_ZohoApplicationFieldMapping__c.getall().values();
        Saf_ZohoApplicationFieldMapping__c   m1 =new Saf_ZohoApplicationFieldMapping__c();
         m1.Salesforce_Field__c='support_owner__c';
        m1.Zoho_Fields__c=' Sales_Support_Owner';
        m1.Name='Sales Support Owner';
        upsert m1;
        mcs.add(m1);        
        Saf_ZohoApplicationFieldMapping__c   m2 =new Saf_ZohoApplicationFieldMapping__c();
        m2.Salesforce_Field__c='genesis_proposalowner__c';
        m2.Zoho_Fields__c=' Owner';
        m2.Name='Sales Owner';
        upsert m2;
        mcs.add(m2);
        
        Saf_ZohoApplicationFieldMapping__c   m3 =new Saf_ZohoApplicationFieldMapping__c();
        m3.Salesforce_Field__c='genesis__expected_start_date__c';
        m3.Zoho_Fields__c='Proposed_Drawdown_Date';
        m3.Name='me Proposed Drawdown Date';
        upsert m3;
        mcs.add(m3);
        
        Saf_ZohoApplicationFieldMapping__c   m4 =new Saf_ZohoApplicationFieldMapping__c();
        m4.Salesforce_Field__c='Application_link__c';
        m4.Zoho_Fields__c=' Application_Link';
        m4.Name='Application Link';
        upsert m4;
        mcs.add(m4);        
        
        Saf_ZohoApplicationFieldMapping__c   m5 =new Saf_ZohoApplicationFieldMapping__c();
        m5.Salesforce_Field__c='genesis__cl_product__c';
        m5.Zoho_Fields__c='Product';
        m5.Name='Product';
        upsert m5;
        mcs.add(m5);          
        
        Saf_ZohoApplicationFieldMapping__c   m6 =new Saf_ZohoApplicationFieldMapping__c();
        m6.Salesforce_Field__c='introducer1__c';
        m6.Zoho_Fields__c='Introducer';
        m6.Name='Introducer';
        upsert m6;
        mcs.add(m6); 
        
        Saf_ZohoApplicationFieldMapping__c   m7 =new Saf_ZohoApplicationFieldMapping__c();
        m7.Salesforce_Field__c='genesis__Account__c';
        m7.Zoho_Fields__c='Account_Name';
        m7.Name='Account Name';
        upsert m7;
        mcs.add(m7); 
        
        Account acc = new Account();     
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.Type='Broker';
        //acc.SIC_Code_Number__c=6576575;

        INSERT acc;
        
       List<String> names = new List<String> {'Operating Lease'};
       // List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = ' Operating Lease ';
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
        /* cllease.TestHelper.createOffice('Test Office', true);
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
        UPDATE dummyLP;*/
        
        //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 12000;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = date.newInstance(2019, 12, 12);
        genApp.genesis__Account__c = acc.Id; 
        genApp.Introducer1__c=acc.Id;
        INSERT genApp; 
        
        List<id> appllicationids=new List<id>();
        appllicationids.add(genApp.id);
        
        genesis__Applications__c app = [SELECT genesis__Interest_Rate__c FROM genesis__Applications__c WHERE Id =:genApp.Id ];
        app.genesis__Interest_Rate__c = 12;
        
        Test.startTest();
        Saf_ZohoApplications.CreateInZoho(appllicationids, false);  
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoApplications_Mock());
        Test.stopTest();        
    }
    
    @isTest static void updateTest()
    {
        
        //Broker app integration settings
        SAF_BrokerApp__c Settings = SAF_BrokerApp__c.getOrgDefaults();
        Settings.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
        UPSERT Settings;
        
        //KYC-CL integration settings
        Saf_CompanyHouse__c CHSettings =  Saf_CompanyHouse__c.getOrgDefaults();
        CHSettings.AccessToken__c =null;
        CHSettings.Username__c = 'Phalguni@hm.com';
        CHSettings.Password__c = 'phalguni@123';
        CHSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        CHSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        upsert CHSettings;
    
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        objSettings.zoho_CretaOppEndpoint__c='sssss';
         objSettings.saf_getZohoAccount__c='hhh';
        UPSERT objSettings;
        
        List<Saf_ZohoApplicationFieldMapping__c> mcs = Saf_ZohoApplicationFieldMapping__c.getall().values();
        Saf_ZohoApplicationFieldMapping__c   m1 =new Saf_ZohoApplicationFieldMapping__c();
        m1.Salesforce_Field__c='support_owner__c';
        m1.Zoho_Fields__c=' Sales_Support_Owner';
        m1.Name='Sales Support Owner';
        upsert m1;
        mcs.add(m1);        
        Saf_ZohoApplicationFieldMapping__c   m2 =new Saf_ZohoApplicationFieldMapping__c();
        m2.Salesforce_Field__c='genesis_proposalowner__c';
        m2.Zoho_Fields__c=' Owner';
        m2.Name='Sales Owner';
        upsert m2;
        mcs.add(m2);
        
        Saf_ZohoApplicationFieldMapping__c   m3 =new Saf_ZohoApplicationFieldMapping__c();
        m3.Salesforce_Field__c='genesis__expected_start_date__c';
        m3.Zoho_Fields__c='Proposed_Drawdown_Date';
        m3.Name='me Proposed Drawdown Date';
        upsert m3;
        mcs.add(m3);
        
        Saf_ZohoApplicationFieldMapping__c   m4 =new Saf_ZohoApplicationFieldMapping__c();
        m4.Salesforce_Field__c='Application_link__c';
        m4.Zoho_Fields__c=' Application_Link';
        m4.Name='Application Link';
        upsert m4;
        mcs.add(m4);        
        
        Saf_ZohoApplicationFieldMapping__c   m5 =new Saf_ZohoApplicationFieldMapping__c();
        m5.Salesforce_Field__c='genesis__cl_product__c';
        m5.Zoho_Fields__c='Product';
        m5.Name='Product';
        upsert m5;
        mcs.add(m5);          
        
        Saf_ZohoApplicationFieldMapping__c   m6 =new Saf_ZohoApplicationFieldMapping__c();
        m6.Salesforce_Field__c='introducer1__c';
        m6.Zoho_Fields__c='Introducer';
        m6.Name='Introducer';
        upsert m6;
        mcs.add(m6); 
        
        Saf_ZohoApplicationFieldMapping__c   m7 =new Saf_ZohoApplicationFieldMapping__c();
        m7.Salesforce_Field__c='genesis__Account__c';
        m7.Zoho_Fields__c='Account_Name';
        m7.Name='Account Name';
        upsert m7;
        mcs.add(m7);        
        
        Account acc = new Account();     
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.Type='Broker';
        INSERT acc;
        
       List<String> names = new List<String> {'Operating Lease'};
       // List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = ' Operating Lease ';
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
       /*  cllease.TestHelper.createOffice('Test Office', true);
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
        UPDATE dummyLP; */
        
        //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 12000;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = date.newInstance(2019, 12, 12);
        genApp.genesis__Account__c = acc.Id;
        genApp.Introducer1__c= acc.id;
        INSERT genApp;
        
        genesis__Applications__c app = [SELECT genesis__Interest_Rate__c FROM genesis__Applications__c WHERE Id =:genApp.Id ];
        app.genesis__Interest_Rate__c = 12;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoApplications_Mock());  
        update app;        
        Test.stopTest();
    }
}