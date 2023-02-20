@IsTest
public class SAF_SharePointController_Test {

  public String webUrl = 'test/1';

  public String uploadUrl = 'test/2';

  public String access_token = 'fdbsudusd';

  public String initialResponse = '';

  public class SharePointControllermock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest request) {
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      String jsonbody =
              '{"users":[{' + '"country":"gb",' + '"role":{' + '"name":"SalesManager",' + '"id":"10777000001201297"' +
              '},' + '"language":"en_TB",' + '"locale":"en_US",' + '" microsoft":"false",' +
              '"Modified_By":{' + '"name":"System Admin",' + '"id":"10777000000140034"' + '},' +
              '"id":"10777000001268001",' + '"country_locale":"US",' + '"first_name":"Paul",' +
              '"email":"paul.morrison@simply.finance",' + '"created_time":"2019-08-01T15:35:00+05:30",' +
              '"Modified_Time":"2019-08-01T15:35:00+05:30",' + '"time_format":"hh:mm a",' + '"offset":"0",' +
              '"profile":{' + '"name":"Standard",' + '"id":"10777000001182794"' + '},' + '"last_name":"Morrison",' +
              '"time_zone":"GMT",' + '"created_by":{' + '"name":"System Admin",' + '"id":"10777000000140034"' + '},' +
              '"zuid":"20067174770",' +
              '"full_name":"PaulMorrison",' + '"SFDC":"sfdc",' + '"territories":[{' + '}],' +
              '"date_format":"MM/dd/yyyy",' + '"status":"active"' + '}],' + '"info":{' + '"per_page":"200",' +
              '"count":"117",' + '"page":"1"' +
              '},' +
              '"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]' +
              '}';
      response.setBody(jsonbody);
      response.setStatusCode(200);
      response.setHeader('X-AUTH-TOKEN', 'aouthtoken12345');
      response.setStatus('Ok');
      return response;
    }

  }

  public with sharing class SharePointControllermock1 implements HTTPCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HTTPResponse();
      res.setHeader('Content-Type', 'application/JSON');
      res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
      res.setBody('body');
      res.setStatusCode(403);
      return res;
    }

  }

  public with sharing class SharePointControllermock2 implements HTTPCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HTTPResponse();
      res.setHeader('Content-Type', 'application/JSON');
      res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
      res.setBody('body');
      res.setStatusCode(200);
      return res;
    }

  }

  public with sharing class SharePointControllermock3 implements HTTPCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HTTPResponse();
      res.setHeader('Content-Type', 'application/JSON');
      res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
      res.setBody('body');
      res.setStatusCode(500);
      return res;
    }

  }

  @isTest
  static void SharePointControllerTest() {

    saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
    objSettings.zoho_AccessEndpoint__c = 'dummy url';
    objSettings.zoho_CretaOppEndpoint__c = 'dummy_access_url';
    upsert objSettings;

    SAF_BrokerApp__c brokerSettings = SAF_BrokerApp__c.getOrgDefaults();
    brokerSettings.EndPointURL__c ='https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
    UPSERT brokerSettings;

    Saf_CompanyHouse__c objCompHouse = Saf_CompanyHouse__c.getOrgDefaults();
    objCompHouse.AccessToken__c = null;
    objCompHouse.Username__c = 'Phalguni@hm.com';
    objCompHouse.Password__c = 'phalguni@123';
    objCompHouse.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
    objCompHouse.AccessToken__c = '123';
    objCompHouse.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
    objCompHouse.UpdateIndividualIdToDB__c ='http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
    objCompHouse.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
    upsert objCompHouse;


    Account a = new Account();
    a.Name = 'TestAccount';
    a.BillingPostalCode = 'BD1 1HA';
    a.BillingCity = 'London';
    a.ShippingPostalCode = 'BD1 1HA';
    a.ShippingCity = 'London';
    a.Landline__c = '12345 123456';
    insert a;
    a.SAF_Sharepoint_Folder_ID__c = '5431';
    update a;


    List<string> lst = new List<string>();
    lst.add('0011x00001ByXxJ');
    SAF_ContactsUtils.UpdateNewCustomerToDB(lst);
    SAF_CompanyHouse.fetchKycAccessToken(true);
      
    genesis__Applications__c app = new genesis__Applications__c();
    app.genesis__Account__c = a.Id;
    app.genesis__Expected_Start_Date__c = Date.Today();
    app.genesis__Sales_Division__c = 'DIRECT';
    app.genesis__Payment_Frequency__c = 'MONTHLY';
    app.genesis__Financed_Amount__c = 123;
    app.genesis__Status__c = 'PROPOSAL';
    app.genesis__Term__c = 12;
    app.Sharepoint_SiteName__c='CLO-Test';
    app.Sharepoint_Proposal_FolderID__c='12345';
    insert app;

    SFDCSharepointFileUpload__c sharePointCS = SFDCSharepointFileUpload__c.getOrgDefaults();
    sharePointCS.Client_Id__c = '3ede7085-8344-4f2d-ab7b-6b6a8e23bad6';
    sharePointCS.Client_Secret__c = 'FJyderZmunqoK6ke53LpSYRYFaIx8L3lCtOsZadiE1s=';
    sharePointCS.Resource__c = 'https://graph.microsoft.com';

    insert sharePointCS;

    Attachment att = new Attachment();
    att.Name = 'Test.png';
    att.parentId = app.Id;
    Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
    att.body = bodyBlob;
    insert att;
    Attachment attRec = [select id, BodyLength, body from Attachment where id =:att.id];
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
    Boolean DoNotDelete = True;
    String Priority = 'Error';
    Boolean SendEMail = True;
    String EmailSubject = 'TestingEmail';
    String EmailBody = 'This is test emailBody';
    ErrorLogsUtils.createErrorLogs(status,
                                   className,
                                   methodName,
                                   errorDescription,
                                   recordID,
                                   requestBody,
                                   responseBody,
                                   doNotDelete,
                                   Priority,
                                   sendEmail,
                                   emailSubject,
                                   emailBody);
    Error_Logs__c errorlog = new Error_Logs__c();
    errorLog =[Select Id, Method_Name__c, Class_Name__c from Error_Logs__c];
    System.Assert(String.isNotEmpty(errorlog.id), 'NewErrorDidNotGenerateSuccesfully');
    System.assertEquals(className, errorlog.Class_Name__c, 'descrepancy in error created');

    test.startTest();
    Test.setMock(HttpCalloutMock.class, new SharePointControllermock());
    SharePointController.createUploadSession('token', filePathUrl, 'method');
    SharePointController.uploadFile(filePathUrl, attRec);
    SAF_Custom_FolderCreation.sendApplicationDocToSharePointCustom(app.Id);
    SAF_Custom_FolderCreation.getSharepointWebUrl(app.Sharepoint_SiteName__c,app.Sharepoint_Proposal_FolderID__c);
    SAF_CreateSharePointController.processSharePoint(a.Name, app.Name, a.id, a.SAF_Sharepoint_Folder_ID__c, app.Id);
    SAF_CreateSharePointController.CreateFolderinSharePoint(endpointURL, a.Name, 'token');
    String endPointURL1 ='https://graph.microsoft.com/v1.0/drives/b!JFjQkBJk3kmCnBIwO7DKj9_hogq_cQlCgDiwDtvGh03-3BUOV9M1ToTgck5IuNVf###/items/' +
            a.SAF_Sharepoint_Folder_ID__c + '?$select=sharepointids';
    SAF_CreateSharePointController.getFileDriveId(endPointURL1);
    SAF_CreateSharePointController.getDynamicWebUrl(app.Sharepoint_SiteName__c, app.Sharepoint_Proposal_FolderID__c);
    SAF_CreateSharePointUtlity.CreateSPFolder(endPointURL, a.Name, 'method', 'token');
    test.stopTest();
  }

}