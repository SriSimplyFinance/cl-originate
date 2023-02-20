@isTest
private class SAF_UploadCongadocspTest 
{
    public class SharePointControllermock implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
           
            response.setStatusCode(200);
            String jsonBody='{"users":[{'+
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
                 
            response.setHeader('X-AUTH-TOKEN', 'aouthtoken12345');
            response.setStatus('Ok');
            response.setBody(jsonBody);
            return response; 
        }
    }
    @isTest static void uploadDocTest()
    {
        saf_zoho__c objZoho = saf_zoho__c.getOrgDefaults();
        objZoho.zoho_AccessEndpoint__c='dummy-url';
        objZoho.zoho_CretaOppEndpoint__c='dummy_url_2';
        upsert objZoho;
        Account acc = new Account();
        acc.Name = 'safdev';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'manchestar';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'manchestar';
        acc.Landline__c='12345654';
        INSERT acc;
       
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c();
        prod.clcommon__Product_Name__c = 'test';
        INSERT prod;
        genesis__Applications__c experian = new genesis__Applications__c();       
        experian.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        experian.genesis__Product_Type__c = 'LEASE';
        experian.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        experian.genesis__Loan_Amount__c = 6700;
        experian.genesis__company__c = genesis.TestHelper.createCompany().Id;
        experian.genesis__Expected_Start_Date__c = Date.today();
        experian.genesis__Warranty_Amount__c=0;
        experian.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        experian.genesis__Tax_Amount__c=0;
        experian.genesis__CL_Product__c = null;
        experian.genesis__Other_Financed_Fees__c = 0;
        experian.genesis__Financed_Amount__c = 6700;
        experian.genesis__Customer_cash_available__c = 1500;
        experian.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        experian.genesis__Term__c = 12;
        experian.genesis__Payment_Frequency__c = 'MONTHLY';
        experian.genesis__Interest_Rate__c = 10;
        experian.genesis__CL_Product__c = prod.id;
        experian.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        experian.genesis__Account__c = acc.Id;
        INSERT experian;
        
        Attachment att = new Attachment();
        att.Name = 'Test.png';
        att.parentId = experian.Id;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob;
        INSERT att; 
        
        SAF_Experian_Info__c safInfo =new SAF_Experian_Info__c();
        safInfo.Account__c=acc.id;
        safInfo.Saf_CommercialName__c='VATA ENVIRONMENTAL LTD';
        safInfo.Saf_RegNumber__c='11209193';
        INSERT safInfo;
            
        Test.startTest();
        SAF_UploadCongadocsp.uploadDoc(string.valueOf(att.Id), String.valueOf(safInfo.Id),'Test.png');
        Test.setMock(HttpCalloutMock.class, new SharePointControllermock());
        Test.stopTest();
    }

}