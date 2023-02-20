@IsTest
public class DocumentUploadClass_Test{

     //Setting Mock response
    public class SharePointControllermock implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{}');
            response.setStatusCode(200);
            response.setHeader('X-AUTH-TOKEN', 'aouthtoken12345');
            response.setStatus('Ok');
            return response; 
        }
    }
    @isTest static void docuploadTest() {
    
        Account a = new Account();
        a.Name = 'TestAccount';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Landline__c='12345 123456';
        insert a;
       
       genesis__Applications__c app = new genesis__Applications__c();
     
       app.genesis__Account__c = a.Id;
       app.genesis__Expected_Start_Date__c = Date.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app.genesis__Sales_Division__c = 'DIRECT';
       app.genesis__Payment_Frequency__c = 'MONTHLY';
       app.genesis__Financed_Amount__c = 123;
       app.genesis__Status__c ='PROPOSAL';
       app.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       insert app;
       
       Attachment att = new Attachment();
       att.Name = 'Test.png';
       att.parentId = app.Id;
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob;
       insert att;
       
       Attachment attRec = [select id, name, ContentType, BodyLength, Body from Attachment where id =: att.id];
        string attachid = attRec.id;
       string filePathUrl = '/Test/123/Test.png';
       HttpRequest request = new HttpRequest();

       test.startTest();
       
       Test.setMock(HttpCalloutMock.class, new SharePointControllermock()); 
       
       DocumentUploadClass.processSharePoint(filePathUrl,attachid);
       
       test.stopTest();
       
  }

}