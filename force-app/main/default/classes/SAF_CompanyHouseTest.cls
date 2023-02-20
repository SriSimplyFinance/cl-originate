@isTest
    private class SAF_CompanyHouseTest {
        @isTest static  void CompanyHouseTestCallout(){
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
               RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/company/gb/10672557/group-parents'; 
        req.httpMethod = 'GET';
       RestContext.request=req;
        RestContext.response=res;
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.AccessToken__c = '123';
            upsert objSettings;
            
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
           
        List<string> lst = new List<string>();
        lst.add('0031x000011SPHW');
        SAF_CompanyHouse.fetchKycAccessToken(true);
        Test.stopTest();
           /* Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.AccessToken__c =null;
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            upsert objSettings;*/
   // HttpResponse response = new HttpResponse();
     //       response.
            //SAF_CompanyHouse.processResponse(Relationresp);
            SAF_CompanyHouse.fetchKycAccessToken(true);
     }
             
     @isTest static void test3()
    {
        
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'fail';
            objSettings.Password__c = 'fail';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.AccessToken__c = null;
            upsert objSettings;
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new SAF_ClsToZoho_Mock());              
        String result = SAF_CompanyHouse.fetchKycAccessToken(true); 
        Test.stopTest();
      // System.assertEquals(null, result);
    }        
             
             
}