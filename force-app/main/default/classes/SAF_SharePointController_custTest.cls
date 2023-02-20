@IsTest
public class SAF_SharePointController_custTest {
  
   public String webUrl='test/1';
    public String uploadUrl='test/2';
    public String access_token = 'fdbsudusd';   
    public String initialResponse = ''; 

  
    //Setting Mock response
    public class SharePointController_custmock implements HttpCalloutMock {
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
     public with sharing class SharePointController_custmock1 implements HTTPCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
            res.setBody('body');
            res.setStatusCode(403);
            return res;
        }
    }
    public with sharing class SharePointController_custmock2 implements HTTPCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
            res.setBody('body');
            res.setStatusCode(200);
            return res;
        }
    }
    public with sharing class SharePointController_custmock3 implements HTTPCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
            res.setBody('body');
            res.setStatusCode(500);
            return res;
        }
    }
    @isTest static void SharePointController_custTest() {
        
         saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.zoho_AccessEndpoint__c='dummy url';
        objSettings.zoho_CretaOppEndpoint__c='dummy_access_url';
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
    
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SharePointController_custmock()); 
        
        Account a = new Account();
        a.Name = 'TestAccount';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Landline__c='12345 123456';
        insert a;
        a.SAF_Sharepoint_Folder_ID__c ='5431';
        update a;
       
      /* clcommon__Product_Name__c prodName = new clcommon__Product_Name__c();
       prodName.Name = 'Hire Purchase';
       insert prodName;
       
       clcommon__CL_Product__c clProdName = new clcommon__CL_Product__c();
       clProdName.clcommon__Product_Name__c= 'Hire Purchase';
       clProdName.Id = prodName.Id;
       insert clProdName;*/
       
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
       
       SFDCSharepointFileUpload__c sharePointCS = new SFDCSharepointFileUpload__c();
        sharePointCS.Client_Id__c				 = '3ede7085-8344-4f2d-ab7b-6b6a8e23bad6';
        sharePointCS.Client_Secret__c			 = 'FJyderZmunqoK6ke53LpSYRYFaIx8L3lCtOsZadiE1s=';
        sharePointCS.Resource__c				 = 'https://graph.microsoft.com';
        sharepointCS.Proposal__c				 = 'Proposal';
        sharepointCS.Root__c					 = 'Root';
        sharepointCS.In_Life__c					 = 'In Life';
        sharepointCS.Transact__c				 = 'Transact';
        sharepointCS.Third_Party_Documents__c	 = 'Third Party Documents';
        sharepointCS.Microsoft_Files__c			 = 'doc,xls';
        sharepointCS.App__c						 = 'App';
        
        insert sharepointCS;
            
       Attachment att = new Attachment();
       att.Name = 'Test.png';
       att.parentId = app.Id;
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob;
       insert att;
       Attachment attRec = [select id,BodyLength,body from Attachment where id =: att.id];
       string filePathUrl = '/Test/123/Test.png';
       string endpointURL = '/Test/123/Proposal';
       HttpRequest request = new HttpRequest();
       
       String Status = 'Teststatus';
                String ClassName = 'TestClass';
                String MethodName = 'Testmethod';
                
                String ErrorDescription = 'TesterrorDescription';
                String RecordID = '1234567890AAABB';
                String RequestBody = 'This is a test error request body';
                String ResponseBody = 'This is a test response Body';
                //String LoggedinUser = UserInfo.getName();
                Boolean DoNotDelete = True;
                String Priority = 'Error';
                //String RequestedTime = system.now();
                Boolean SendEMail = True;
                String EmailSubject = 'TestingEmail';
                String EmailBody = 'This is test emailBody';
                ErrorLogsUtils.createErrorLogs(status,className,methodName,errorDescription,recordID,requestBody,responseBody,doNotDelete,Priority,sendEmail,emailSubject,emailBody );
                Error_Logs__c errorlog = new Error_Logs__c();
                errorLog =[Select Id,Method_Name__c ,Class_Name__c from Error_Logs__c];
                System.Assert(String.isNotEmpty(errorlog.id),'NewErrorDidNotGenerateSuccesfully');
                System.assertEquals(className, errorlog.Class_Name__c,'descrepancy in error created');
       //Test.setMock(HttpCalloutMock.class, new SharePointControllermock1()); 
       //Test.setMock(HttpCalloutMock.class, new SharePointControllermock2()); 
       //Test.setMock(HttpCalloutMock.class, new SharePointControllermock3()); 

       SharePointController.createUploadSession('token',filePathUrl,'method');
       SharePointController.uploadFile(filePathUrl,attRec);
        
       //SharePointController.fetchSharePointAccessToken();
       //SharePointUtlity.prepareRequest(filePathUrl, 'reqBody','TestMethod','Header');
       //SharePointUtlity.prepareRequestWithBlob(filePathUrl,attRec,'TestMethod');
       //Added for folder creation changes
      // Test.setMock(HttpCalloutMock.class, new SharePointControllermock());
       SAF_CreateSharePointController_cust.processSharePoint(a.Name,app.Name,a.id,a.SAF_Sharepoint_Folder_ID__c);
       SAF_CreateSharePointController_cust.CreateFolderinSharePoint(endpointURL,a.Name,'token');
        
       Test.setMock(HttpCalloutMock.class, new SharePointController_custmock1()); 
       String endPointURL1='https://graph.microsoft.com/v1.0/drives/b!JFjQkBJk3kmCnBIwO7DKj9_hogq_cQlCgDiwDtvGh03-3BUOV9M1ToTgck5IuNVf###/items/'+a.SAF_Sharepoint_Folder_ID__c+'?$select=sharepointids';
       
       SAF_CreateSharePointController_cust.getFileDriveId(endPointURL1);
       SAF_CreateSharePointUtlity.CreateSPFolder(endPointURL1,a.Name,'method','token');
       
       //SharePointUtlity.fireRequestMap(request );
       test.stopTest();
	}
    
    static testMethod void SAF_Migration_fetchCustIDTest() {       
      cllease.TestHelper.createSeedDataForTesting();
     
      clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
        List<String> names = new List<String> {'Finance Lease'};
        //List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = 'Finance Lease';
        //pr1.RecordTypeId = 'LEASE';
        insert pr1;
            
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];

        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 1200;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
        genApp.genesis__Account__c = acc.Id;
        //genApp.Security_Deposit__c = 100;
        insert genApp; 
        
        SFDCSharepointFileUpload__c sharePointCS = new SFDCSharepointFileUpload__c();
        sharePointCS.Client_Id__c				 = '3ede7085-8344-4f2d-ab7b-6b6a8e23bad6';
        sharePointCS.Client_Secret__c			 = 'FJyderZmunqoK6ke53LpSYRYFaIx8L3lCtOsZadiE1s=';
        sharePointCS.Resource__c				 = 'https://graph.microsoft.com';
        sharepointCS.Proposal__c				 = 'Proposal';
        sharepointCS.Root__c					 = 'Root';
        sharepointCS.In_Life__c					 = 'In Life';
        sharepointCS.Transact__c				 = 'Transact';
        sharepointCS.Third_Party_Documents__c	 = 'Third Party Documents';
        sharepointCS.Microsoft_Files__c			 = 'doc,xls';
        sharepointCS.App__c						 = 'App';
        
        insert sharepointCS;
        
      test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<genesis__Applications__c> lstTypes = new List<genesis__Applications__c>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         SAF_Migration_fetchCustID ER = new  SAF_Migration_fetchCustID();
         //ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            genesis__Applications__c objType = (genesis__Applications__c)QIT.next();           
            System.debug('genesis__Applications__c :'+objType);
            lstTypes.add(objType);
        }  
        
        system.debug('Applications: '+lstTypes);     
        try{
            Test.setMock(HttpCalloutMock.class, new SharePointController_custmock()); 
        ER.execute(BC,lstTypes);
        ER.finish(BC); 
        }
        catch(Exception e){}
        //ER.finish(BC); 
      
        test.stopTest();
    }
}