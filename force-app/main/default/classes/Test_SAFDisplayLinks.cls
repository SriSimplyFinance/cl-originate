@isTest
private class Test_SAFDisplayLinks {
    @isTest 
    static void Test_SAFDisplayLinks1() {
       clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        SFDCSharepointFileUpload__c setting = new SFDCSharepointFileUpload__c();
        setting.In_Life__c = 'In Life';
      setting.Proposal__c ='Proposal';
      setting.Third_Party_Documents__c='Third Party Documents';
      setting.FilePathForThirdPartyDocs__c='/Third Party Documents';
      setting.File_Path_For_ThirdParty_InLife__c='/Third Party Documents/App/In Life';
      setting.File_Path_For_ThirdParty_Proposal__c='/Third Party Documents/App/Proposal';
      setting.Microsoft_Files__c = 'doc';
      setting.Microsoft_Files__c = 'docx';
      setting.Microsoft_Files__c = 'xls';
      setting.Microsoft_Files__c = 'xlsx';
      insert setting;

      
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
        
        string filePathUrl = '/Test/123/Test.png';
        string url = '/Test/123/Test.png###123';
       // String fileName = 'Test.doc';
        
        Attachment att = new Attachment();
        att.parentId = application.id;
        att.Name = 'Test.png';
        Blob bodyBlob=Blob.valueOf('Attachment Body');
        att.body=bodyBlob;
        insert att;
        
        string fileFolder = 'In Life';
        
        SAF_Document_Links__c docLink = new SAF_Document_Links__c();
        docLink.Application__c = application.id;
        docLink.Name = 'In Life';
        docLink.Document_Path__c ='test';
        docLink.File_Name__c = 'Test';
        insert docLink;
        
         SAF_Document_Links__c docLink1 = new SAF_Document_Links__c();
        docLink1.Application__c = application.id;
        docLink1.Name = 'Proposal';
        docLink1.Document_Path__c ='test';
        docLink1.File_Name__c = 'Test';
        
        insert docLink1;
        
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAF_SharePointController_Test.SharePointControllermock());
        SAF_DisplayLinks.displayLinks(filePathUrl,url,application.Id);
        SAF_CreateSharePointController.getFileDriveId(url);
        SAF_DisplayLinks.populateThirdpartyDocs(application.id);
        test.stopTest();
    
    } 
    
    static void Test_SAFDisplayLinks2() {
       clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        SFDCSharepointFileUpload__c setting = new SFDCSharepointFileUpload__c();
        setting.In_Life__c = 'In Life';
      setting.Proposal__c ='Proposal';
      setting.Third_Party_Documents__c='Third Party Documents';
      setting.FilePathForThirdPartyDocs__c='/Third Party Documents';
      setting.File_Path_For_ThirdParty_InLife__c='/Third Party Documents/App/In Life';
      setting.File_Path_For_ThirdParty_Proposal__c='/Third Party Documents/App/Proposal';
      setting.Microsoft_Files__c = 'doc';
      setting.Microsoft_Files__c = 'docx';
      setting.Microsoft_Files__c = 'xls';
      setting.Microsoft_Files__c = 'xlsx';
      insert setting;

      
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
        
        string filePathUrl = '/Test/123/Test.doc';
        string url = '/Test/123/Test.doc###123';
       // String fileName = 'Test.doc';
        
        Attachment att = new Attachment();
        att.parentId = application.id;
        att.Name = 'Test.png';
        Blob bodyBlob=Blob.valueOf('Attachment Body');
        att.body=bodyBlob;
        insert att;
           
        string fileFolder = 'Proposal';        
        
        SAF_Document_Links__c docLink = new SAF_Document_Links__c();
        docLink.Application__c = application.id;
        docLink.Name = 'In Life';
        docLink.Document_Path__c ='test';
        docLink.File_Name__c = 'Test';
        insert docLink;
        
         SAF_Document_Links__c docLink1 = new SAF_Document_Links__c();
        docLink1.Application__c = application.id;
        docLink1.Name = 'Proposal';
        docLink1.Document_Path__c ='test';
        docLink1.File_Name__c = 'Test';
        
        insert docLink1;
        
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAF_SharePointController_Test.SharePointControllermock());
        SAF_DisplayLinks.displayLinks(filePathUrl,url,application.Id);
        SAF_CreateSharePointController.getFileDriveId(url);
        SAF_DisplayLinks.populateThirdpartyDocs(application.id);
        test.stopTest();
    
    } 
    }