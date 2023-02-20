@isTest
private class Test_SAFAddDocumentCategoryToApp{
    public class Saf_ZohoUnderWritingMock implements HttpCalloutMock
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
        return response;
        }
}
    @isTest 
    static void Test_SAFAddDocumentCategoryToApp() {
        //Broker app integration settings
        SAF_BrokerApp__c Settings = SAF_BrokerApp__c.getOrgDefaults();
        Settings.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
        UPSERT Settings;
    
        //KYC integration settings
        Saf_CompanyHouse__c CHSettings =  Saf_CompanyHouse__c.getOrgDefaults();
        CHSettings.AccessToken__c =null;
        CHSettings.Username__c = 'Phalguni@hm.com';
        CHSettings.Password__c = 'phalguni@123';
        CHSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        CHSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        CHSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
        CHSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        CHSettings.UpdateContactToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/individual'; 
        upsert CHSettings;
            
        Saf_setting__c objsetting = Saf_setting__c.getOrgDefaults();
        objsetting.ACH__c='uuu';
        upsert objsetting;
        
         Test.setMock(HttpCalloutMock.class,new Saf_ZohoUnderWritingMock());
          saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_AccessEndpoint__c = 'FAKE_ZOHO_END_POINT';
        objSettings.zoho_CretaOppEndpoint__c='hhjhs';
        objSettings.saf_getZohoAccount__c='hghsaas';
        upsert objSettings; 
    
    clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
    
    Account acc = new Account(name='test account');
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
        
        genesis__Document_Category__c docCat = new genesis__Document_Category__c();
        docCat.genesis__Category_Name__c= 'Root';
        insert docCat;
        
        genesis__Document_Category__c docCat1 = new genesis__Document_Category__c();
        docCat1.genesis__Category_Name__c= 'Proposal';
        docCat1.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat1;
        
        genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
       // appDocCat.genesis__Application__c = genApp.Id;
        appDocCat.genesis__Document_Category__c = docCat.Id;
        appDocCat.Name = 'Proposal';
        insert appDocCat;
        
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 1200;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
        genApp.genesis__Account__c = acc.Id;
        
        insert genApp;
        
        
        genesis__Application_Document_Category__c appDocCat1 = new genesis__Application_Document_Category__c();
        appDocCat1.genesis__Application__c = genApp.Id;
        appDocCat1.genesis__Document_Category__c = docCat.Id;
        appDocCat1.genesis__Parent_Application_Document_Category__c = appDocCat.Id;
        appDocCat1.Name = docCat.genesis__Category_Name__c;
        insert appDocCat1;
    
    }
    
}