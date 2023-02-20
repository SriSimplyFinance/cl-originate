@isTest(seeAllData=true)
public class SAF_Duedil_Test
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
                            +'"limit": 5,'
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
        
        //dds.createCustomers();
        Test.stopTest();
    }
    
    //Setting Group Companies Mock responses 
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
                                +'"countryCode": "US",'
                                +'"companyId": 10587968,'
                                +'"name": "Google International Llc",'
                                +'"degreeOfSeparation": 1,'
                                +'"ConnectionType"  :"Parent Company",'
                                +'"AccountId":12345,'
                                +'"isImmediateParent": true,'
                                +'"ischecked":true,'
                                +'"isUltimateParent": false'
                                +'},'
                                +'{'
                                +'"countryCode": "US",'
                                +'"companyId": 10588139,'
                                +'"name": "Google Inc",'
                                +'"degreeOfSeparation": 2,'
                                +'"ConnectionType"  :"Group Company",'
                                +'"AccountId":123457,'
                                +'"ischecked":true,'
                                +'"isImmediateParent": false,'
                                +'"isUltimateParent": false'
                                +'},'
                                +'{'
                                +'"countryCode": "US",'
                                +'"companyId": null,'
                                +'"name": "Alphabet Inc",'
                                +'"degreeOfSeparation": 3,'
                                +'"ConnectionType"  :"UBO",'
                                +'"AccountId":123456,'
                                +'"ischecked":true,'
                                +'"isImmediateParent": false,'
                                +'"isUltimateParent": true'
                                +'}'
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
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
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test());   
        SAF_Duedil.GroupCompanies gc = SAF_Duedil.GetGroupCompanies('10672557','gb');
        
        pagination      = gc.pagination;
        countryCode     = gc.countryCode;
        companyId       = gc.companyId;
        groupParents    = gc.groupParents;
        Test.stopTest();
    }
    
    //Setting Related Companies Mock responses 
    public class SAFDuedilMock_RelatedCompanies_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                            +'"countryCode": "GB",'
                            +'"companyId": "04377558",'
                            +'"pagination": {'
                            +'"offset": 0,'
                            +'"limit": 3,'
                            +'"total": 211'
                            +'},'
                            +'"relatedCompanies": ['
                            +'{},'
                            +'{},'
                            +'{}'
                            +']'
                            +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
      public class SAFDuedilMock_RelatedCompanies_Test1 implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                            +'"countryCode": "GB",'
                            +'"companyId": "04377558",'
                            +'"pagination": {'
                            +'"offset": 0,'
                            +'"limit": 3,'
                            +'"total": 211'
                            +'},'
                            +'"relatedCompanies": ['
                            +'{'
                            +'"countryCode": "GB",'
                            +'"companyId": "SF000764",'
                            +'"officialStatus": "Converted / Closed",'
                            +'"simplifiedStatus": "Closed",'
                            +'"name": "Ubs Ag",'
                            +'"confidence": "low",'
                            +'"nameSimilarityScore": 0.31578947368421050878595224276068620383739471435546875,'
                            +'"mutualAddresses": {'
                            +'"count": 0'
                            +'},'
                            +'"mutualMajorShareholders": {'
                            +'"count": 0'
                            +'},'
                            +'"mutualOfficers": {'
                            +'"count": 0'
                            +'},'
                            +'"mutualInvestments": {'
                            +'"count": 3'
                            +'}'
                            +'}'
                            +']'
                            +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
    static testmethod void RelatedCompanies()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        string countryCode, companyId, officialStatus, simplifiedStatus, name, confidence;
        decimal nameSimilarityScore;
        string  AccountId;
        SAF_Duedil.mutualAddresses mutualAddresses;
        SAF_Duedil.mutualMajorShareholders mutualMajorShareholders;
        SAF_Duedil.mutualOfficers  mutualOfficers;
        SAF_Duedil.mutualInvestments mutualInvestments;
        boolean ischecked;
        
        req.requestURI = '/company/gb/10672557/related-companies';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_RelatedCompanies_Test());   
        SAF_Duedil.RelatedCompanies rc = SAF_Duedil.GetRelatedCompanies('10672557','gb');
        
        SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
        csinfo = SAF_Duedil.GetCompanyInfo('10672557','gb');
        SAF_Duedil.relatedCompany relc = new SAF_Duedil.relatedCompany();
        
        countryCode = relc.countryCode; 
        companyId = relc.companyId; 
        officialStatus = relc.officialStatus; 
        simplifiedStatus = relc.simplifiedStatus; 
        name = relc.name; 
        confidence = relc.confidence;
        AccountId = relc.AccountId;
        mutualAddresses = relc.mutualAddresses;
        mutualMajorShareholders = relc.mutualMajorShareholders;
        mutualOfficers = relc.mutualOfficers;
        mutualInvestments = relc.mutualInvestments;
        relc.nameSimilarityScore = 26.00;
        nameSimilarityScore = relc.nameSimilarityScore;
        ischecked = relc.ischecked;
        Test.stopTest();
    }
    
    
    //Setting Share holders Mock responses 
    public class SAFDuedilMock_Shareholders_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "06999618",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 3,'
                                +'"total": 40'
                                +'},'
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
    
    public class SAFDuedilMock_Shareholders_Test_Exc implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {   
             HttpResponse response = new HttpResponse(); 
           if(request.getEndpoint().contains('shareholders'))
           {
            // Create a fake response
           
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                    +'"countryCode": "GB",'
                                    +'"companyId": "06999618",'
                                    +'"pagination": {'
                                    +'"offset": 0,'
                                    +'"limit": 10,'
                                    +'"total": 53'
                                    +'},'
                                    +'"totalCompanyShares": 652418757,'
                                    +'"shareholders": ['
                                    +'{'
                                    +'"sourceName": "Oak Investment Partners Xiii Lp",'
                                    +'"totalShareholding": 270057325,'
                                    +'"totalShareholdingPercentage": 41.39324967323096160498607787303626537322998046875,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 270057325,'
                                    +'"percentageOfShares": 43.8386955274909411173211992718279361724853515625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": [],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": {'
                                    +'"suspectedType": "company"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Notion Capital 2 Lp",'
                                    +'"totalShareholding": 107402678,'
                                    +'"totalShareholdingPercentage": 16.462230254364069281791671528480947017669677734375,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 107402678,'
                                    +'"percentageOfShares": 17.434792037872515635399395250715315341949462890625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": ['
                                    +'{'
                                    +'"type": "company",'
                                    +'"person": null,'
                                    +'"company": {'
                                    +'"countryCode": "GB",'
                                    +'"companyId": "LP014907",'
                                    +'"name": "Notion Capital 2 LP",'
                                    +'"officialStatus": "Active",'
                                    +'"simplifiedStatus": "Active"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": null'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Augmentum Fintech Plc",'
                                    +'"totalShareholding": 105644554,'
                                    +'"totalShareholdingPercentage": 16.19275241039705548473648377694189548492431640625,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 105644553,'
                                    +'"percentageOfShares": 17.149393718925711738165773567743599414825439453125,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"class": "Preferred D",'
                                    +'"numberOfShares": 1,'
                                    +'"percentageOfShares": 100,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": ['
                                    +'{'
                                    +'"type": "company",'
                                    +'"person": null,'
                                    +'"company": {'
                                    +'"countryCode": "GB",'
                                    +'"companyId": "11118262",'
                                    +'"name": "Augmentum Fintech PLC",'
                                    +'"officialStatus": "Active",'
                                    +'"simplifiedStatus": "Active"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": null'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Venture Founders Nominee Limited",'
                                    +'"totalShareholding": 42535228,'
                                    +'"totalShareholdingPercentage": 6.5196206491040538111292335088364779949188232421875,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 42535228,'
                                    +'"percentageOfShares": 6.904789231265649362967451452277600765228271484375,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": ['
                                    +'{'
                                    +'"exactmatchtype": "company",'
                                    +'"person": null,'
                                    +'"company": {'
                                    +'"countryCode": "GB",'
                                    +'"companyId": "09050765",'
                                    +'"name": "Venture Founders Nominee Limited",'
                                    +'"officialStatus": "Active",'
                                    +'"simplifiedStatus": "Active"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": null'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Peter Damian Kimmelman",'
                                    +'"totalShareholding": 27251105,'
                                    +'"totalShareholdingPercentage": 4.17693463095819605968017640407197177410125732421875,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Ordinary",'
                                    +'"numberOfShares": 9888495,'
                                    +'"percentageOfShares": 66.5835334397844462728244252502918243408203125,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 17362610,'
                                    +'"percentageOfShares": 2.818491123514496710100729615078307688236236572265625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": ['
                                    +'{'
                                    +'"type": "person",'
                                    +'"person": {'
                                    +'"honorific": "Mr",'
                                    +'"firstName": "Peter",'
                                    +'"middleName": "Damian",'
                                    +'"lastName": "Kimmelman",'
                                    +'"nationalities": ['
                                    +'{'
                                    +'  "demonym": "American",'
                                    +'  "countryCode": "US"'
                                    +'}'
                                    +'],'
                                    +'"dateOfBirth": {'
                                    +'"year": 1982,'
                                    +'"month": 10'
                                    +'},'
                                    +'"officerId": "919801033"'
                                    +'},'
                                    +'"company": null'
                                    +'}'
                                    +'],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": null'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Concentric Team Technology I Lp",'
                                    +'"totalShareholding": 22469819,'
                                    +'"totalShareholdingPercentage": 3.444079244950340790154541537049226462841033935546875,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 22469819,'
                                    +'"percentageOfShares": 3.647549844088957993193389484076760709285736083984375,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": ['
                                    +'{'
                                    +'"type": "company",'
                                    +'"person": null,'
                                    +'"company": {'
                                    +'"countryCode": "GB",'
                                    +'"companyId": "LP017328",'
                                    +'"name": "Concentric Team Technology I LP",'
                                    +'"officialStatus": "Active",'
                                    +'"simplifiedStatus": "Active"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": null'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Playfair Capital Investment Nominee Ltd",'
                                    +'"totalShareholding": 17725006,'
                                    +'"totalShareholdingPercentage": 2.71681428680935344033287037746049463748931884765625,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 17196636,'
                                    +'"percentageOfShares": 2.7915483858884027057456478360109031200408935546875,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"class": "Preferred B",'
                                    +'"numberOfShares": 528370,'
                                    +'"percentageOfShares": 3.63206395435163020835034330957569181919097900390625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": ['
                                    +'{'
                                    +'"type": "company",'
                                    +'"person": null,'
                                    +'"company": {'
                                    +'"countryCode": "GB",'
                                    +'"companyId": "08748052",'
                                    +'"name": "Playfair Capital Investment Nominee Ltd",'
                                    +'"officialStatus": "Active",'
                                    +'"simplifiedStatus": "Active"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": null'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "David Legg",'
                                    +'"totalShareholding": 10845697,'
                                    +'"totalShareholdingPercentage": 1.6623827692924530996521070846938528120517730712890625,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 10699767,'
                                    +'"percentageOfShares": 1.7369046654375888127930238624685443937778472900390625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"class": "Preferred B",'
                                    +'"numberOfShares": 78672,'
                                    +'"percentageOfShares": 0.540798560510156622882504962035454809665679931640625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"class": "Preferred A",'
                                    +'"numberOfShares": 67258,'
                                    +'"percentageOfShares": 0.96149942331192217448432302262517623603343963623046875,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": [],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": {'
                                    +'"suspectedType": "person"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Oak Investment Partners Xiii, L.P.",'
                                    +'"totalShareholding": 9200981,'
                                    +'"totalShareholdingPercentage": 1.4102876260499666027925513844820670783519744873046875,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred B",'
                                    +'"numberOfShares": 8083283,'
                                    +'"percentageOfShares": 55.5652304580564901925754384137690067291259765625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"class": "Preferred A",'
                                    +'"numberOfShares": 1117698,'
                                    +'"percentageOfShares": 15.9782625477547473025197177776135504245758056640625,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": [],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": {'
                                    +'"suspectedType": "company"'
                                    +'}'
                                    +'},'
                                    +'{'
                                    +'"sourceName": "Wave Partners Limited",'
                                    +'"totalShareholding": 7923341,'
                                    +'"totalShareholdingPercentage": 1.214456346478094861396357373450882732868194580078125,'
                                    +'"shareholdings": ['
                                    +'{'
                                    +'"class": "Preferred C",'
                                    +'"numberOfShares": 7923341,'
                                    +'"percentageOfShares": 1.2862044518121684699707429899717681109905242919921875,'
                                    +'"nominalValue": {'
                                    +'"value": 0,'
                                    +'"currency": "GBP"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"exactMatches": ['
                                    +'{'
                                    +'"type": "company",'
                                    +'"person": null,'
                                    +'"company": {'
                                    +'"countryCode": "GB",'
                                    +'"companyId": "06120952",'
                                    +'"name": "Wave Partners Limited",'
                                    +'"officialStatus": "Active",'
                                    +'"simplifiedStatus": "Active"'
                                    +'}'
                                    +'}'
                                    +'],'
                                    +'"possibleMatches": [],'
                                    +'"notMatched": null'
                                    +'}'
                                    +']'
                                    +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
        }
        else 
           {
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                          +'"pagination": {'
                            +'"offset": 0,'
                            +'"limit": 5,'
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
                            +'"legalEntityIdentifier": null,'
                            +'"type": "Private limited with share capital",'
                            +'"incorporationCountry": "United Kingdom",'
                            +'"incorporationDate": "2014-10-07",'
                            +'"officialStatus": "Proposal to Strike Off",'
                            +'"simplifiedStatus": "Intermediate",'
                            +'"numberOfEmployees": null,'
                            +'"primaryWebsite": null,'
                            +'"registeredAddress": {'
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
                            +'},'
                            +'"charitableIdentitiesCount": 0,'
                            +'"accounts": {'
                            +'"filingType": "Total exemption full",'
                            +'"currency": "GBP",'
                            +'"latestAccountsDate": "2017-10-31",'
                            +'"consolidatedAccounts": false,'
                            +'"nextAccountsDueDate": "2019-07-31"'
                            +'},'
                            +'"financialSummary": {'
                            +'"turnover": null,'
                            +'"ebitda": null,'
                            +'"postTaxProfit": null,'
                            +'"totalAssets": null,'
                            +'"netAssets": null'
                            +'}'
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
           }    return response; 
        }
    }
    
    
    static testmethod void Shareholders()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Shareholders_Test());   
        SAF_Duedil.companyshareholders sh = SAF_Duedil.GetShareholders('10672557','gb');
        Test.stopTest();
    }
     static testmethod void Shareholdersmatch()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_Shareholders_Test_Exc());   
        SAF_Duedil.companyshareholders sh = SAF_Duedil.GetShareholders('10672557','gb');
        Test.stopTest();
    }
    //Setting company Officers Mock responses 
    public class SAFDuedilMock_companyOfficers_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "08264782",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 10,'
                                +'"total": 2'
                                +'},'
                                +'"filters": null,'
                                +'"officers": ['
                                +'{},'
                                +'{}'
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
       public class SAFDuedilMock_companyOfficersApp_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
              response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            if(request.getEndpoint().contains('officers'))
           {
          
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "08264782",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 10,'
                                +'"total": 2'
                                +'},'
                                +'"filters": null,'
                                +'"officers": ['
                                +'{'
                                +'"officerId": "924703112",'
                                +'"type": "person",'
                                 +'"person": {'
                                +'"honorific": "Mr",'
                                +'"firstName": "Andrew",'
                                +'"middleName": "Merlay",'
                                +'"lastName": "Wright",'
                                +'"nationalities": ['
                                +'{'
                                 +'"demonym": "British",'
                                 +'"countryCode": "GB"'
                                 +'}'
                                 +'],'
                                +'"dateOfBirth": {'
                                 +'"year": 1960,'
                                +'"month": 5'
                                +'}'
                                  +'},'
                                +'"company": null,'
                                 +'"isShareholder": null,'
                                +'"disqualifications": [],'
                                +'"appointments": ['
                                 +'{'
                                 +'"status": "open",'
                                 +'"startDate": "2018-05-17",'
                                 +'"endDate": null,'
                                 +'"officialRole": "Director",'
                                 +'"selfDescribedPosition": "Treasurer",'
                                 +'"serviceAddress": {'
                                 +'"fullAddress": "8 Canada Square, London, United Kingdom, E14 5HQ",'
                                 +'"structuredAddress": {'
                                 +'"premises": "8 Canada Square",'
                                 +'"thoroughfare": null,'
                                 +'"dependentLocality": null,'
                                 +'"postTown": "London",'
                                 +'"county": null,'
                                 +'"postcode": "E14 5HQ",'
                                 +'"countryCode": "GB"'
                                 +'}'
                                 +'}'
                                 +'}'
                                 +']'
                                +'}'
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            }
            else
            {
         String responseStr =        '{'+
        '    "countryCode": "GB",'+
        '    "companyId": "01794877",'+
        '    "name": "Sabtina Limited",'+
        '    "legalEntityIdentifier": null,'+
        '    "type": "Private limited with share capital",'+
        '    "incorporationCountry": "United Kingdom",'+
        '    "incorporationDate": "1984-02-24",'+
        '    "officialStatus": "Active",'+
        '    "simplifiedStatus": "Active",'+
        '    "numberOfEmployees": 2,'+
        '    "primaryWebsite": null,'+
        '    "registeredAddress": {'+
        '        "fullAddress": "210 Upper Fifth Street, Regency Court, Milton Keynes, Bucks, MK9 2HR",'+
        '        "structuredAddress": {'+
        '            "premises": "210",'+
        '            "thoroughfare": "Upper Fifth Street",'+
        '            "dependentLocality": "Regency Court, Bucks",'+
        '            "postTown": "Milton Keynes",'+
        '            "county": "Buckinghamshire",'+
        '            "postcode": "MK9 2HR",'+
        '            "countryCode": "GB"'+
        '        },'+
        '        "geolocation": {'+
        '            "latitude": 52.03982,'+
        '            "longitude": -0.76437'+
        '        }'+
        '    },'+
        '    "charitableIdentitiesCount": 0,'+
        '    "accounts": {'+
        '        "filingType": "Full accounts",'+
        '        "currency": "GBP",'+
        '        "latestAccountsDate": "2019-06-30",'+
        '        "consolidatedAccounts": false,'+
        '        "nextAccountsDueDate": "2021-03-31"'+
        '    },'+
        '    "financialSummary": {'+
        '        "turnover": 26243,'+
        '        "ebitda": -262544,'+
        '        "postTaxProfit": -258420,'+
        '        "totalAssets": 3413359,'+
        '        "netAssets": 3023804'+
        '    }'+
        '}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
           
        }
         return response; 
        }
    }
    static testmethod void companyOfficers()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/officers';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_companyOfficers_Test());   
        SAF_Duedil.companyOfficers co = SAF_Duedil.GetcompanyOfficers('10672557','gb');
        Test.stopTest();
    }
    
    //Setting Company Info Mock responses 
    public class SAFDuedilMock_CompanyInfo_Test implements HttpCalloutMock 
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
                            +'"legalEntityIdentifier": null,'
                            +'"type": "Private limited with share capital",'
                            +'"incorporationCountry": "United Kingdom",'
                            +'"incorporationDate": "2014-10-07",'
                            +'"officialStatus": "Proposal to Strike Off",'
                            +'"simplifiedStatus": "Intermediate",'
                            +'"numberOfEmployees": null,'
                            +'"primaryWebsite": null,'
                            +'"registeredAddress": {'
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
                            +'},'
                            +'"charitableIdentitiesCount": 0,'
                            +'"accounts": {'
                            +'"filingType": "Total exemption full",'
                            +'"currency": "GBP",'
                            +'"latestAccountsDate": "2017-10-31",'
                            +'"consolidatedAccounts": false,'
                            +'"nextAccountsDueDate": "2019-07-31"'
                            +'},'
                            +'"financialSummary": {'
                            +'"turnover": null,'
                            +'"ebitda": null,'
                            +'"postTaxProfit": null,'
                            +'"totalAssets": null,'
                            +'"netAssets": null'
                            +'}'
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
   public class SAFDuedilMock_CompanyInfo_Test1 implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr =        '{'+
        '    "countryCode": "GB",'+
        '    "companyId": "01794877",'+
        '    "name": "Sabtina Limited",'+
        '    "legalEntityIdentifier": null,'+
        '    "type": "Private limited with share capital",'+
        '    "incorporationCountry": "United Kingdom",'+
        '    "incorporationDate": "1984-02-24",'+
        '    "officialStatus": "Active",'+
        '    "simplifiedStatus": "Active",'+
        '    "numberOfEmployees": 2,'+
        '    "primaryWebsite": null,'+
        '    "registeredAddress": {'+
        '        "fullAddress": "210 Upper Fifth Street, Regency Court, Milton Keynes, Bucks, MK9 2HR",'+
        '        "structuredAddress": {'+
        '            "premises": "210",'+
        '            "thoroughfare": "Upper Fifth Street",'+
        '            "dependentLocality": "Regency Court, Bucks",'+
        '            "postTown": "Milton Keynes",'+
        '            "county": "Buckinghamshire",'+
        '            "postcode": "MK9 2HR",'+
        '            "countryCode": "GB"'+
        '        },'+
        '        "geolocation": {'+
        '            "latitude": 52.03982,'+
        '            "longitude": -0.76437'+
        '        }'+
        '    },'+
        '    "charitableIdentitiesCount": 0,'+
        '    "accounts": {'+
        '        "filingType": "Full accounts",'+
        '        "currency": "GBP",'+
        '        "latestAccountsDate": "2019-06-30",'+
        '        "consolidatedAccounts": false,'+
        '        "nextAccountsDueDate": "2021-03-31"'+
        '    },'+
        '    "financialSummary": {'+
        '        "turnover": 26243,'+
        '        "ebitda": -262544,'+
        '        "postTaxProfit": -258420,'+
        '        "totalAssets": 3413359,'+
        '        "netAssets": 3023804'+
        '    }'+
        '}';
        response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
    public class SAFDuedilMock_CompanyInfo_Test_exc implements HttpCalloutMock 
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
                            +'"legalEntityIdentifier": null,'
                            +'"type": "Private limited with share capital",'
                            +'"incorporationCountry": "United Kingdom",'
                            +'"incorporationDate": "2014-10-07",'
                            +'"officialStatus": "Proposal to Strike Off",'
                            +'"simplifiedStatus": "Intermediate",'
                            +'"numberOfEmployees": null,'
                            +'"primaryWebsite": null,'
                            +'"registeredAddress": {'
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
                            +'},'
                            +'"charitableIdentitiesCount": 0,'
                            +'"accounts": {'
                            +'"filingType": "Total exemption full",'
                            +'"currency": "GBP",'
                            +'"latestAccountsDate": "2017-10-31",'
                            +'"consolidatedAccounts": false,'
                            +'"nextAccountsDueDate": "2019-07-31"'
                            +'},'
                            +'"financialSummary": {'
                            +'"turnover": null,'
                            +'"ebitda": null,'
                            +'"postTaxProfit": null,'
                            +'"totalAssets": null,'
                            +'"netAssets": null'
                            +'}'
                            +'}'
                          +']'
                        +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
    
    static testmethod void companyInfo()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_CompanyInfo_Test());   
        SAF_Duedil.CustomerInfo ci = SAF_Duedil.GetCompanyInfo('10672557','gb');
        Test.stopTest();
    }
    
    //Setting Industry Info Mock responses 
    public class SAFDuedilMock_IndustryInfo_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                  +'"countryCode": "GB",'
                                  +'"companyId": "05236274",'
                                  +'"pagination": {'
                                    +'"offset": 0,'
                                    +'"limit": 10,'
                                    +'"total": 4'
                                  +'},'
                                  +'"filters": null,'
                                  +'"industries": ['
                                    +'{'
                                      +'"name": "Service activities incidental to air transportation",'
                                      +'"code": "52230",'
                                      +'"type": "SIC2007"'
                                    +'},'
                                    +'{'
                                      +'"name": "Other supporting air transport activities",'
                                      +'"code": "6323",'
                                      +'"type": "SIC2003"'
                                    +'},'
                                    +'{'
                                      +'"name": "Management consultancy activities other than financial management",'
                                      +'"code": "70229",'
                                      +'"type": "SIC2007"'
                                    +'},'
                                    +'{'
                                      +'"name": "Business & management consultancy",'
                                      +'"code": "7414",'
                                      +'"type": "SIC2003"'
                                    +'}'
                                  +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
    
    static testmethod void IndustryInfo()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        SAF_Duedil.filters filters;
        List<SAF_Duedil.IndustryInfo> Industries;
        
        req.requestURI = '/company/gb/10672557/industries';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        //Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_IndustryInfo_Test());   
        SAF_Duedil.GetIndustryInfo('10672557','gb');
        
        SAF_Duedil.IndustriesInfo ifs = new SAF_Duedil.IndustriesInfo();
        pagination = ifs.pagination;
        filters = ifs.filters;
        Industries = ifs.Industries;
        
        string name;
        string code;
        string type;
        //List<SAF_Duedil.IndustryInfo> ifs = new List<SAF_Duedil.IndustryInfo>;
        SAF_Duedil.IndustriesInfo Indusinfo = new SAF_Duedil.IndustriesInfo();
        Indusinfo = SAF_Duedil.GetIndustryInfo('10672557','gb');
        for(SAF_Duedil.IndustryInfo objcInfo:Indusinfo.industries)    
        {
            name = objcInfo.name;
            code = objcInfo.code;
            type = objcInfo.type;
        }
        
        String value;
        string description;
        SAF_Duedil.reasonCode rsc = new SAF_Duedil.reasonCode();
        value = rsc.value;
        description = rsc.description;
        
        string lei;
        string sourceUrl;
        SAF_Duedil.legalEntityIdentifier leid = new SAF_Duedil.legalEntityIdentifier();
        lei = leid.lei;
        sourceUrl = leid.sourceUrl;
        
        //Public class  structuredAddress 
        string premises;
        string thoroughfare;
        string dependentLocality;
        string postTown;
        string county;
        string postcode;
        string countryCode;
        SAF_Duedil.structuredAddress sa = new SAF_Duedil.structuredAddress();
        premises            = sa.premises;
        thoroughfare        = sa.thoroughfare;
        dependentLocality   = sa.dependentLocality;
        postTown            = sa.postTown;
        county              = sa.county;
        postcode            = sa.postcode;
        countryCode         = sa.countryCode;
        
        string fullAddress;
        SAF_Duedil.structuredAddress structuredAddress;
        SAF_Duedil.geolocation geolocation;
        
        SAF_Duedil.registeredAddress ra = new SAF_Duedil.registeredAddress();
        fullAddress = ra.fullAddress;
        structuredAddress = ra.structuredAddress;
        geolocation = ra.geolocation;
        
        string  latitude;
        string  longitude;
        SAF_Duedil.geolocation gl =  new SAF_Duedil.geolocation();
        latitude    = gl.latitude;
        longitude   = gl.longitude;
        
        string filingType;
        string latestAccountsDate;
        string consolidatedAccounts;
        string nextAccountsDueDate;
        
        SAF_Duedil.accounts sda = new SAF_Duedil.accounts();
        filingType              = sda.filingType;
        latestAccountsDate      = sda.latestAccountsDate;
        consolidatedAccounts    = sda.consolidatedAccounts;
        nextAccountsDueDate     = sda.nextAccountsDueDate;
            
        string turnover, ebitda, postTaxProfit, totalAssets, netAssets;
        SAF_Duedil.financialSummary fs = new SAF_Duedil.financialSummary();
        turnover = fs.turnover;
        ebitda = fs.ebitda;
        postTaxProfit = fs.postTaxProfit;
        totalAssets = fs.totalAssets;
        netAssets =  fs.netAssets;
     
        string offset,total;
        SAF_Duedil.pagination pg = new SAF_Duedil.pagination();
        offset  = pg.offset;
        total = pg.total;
        
        string name1;
        SAF_Duedil.simplifiedStatuses simplifiedStatuses;
        SAF_Duedil.countryCodes countryCodes; 
        SAF_Duedil.filters fl = new SAF_Duedil.filters();
        name1 = fl.name;
        simplifiedStatuses = fl.simplifiedStatuses;
        countryCodes = fl.countryCodes;
        
        string countryCode1, companyId, name2, degreeOfSeparation, isImmediateParent, isUltimateParent, AccountId, ConnectionType;
        boolean ischecked;
        SAF_Duedil.groupParent gp = new SAF_Duedil.groupParent();
        countryCode1 = gp.countryCode;
        companyId = gp.companyId;
        name2 = gp.name;
        degreeOfSeparation = gp.degreeOfSeparation; 
        isImmediateParent = gp.isImmediateParent;
        isUltimateParent = gp.isUltimateParent;
        AccountId = gp.AccountId;
        ConnectionType = gp.ConnectionType;
        ischecked = gp.ischecked;
        
        // Starts;;;;
        string count;
        SAF_Duedil.mutualAddresses ma = new SAF_Duedil.mutualAddresses();
        count = ma.count;
        
        SAF_Duedil.mutualMajorShareholders mms = new SAF_Duedil.mutualMajorShareholders();
        count = mms.count;
        
        SAF_Duedil.mutualOfficers mo = new SAF_Duedil.mutualOfficers();
        count = mo.count;
        
        SAF_Duedil.mutualInvestments mi = new SAF_Duedil.mutualInvestments();
        count = mi.count;
        
        List<SAF_Duedil.relatedCompany> relatedCompanies;
        SAF_Duedil.relatedCompanies rc11 = new SAF_Duedil.relatedCompanies();
        countryCode = rc11.countryCode;
        companyId = rc11.companyId;
        pagination = rc11.pagination;
        relatedCompanies = rc11.relatedCompanies;
        
        string year, month, monthYear;
        SAF_Duedil.dateOfBirth dob = new SAF_Duedil.dateOfBirth();
        year = dob.year;
        month = dob.month;
        monthYear = dob.monthYear;
        
        string honorific,firstName, middleName, lastName, officerId; 
        SAF_Duedil.dateOfBirth dateOfBirth;
        SAF_Duedil.nationalities nationalities;
        SAF_Duedil.person per = new SAF_Duedil.person();
        honorific = per.honorific;
        firstName = per.firstName;
        middleName = per.middleName;
        lastName = per.lastName;
        dateOfBirth = per.dateOfBirth;
        officerId = per.officerId;
        
        string demonym;
        SAF_Duedil.nationalities nt = new SAF_Duedil.nationalities();
        demonym = nt.demonym;
        countryCode = nt.countryCode;
        
        string isShareholder, Relationship, ContactId;
        SAF_Duedil.person person;
        SAF_Duedil.CustomerInfo company;
        List<SAF_Duedil.appointment> appointments;
        SAF_Duedil.officer ofc = new SAF_Duedil.officer();
        officerId = ofc.officerId;
        type = ofc.type;
        person = ofc.person;
        isShareholder = ofc.isShareholder;
        company = ofc.company;
        Relationship = ofc.Relationship;
        appointments = ofc.appointments;
        ContactId = ofc.ContactId;
        ischecked = ofc.ischecked;
        
        string status, startDate, endDate, officialRole, selfDescribedPosition;
        SAF_Duedil.registeredAddress serviceAddress;
        SAF_Duedil.appointment apt = new SAF_Duedil.appointment();
        status = apt.status;
        startDate = apt.startDate;
        endDate = apt.endDate;
        officialRole = apt.officialRole;
        selfDescribedPosition = apt.selfDescribedPosition;
        serviceAddress = apt.serviceAddress; 
        
        SAF_Duedil.exactMatch em = new SAF_Duedil.exactMatch();
        type = em.type;
        person = em.person;
        company = em.company;
        
        SAF_Duedil.nominalValue nv = new SAF_Duedil.nominalValue();
        value = nv.value;
        
        string numberOfShares,percentageOfShares;
        SAF_Duedil.nominalValue nominalValue;
        SAF_Duedil.shareholding sh1 = new  SAF_Duedil.shareholding();
        numberOfShares = sh1.numberOfShares;
        percentageOfShares = sh1.percentageOfShares;
        nominalValue = sh1.nominalValue;
        
        string sourceName, totalShareholding, exactMatchType;  
        decimal totalShareholdingPercentage;
        List<SAF_Duedil.shareholding> shareholdings;
        List<SAF_Duedil.exactMatch> exactMatches;
        SAF_Duedil.notMatched notMatched;
        SAF_Duedil.shareholder sh2 = new SAF_Duedil.shareholder();
        sourceName = sh2.sourceName;
        totalShareholding = sh2.totalShareholding;
        sh2.totalShareholdingPercentage = 50.00;
        totalShareholdingPercentage = sh2.totalShareholdingPercentage;
        shareholdings = sh2.shareholdings;
        exactMatches = sh2.exactMatches;
        ContactId = sh2.contactId;
        Relationship = sh2.Relationship;
        notMatched = sh2.notMatched;
        exactMatchType = sh2.exactMatchType;
        ischecked = sh2.ischecked;
        
        string suspectedType;
        SAF_Duedil.notMatched nm = new SAF_Duedil.notMatched();
        suspectedType = nm.suspectedType;
        
        string totalCompanyShares;
        List<SAF_Duedil.shareholder> shareholders;
        SAF_Duedil.companyshareholders csh = new SAF_Duedil.companyshareholders();
        countryCode = csh.countryCode;
        companyId = csh.companyId;
        pagination = csh.pagination;
        totalCompanyShares = csh.totalCompanyShares;
        shareholders = csh.shareholders;
        
        List<SAF_Duedil.officer> officers;
        SAF_Duedil.companyOfficers co = new SAF_Duedil.companyOfficers();
        countryCode = co.countryCode;
        companyId = co.companyId;
        pagination = co.pagination;
        officers = co.officers;
     
       // Test.stopTest();
    }
}