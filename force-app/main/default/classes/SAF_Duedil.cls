/**
    @ name                      : SAF_Duedil
    @ author                    : Happiest Minds/Phalguni
    @ description               : Get customer and its details from Duedil APi
    @ created date              : 11/16/2018   
    @ Modified by / Date        : 11/19/2018 
*/
Public class SAF_Duedil
{       
      public static final string COUNTRY_CODE = 'GB';
      static Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
    
     public static CustomersInfo getCustomers(string strcompanyName,string strlimit,string stroffset) {
    
     HttpRequest req = new HttpRequest();
     //req.setTimeout(120000);
     string url =  settings.getCustomers__c;//'https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
     url = url.replace('strlimit',strlimit).replace('stroffset',stroffset);
     req.setEndpoint(url);
     req.setMethod('POST');
     
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
     criteria crbody = new criteria();
     countryCodes cc = new countryCodes();
     simplifiedStatuses ss = new simplifiedStatuses();
     cc.values = new List<string> {COUNTRY_CODE};
     ss.values = new List<string> {'Active', 'Intermediate', 'Closed'};
     ss.mode = 'any';
     crbody.name  = strcompanyName; //'Friary Court (Plymouth) No.8 Management Company Limited';
     crbody.countryCodes =cc;
     crbody.simplifiedStatuses = ss;
     criterias cr = new criterias();
     cr.criteria =crbody; 
     string strbody = parseStringJson(cr);
     system.debug('***strbody: '+strbody);
     /*string strbody = '{ ' + 
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
        req.setHeader('X-AUTH-TOKEN', settings.Token__c );
        req.setbody(strbody);
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     CustomersInfo cs = new CustomersInfo();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
      if(res.getStatusCode() == 200)
     {
         cs = parseJSONString2(jsonStr);
         system.debug('***cspagination: '+cs.pagination); 
         system.debug('***csfilter: '+cs.filters); 
         if(cs.companies != null)
       {  
         for(customerInfo csinf:cs.companies)
         { system.debug('***csinf: '+csinf);} 
       }
     }
     return cs;
    } 
     public static SAF_PepSanction GetPepSanctionIndividual(Contact ObjCnt) {
    
     HttpRequest req = new HttpRequest();
      req.setTimeout(120000);
     //string url = 'https://duedil.io/v4/peps-sanctions/search/individuals.json';
      string url = settings.GetPepSanctionIndividual__c;
     //url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('POST');
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
  /*  string strbody = '{'+
  '"criteria": {'+
    '"anyIndividual": {'+
      '"firstName": "David",'+
      '"lastName": "Cameron",'+
      '"middleName": "",'+
      '"dateOfBirth": {'+
       ' "year": 1966'+
      '},'+
      '"address": "",' +
      '"city": "",'+
       ' "postcode": "",'+
       ' "countryCode": ""'+
    '}' +
 ' }'+
'}';*/
     SAF_PepSanction.cls_criteriaIndividual crbody = new SAF_PepSanction.cls_criteriaIndividual();
     crbody.anyIndividual = new SAF_PepSanction.cls_anyIndividual();
     crbody.anyIndividual.firstName = ObjCnt.FirstName;
     crbody.anyIndividual.lastName = ObjCnt.LastName;
     crbody.anyIndividual.middleName = (ObjCnt.ints__Middle_Name__c == null) ? '':ObjCnt.ints__Middle_Name__c ;
     crbody.anyIndividual.dateOfBirth = new SAF_PepSanction.cls_dateOfBirth();
     Integer intEmpty;
     crbody.anyIndividual.dateOfBirth.year = (ObjCnt.Birthdate !=null) ? Integer.valueof(ObjCnt.Birthdate.year()) : ((ObjCnt.SAF_DOB_year__c != null) ? Integer.valueof(ObjCnt.SAF_DOB_year__c) : intEmpty);
     crbody.anyIndividual.dateOfBirth.month = (ObjCnt.Birthdate !=null) ? Integer.valueof(ObjCnt.Birthdate.month()) : ((ObjCnt.SAF_DOB_Month__c != null) ? Integer.valueof(ObjCnt.SAF_DOB_Month__c) : intEmpty); 
     crbody.anyIndividual.dateOfBirth.day = (ObjCnt.Birthdate !=null) ? Integer.valueof(ObjCnt.Birthdate.day()):((ObjCnt.SAF_DOB_Day__c != null) ? Integer.valueof(ObjCnt.SAF_DOB_Day__c): intEmpty);
     crbody.anyIndividual.address = (ObjCnt.Otherstreet == null) ? '' :ObjCnt.Otherstreet;
     crbody.anyIndividual.city= (ObjCnt.Othercity == null) ? '' :ObjCnt.Othercity;
     crbody.anyIndividual.postcode = (ObjCnt.OtherPostalCode == null) ? '' : ObjCnt.OtherPostalCode;
     crbody.anyIndividual.countrycode=  (ObjCnt.OtherPostalCode == null) ? '' : 'gb';
     SAF_PepSanction.cls_criteriasInd cr = new SAF_PepSanction.cls_criteriasInd();
     cr.criteria =crbody; 
     string strbody = parsePEPIndStringJson(cr);
     if(crbody.anyIndividual.dateOfBirth.day == null) {strbody = strbody.replace('"day":null','').replace('"month":'+crbody.anyIndividual.dateOfBirth.month,'').replace(',,},','},');}
    system.debug('***strbody: '+strbody);
     req.setbody(strbody);
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     SAF_PepSanction gp1 = new SAF_PepSanction();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
      if(res.getStatusCode() == 200)
     {
         gp1 = SAF_PepSanction.parse(jsonStr);
       /*if(gp1.groupParents != null)
       {  
        //for(groupParent gpinf:gp.groupParents)
        // { system.debug('***gpinf: '+gpinf); } 
       }*/
     }
     return gp1;
    } 
     public static SAF_PepSanction GetPepSanctionBuisness(string CompanyId,string Countrycode) {
    
     HttpRequest req = new HttpRequest();
     req.setTimeout(120000);
     string url = settings.GetPepSanctionBuisness__c;
     // string url = 'https://duedil.io/v4/peps-sanctions/search/businesses.json';
     //url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('POST');
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
     SAF_PepSanction.cls_criteria crbody = new SAF_PepSanction.cls_criteria();
     crbody.duedilCompany = new SAF_PepSanction.cls_duedilCompany();
     crbody.duedilCompany.companyId = CompanyId;
     crbody.duedilCompany.countrycode= Countrycode;
     SAF_PepSanction.cls_criterias cr = new SAF_PepSanction.cls_criterias ();
     cr.criteria =crbody; 
     string strbody = parsePEPStringJson(cr);
     
    
    /*string strbody = '{' +
    '"criteria": {' +
    '"duedilCompany": {' +
    '  "companyId": "'+ CompanyId +'",' +
     ' "countryCode": "'+ Countrycode +'"' +
    '}' +
      '} ' +
    '}';*/
    system.debug('***strbody: '+strbody);
     req.setbody(strbody);
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     SAF_PepSanction gp1 = new SAF_PepSanction();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
      if(res.getStatusCode() == 200)
     {
         gp1 = SAF_PepSanction.parse(jsonStr);
       /*if(gp1.groupParents != null)
       {  
        //for(groupParent gpinf:gp.groupParents)
        // { system.debug('***gpinf: '+gpinf); } 
       }*/
     }else
     {gp1 = null;}
     return gp1;
    } 
    public static GroupCompanies GetGroupCompanies(string CompanyId,string Countrycode) {
    
     HttpRequest req = new HttpRequest();
     string url = settings.GetGroupCompanies__c ; //'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
     url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('GET');
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
    
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     GroupCompanies gp = new GroupCompanies();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
      if(res.getStatusCode() == 200)
     {
         gp = parseJSONStringGroupCompanies(jsonStr);
       if(gp.groupParents != null)
       {  
        for(groupParent gpinf:gp.groupParents)
         { system.debug('***gpinf: '+gpinf); } 
       }
     }
     return gp;
    } 
    
         
    public static relatedCompanies GetRelatedCompanies(string CompanyId,string Countrycode) {
    
     HttpRequest req = new HttpRequest();
     string url = settings.GetRelatedCompanies__c; //'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
     url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('GET');
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
    
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     relatedCompanies rc = new relatedCompanies();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
      if(res.getStatusCode() == 200)
     {
         rc = parseJSONStringRelatedCompanies(jsonStr);
          if(rc.relatedCompanies != null)
           {   
            for(relatedcompany rcinf:rc.relatedCompanies)
             { system.debug('***rcinf: '+rcinf); } 
           }
     }
     return rc;
    } 
    
     public static companyshareholders GetShareholders(string CompanyId,string Countrycode) {
    
     HttpRequest req = new HttpRequest();
     string url = settings.GetShareholders__c; //'https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
     url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('GET');
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
    
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     companyshareholders  sh = new companyshareholders();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     system.debug('***Jsonstring: '+jsonStr);
     
     if(res.getStatusCode() == 200)
     {
        sh = parseJSONStringCompanyShareholders(jsonStr);
        if(sh.shareholders != null)
        {
            for(shareholder shinf:sh.shareholders)
             { system.debug('***shinf: '+shinf); }
        } 
     }
     return sh;
    } 
    
      public static companyofficers GetcompanyOfficers(string CompanyId,string Countrycode) {
    
     HttpRequest req = new HttpRequest();
     string url = settings.GetcompanyOfficers__c; //'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
     url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('GET');
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
    
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     companyofficers co = new companyofficers();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
     if(res.getStatusCode() == 200)
         {
             co = parseJSONStringCompanyOfficers(jsonStr); 
            if(co.officers != null)
           {  
             for(officer coinf:co.officers)
             { system.debug('***coinf: '+coinf); 
               if(coinf.appointments !=null && coinf.appointments.size() > 0) coinf.officialRoleposition = coinf.appointments[0].officialRole + ' - ' + coinf.appointments[0].selfDescribedPosition;
               
             } 
           }
        }
      return co;
    } 
    
     public static CustomerInfo GetCompanyInfo(string CompanyId,string Countrycode)
    {
     HttpRequest req = new HttpRequest();
     string url = settings.GetCompanyInfo__c; //'https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
     url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('GET');
     
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
   
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     
     CustomerInfo cs = new CustomerInfo();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
     
     cs = parseJSONString(jsonStr);
     system.debug('***Jsonstring: '+cs);
     return cs;
    } 
      public static IndustriesInfo GetIndustryInfo(string CompanyId,string Countrycode)
    {
     HttpRequest req = new HttpRequest();
     string url = 'https://duedil.io/v4/company/Countrycode/CompanyId/industries.json?limit=20&offset=0';
      system.debug('##################CompanyId : '+CompanyId );
      system.debug('##################Countrycode : '+Countrycode);
       system.debug('##################url : '+url);
     url = url.replace('Countrycode',Countrycode).replace('CompanyId',CompanyId);
     req.setEndpoint(url);
     req.setMethod('GET');
     
     req.setHeader('X-AUTH-TOKEN', settings.Token__c);
   
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     
     IndustriesInfo cs = new IndustriesInfo();
     string slash = '/';
     String jsonStr = res.getBody();//.replace(slash,'');
     //system.debug('***Jsonstring: '+jsonStr);
     cs = parseJSONStringIndustries(jsonStr);
     system.debug('***Jsonstring: '+cs);
     return cs;
    } 
    //JSON parser class
     Public class IndustriesInfo {
        //WebPortalAutomationProcessUpdate.LoanDetails loanDetails;
        //CL_WebPortalAutomationProcessUpdateNew.LoanDetails loanDetails;
        Public pagination pagination{get; set;}
        public filters filters{get; set;}
        public List<IndustryInfo> Industries{get; set;}
    } 
     Public class IndustryInfo {
        
        Public string name{get; set;}
        public string code{get; set;}
        public string type{get; set;}
    } 
    Public class CustomerInfo {
     public string countryCode{get; set;}
     public string companyId{get; set;}
     public string name{get; set;}
     public string newname{get; set;}
     public legalEntityIdentifier legalEntityIdentifier{get; set;}
     
     public string  type{get; set;}
     public string  incorporationCountry{get; set;}
     public string  incorporationDate{get; set;}
     public string  officialStatus{get; set;}
     public string  simplifiedStatus{get; set;}
     public string  numberOfEmployees{get; set;}
     public string  primaryWebsite{get; set;}
  
     public registeredAddress registeredAddress{get; set;}
 
     public string  charitableIdentitiesCount{get; set;}
     public accounts  accounts{get; set;}
   
     public financialSummary  financialSummary{get; set;}
     public string AccountId{get; set;}
     public boolean ischecked{get; set;}
    }
    Public class CustomersInfo {
        //WebPortalAutomationProcessUpdate.LoanDetails loanDetails;
        //CL_WebPortalAutomationProcessUpdateNew.LoanDetails loanDetails;
        Public pagination pagination{get; set;}
        public filters filters{get; set;}
        public List<CustomerInfo> companies{get; set;}
    } 
    Public class reasonCode 
    {
        public String value{get; set;}
        public string description{get; set;}
    }
     Public class legalEntityIdentifier 
    { 
     
      public string lei{get; set;}
     public  string sourceUrl{get; set;}
    }
     
    Public class registeredAddress {
      
     public  string fullAddress{get; set;}
     public  structuredAddress structuredAddress{get; set;}
     public  geolocation geolocation{get; set;}  
     }
    
     Public class  structuredAddress {
       public  string  premises{get; set;}
     public  string  thoroughfare{get; set;}
     public  string  dependentLocality{get; set;}
     public  string  postTown{get; set;}
     public  string  county{get; set;}
     public  string  postcode{get; set;}
     public string countryCode{get; set;}
     }
      Public class  geolocation { 
       public  string  latitude{get; set;}
     public  string  longitude{get; set;}
     }
    
     Public class  accounts { 
       public  string filingType{get; set;}
     //public  string currency{get; set;}
     public  string latestAccountsDate{get; set;}
     public  string consolidatedAccounts{get; set;}
     public  string nextAccountsDueDate{get; set;}
     }
   
     Public class  financialSummary {   
       public  string turnover{get; set;}
     public  string ebitda{get; set;}
     public  string postTaxProfit{get; set;}
     public  string totalAssets{get; set;}
     public  string netAssets{get; set;} 
     }
     
      Public class  pagination {
        public  string offset{get; set;}
        //public  string Limit;
        public  string total{get; set;}
      }
       Public class  filters {
       public  string name{get; set;}
        public  simplifiedStatuses simplifiedStatuses{get; set;}
        public  countryCodes countryCodes{get; set;}
       }
       Public class  simplifiedStatuses {
       public  list<string> values{get; set;}
       public  string mode{get; set;}
       }
       
       Public class  countryCodes {
       public  list<string> values{get; set;}
       }
        Public class  criteria {
        public  string name;
        public  countryCodes countryCodes;
         public simplifiedStatuses simplifiedStatuses;
       }
         Public class  criterias {
        public  criteria criteria;

       }
         
  Public class groupParent{
     public string countryCode{get; set;}
     public string  companyId{get; set;}
     public string  name{get; set;}
     public string  degreeOfSeparation{get; set;}
     public string  isImmediateParent{get; set;}
     public string  isUltimateParent{get; set;}
     public string  AccountId{get; set;}
     public string  ConnectionType{get; set;}
     public boolean ischecked{get; set;}
    }
      Public class GroupCompanies{
        
        Public pagination pagination{get; set;}
        public string countryCode{get; set;}
        public string  companyId{get; set;}
        public List<groupParent> groupParents{get; set;}
    } 
    Public class relatedCompany{
     public string countryCode{get; set;}
     public string  companyId{get; set;}
     public string  officialStatus{get; set;}
     public string  simplifiedStatus{get; set;}
     public string  name{get; set;}
     public string  confidence{get; set;}
     public decimal nameSimilarityScore{get{return nameSimilarityScore.setscale(2);} set;}
     public string  AccountId{get; set;}
     public mutualAddresses mutualAddresses{get; set;}
     public mutualMajorShareholders mutualMajorShareholders{get; set;}
     public mutualOfficers  mutualOfficers{get; set;}
     public mutualInvestments mutualInvestments{get; set;}
     public boolean ischecked{get; set;}
     
    }
     Public class mutualAddresses{
     Public string count{get; set;}
     }
     Public class mutualMajorShareholders{
     Public string count{get; set;}
     }
     
     Public class mutualOfficers{
     Public string count{get; set;}
     }
     
     Public class mutualInvestments{
     Public string count{get; set;}
     }
     
     Public class relatedCompanies{
     public string countryCode{get; set;}
     public string  companyId{get; set;}
     Public pagination pagination{get; set;}
     Public List<relatedCompany> relatedCompanies{get; set;}
     /*public string AccountId{get; set;}
     public boolean ischecked{get; set;}*/
     }
     Public class dateOfBirth{
     public string year{get; set;}
     public string  month{get; set;}
     public string  monthYear{get; set;}
    }
     Public class person{
     public string honorific{get; set;}
     public string  firstName{get; set;}
     public string  middleName{get; set;}
     public string  lastName{get; set;}
     public dateOfBirth dateOfBirth{get; set;}
     //public nationalities nationalities{get; set;}
    public string officerId{get; set;}
    }
     Public class nationalities{
      public string demonym{get; set;} 
      public string countryCode{get; set;} 
    }
     Public class officer{
     public string officerId{get; set;}
     public string type{get; set;}
     public person person{get; set;}
     public string isShareholder{get; set;}
     public CustomerInfo company{get; set;}
     public string Relationship{get; set;}
     public List<appointment> appointments{get; set;}
     public string officialRolePosition{get; set;}
     public string  ContactId{get; set;}
     public boolean ischecked{get; set;}
     public boolean isDirector{get; set;}
     public decimal totalShareholdingPercentage{get{return totalShareholdingPercentage.setscale(2);} set;}
   }
    Public class appointment{
        public string status{get; set;}    
        public string startDate{get; set;}       
        public string endDate{get; set;}       
        public string officialRole{get; set;}    
        public string selfDescribedPosition{get; set;}    
        public registeredAddress serviceAddress{get; set;}           
  }
  Public class exactMatch{
         public string type{get; set;}    
        public person person{get; set;}       
        public CustomerInfo company{get; set;}       
               
  }
  Public class nominalValue{
      public string value{get; set;}    
      //public string currency;        
    }
    
    Public class shareholding{
        //public string class;           
        public string numberOfShares{get; set;}        
        public string  percentageOfShares{get; set;}         
        public nominalValue nominalValue{get; set;}          
    }
   Public class shareholder{
      
    public string sourceName{get; set;} 
    public string totalShareholding{get; set;}
    public decimal totalShareholdingPercentage{get{return totalShareholdingPercentage.setscale(2);} set;}
    public List<shareholding> shareholdings{get; set;}
    public List<exactMatch> exactMatches{get; set;}
    public string  ContactId{get; set;}
    public string  CustomerId{get; set;}
    public string  ShareholderId{get; set;}
    public string  Relationship{get; set;}
    public notMatched notMatched{get; set;}
    public string exactMatchType{get; set;}
    public boolean ischecked{get; set;}
    }
    Public class notMatched{
      public string suspectedType{get; set;} 
    }
   Public class companyshareholders{
      
     public string countryCode{get; set;}  
     public string  companyId{get; set;} 
     Public pagination pagination{get; set;}  
     public string totalCompanyShares{get; set;} 
     public List<shareholder> shareholders{get; set;} 
    }
    
     Public class companyOfficers{
      
     public string countryCode{get; set;}
     public string  companyId{get; set;}
     Public pagination pagination{get; set;}
     public List<officer> officers{get; set;}
    }
    Public class cls_PepSanction {
        Public Integer totalmatches;  //95
        Public Boolean noofmatchscoreabove90; //>90 Red
        Public Boolean noofmatchscoreabove90con;
        Public string strPepAppId; 
        Public List<saf_pep_sanction_info__c> AllpepInfo;
        Public List<saf_Pep_addresses__c> Alladdr;
        Public List<saf_Pep_Relatednames__c> Allrel;
        Public List<saf_Pep_categories__c> Allcat;
        Public List<saf_Pep_documents__c> Alldoc;
        Public List<saf_Pep_globalDatasets__c> Allgd;
        Public List<saf_Pep_linkedBuisnesses__c> AlllinkBuis;
        Public List<saf_Pep_linkedIndividuals__c> AlllinkInd;
        Public List<saf_Pep_notes__c> Allnote;
        Public List<saf_Pep_sanctions__c> Allsanc;
        Public List<saf_pep_PoliticalPositions__c> Allpp;
        Public List<saf_pep_aliases__c> Allpepalia;
        Public List<saf_pep_nationalities__c> Allpn;
        Public List<saf_pep_sanction_Individual__c> Allind;
    }
    //To deserialize the JSON string
    Public static CustomerInfo parseJSONString(String json) {
        return (CustomerInfo)System.JSON.deserialize(json,CustomerInfo.class);
    }   
     Public static CustomersInfo parseJSONString2(String json) {
        return (CustomersInfo)System.JSON.deserialize(json,CustomersInfo.class);
    }   
    Public static GroupCompanies parseJSONStringGroupCompanies(String json) {
        return (GroupCompanies)System.JSON.deserialize(json,GroupCompanies.class);
    } 
     Public static relatedCompanies parseJSONStringRelatedCompanies(String json) {
        return (relatedCompanies)System.JSON.deserialize(json,relatedCompanies.class);
    } 
    Public static companyshareholders parseJSONStringCompanyShareholders(String json) {
        return (companyshareholders)System.JSON.deserialize(json,companyshareholders.class);
    } 
     Public static companyOfficers parseJSONStringCompanyOfficers(String json) {
        return (companyOfficers)System.JSON.deserialize(json,companyOfficers.class);
    }   
     Public static IndustriesInfo parseJSONStringIndustries(String json) {
        return (IndustriesInfo)System.JSON.deserialize(json,IndustriesInfo.class);
    }     
    Public static string parseStringJson(criterias cr) {
        return (string)System.JSON.serialize(cr);
    } 
    Public static string parsePEPStringJson(SAF_PepSanction.cls_criterias cr) {
        return (string)System.JSON.serialize(cr);
    } 
     Public static string parsePEPIndStringJson(SAF_PepSanction.cls_criteriasInd cr) {
        return (string)System.JSON.serialize(cr);
    }   
}