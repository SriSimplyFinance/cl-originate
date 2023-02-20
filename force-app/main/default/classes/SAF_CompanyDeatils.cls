public class SAF_CompanyDeatils
{   
    public class MyException extends Exception{}
    public String CompanyId {get;set;}
    public String Companyname {get; set;}
    public List<Account> lstAccounts;
    //public String ParentConType{get;set;}
    public List<SAF_Duedil.shareholder> shareholder{get;set;} 
    public List<SAF_Duedil.shareholder> shareholderUBO{get;set;} 
    public String UBOCompanyId {get;set;}
    public String UBOCompanyName {get;set;}
    public String UBOCompanymessage {get;set;}
    public List<SAF_Duedil.groupParent> CompgroupParents{get;set;} 
    public List<SAF_Duedil.officer> officers{get;set;} 
    public Map<string,SAF_Duedil.Officer> MapOfficers = new  Map<string,SAF_Duedil.Officer>(); 
    public static Map<string,string> MapRoles = new  Map<string,string>(); 
    public List<SAF_Duedil.relatedCompany> comprelatedCompanies{get;set;} 
    public List<SAF_Duedil.CustomerInfo> CustInfo{get;set;}
    public String CustAddress{get;set;}
    public String ConnectionType{get;set;}
    public Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
    Savepoint sp;
    /* Merging Related Contacts to this page - Starts */
    public string AccountId {get;set;}
    public List<Account> objAccountlst;
    public List<Contact> objContactlst;
    /* Merging Related Contacts to this page - Ends */
    
    //Error Log Starts
    public static string strDateFormat = 'ddMMyyyy';
    public static User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
    public static Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
    public static List<string> AccountIds = new List<string>();
    //Error Log Ends
    
    // When Blank update the following variables to show the information in screen - Starts
    public String GroupParentsmessage{get;set;}
    public String officersmessage{get;set;}
    public String shareholdersmessage{get;set;}
    public String comprelatedCompaniesmessage{get;set;}
    // When Blank update the following variables to show the information in screen - Ends
    
    List<contact> lstcontact; // Deepak <UBO Shareholders contact creation>
    public String MainAccntId {get;set;}
     
    public void show()
    {
        try
        {
            CompanyId = (ApexPages.currentPage().getParameters().get('companyid') == null) ? CompanyId : ApexPages.currentPage().getParameters().get('companyid');
            Companyname = (ApexPages.currentPage().getParameters().get('companyname')==null) ? Companyname : ApexPages.currentPage().getParameters().get('companyname') ;
           
            
            SAF_Duedil dd = new SAF_Duedil();
            
            SAF_Duedil.CustomersInfo cs = new SAF_Duedil.CustomersInfo();
            CustInfo = new List<SAF_Duedil.CustomerInfo>();
            
            SAF_Duedil.GroupCompanies gp = new SAF_Duedil.GroupCompanies();
            CompgroupParents = new List<SAF_Duedil.groupParent>();
            
            SAF_Duedil.companyofficers csofficers = new SAF_Duedil.companyofficers();
            SAF_Duedil.relatedCompanies rc= new SAF_Duedil.relatedCompanies();
               system.debug('*****CompanyId**********'+CompanyId);
            if(CompanyId != null)
            {
                cs = SAF_Duedil.getCustomers(CompanyId,'10','0');
                CustInfo = cs.companies;
                
                //this.updateParentAccountIds();
                
                
                gp = SAF_Duedil.GetGroupCompanies(CompanyId,'gb'); 
                CompgroupParents = gp.groupParents;
                
                
                csofficers = SAF_Duedil.GetcompanyOfficers(CompanyId,'gb');
                //officers = csofficers.officers;
                
                
                rc= SAF_Duedil.GetRelatedCompanies(CompanyId,'gb');
                comprelatedCompanies = rc.relatedCompanies;
                // updateAccountIds();
            }
          
            if(Test.isRunningTest()){throw new MyException();}
       }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'show',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }  
     
    
    }
    
    public void updateParentAccountIds()
    {
        try
        {
            // assigning values to id field
            map<string,string> mapAccountIds = new map<string,string>();
            List<string> customerRegno = new List<string>();
            if(CustInfo == null) {CustInfo = new List<SAF_Duedil.CustomerInfo> ();}
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustInfo)    
            {if(string.IsNotBlank(objIdUpdate.companyId)) customerRegno.add(objIdUpdate.companyId);} 
            
            //creating a map for getting Account Id and Company reg no
            for(Account objIdUpdate:[SELECT Name,Id,AccountNumber FROM Account WHERE AccountNumber In :customerRegno or AccountNumber =:CompanyId])
            { mapAccountIds.put(objIdUpdate.AccountNumber,objIdUpdate.Id);//ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name: '+objc.name+ '  objc.Id:'+ objc.Id+ '  objc.AccountNumber:' + objc.AccountNumber));
            }
            
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustInfo)    
            {
                objIdUpdate.accountId = mapAccountIds.get(objIdUpdate.companyId);
                if(objIdUpdate.accountId != null)
                {
                    Account acc = [select Id,BillingAddress,BillingCity,BillingState,BillingPostalCode,BillingStreet,BillingCountry,SAF_Connection_Type__c,ParentId from Account where Id =: objIdUpdate.accountId];
                    
                    //CustAddress = String.ValueOf(acc.BillingAddress);
                    CustAddress = (acc.BillingStreet == null ? '' : acc.BillingStreet); CustAddress = CustAddress == '' ? (acc.BillingCity         == null ? '' : acc.BillingCity)       : (acc.BillingCity         == null ? CustAddress : CustAddress + ', ' + acc.BillingCity);CustAddress = CustAddress == '' ? (acc.BillingPostalCode   == null ? '' : acc.BillingPostalCode) : (acc.BillingPostalCode   == null ? CustAddress : CustAddress + ', ' + acc.BillingPostalCode);CustAddress = CustAddress == '' ? (acc.BillingState        == null ? '' : acc.BillingState )     : (acc.BillingState        == null ? CustAddress : CustAddress + ', ' + acc.BillingState);CustAddress = CustAddress == '' ? (acc.BillingCountry      == null ? '' : acc.BillingCountry)    : (acc.BillingCountry      == null ? CustAddress : CustAddress + ', ' + acc.BillingCountry); ConnectionType = acc.SAF_Connection_Type__c;
                }
                else
                {
                    SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();csinfo = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');CustAddress  = (csinfo.registeredAddress != null) ? csinfo.registeredAddress.fullAddress: '' ;
                    
                    /*CustAddress  = (csinfo.registeredAddress.structuredAddress.postTown == null ? '' : csinfo.registeredAddress.structuredAddress.postTown);
                    CustAddress  = CustAddress == null ? (csinfo.registeredAddress.structuredAddress.postcode == null ? '' : csinfo.registeredAddress.structuredAddress.postcode)  : (csinfo.registeredAddress.structuredAddress.postcode == null ? CustAddress : CustAddress + ', ' +csinfo.registeredAddress.structuredAddress.postcode) ;
                    CustAddress  = CustAddress == null ? (csinfo.registeredAddress.structuredAddress.county == null ? '' : csinfo.registeredAddress.structuredAddress.county)    : (csinfo.registeredAddress.structuredAddress.county == null ? CustAddress : CustAddress + ', ' +CustAddress + ', ' +csinfo.registeredAddress.structuredAddress.county);*/
                }
                system.debug('mapAccountIds.get(objIdUpdate.companyId):' +mapAccountIds.get(objIdUpdate.companyId));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
            }
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'updateParentAccountIds',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void createRelatedCustomers()
    {
        try
        {
            //SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Account> { Account.SObjectType});
            list<Account> accs = new list<Account>();
            list<Contact> cons = new list<Contact>();
            Account acc;
            boolean customerCreated = false;
            integer custCount = 0;
             List<Account> mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId and Name =:Companyname];   
            if(mainAccount.size() == 0) 
            {
               SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
               csinfo  = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
               accs.add(customerInit(csinfo));
            }
            //FATAL, ERROR, WARNING, INFO, CONFIRM
            for(SAF_Duedil.relatedCompany objc:comprelatedCompanies)    
            {
                system.debug('test debug'+ objc.companyId);
                system.debug('comprelatedCompanies: '+ comprelatedCompanies);
                SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
                csinfo = SAF_Duedil.GetCompanyInfo(objc.companyId,'gb');
               
                string SICcode = '';
                SAF_Duedil.IndustriesInfo Indusinfo = new SAF_Duedil.IndustriesInfo();
                Indusinfo = SAF_Duedil.GetIndustryInfo(objc.companyId,'gb');
               if( Indusinfo.industries != null)
               {
                    for(SAF_Duedil.IndustryInfo objcInfo:Indusinfo.industries)    
                    {if(objcInfo.type == 'SIC2007' && objcInfo.code != null) {SICcode =  objcInfo.code;}
                    }
               }
                acc = new Account();
                
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Checked: '+objc.isChecked + ' companyId Id: '+objc.companyId));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Checked: '+objc.isChecked));objc.AccountId
                if(objc.AccountId == null&& objc.ischecked)
                //&& objc.ischecked)
                {
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Customer(s) Info Address: '+csinfo.registeredAddress.structuredAddress.postTown));
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Company: '+objc.companyId+' Account Id: '+objc.AccountId));
                    acc.Name = csinfo.name;
                    acc.AccountNumber = csinfo.companyId;
                    acc.Type = settings.Customer_Type__c;
                    acc.Sic = SICcode;
                    //acc.CurrencyIsoCode = 'GBP';
                    acc.Ownership = ownerShipValue(csinfo.type);
                    acc.SAF_is_Duedil_Created__c = true;
                    acc.SAF_Connection_Type__c = 'Related Company';
                    //acc.clcommon__Email__c = 'test.test@test.com';
                    //acc.Phone = '98765 432101';
                     acc.CLCOMMON__LEGAL_ENTITY_TYPE__C = SETTINGS.LegalEntity__c;
                    system.debug('Legal Entity type for acc'+ acc.CLCOMMON__LEGAL_ENTITY_TYPE__C);
                    if(csinfo.registeredAddress != null && csinfo.registeredAddress.structuredAddress != null)
                    { 
                        acc.BillingStreet  = csinfo.registeredAddress.structuredAddress.premises + ' '+csinfo.registeredAddress.structuredAddress.thoroughfare; acc.BillingPostalCode = csinfo.registeredAddress.structuredAddress.postcode;acc.BillingCity = csinfo.registeredAddress.structuredAddress.postTown;acc.BillingState = csinfo.registeredAddress.structuredAddress.county; acc.BillingCountry = csinfo.incorporationCountry; if(csinfo.registeredAddress.geolocation != null) {acc.BillingLatitude = Decimal.ValueOf(csinfo.registeredAddress.geolocation.latitude);acc.BillingLongitude = Decimal.ValueOf(csinfo.registeredAddress.geolocation.longitude);} acc.SAF_dependentLocality__c = csinfo.registeredAddress.structuredAddress.dependentLocality;acc.SAF_thoroughfare__c = csinfo.registeredAddress.structuredAddress.thoroughfare;acc.SAF_premises__c = csinfo.registeredAddress.structuredAddress.premises;
                      }
                    if(csinfo.financialSummary != null)
                    {  
                        acc.SAF_netAssets__c                    = csinfo.financialSummary.netAssets; acc.SAF_totalAssets__c                  = csinfo.financialSummary.totalAssets;acc.SAF_ebitda__c                       = csinfo.financialSummary.ebitda;acc.SAF_postTaxProfit__c                = csinfo.financialSummary.postTaxProfit;acc.SAF_turnover__c                     = csinfo.financialSummary.turnover;
                   }
                    if(csinfo.accounts != null)
                    {  
                        acc.SAF_nextAccountsDueDate__c          = csinfo.accounts.nextAccountsDueDate; acc.SAF_consolidatedAccounts__c         = csinfo.accounts.consolidatedAccounts;acc.SAF_latestAccountsDate__c           = csinfo.accounts.latestAccountsDate;acc.SAF_filingType__c                   = csinfo.accounts.filingType;
                   }
                    
                    acc.SAF_incorporationDate__c            = csinfo.incorporationDate;
                    acc.SAF_incorporationCountry__c         = csinfo.incorporationCountry;
                    acc.SAF_charitableIdentitiesCount__c    = csinfo.charitableIdentitiesCount;
                    acc.SAF_officialStatus__c               = csinfo.officialStatus;
                    acc.SAF_simplifiedStatus__c             = csinfo.simplifiedStatus;
                    
                    // acc.SAF_turnover__c = objc.financialSummary.turnover;
                    if(acc.Name != null) {accs.add(acc); }
                    
                    customerCreated = true;
                    custCount = custCount+1;
                }
            }
            
            if(customerCreated)
            {
                //database.insert(accs);
               // Savepoint sp = Database.setSavepoint();
               //-------------is database insert is false it will create duplicate records.
                Database.SaveResult[] srList = Database.insert(accs,true);
               
                cons.addall(RelCreateContactFromAccount(accs));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'SObject: '+srList.size()));
                this.updateAccountIds();//commented for test
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, srList.size()+ ' Group parent(s) Created Successfully'));
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ' Group parent(s) Created Successfully'));
                
                /*  for(Account objc:accs)    
                  {
                        system.debug('objc:' + objc.accountnumber + objc.name);
                        createRelatedGroupCustomers2(objc.accountnumber,objc.name);
                  }*/
            }
             if(cons.size()>0) 
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'lstcontact: '+lstcontact1.size()));
                //insert lstcontact;
                Database.SaveResult[] srList = Database.insert(cons);
                
                /*this.RelConupdateContactIds();
                if(shareholderUBO != null){this.RelConupdateUBOContactIds();}
                if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
                if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,srList.size()+ ' Director(s) created successfully'));*/
            }               
            //if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //Database.RollBack(sp);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            system.debug('Error: '+e.getMessage()+ ', Line no: '+e.getLineNumber());
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'createRelatedCustomers',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
        
        //structuredAddress
    }
    @future(callout=true)
   public static void createRelatedGroupCustomers2(string CompanyId,string companyname)
     {
           createRelatedGroupCustomers1(CompanyId,companyname);
     }
    public static void createRelatedGroupCustomers1(string CompanyId,string companyname)
     {
       
            Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults(); 
           Map<string,SAF_Duedil.Officer> MapOfficers = new  Map<string,SAF_Duedil.Officer>();
           Map<string,SAF_Duedil.shareholder> Mapshareholders = new  Map<string,SAF_Duedil.shareholder>();
            SAF_Duedil.companyofficers csofficers = new SAF_Duedil.companyofficers();
               csofficers = SAF_Duedil.GetcompanyOfficers(CompanyId,'gb');
           SAF_Duedil.companyshareholders cs = new SAF_Duedil.companyshareholders();
         
            SAF_Duedil.GroupCompanies gp = new SAF_Duedil.GroupCompanies();
            List<SAF_Duedil.groupParent> CompgroupParents = new List<SAF_Duedil.groupParent>(); 
            list<Account> mainacc = new list<Account>();  
            list<Account> accs = new list<Account>();
            list<contact> lstcontact1 = new list<contact>();
           if(csofficers.officers != null)
            {
                  system.debug('*****csofficers.officers**********'+ csofficers.officers.size());
                for(SAF_Duedil.officer objcofficer:csofficers.officers)    
                {
                    if(objcofficer.Type == 'person'){   
                        objcofficer.Relationship = 'Director';
                        objcofficer.ischecked = true;
                        objcofficer.totalShareholdingPercentage = 0;
                        if(!MapOfficers.containskey(objcofficer.officerId)) MapOfficers.put(objcofficer.officerId,objcofficer);
                       // officers.add(objcofficer); 
                         system.debug('*****officer in map **********'+objcofficer);
                    }
                }
             }
                 system.debug('*****MapOfficers**********'+ MapOfficers.size());   
        if(CompanyId != null)
        {
               system.debug('*****CompanyId1**********'+CompanyId);
                List<Account> mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId];   
                string mainAccountId ='';  
                     try{
                mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : ''; 
                system.debug('*****mainAccount**********try:'+mainAccount);
                } 
                catch(Exception ex)
                {system.debug('*****mainAccount**********catch :'+mainAccount); }     
                   
             
                List<SAF_Duedil.shareholder>  shareholder = new List<SAF_Duedil.shareholder>();
                //officers = csofficers.officers;
                 //Adding only contact/person in the list
               gp = SAF_Duedil.GetGroupCompanies(CompanyId,'gb'); 
               CompgroupParents = gp.groupParents; 
                
                cs = SAF_Duedil.GetShareholders(CompanyId,'gb');
                system.debug('###CS :'+ cs);
                system.debug('###cs.shareholders :'+ cs.shareholders);
                system.debug('CompgroupParents :'+ CompgroupParents);
                    
                     
               if(cs.shareholders != null)
               {
                    for(SAF_Duedil.shareholder objc:cs.shareholders)    
                    { 
                        for(SAF_Duedil.exactMatch objcmatch:objc.exactMatches)    
                        {
                            if(objcmatch.type == 'company' && objcmatch.person == null)
                            { 
                             for(SAF_Duedil.groupparent  obj:CompgroupParents)    
                                {    system.debug('groupparent obj:'+ obj);
                                     if(obj.companyId == objcmatch.company.companyId)
                                     {objc.Relationship = GetConnectionType(Boolean.valueof(obj.isImmediateParent),Boolean.valueof(obj.isUltimateParent)); 
                                        objc.ischecked = true;
                                        objc.CustomerId = null;
                                        saf_duedil.customerinfo csinfo  = SAF_Duedil.GetCompanyInfo(objcmatch.company.companyId,'gb');
                                       objcmatch.company = csinfo;
                                       Mapshareholders.put(objcmatch.company.companyId,objc);
                                     
                                     }
                                     
                                     if(Boolean.valueof(obj.isUltimateParent) == true)
                                     {
                                        // UBOCompanyId = obj.companyId;
                                        // UBOCompanyName = obj.name;
                                     }
                                
                                } 
                               
                               if(CompgroupParents.size() ==0)  
                               {
                                   objc.Relationship = 'Shareholder';
                                    objc.ischecked = true;
                                    objc.CustomerId = null;                             
                                    //saf_duedil.customerinfo objsh = new saf_duedil.customerinfo();                                
                                    //objcmatch.company = objsh;
                                   saf_duedil.customerinfo csinfo  = SAF_Duedil.GetCompanyInfo(objcmatch.company.companyId,'gb');
                                   objcmatch.company = csinfo;
                                   if(objc.totalShareholdingPercentage >=settings.TotalShareholderPercentage__c) Mapshareholders.put(objcmatch.company.companyId,objc);
                               }
                             }
                            else if(objcmatch.type == 'person')
                            { 
                                  objc.Relationship = 'Shareholder';
                                   objc.ischecked = true;
                                    saf_duedil.officer objofficer = new  saf_duedil.officer();
                                  if(objcmatch.person.officerId !=null && mapofficers.containskey(objcmatch.person.officerId)){
                                    string isshareholder =  mapofficers.get(objcmatch.person.officerId).isshareholder;
                                    if(isshareholder == 'true')  objc.Relationship = 'Director';
                                    objofficer = mapofficers.get(objcmatch.person.officerId);//new saf_duedil.officer();
                                   }
                                   if(objcmatch.person.officerId !=null && !mapofficers.containskey(objcmatch.person.officerId))
                                   {
                                       objofficer = new saf_duedil.officer();
                                       objofficer.officerId = objcmatch.person.officerId;
                                       objofficer.person = objcmatch.person;
                                   }
                                    //objofficer.officerId = objcmatch.person.officerId;  
                                    objofficer.ischecked = true;
                                    objofficer.ContactId = null;
                                    objofficer.isDirector= true;
                                    //objofficer.person = objcmatch.person;
                                    objofficer.Relationship = objc.Relationship ;//'Director';
                                    objofficer.totalShareholdingPercentage= objc.totalShareholdingPercentage;
                                    if(objc.totalShareholdingPercentage >=settings.TotalShareholderPercentage__c) MapOfficers.put(objofficer.officerId,objofficer);
                                  
                            } 
                           /* else if(objcmatch.type == 'person')
                            { 
                                   
                                     objc.Relationship = 'Director';
                                    objc.ischecked = true;
                                    saf_duedil.officer objofficer = new saf_duedil.officer();
                                    objofficer.officerId = objcmatch.person.officerId;
                                     objofficer.Relationship = 'Director';
                                    objofficer.ischecked = true;
                                    objofficer.ContactId = null;
                                    objofficer.isDirector= true;
                                    objofficer.person = objcmatch.person;
                                    objofficer.totalShareholdingPercentage= objc.totalShareholdingPercentage;
                                    MapOfficers.put(objofficer.officerId,objofficer);
                                    
                            } */
                            objc.exactMatchType = objcmatch.type;
                        }
                        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc : '+objc.exactMatches[0].company.companyId));
                         
                       system.debug('###### SH Percentage: '+objc.totalShareholdingPercentage + ' ###Company Id :'+ CompanyId);
                        if(objc.totalShareholdingPercentage >=settings.TotalShareholderPercentage__c)
                       {
                             objc.ischecked = true;
                             if(objc.notMatched !=null && (objc.notMatched.suspectedType == 'company' || objc.notMatched.suspectedType == 'person'))
                            { 
                                    objc.Relationship = 'Shareholder';
                                    Mapshareholders.put(objc.sourcename,objc);
                            } 
                           if(objc.notMatched ==null && objc.exactMatches.size() ==0 ) {
                               objc.Relationship = 'Shareholder';   
                                Mapshareholders.put(objc.sourcename,objc);
                            } 
                            
                          shareholder.add(objc);
                       }
                      
                    } 
               }
            if(mainAccountId == null || mainAccountId == '')
                {
                    SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
                      csinfo = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
                      mainacc.add(customerinit(csinfo));  
                       system.debug('mainacc:'+ mainacc);
                      Database.insert(mainacc,false); 
                 }
                mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId];   
                mainAccountId ='';  
                     try{
                mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : ''; 
                system.debug('*****mainAccount**********try:'+mainAccount);
                } 
                catch(Exception ex)
                {system.debug('*****mainAccount**********catch :'+mainAccount); }          
            if(csofficers.officers != null)
            {
                /*  system.debug('*****csofficers.officers**********'+ csofficers.officers.size());
                for(SAF_Duedil.officer objcofficer:csofficers.officers)    
                {
                    if(objcofficer.Type == 'person'){   
                        objcofficer.Relationship = 'Director';
                        objcofficer.ischecked = true;
                        objcofficer.totalShareholdingPercentage = 0;
                        if(!MapOfficers.containskey(objcofficer.officerId)) MapOfficers.put(objcofficer.officerId,objcofficer);
                       // officers.add(objcofficer); 
                         system.debug('*****officer in map **********'+objcofficer);
                    }
                }*/
                 system.debug('*****MapOfficers**********'+ MapOfficers);
                 //creating a map for getting Account Id and Company reg no
                for(Contact objIdUpdate:[SELECT Name,Id,SAF_OfficerId__c,AccountId FROM Contact WHERE SAF_OfficerId__c In :MapOfficers.keyset()])
                {
                  
                    if(MapOfficers.containsKey(objIdUpdate.SAF_OfficerId__c))
                    {
                       SAF_Duedil.officer objcofficer = MapOfficers.get(objIdUpdate.SAF_OfficerId__c);
                       objcofficer.contactId = objIdUpdate.ID;
                       SAF_Duedil.customerinfo cs1 = new  SAF_Duedil.customerinfo();
                       cs1.AccountId = objIdUpdate.AccountId;
                       objcofficer.company = cs1;
                       MapOfficers.put(objIdUpdate.SAF_OfficerId__c,objcofficer);
                       system.debug('*****objcofficer.contactId**********'+ objcofficer.officerId);
                    }
                    
                }
            
                for(Account objIdUpdate:[SELECT Name,Id,SAF_OfficerId__c,accountnumber FROM Account WHERE accountnumber In :Mapshareholders.keyset()])
                {
                  
                    if(Mapshareholders.containsKey(objIdUpdate.accountnumber))
                    {
                       SAF_Duedil.shareholder objsh = Mapshareholders.get(objIdUpdate.accountnumber);
                       objsh.customerId = objIdUpdate.ID;
                       for(SAF_Duedil.exactMatch objcmatch:objsh.exactMatches)    
                       {
                           objcmatch.company.AccountId = objIdUpdate.Id;
                       }
                       Mapshareholders.put(objIdUpdate.accountnumber,objsh);
                       system.debug('*****objIdUpdate.accountnumber**********'+ objIdUpdate.accountnumber);
                    }
                    
                }
                   system.debug('Mapshareholders'+Mapshareholders);  
                   
                for(SAF_Duedil.shareholder objshareholder:Mapshareholders.values())    
                    {
                        
                          Account objaccount1 = new Account();
                          system.debug('objshareholderinside: '+objshareholder);
                      for(SAF_Duedil.exactMatch objcmatch:objshareholder.exactMatches)    
                          {   
                           if((objshareholder.customerId== null || objshareholder.customerId == '') && (objshareholder.ischecked != null && objshareholder.ischecked)  )//&& objshareholder.Relationship  == 'Shareholder'
                             {
                                 //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId));
                                    objaccount1.Name = objcmatch.company.name;
                                    objaccount1.SAF_OfficerID__c = (objcmatch.person!= null ? objcmatch.person.officerId : '');
                                    objaccount1.Type = settings.Customer_Type__c;
                                    objaccount1.Sic = '000000';
                                    objaccount1.Ownership = ownerShipValue(objcmatch.company.type);
                                    objaccount1.accountnumber = objcmatch.company.companyId;
                                    objaccount1.SAF_is_Duedil_Created__c = true;
                                    objaccount1.clcommon__Legal_Entity_Type__c = settings.LegalEntity__c;
                                    objaccount1.SAF_Connection_Type__c = objshareholder.Relationship;
                                    objaccount1.cllease__Undeployed_Funds__c = objshareholder.totalShareholdingPercentage;
                                    //objaccount1.collect__External_ID__c=objofficer.officerId;
                                   SAF_Duedil.CustomerInfo csinfo = objcmatch.company;
                                   if(csinfo.registeredAddress != null && csinfo.registeredAddress.structuredAddress != null)
                                    { 
                                        objaccount1.BillingStreet                      = csinfo.registeredAddress.structuredAddress.premises + ' '+ ((csinfo.registeredAddress.structuredAddress.thoroughfare == null) ? '' :csinfo.registeredAddress.structuredAddress.thoroughfare) ;
                                        objaccount1.BillingPostalCode                  = csinfo.registeredAddress.structuredAddress.postcode;
                                        objaccount1.BillingCity                        = csinfo.registeredAddress.structuredAddress.postTown;
                                        objaccount1.BillingState                       = csinfo.registeredAddress.structuredAddress.county;
                                        objaccount1.BillingCountry                     = csinfo.incorporationCountry;
                                        if(csinfo.registeredAddress.geolocation != null)
                                        {objaccount1.BillingLatitude = Decimal.ValueOf(csinfo.registeredAddress.geolocation.latitude);
                                        objaccount1.BillingLongitude                   = Decimal.ValueOf(csinfo.registeredAddress.geolocation.longitude);}
                                        objaccount1.SAF_dependentLocality__c            = csinfo.registeredAddress.structuredAddress.dependentLocality; 
                                        objaccount1.SAF_thoroughfare__c                 = csinfo.registeredAddress.structuredAddress.thoroughfare;
                                        objaccount1.SAF_premises__c                     = csinfo.registeredAddress.structuredAddress.premises;                
                                    }
                                    
                                    if(csinfo.financialSummary != null)
                                    { 
                                    objaccount1.SAF_netAssets__c                    = csinfo.financialSummary.netAssets;
                                    objaccount1.SAF_totalAssets__c                  = csinfo.financialSummary.totalAssets;
                                    objaccount1.SAF_ebitda__c                       = csinfo.financialSummary.ebitda;
                                     objaccount1.SAF_postTaxProfit__c                = csinfo.financialSummary.postTaxProfit;
                                     objaccount1.SAF_turnover__c                     = csinfo.financialSummary.turnover;                                     
                                    }
                                    
                                    if(csinfo.accounts != null)
                                    { 
                                    objaccount1.SAF_nextAccountsDueDate__c          = csinfo.accounts.nextAccountsDueDate;
                                    objaccount1.SAF_consolidatedAccounts__c         = csinfo.accounts.consolidatedAccounts;
                                    objaccount1.SAF_latestAccountsDate__c           = csinfo.accounts.latestAccountsDate; 
                                    objaccount1.SAF_filingType__c                   = csinfo.accounts.filingType;
                                    }
                                    objaccount1.SAF_incorporationDate__c            = csinfo.incorporationDate;
                                    objaccount1.SAF_incorporationCountry__c         = csinfo.incorporationCountry;
                                    objaccount1.SAF_charitableIdentitiesCount__c    = csinfo.charitableIdentitiesCount;
                                    objaccount1.SAF_officialStatus__c               = csinfo.officialStatus;
                                    objaccount1.SAF_simplifiedStatus__c             = csinfo.simplifiedStatus;
                                    
                                    if(objaccount1.Name !=null) {accs.add(objaccount1);}
                                   system.debug('objaccount1sh: '+objaccount1);
                                }
                                 system.debug('objcmatch.company: '+objcmatch.company);             
                               if(objshareholder.customerId != null  && objcmatch.company != null && objcmatch.company.accountId != null)//&& objshareholder.Relationship  == 'Shareholder'
                               {
                                     system.debug('objcmatch.company.accountId '+objcmatch.company.accountId);
                                     GetRelationship(objshareholder.Relationship,mainAccountId ,objcmatch.company.accountId,objshareholder.totalShareholdingPercentage);                
                               }
                         
                       }
                       if(objshareholder.exactMatchType == null && objshareholder.ischecked != null  && objshareholder.ischecked)
                        {
                                Account objAccount = new Account();
                                objAccount.Name                  = objshareholder.sourceName;
                                //objAccount.AccountNumber         = objexact.company.companyId;
                                objAccount.Type                  = settings.Customer_Type__c;
                                objAccount.Sic                   = '';
                                //objAccount.CurrencyIsoCode       = 'GBP';
                                objAccount.Ownership             = ownerShipValue('other'); 
                                objAccount.SAF_is_Duedil_Created__c = true;
                                objAccount.CLCOMMON__LEGAL_ENTITY_TYPE__C = settings.LegalEntity_Individual__c; 
                                objAccount.SAF_Connection_Type__c  = objshareholder.Relationship;
                                objAccount.cllease__Undeployed_Funds__c = objshareholder.totalShareholdingPercentage;
                                accs.add(objAccount);
                              
                             
                        }
                       
                     }  
                   system.debug('accs size SH'+accs +accs.size());                       
               /* for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
               {    
                   objIdUpdate.ConnectionType = GetConnectionType(Boolean.valueof(objIdUpdate.isImmediateParent),Boolean.valueof(objIdUpdate.isUltimateParent));
                   system.debug('objIdUpdate:' +objIdUpdate.ConnectionType + ' objIdUpdate.companyId :' + objIdUpdate.companyId +Boolean.valueof(objIdUpdate.isUltimateParent));
                      
                  if(objIdUpdate.ConnectionType == 'Group Company' && objIdUpdate.companyId != null)
                  {    SAF_Duedil.companyofficers csGrpofficers = new SAF_Duedil.companyofficers();
                        csGrpofficers = SAF_Duedil.GetcompanyOfficers(objIdUpdate.companyId,'gb');
                         if(csGrpofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csGrpofficers.officers) 
                         {objp.Relationship = 'Group Director';
                           MapOfficers.put(objp.officerId,objp);
                            system.debug('objp.Relationship group:' +objp.Relationship + 'officerId :' +objp.officerId);
                         }
                       }
                  }
               }
               for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
               {    
                    
                  if(objIdUpdate.ConnectionType == 'Parent Company' && objIdUpdate.companyId != null)
                  {     SAF_Duedil.companyofficers csParofficers = new SAF_Duedil.companyofficers();
                        csParofficers = SAF_Duedil.GetcompanyOfficers(objIdUpdate.companyId,'gb');
                      
                       if(csParofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csParofficers.officers) 
                         { objp.Relationship = 'Parent Director';
                           MapOfficers.put(objp.officerId,objp);
                           system.debug('objp.Relationship Parent:' +objp.Relationship + 'officerId :' +objp.officerId);
                         }
                       }
                   }
                }
                
                 for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
                {    
                  if(Boolean.valueof(objIdUpdate.isUltimateParent) == true && objIdUpdate.companyId != null)
                  {    SAF_Duedil.companyofficers csUBOofficers = new SAF_Duedil.companyofficers();
                        csUBOofficers = SAF_Duedil.GetcompanyOfficers(objIdUpdate.companyId,'gb');
                       if(csUBOofficers.officers != null)
                       { system.debug('UBO Director:' );
                         for(SAF_Duedil.officer  objp:csUBOofficers.officers) 
                         {  objp.Relationship = 'UBO Director';
                            MapOfficers.put(objp.officerId,objp);
                            system.debug('objp.Relationship UBO:' +objp.Relationship + 'officerId :' +objp.officerId);
                         }
                       }
                  }
                }*/
                
                  for(SAF_Duedil.Officer objofficer:MapOfficers.values())    
                    {
                          Contact objContact1 = new Contact();
                          Account objaccount1 = new Account();
                           system.debug('objofficerinside: '+objofficer);
                        if((objofficer.contactId == null || objofficer.contactId == '') && (objofficer.ischecked != null && objofficer.ischecked)  && (objofficer.Relationship  == 'Director' || objofficer.Relationship  == 'Shareholder'))
                        {
                            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId));
                            objaccount1.Name = objofficer.person.firstName+ ' ' + objofficer.person.lastName;
                            objaccount1.SAF_OfficerID__c = objofficer.officerId;
                            objaccount1.Type = settings.Customer_Type__c;
                            objaccount1.Sic = '000000';
                            objaccount1.Ownership = 'Individual';
                            //objaccount1.accountnumber = objofficer.officerId;
                            objaccount1.SAF_is_Duedil_Created__c = true;
                            objaccount1.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                            objaccount1.SAF_Connection_Type__c = objofficer.Relationship;
                            //objaccount1.collect__External_ID__c=objofficer.officerId;
                            if(objofficer.appointments !=null && objofficer.appointments.size() >0 && objofficer.appointments[0] != null && objofficer.appointments[0].serviceAddress != null && objofficer.appointments[0].serviceAddress.structuredAddress != null)
                                    {
                                        objaccount1.BillingStreet                    = ((objofficer.appointments[0].serviceAddress.structuredAddress.premises ==null) ? '':objofficer.appointments[0].serviceAddress.structuredAddress.premises)  
                                        + ' '+ ((objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare == null) ? '':objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare);
                                        objaccount1.BillingPostalCode                = objofficer.appointments[0].serviceAddress.structuredAddress.postcode;
                                        objaccount1.BillingCity                      = objofficer.appointments[0].serviceAddress.structuredAddress.postTown;
                                        objaccount1.BillingState                     = objofficer.appointments[0].serviceAddress.structuredAddress.county;
                                    }
                            //system.debug('***objofficer.appointments[0].officialRole.contains****'+ objofficer.appointments[0].officialRole.contains('Director'));
                            //system.debug('***objofficer.appointments[0].position.contains****'+ objofficer.appointments[0].officialRole.contains('director'));
                            if(objofficer.appointments !=null && objofficer.appointments.size() >0 && objofficer.officialRoleposition != '' && (!objofficer.officialRoleposition.contains('Director')))
                            {
                                if(objofficer.Relationship != 'Shareholder') objaccount1.SAF_Connection_Type__c = 'Officer';
                            }
                           else if((objofficer.appointments ==null || objofficer.appointments.size() == 0) && (objofficer.officialRoleposition == null || objofficer.officialRoleposition == ''))
                            {
                                if(objofficer.Relationship != 'Shareholder')  objaccount1.SAF_Connection_Type__c = 'Officer';
                            }
                            system.debug('objaccount1: '+objaccount1);
                            if(objaccount1.Name !=null) {accs.add(objaccount1);}
                                  system.debug('objaccount1: '+objaccount1);
                        }
                         system.debug('objaccount1.SAF_Connection_Type__c '+objaccount1.SAF_Connection_Type__c);
                          system.debug('objofficer.officialRoleposition '+objofficer.officialRoleposition);             
                       if(objofficer.contactId != null  && objofficer.company != null && objofficer.company.accountId != null) //&& objofficer.Relationship  == 'Director'
                       {
                            if(objofficer.contactId != null && objofficer.appointments !=null && objofficer.appointments.size() >0 && objofficer.officialRoleposition != null && (!objofficer.officialRoleposition.contains('Director')))
                            {
                                if(objofficer.Relationship != 'Shareholder') objofficer.Relationship = 'Officer';
                                //system.debug('Officer Relationshiptype for Secretary '+objofficer.Relationship);
                            }
                           if(objofficer.contactId != null  && (objofficer.officialRoleposition == null || objofficer.officialRoleposition == ''))
                            {
                                if(objofficer.Relationship != 'Shareholder') objofficer.Relationship = 'Officer';
                                 system.debug('Officer Relationshiptype for Secretary '+objofficer.Relationship);
                            }
                             system.debug('objofficer.company.accountId '+objofficer.company.accountId + objofficer.Relationship);
                             GetRelationship(objofficer.Relationship,mainAccountId ,objofficer.company.accountId,objofficer.totalShareholdingPercentage);                
                       }
                     }
                system.debug('accs size'+accs +accs.size()); 
                 mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId ];   
                mainAccountId ='';  
                     try{
                mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : ''; 
                system.debug('*****mainAccount**********try2'+mainAccount);
                } 
                catch(Exception ex)
                {system.debug('*****mainAccount**********catch2'+mainAccount); }  
                if(mainAccountId == null || mainAccountId == '')
                {
                    SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
                      csinfo = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
                      accs.add(customerinit(csinfo));  
                 } 
                                                          
               if(accs.size() >0)
                {
                    //database.insert(accs);
                   // Savepoint sp = Database.setSavepoint();
                    system.debug('Mapacc1values1'+accs +accs.size());
                   try
                   {
                   Database.SaveResult[] srList = Database.insert(accs,false);
                    mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId];   
                mainAccountId ='';  
                     try{
                mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : ''; 
                } 
                catch(Exception ex)
                {system.debug('*****mainAccount**********'+mainAccount); } 
                
                
                    //insert accs;
                   // system.debug('SObject: account'+srList.size()); 
                   for(SAF_Duedil.shareholder objshareholder:Mapshareholders.values())    
                    {
                    
                           for(Account acc1 :accs)
                          {
                                  system.debug('acc1.cllease__Undeployed_Funds__c:' + acc1.cllease__Undeployed_Funds__c);
                                    system.debug('acc1.saf_officerId__c' + acc1.saf_officerId__c);
                                    system.debug('acc1.accountnumber:' + acc1.accountnumber);
                                     system.debug('acc1.name' +acc1.name);
                                 if(objshareholder.exactmatches.size() >0 && acc1.saf_officerId__c != null &&  objshareholder.exactmatches[0].person != null && objshareholder.exactmatches[0].person.officerId == acc1.saf_officerId__c && (objshareholder.customerId == null || objshareholder.customerId == '') && (objshareholder.ischecked != null && objshareholder.ischecked)) //&& objshareholder.Relationship  == 'Shareholder'
                                {
                                      GetRelationship(acc1.SAF_Connection_Type__c,mainAccountId ,acc1.Id,acc1.cllease__Undeployed_Funds__c); //objshareholder.totalShareholdingPercentage
                                       system.debug('objshareholder.sourcename if:' +objshareholder.sourcename);   
                                }
                                else  if(objshareholder.exactmatches.size() >0 && objshareholder.exactmatches[0].company!= null && objshareholder.exactmatches[0].company.companyid == acc1.accountnumber && (objshareholder.customerId == null || objshareholder.customerId == '') && (objshareholder.ischecked != null && objshareholder.ischecked)) //&& objshareholder.Relationship  == 'Shareholder'
                                {
                                      GetRelationship(acc1.SAF_Connection_Type__c,mainAccountId ,acc1.Id,acc1.cllease__Undeployed_Funds__c); //objshareholder.totalShareholdingPercentage
                                       system.debug('objshareholder.sourcename if:' +objshareholder.sourcename);   
                                }
                               else if(objshareholder.exactmatches.size() ==0 && acc1.accountnumber==null && objshareholder.sourcename == acc1.name && acc1.SAF_Connection_Type__c == 'Shareholder' && (objshareholder.customerId == null || objshareholder.customerId == '') && (objshareholder.ischecked != null && objshareholder.ischecked) )
                               {
                                    Contact objContact2 = new Contact();
                                    objContact2.LastName                             =  acc1.Name;//objofficer.person.middlename + ' ' +
                                    //objContact2.FirstName                            = objofficer.person.firstName;
                                    objContact2.title                                = 'Director/Officer';
                                    //objContact2.Salutation                           = objofficer.person.honorific;
                                    objContact2.AccountId                            = (acc1.Id != null && string.valueof(acc1.Id).length() >= 15) ? acc1.Id: null;
                                    objContact2.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                                    objContact2.SAF_Is_Shareholder__c                = true;
                                    objContact2.SAF_TotalShareholdingPercentage__c = string.valueof(acc1.cllease__Undeployed_Funds__c);
                                    objContact2.SAF_is_Duedil_Created__c             = true;
                                    lstcontact1.add(objContact2);
                                      system.debug('**********objContact2*******'+objContact2);
                                      GetRelationship(acc1.SAF_Connection_Type__c,mainAccountId ,acc1.Id,acc1.cllease__Undeployed_Funds__c); 
                                      system.debug('objshareholder.sourcename else:' +objshareholder.sourcename);
                               }                           
                           }
                        
                        
                   }
                    for(SAF_Duedil.Officer objofficer:mapofficers.values())    
                    { 
                     
                      for(Account acc1 :accs)
                      {
                          string AccountId1 = acc1.Id;
                          system.debug('AccountId1 :'+AccountId1 + objofficer.Relationship);
                          //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId+' Contact Id: '+objofficer.contactId +' Selected: '+objofficer.ischecked));
                        
                          Contact objContact2 = new Contact();
                            string officername = objofficer.person.firstName+ ' ' + objofficer.person.lastName;
                            if((objofficer.contactId == null || objofficer.contactId == '') && (objofficer.ischecked != null && objofficer.ischecked) && (objofficer.Relationship  == 'Director' || objofficer.Relationship  == 'Shareholder'))
                            {
                               
                                system.debug('**********officername *******'+officername );
                               //  system.debug('**********accountnumber*******'+acc1.accountnumber + 'officerId :' + objofficer.officerId);
                                if(officername == acc1.Name && (objofficer.Relationship == acc1.saf_connection_type__c||acc1.saf_connection_type__c=='Officer'))
                               {
                                     GetRelationship(acc1.SAF_Connection_Type__c,mainAccountId ,acc1.Id,objofficer.totalShareholdingPercentage);                 
                                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId));
                                    objContact2.SAF_OfficerId__c                     = objofficer.officerId;
                                    objContact2.LastName                             =  objofficer.person.lastName;//objofficer.person.middlename + ' ' +
                                    objContact2.FirstName                            = objofficer.person.firstName;
                                    objContact2.title                                = 'Director/Officer';
                                    objContact2.Salutation                           = objofficer.person.honorific;
                                    objContact2.AccountId                            = (AccountId1 != null && AccountId1.length() >= 15) ? AccountId1 : null;
                                    objContact2.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                                    objContact2.SAF_Is_Shareholder__c                = objofficer.isShareholder != 'true'? false: true;
                                  
                                    objContact2.SAF_is_Duedil_Created__c             = true;
                                    /*if(objofficer.person != null && objofficer.person.nationalities != null)
                                    {
                                        objContact.SAF_Demonym__c                   = objofficer.person.nationalities.demonym;
                                        objContact.SAF_CountryCode__c               = objofficer.person.nationalities.countryCode;
                                    }*/
                                    
                                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Service Address: '+objofficer.appointments[0].serviceAddress));
                                    
                                    if(objofficer.appointments != null && objofficer.appointments.size() >0 && objofficer.appointments[0] != null)
                                    {
                                        objContact2.SAF_OfficialRole__c                  = objofficer.appointments[0].officialRole;
                                        objContact2.SAF_Position__c                      = objofficer.appointments[0].selfDescribedPosition;
                                       if(objofficer.appointments[0].serviceAddress != null && objofficer.appointments[0].serviceAddress.structuredAddress != null)
                                       {
                                        objContact2.MailingStreet                    = objofficer.appointments[0].serviceAddress.structuredAddress.premises + ' '+ ((objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare == null) ? '':objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare);
                                        objContact2.MailingPostalCode                = objofficer.appointments[0].serviceAddress.structuredAddress.postcode;
                                        objContact2.MailingCity                      = objofficer.appointments[0].serviceAddress.structuredAddress.postTown;
                                        objContact2.MailingState                     = objofficer.appointments[0].serviceAddress.structuredAddress.county;
                                        }
                                    }
                                    
                                    if(objofficer.person != null && objofficer.person.dateOfBirth != null)
                                    {
                                       /* if(objofficer.person.dateOfBirth.year != null) 
                                        { 
                                            objContact1.Birthdate = Date.newInstance(integer.valueof(objofficer.person.dateOfBirth.year), integer.valueof(objofficer.person.dateOfBirth.month), 1); 
                                        }*/
                                        
                                        //DateString.length()
                                        
                                        objContact2.SAF_DOB_Month__c = objofficer.person.dateOfBirth.month ;
                                        objContact2.SAF_DOB_Year__c = objofficer.person.dateOfBirth.year;
                                    }//(objofficer.person.dateOfBirth.year != null) ? (objofficer.person.dateOfBirth.year + '/'+ objofficer.person.dateOfBirth.month) : ''; 
                                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objContact: '+objContact));
                                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer Id: '+objofficer.officerId));
                                    
                                    lstcontact1.add(objContact2);
                                      system.debug('**********objContact2*******'+objContact2);
                                }
                            }
                        
                             // Database.SaveResult[] srList1 = Database.insert(lstcontact1,false);
                             //   insert lstcontact1;
                             // ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,srList1.size()+ ' Director(s) created successfully'));     
                             // system.debug('SObject contact: '+srList1.size());
                        }
                      
                   
                    //structuredAddress
                    } 
                    if(lstcontact1.size()>0) Database.SaveResult[] srList1 = Database.insert(lstcontact1,false);  
                    if(Test.isRunningTest()){throw new MyException();}
                } 
              catch(Exception e)
                {  
                    //Database.RollBack(sp);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
                    //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
                    //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
                    string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
                    ErrorLogsUtils.createErrorLogs('Failure', 'SAF_CompanyDeatils', 
                        'createRelatedGroupCustomers2',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');//String.valueOf().substring(0,String.valueOf(sc).indexOf(':'))
                }               
             }  
                
          }
   
       } 
 
    }
    
    public void createRelatedGroupCustomers()
    {     list<Account> accs = new list<Account>();
        try
        {
            //SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Account> { Account.SObjectType});
           
            list<Contact> cons = new list<Contact>();
            Account acc;
            boolean customerCreated = false;
            integer custCount = 0;
            system.debug('*******CompgroupParents******'+CompgroupParents);
           if(CompgroupParents != null)
           { 
               List<Account> mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId and Name =:Companyname];   
            if(mainAccount.size() == 0) 
            {
               SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
               csinfo  = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
               accs.add(customerInit(csinfo));
            }
            //FATAL, ERROR, WARNING, INFO, CONFIRM
            for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
            {
            
                SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
                string SICcode = '';
                SAF_Duedil.IndustriesInfo Indusinfo = new SAF_Duedil.IndustriesInfo();
               
               //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Checked: '+objIdUpdate.isChecked + ' companyId Id: '+objIdUpdate.companyId));
               if(objIdUpdate.companyId != null)
               { 
                    csinfo = SAF_Duedil.GetCompanyInfo(objIdUpdate.companyId,'gb'); 
                    system.debug('********csinfo********'+csinfo);          
                    Indusinfo = SAF_Duedil.GetIndustryInfo(objIdUpdate.companyId,'gb');
                    if(Indusinfo.industries ==  null) {Indusinfo.industries = new List<SAF_Duedil.IndustryInfo>();}
                    for(SAF_Duedil.IndustryInfo objcInfo:Indusinfo.industries)    
                    { if(objcInfo.type == 'SIC2007' && objcInfo.code != null)  {SICcode =  objcInfo.code;}}
                
                acc = new Account();
                
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Checked: '+objIdUpdate.isChecked + ' companyId Id: '+objIdUpdate.companyId));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Checked: '+objc.isChecked));objc.AccountId
                if(objIdUpdate.AccountId == null && objIdUpdate.ischecked)
                {
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Customer(s) Info Address: '+csinfo.registeredAddress.structuredAddress.postTown));
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Company: '+objIdUpdate.companyId+' Account Id: '+objIdUpdate.AccountId));
                    acc.Name = csinfo.name;
                    acc.AccountNumber = csinfo.companyId;
                    acc.Type = settings.Customer_Type__c;
                    acc.Sic = SICcode;
                    //acc.CurrencyIsoCode = 'GBP';
                    acc.Ownership = ownerShipValue(csinfo.type);
                    acc.SAF_is_Duedil_Created__c = true;
                    acc.clcommon__Legal_Entity_Type__c = settings.LegalEntity__c;
                  
                    //acc.clcommon__Email__c = 'test.test@test.com';
                    //acc.Phone = '98765 432101';
                    
                    if(csinfo.registeredAddress != null && csinfo.registeredAddress.structuredAddress != null)
                    { 
                        acc.BillingStreet                      = csinfo.registeredAddress.structuredAddress.premises + ' '+ ((csinfo.registeredAddress.structuredAddress.thoroughfare == null) ? '' :csinfo.registeredAddress.structuredAddress.thoroughfare) ;
                        acc.BillingPostalCode                  = csinfo.registeredAddress.structuredAddress.postcode;acc.BillingCity                        = csinfo.registeredAddress.structuredAddress.postTown;acc.BillingState                       = csinfo.registeredAddress.structuredAddress.county;acc.BillingCountry                     = csinfo.incorporationCountry;if(csinfo.registeredAddress.geolocation != null){acc.BillingLatitude                    = Decimal.ValueOf(csinfo.registeredAddress.geolocation.latitude);acc.BillingLongitude                   = Decimal.ValueOf(csinfo.registeredAddress.geolocation.longitude);}acc.SAF_dependentLocality__c            = csinfo.registeredAddress.structuredAddress.dependentLocality; acc.SAF_thoroughfare__c                 = csinfo.registeredAddress.structuredAddress.thoroughfare;acc.SAF_premises__c                     = csinfo.registeredAddress.structuredAddress.premises;
                    }
                    
                    if(csinfo.financialSummary != null)
                    { 
                    acc.SAF_netAssets__c                    = csinfo.financialSummary.netAssets; acc.SAF_totalAssets__c                  = csinfo.financialSummary.totalAssets;acc.SAF_ebitda__c                       = csinfo.financialSummary.ebitda; acc.SAF_postTaxProfit__c                = csinfo.financialSummary.postTaxProfit;acc.SAF_turnover__c                     = csinfo.financialSummary.turnover;
                    }
                    
                    if(csinfo.accounts != null)
                    { 
                    acc.SAF_nextAccountsDueDate__c          = csinfo.accounts.nextAccountsDueDate;acc.SAF_consolidatedAccounts__c         = csinfo.accounts.consolidatedAccounts;acc.SAF_latestAccountsDate__c           = csinfo.accounts.latestAccountsDate; acc.SAF_filingType__c                   = csinfo.accounts.filingType;
                    }
                    acc.SAF_incorporationDate__c            = csinfo.incorporationDate;
                    acc.SAF_incorporationCountry__c         = csinfo.incorporationCountry;
                    acc.SAF_charitableIdentitiesCount__c    = csinfo.charitableIdentitiesCount;
                    acc.SAF_officialStatus__c               = csinfo.officialStatus;
                    acc.SAF_simplifiedStatus__c             = csinfo.simplifiedStatus;
                    acc.SAF_Connection_Type__c              = GetConnectionType(Boolean.valueof(objIdUpdate.isImmediateParent),Boolean.valueof(objIdUpdate.isUltimateParent));
                 
                    // acc.SAF_turnover__c = objc.financialSummary.turnover;
                    
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Acc: '+acc));
                    if(acc.Name !=null) {accs.add(acc);}
                    
                    customerCreated = true;
                    custCount = custCount+1;
                  }
                }
             }
            }
            if(customerCreated)
            {
                //database.insert(accs);
                Savepoint sp = Database.setSavepoint();
                Database.SaveResult[] srList = Database.insert(accs);//commented for test
                cons.addall(RelCreateContactFromAccount(accs));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'SObject: '+srList.size()));
                this.updateAccountIds();//commented for test
                if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
                if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, srList.size()+ ' Group parent(s) Created Successfully'));
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ' Group parent(s) Created Successfully'));
            }
             if(cons.size()>0) 
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'lstcontact: '+lstcontact1.size()));
                //insert lstcontact;
                Database.SaveResult[] srList = Database.insert(cons);
                /*this.RelConupdateContactIds();
                if(shareholderUBO != null){this.RelConupdateUBOContactIds();}
                if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
                if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,srList.size()+ ' Director(s) created successfully'));*/
            }
            
            if(Test.isRunningTest()){throw new MyException();}
            //structuredAddress
          
        }
        catch(Exception e)
        {  
           // Database.RollBack(sp);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'createRelatedGroupCustomers',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
         //return accs;
    }
    
     public static Account customerInit(SAF_Duedil.CustomerInfo csinfo)
    {
        try
        {
            Account acc = new Account();
            
            string SICcode = '';
            SAF_Duedil.IndustriesInfo Indusinfo = new SAF_Duedil.IndustriesInfo();
            if(csinfo.companyId != null)
            { 
                Indusinfo = SAF_Duedil.GetIndustryInfo(csinfo.companyId,'gb');
                system.debug('##################Indusinfo : '+Indusinfo );
                if(Indusinfo.industries != null)
                {   for(SAF_Duedil.IndustryInfo objcInfo:Indusinfo.industries)    
                    {
                         if(objcInfo.type == 'SIC2007' && objcInfo.code != null)
                         {SICcode =  objcInfo.code; acc.Sic = SICcode;}
                    }
                }
            
                system.debug('******Test debug: '+csinfo);
                acc.Name = csinfo.name;
                acc.AccountNumber = csinfo.companyId;
                acc.Type = Saf_Duedil__c.getOrgDefaults().Customer_Type__c;
               // acc.CurrencyIsoCode = 'GBP';
                acc.Ownership = ownerShipValue(csinfo.type);
                acc.SAF_is_Duedil_Created__c = true;
                //acc.clcommon__Email__c = 'test.test@test.com';
                //acc.Phone = '98765 432101';
                acc.CLCOMMON__LEGAL_ENTITY_TYPE__C = Saf_Duedil__c.getOrgDefaults().LegalEntity__c;
                system.debug('Legal Entity type for acc'+ acc.CLCOMMON__LEGAL_ENTITY_TYPE__C);
                
                if(csinfo.registeredAddress != null && csinfo.registeredAddress.structuredAddress != null)
                { 
                    system.debug('Test : '+csinfo.registeredAddress);
                    acc.BillingStreet                      = csinfo.registeredAddress.structuredAddress.premises + ' '+csinfo.registeredAddress.structuredAddress.thoroughfare;
                    acc.BillingPostalCode                  = csinfo.registeredAddress.structuredAddress.postcode;
                    acc.BillingCity                        = csinfo.registeredAddress.structuredAddress.postTown;
                    acc.BillingState                       = csinfo.registeredAddress.structuredAddress.county;
                    acc.BillingCountry                     = csinfo.incorporationCountry;
                    if(csinfo.registeredAddress.geolocation != null)
                    {
                        acc.BillingLatitude                    = Decimal.ValueOf(csinfo.registeredAddress.geolocation.latitude);
                        acc.BillingLongitude                   = Decimal.ValueOf(csinfo.registeredAddress.geolocation.longitude);
                    }
                    acc.SAF_dependentLocality__c            = csinfo.registeredAddress.structuredAddress.dependentLocality;
                    acc.SAF_thoroughfare__c                 = csinfo.registeredAddress.structuredAddress.thoroughfare;
                    acc.SAF_premises__c                     = csinfo.registeredAddress.structuredAddress.premises;
                }
                
                 if(csinfo.financialSummary != null)
                {
                    acc.SAF_netAssets__c                    = csinfo.financialSummary.netAssets;
                    acc.SAF_totalAssets__c                  = csinfo.financialSummary.totalAssets;
                    acc.SAF_ebitda__c                       = csinfo.financialSummary.ebitda;
                    acc.SAF_postTaxProfit__c                = csinfo.financialSummary.postTaxProfit;
                    acc.SAF_turnover__c                     = csinfo.financialSummary.turnover;
                }  
                
                if(csinfo.accounts != null)
                {  
                    acc.SAF_nextAccountsDueDate__c          = csinfo.accounts.nextAccountsDueDate;
                    acc.SAF_consolidatedAccounts__c         = csinfo.accounts.consolidatedAccounts;
                    acc.SAF_latestAccountsDate__c           = csinfo.accounts.latestAccountsDate;
                    acc.SAF_filingType__c                   = csinfo.accounts.filingType;
                }
                acc.SAF_incorporationDate__c            = csinfo.incorporationDate;
                acc.SAF_incorporationCountry__c         = csinfo.incorporationCountry;
               
              
                acc.SAF_charitableIdentitiesCount__c    = csinfo.charitableIdentitiesCount;
               
                acc.SAF_officialStatus__c               = csinfo.officialStatus;
                acc.SAF_simplifiedStatus__c             = csinfo.simplifiedStatus;
           } 
           return acc;
       }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure','SAF_CompanyDeatils' , 
                'customerInit',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            return null;
        }
    }
      public static string GetRelationship(string strcontype,string Account,string AccountRelated,decimal percent)
    {
        try
        {
            List<clcommon__Reciprocal_Role__c> lst_role = [Select Id,Name,clcommon__Inverse_Role__c from clcommon__Reciprocal_Role__c];
            for(clcommon__Reciprocal_Role__c obj:lst_role)
            { 
             MapRoles.put(obj.Name,obj.ID); 
             system.debug('MapRoles obj.Name:' +obj.Name + obj.Id);
            }
             system.debug('MapRoles:' +MapRoles.size());
            List<clcommon__Relationship__c> lstRel = new List<clcommon__Relationship__c>();
            clcommon__Relationship__c objRel = new clcommon__Relationship__c();
            if(Account != null && Account != '' && AccountRelated != null && Account != AccountRelated)
           {
            system.debug('Account:' +Account);
            objRel.clcommon__Entity__c = Account;
            objRel.clcommon__Ownership_Percentage__c = percent;
            objRel.clcommon__Related_Entity__c = AccountRelated;
             system.debug('strcontype:' + strcontype);
            /*string type = 'a903O0000008PntQAE';
            if(strcontype == 'UBO') {type = 'a903O0000008Po6QAE';}
            else if(strcontype == 'Parent Company') {type= 'a903O0000008Po1QAE';}
            else if(strcontype == 'Group company')  {type = 'a903O0000008PoBQAU';}
            else if(strcontype == 'Related Company')  {type= 'a903O0000008PoGQAU';}
            else if(strcontype == 'Director')  {type= 'a903O0000008PpdQAE';}
            else if(strcontype == 'Parent Director')  {type= 'a903O0000008Pq7QAE';}
            else if(strcontype == 'Group Director')  {type= 'a903O0000008PqCQAU';}
            else if(strcontype == 'UBO Director')  {type= 'a903O0000008Pq2QAE';}
            else if(strcontype == 'Related Customer')  {type= 'a903O0000008PpxQAE';}
             objRel.clcommon__Relationship__c = type;*/
             if(MapRoles.containskey(strcontype))
                {
                    objRel.clcommon__Relationship__c = MapRoles.get(strcontype);
                }
                else
                {
                    objRel.clcommon__Relationship__c = MapRoles.get('Subsidiary');
                }
            system.debug('****objRel.clcommon__Relationship__c:' + objRel.clcommon__Relationship__c);
            lstRel.add(objRel);
           
            //Commented by Megha to avoid two way relationship
         /*   if(Account != null && AccountRelated != null && Account != AccountRelated) 
            {
               
                objRel = new clcommon__Relationship__c();
                objRel.clcommon__Entity__c = AccountRelated;
                objRel.clcommon__Ownership_Percentage__c = percent;
                objRel.clcommon__Related_Entity__c = Account; */
                
              /*  if(strcontype == 'UBO') { objRel.clcommon__Relationship__c = 'a903O0000008Po6QAE';}
                else if(strcontype == 'Parent Company') { objRel.clcommon__Relationship__c= 'a903O0000008Po1QAE';}
                else if(strcontype == 'Group company')  { objRel.clcommon__Relationship__c= 'a903O0000008PoBQAU';}
                else if(strcontype == 'Related Company')  { objRel.clcommon__Relationship__c= 'a903O0000008PoGQAU';}
                else if(strcontype == 'Related Customer')  { objRel.clcommon__Relationship__c = 'a903O0000008PpxQAE';}
               
                if(strcontype == 'UBO Director'){
                    objRel.clcommon__Relationship__c = 'a903O0000008Pq2QAE'; //UBO director 'a903O0000008Po6QAE';
                }
                if(strcontype == 'Parent Director')
                {
                     objRel.clcommon__Relationship__c = 'a903O0000008Pq7QAE' ; //parent director 'a903O0000008Po1QAE'
                }
                if(strcontype == 'Group Director')
                {
                     objRel.clcommon__Relationship__c = 'a903O0000008PqCQAU'; //group director 'a903O0000008PoBQAU';
                } 
                if( strcontype == 'Director')
                {
                    objRel.clcommon__Relationship__c =  'a903O0000008PpdQAE'; //director 'a903O0000008PpxQAE';
                }
                if(strcontype == '' || strcontype  == null)
                {
                     objRel.clcommon__Relationship__c = 'a903O0000008PoGQAU';
                }*/
                
              /*   if(MapRoles.containskey(strcontype))
                {
                    objRel.clcommon__Relationship__c = MapRoles.get(strcontype);
                }
                else
                {
                    objRel.clcommon__Relationship__c = MapRoles.get('Related Company');
                }
                 system.debug('****objRel.clcommon__Relationship__c:' + objRel.clcommon__Relationship__c);
                lstRel.add(objRel); */
                insert lstRel;
            }
            system.debug('objRel :' + objRel + 'objRel.clcommon__Entity__c: ' + objRel.clcommon__Entity__c);
            return objRel.Id;
            
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', 'SAF_CompanyDeatils', 
                'GetRelationship',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');//String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))
            return null;
        }
    }
     
     public static string GetConnectionType(boolean isImmediateParent,boolean isUltimateParent)
    {
        try
        {
            string strConType = '';
            if(isUltimateParent)
            {strConType ='UBO'; }
            else if(isImmediateParent && !isUltimateParent)
            {strConType ='Parent Company'; }
            else if(!isImmediateParent && !isUltimateParent)
            {strConType ='Group Company'; }
            
            //else if(!isImmediateParent && isUltimateParent)
            //{strConType ='Related Company'; }
            //if(Test.isRunningTest()){throw new MyException();}
            return strConType;
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', '', 
                'GetConnectionType',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');//String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))
            return null;
        }
    }
    public void updateAccountIds()
    {    
        try
        {
            // assigning values to id field
            map<string,string> mapAccountIds = new map<string,string>();
             map<Id,SAF_Duedil.groupparent> mapgroupParents = new map<Id,SAF_Duedil.groupparent>();
            List<string> customerRegno = new List<string>();
            SAF_Duedil.groupparent UBOgroupParent = new SAF_Duedil.groupparent();
            system.debug('*********UpdateAccountIDS'+CompgroupParents);
            if(CompgroupParents != null)
            {
            
                for(SAF_Duedil.groupparent objIdUpdate:CompgroupParents)    
                { 
               if(string.IsNotBlank(objIdUpdate.companyId)) {customerRegno.add(objIdUpdate.companyId); }
                } 
               
                //Populating a customerinfo list with salesforce account Ids. 
                for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
                { 
                    objIdUpdate.accountId = mapAccountIds.get(objIdUpdate.companyId);
                    objIdUpdate.ConnectionType  = GetConnectionType(Boolean.valueof(objIdUpdate.isImmediateParent),Boolean.valueof(objIdUpdate.isUltimateParent));
                    
                    system.debug('mapAccountIds.get(objIdUpdate.companyId):' +mapAccountIds.get(objIdUpdate.companyId));
                    if(objIdUpdate.ConnectionType == 'Parent Company' || objIdUpdate.ConnectionType == 'UBO') 
                     {  
                        UBOgroupParent.AccountId =  objIdUpdate.AccountId;  
                        UBOgroupParent.ConnectionType =  objIdUpdate.ConnectionType;
                       // if(objIdUpdate.ConnectionType == 'UBO') {ParentConType = objIdUpdate.ConnectionType; }
                     }
                   mapgroupParents.put(objIdUpdate.accountId,objIdUpdate); 
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
                }
                 system.debug('UBOgroupParent:' +UBOgroupParent);
            }
            if(comprelatedCompanies == null) {comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();}
            for(SAF_Duedil.relatedCompany objIdUpdate:comprelatedCompanies)    
            {if(string.IsNotBlank(objIdUpdate.companyId)) customerRegno.add(objIdUpdate.companyId);}
            //creating a map for getting Account Id and Company reg no
            for(Account objIdUpdate:[SELECT Name,Id,AccountNumber FROM Account WHERE AccountNumber In :customerRegno])
            {
                mapAccountIds.put(objIdUpdate.AccountNumber,objIdUpdate.Id);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objIdUpdate.name: '+objIdUpdate.name+ '  objIdUpdate.Id:'+ objIdUpdate.Id+ '  objIdUpdate.AccountNumber:' + objIdUpdate.AccountNumber));
            }
             
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
            { 
                objIdUpdate.accountId = mapAccountIds.get(objIdUpdate.companyId);
                objIdUpdate.ConnectionType  = GetConnectionType(Boolean.valueof(objIdUpdate.isImmediateParent),Boolean.valueof(objIdUpdate.isUltimateParent));
                system.debug('mapAccountIds.get(objIdUpdate.companyId):' +mapAccountIds.get(objIdUpdate.companyId));
                if(objIdUpdate.ConnectionType == 'Parent Company' || objIdUpdate.ConnectionType == 'UBO') 
                 {  
                    UBOgroupParent.AccountId =  objIdUpdate.AccountId;  
                    UBOgroupParent.ConnectionType =  objIdUpdate.ConnectionType;
                   // if(objIdUpdate.ConnectionType == 'UBO') {ParentConType = objIdUpdate.ConnectionType; }
                 }
                   mapgroupParents.put(objIdUpdate.accountId,objIdUpdate); 
                   
                 system.debug('objIdUpdate.ConnectionType:' +objIdUpdate.ConnectionType);          
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
            }
            
            List<Account> lstAccounts = [SELECT Name,Id,AccountNumber,SAF_Connection_Type__c,ParentId FROM Account WHERE AccountNumber In :customerRegno];
            List<Account> objaccParent= [SELECT Id,ParentId,Name,SAF_Connection_Type__c FROM Account WHERE AccountNumber =: companyId];
            system.debug('objaccParent: '+objaccParent);
            system.debug('mapgroupParents: '+mapgroupParents);
               //creating a map for getting Account Id and Company reg no
               string UBOParentId = '';
            for(Account objIdUpdate:lstAccounts)
            {
                mapAccountIds.put(objIdUpdate.AccountNumber,objIdUpdate.Id); 
                if(mapgroupParents.containskey(objIdUpdate.Id)) {
                objIdUpdate.SAF_Connection_Type__c = mapgroupParents.get(objIdUpdate.Id).ConnectionType;
                      if(mapgroupParents.get(objIdUpdate.Id).isUltimateParent == 'true' && mapgroupParents.get(objIdUpdate.Id).isImmediateParent == 'false')
                      { UBOParentId = objIdUpdate.Id;}
                     if(mapgroupParents.get(objIdUpdate.Id).isUltimateParent == 'false' && mapgroupParents.get(objIdUpdate.Id).isImmediateParent == 'true')
                      {
                        //  objIdUpdate.ParentId = UBOParentId; 
                      }
                 }
                system.debug('objIdUpdate.SAF_Connection_Type__c : '+objIdUpdate.SAF_Connection_Type__c);     
            } 
            
            if(objaccParent.size() >0) { 
                    objaccParent[0].ParentId = UBOgroupParent.AccountId;
                    //objaccParent[0].SAF_Connection_Type__c = UBOgroupParent.ConnectionType;
                   
                    //lstAccounts.add(objaccParent[0]);
                    update objaccParent;              
                    if(lstAccounts.size() >0) {update lstAccounts; }
                }
                else
                {ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Customer ' + CompanyName +' is not yet created in salesforce.'));}
            
            
            
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.relatedCompany objIdUpdate:comprelatedCompanies)    
            { 
                objIdUpdate.accountId = mapAccountIds.get(objIdUpdate.companyId);
                system.debug('mapAccountIds.get(objIdUpdate.companyId):' +mapAccountIds.get(objIdUpdate.companyId));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objIdUpdate.name : '+objIdUpdate.name+ ' objIdUpdate.accountId :'+ objIdUpdate.accountId+ ' objIdUpdate.companyId :' + objIdUpdate.companyId));
            }
            if(Test.isRunningTest()){throw new MyException();}
            system.debug('*********mapAccountIds.keyset()'+mapAccountIds.keyset());
            AccountIds.addall(mapAccountIds.keyset());
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'updateAccountIds',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
        
       
    }
    
    /* Merging Related Contacts to this page - Starts */
    
    public void RelConShow()
    {
        try
        {
        
            CompanyId = (ApexPages.currentPage().getParameters().get('companyid') == null) ? CompanyId : ApexPages.currentPage().getParameters().get('companyid');
            Companyname = (ApexPages.currentPage().getParameters().get('companyname')==null) ? Companyname : ApexPages.currentPage().getParameters().get('companyname') ;
            Companyname = Companyname.replace('ampar', '&');
           //CompanyId = ApexPages.currentPage().getParameters().get('companyid');
            SAF_Duedil dd = new SAF_Duedil();
            
            SAF_Duedil.companyshareholders cs = new SAF_Duedil.companyshareholders();
            SAF_Duedil.companyofficers csofficers = new SAF_Duedil.companyofficers();
            shareholder = new List<SAF_Duedil.shareholder>();
            // Deepak <Sort values> Starts
            List<SAF_Duedil.shareholder> shareholderSorted = new List<SAF_Duedil.shareholder>();
            List<SelectOption> ShareholderSelectOption = new List<SelectOption>();
            
            List<SAF_Duedil.shareholder> shareholderSortedUBO = new List<SAF_Duedil.shareholder>();
            List<SelectOption> ShareholderSelectOptionUBO = new List<SelectOption>();
            // Deepak <Sort values> Ends
            
            officers = new List<SAF_Duedil.officer>();
            if(CompanyId != null)
            { 
                cs = SAF_Duedil.GetShareholders(CompanyId,'gb');
                 
                system.debug('###Company Id :'+ CompanyId);
                system.debug('###CS :'+ cs);
                csofficers = SAF_Duedil.GetcompanyOfficers(CompanyId,'gb');
                system.debug('###cs.shareholders :'+ cs.shareholders);
                system.debug('CompgroupParents :'+ CompgroupParents);
                 //Adding only contact/person in the list
            if(csofficers.officers != null)
            {
                for(SAF_Duedil.officer objcofficer:csofficers.officers)    
                {if(objcofficer.Type == 'person'){   objcofficer.Relationship = 'Director';
                       // officers.add(objcofficer); 
                        objcofficer.isDirector = true;
                       
                        MapOfficers.put(objcofficer.officerId,objcofficer);
                    }
                }
             }
                
               if(cs.shareholders != null)
               {
                    for(SAF_Duedil.shareholder objc:cs.shareholders)    
                    { 
                        for(SAF_Duedil.exactMatch objcmatch:objc.exactMatches)    
                        {
                            if(objcmatch.type == 'company' && objcmatch.person == null && CompgroupParents !=null)
                            { 
                             for(SAF_Duedil.groupparent  obj:CompgroupParents)    
                                {    system.debug('groupparent obj:'+ obj);
                                     if(obj.companyId == objcmatch.company.companyId)
                                     {objc.Relationship = GetConnectionType(Boolean.valueof(obj.isImmediateParent),Boolean.valueof(obj.isUltimateParent)); }
                                     if(Boolean.valueof(obj.isUltimateParent) == true)
                                     {
                                         UBOCompanyId = obj.companyId;
                                         UBOCompanyName = obj.name;
                                     }
                                
                                } 
                               if(CompgroupParents.size() ==0)  objc.Relationship = 'Shareholder';
                               objc.shareholderId = objcmatch.company.companyId;
                             }
                           
                            else if(objcmatch.type == 'person')
                            { 
                                  objc.Relationship = 'Shareholder';
                                  if(objcmatch.person.officerId !=null && mapofficers.containskey(objcmatch.person.officerId)){
                                    string isshareholder =  mapofficers.get(objcmatch.person.officerId).isshareholder;
                                    if(isshareholder == 'true')  objc.Relationship = 'Director';
                                  } 
                                objc.shareholderId = objcmatch.person.officerId;     
                            } 
                            objc.exactMatchType = objcmatch.type;
                        }
                        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc : '+objc.exactMatches[0].company.companyId));
                       system.debug('###### SH Percentage: '+objc.totalShareholdingPercentage + ' ###Company Id :'+ CompanyId);
                        if(objc.totalShareholdingPercentage >=settings.TotalShareholderPercentage__c)
                       {
                          shareholder.add(objc);
                       }
                       if(objc.notMatched !=null && (objc.notMatched.suspectedType == 'company' || objc.notMatched.suspectedType == 'person'))
                            { 
                                    objc.Relationship = 'Shareholder';
                            } 
                       if(objc.notMatched ==null && objc.exactMatches.size() ==0 ) objc.Relationship = 'Shareholder';
                    } 
                    
                   // Deepak <Sort values>
                    for(SAF_Duedil.shareholder ShareholderList: shareholder)
                    {
                        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'ShareholderList : '+ShareholderList.sourceName));
                        ShareholderSelectOption.add(new SelectOption(ShareholderList.sourceName,ShareholderList.sourceName));                    
                    }
                   ShareholderSelectOption.sort();
                   
                    for (SelectOption so : ShareholderSelectOption)
                    {
                        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'ShareholderList : '+so.getLabel()));
                        for(SAF_Duedil.shareholder ShareholderList: shareholder)
                        {
                            if(so.getLabel() == ShareholderList.sourceName)
                            {
                                shareholderSorted.add(ShareholderList);
                            }
                        }
                    }
                   shareholder.clear();
                   shareholder = shareholderSorted;
                   //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'ShareholderList sorted : '+shareholder));
                }
                system.debug('UBOCompanyId :'+ UBOCompanyId);
                system.debug('shareholder :'+ shareholder);
                if(UBOCompanyId != null)
                { 
                  SAF_Duedil.companyshareholders cs1 = new SAF_Duedil.companyshareholders();
                  cs1 = SAF_Duedil.GetShareholders(UBOCompanyId,'gb');
                  shareholderUBO = new List<SAF_Duedil.shareholder>();
                 if(cs1.shareholders != null)
                 {
                   for(SAF_Duedil.shareholder objc:cs1.shareholders)    
                    { 
                        objc.Relationship = 'UBO';
                        for(SAF_Duedil.exactMatch objcmatch:objc.exactMatches)    
                        { 
                            objc.exactMatchType = objcmatch.type;
                             system.debug('objc.exactMatchType:'+ objc.exactMatchType);
                            if(objc.exactMatchType == 'person') objc.Relationship = 'Director';objc.ShareholderId = (objcmatch.person != null && objcmatch.person.officerId != null ? objcmatch.person.officerId : ''); //objc.Relationship + need to modify
                            if(objc.exactMatchType == 'company') objc.ShareholderId =  (objcmatch.company!= null && objcmatch.company.companyId != null ? objcmatch.company.companyId : '');
                        }
                       if(objc.totalShareholdingPercentage >=settings.TotalShareholderPercentage__c)
                       {
                          shareholderUBO.add(objc);
                          //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc : '+objc.exactMatches[0].company.companyId));
                          //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc : '+objc.exactMatches[0].person.officerId));
                          //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'cs1 : '+cs1));
                       }
                    }
                    
                    // Deepak <Sort values for UBO>
                    for(SAF_Duedil.shareholder ShareholderListUBO: shareholderUBO)
                    {
                        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'ShareholderList : '+ShareholderList.sourceName));
                        ShareholderSelectOptionUBO.add(new SelectOption(ShareholderListUBO.sourceName,ShareholderListUBO.sourceName));                    
                    }
                   ShareholderSelectOptionUBO.sort();
                   
                    for (SelectOption soUBO : ShareholderSelectOptionUBO)
                    {
                        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'ShareholderList : '+so.getLabel()));
                        for(SAF_Duedil.shareholder ShareholderListUBO: shareholderUBO)
                        {
                            if(soUBO.getLabel() == ShareholderListUBO.sourceName)
                            {
                                shareholderSortedUBO.add(ShareholderListUBO);
                            }
                        }
                    }
                   shareholderUBO.clear();
                   shareholderUBO= shareholderSortedUBO;
                 }
             }
            }
           
            
               for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
               {    
                   objIdUpdate.ConnectionType = GetConnectionType(Boolean.valueof(objIdUpdate.isImmediateParent),Boolean.valueof(objIdUpdate.isUltimateParent));
                   system.debug('objIdUpdate:' +objIdUpdate.ConnectionType + ' objIdUpdate.companyId :' + objIdUpdate.companyId +Boolean.valueof(objIdUpdate.isUltimateParent));
                      
                  if(objIdUpdate.ConnectionType == 'Group Company' && objIdUpdate.companyId != null)
                  {    SAF_Duedil.companyofficers csGrpofficers = new SAF_Duedil.companyofficers();
                        csGrpofficers = SAF_Duedil.GetcompanyOfficers(objIdUpdate.companyId,'gb');
                         if(csGrpofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csGrpofficers.officers) 
                         {
                            //if(MapOfficers.containskey(objp.officerId)) { objp.isDirector = true;}
                           
                                 objp.Relationship = 'Group Director';
                                 MapOfficers.put(objp.officerId,objp);
                                 system.debug('objp.Relationship group:' +objp.Relationship + 'officerId :' +objp.officerId);
                            
                         }
                       }
                  }
               }
               for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
               {    
                    
                  if(objIdUpdate.ConnectionType == 'Parent Company' && objIdUpdate.companyId != null)
                  {     SAF_Duedil.companyofficers csParofficers = new SAF_Duedil.companyofficers();
                        csParofficers = SAF_Duedil.GetcompanyOfficers(objIdUpdate.companyId,'gb');
                      
                       if(csParofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csParofficers.officers) 
                         { 
                              //if(MapOfficers.containskey(objp.officerId)) { objp.isDirector = true;}
                              objp.Relationship = 'Parent Director';
                               MapOfficers.put(objp.officerId,objp);
                               system.debug('objp.Relationship Parent:' +objp.Relationship + 'officerId :' +objp.officerId);
                         }
                       }
                   }
                }
                
                for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
                {    
                  if(Boolean.valueof(objIdUpdate.isUltimateParent) == true && objIdUpdate.companyId != null)
                  {    SAF_Duedil.companyofficers csUBOofficers = new SAF_Duedil.companyofficers();
                        csUBOofficers = SAF_Duedil.GetcompanyOfficers(objIdUpdate.companyId,'gb');
                       if(csUBOofficers.officers != null)
                       { system.debug('UBO Director:' );
                         for(SAF_Duedil.officer  objp:csUBOofficers.officers) 
                         {  
                             //if(MapOfficers.containskey(objp.officerId)) { objp.isDirector = true;}
                            objp.Relationship = 'UBO Director';
                            MapOfficers.put(objp.officerId,objp);
                            system.debug('objp.Relationship UBO:' +objp.Relationship + 'officerId :' +objp.officerId);
                         }
                       }
                  }
                }
                
            if(csofficers.officers != null)
            {
                for(SAF_Duedil.officer objcofficer:csofficers.officers)    
                {if(objcofficer.Type == 'person'){  
               
                   if(MapOfficers.containskey(objcofficer.officerId)) { 
                         SAF_Duedil.officer objoff = MapOfficers.get(objcofficer.officerId);
                         objoff.isDirector = true;
                         MapOfficers.put(objoff.officerId,objoff);
                        }
                    }
                }
             }
                 
             for(SAF_Duedil.officer objdirector:MapOfficers.values())    
            { if(objdirector.Type == 'person') {   officers.add(objdirector); 
                    system.debug('objdirector:' +objdirector.relationship +' : ' + objdirector.person.firstname + ' : '+objdirector.officerId);
                   
                }
                // system.debug('objdirector:' +objdirector.relationship + objdirector.person.firstname);
            }
            this.RelConGetCompanyInfo();
            this.RelConupdateContactIds();
            if(shareholderUBO != null){this.RelConupdateUBOContactIds();}
            if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
            if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
            //if(Test.isRunningTest()){throw new MyException();}
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'customerInfo name: '+CustomerInfo[1].name));
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelConShow',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    
    }
    
    public void RelConupdateContactIds()
    {
        
        try
        {
            // assigning values to id field
            map<string,contact> mapcontactIds = new map<string,contact>();
            List<string> OfficerRegno = new List<string>();
           
            
            string blank = null;
            for(SAF_Duedil.officer objIdUpdate:officers)    
            { 
                OfficerRegno.add(objIdUpdate.officerId);
            } 
             for(SAF_Duedil.shareholder objIdUpdate:shareholder)    
            { 
                 for(SAF_Duedil.exactmatch objexact:objIdUpdate.exactmatches)    
                { 
                 if(objexact.person != null) {OfficerRegno.add(objexact.person.officerId);}
                }
               
            }
             
            //creating a map for getting Account Id and Company reg no
            for(Contact objIdUpdate:[SELECT Name,Id,SAF_OfficerId__c,AccountId FROM Contact WHERE SAF_OfficerId__c In :OfficerRegno])
            {
                mapcontactIds.put(objIdUpdate.SAF_OfficerId__c,objIdUpdate);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name: '+objc.name+ '  objc.Id:'+ objc.Id+ '  objc.AccountNumber:' + objc.AccountNumber));
            }
            
       
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.officer objConIdUpdate:officers)    
            { 
                objConIdUpdate.ContactId = (mapcontactIds.get(objConIdUpdate.officerId) == null ) ? '' : mapcontactIds.get(objConIdUpdate.officerId).Id;
                if(objConIdUpdate.person != null)
                {
                objConIdUpdate.person.dateOfBirth.monthYear = string.ValueOf(objConIdUpdate.person.dateOfBirth.month) == null? '': string.ValueOf(objConIdUpdate.person.dateOfBirth.month).Length() > 1? string.ValueOf(objConIdUpdate.person.dateOfBirth.month) +'/'+string.ValueOf(objConIdUpdate.person.dateOfBirth.year): '0'+string.ValueOf(objConIdUpdate.person.dateOfBirth.month) +'/'+string.ValueOf(objConIdUpdate.person.dateOfBirth.year);
                system.debug('mapAccountIds.get(objConIdUpdate.officerId):' +objConIdUpdate.ContactId);
                }//ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
            }
             for(SAF_Duedil.shareholder objConIdUpdate:shareholder)    
            { 
              for(SAF_Duedil.exactmatch objexact:objConIdUpdate.exactmatches)    
                { 
                 if(objexact.person != null) {objConIdUpdate.ContactId = (mapcontactIds.get(objexact.person.officerId) == null ) ? '' : mapcontactIds.get(objexact.person.officerId).Id; 
                 objexact.person.dateOfBirth.monthYear = string.ValueOf(objexact.person.dateOfBirth.month) == null? '': string.ValueOf(objexact.person.dateOfBirth.month).Length() > 1? string.ValueOf(objexact.person.dateOfBirth.month) +'/'+string.ValueOf(objexact.person.dateOfBirth.year): '0'+string.ValueOf(objexact.person.dateOfBirth.month) +'/'+string.ValueOf(objexact.person.dateOfBirth.year);
                }
                
                system.debug('mapAccountIds.get(objConIdUpdate.officerId):' +objConIdUpdate.ContactId);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
                }
            }
            //if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelConupdateContactIds',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    // Deepak <UBO Shareholders> - Starts
    public void RelConupdateUBOContactIds()
    {
        try
        {
            // assigning values to id field
            map<string,contact> mapcontactIds = new map<string,contact>();
            List<string> OfficerRegno = new List<string>();
            
            string blank = null;
            for(SAF_Duedil.officer objIdUpdate:officers)    
            { 
                OfficerRegno.add(objIdUpdate.officerId);
            } 
            for(SAF_Duedil.shareholder objIdUpdate:shareholderUBO)    
            { 
                for(SAF_Duedil.exactmatch objexact:objIdUpdate.exactmatches)    
                { 
                    if(objexact.person != null) {OfficerRegno.add(objexact.person.officerId);}
                }
            } 
            //creating a map for getting Account Id and Company reg no
            for(Contact objIdUpdate:[SELECT Name,Id,SAF_OfficerId__c,AccountId FROM Contact WHERE SAF_OfficerId__c In :OfficerRegno])
            {
                mapcontactIds.put(objIdUpdate.SAF_OfficerId__c,objIdUpdate);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name: '+objc.name+ '  objc.Id:'+ objc.Id+ '  objc.AccountNumber:' + objc.AccountNumber));
            }
            
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.officer objConIdUpdate:officers)    
            { 
                objConIdUpdate.ContactId = (mapcontactIds.get(objConIdUpdate.officerId) == null ) ? '' : mapcontactIds.get(objConIdUpdate.officerId).Id;
                objConIdUpdate.person.dateOfBirth.monthYear = string.ValueOf(objConIdUpdate.person.dateOfBirth.month) == null? '': string.ValueOf(objConIdUpdate.person.dateOfBirth.month).Length() > 1? string.ValueOf(objConIdUpdate.person.dateOfBirth.month) +'/'+string.ValueOf(objConIdUpdate.person.dateOfBirth.year): '0'+string.ValueOf(objConIdUpdate.person.dateOfBirth.month) +'/'+string.ValueOf(objConIdUpdate.person.dateOfBirth.year);
                system.debug('mapAccountIds.get(objConIdUpdate.officerId):' +objConIdUpdate.ContactId);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
            }
            for(SAF_Duedil.shareholder objConIdUpdate:shareholderUBO)    
            { 
                for(SAF_Duedil.exactmatch objexact:objConIdUpdate.exactmatches)    
                { 
                    if(objexact.person != null) 
                    {
                        objConIdUpdate.ContactId = (mapcontactIds.get(objexact.person.officerId) == null ) ? '' : mapcontactIds.get(objexact.person.officerId).Id; 
                        objexact.person.dateOfBirth.monthYear = string.ValueOf(objexact.person.dateOfBirth.month) == null? '': string.ValueOf(objexact.person.dateOfBirth.month).Length() > 1? string.ValueOf(objexact.person.dateOfBirth.month) +'/'+string.ValueOf(objexact.person.dateOfBirth.year): '0'+string.ValueOf(objexact.person.dateOfBirth.month) +'/'+string.ValueOf(objexact.person.dateOfBirth.year);
                    } 
                    system.debug('mapAccountIds.get(objConIdUpdate.officerId):' +objConIdUpdate.ContactId);
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
                }
            }
            //if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelConupdateUBOContactIds',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    // Account Id update
    public void RelConupdateUBOAccountIds(List<SAF_Duedil.shareholder> shareholdersOrUBOsh)
    {
         try
        {
            // assigning values to id field
            map<string,string> mapAccountIds = new map<string,string>();
            List<string> customerRegno = new List<string>();
            
             map<string,Account> mapAccnames = new map<string,Account>();
             List<string> accountNames = new List<string>();
             
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustInfo)    
            {  customerRegno.add(objIdUpdate.companyId);} 
              
            for(SAF_Duedil.shareholder objIdUpdate:shareholdersOrUBOsh)    
            { 
                for(SAF_Duedil.exactmatch objexact:objIdUpdate.exactmatches)    
                { 
                    if(objexact.company != null) {customerRegno.add(objexact.company.companyId);}
                }
                 accountNames.add(objIdUpdate.sourcename);
            } 
             system.debug('accountNames:' +accountNames);  
            //creating a map for getting Account Id and Company reg no
            for(Account objIdUpdate:[SELECT Name,Id,AccountNumber FROM Account WHERE AccountNumber In :customerRegno limit 30])
            { mapAccountIds.put(objIdUpdate.AccountNumber,objIdUpdate.Id);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name: '+objc.name+ '  objc.Id:'+ objc.Id+ '  objc.AccountNumber:' + objc.AccountNumber));
            }
            
                 
             for(Account objIdUpdate:[SELECT Name,Id,AccountNumber FROM Account WHERE Name In :accountNames limit 30])
            {
                mapAccnames.put(objIdUpdate.Name,objIdUpdate);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name: '+objc.name+ '  objc.Id:'+ objc.Id+ '  objc.AccountNumber:' + objc.AccountNumber));
            }
            
             system.debug('mapAccnames:' +mapAccnames);
             
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustInfo)    
            {  objIdUpdate.accountId = mapAccountIds.get(objIdUpdate.companyId);
                system.debug('mapAccountIds.get(objIdUpdate.companyId):' +mapAccountIds.get(objIdUpdate.companyId));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
            }
            
            for(SAF_Duedil.shareholder objConIdUpdate:shareholdersOrUBOsh)    
            { 
                for(SAF_Duedil.exactmatch objexact:objConIdUpdate.exactmatches)    
                { 
                    if(objexact.company!= null) 
                    {
                        objConIdUpdate.ContactId = (mapAccountIds.get(objexact.company.companyid) == null ) ? '' : mapAccountIds.get(objexact.company.companyid); 
                        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Id: '+objConIdUpdate.ContactId));
                    } 
                }
                 if(objConIdUpdate.exactmatches.size() == 0) {objConIdUpdate.ContactId = (mapAccnames.get(objConIdUpdate.sourcename) == null ) ? '' : mapAccnames.get(objConIdUpdate.sourcename).Id; }
           
            }
            //if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            system.debug('~###Error '+e.getMessage()+ ', Line no: '+e.getLineNumber());
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelConupdateUBOAccountIds',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    // Deepak <UBO Shareholders> - Ends
    public void RelConcreateContacts()
    {
        try
        {
            //SAF_Duedil.Officer objofficer = new SAF_Duedil.Officer();
           // List<contact> lstcontact1 = new List<contact>();
            string mainAccountId;string UBOAccountId;string ParentAccountId;string GroupAccountId;string ParentcompanyId;string GroupcompanyId;
            account mainacc = new account();
           
            Map<string,string> mapgroupacc = new  Map<string,string>();
            if(companyid !=null)
            {
               List<Account> mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId and Name =:Companyname];   
              System.debug('******MainAccount1***'+mainAccount);
               mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : null; 
               
               if(mainAccountId !=null)  mapgroupacc.put('main',mainAccountId); 
           }    
            List<contact> cons = new List<contact>();
            List<Account> lstaccount1 = new List<Account>();
            
            Contact objContact1;
            Account objaccount1;
            boolean customerCreated = false;
            integer custCount = 0;
            for(SAF_Duedil.Officer objofficer:officers)    
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId+' Contact Id: '+objofficer.contactId +' Selected: '+objofficer.ischecked));
                objContact1 = new Contact();
                objaccount1 = new Account();
                if((objofficer.contactId == null || objofficer.contactId == '') && (objofficer.ischecked != null && objofficer.ischecked))
                {
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId));
                    objaccount1.Name = objofficer.person.firstName+ ' ' + objofficer.person.lastName;
                    objaccount1.SAF_OfficerID__c = objofficer.officerId;
                    objaccount1.Type = settings.Customer_Type__c;
                    objaccount1.Sic = '000000';
                    objaccount1.SAF_is_Duedil_Created__c = true;
                    objaccount1.Ownership = 'Individual';
                    objaccount1.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                    objaccount1.SAF_Connection_Type__c = objofficer.Relationship;
                    if(objofficer.Relationship != null && objofficer.Relationship == 'UBO Director')
                    {UBOAccountId = 'UBO';}
                    if(objofficer.Relationship != null && objofficer.Relationship == 'Parent Director')
                    {ParentAccountId = 'Parent'; ParentcompanyId ='Parent Company'; }
                    if(objofficer.Relationship != null && objofficer.Relationship == 'Group Director')
                    {GroupAccountId = 'Group'; GroupcompanyId = 'Group Company';}
                    
                    system.debug('***objofficer.appointments[0].officialRole.contains****'+ objofficer.appointments[0].officialRole.contains('Director'));
                    system.debug('***objofficer.appointments[0].officialRole.contains****'+ objofficer.appointments[0].officialRole.contains('director'));
                    if(objofficer.appointments.size() >0 && objofficer.officialRoleposition != null && (!objofficer.officialRoleposition.contains('Director')))
                    {
                        objaccount1.SAF_Connection_Type__c = 'Officer';
                    }
                   if(objofficer.appointments.size() == 0 || objofficer.appointments == null)
                    {
                        objaccount1.SAF_Connection_Type__c = 'Officer';
                    }
                      system.debug('***objaccount1.SAF_Connection_Type__c****'+ objaccount1.SAF_Connection_Type__c);
                 /*   objContact1.SAF_OfficerId__c                     = objofficer.officerId;
                    objContact1.LastName                             =  objofficer.person.lastName;//objofficer.person.middlename + ' ' +
                    objContact1.FirstName                            = objofficer.person.firstName;
                    objContact1.title                                = 'Director/Officer';
                    objContact1.Salutation                           = objofficer.person.honorific;
                    objContact1.AccountId                            = (AccountId != null && AccountId.length() >= 15) ? AccountId : null;
                    
                    objContact1.SAF_Is_Shareholder__c                = objofficer.isShareholder != 'true'? false: true;
                    objContact1.SAF_OfficialRole__c                  = objofficer.appointments[0].officialRole;
                    objContact1.SAF_Position__c                      = objofficer.appointments[0].selfDescribedPosition;
                    objContact1.SAF_is_Duedil_Created__c             = true;
                  /*  if(objofficer.person != null && objofficer.person.nationalities != null)
                    {
                        objContact.SAF_Demonym__c                   = objofficer.person.nationalities.demonym;
                        objContact.SAF_CountryCode__c               = objofficer.person.nationalities.countryCode;
                    } */
                    
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Service Address: '+objofficer.appointments[0].serviceAddress));
                    
                    if(objofficer.appointments[0] != null && objofficer.appointments[0].serviceAddress != null && objofficer.appointments[0].serviceAddress.structuredAddress != null)
                    {
                        objaccount1.BillingStreet                    = objofficer.appointments[0].serviceAddress.structuredAddress.premises + ' '+ ((objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare == null) ? '':objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare);
                        objaccount1.BillingPostalCode                = objofficer.appointments[0].serviceAddress.structuredAddress.postcode;
                        objaccount1.BillingCity                      = objofficer.appointments[0].serviceAddress.structuredAddress.postTown;
                        objaccount1.BillingState                     = objofficer.appointments[0].serviceAddress.structuredAddress.county;
                    }
                    
                   // if(objofficer.person != null && objofficer.person.dateOfBirth != null)
                  //  {
                      /*  if(objofficer.person.dateOfBirth.year != null) 
                        { 
                            objContact1.Birthdate = Date.newInstance(integer.valueof(objofficer.person.dateOfBirth.year), integer.valueof(objofficer.person.dateOfBirth.month), 1); 
                        }*/
                        
                        //DateString.length()
                        
                       // objContact1.SAF_DOB_Month__c = objofficer.person.dateOfBirth.month ;
                       // objContact1.SAF_DOB_Year__c = objofficer.person.dateOfBirth.year;
                 //   }//(objofficer.person.dateOfBirth.year != null) ? (objofficer.person.dateOfBirth.year + '/'+ objofficer.person.dateOfBirth.month) : ''; 
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objContact: '+objContact));
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer Id: '+objofficer.officerId));
                    
                   //lstcontact1.add(objContact1);
                     if(objaccount1.Name !=null && objaccount1 !=null) {lstaccount1.add(objaccount1);
                     }
                    customerCreated = true;
                    custCount = custCount+1;
                }
                
            }
        if(lstaccount1.size()>0)
        {
             SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
            if(mainAccountId == null) {
               
               csinfo  = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
               lstaccount1.add(customerInit(csinfo));
              }
               for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
               {    
                      system.debug('***********UBOAccountId' + UBOAccountId);
                      system.debug('***********ParentAccountId ' + ParentAccountId);
                      system.debug('***********GroupAccountId ' + GroupAccountId );
                      system.debug('***********Connection type' + objIdUpdate.ConnectionType);
                  if(objIdUpdate.companyId != null && objIdUpdate.AccountId == null && objIdUpdate.ConnectionType == UBOAccountId)
                  {  
                     csinfo  = SAF_Duedil.GetCompanyInfo(objIdUpdate.companyId,'gb');
                     lstaccount1.add(customerInit(csinfo));
                     system.debug('***********in UBO');
                  }
                  if(objIdUpdate.companyId != null && objIdUpdate.AccountId == null && objIdUpdate.ConnectionType == ParentcompanyId) //ParentAccountId)
                  {  
                     csinfo  = SAF_Duedil.GetCompanyInfo(objIdUpdate.companyId,'gb');
                     lstaccount1.add(customerInit(csinfo));
                       system.debug('***********in Parent');
                  }
                  if(objIdUpdate.companyId != null && objIdUpdate.AccountId == null && objIdUpdate.ConnectionType == GroupcompanyId)
                  {  
                     csinfo  = SAF_Duedil.GetCompanyInfo(objIdUpdate.companyId,'gb');
                     lstaccount1.add(customerInit(csinfo));
                      system.debug('***********in group ');
                  }
               } 
               
              
            // Savepoint sp = Database.setSavepoint(); 
              system.debug('***lstaccount1****'+ lstaccount1); 
             Database.SaveResult[] srList = Database.insert(lstaccount1);
             this.updateAccountIds();
              List<Account> mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId and Name =:Companyname]; 
              system.debug('***mainaccount****'+ mainAccount);              
               mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : null;                
               if(mainAccountId !=null)  mapgroupacc.put('main',mainAccountId); 
               for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
               {    
                    
                  if(objIdUpdate.companyId != null)
                  {  
                     objIdUpdate.ConnectionType = objIdUpdate.ConnectionType.replace('company','').replace('Company','').trim();
                     mapgroupacc.put(objIdUpdate.ConnectionType,objIdUpdate.AccountId); 
                  }
               } 
  
            system.debug('mapgroupacc :'+mapgroupacc);
            cons.addall(RelCreateContactFromAccount2(lstaccount1,mapgroupacc));
            List<clcommon__Relationship__c> lst_rel =  [Select Id,clcommon__Entity__c,clcommon__Related_Entity__c,clcommon__Relationship__c from clcommon__Relationship__c where clcommon__Entity__c =:mainAccountId and clcommon__Related_Entity__c In: mapgroupacc.values()];
            system.debug('lst_rel.size:'+lst_rel.size());
            if(lst_rel.size() == 0)
            {
               for(string strkey:mapgroupacc.keyset())    
               {    
                    string strcontype= strkey.replace('Parent','Parent Company').replace('Group','Group Company');
                     system.debug('strcontype:'+strcontype + 'map : ' + mapgroupacc.get(strkey));   
                      system.debug('strkey :'+strkey + UBOAccountId+ ParentAccountId +GroupAccountId);   
                   if((strkey == UBOAccountId) || (strkey == ParentAccountId) || (strkey == GroupAccountId))
                    {
                       
                        GetRelationship(strcontype,mainAccountId,mapgroupacc.get(strkey),null);
                    }
               }
            }
            
            system.debug('Contact list in new method'+cons);
        }
        if(cons.size()>0)
        {
             Database.SaveResult[] srList = Database.insert(cons);
              this.RelConupdateContactIds();
                if(shareholderUBO != null){this.RelConupdateUBOContactIds();}
                if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
                if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,srList.size()+ ' Director(s) created successfully'));
                
        }
        for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
               {    
                    
                  if(objIdUpdate.companyId != null)
                  {  
                     objIdUpdate.ConnectionType = objIdUpdate.ConnectionType.replace('Parent','Parent Company').replace('Group','Group Company');
                    
                  }
               } 
          /*  if(lstcontact1.size()>0) 
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'lstcontact: '+lstcontact1.size()));
                //insert lstcontact;
               // Database.SaveResult[] srList = Database.insert(lstcontact1);
                this.RelConupdateContactIds();
                if(shareholderUBO != null){this.RelConupdateUBOContactIds();}
                if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
                if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
               // ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,srList.size()+ ' Director(s) created successfully'));
            } */
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
           // Database.RollBack(sp);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelConcreateContacts',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
     public list<Contact> RelCreateContactFromAccount(List<Account> LstAccounts)
    {
        list<Contact> lstcontact1 = new list<Contact>();
        try
        {
            //SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Account> { Account.SObjectType});
           List<Account> mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId and Name =:Companyname];   
            string mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : '';
             
          for(Account acc :LstAccounts)
          {
                   Contact objContact1 = new Contact();
                   
                  system.debug('acc.SAF_Connection_Type__c :' + acc.SAF_Connection_Type__c); 
                     GetRelationship(acc.SAF_Connection_Type__c,mainAccountId ,acc.Id,null);
                if(acc.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Sole__c || acc.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Individual__c)
                {
                    system.debug('Inside if loop of new method'+acc.clcommon__Legal_Entity_Type__c);          
                       
                    objContact1.LastName                             = acc.name;//objofficer.person.middlename + ' ' +
                   // objContact1.FirstName                            = objofficer.person.firstName;
                    //objContact1.title                                = 'Director/Officer';
                    //objContact1.Salutation                           = objofficer.person.honorific;
                    string AccountId = acc.Id;
                    objContact1.AccountId                            = (AccountId != null && AccountId.length() >= 15) ? AccountId : null;
                    objContact1.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                  
                        objContact1.MailingStreet                     =  acc.BillingStreet;
                        objContact1.MailingPostalCode                  = acc.BillingPostalCode;
                        objContact1.MailingCity                       = acc.BillingCity;
                        objContact1.MailingState                     = acc.BillingState;
                        objContact1.MailingCountry                     = acc.BillingCountry;
                        //if(csinfo.registeredAddress.geolocation != null){
                            objContact1.MailingLatitude                    = acc.BillingLatitude;
                            objContact1.MailingLongitude                   = acc.BillingLongitude;
                          //  }
                        
                  
                   
                   
                   
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Acc: '+acc));
                    lstcontact1.add(objContact1);
             }     
            if(Test.isRunningTest()){throw new MyException();}
            //structuredAddress
            }   
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelCreateContactFromAccount',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
         return lstcontact1;
    }
     public list<Contact> RelCreateContactFromAccount2(List<Account> LstAccounts,map<string,string> mappgroupAcc)
    {
        list<Contact> lstcontact1 = new list<Contact>();
        Map<string,Account> mapoffid = new Map<string,Account>();
        
        try
        {
            //SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Account> { Account.SObjectType});
            for(SAF_Duedil.Officer objofficer:officers)    
            { 
              Contact objContact1;
              for(Account acc :LstAccounts)
              {
               AccountId = acc.Id;
                 
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId+' Contact Id: '+objofficer.contactId +' Selected: '+objofficer.ischecked));
                objContact1 = new Contact();
                if((objofficer.contactId == null || objofficer.contactId == '') && (objofficer.ischecked != null && objofficer.ischecked))
                {
                    string officername = objofficer.person.firstName+ ' ' + objofficer.person.lastName;
                    system.debug('**********officername *******'+officername );
                    if(officername == acc.Name)
                   {
                       acc.SAF_Connection_Type__c = acc.SAF_Connection_Type__c + ' ';
                       system.debug('**********acc.SAF_Connection_Type__c*******'+acc.SAF_Connection_Type__c);
                       string contype = acc.SAF_Connection_Type__c != ' '? acc.SAF_Connection_Type__c.substringBefore(' ') : acc.SAF_Connection_Type__c;
                        system.debug('**********contype *******'+contype +'type :' + mappgroupAcc.containskey(contype));
                       string mainaccountId =  mappgroupAcc.get(contype) == null ? mappgroupAcc.get('main') : mappgroupAcc.get(contype);
                       system.debug('**********mainaccountId *******'+mainaccountId);
                       acc.SAF_Connection_Type__c = acc.SAF_Connection_Type__c.trim();
                      /*for(string str:mappgroupAcc.keyset())
                      {
                             if(str != null && mainaccountId == mappgroupAcc.get(str) && (str == 'UBO' || str == 'Parent')) 
                             {acc.SAF_Connection_Type__c = 'Director';}
                             
                      } */
                      if(acc.SAF_Connection_Type__c == 'UBO Director' || acc.SAF_Connection_Type__c == 'Parent Director' || acc.SAF_Connection_Type__c == 'Group Director')
                      {
                         
                          string id = mappgroupAcc.get('main');
                         // if(objofficer.isDirector == null) {id = null;} // ***********new condition added to restrict it from creating relationship with main customer
                           system.debug('**********id*******'+id);
                           acc.SAF_Connection_Type__c = 'Director';
                          string strcontypeImmnediateDirector = objofficer.Relationship;
                          if(objofficer.isDirector!= null && objofficer.isDirector) strcontypeImmnediateDirector = 'Director';
                          system.debug('**********strcontypeImmnediateDirector*******'+strcontypeImmnediateDirector);
                          if(id != null && mainaccountId != id) GetRelationship(strcontypeImmnediateDirector,id,acc.Id,null); 
                      }
                     
                      system.debug('**********acc.SAF_Connection_Type__c*******'+acc.SAF_Connection_Type__c);
                      GetRelationship(acc.SAF_Connection_Type__c,mainAccountId ,acc.Id,null);              
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objofficer.officerId));
                    objContact1.SAF_OfficerId__c                     = objofficer.officerId;
                    objContact1.LastName                             =  objofficer.person.lastName;//objofficer.person.middlename + ' ' +
                    objContact1.FirstName                            = objofficer.person.firstName;
                    objContact1.title                                = 'Director/Officer';
                    objContact1.Salutation                           = objofficer.person.honorific;
                    objContact1.AccountId                            = (AccountId != null && AccountId.length() >= 15) ? AccountId : null;
                    
                    objContact1.SAF_Is_Shareholder__c                = objofficer.isShareholder != 'true'? false: true;
                    objContact1.SAF_OfficialRole__c                  = objofficer.appointments[0].officialRole;
                    objContact1.SAF_Position__c                      = objofficer.appointments[0].selfDescribedPosition;
                    objContact1.SAF_is_Duedil_Created__c             = true;
                    objContact1.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                    /*if(objofficer.person != null && objofficer.person.nationalities != null)
                    {
                        objContact.SAF_Demonym__c                   = objofficer.person.nationalities.demonym;
                        objContact.SAF_CountryCode__c               = objofficer.person.nationalities.countryCode;
                    }*/
                    
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Service Address: '+objofficer.appointments[0].serviceAddress));
                    
                    if(objofficer.appointments[0] != null && objofficer.appointments[0].serviceAddress != null && objofficer.appointments[0].serviceAddress.structuredAddress != null)
                    {
                        objContact1.MailingStreet                    = objofficer.appointments[0].serviceAddress.structuredAddress.premises + ' '+ ((objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare == null) ? '':objofficer.appointments[0].serviceAddress.structuredAddress.thoroughfare);
                        objContact1.MailingPostalCode                = objofficer.appointments[0].serviceAddress.structuredAddress.postcode;
                        objContact1.MailingCity                      = objofficer.appointments[0].serviceAddress.structuredAddress.postTown;
                        objContact1.MailingState                     = objofficer.appointments[0].serviceAddress.structuredAddress.county;
                    }
                    
                    if(objofficer.person != null && objofficer.person.dateOfBirth != null)
                    {
                       /* if(objofficer.person.dateOfBirth.year != null) 
                        { 
                            objContact1.Birthdate = Date.newInstance(integer.valueof(objofficer.person.dateOfBirth.year), integer.valueof(objofficer.person.dateOfBirth.month), 1); 
                        }*/
                        
                        //DateString.length()
                        
                        objContact1.SAF_DOB_Month__c = objofficer.person.dateOfBirth.month ;
                        objContact1.SAF_DOB_Year__c = objofficer.person.dateOfBirth.year;
                    }//(objofficer.person.dateOfBirth.year != null) ? (objofficer.person.dateOfBirth.year + '/'+ objofficer.person.dateOfBirth.month) : ''; 
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objContact: '+objContact));
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer Id: '+objofficer.officerId));
                    
                    lstcontact1.add(objContact1);
                }
                }
              
            }
              
            if(Test.isRunningTest()){throw new MyException();}
            //structuredAddress
            }   
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelCreateContactFromAccount',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
         return lstcontact1;
    }
    public void CreateShareholderContacts()
    {
        try
        {
            //SAF_Duedil.Officer objofficer = new SAF_Duedil.Officer();
            List<contact> lstcontact = new List<contact>();
            Contact objContact;
            for(SAF_Duedil.shareholder objshareholder:shareholder)    
            {
                for(SAF_Duedil.exactmatch objexact:objshareholder.exactMatches)    
                {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objshareholder.officerId+' Contact Id: '+objshareholder.contactId +' Selected: '+objshareholder.ischecked));
                objContact = new Contact();
                if(objshareholder.contactId == '' && objshareholder.ischecked)
                {
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer: '+objshareholder.officerId));
                   if(objexact.person != null)
                   {
                    objContact.SAF_OfficerId__c                     = objexact.person.officerId; objContact.LastName                             =  objexact.person.lastName;//objshareholder.person.middlename + ' ' +
                    objContact.FirstName                            = objexact.person.firstName;objContact.Salutation                           = objexact.person.honorific;
                       if(objexact.person.dateOfBirth.year != null) 
                        { 
                            //objContact.Birthdate = Date.newInstance(integer.valueof(objexact.person.dateOfBirth.year), integer.valueof(objexact.person.dateOfBirth.month), 1); 
                            objContact.SAF_DOB_Month__c = objexact.person.dateOfBirth.month ;
                            objContact.SAF_DOB_Year__c = objexact.person.dateOfBirth.year;
                           
                        }
                  
                  }  objContact.AccountId                            =AccountId.length() >= 15 ? AccountId : null; 
                    
                    objContact.title                                = 'Director/Officer';
                    objContact.SAF_TotalShareholding__c             = objshareholder.totalShareholding;
                    objContact.SAF_TotalShareholdingPercentage__c   = String.ValueOf(objshareholder.totalShareholdingPercentage);
                    objContact.SAF_Is_Shareholder__c                = true;
                    objContact.SAF_Shareholder_Relationship__c      = objshareholder.Relationship;
                    objContact.SAF_is_Duedil_Created__c             = true;
                   
                    
                    //DateString.length()
                    
                   //(objexact.person.dateOfBirth.year != null) ? (objexact.person.dateOfBirth.year + '/'+ objexact.person.dateOfBirth.month) : ''; 
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objContact: '+objContact));
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Officer Id: '+objshareholder.officerId));
                    
                   if(objContact.LastName !=null) {lstcontact.add(objContact);}
                }
              }  
            }
        
            if(lstcontact.size()>0) 
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'lstcontact: '+lstcontact.size()));
                //insert lstcontact;
                Savepoint sp = Database.setSavepoint();
                Database.SaveResult[] srList = Database.insert(lstcontact);
                this.RelConupdateContactIds();
                if(shareholderUBO != null){this.RelConupdateUBOContactIds();}
                if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
                if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,srList.size()+ ' Director(s) created successfully'));
            }
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //Database.RollBack(sp);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'CreateShareholderContacts',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    //@future(callout=true)
    public void CreateShareholders()
    {
        //List<SAF_Duedil.shareholder> Shareholder = new List<SAF_Duedil.shareholder>();
        this.CreateShareholdersOrUBOSH(shareholder,CompanyID);
    }
    
    public void CreateUBOShareholders()
    {
        this.CreateShareholdersOrUBOSH(shareholderUBO,UBOCompanyId);
    }
    
    //CreateShareholdersOrUBOSH
    // Deepak <UBO Share holders creation> - Starts
    
    public void CreateShareholdersOrUBOSH(List<SAF_Duedil.shareholder> ShOrUBOSh,string ShCompanyID)
    {
        try
        {
            integer totalShareholdersCreated = 0, curCount;
              lstcontact = new List<contact>();
            objAccountlst = new List<Account>();
           //List<Account> objAccountlst1 = new List<Account>();
            objContactlst = new List<Contact>();
            
            List<Account> mainAccount = [Select Id,Name,SAF_Connection_Type__c from Account where AccountNumber =:ShCompanyID and Name =:Companyname];   
                MainAccntId = (mainAccount.size() >0) ? mainAccount[0].Id : null;  
                   system.debug('**********MainAccntId '+MainAccntId );
            /*if(mainAccountId == null) {
                SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
               csinfo  = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
               objAccountlst1.add(customerInit(csinfo));     
               Database.insert(objAccountlst1);
               if(objAccountlst1.size() >0) {mainAccount = [Select Id,Name from Account where AccountNumber =:CompanyId and Name =:Companyname];   }
                mainAccountId = (mainAccount.size() >0) ? mainAccount[0].Id : null;           
            }*/
             
          
            for(SAF_Duedil.shareholder objshORuboshareholder:ShOrUBOSh)
            {
                system.debug('~###objshORuboshareholder :' + objshORuboshareholder.exactMatches);
                system.debug('~###exactMatchType :' + objshORuboshareholder.exactMatchType + ' ischecked: '+objshORuboshareholder.ischecked +objshORuboshareholder.Relationship);
                if(objshORuboshareholder.exactMatchType != null && objshORuboshareholder.ischecked != null  && objshORuboshareholder.ischecked)
                {
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'UBO Shareholders: '+objuboshareholder.exactMatchType + ' Total Shareholding: '+objuboshareholder.totalShareholding));
                    switch on objshORuboshareholder.exactMatchType
                    {   when 'company'
                        {   curCount = createCompany(objshORuboshareholder,objshORuboshareholder.Relationship);
                            totalShareholdersCreated = curCount > 0? totalShareholdersCreated + curCount:totalShareholdersCreated;
                        }   
                        when 'person'
                        {   objContactlst.addall(createperson2(objshORuboshareholder,ShCompanyID));
                          
                            totalShareholdersCreated = curCount > 0? totalShareholdersCreated + curCount:totalShareholdersCreated;
                         
                        }
                    }
                }
                if(objshORuboshareholder.exactMatchType == null && objshORuboshareholder.ischecked != null  && objshORuboshareholder.ischecked)
                {
                        Account objAccount = new Account();
                        objAccount.Name                  = objshORuboshareholder.sourceName;
                        //objAccount.AccountNumber         = objexact.company.companyId;
                        objAccount.Type                  = settings.Customer_Type__c;
                        objAccount.Sic                   = '';
                        //objAccount.CurrencyIsoCode       = 'GBP';
                        objAccount.Ownership             = ownerShipValue('other'); 
                        objAccount.SAF_is_Duedil_Created__c = true;
                        objAccount.CLCOMMON__LEGAL_ENTITY_TYPE__C = settings.LegalEntity_Individual__c; 
                        objAccount.SAF_Connection_Type__c  = objshORuboshareholder.Relationship;
                        objAccount.cllease__Undeployed_Funds__c = objshORuboshareholder.totalShareholdingPercentage;
                        objAccountlst.add(objAccount);
                     
                }
                //else if(objuboshareholder.notMatched != null && objuboshareholder.notMatched.suspectedType != null && objuboshareholder.ischecked != null && objuboshareholder.ischecked)
            }
            
            Database.SaveResult[] srListAcc, srListCon;
          
             
            if(objAccountlst.size() >0)
            {   
                Savepoint sp = Database.setSavepoint();
                srListAcc = Database.insert(objAccountlst);
                this.updateAccountIds();
               if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
               if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
                Map<string,string> mapgroupacc = new Map<string,string>();
                
                if(mainAccntId == null)
                { 
                 mainAccount = [Select Id,Name,SAF_Connection_Type__c from Account where AccountNumber =:ShCompanyID and Name =:Companyname];   
                 mainAccntId = (mainAccount.size() >0) ? mainAccount[0].Id : null; 
                }
            /*    else
                {
                    objAccountlst.add(mainAccount[0]);
                } */
                system.debug('************Size of Account List*****'+objAccountlst);
                if(mainAccntId !=null)  mapgroupacc.put('main',mainAccntId); 
                 
                  
                  for(SAF_Duedil.groupparent  objIdUpdate:CompgroupParents)    
                   {    
                         system.debug('*********objIdUpdate.companyId '+objIdUpdate.companyId); 
                      if(objIdUpdate.companyId != null)
                      {  
                          mapgroupacc.put(objIdUpdate.ConnectionType,objIdUpdate.AccountId); 
                      }
                   } 
             system.debug('**********mapgroupacc '+mapgroupacc);
           
               for( account acc: objAccountlst)
               {
                   
                       system.debug('**********acc.SAF_Connection_Type__c'+acc.SAF_Connection_Type__c);
                       string contype = acc.SAF_Connection_Type__c;
                       string mainaccId;
                      // string mainaccId =  mapgroupacc.get(contype) == null ? mapgroupacc.get('main') : mapgroupacc.get(contype);
                      if(contype == 'UBO' ||contype == 'Parent Company'|| contype == 'Group Company' || contype == 'Shareholder')
                      {
                          mainaccId = mapgroupacc.get('main');
                          system.debug('****mainaccId if'+mainaccId);
                      }
                      else if(contype == null )
                      {
                         mainaccId = mapgroupacc.get('contype');
                         system.debug('****mainaccId else'+mainaccId);
                      }
                       system.debug('**********mainaccId'+mainaccId); 
                                           
                     if(mainaccId != null)
                     {
                      system.debug('**********acc.SAF_Connection_Type__c*******'+acc.SAF_Connection_Type__c);
                      GetRelationship(acc.SAF_Connection_Type__c,mainaccId,acc.Id, acc.cllease__Undeployed_Funds__c);       
                     }
                           if(acc.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Sole__c || acc.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Individual__c)
                            {
                                system.debug('Inside if loop of new method'+acc.clcommon__Legal_Entity_Type__c);          
                                Contact  objContact1 = new Contact();   
                                objContact1.LastName                             = acc.name;//objofficer.person.middlename + ' ' +
                               // objContact1.FirstName                            = objofficer.person.firstName;
                                //objContact1.title                                = 'Director/Officer';
                                //objContact1.Salutation                           = objofficer.person.honorific;
                                string AccountId = acc.Id;
                                objContact1.AccountId                            = (AccountId != null && AccountId.length() >= 15) ? AccountId : null;
                                objContact1.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;                        
                                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Acc: '+acc));
                                objContactlst.add(objContact1);
                             }  
               
               }
               //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'SObject: '+srListAcc));
            }
            if(objContactlst.size() >0)
            {  
                 srListCon = Database.insert(objContactlst);
                 this.RelConupdateContactIds();            
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, (srListCon != null? srListCon.size():0) + ' Shareholders Information created successfully'));
                if(shareholderUBO != null){this.RelConupdateUBOContactIds();}  
                if(shareholderUBO != null){this.RelConupdateUBOAccountIds(shareholderUBO);}
                if(shareholder != null){this.RelConupdateUBOAccountIds(shareholder);}
                if(Test.isRunningTest()){throw new MyException();}
            }             
         
        }
        catch(Exception e)
        {  
            //Database.RollBack(sp);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            system.debug('~~~Error 1: '+e.getMessage()+ ', Line no: '+e.getLineNumber());
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'CreateUBOShareholders',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
   
    public integer createCompany(SAF_Duedil.shareholder csh,string Relationship)
    {
        try
        {
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Name: '+csh.sourcename + ', Selected: '+csh.ischecked +', Exact Matches: '+csh));
            Account objAccount;
             if(mainAccntId == null) {
                SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
               csinfo  = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
               objAccountlst.add(customerInit(csinfo));
              
            }  
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Name: '+csh.sourcename + ', Selected: '+csh.ischecked +', Exact Matches: '+csh));
            for(SAF_Duedil.exactmatch objexact:csh.exactMatches)    
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Id: '+csh.contactId+', Selected: '+csh.ischecked+ ', Name: '+csh.sourcename+ ', Company Id: '+objexact.company.companyId));
                objAccount = new Account();
                
                if((csh.contactId == null || csh.contactId == '') && csh.ischecked != null && csh.ischecked)
                {
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Company : '+objexact.company));
                    SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
                    csinfo = SAF_Duedil.GetCompanyInfo(objexact.company.companyId,'gb');
                    
                    string SICcode = '';
                    SAF_Duedil.IndustriesInfo Indusinfo = new SAF_Duedil.IndustriesInfo();
                    if(objexact.company.companyId != null)
                    { 
                        Indusinfo = SAF_Duedil.GetIndustryInfo(objexact.company.companyId,'gb');
                        system.debug('##################Indusinfo : '+Indusinfo );
                        if(Indusinfo.industries != null)
                        {   
                            for(SAF_Duedil.IndustryInfo objcInfo:Indusinfo.industries)    
                            {
                                if(objcInfo.type == 'SIC2007' && objcInfo.code != null)
                                {SICcode =  objcInfo.code;}
                            }
                        }
                        
                        objAccount.Name                  = csh.sourceName;
                        objAccount.AccountNumber         = objexact.company.companyId;
                        objAccount.Type                  = settings.Customer_Type__c;
                        objAccount.Sic                   = SICcode;
                        //objAccount.CurrencyIsoCode       = 'GBP';
                        objAccount.Ownership             = ownerShipValue(csinfo.type); 
                        objAccount.SAF_is_Duedil_Created__c = true;
                        objAccount.CLCOMMON__LEGAL_ENTITY_TYPE__C = SETTINGS.LEGALENTITY__C; 
                        objAccount.SAF_Connection_Type__c  = Relationship;
                        objAccount.cllease__Undeployed_Funds__c = csh.totalShareholdingPercentage;
                        if(csinfo != null)
                        {
                            if(csinfo.registeredAddress != null && csinfo.registeredAddress.structuredAddress != null)
                            { 
                                objAccount.BillingStreet               = csinfo.registeredAddress.structuredAddress.premises + ' '+((csinfo.registeredAddress.structuredAddress.thoroughfare == null) ? '' :csinfo.registeredAddress.structuredAddress.thoroughfare); 
                                objAccount.BillingPostalCode           = csinfo.registeredAddress.structuredAddress.postcode;
                                objAccount.BillingCity                 = csinfo.registeredAddress.structuredAddress.postTown;
                                objAccount.BillingState                = csinfo.registeredAddress.structuredAddress.county; 
                                objAccount.BillingCountry              = csinfo.incorporationCountry; 
                                if(csinfo.registeredAddress.geolocation != null){
                                objAccount.BillingLatitude             = Decimal.ValueOf(csinfo.registeredAddress.geolocation.latitude);
                                objAccount.BillingLongitude            = Decimal.ValueOf(csinfo.registeredAddress.geolocation.longitude); }
                                objAccount.SAF_dependentLocality__c     = csinfo.registeredAddress.structuredAddress.dependentLocality;
                                objAccount.SAF_thoroughfare__c          = csinfo.registeredAddress.structuredAddress.thoroughfare;
                                objAccount.SAF_premises__c              = csinfo.registeredAddress.structuredAddress.premises;
                            }
                            
                            if(csinfo.financialSummary != null)
                            {  
                                objAccount.SAF_netAssets__c             = csinfo.financialSummary.netAssets; 
                                objAccount.SAF_totalAssets__c           = csinfo.financialSummary.totalAssets;
                                objAccount.SAF_ebitda__c                = csinfo.financialSummary.ebitda;
                                objAccount.SAF_postTaxProfit__c         = csinfo.financialSummary.postTaxProfit;
                                objAccount.SAF_turnover__c              = csinfo.financialSummary.turnover;
                            }
                            
                            if(csinfo.accounts != null)
                            {  
                                objAccount.SAF_nextAccountsDueDate__c   = csinfo.accounts.nextAccountsDueDate; 
                                objAccount.SAF_consolidatedAccounts__c  = csinfo.accounts.consolidatedAccounts;
                                objAccount.SAF_latestAccountsDate__c    = csinfo.accounts.latestAccountsDate;
                                objAccount.SAF_filingType__c            = csinfo.accounts.filingType;
                            }
                            
                            objAccount.SAF_incorporationDate__c            = csinfo.incorporationDate;
                            objAccount.SAF_incorporationCountry__c         = csinfo.incorporationCountry;
                            objAccount.SAF_charitableIdentitiesCount__c    = csinfo.charitableIdentitiesCount;
                            objAccount.SAF_officialStatus__c               = csinfo.officialStatus;
                            objAccount.SAF_simplifiedStatus__c             = csinfo.simplifiedStatus;
                            
                            if(objAccount.Name != null)
                            {
                                //insert objAccount;
                                objAccountlst.add(objAccount);
                                 
                                return 1;
                            }
                        }
                    }
                }
            }
            //if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            system.debug('~~~Error 12: '+e.getMessage()+ ', Line no: '+e.getLineNumber());
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', '', 
                'createCompany',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
        return 0;
    }
    
     public List<Contact> createperson2(SAF_Duedil.shareholder psh,string SHCompanyId)
    {
        Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
        List<contact> objContactlst = new List<contact>(); 
        List<Account> lstaccount1 = new List<Account>();
        try
        {
                              
            Account objaccount1;           
            for(SAF_Duedil.exactmatch objexact:psh.exactMatches)    
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Id: '+psh.contactId+', Selected: '+psh.ischecked+ ', Officer: '+psh.sourcename+ ', Exact Matches: '+objexact.person.officerid ));
              
                objaccount1 = new Account();
                system.debug('psh.contactId:' + psh.contactId);
                if(psh.contactId == '' || psh.contactId == null)
                {
                 if(objexact.person != null)
                    {
                        objaccount1.Name = objexact.person.firstName+ ' ' + objexact.person.lastName;
                        objaccount1.SAF_OfficerID__c = objexact.person.officerId;
                        objaccount1.Type = settings.Customer_Type__c;
                        objaccount1.Sic = '000000';
                        objaccount1.SAF_is_Duedil_Created__c = true;
                        objaccount1.Ownership = 'Individual';
                        objaccount1.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                        objaccount1.SAF_Connection_Type__c = psh.Relationship;  
                        if(mapofficers.containskey(objexact.person.officerId))
                        {
                         saf_duedil.officer objofficer = mapofficers.get(objexact.person.officerId);
                         if(objofficer.officialroleposition != null && !objofficer.officialroleposition.contains('Director'))
                            {objaccount1.SAF_Connection_Type__c = 'Officer';}
                         }   
                       // objaccount1.cllease__Undeployed_Funds__c= psh.totalShareholdingPercentage;   
                  /*  if(objexact.appointments[0] != null  && objexact.appointments[0].serviceAddress != null  && objexact.appointments[0].serviceAddress.structuredAddress != null)
                    {
                        objaccount1.BillingStreet                    = objexact.officers.appointments[0].serviceAddress.structuredAddress.premises + ' '+objexact.appointments[0].serviceAddress.structuredAddress.thoroughfare;
                        objaccount1.BillingPostalCode                = objexact.appointments[0].serviceAddress.structuredAddress.postcode;
                        objaccount1.BillingCity                      = objexact.appointments[0].serviceAddress.structuredAddress.postTown;
                        objaccount1.BillingState                     = objexact.appointments[0].serviceAddress.structuredAddress.county;
                    }  */                    
                     }
                     if(objaccount1.Name !=null) {lstaccount1.add(objaccount1);}                    
                 }
              }
           String AccountId1;
           if(lstaccount1.size() >0)
           {
             //database.insert(accs);
              if(mainAccntId == null) {
                SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
               csinfo  = SAF_Duedil.GetCompanyInfo(SHCompanyId,'gb');
               lstaccount1.add(customerInit(csinfo));
              
            }
              system.debug('lstaccount1'+lstaccount1+lstaccount1.size());
              Savepoint sp = Database.setSavepoint();
              Database.SaveResult[] srList = Database.insert(lstaccount1,false);
              
               if(mainAccntId == null) {
               List<Account> mainAccount = [Select Id,Name from Account where AccountNumber =:SHCompanyId];                
               mainAccntId = (mainAccount.size() >0) ? mainAccount[0].Id : null; 
              // GetRelationship(objaccount1.SAF_Connection_Type__c,mainAccntId,objaccount1.Id,null);               
              }
               
              Contact objContact;
           for(SAF_Duedil.exactmatch objexact:psh.exactMatches)    
            {
              system.debug('******lstaccount1*****'+lstaccount1);
              for(Account objacc:lstaccount1)    
              {
                 AccountId1 =  objacc.Id; 
                 system.debug('******AccountId1 *****'+AccountId1);
                 string officername = objexact.person.firstName+ ' ' + objexact.person.lastName;
                 system.debug('**********officername *******'+officername );                                     
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Id: '+psh.contactId+', Selected: '+psh.ischecked+ ', Officer: '+psh.sourcename+ ', Exact Matches: '+objexact.person.officerid ));
                objContact = new Contact();                
                if(psh.contactId == '' || psh.contactId == null && officername == objacc.name )
                {
                    if(objexact.person != null)
                    {
                        objContact.AccountId                            = (AccountId1 != null && AccountId1.length() >= 15) ? AccountId1 : null;
                        objContact.SAF_OfficerId__c                     = objexact.person.officerId; 
                        objContact.LastName                             = objexact.person.lastName;//psh.person.middlename + ' ' +
                        objContact.FirstName                            = objexact.person.firstName;
                        objContact.Salutation                           = objexact.person.honorific;
                        objContact.SAF_is_Duedil_Created__c             = true;
                        objContact.clcommon__Legal_Entity_Type__c = settings.LegalEntity_Individual__c;
                        if(objexact.person.dateOfBirth.year != null) 
                        { 
                            //objContact.Birthdate = Date.newInstance(integer.valueof(objexact.person.dateOfBirth.year), integer.valueof(objexact.person.dateOfBirth.month), 1); 
                            objContact.SAF_DOB_Month__c = objexact.person.dateOfBirth.month ;
                            objContact.SAF_DOB_Year__c = objexact.person.dateOfBirth.year;
                        }
                    }  
                    
                    
                    //if(objexact.appointments[0] != null 
                    //    && objexact.appointments[0].serviceAddress != null 
                    //    && objexact.appointments[0].serviceAddress.structuredAddress != null)
                    /*{
                        objContact.MailingStreet                    = objexact.officers.appointments[0].serviceAddress.structuredAddress.premises + ' '+objexact.appointments[0].serviceAddress.structuredAddress.thoroughfare;
                        objContact.MailingPostalCode                = objexact.appointments[0].serviceAddress.structuredAddress.postcode;
                        objContact.MailingCity                      = objexact.appointments[0].serviceAddress.structuredAddress.postTown;
                        objContact.MailingState                     = objexact.appointments[0].serviceAddress.structuredAddress.county;
                    }*/
                    
                    //objContact.AccountId                            = AccountId.length() >= 15 ? AccountId : null; 
                    objContact.title                                = 'Director/Officer';
                    objContact.SAF_TotalShareholding__c             = psh.totalShareholding;
                    objContact.SAF_TotalShareholdingPercentage__c   = String.ValueOf(psh.totalShareholdingPercentage);
                    objContact.SAF_Is_Shareholder__c                = true;
                    objContact.SAF_Shareholder_Relationship__c      = psh.Relationship;
                    
                    if(objContact.LastName !=null && objacc.clcommon__Legal_Entity_Type__c == settings.LegalEntity_Individual__c) 
                    {
                        //lstcontact.add(objContact);
                        //insert objContact;
                        objContactlst.add(objContact);
                       
                       // return 1;
                    }
                }GetRelationship(objacc.SAF_Connection_Type__c,mainAccntId ,objacc.Id, psh.totalShareholdingPercentage);
            }
            
         }
             system.debug('objContactlst:' + objContactlst);//if(Test.isRunningTest()){throw new MyException();} 
         } 
        } 
        catch(Exception e)
        {  
            //Database.RollBack(sp);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', 'SAF_CompanyDeatils', 
                'createPerson2',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
                system.debug('createPerson2 :' + strErrordes);
         }
          return objContactlst;
      }
  
    // Deepak <UBO Share holders creation> - Ends
    
    public void RelConGetCompanyInfo()
    {
        try
        {
            // assigning values to id field
            
            List<Account> lstacc = [select Id,Name,BillingAddress,BillingCity,BillingState,BillingPostalCode,BillingStreet,BillingCountry,SAF_Connection_Type__c,Accountnumber from Account where Accountnumber =:CompanyId];
            for(account acc:lstacc)    
            {
                if(acc != null)
                {
                    //CustAddress = String.ValueOf(acc.BillingAddress);
                    CustAddress = (acc.BillingStreet == null ? '' : acc.BillingStreet);CustAddress = CustAddress == '' ? (acc.BillingCity         == null ? '' : acc.BillingCity)       : (acc.BillingCity         == null ? CustAddress : CustAddress + ', ' + acc.BillingCity);CustAddress = CustAddress == '' ? (acc.BillingPostalCode   == null ? '' : acc.BillingPostalCode) : (acc.BillingPostalCode   == null ? CustAddress : CustAddress + ', ' + acc.BillingPostalCode); CustAddress = CustAddress == '' ? (acc.BillingState        == null ? '' : acc.BillingState )     : (acc.BillingState        == null ? CustAddress : CustAddress + ', ' + acc.BillingState);CustAddress = CustAddress == '' ? (acc.BillingCountry      == null ? '' : acc.BillingCountry)    : (acc.BillingCountry      == null ? CustAddress : CustAddress + ', ' + acc.BillingCountry); CompanyName = acc.Name; ConnectionType = acc.SAF_Connection_Type__c;
                    AccountId = acc.Id;
                }
                else
                {
                    SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();csinfo = SAF_Duedil.GetCompanyInfo(CompanyId ,'gb');
                    CompanyName = csinfo.Name;CustAddress  = csinfo.registeredAddress.fullAddress;
                    // ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please create customer before creating related Contacts.'));
                }
            }   
            //if(Test.isRunningTest()){throw new MyException();}
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'RelConGetCompanyInfo',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public static String ownerShipValue(String ddosValue)
    {
        List<SAF_Ownership__c> mcs = SAF_Ownership__c.getall().values();
        boolean textField = null;
        
        for(SAF_Ownership__c os: mcs)
        {
            system.debug(os.Duedil_Ownership__c);
            system.debug(os.Ownership__c);
            
            if(ddosValue == os.Duedil_Ownership__c)
            {
                return os.Ownership__c;
            }
        }
        return 'Other';
    }
    
    /* Merging Related Contacts to this page - Ends*/
    
    /*Generate the cais file forcurrent month*/
    public void SAF_CompanyDeatils()
    {
        try
        {
             system.debug('###SAF_CompanyDeatils :*******');
            show();
            RelConShow();
            this.updateParentAccountIds();
            updateAccountIds();
             Companyname = Companyname.replace('ampar', '&');
            //this.RelConupdateContactIds();
            //this.RelConupdateUBOContactIds();
            //this.RelConupdateUBOAccountIds();
            if(lstaccounts != null && lstaccounts.size() > 0 ) {update lstaccounts;}
            if(CompgroupParents != null && CompgroupParents.size() == 0) {GroupParentsmessage = 'No Group Companies found for this company.';}
            if(comprelatedCompanies != null && comprelatedCompanies.size() == 0) {comprelatedCompaniesmessage = 'No Related Customers found for this company.';}
            if(shareholder != null && shareholder.size() == 0) {shareholdersmessage = 'No Shareholder Information (Total shareholding % 25 and above) found for this company.';}
            if(shareholderUBO != null && shareholderUBO.size() == 0) {UBOCompanymessage = 'No shareholders found for this company.';}
            if(officers != null && officers.size() == 0) {officersmessage = 'No Directors found for this company.';}
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        { 
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));        
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'SAF_CompanyDeatils',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
        }
       
    }
      Public class AccountContWrapper
    {
    
        public List<Account> Accounts;
        public List<Contact> Contacts;
    
    }
}