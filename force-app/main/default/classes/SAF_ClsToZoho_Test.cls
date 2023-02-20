@isTest
private class SAF_ClsToZoho_Test 
{
    @isTest static void test1()
    {
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_AccessEndpoint__c = 'FAKE_ZOHO_END_POINT';
         upsert objSettings;
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new SAF_ClsToZoho_Mock());              
        String result = SAF_ClsToZoho.fetchZohoAccessToken(false); 
        Test.stopTest();
       System.assertEquals('bc426429ff05e9258ab32f182300efa9.89f6e7470e6a6367b1f6d5126b9efd67', result);
    }
      @isTest static void test2()
    {
        
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_AccessEndpoint__c = 'FAKE_ZOHO_END_POINT2';
         upsert objSettings;
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new SAF_ClsToZoho_Mock());              
        String result = SAF_ClsToZoho.fetchZohoAccessToken(false); 
        Test.stopTest();
       System.assertEquals('null', result);
    }
  @isTest static void test3()
    {
        
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_AccessEndpoint__c = 'fail';
         objSettings.saf_ZohoAccesstoken__c= null;
         upsert objSettings;
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new SAF_ClsToZoho_Mock());              
        String result = SAF_ClsToZoho.fetchZohoAccessToken(false); 
        Test.stopTest();
       System.assertEquals('ERROR', result);
    }
}