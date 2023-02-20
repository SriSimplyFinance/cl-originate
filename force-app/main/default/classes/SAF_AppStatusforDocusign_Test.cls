@isTest
private class SAF_AppStatusforDocusign_Test 
{
    @istest static void testDocuSignAppStat()
    {   
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        objSettings.zoho_CretaOppEndpoint__c='sssss';
        objSettings.zoho_AccessEndpoint__c='dummy url';
       
        UPSERT objSettings;
         
         Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.saf_Docusign_clientid__c='385389435';
        upsert objSettings1; 
        
        Account a = new Account();
        a.Name = 'MyTestAccount';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Landline__c='12345 123456';
        insert a;
        
        genesis__Applications__c app = new genesis__Applications__c();   
        app.genesis__Account__c = a.Id;
        app.genesis__Expected_Start_Date__c = Date.Today();
        app.genesis__Sales_Division__c = 'DIRECT';
        app.genesis__Payment_Frequency__c = 'MONTHLY';
        app.genesis__Financed_Amount__c = 123;
        app.genesis__Status__c ='DOCUMENTS RAISED';
        app.genesis__Term__c =12;
        insert app;
        
        dsfs__DocuSign_Status__c dds =new dsfs__DocuSign_Status__c();
        dds.dsfs__Subject__c = 'Test Email Subject';
        dds.dsfs__Envelope_Status__c = 'Sent';
        dds.dsfs__DocuSign_Envelope_ID__c = '7AE9BBF8-D10E-4ACC-8341-B78E5C9DF207';
       insert dds;
    
      Saf_Docusign_Application__c sda = new Saf_Docusign_Application__c();    
        sda.Name = 'Test Document Sign';
        sda.saf_Application__c = app.Id;
        sda.saf_EnvelopeId__c = '7AE9BBF8-D10E-4ACC-8341-B78E5C9DF207';
        sda.saf_Status__c = 'Created';
      
        
        dds.dsfs__Envelope_Status__c = 'Completed';
       
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSignEnevelope_Mock());
        
        
         insert sda;
         UPDATE dds;
        Test.stopTest();
    }
}