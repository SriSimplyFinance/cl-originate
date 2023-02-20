@isTest
private class Test_Custom_DocumentUploadToSharePoint{
    @isTest 
    static void Test_Custom_DocumentUploadToSharePoint() {
             
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

        genesis__Applications__c application = new genesis__Applications__c();
        //application.RecordTypeId = applicationRecordTypes.get('LEASE');
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        application.genesis__Loan_Amount__c = 6700;
        application.genesis__company__c = genesis.TestHelper.createCompany().Id;
        application.genesis__Collateral_Value__c= 6700;
        application.genesis__Estimated_Selling_Price__c = 6700;
        application.genesis__Fees_Amount__c =0;
        application.genesis__Expected_Start_Date__c = Date.today();
        application.genesis__Warranty_Amount__c=0;
        application.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        application.genesis__Tax_Amount__c=0;
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;
        application.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
        application.genesis__Days_Convention__c = '30/360';
        application.genesis__Landing_Sequence__c = 3;
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        application.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
        application.genesis__Account__c = acc.Id;
        insert application;
      
        
        Attachment att = new Attachment();
        att.parentId = application.id;
        att.Name = 'Test.png';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob;
        insert att;
        
        genesis__Document_Category__c docCat = new genesis__Document_Category__c();
        docCat.genesis__Category_Name__c= 'Root';
        insert docCat;
        
        genesis__Document_Category__c docCat1 = new genesis__Document_Category__c();
        docCat1.genesis__Category_Name__c= 'Proposal';
        docCat1.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat1;
        
        genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat.genesis__Application__c = application.Id;
        appDocCat.genesis__Document_Category__c = docCat.Id;
        appDocCat.Name = docCat1.genesis__Category_Name__c;
        insert appDocCat;        
        
        SAF_Custom_DocumentUploadToSharePoint.sendApplicationDocToSharePointCustom(appDocCat.Name,att.id,application.id);
        Test.setMock(HttpCalloutMock.class, new SAF_SharePointController_Test.SharePointControllermock());
        SAF_Custom_FolderCreation.sendApplicationDocToSharePointCustom(application.id);
        try
        {
        Attachment att1 = new Attachment();
        att1.parentId = application.id;
        att1.Name = 'Test.txt';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        att1.body=bodyBlob1;
        insert att1;
        }
        catch(Exception e)
        {
        SAF_Custom_DocumentUploadToSharePoint.sendFailureEmail('Txt file not allowed','Test.txt');
        }
    
    }
    public class SharePointControllermock implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
           // response.setBody('{}');
            response.setStatusCode(200);
            response.setHeader('X-AUTH-TOKEN', 'aouthtoken12345');
            response.setStatus('Ok');
            return response; 
        }
    }
    
    
}