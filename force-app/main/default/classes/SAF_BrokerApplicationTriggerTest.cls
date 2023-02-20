@isTest
public class SAF_BrokerApplicationTriggerTest
{
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
     @isTest public static void resultTest()
    {   
    
    
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
        
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_AccessEndpoint__c = 'FAKE_ZOHO_END_POINT';
        objSettings.zoho_CretaOppEndpoint__c='hhjhs';
        objSettings.saf_getZohoAccount__c='hghsaas';
        upsert objSettings;     
      
        Account acc = new Account();     
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.Type='Broker';
        INSERT acc;
   
        //Create Application
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

        List<id> applicationids=new List<id>();
        applicationids.add(genApp.id);
        genesis__Applications__c app = [SELECT id,genesis__Interest_Rate__c,Security_Deposit__c,genesis__Description__c FROM genesis__Applications__c WHERE Id =:genApp.Id ];
        app.genesis__Interest_Rate__c = 12;
        app.Security_Deposit__c=132;
        app.genesis__Description__c='hgfsahbjfdsdsjbfjgfd';
        
        Test.startTest();
        UPDATE app;
        Saf_ZohoApplications.CreateInZoho(applicationids, false);   
        Test.setMock(HttpCalloutMock.class,new Saf_ZohoUnderWritingMock());
        Test.stopTest();        
    }
}