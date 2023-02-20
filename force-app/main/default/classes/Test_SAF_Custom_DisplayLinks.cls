@isTest
private class Test_SAF_Custom_DisplayLinks{
//Setting Mock response
    public class SharePointmock implements HttpCalloutMock {
         public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String jsonbody=  '{"users":[{'+
                                '"country":"gb",'+
                                  '"role":{' +
                                        '"name":"SalesManager",'+
                                          '"id":"10777000001201297"'+
                                       '},'+      
                                  '"language":"en_TB",'+
                                  '"locale":"en_US",'+
                                  '" microsoft":"false",'+
                                //  '"Isonline":"false",'+
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
            response.setBody(jsonbody);
            response.setStatusCode(200);
            response.setHeader('X-AUTH-TOKEN', 'aouthtoken12345');
            response.setStatus('Ok');
            return response; 
        }
    }
    @isTest 
    static void Test_SAF_Custom_DisplayLinks() {
      
       clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        SFDCSharepointFileUpload__c setting = new SFDCSharepointFileUpload__c();
        setting.In_Life__c = 'In Life';
        setting.Proposal__c ='Proposal';
        setting.Transact__c='Transact';
      setting.Third_Party_Documents__c='Third Party Documents';
      setting.FilePathForThirdPartyDocs__c='/Third Party Documents';
      setting.File_Path_For_ThirdParty_InLife__c='/Third Party Documents/App/In Life';
      setting.File_Path_For_ThirdParty_Proposal__c='/Third Party Documents/App/Proposal';
      setting.File_Path_For_ThirdParty_Transact__c='/Third Party Documents/App/Transact';
      setting.Microsoft_Files__c = 'doc';
      setting.Microsoft_Files__c = 'docx';
      setting.Microsoft_Files__c = 'xls';
      setting.Microsoft_Files__c = 'xlsx';
      insert setting;

      saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.zoho_AccessEndpoint__c='dummy url';
        objSettings.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings;
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
        string fileName = 'test';
        string filePathUrl = 'test customer2 Jan29/APP-0000001897/Transact';
        string url = 'https://simplyfinance.sharepoint.com/sites/CLO-Test/_layouts/15/Doc.aspx?sourcedoc=%7B771D10F8-81DD-4F8F-AFA7-CC60A15F32AE%7D&file=Test.doc&action=default&mobileredirect=true###123';
        
        Attachment att = new Attachment();
        att.parentId = application.id;
        att.Name = 'Test.doc';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob;
        insert att;
        
      /*  string fileFolder = 'In Life';
        
        SAF_Document_Links__c docLink = new SAF_Document_Links__c();
        docLink.Application__c = application.id;
        docLink.Name = 'In Life';
        docLink.Document_Path__c ='Test';
        docLink.File_Name__c = 'Test.doc';
        insert docLink;
        
         SAF_Document_Links__c docLink1 = new SAF_Document_Links__c();
        docLink1.Application__c = application.id;
        docLink1.Name = 'Transact';
        docLink1.Document_Path__c ='Test';
        docLink1.File_Name__c = 'Test.doc';
        
        insert docLink1; */
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAF_SharePointController_Test.SharePointControllermock());
        SAF_Custom_DisplayLinks.displayLinksCustom(filePathUrl,url,application.id);
        SAF_CreateSharePointController.getFileDriveId(url);
        SAF_Custom_DisplayLinks.displayLinksExp(url,'Third Party Document',fileName);        
        test.stopTest();
    
    }
    
}