@isTest(seealldata=true)
@TestVisible
public class SAF_DueDilSearch_Test 
{
    //Setting Mock responses 
    public class SAFDuedilMock_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                          +'"pagination": {'
                            +'"offset": 0,'
                            +'"limit": 20,'
                            +'"total": 1429'
                          +'},'
                          +'"filters": {'
                            +'"name": "Acme ltd"'
                          +'},'
                          +'"companies": ['
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "09251999",'
                              +'"name": "Acme + Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2014-10-07",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "06970764",'
                              +'"name": "Acme (South West) Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2009-07-23",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "05124647",'
                              +'"name": "Acme (GB) Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2004-05-11",'
                              +'"officialStatus": "Dissolved",'
                              +'"simplifiedStatus": "Closed"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "05534913",'
                              +'"name": "Acme (Brighton) LTD.",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2005-08-12",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "SC512893",'
                              +'"name": "Acme (RNL) LTD.",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2015-08-12",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'}'
                          +']'
                        +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }

    public class SAFDuedilMockTryCatch_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                          +'"pagination": {'
                            +'"offset": 9980,'
                            +'"limit": 20,'
                            +'"total": 2455333'
                          +'},'
                          +'"filters": {'
                            +'"name": "ltd"'
                          +'},'
                          +'"companies": ['
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "09251999",'
                              +'"name": "Acme + Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2014-10-07",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "06970764",'
                              +'"name": "Acme (South West) Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2009-07-23",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "05124647",'
                              +'"name": "Acme (GB) Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2004-05-11",'
                              +'"officialStatus": "Dissolved",'
                              +'"simplifiedStatus": "Closed"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "05534913",'
                              +'"name": "Acme (Brighton) LTD.",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2005-08-12",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "03216634",'
                              +'"name": "Other Creative Limited",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2014-10-07",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "SC512893",'
                              +'"name": "Acme (RNL) LTD.",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2015-08-12",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'}'
                          +']'
                        +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
    
    static testmethod void companiesInfo_async()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetShareholders__c='https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.GetRelatedCompanies__c ='https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
         objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
        objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
       // objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1;  
        string strbody = '{ ' + 
            '"criteria": {' + 
             '   "name": "Friary Court (Plymouth) No.8 Management Company Limited",' + 
             '   "countryCodes": {' + 
              '      "values": ["GB"]' + 
              '  },' + 
               ' "simplifiedStatuses": {' + 
               '     "values": ["Active"],' + 
                '    "mode": "any"' + 
               ' }' + 
           ' }' + 
       '}';
        
         req.requestURI = '/company/gb/03977902/shareholders';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc());   
        SAF_Duedil.companyshareholders sh = SAF_Duedil.GetShareholders('03977902','gb');//03977902 // 10672557 // 06999618
       
        system.debug('###objCmp.shareholder :' + sh.shareholders[0].exactMatches);
     
         for(SAF_Duedil.shareholder objshare:sh.shareholders)    
                {
                     objshare.contactId= '';
                     objshare.ischecked = true;
                }
        SAF_DueDilSearch.AsyncExecutionExample2 accQObj = new SAF_DueDilSearch.AsyncExecutionExample2('03977902','Google UK Limited');
        // startTest/stopTest block to force async processes to run
        System.enqueueJob(accQObj);     
        Test.stopTest();
    }
    
      static testmethod void companiesInfo()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        string strbody = '{ ' + 
            '"criteria": {' + 
             '   "name": "Friary Court (Plymouth) No.8 Management Company Limited",' + 
             '   "countryCodes": {' + 
              '      "values": ["GB"]' + 
              '  },' + 
               ' "simplifiedStatuses": {' + 
               '     "values": ["Active"],' + 
                '    "mode": "any"' + 
               ' }' + 
           ' }' + 
       '}';
        
        String JsonMsg=JSON.serialize(strbody);
        String companyId,name,countryCode,type, incorporationCountry, incorporationDate;
        String officialStatus, simplifiedStatus, numberOfEmployees, primaryWebsite;
        
        SAF_Duedil.legalEntityIdentifier legalEntityIdentifier;
        SAF_Duedil.registeredAddress registeredAddress;
        string  charitableIdentitiesCount;
        SAF_Duedil.Accounts  accounts;
        
        SAF_Duedil.FinancialSummary  financialSummary;
        string AccountId;
        boolean ischecked;
        //system.debug('credit Sense JOSN Body'+JsonMsg);  
        
        req.requestURI = '/search/companies/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
         Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;
        
        Test.startTest();
        // Set mock callout class 
       
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Test());   
        SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('10588139','20','0');
        for(SAF_Duedil.customerInfo csinf:cs.companies)
        { 
            companyId                   = csinf.companyId;
            name                        = csinf.name;
            countryCode                 = csinf.countryCode;
            type                        = csinf.type; 
            incorporationCountry        = csinf.incorporationCountry;
            incorporationDate           = csinf.incorporationDate;
            officialStatus              = csinf.officialStatus;
            simplifiedStatus            = csinf.simplifiedStatus;
            numberOfEmployees           = csinf.numberOfEmployees;
            primaryWebsite              = csinf.primaryWebsite;
            legalEntityIdentifier       = csinf.legalEntityIdentifier;
            registeredAddress           = csinf.registeredAddress;
            charitableIdentitiesCount   = csinf.charitableIdentitiesCount;
            accounts                    = csinf.accounts;
            
            financialSummary            = csinf.financialSummary;
            AccountId                   = csinf.AccountId;
            csinf.ischecked             = true;
            ischecked                   = csinf.ischecked;
           
            break;
        } 
        
        //Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Test());   
        //cs = SAF_Duedil.getCustomers('10672557','20','0');
        cs = SAF_Duedil.getCustomers('Limited','20','0');
        SAF_DueDilSearch dds = new SAF_DueDilSearch();
        dds.CustomerInfo = cs.companies;
        system.debug('##################Customer Info: '+dds.CustomerInfo);
        
        Account acc = new Account();
         for(SAF_Duedil.customerInfo csinf:dds.CustomerInfo)
        { 
            acc = dds.customerInit(csinf);
            break;
        } 
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_DueDil_CustomerSearch')); 
        System.currentPageReference().getParameters().put('compId','09251999');
        
        /*Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_IndustryInfo_Test());   
        SAF_Duedil.GetIndustryInfo('09251999','gb');
        SAF_Duedil.IndustriesInfo ifs = new SAF_Duedil.IndustriesInfo();
       
        List<SAF_Duedil.IndustryInfo> Industries = ifs.Industries;*/
        //IndustryInfo();
        dds.CustomerName = 'Acme + Ltd';
        dds.show();
        dds.selectAll = true;
        dds.pageInit();
        dds.search();
        //throw new Exception('Error');
        
        
        dds.paginationNext();
        dds.paginationPrevious();
        dds.paginationLast();
        dds.FoundLastPage = true;
        dds.paginationNext();
        dds.FoundLastPage = false;
        dds.paginationLast();
        dds.FoundLastPage = true;
        dds.paginationPrevious();
        dds.FoundLastPage = false;
        dds.paginationFirst();
        dds.paginationNext();
        
        dds.NonLimitedCust = 10000;
        dds.Totalcount = 11000;
        dds.paginationNext();
        dds.paginationPrevious();
        dds.paginationLast();
        dds.PaginationStart = 9980;
        dds.paginationNext();
        dds.selectAll = true;
        dds.updateCheckBoxes();
        system.debug('@@@@@@@@@@@@@@@@Count : '+dds.Totalcount);
        dds.createCustomers();       
        insert acc;
        //Account acc = [Select Id,Name,AccountNumber from Account Order By CreatedDate Desc Limit 1];
        SAF_DueDilSearch.CustomerUpdate(acc.AccountNumber, acc.Id);
        
        Test.stopTest();
    }
    public class SAFDuedilMock_Test1 implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                          +'"pagination": {'
                            +'"offset": 0,'
                            +'"limit": 5,'
                            +'"total": 2455333'
                          +'},'
                          +'"filters": {'
                            +'"name": "limited"'
                          +'},'
                          +'"companies": ['
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "09251999",'
                              +'"name": "Acme + Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2014-10-07",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "06970764",'
                              +'"name": "Acme (South West) Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2009-07-23",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "05124647",'
                              +'"name": "Acme (GB) Ltd",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2004-05-11",'
                              +'"officialStatus": "Dissolved",'
                              +'"simplifiedStatus": "Closed"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "05534913",'
                              +'"name": "Acme (Brighton) LTD.",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2005-08-12",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'},'
                            +'{'
                              +'"countryCode": "GB",'
                              +'"companyId": "SC512893",'
                              +'"name": "Acme (RNL) LTD.",'
                              +'"type": "Private limited with share capital",'
                              +'"incorporationDate": "2015-08-12",'
                              +'"officialStatus": "Active",'
                              +'"simplifiedStatus": "Active"'
                            +'}'
                          +']'
                        +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }

    static testmethod void companiesInfo1()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        string strbody = '{ ' + 
            '"criteria": {' + 
             '   "name": "Friary Court (Plymouth) No.8 Management Company Limited",' + 
             '   "countryCodes": {' + 
              '      "values": ["GB"]' + 
              '  },' + 
               ' "simplifiedStatuses": {' + 
               '     "values": ["Active"],' + 
                '    "mode": "any"' + 
               ' }' + 
           ' }' + 
       '}';
        
        String JsonMsg=JSON.serialize(strbody);
        String companyId,name,countryCode,type, incorporationCountry, incorporationDate;
        String officialStatus, simplifiedStatus, numberOfEmployees, primaryWebsite;
        
        SAF_Duedil.legalEntityIdentifier legalEntityIdentifier;
        SAF_Duedil.registeredAddress registeredAddress;
        string  charitableIdentitiesCount;
        SAF_Duedil.Accounts  accounts;
        
        SAF_Duedil.FinancialSummary  financialSummary;
        string AccountId;
        boolean ischecked;
        //system.debug('credit Sense JOSN Body'+JsonMsg);  
        
        req.requestURI = '/search/companies/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        ///Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Test1());   
        SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('10588139','20','0');
        for(SAF_Duedil.customerInfo csinf:cs.companies)
        { 
            companyId                   = csinf.companyId;
            name                        = csinf.name;
            countryCode                 = csinf.countryCode;
            type                        = csinf.type; 
            incorporationCountry        = csinf.incorporationCountry;
            incorporationDate           = csinf.incorporationDate;
            officialStatus              = csinf.officialStatus;
            simplifiedStatus            = csinf.simplifiedStatus;
            numberOfEmployees           = csinf.numberOfEmployees;
            primaryWebsite              = csinf.primaryWebsite;
            legalEntityIdentifier       = csinf.legalEntityIdentifier;
            registeredAddress           = csinf.registeredAddress;
            charitableIdentitiesCount   = csinf.charitableIdentitiesCount;
            accounts                    = csinf.accounts;
            
            financialSummary            = csinf.financialSummary;
            AccountId                   = csinf.AccountId;
            csinf.ischecked             = true;
            ischecked                   = csinf.ischecked;
           
            break;
        } 
        
        //Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Test());   
        //cs = SAF_Duedil.getCustomers('10672557','20','0');
        cs = SAF_Duedil.getCustomers('Limited','20','0');
        SAF_DueDilSearch dds = new SAF_DueDilSearch();
        dds.CustomerInfo = cs.companies;
       
        system.debug('##################Customer Info: '+dds.CustomerInfo);
        
         for(SAF_Duedil.customerInfo csinf:dds.CustomerInfo)
        { 
            dds.customerInit(csinf);
            break;
        } 
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_DueDil_CustomerSearch')); 
        System.currentPageReference().getParameters().put('compId','09251999');
        
        /*Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_IndustryInfo_Test());   
        SAF_Duedil.GetIndustryInfo('09251999','gb');
        SAF_Duedil.IndustriesInfo ifs = new SAF_Duedil.IndustriesInfo();
       
        List<SAF_Duedil.IndustryInfo> Industries = ifs.Industries;*/
        //IndustryInfo();
        dds.CustomerName = 'Acme + Ltd';
        dds.show();
        dds.selectAll = true;
        dds.pageInit();
        dds.search();
        
                
        //dds.createSingleCustomer();
        dds.paginationNext();
        dds.paginationPrevious();
        dds.paginationLast();
        dds.FoundLastPage = true;
        dds.paginationNext();
        dds.FoundLastPage = false;
        dds.paginationLast();
        dds.FoundLastPage = true;
        dds.paginationPrevious();
        dds.FoundLastPage = false;
        dds.paginationFirst();
        dds.paginationNext();
        
        dds.NonLimitedCust = 10000;
        dds.Totalcount = 11000;
        dds.paginationNext();
        dds.paginationPrevious();
        dds.paginationLast();
        dds.PaginationStart = 9980;
        dds.paginationNext();
        dds.selectAll = true;
        dds.updateCheckBoxes();
        system.debug('@@@@@@@@@@@@@@@@Count : '+dds.Totalcount);
        
        Test.startTest();
        dds.createCustomers();
        Account acc = [Select Id,Name,AccountNumber from Account Order By CreatedDate Desc Limit 1];
        SAF_DueDilSearch.CustomerUpdate(acc.AccountNumber, acc.Id);
        
        Test.stopTest();
    }
    
    static testmethod void companiesInfo2()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        string strbody;/* = '{ ' + 
            '"criteria": {' + 
             '   "name": "Friary Court (Plymouth) No.8 Management Company Limited",' + 
             '   "countryCodes": {' + 
              '      "values": ["GB"]' + 
              '  },' + 
               ' "simplifiedStatuses": {' + 
               '     "values": ["Active"],' + 
                '    "mode": "any"' + 
               ' }' + 
           ' }' + 
       '}';*/
        
        String JsonMsg=JSON.serialize(strbody);
        String companyId,name,countryCode,type, incorporationCountry, incorporationDate;
        String officialStatus, simplifiedStatus, numberOfEmployees, primaryWebsite;
        
        SAF_Duedil.legalEntityIdentifier legalEntityIdentifier;
        SAF_Duedil.registeredAddress registeredAddress;
        string  charitableIdentitiesCount;
        SAF_Duedil.Accounts  accounts;
        
        SAF_Duedil.FinancialSummary  financialSummary;
        string AccountId;
        boolean ischecked;
        //system.debug('credit Sense JOSN Body'+JsonMsg);  
        
        req.requestURI = '/search/companies/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMockTryCatch_Test());   
        SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('10588139','','');
        //Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Test());   
        //cs = SAF_Duedil.getCustomers('10672557','20','0');
        cs = SAF_Duedil.getCustomers('Limited','','');
        SAF_DueDilSearch dds = new SAF_DueDilSearch();
        dds.CustomerInfo = cs.companies;
        system.debug('##################Customer Info: '+dds.CustomerInfo);
        
         for(SAF_Duedil.customerInfo csinf:dds.CustomerInfo)
        { 
            dds.customerInit(csinf);
            break;
        } 
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_DueDil_CustomerSearch')); 
        //System.currentPageReference().getParameters().put('compId','09251999');
        
        dds.CustomerName = null;
        dds.show();
        dds.selectAll = true;
        dds.pageInit();
        dds.search();
        
        
        //dds.createSingleCustomer();
        dds.paginationNext();
        dds.paginationPrevious();
        dds.paginationLast();
        dds.FoundLastPage = true;
        dds.paginationNext();
        dds.FoundLastPage = false;
        dds.paginationLast();
        dds.FoundLastPage = true;
        dds.paginationPrevious();
        dds.FoundLastPage = false;
        dds.paginationFirst();
        dds.paginationNext();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_DueDil_CustomerSearch')); 
        System.currentPageReference().getParameters().put('compId','09251999');
        dds.PaginationStart = 9961;
        System.debug('!!!!!!!!!!!!!!!!!!NonLimitedCust : '+dds.NonLimitedCust);
        System.debug('!!!!!!!!!!!!!!!!!!Strlimit1: '+(Integer.valueof(dds.Strlimit)+Integer.valueof(1)));
        dds.NonLimitedCust = 10000;
        dds.Totalcount = 11000;
        dds.Strlimit = '20';
        dds.paginationNext();
        dds.paginationPrevious();
        dds.paginationLast();
        dds.PaginationStart = 9980;
        dds.paginationNext();
        dds.selectAll = true;
        dds.updateCheckBoxes();
        system.debug('@@@@@@@@@@@@@@@@Count : '+dds.Totalcount);
        
        
        
        Test.startTest();
        dds.createCustomers();
        
        Account acc = [Select Id,Name,AccountNumber from Account Where AccountNumber!=null Order By CreatedDate Desc Limit 1];
        
        SAF_DueDilSearch.CustomerUpdate(acc.AccountNumber, acc.Id);
        system.debug('#### Customer: '+acc.Name+ ', Account Number: '+acc.AccountNumber);
        Test.stopTest();
    }
    
    static testmethod void companiesInfo3()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        string strbody = '{ ' + 
            '"criteria": {' + 
             '   "name": "09251999",' + 
             '   "countryCodes": {' + 
              '      "values": ["GB"]' + 
              '  },' + 
               ' "simplifiedStatuses": {' + 
               '     "values": ["Active", "Intermediate", "Closed"],' + 
                '    "mode": "any"' + 
               ' }' + 
           ' }' + 
       '}';
        
        String JsonMsg=JSON.serialize(strbody);
        String companyId,name,countryCode,type, incorporationCountry, incorporationDate;
        String officialStatus, simplifiedStatus, numberOfEmployees, primaryWebsite;
        
        SAF_Duedil.legalEntityIdentifier legalEntityIdentifier;
        SAF_Duedil.registeredAddress registeredAddress;
        string  charitableIdentitiesCount;
        SAF_Duedil.Accounts  accounts;
        
        SAF_Duedil.FinancialSummary  financialSummary;
        string AccountId;
        boolean ischecked;
        //system.debug('credit Sense JOSN Body'+JsonMsg);  
        
        req.requestURI = '/search/companies/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        ///Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Test1());   
        SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('09251999','20','0');
        SAF_DueDilSearch dds = new SAF_DueDilSearch();
        dds.createSingleCustomer();
        dds.CustomerInfo = cs.companies;
        system.debug('##################Customer Info: '+dds.CustomerInfo);
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test_exc()); 
        //SAF_Duedil.CustomerInfo ci = SAF_Duedil.GetCompanyInfo('09251999','gb');
        //SAF_Duedil.CustomerInfo ci = dds.CustomerInfo;
        //dds.CustomerInfo.registeredAddress.fullAddress = '37 Elm Park, Paignton, Devon, TQ3 3QH';
        /*dds.CustomerInfo.registeredAddress.structuredAddress.premises = '37';
        dds.CustomerInfo.registeredAddress.structuredAddress.thoroughfare = 'Elm Park';
        dds.CustomerInfo.registeredAddress.structuredAddress.dependentLocality = 'null';
        dds.CustomerInfo.registeredAddress.structuredAddress.postTown = 'Paignton';
        dds.CustomerInfo.registeredAddress.structuredAddress.county = 'Devon';
        dds.CustomerInfo.registeredAddress.structuredAddress.postcode = 'TQ3 3QH';
        dds.CustomerInfo.registeredAddress.structuredAddress.countryCode = 'GB';
        dds.CustomerInfo.registeredAddress.geolocation.latitude = '50.43542999999999665305949747562408447265625';
        dds.CustomerInfo.registeredAddress.geolocation.latitude = '-3.58077999999999985192289386759512126445770263671875';*/
        /*ci.registeredAddress = ['"registeredAddress": {'
                            +'"fullAddress": "37 Elm Park, Paignton, Devon, TQ3 3QH",'
                            +'"structuredAddress": {'
                            +'"premises": "37",'
                            +'"thoroughfare": "Elm Park",'
                            +'"dependentLocality": null,'
                            +'"postTown": "Paignton",'
                            +'"county": "Devon",'
                            +'"postcode": "TQ3 3QH",'
                            +'"countryCode": "GB"'
                            +'},'
                            +'"geolocation": {'
                            +'"latitude": 50.43542999999999665305949747562408447265625,'
                            +'"longitude": -3.58077999999999985192289386759512126445770263671875'
                            +'}'
                            +'}'];*/
        //system.debug('Address Check Ci: '+dds.CustomerInfo);
        //system.debug('Address Check');
        //dds.customerInit(dds.CustomerInfo);
    }
    
    static testmethod void companiesInfo4()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        string strbody = '{ ' + 
            '"criteria": {' + 
             '   "name": "03216634",' + 
             '   "countryCodes": {' + 
              '      "values": ["GB"]' + 
              '  },' + 
               ' "simplifiedStatuses": {' + 
               '     "values": ["Active", "Intermediate", "Closed"],' + 
                '    "mode": "any"' + 
               ' }' + 
           ' }' + 
       '}';
        
        String JsonMsg=JSON.serialize(strbody);
        String companyId,name,countryCode,type, incorporationCountry, incorporationDate;
        String officialStatus, simplifiedStatus, numberOfEmployees, primaryWebsite;
        
        SAF_Duedil.legalEntityIdentifier legalEntityIdentifier;
        SAF_Duedil.registeredAddress registeredAddress;
        string  charitableIdentitiesCount;
        SAF_Duedil.Accounts  accounts;
        
        SAF_Duedil.FinancialSummary  financialSummary;
        string AccountId;
        boolean ischecked;
        //system.debug('credit Sense JOSN Body'+JsonMsg);  
        
        req.requestURI = '/search/companies/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        companyId ='09251999'; 
        string companyname = 'Acme ltd';
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMockTryCatch_Test()); 
        Test.startTest();
        
        Account acc = [Select Id,Name,AccountNumber from Account Where AccountNumber!=null Order By CreatedDate Desc Limit 1];
        SAF_DueDilSearch duedill = new SAF_DueDilSearch();
        SAF_DueDilSearch.CustomerUpdate(acc.AccountNumber, acc.Id);
        duedill.createSingleCustomer();
        duedill.createLinkedcomp(companyId,companyname);
        system.debug('#### ACC Customer: '+acc.Name+ ', Account Number: '+acc.AccountNumber);
        Test.stopTest();
    }
}