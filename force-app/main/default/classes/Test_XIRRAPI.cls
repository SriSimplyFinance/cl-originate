@isTest
public class Test_XIRRAPI{
  public class XIRRAPIMock implements HttpCalloutMock {
         public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('XIRR Complete');
            response.setStatusCode(200);
            response.setHeader('X-AUTH-TOKEN', 'aouthtoken12345');
            response.setStatus('Ok');
            return response; 
}}
 
 @isTest static void verifyXIRRAPICallsTest(){
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
        
        List<string> apps = new List<string>();
        apps.add(genApp.Id);
        
        Test.startTest();
       
        Test.setMock(HttpCalloutMock.class, new Saf_CompanyShareholderMockTest ());
        XIRRAPIController.verifyXIRRAPICalls(apps);
        Test.stopTest();
       
        }
        }