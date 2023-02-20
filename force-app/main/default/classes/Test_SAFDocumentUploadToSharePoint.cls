@isTest(SeeAllData=true)
public class Test_SAFDocumentUploadToSharePoint{
 //Setting Mock response
    public class SharePointmock implements HttpCalloutMock {
        // Implement this interface method
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
    static void Test_SAFDocumentUploadToSharePoint() {
    
          clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        SFDCSharepointFileUpload__c setting = new SFDCSharepointFileUpload__c();
        /*setting.In_Life__c = 'In Life';
      setting.Proposal__c ='Proposal';
      setting.Third_Party_Documents__c='Third Party Documents';
      setting.FilePathForThirdPartyDocs__c='/Third Party Documents';
      setting.File_Path_For_ThirdParty_InLife__c='/Third Party Documents/App/In Life';
      setting.File_Path_For_ThirdParty_Proposal__c='/Third Party Documents/App/Proposal';
      insert setting;*/
      saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.zoho_AccessEndpoint__c='dummy url';
        objSettings.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings;
      Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'DEE1account';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
        List<String> names = new List<String> {'Hire Purchase', 'Finance Lease','Operating Lease','Sale & Hp Back'};
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];
        
        genesis__Applications__c application = new genesis__Applications__c();
        //application.RecordTypeId = applicationRecordTypes.get('LEASE');
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        application.genesis__CL_Product__c = product.Id;
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
      
        
        
        
        Attachment att1 = new Attachment();
        att1.parentId = application.id;
        att1.Name = 'Test.png';
        Blob bodyBlob1=Blob.valueOf('');
        att1.body=bodyBlob1;
        insert att1;
        
        genesis__Document_Category__c docCat = new genesis__Document_Category__c();
        docCat.genesis__Category_Name__c= 'Root';
        insert docCat;
        
        genesis__Document_Category__c docCat2 = new genesis__Document_Category__c();
        docCat2.genesis__Category_Name__c= 'In Life';
        docCat2.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat2;
        
        genesis__Document_Category__c docCat3 = new genesis__Document_Category__c();
        docCat3.genesis__Category_Name__c= 'Proposal';
        docCat3.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat3;
        
        genesis__Document_Category__c docCat4 = new genesis__Document_Category__c();
        docCat4.genesis__Category_Name__c= 'Third Party Documents';
        docCat4.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat4;
        
         genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat.genesis__Application__c = application.Id;
        appDocCat.genesis__Document_Category__c = docCat2.Id;
        appDocCat.Name = 'In Life';
        insert appDocCat;
        
        genesis__Application_Document_Category__c appDocCat1 = new genesis__Application_Document_Category__c();
        appDocCat1.genesis__Application__c = application.Id;
        appDocCat1.genesis__Document_Category__c = docCat3.Id;
        appDocCat1.Name = 'Proposal';
        insert appDocCat1;
        
        genesis__Application_Document_Category__c appDocCat3 = new genesis__Application_Document_Category__c();
        appDocCat3.genesis__Application__c = application.Id;
        appDocCat3.genesis__Document_Category__c = docCat4.Id;
        appDocCat3.Name = 'Third Party Documents';
        insert appDocCat3;
        
        
        
       Attachment att = new Attachment();
        att.parentId = application.id;
        att.Name = 'Test.png';
        Blob bodyBlob=Blob.valueOf('Attachment Body');
        att.body=bodyBlob;
        insert att;
        
        genesis__AppDocCatAttachmentJunction__c adc = new genesis__AppDocCatAttachmentJunction__c();
        adc.genesis__Application_Document_Category__c = appDocCat3.Id;
        adc.genesis__AttachmentId__c = att.Id;
        insert adc;
        
        Boolean isApp = true;
        Boolean isAgreementConverted = true;
        test.startTest();
       
       Test.setMock(HttpCalloutMock.class, new SharePointmock ());
        SAF_DocumentUploadToSharePoint.sendApplicationDocToSharePoint(isApp,att.id,application.id);
       // SAF_DocumentUploadToSharePoint.populateThirdpartyDocs(application.id);
        SAF_DocumentUploadToSharePoint.deleteAttachment(att1.id,application.id);
        SAF_DocumentUploadToSharePoint.attachmentSize(att.Id);
        SAF_DocumentUploadToSharePoint.deleteexpAttachment(att.Id);
        test.stopTest();
  } 
  
   @isTest 
    static void Test_SAFDocumentUploadToSharePoint1() {    
    
          clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        SFDCSharepointFileUpload__c setting = new SFDCSharepointFileUpload__c();
        /*setting.In_Life__c = 'In Life';
      setting.Proposal__c ='Proposal';
      setting.Third_Party_Documents__c='Third Party Documents';
      setting.FilePathForThirdPartyDocs__c='/Third Party Documents';
      setting.File_Path_For_ThirdParty_InLife__c='/Third Party Documents/App/In Life';
      setting.File_Path_For_ThirdParty_Proposal__c='/Third Party Documents/App/Proposal';
      insert setting;*/
      saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.zoho_AccessEndpoint__c='dummy url';
        objSettings.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings;
      Account acc1 = new Account();
        acc1.clcommon__Legal_Entity_Type__c = legal.id;
        acc1.Name = 'DEE2TestAccount';
        acc1.BillingPostalCode = 'BD1 1HA';
        acc1.BillingCity = 'London';
        acc1.ShippingPostalCode = 'BD1 1HA';
        acc1.ShippingCity = 'London';
        acc1.Landline__c='12345 123456';
        insert acc1;

        List<String> names = new List<String> {'Hire Purchase', 'Finance Lease','Operating Lease','Sale & Hp Back'};
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];
        
        genesis__Applications__c application = new genesis__Applications__c();
        //application.RecordTypeId = applicationRecordTypes.get('LEASE');
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        application.genesis__CL_Product__c = product.Id;
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
        application.genesis__Account__c = acc1.Id;
        insert application;
      
        
        Attachment att = new Attachment();
        att.parentId = application.id;
        att.Name = 'Test.png';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob;
        insert att;
        
        Attachment att1 = new Attachment();
        att1.parentId = application.id;
        att1.Name = 'Test.png';
        Blob bodyBlob1=Blob.valueOf('');
        att1.body=bodyBlob1;
        insert att1;
        
       genesis__Document_Category__c docCat = new genesis__Document_Category__c();
        docCat.genesis__Category_Name__c= 'Root';
        insert docCat;
        
        genesis__Document_Category__c docCat2 = new genesis__Document_Category__c();
        docCat2.genesis__Category_Name__c= 'In Life';
        docCat2.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat2;
        
        genesis__Document_Category__c docCat3 = new genesis__Document_Category__c();
        docCat3.genesis__Category_Name__c= 'Proposal';
        docCat3.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat3;
        
        genesis__Document_Category__c docCat4 = new genesis__Document_Category__c();
        docCat4.genesis__Category_Name__c= 'Third Party Documents';
        docCat4.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat4;
        
         genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat.genesis__Application__c = application.Id;
        appDocCat.genesis__Document_Category__c = docCat.Id;
        appDocCat.Name = docCat.genesis__Category_Name__c ;
        insert appDocCat;
        
        genesis__Application_Document_Category__c appDocCat1 = new genesis__Application_Document_Category__c();
        appDocCat1.genesis__Application__c = application.Id;
        appDocCat1.genesis__Document_Category__c = docCat.Id;
        appDocCat1.Name = docCat3.genesis__Category_Name__c ;
        insert appDocCat1;
        
        genesis__Application_Document_Category__c appDocCat3 = new genesis__Application_Document_Category__c();
        appDocCat3.genesis__Application__c = application.Id;
        appDocCat3.genesis__Document_Category__c = docCat.Id;
        appDocCat3.Name = docCat4.genesis__Category_Name__c;
        insert appDocCat3;
        
        genesis__AppDocCatAttachmentJunction__c adc = new genesis__AppDocCatAttachmentJunction__c();
        adc.genesis__Application_Document_Category__c = appDocCat3.Id;
        adc.genesis__AttachmentId__c = att.Id;
        insert adc;
        
        Set<id> attachmentIdSet = new set<id>();
        attachmentIdSet.add(adc.genesis__AttachmentId__c);
        Boolean isApp = false;
        Boolean isAgreementConverted = false;
        test.startTest();
       
       Test.setMock(HttpCalloutMock.class, new SharePointmock ());
        SAF_DocumentUploadToSharePoint.sendApplicationDocToSharePoint(isApp,att.id,application.id);
       // SAF_DocumentUploadToSharePoint.populateThirdpartyDocs(application.id);
        SAF_DocumentUploadToSharePoint.deleteAttachment(att1.id,application.id);
        SAF_DocumentUploadToSharePoint.attachmentSize(att.Id);
        SAF_DocumentUploadToSharePoint.deleteexpAttachment(att.Id);
        test.stopTest();
  } 
  
 
}