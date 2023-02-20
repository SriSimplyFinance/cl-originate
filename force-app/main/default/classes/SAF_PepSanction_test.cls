/**
    @ name                      : SAF_PepSanction_test
    @ author                    : Happiest Minds/Phalguni
    @ description               : test class for pep and sanction
    @ created date              : 12/06/2019    
    @ Modified by / Date        : 16/06/2019 
*/
@istest(seeAllData=true)
public class SAF_PepSanction_test{
    
    public class SAFDuedilMock_GroupCompanies_Test implements HttpCalloutMock 
    {    
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "03977902",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 10,'
                                +'"total": 3'
                                +'},'
                                +'"groupParents": ['
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": 10587968,'
                                +'"name": "Google International Llc",'
                                +'"degreeOfSeparation": 1,'
                                +'"isImmediateParent": true,'
                                +'"isUltimateParent": false'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": 10588139,'
                                +'"name": "Google Inc",'
                                +'"degreeOfSeparation": 2,'
                                +'"isImmediateParent": false,'
                                +'"isUltimateParent": false'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": 10567968,'
                                +'"name": "Alphabet Inc",'
                                +'"degreeOfSeparation": 3,'
                                +'"isImmediateParent": false,'
                                +'"isUltimateParent": true'
                                +'}'
                                +'],'
                                +'"totalCompanyShares": 36031336,'
                                +'"shareholders": ['
                                +'{'
                                +'"sourceName": "Peter Damian Kimmelman",'
                                +'"totalShareholding": 9888495,'
                                +'"totalShareholdingPercentage": 27.444153056106497,'
                                +'"shareholdings": [],'
                                +'"exactMatches": ['
                                +'{' 
                                +'"type": "company",'
                                +'"person": null,'
                                +'"company": {'
                                +'"countryCode": "GB",'
                                +'"companyId": "00014259",'
                                +'"name": "HSBC Bank PLC",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active"'
                                +'        }'
                                +'    }'
                                +'],'
                                +'"possibleMatches": [ ],'
                                +'"notMatched": null'
                                +'}'                              
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
        }
        
    public static Account CreateAccount()
    {
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        Account acc = new Account(name='Capgemini pvt limited');
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'Capgemini pvt limited';
        acc.Accountnumber = '10588244';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        return acc;
    }
   
    public static genesis__Applications__c CreateApplication(string straccountId,string strcontactId)
    {
       
        genesis__Applications__c application = new genesis__Applications__c();
        //application.RecordTypeId = applicationRecordTypes.get('LEASE');
        if(strcontactId != '')
        {
            application.genesis__Contact__c = strcontactId;// genesis.TestHelper.createContact().Id;
        }
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
        application.genesis__Account__c =straccountId;
        insert application;
        return application;
    }
      public static saf_pep_sanction_app__c CreatePepApp(string strcontactId,string straccountId,string strappid)
    {
        saf_pep_sanction_app__c objpepApp = new saf_pep_sanction_app__c();
        objpepApp.saf_Customer__c = straccountId;//CreateAccount().Id;
        if(strcontactId != '')
        {
            objpepApp.saf_Individual__c = strcontactId;//genesis.TestHelper.createContact().Id;
        }objpepApp.saf_Application__c = strappid;//CreateApplication().Id;
        objpepApp.Saf_lastmodifedBranchDate__c = Date.today();
        objpepApp.saf_CompanyID__c ='10588244';
        objpepApp.SAF_Status__c ='';
        objpepApp.saf_TotalMatches__c= 9;
        insert objpepApp;
        return objpepApp;
    }
    public static testmethod void GroupCompanies()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
        List<SAF_Duedil.groupParent> groupParents;
        
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        //rest req for share holders
        
      
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test());  
        //Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Shareholders_Test());     
        //SAF_Duedil.GroupCompanies gc = SAF_Duedil.GetGroupCompanies('10672557','gb');
        list<string> RelCustomers = SAF_PepSanction.GetRelatedCustomers('10672557','Kier');
        
        
        /*pagination      = gc.pagination;
        countryCode     = gc.countryCode;
        companyId       = gc.companyId;
        groupParents    = gc.groupParents;*/
        Test.stopTest();
    }
 
    public static testmethod void GetAppStatus()
       {
       Test.startTest();
       //SAF_PepSanction_test.GroupCompanies();

       //SAF_PepSanction_test.Share_holders();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
        List<SAF_Duedil.groupParent> groupParents;
        
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test()); 
        Contact objcontact = genesis.TestHelper.createContact();
        Account objAccount = createaccount(); 
       genesis__Applications__c objgen = CreateApplication(objAccount.Id,objcontact.Id); 
       //string strstatus = SAF_PepSanction.GetAppStatus('a7F9E0000004fIB','10588244');
       CreatePepApp(objcontact.Id,objAccount.Id,objgen.Id);
       string strstatus = SAF_PepSanction.GetAppStatus(objgen.Id ,'10588244','8');
       Test.stopTest();
      }
      public static testmethod void pepSacntion_Individual_test()
       {
       
       //SAF_PepSanction_test.GroupCompanies();

       //SAF_PepSanction_test.Share_holders();
        String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/individuals.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
         Account objAccount = createaccount(); 
         Contact objcontact = genesis.TestHelper.createContact();
         objcontact.accountId = objAccount.Id;
         update objcontact;
         genesis__Applications__c objgen = CreateApplication(objAccount.Id,objcontact.Id);
         
        Test.startTest();
        // Set mock callout class 
       
       //SAF_Duedil.GetPepSanctionIndividual('0039E00000qiXEOQA2');
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncontact_Test());
       
       
          
       //string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('0039E00000qiXEOQA2','a7F9E0000004fIB',true);
       string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd(objcontact.Id,objgen.Id,true);
       Test.stopTest();
       
       }
       
       public static testmethod void pepSacntion_Individual_test2()
       {
       
        String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/individuals.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
         
        Account objAccount = createaccount(); 
         Contact objcontact = genesis.TestHelper.createContact();
       genesis__Applications__c objgen = CreateApplication(objAccount.Id,objcontact.Id);  
       CreatePepApp(objcontact.Id,objAccount.Id,objgen.Id); 
        Test.startTest();
        // Set mock callout class 
      
       //SAF_Duedil.GetPepSanctionIndividual('0039E00000qiXEOQA2');
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncontact_Test());  
      // string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('0039E00000qiXEOQA2','a7F9E0000004MeM',false);
      string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd(objcontact.Id,objgen.Id,false); 
       Test.stopTest();
       
       }
       public static testmethod void pepSacntion_Individual_test3()
       {
       
       //SAF_PepSanction_test.GroupCompanies();

       //SAF_PepSanction_test.Share_holders();
        String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/individuals.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
         Account objAccount = createaccount(); 
          Contact objcontact = genesis.TestHelper.createContact();
       genesis__Applications__c objgen = CreateApplication(objAccount.Id,objcontact.Id);  
       CreatePepApp(objcontact.Id,objAccount.Id,objgen.Id); 
        Test.startTest();
        // Set mock callout class 
        
       
       //SAF_Duedil.GetPepSanctionIndividual('0039E00000qiXEOQA2');
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncontact_Test());  
       //string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('0039E00000qiXEOQA2','a7F9E0000004MeM',true);
       string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd(objcontact.Id,objgen.Id,true);
       Test.stopTest();
       
       }
       public static testmethod void pepSacntion_Individual_test4()
       {
       
       //SAF_PepSanction_test.GroupCompanies();

       //SAF_PepSanction_test.Share_holders();
        String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/individuals.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        Account objAccount = createaccount(); 
       Contact objcontact = genesis.TestHelper.createContact();
       genesis__Applications__c objgen = CreateApplication(objAccount.Id,objcontact.Id);
       
        Test.startTest();
        // Set mock callout class 
        
       //SAF_Duedil.GetPepSanctionIndividual('0039E00000qiXEOQA2');
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncontact_Test());  
       //string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('0039E00000kjvO5','a7F9E0000004MeM',true);
       string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('',objgen.Id,true);
       Test.stopTest();
       
       }
        public static testmethod void pepSacntion_Individual_test5()
       {
       
       
        String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/individuals.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        Account objAccount = createaccount(); 
        Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
         CreatePepApp(objcontact.Id,objAccount.Id,CreateApplication(objAccount.Id,'').Id); 
        Test.startTest();
        // Set mock callout class 
        
       //SAF_Duedil.GetPepSanctionIndividual('0039E00000qiXEOQA2');
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncontact_Test());  
       //string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('','a7F9E0000004MeM',true);
       string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd(objcontact.Id,objgen.Id,true);
       Test.stopTest();
       
       }
        
        
        public static testmethod void pepSacntion_Individual_test6()
       {
       
        String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/individuals.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        Account objAccount = createaccount(); 
        Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
         CreatePepApp(objcontact.Id,objAccount.Id,CreateApplication(objAccount.Id,'').Id); 
        Test.startTest();
        // Set mock callout class 
        
       //SAF_Duedil.GetPepSanctionIndividual('0039E00000qiXEOQA2');
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncontact_Test());  
       //string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('','a7F9E0000004MeM',true);
       string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd(objcontact.Id,objgen.Id,false);
       Test.stopTest();
       
       }
        public static testmethod void pepSacntion_Buisness_test()
       {
       
       String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/businesses.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
         Account objAccount = createaccount(); 
        //Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
         CreatePepApp('',objAccount.Id,objgen.Id);
         
        Test.startTest();
        // Set mock callout class 
           
       
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncompany_Test());  
        
       // customer and application existing
       //string strstatus = SAF_PepSanction.GetPepSanctionApplication('0019E00000sIiYk','a7F9E0000004MeM',true);
       string strstatus = SAF_PepSanction.GetPepSanctionApplication(objAccount.Id,objgen.Id,true);
       //different application
       // string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('0019E00000yFbizQAC','a7F9E0000004MiE',true);
       Test.stopTest();
       
       }
       
             
        public static testmethod void pepSacntion_Buisness_test2()
       {
       
       String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/businesses.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
          Account objAccount = createaccount(); 
        //Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
         CreatePepApp('',objAccount.Id,CreateApplication(objAccount.Id,'').Id);
         
        Test.startTest();
        // Set mock callout class 
           
       
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncompany_Test());  
       
       //same customer new application
        //string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('0019E00000sIiYk','a7F9E0000004MiE',true);
         string strstatus = SAF_PepSanction.GetPepSanctionApplication(objAccount.Id,objgen.Id,true);
       Test.stopTest();
       
       }
         public static testmethod void pepSacntion_Buisness_test3()
       {
       
       String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/businesses.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        Account objAccount = createaccount(); 
        //Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
         CreatePepApp('',objAccount.Id,objgen.Id);
         
        Test.startTest();
        // Set mock callout class 
           
       
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncompany_Test());  
       
       
       //same customer new application - 3 months check
       // string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('0019E00000sIiYk','a7F9E0000004MiE',false);
       string strstatus2 = SAF_PepSanction.GetPepSanctionApplication(objAccount.Id,objgen.Id,false);
       Test.stopTest();
       
       }
         public static testmethod void pepSacntion_Buisness_test4()
       {
       
       String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/businesses.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
         Account objAccount = createaccount(); 
        //Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
        // CreatePepApp('',objAccount.Id,objgen.Id);
         
        Test.startTest();
        // Set mock callout class 
           
       
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncompany_Test());  
        //SAF_Duedil.GetPepSanctionBuisness('10588244','gb');
       //string strstatus = SAF_PepSanction.GetPepSanctionApplicationInd('0039E00000qiXEOQA2','a7F9E0000004fIB',true);
       
       //no customer no application 
        //string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('0019E00000zOErvQAG','a7F9E0000004fbd',true);
        string strstatus2 = SAF_PepSanction.GetPepSanctionApplication(objAccount.Id,objgen.Id,true);
       Test.stopTest();
       
       }
        public static testmethod void pepSacntion_Buisness_test5()
       {
       
       String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/businesses.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        Account objAccount = createaccount(); 
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
        Test.startTest();
        // Set mock callout class 
           
       
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncompany_Test());  
       
       //same customer new application
        //string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('','a7F9E0000004MiE',true);
       string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('',objgen.Id,true);
       Test.stopTest();
       
       }
       
       public static testmethod void pepSacntion_Buisness_test6()
       {
       
       String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/businesses.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
          Account objAccount = createaccount(); 
        //Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
         CreatePepApp('',objAccount.Id,CreateApplication(objAccount.Id,'').Id);
         
        Test.startTest();
        // Set mock callout class 
           
       
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncompany_Test());  
       
       //same customer new application
        //string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('0019E00000sIiYk','a7F9E0000004MiE',true);
         string strstatus = SAF_PepSanction.GetPepSanctionApplication(objAccount.Id,objgen.Id,false);
       Test.stopTest();
       
       }
        public static testmethod void pepSacntion_Buisness_test7()
       {
       
        String strbody=     '{"criteria":{"duedilCompany":{"countryCode":"gb","companyId":"10588244"}}}';
       String JsonMsg=JSON.serialize(strbody);
       //SAF_PepSanction_test.GroupCompanies();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
       //SAF_PepSanction_test.Share_holders();
        req.requestURI = '/peps-sanctions/search/businesses.json';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
         Account objAccount = createaccount(); 
        //Contact objcontact = genesis.TestHelper.createContact();
        genesis__Applications__c objgen = CreateApplication(objAccount.Id,'');
         CreatePepApp('',objAccount.Id,objgen.Id);
         
        Test.startTest();
        // Set mock callout class 
           
       
        Test.setMock(HttpCalloutMock.class, new SAF_PepSanctionMock_Test.PepSanctioncompany2_Test());  
        
       // customer and application existing
       //string strstatus = SAF_PepSanction.GetPepSanctionApplication('0019E00000sIiYk','a7F9E0000004MeM',true);
       string strstatus = SAF_PepSanction.GetPepSanctionApplication(objAccount.Id,objgen.Id,true);
       //different application
       // string strstatus2 = SAF_PepSanction.GetPepSanctionApplication('0019E00000yFbizQAC','a7F9E0000004MiE',true);
       Test.stopTest();
       
       }
}