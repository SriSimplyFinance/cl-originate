@isTest
public class SAF_ZohoAPIControllerTest {
    
    public class SAF_ZohoAPIControllerMock implements HttpCalloutMock {
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

    @isTest static void verifyZohoAPICallsTest(){
         saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.zoho_AccessEndpoint__c='dummy url';
        objSettings.zoho_CretaOppEndpoint__c='dummy_access_url';
        objSettings.saf_getZohoAccount__c='sfdc dummy_access_url';
        upsert objSettings;
        
        SAF_BrokerApp__c brokerSettings = SAF_BrokerApp__c.getOrgDefaults();
            brokerSettings.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
            UPSERT brokerSettings;
        
         Saf_CompanyHouse__c objCompHouse =  Saf_CompanyHouse__c.getOrgDefaults();
            objCompHouse.AccessToken__c =null;
            objCompHouse.Username__c = 'Phalguni@hm.com';
            objCompHouse.Password__c = 'phalguni@123';
            objCompHouse.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objCompHouse.AccessToken__c = '123';
            objCompHouse.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objCompHouse.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objCompHouse.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            upsert objCompHouse;
        
        List<string> lst = new List<string>();
            lst.add('0011x00001ByXxJ');
            SAF_ContactsUtils.UpdateNewCustomerToDB(lst);
            SAF_CompanyHouse.fetchKycAccessToken(true);
        
        Account acc = new Account();     
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.Type='Broker';
        INSERT acc;
         
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 12000;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';        
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Dealer_Payment_Date__c= date.newInstance(2019, 12, 12);
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = date.newInstance(2019, 12, 12);
        genApp.genesis__Account__c = acc.Id; 
        genApp.Introducer1__c=acc.Id;    
        INSERT genApp;
        List<String> applicationId = new List<String>{genApp.Id};
        List<Saf_ZohoAPIController.Zoho_Details> zohoDetailsList = new List<Saf_ZohoAPIController.Zoho_Details>();
		Saf_ZohoAPIController.Zoho_Details zohoDetailsObj = new Saf_ZohoAPIController.Zoho_Details();
        zohoDetailsObj.appId = applicationId;
        zohoDetailsObj.iscreate = False;
        zohoDetailsList.add(zohoDetailsObj);
        
        Test.startTest();
       
        Test.setMock(HttpCalloutMock.class, new SAF_ZohoAPIControllerMock());
        Saf_ZohoAPIController.verifyZohoAPICalls(zohoDetailsList);
        Test.stopTest();

    }
    
		
}