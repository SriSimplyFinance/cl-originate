/**
    @ name                      : SAF_PepSanction
    @ author                    : Happiest Minds/Phalguni
    @ description               : Get pep and sanction info from Duedil APi
    @ created date              : 05/16/2019   
    @ Modified by / Date        : 05/22/2019 
*/

Global class SAF_PepSanction{
    public Integer totalMatches;    //5
    public cls_criteria criteria;
    public cls_possibleMatches[] possibleMatches;
    public static date BranchDate;
    public static Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
   
    webservice static string GetAppStatus(string strAppId,string strCustId,string totalrecords)
   {
     string strAppStatus = 'Error';
       User userRec = [Select Id,Name, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
       BranchDate = userRec.cllease__Current_Branch_s_System_Date__c;
       List<genesis__Applications__c> lstgenApp = [select Id,name,SAF_PEP_Status__c from genesis__Applications__c where Id =: strAppId];
       List<saf_pep_sanction_app__c> lstpepApp = [select Id,saf_Customer__r.saf_IsRed__c,saf_Individual__r.saf_IsRed__c,saf_Application__r.SAF_PEP_Status__c,saf_Individual__c,saf_Individual__r.SAF_PEPApp_LastModifiedBy__c,saf_Individual__r.SAF_PepApp_LastModifiedDate__c,saf_Individual__r.SAF_PepApp_Createddate__c,saf_Customer__r.SAF_PEPApp_LastModifiedBy__c,saf_Customer__r.SAF_PepApp_LastModifiedDate__c,saf_Customer__r.SAF_PepApp_Createddate__c,createddate,Saf_lastmodifedBranchDate__c,LastModifiedDate, saf_Customer__c,Name,saf_Application__c,saf_CompanyID__c,SAF_Status__c,saf_TotalMatches__c from saf_pep_sanction_app__c where saf_Application__c =: strAppId]; 
       Map<Id,Account> mapcustomer = new Map<Id,Account>(); 
       Map<Id,Contact> mapcontact = new Map<Id,Contact>(); 
      //Map<Id,string> MapAppStatus = new Map<Id,string>(); 
         //Integer noOfFail =0; Integer noOfManualPass=0; Integer noOfPass=0;Integer inProgress=0;
         Integer noOfmatchesabove90 =0; 
          if(lstpepApp.size() ==0)
          { strAppStatus = 'PEPs and Sanctions Verification Required';}
          else
          {
           
             for(saf_pep_sanction_app__c objpepApp:lstpepApp)    
                {
               /*   if(objpepApp.SAF_Status__c == 'PEPs and Sanctions Failed')
                      {noOfFail = noOfFail +1;}
                  else if(objpepApp.SAF_Status__c =='PEPs and Sanctions Passed - Manually Verified')
                      {noOfManualPass = noOfManualPass +1;}
                  else if(objpepApp.SAF_Status__c == 'PEPs and Sanctions completed')
                      {noOfPass = noOfPass+1;}
                      else if(objpepApp.SAF_Status__c == 'PEPs and Sanctions Verification required - In Progress')
                       {inProgress= inProgress+1;}
                  else {}*/
                  if(objpepApp.saf_Customer__r.saf_IsRed__c >0) {noOfmatchesabove90 = noOfmatchesabove90 +1;}
                  if(objpepApp.saf_Individual__r.saf_IsRed__c >0) {noOfmatchesabove90 = noOfmatchesabove90 +1;} 
                  
                   //MapAppStatus.put(objpepApp.saf_Application__c,objpepApp.saf_Application__r.SAF_PEP_Status__c);
                   Account objacc = objpepapp.saf_Customer__r;
                   objacc.SAF_PepApp_Createddate__c = objpepapp.createddate;
                           objacc.SAF_PepApp_LastModifiedDate__c = objpepapp.lastmodifieddate;
                           objacc.SAF_PEPApp_LastModifiedBy__c = userRec.Name;
                           mapcustomer.put(objacc.Id,objacc); 
                   if(objpepapp.saf_Individual__c != null)
                   {        
                   Contact objcon = objpepapp.saf_Individual__r;
                   objcon.SAF_PepApp_Createddate__c = objpepapp.createddate;
                           objcon.SAF_PepApp_LastModifiedDate__c = objpepapp.lastmodifieddate;
                           objcon.SAF_PEPApp_LastModifiedBy__c = userRec.Name;
                           mapcontact.put(objcon.Id,objcon); 
                    }
                    
                }
          }// system.debug('*****noOfFail:'+noOfFail +'*****noOfManualPass:'+noOfManualPass +'*****noOfPass:'+noOfPass);
           system.debug('*****noOfmatchesabove90 :'+noOfmatchesabove90);
          system.debug('*****mapcontact:'+mapcontact);
           system.debug('*****mapcustomer:'+mapcustomer);
          for(genesis__Applications__c objgenApp:lstgenApp)  
          {
          Integer inttotal = (totalrecords !=null) ? integer.valueof(totalrecords) : 0;
            /*If(noOfFail >0) {objgenApp.SAF_PEP_Status__c = 'PEPs and Sanctions Failed';}
            else if(noOfFail == 0 && inProgress >0) {objgenApp.SAF_PEP_Status__c = 'PEPs and Sanctions Verification required - In Progress';}
            else if(noOfFail == 0 && noOfManualPass >0) {objgenApp.SAF_PEP_Status__c = 'PEPs and Sanctions Passed - Manually Verified';}         
            else if(noOfFail == 0 && noOfManualPass == 0 && noOfPass >0 && noOfPass == lstpepApp.size()) {objgenApp.SAF_PEP_Status__c = 'PEPs and Sanctions completed';}
            else {objgenApp.SAF_PEP_Status__c = 'PEPs and Sanctions Verification Required';}*/
            if(noOfmatchesabove90 >0 || inttotal != lstpepApp.size()) { objgenApp.SAF_PEP_Status__c = 'PEPs and Sanctions Verification required - In Progress';}
            else {objgenApp.SAF_PEP_Status__c = 'PEPs and Sanctions completed';}
            //objgenApp.SAF_PEP_Status__c = MapAppStatus.get(objgenApp.Id);
            strAppStatus = objgenApp.SAF_PEP_Status__c;
          }
       
     update lstgenApp;
     if(mapcustomer.size() >0) update mapcustomer.values();//SAF_PEP_Status__c
     if(mapcontact.size() >0) update mapcontact.values();
     return strAppStatus;
   }    
   webservice static List<string> GetRelatedCustomers(string CompanyId ,string strCompanyName)
   { 
    Set<string> AccountIds = new Set<string>();
    List<string> companyIds = new List<string>();
    List<string> contactIds = new List<string>();
    Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
    /*SAF_CompanyDeatils objcomp = new SAF_CompanyDeatils();
    objcomp.Companyname =strCompanyName;
    objcomp.CompanyId = strCustomerId;
    objcomp.SAF_CompanyDeatils();
    AccountIds = SAF_CompanyDeatils.AccountIds;
    system.debug('AccountIds  :' +AccountIds);*/
           SAF_Duedil dd = new SAF_Duedil();
           string UBOCompanyId = '';
           string UBOCompanyName = '';
           string ParentCompanyId = '';
           string ParentCompanyName = '';
                      
                      
            SAF_Duedil.GroupCompanies gp = new SAF_Duedil.GroupCompanies();
            List<SAF_Duedil.groupParent> CompgroupParents = new List<SAF_Duedil.groupParent>();
            SAF_Duedil.companyshareholders cs = new SAF_Duedil.companyshareholders();
            SAF_Duedil.companyshareholders Ubocs = new SAF_Duedil.companyshareholders();
               system.debug('*****CompanyId**********'+CompanyId );
            if(CompanyId != null && CompanyId != '')
            {
                //cs = SAF_Duedil.getCustomers(CompanyId,'10','0');
                //CustInfo = cs.companies;
                
                //this.updateParentAccountIds();
                
                
                gp = SAF_Duedil.GetGroupCompanies(CompanyId,'gb'); 
                CompgroupParents = gp.groupParents;
                SAF_Duedil.companyofficers csGrpofficers = new SAF_Duedil.companyofficers();
               if(CompgroupParents != null)
               { 
                 for(SAF_Duedil.groupParent objgp:CompgroupParents)  
                 {
                    companyIds.add(objgp.companyId);
                      if(Boolean.valueof(objgp.isUltimateParent) == true)
                                     {
                                         UBOCompanyId = objgp.companyId;
                                         UBOCompanyName = objgp.name;              
                                     }
                     else if(Boolean.valueof(objgp.isImmediateParent) == true)
                                     {
                                         ParentCompanyId = objgp.companyId;
                                         ParentCompanyName = objgp.name;               
                                     }    
                    else
                   { 
                    csGrpofficers = SAF_Duedil.GetcompanyOfficers(objgp.companyId,'gb');
                    if(csGrpofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csGrpofficers.officers) 
                         {
                           if(objp.officerId != null || objp.officerId != '')
                           {
                              contactIds.add(objp.officerId); 
                              //system.debug('officerId :' +objp.officerId);
                           }
                           
                         }
                       }   
                    }   
                                 
                 }
              }
               cs = SAF_Duedil.GetShareholders(CompanyId,'gb');
               
               if(cs.shareholders != null)
               { 
                for(SAF_Duedil.shareholder objc:cs.shareholders)    
                {
                 for(SAF_Duedil.exactMatch objcmatch:objc.exactMatches)    
                        {
                            if(objcmatch.type == 'company' && objcmatch.person == null)
                            {  
                             if(objc.totalShareholdingPercentage >=settings.TotalShareholderPercentage__c)
                                   {
                                      //shareholder.add(objc);
                                      companyIds.add(objcmatch.company.companyId);
                                   }
                            }
                         }
                } 
               } 
                  csGrpofficers = SAF_Duedil.GetcompanyOfficers(CompanyId,'gb');
                    if(csGrpofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csGrpofficers.officers) 
                         {
                           if(objp.officerId != null || objp.officerId != '')
                           {
                              contactIds.add(objp.officerId); 
                              //system.debug('officerId :' +objp.officerId);
                           }
                           
                         }
                       }
               if(ParentCompanyId != '' && ParentCompanyName != null)
              { 
               csGrpofficers = SAF_Duedil.GetcompanyOfficers(UBOCompanyId,'gb');
                    if(csGrpofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csGrpofficers.officers) 
                         {
                           if(objp.officerId != null || objp.officerId != '')
                           {
                              contactIds.add(objp.officerId); 
                              //system.debug('officerId :' +objp.officerId);
                           }
                           
                         }
                       }
                 }
              if(UBOCompanyId != '' && UBOCompanyId != null)
              { 
               csGrpofficers = SAF_Duedil.GetcompanyOfficers(ParentCompanyId,'gb');
                    if(csGrpofficers.officers != null)
                       {
                         for(SAF_Duedil.officer  objp:csGrpofficers.officers) 
                         {
                           if(objp.officerId != null || objp.officerId != '')
                           {
                              contactIds.add(objp.officerId); 
                              //system.debug('officerId :' +objp.officerId);
                           }
                           
                         }
                       }
                       
                Ubocs = SAF_Duedil.GetShareholders(UBOCompanyId,'gb');  
               if(Ubocs.shareholders != null)
               { 
                for(SAF_Duedil.shareholder objc:Ubocs.shareholders)    
                {
                 for(SAF_Duedil.exactMatch objcmatch:objc.exactMatches)    
                        {
                            if(objcmatch.type == 'company' && objcmatch.person == null)
                            {  
                             if(objc.totalShareholdingPercentage >=settings.TotalShareholderPercentage__c)
                                   {
                                      //shareholder.add(objc);
                                      companyIds.add(objcmatch.company.companyId);
                                   }
                            }
                         }
                }    
                }
              } 
            }
        system.debug('*****companyIds**********'+companyIds ); 
         system.debug('*****contactIds**********'+contactIds);  
          for(Account objacc:[select Id,Name from Account where accountnumber in: companyIds and accountnumber != null and accountnumber != ''])
          {
           AccountIds.add(objacc.Id);
          }
           List<string> UniqueAccountIds = new List<string>(AccountIds);
         
          for(Contact objcon:[select Id,Name from Contact where AccountId in: AccountIds or (saf_officerId__c in: contactIds and saf_officerId__c != null and saf_officerId__c != '')])
          {
           UniqueAccountIds.add(objcon.Id);
          }
         
           system.debug('*****UniqueAccountIds**********'+UniqueAccountIds);  
          return UniqueAccountIds;
   }
   webservice static string GetPepSanctionApplication(string strCustomerId,string strAppId,boolean IsSelected)
   {    
         string strreturn = 'No matches found';
         string strDateFormat = 'ddMMyyyy'; 
           //Get the Current date from CL which we would displaying in Page.
       User userRec = [Select Id,Name, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
       BranchDate = userRec.cllease__Current_Branch_s_System_Date__c;
       
       try
       {
       List<Account> lstcustomer = [select Id,Name,Accountnumber from Account where Id =: strCustomerId];
       List<saf_pep_sanction_info__c> lstpep = [select Id,Saf_IsActive__c,Name,saf_Customer__r.Accountnumber,saf_Customer__c,saf_application__c,saf_pep_sanction_app__c,saf_pep_sanction_app__r.saf_CompanyID__c,saf_pep_sanction_app__r.LastModifiedDate,CreatedDate from saf_pep_sanction_info__c where saf_Customer__c=: strCustomerId];
        system.debug('lstpep :' +lstpep );     
       List<saf_pep_sanction_app__c> lstpepAppCust = new List<saf_pep_sanction_app__c> ();
       List<Account> lstcustomer1 = new List<Account>();
        List<saf_pep_sanction_app__c> lstpepApp = [select Id,saf_Customer__r.saf_Color__c,saf_application__r.Name,Saf_lastmodifedBranchDate__c,LastModifiedDate, saf_Customer__c,Name,saf_Application__c,saf_CompanyID__c,SAF_Status__c,saf_TotalMatches__c from saf_pep_sanction_app__c where saf_Customer__c=: strCustomerId and SAF_individual__c =: '' and saf_Application__c =: strAppId order by lastmodifieddate desc limit 1]; 
        
       
     
       date OldDate = userRec.cllease__Current_Branch_s_System_Date__c.addmonths(Integer.valueof(settings.PEPSanctionMonth__c));//date.today().addmonths(-3);
      system.debug('OldDate :' +OldDate );
    
      //List<saf_pep_sanction_app__c> lstpepapp = [select Id,Name,saf_application__c,saf_application__r.Name from saf_pep_sanction_app__c where saf_Application__c =: strAppId];
       List<saf_pep_sanction_info__c> lstpepNew = new  List<saf_pep_sanction_info__c>();
       saf_duedil.cls_PepSanction objduepep = new saf_duedil.cls_PepSanction();
       objduepep.Alladdr = new List<saf_Pep_addresses__c>();
             
      for(saf_pep_sanction_app__c objpepapp:lstpepApp)  
         {
          system.debug('IsSelected:' +IsSelected + objpepapp.saf_application__r.Name);     
            //if(strAppId == objpepapp.saf_application__c)
              // {
                if(objpepapp.Saf_lastmodifedBranchDate__c < OldDate || IsSelected)
                { system.debug('objpepapp.LastModifiedDate :' +objpepapp.LastModifiedDate);     
                  
                        for(saf_pep_sanction_info__c objpepinfo:lstpep)
                        {
                            objpepinfo.Saf_IsActive__c  = False;
                        }
                        string pepappid = objpepapp.Id;
                       
                         objduepep = CreatePepSanctionCustomer(lstcustomer[0].Accountnumber,strCustomerId,strAppId,pepappid);
                        if(objduepep !=null && objduepep.AllpepInfo !=null)
                        {
                             objpepapp.saf_TotalMatches__c = objduepep.totalmatches;
                             
                             objpepapp.Saf_lastmodifedBranchDate__c =BranchDate;
                             //objpepapp.SAF_Status__c= objduepep.totalmatches;
                             
                             lstpepNew.addall(objduepep.AllpepInfo); 
                         }
                         
                     
                } 
                else 
                {strreturn = 'PEPs and Sanctions check has been completed within the last 3 months.';}
                 if(objduepep.totalmatches == null || objduepep.totalmatches == 0) 
                             {
                              objpepapp.SAF_Status__c = 'PEPs and Sanctions completed';
                              objpepapp.saf_Customer__r.saf_Color__c = 3;
                             }
                //break;
                 system.debug('objpepapp.SAF_Status__c:' +objpepapp.SAF_Status__c);
              //   break;
             //}else {IsAppFound  = true;system.debug('IsAppFound  :' +IsAppFound);}
          }      
       
         system.debug('lstpepApp.size():' +lstpepApp.size());       
         
         
       if(lstpepApp.size() ==0)
       {
          
          lstpepAppCust = [select Id,saf_Customer__r.saf_Color__c,saf_application__r.Name,Saf_lastmodifedBranchDate__c,LastModifiedDate, saf_Customer__c,Name,saf_Application__c,saf_CompanyID__c,SAF_Status__c,saf_TotalMatches__c from saf_pep_sanction_app__c where saf_Customer__c=: strCustomerId and SAF_individual__c =: '' order by lastmodifieddate desc limit 1]; 
          system.debug('lstpepAppCust :' +lstpepAppCust);
         for(saf_pep_sanction_app__c objpepapp:lstpepAppCust)  
         {
          system.debug('IsSelected:' +IsSelected + objpepapp.saf_application__r.Name);     
            //if(strAppId == objpepapp.saf_application__c)
              // 
                if(objpepapp.Saf_lastmodifedBranchDate__c < OldDate || IsSelected)
                { system.debug('objpepapp_customer.Saf_lastmodifedBranchDate__c :' +objpepapp.Saf_lastmodifedBranchDate__c );     
                  
                        for(saf_pep_sanction_info__c objpepinfo:lstpep)
                        {
                            objpepinfo.Saf_IsActive__c  = False;
                        }
                        string pepappid = objpepapp.Id;
                       
                         objduepep = CreatePepSanctionCustomer(lstcustomer[0].Accountnumber,strCustomerId,strAppId,pepappid);
                        if(objduepep !=null)
                        {
                             objpepapp.saf_TotalMatches__c = objduepep.totalmatches;
                             objpepapp.Saf_lastmodifedBranchDate__c =BranchDate;
                             //objpepapp.SAF_Status__c= objduepep.totalmatches;
                             
                             lstpepNew.addall(objduepep.AllpepInfo); 
                         }
                         
                     
                } 
                else 
                {strreturn = 'PEPs and Sanctions check has been completed within the last 3 months.';
                
                  integer totalmacthes = (objpepapp.saf_TotalMatches__c == null) ? null :Integer.valueof(objpepapp.saf_TotalMatches__c);
                  if(totalmacthes == 0 || totalmacthes ==null)  {objpepapp.saf_Customer__r.saf_Color__c = 3;}
                  
                  CreatePepSanctionApp(lstcustomer[0].Accountnumber,strCustomerId,strAppId,totalmacthes);                
                }
                 if(objduepep.totalmatches == null || objduepep.totalmatches == 0) 
                             {
                              objpepapp.SAF_Status__c = 'PEPs and Sanctions completed';
                              objpepapp.saf_Customer__r.saf_Color__c = 3;
                             }
                //break;
                system.debug('objpepapp.saf_Customer__r.saf_Color__c:'+objpepapp.saf_Customer__r.saf_Color__c);
                 system.debug('objpepapp.SAF_Status__c:' +objpepapp.SAF_Status__c);
             Account objacc = objpepapp.saf_Customer__r;
             objacc.saf_Color__c = objpepapp.saf_Customer__r.saf_Color__c;
             lstcustomer1.add(objacc);
             system.debug('lstcustomer1'+lstcustomer1);
          }       
            
       }
       
       if(lstpepApp.size() ==0 && lstpepAppCust.size() ==0)
       {
                system.debug('no pep app records'); 
                objduepep = CreatePepSanctionCustomer(lstcustomer[0].Accountnumber,strCustomerId,strAppId,null);
               if(objduepep.AllpepInfo !=null)
               {
                system.debug('objduepep.AllpepInfo.size() :' +objduepep.AllpepInfo.size());
                if(objduepep.AllpepInfo.size() >0)           
                {  lstpepNew.addall(objduepep.AllpepInfo);  }
               }
            
          }
          
       system.debug('lstpepNew:' +lstpepNew.size()+ 'objduepep.strpepappId :'+ objduepep.strpepappId);
       if(lstpepNew.size() >0) 
       {   
          List<saf_pep_sanction_app__c> updatepepapp = [select Id,Name,SAF_Status__c,saf_Customer__c,saf_Customer__r.saf_Color__c from saf_pep_sanction_app__c where Id =: objduepep.strpepappId];
           system.debug('updatepepapp :' + updatepepapp);   
                
                 for(saf_pep_sanction_app__c objpepapp:updatepepapp)  
                     {
                         if(objduepep.totalmatches == null || objduepep.totalmatches == 0) 
                         {
                          objpepapp.SAF_Status__c = 'PEPs and Sanctions completed';
                          objpepapp.saf_Customer__r.saf_Color__c = 3;
                         }
                          else
                          {  
                             boolean noofmatchscoreabove90 = (objduepep.noofmatchscoreabove90 != null) ? objduepep.noofmatchscoreabove90 : false;
                             if(noofmatchscoreabove90)                    {
                               objpepapp.SAF_Status__c = 'PEPs and Sanctions Verification required - In Progress';
                               objpepapp.saf_Customer__r.saf_Color__c = 2; 
                             } 
                             else
                             {objpepapp.SAF_Status__c = 'PEPs and Sanctions completed';
                                objpepapp.saf_Customer__r.saf_Color__c = 1;
                             }
                          }
                           Account objacc = objpepapp.saf_Customer__r;
                           objacc.saf_Color__c = objpepapp.saf_Customer__r.saf_Color__c;
                           /*objacc.SAF_PepApp_Createddate__c = objpepapp.createddate;
                           objacc.SAF_PepApp_LastModifiedDate__c = objpepapp.lastmodifieddate;
                           objacc.SAF_PEPApp_LastModifiedBy__c = userRec.Name;*/
                           lstcustomer1.add(objacc);
                     }
               
           update updatepepapp;
          
           system.debug('lstcustomer1:' +lstcustomer1);
                          
           if(lstpep.size()>0) { update lstpep;} 
            update lstcustomer1;        
           strreturn = 'Success';
       }
       
        
      }
       catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes =  e.getMessage() + ', Line no: '+e.getLineNumber();
            system.debug('error_cust:' +strErrordes);
            strreturn = 'Failed to retrieve data from DueDil. Please try later.';
            ErrorLogsUtils.createErrorLogs('No matches found', 'SAF_PepSanction', 
                'GetPepSanctionApplication',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }  
       return strreturn;
   }
   
   webservice static string GetPepSanctionApplicationInd(string strContactId,string strAppId,boolean IsSelected)
   {    
         string strreturn = 'No matches found';
         string strDateFormat = 'ddMMyyyy'; 
           //Get the Current date from CL which we would displaying in Page.
       User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
       BranchDate = userRec.cllease__Current_Branch_s_System_Date__c;
       //Map<Id,saf_pep_sanction_app__c> MapPepAppUpdate = new  Map<Id,saf_pep_sanction_app__c>();
       try
       {
       List<Contact> lstContact1 = new List<Contact>();
       List<Contact> lstContact = [select Id,saf_Color__c ,Otherstreet,AccountId,Account.accountnumber,Othercity,OtherPostalCode,lastName,Birthdate,SAF_DOB_year__c,SAF_DOB_month__c,SAF_DOB_day__c,SAF_OfficerId__c,FirstName,ints__Middle_Name__c from Contact where Id =: strContactId];
       List<saf_pep_sanction_Individual__c> lstpep = [select Id,Saf_IsActive__c,Name,SAF_Contact__c,saf_application__c,saf_pep_sanction_app__c,CreatedDate from saf_pep_sanction_Individual__c where SAF_Contact__c=: strContactId];
        system.debug('lstpep :' +lstpep );     
          List<saf_pep_sanction_app__c> lstpepAppCust = new List<saf_pep_sanction_app__c> ();

        List<saf_pep_sanction_app__c> lstpepApp = [select Id,saf_CompanyID__c,Saf_lastmodifedBranchDate__c,LastModifiedDate, saf_Customer__c,Name,saf_Application__c,SAF_Status__c,saf_TotalMatches__c,SAF_individual__c,SAF_individual__r.saf_Color__c from saf_pep_sanction_app__c where SAF_individual__c=: strContactId and saf_Application__c =: strAppId order by lastmodifieddate desc limit 1]; 
        
       
     
       date OldDate = userRec.cllease__Current_Branch_s_System_Date__c.addmonths(Integer.valueof(settings.PEPSanctionMonth__c));//date.today().addmonths(-3);
      system.debug('OldDate :' +OldDate );
    
      //List<saf_pep_sanction_app__c> lstpepapp = [select Id,Name,saf_application__c,saf_application__r.Name from saf_pep_sanction_app__c where saf_Application__c =: strAppId];
       List<saf_pep_sanction_Individual__c> lstpepNew = new  List<saf_pep_sanction_Individual__c>();
       saf_duedil.cls_PepSanction objduepep = new saf_duedil.cls_PepSanction();
       objduepep.Alladdr = new List<saf_Pep_addresses__c>();
      
              
      for(saf_pep_sanction_app__c objpepapp:lstpepApp)  
         {
          system.debug('IsSelected:' +IsSelected);     
            if(objpepapp.Saf_lastmodifedBranchDate__c < OldDate || IsSelected)
            { system.debug('objpepapp.LastModifiedDate :' +objpepapp.LastModifiedDate);     
                for(saf_pep_sanction_Individual__c objpepinfo:lstpep)
                {
                    objpepinfo.Saf_IsActive__c  = False;
                }
                string pepappid = objpepapp.Id;
                
                 objduepep = CreatePepSanctionContact(objpepapp.saf_CompanyID__c,objpepapp.saf_customer__c,strAppId,lstcontact[0],pepappid);
                if(objduepep != null && objduepep.Allind !=null)
                {
                     objpepapp.saf_TotalMatches__c = objduepep.totalmatches;
                     objpepapp.Saf_lastmodifedBranchDate__c =BranchDate;
                     //objpepapp.SAF_Status__c= objduepep.totalmatches;
                     lstpepNew.addall(objduepep.Allind); 
                 } 
            } 
            else 
            {strreturn = 'PEPs and Sanctions check has been completed within the last 3 months.';}
            //break;
              if(objduepep.totalmatches == null || objduepep.totalmatches == 0) 
                         {
                         system.debug('objduepep.totalmatches:' +objduepep.totalmatches);
                          objpepapp.SAF_Status__c = 'PEPs and Sanctions completed';
                          objpepapp.saf_individual__r.saf_Color__c = 3;
                          //MapPepAppUpdate.put(objpepapp.Id,objpepapp);
                         }
            //break;
             system.debug('objpepapp.SAF_Status__c:' +objpepapp.SAF_Status__c);
          }      
       
         system.debug('lstpepApp.size():' +lstpepApp.size());
       if(lstpepApp.size() ==0)
       {
            lstpepAppCust = [select Id,saf_individual__r.saf_Color__c,saf_application__r.Name,Saf_lastmodifedBranchDate__c,LastModifiedDate, saf_Customer__c,Name,saf_Application__c,saf_CompanyID__c,SAF_Status__c,saf_TotalMatches__c from saf_pep_sanction_app__c where SAF_individual__c =: strContactId order by lastmodifieddate desc limit 1]; 
        
           for(saf_pep_sanction_app__c objpepapp:lstpepAppCust)  
                 {
                  system.debug('IsSelected:' +IsSelected + objpepapp.saf_application__r.Name);     
                    //if(strAppId == objpepapp.saf_application__c)
                      // 
                        if(objpepapp.Saf_lastmodifedBranchDate__c < OldDate || IsSelected)
                        { system.debug('objpepapp_customer.LastModifiedDate :' +objpepapp.LastModifiedDate);     
                          
                                for(saf_pep_sanction_Individual__c objpepinfo:lstpep)
                                {
                                    objpepinfo.Saf_IsActive__c  = False;
                                }
                                string pepappid = objpepapp.Id;
                                //if(strAppId != objpepapp.saf_application__c) {pepappid = '';} 
                                objduepep = CreatePepSanctionContact(objpepapp.saf_CompanyID__c,objpepapp.saf_customer__c,strAppId,lstcontact[0],null);
                               
                                if(objduepep !=null)
                                {
                                     objpepapp.saf_TotalMatches__c = objduepep.totalmatches;
                                     objpepapp.Saf_lastmodifedBranchDate__c =BranchDate;
                                     //objpepapp.SAF_Status__c= objduepep.totalmatches;
                                     
                                     lstpepNew.addall(objduepep.Allind); 
                                 }
                                 
                             
                        } 
                        else 
                        {strreturn = 'PEPs and Sanctions check has been completed within the last 3 months.';
                        
                          integer totalmacthes = (objpepapp.saf_TotalMatches__c == null) ? null :Integer.valueof(objpepapp.saf_TotalMatches__c);
                          if(totalmacthes == 0 || totalmacthes ==null)  {objpepapp.saf_individual__r.saf_Color__c = 3;}
                          CreatePepSanctionAppIndividual(lstcontact[0].account.Accountnumber,lstcontact[0].accountId,Lstcontact[0],strAppId,totalmacthes);                
                        
                        }
                         if(objduepep.totalmatches == null || objduepep.totalmatches == 0) 
                                     {
                                      objpepapp.SAF_Status__c = 'PEPs and Sanctions completed';
                                      objpepapp.saf_individual__r.saf_Color__c = 3;
                                     }
                        //break;
                         system.debug('objpepapp.SAF_Status__c:' +objpepapp.SAF_Status__c);
                      
          }       
    
       }


        if(lstpepApp.size() ==0 && lstpepAppCust.size() ==0)
           {
                    system.debug('no pep app records'); 
               objduepep = CreatePepSanctionContact(lstContact[0].Account.accountnumber,lstContact[0].AccountId,strAppId,lstcontact[0],null);
                if(objduepep.Allind !=null)
               {
                system.debug('objduepep.Allind.size() :' +objduepep.Allind.size());
                if(objduepep.Allind.size() >0)    
                {  lstpepNew.addall(objduepep.Allind); }
               }
           }
       system.debug('lstpepNew:' +lstpepNew.size()+ 'objduepep.strpepappId :'+ objduepep.strpepappId);
       if(lstpepNew.size() >0) 
       { 
           system.debug('lstpepApp :' + lstpepApp);     
        
           List<saf_pep_sanction_app__c> updatepepapp = [select Id,Name,SAF_Status__c,saf_individual__c,saf_individual__r.saf_Color__c from saf_pep_sanction_app__c where Id =: objduepep.strpepappId];
            //system.debug('updatepepapp :' + updatepepapp);     
             system.debug('objduepep :' + objduepep);      
                 for(saf_pep_sanction_app__c objpepapp1:updatepepapp)  
                     {
                          if(objduepep.totalmatches == null || objduepep.totalmatches == 0) 
                         {
                          objpepapp1.SAF_Status__c = 'PEPs and Sanctions completed';
                           objpepapp1.saf_individual__r.saf_Color__c = 3; 
                         }
                         
                          else
                          {  
                             boolean noofmatchscoreabove90con = (objduepep.noofmatchscoreabove90con != null) ? objduepep.noofmatchscoreabove90con : false;
                             if(noofmatchscoreabove90con)
                             {
                               objpepapp1.SAF_Status__c = 'PEPs and Sanctions Verification required - In Progress';
                                objpepapp1.saf_individual__r.saf_Color__c = 2; 
                             } 
                             else
                             {objpepapp1.SAF_Status__c = 'PEPs and Sanctions completed';
                               objpepapp1.saf_individual__r.saf_Color__c = 1;  
                             }
                          }
                             Contact objacc = objpepapp1.saf_individual__r;
                           objacc.saf_Color__c = objpepapp1.saf_individual__r.saf_Color__c;
                           
                           lstContact1.add(objacc);
                     }
           system.debug('lstContact1:' +lstContact1);    
           update updatepepapp;
           if(lstpep.size()>0) { update lstpep;}
           update lstContact1;
           strreturn = 'Success';
       }
      // else { update MapPepAppUpdate.values();}
      }
       catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes =  e.getMessage() + ', Line no: '+e.getLineNumber();
           system.debug('error_cust:' +strErrordes);
            strreturn = 'Failed to retrieve data from DueDil. Please try later.';
            ErrorLogsUtils.createErrorLogs('No matches found', 'SAF_PepSanction', 
                'GetPepSanctionApplication',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }  
       return strreturn;
   }
   Public static saf_pep_sanction_app__c CreatePepSanctionApp(string CompanyId,string strAccountId,string strAppId,Integer totalmatches)
   {
             saf_pep_sanction_app__c objapp = new saf_pep_sanction_app__c(); 
             Map<Id,Account> mapcustomer1 = new Map<Id,Account>();
             objapp.saf_CompanyID__c = CompanyId;
             objapp.saf_Customer__c = strAccountId;
             objapp.saf_application__c = strAppId;
             objapp.saf_TotalMatches__c = totalmatches;
             objapp.Saf_lastmodifedBranchDate__c =BranchDate;
             if(totalmatches == null || totalmatches ==0) { objapp.SAF_Status__c = 'PEPs and Sanctions completed';
             Account objacc = [select Id,Name,saf_Color__c from Account where Id =: strAccountId];
                           objacc.saf_Color__c = 3;
                           mapcustomer1.put(objacc.Id,objacc);
             
             }
             system.debug('mapcustomer1:' +mapcustomer1);
             insert objapp;
             update mapcustomer1.values();
             return objapp;
   }
   
   Public static saf_pep_sanction_app__c CreatePepSanctionAppIndividual(string CompanyId,string strAccountId,Contact objcontact,string strAppId,Integer totalmatches)
   {
         saf_pep_sanction_app__c objapp = new saf_pep_sanction_app__c();  
         Map<Id,Contact> mapcontact1 = new Map<Id,Contact>();     
         objapp.saf_Individual__c = objcontact.Id;
         objapp.saf_application__c = strAppId;
         objapp.saf_CompanyID__c = CompanyId;
         objapp.saf_Customer__c = strAccountId;
         objapp.saf_TotalMatches__c = totalmatches;
         objapp.Saf_lastmodifedBranchDate__c =BranchDate;
         if(totalmatches == null || totalmatches ==0) { objapp.SAF_Status__c = 'PEPs and Sanctions completed';
         Contact objcon = [select Id,Name,saf_Color__c from Contact where Id =: objcontact.Id];
                           objcon.saf_Color__c = 3;
                           mapcontact1.put(objcon.Id,objcon);
             
         }
         insert objapp;
         update mapcontact1.values();
         return objapp;
   }
   public static saf_duedil.cls_PepSanction CreatePepSanctionCustomer(string CompanyId,string strAccountId,string strAppId,string strPepAppId)
   {
      saf_duedil.cls_PepSanction objduePep = new saf_duedil.cls_PepSanction();
      
      SAF_PepSanction objPepSanction = SAF_Duedil.GetPepSanctionBuisness(CompanyId,'gb');
       system.debug('objPepSanction :' +objPepSanction );     
      saf_pep_sanction_app__c objapp = new saf_pep_sanction_app__c(); 
     if((strPepAppId == null || strPepAppId == '') && objPepSanction !=null)
     {
          
         objapp =CreatePepSanctionApp(CompanyId,strAccountId,strAppId,objPepSanction.totalmatches);      
         strPepAppId = objapp.Id;
         //objapp.saf_CompanyID__c = CompanyId;
         //objapp.saf_application__c = strAppId;
         //objapp.saf_TotalMatches__c = objPepSanction.totalMatches;
         //insert objapp;
      }
     //else
     //{strPepAppId = objapp.Id;}
     
      List<saf_Pep_addresses__c> lstadd;
      List<saf_pep_sanction_info__c> lstinfo = new List<saf_pep_sanction_info__c>();   
    if(objPepSanction !=null && objPepSanction.possibleMatches !=null)
    {
        Integer Intabove90 = 0;
     for(cls_possibleMatches objpm:objPepSanction.possibleMatches)    
         {
            saf_pep_sanction_info__c objinfo = new saf_pep_sanction_info__c(); 
            if(objpm.matchScore >=settings.PEPSanctionMatchscore__c) {Intabove90 = Intabove90 +1 ;
            objduePep.noofmatchscoreabove90 = true;}
               
            objinfo.saf_MatchScore__c  = objpm.matchScore;
            objinfo.saf_Type__c  = objpm.type; 
            objinfo.saf_Customer__c = strAccountId;
            objinfo.saf_application__c = strAppId;
            objinfo.saf_pep_sanction_app__c = strPepAppId ;
            
            
            
           // saf_Pep_sanction_buisness__c objbuis = new saf_Pep_sanction_buisness__c();
            objinfo.saf_LookupId__c = objpm.business.lookupId;
            objinfo.saf_Website__c = objpm.business.website;
            objinfo.saf_Fax__c = objpm.business.fax;
            objinfo.saf_Name__c = objpm.business.name;
            objinfo.saf_business__c = objpm.business.name;
            objinfo.Saf_IsActive__c  = True;
            lstinfo.add(objinfo);
          } 
           system.debug('Intabove90 :' +Intabove90 );    
          if(lstinfo.size() >0)
          {
           if(Intabove90 == 0)
           {
              insert lstinfo[0];
           }
           else 
           {
              insert lstinfo;
           }
          } 
          List<saf_Pep_globalDatasets__c> lstglobal = new List<saf_Pep_globalDatasets__c>();  
          List<saf_Pep_documents__c> lstdoc = new List<saf_Pep_documents__c>();
          List<saf_Pep_categories__c> lstcat = new List<saf_Pep_categories__c>();
          List<saf_Pep_sanctions__c> lstsanc = new List<saf_Pep_sanctions__c>();
          List<saf_Pep_notes__c> lstnotes = new List<saf_Pep_notes__c>();
          list<saf_Pep_linkedBuisnesses__c> lstlinked = new List<saf_Pep_linkedBuisnesses__c>();
          List<saf_Pep_Relatednames__c> lstrname = new List<saf_Pep_Relatednames__c>();
         for(cls_possibleMatches objpm:objPepSanction.possibleMatches)    
          {
            for(saf_pep_sanction_info__c objinfo:lstinfo)    
           {
           if(objinfo.saf_business__c == objpm.business.name && objpm.matchScore >=settings.PEPSanctionMatchscore__c)
            {
            
            if(objpm.business.globalDatasets != null)
            {
             saf_Pep_globalDatasets__c objglobal = new saf_Pep_globalDatasets__c();
             objglobal.saf_Peps__c = objpm.business.globalDatasets.peps;
             objglobal.saf_pep_sanction_info__c = objinfo.Id;
            
             objglobal.saf_SanctionsCurrent__c= objpm.business.globalDatasets.sanctionsCurrent;
             objglobal.saf_SanctionsPrevious__c=  objpm.business.globalDatasets.sanctionsPrevious;
             objglobal.saf_LawEnforcement__c = objpm.business.globalDatasets.lawEnforcement;
             objglobal.saf_FinancialRegulatorPenalties__c =  objpm.business.globalDatasets.financialRegulatorPenalties;
             objglobal.saf_DisqualifiedDirectors__c = objpm.business.globalDatasets.disqualifiedDirectors;
             objglobal.saf_Insolvencies__c = objpm.business.globalDatasets.insolvencies;
             objglobal.saf_AdverseMedia__c = objpm.business.globalDatasets.adverseMedia;
           /* objglobal .saf_Fax__c = objpm.business.fax;
            objglobal .saf_Name__c = objpm.business.name;
            objglobal .saf_business__c = objpm.business.name;
            objglobal .Saf_IsActive__c  = True;*/
           //insert objglobal;
            lstglobal.add(objglobal);
            }
            
            lstadd = new List<saf_Pep_addresses__c>();
            for(cls_addresses objaddr:objpm.business.addresses)    
            {
                saf_Pep_addresses__c objadd = new saf_Pep_addresses__c();
                objadd.saf_FullAddress__c = objaddr.fullAddress;
                objadd.saf_CountryCode__c = objaddr.countryCode;
                objadd.saf_Address1__c    = objaddr.sourceAddress.address1;
                objadd.saf_Address2__c    = objaddr.sourceAddress.address2;
                objadd.saf_Address3__c    = objaddr.sourceAddress.address3;
                objadd.saf_Address4__c    = objaddr.sourceAddress.address4;
                objadd.saf_City__c        = objaddr.sourceAddress.city;
                objadd.SAF_County__c      = objaddr.sourceAddress.county;
                objadd.saf_PostCode__c    = objaddr.sourceAddress.postcode;
                objadd.saf_Country__c     = objaddr.sourceAddress.country;
                 objadd.saf_pep_sanction_info__c = objinfo.Id;
                 lstadd.add(objadd);
            }
             
             
            //insert lstadd;
            
            for(cls_documents objdocs:objpm.business.documents)    
            {
                saf_Pep_documents__c objdoc = new saf_Pep_documents__c();
                objdoc.saf_OriginalUrl__c   = objdocs.originalUrl;
                objdoc.saf_DateCollected__c = objdocs.dateCollected;
                objdoc.saf_DocumentUrl__c   = objdocs.documentUrl;
                objdoc.saf_pep_sanction_info__c = objinfo.Id;
                
               if(objdocs.categories != null)
               {
                for(cls_categories objpepcat: objdocs.categories)    
                    { 
                        saf_Pep_categories__c objcat = new saf_Pep_categories__c();
                        objcat.SAF_Name__c = objpepcat.name;
                        objcat.saf_categories__c = objpepcat.name;
                        objcat.saf_pep_sanction_info__c = objinfo.Id;
                        lstcat.add(objcat);
                    }
                } lstdoc.add(objdoc);
            }
              //insert lstdoc;
           
            for(cls_sanctions objsanc:objpm.business.sanctions)    
            {
                saf_Pep_sanctions__c objsan = new saf_Pep_sanctions__c();
                objsan.Description__c = objsanc.description;
                objsan.IsCurrent__c = objsanc.isCurrent;
                 objsan.saf_pep_sanction_info__c = objinfo.Id;
                lstsanc.add(objsan);
            }
             // insert lstsanc;
              
           
            for(cls_notes objnotes:objpm.business.notes)    
            {
                saf_Pep_notes__c objnote = new saf_Pep_notes__c();
                objnote.SAF_Text__c = objnotes.text;
                objnote.SAF_Source__c = objnotes.source;
                 objnote.saf_pep_sanction_info__c = objinfo.Id;
                if(lstnotes.size() <= 10) {lstnotes.add(objnote);} 
            }
            //insert lstnotes;
            
           
            for(cls_linkedBusinesses objlinkedBuis:objpm.business.linkedBusinesses)    
            {
                saf_Pep_linkedBuisnesses__c objlinkbuis = new saf_Pep_linkedBuisnesses__c();
                objlinkbuis.SAF_LookUpID__c = objlinkedBuis.lookupId;
                objlinkbuis.SAF_Name__c    = objlinkedBuis.name;
                objlinkbuis.SAF_Association__c= objlinkedBuis.association;
                 objlinkbuis.saf_pep_sanction_info__c = objinfo.Id;
                lstlinked.add(objlinkbuis);
            }
            // insert lstlinked;
           
             for(cls_relatedNames objrn:objpm.business.relatedNames)    
            {
                saf_Pep_Relatednames__c objrname = new saf_Pep_Relatednames__c();
                objrname.SAF_Name__c = objrn.name;
                 objrname.saf_pep_sanction_info__c = objinfo.Id;
                 lstrname.add(objrname);
            }
             // insert lstrname;
            }
           }
         }
         //system.debug('lstadd:' +lstadd.size());   
        //insert lstinfo;
       // insert lstadd;
       if(Intabove90 > 0)
       {
            Database.SaveResult[] sr =  Database.insert(lstglobal, true); 
            Database.SaveResult[] sr1 =  Database.insert(lstadd, true); 
            Database.SaveResult[] sr2 =  Database.insert(lstdoc , true); 
            Database.SaveResult[] sr3 =  Database.insert(lstsanc , true); 
            Database.SaveResult[] sr4 =  Database.insert(lstnotes , true); 
            Database.SaveResult[] sr5 =  Database.insert(lstlinked , true);
            Database.SaveResult[] sr6 =  Database.insert(lstrname, true);
            Database.SaveResult[] sr7 =  Database.insert(lstcat , true); 
        } 
        else 
        {//please save only the first pepinfo record here.
        }  
        objduePep.AllpepInfo =lstinfo;
        objduepep.Alladdr =  lstadd;
        objduePep.strPepAppId = strPepAppId;
        objduePep.totalmatches = objPepSanction.totalMatches;
      }
     
      return objduePep;
    
   }
   //Individual code added here
   public static saf_duedil.cls_PepSanction CreatePepSanctionContact(string CompanyId,string strAccountId,string strAppId,contact cont,string strPepAppId)
   {
     saf_duedil.cls_PepSanction objduePep = new saf_duedil.cls_PepSanction();
      SAF_PepSanction objPepSanction = SAF_Duedil.GetPepSanctionIndividual(cont);

       system.debug('objPepSanction :' +objPepSanction );     
        saf_pep_sanction_app__c objapp = new saf_pep_sanction_app__c(); 
     if((strPepAppId == null || strPepAppId == '') && objPepSanction !=null)
     {
          
         objapp =CreatePepSanctionAppIndividual(CompanyId,strAccountId,cont,strAppId,objPepSanction.totalmatches);      
         strPepAppId = objapp.Id;
         //objapp.saf_CompanyID__c = CompanyId;
         //objapp.saf_application__c = strAppId;
         //objapp.saf_TotalMatches__c = objPepSanction.totalMatches;
         //insert objapp;
      }
     system.debug('strPepAppId :' +strPepAppId );    
      List<saf_pep_sanction_Individual__c> lstIndinfo = new List<saf_pep_sanction_Individual__c>();  
     // List<saf_pep_sanction_info__c> lstinfo = new List<saf_pep_sanction_info__c>();  
   if(objPepSanction !=null && objPepSanction.possibleMatches !=null)
    {   Integer Intabove90 = 0;
       for(cls_possibleMatches objpmind:objPepSanction.possibleMatches)    
         {
           
           /*  saf_pep_sanction_info__c objinfo = new saf_pep_sanction_info__c(); 
            
            objinfo.saf_MatchScore__c  = objpmind.matchScore;
            objinfo.saf_Type__c  = objpmind.type; 
            objinfo.saf_Customer__c = strAccountId;
            objinfo.saf_application__c = strAppId;
            objinfo.saf_pep_sanction_app__c = strPepAppId ;
            
            lstinfo.add(objinfo);*/
            
            
            saf_pep_sanction_Individual__c objind = new saf_pep_sanction_Individual__c();  
             if(objpmind.matchScore >=settings.PEPSanctionMatchscore_cont__c) {
                 Intabove90 = Intabove90 +1;
                 objduePep.noofmatchscoreabove90con = true;
             
             }
              // system.debug('Intabove90 :' +Intabove90 );      
            objind.saf_MatchScore__c  = objpmind.matchScore;
            objind.saf_Type__c  = objpmind.type; 
            objind.SAF_Contact__c = cont.Id;
           // objind.saf_Customer__c = strAccountId;
            objind.saf_application__c = strAppId;
            objind.saf_pep_sanction_app__c =strPepAppId; 
            //lstinfo.add(objinfo);
            // objind.saf_pep_sanction_info__c = objinfo.Id;
           
            objind.saf_lookupId__c = objpmind.individual.lookupId;
            objind.saf_Honorific__c = objpmind.individual.honorific;
            objind.Saf_AlternativeHonorific__c = objpmind.individual.alternativeHonorific;
            objind.Saf_FirstName__c = objpmind.individual.firstName;
            objind.saf_MiddleName__c = objpmind.individual.middleName;
            objind.saf_LastName__c = objpmind.individual.lastName;
            objind.Saf_IsActive__c  = True;
           /* objbuis.saf_Website__c = objpmind.individual.website;
            objbuis.saf_Fax__c = objpmind.business.fax;
            objbuis.saf_Name__c = objpmind.business.name; */
               
            lstIndinfo.add(objind);
          }
         if(lstIndinfo.size() >0)
          {
           if(Intabove90 == 0)
           {
              insert lstIndinfo[0];
              //insert lstinfo[0];
           }
           else 
           {
              insert lstIndinfo;
              //insert lstinfo;
           }
          } 
         List<saf_Pep_globalDatasets__c> lstglobal = new List<saf_Pep_globalDatasets__c>();  
         List<saf_Pep_documents__c> lstidoc = new List<saf_Pep_documents__c>();
         List<saf_Pep_categories__c> lstcat = new List<saf_Pep_categories__c>();
         List<saf_Pep_sanctions__c> lstisanc = new List<saf_Pep_sanctions__c>();
         List<saf_Pep_notes__c> lstinotes = new List<saf_Pep_notes__c>();
         list<saf_Pep_linkedBuisnesses__c> lstlinked = new List<saf_Pep_linkedBuisnesses__c>();
         List<saf_Pep_Relatednames__c> lstrname = new List<saf_Pep_Relatednames__c>();          
         List<saf_pep_nationalities__c> lstnl = new List<saf_pep_nationalities__c>();
         List<saf_pep_aliases__c> lstal = new List<saf_pep_aliases__c>();
         List<saf_Pep_addresses__c> lstaddr = new List<saf_Pep_addresses__c>();
         
         List<saf_Pep_linkedIndividuals__c> lstlid = new List<saf_Pep_linkedIndividuals__c>();
         List<saf_pep_PoliticalPositions__c> lstpol = new List<saf_pep_PoliticalPositions__c>();

  for(cls_possibleMatches objpmind:objPepSanction.possibleMatches)    
          {
            for(saf_pep_sanction_Individual__c objinfo:lstIndinfo)    
           {
           if(objinfo.Saf_FirstName__c == objpmind.individual.firstname && objpmind.matchScore >=settings.PEPSanctionMatchscore_cont__c)
            {
            if(objpmind.individual.nationalities != null)
            {         
           Integer intnationalities = 0;
           for(cls_nationalities objnl:objpmind.individual.nationalities)  
            {
                saf_pep_nationalities__c objmnl = new saf_pep_nationalities__c();
                objmnl.saf_Demonym__c = objnl.demonym;
                objmnl.saf_pep_sanction_Individual__c = objinfo.Id;
                if(intnationalities <=25) {lstnl.add(objmnl);}
                intnationalities = intnationalities+1;
            }
             //system.debug('lstnl :' +lstnl );     
          }
              Integer intglobal =0;
              if(objpmind.individual.globalDatasets != null)
            {
             saf_Pep_globalDatasets__c objglobal = new saf_Pep_globalDatasets__c();
             objglobal.saf_Peps__c = objpmind.individual.globalDatasets.peps;
             objglobal.saf_pep_sanction_Individual__c = objinfo.Id;
            
             objglobal.saf_SanctionsCurrent__c= objpmind.individual.globalDatasets.sanctionsCurrent;
             objglobal.saf_SanctionsPrevious__c=  objpmind.individual.globalDatasets.sanctionsPrevious;
             objglobal.saf_LawEnforcement__c = objpmind.individual.globalDatasets.lawEnforcement;
             objglobal.saf_FinancialRegulatorPenalties__c =  objpmind.individual.globalDatasets.financialRegulatorPenalties;
             objglobal.saf_DisqualifiedDirectors__c = objpmind.individual.globalDatasets.disqualifiedDirectors;
             objglobal.saf_Insolvencies__c = objpmind.individual.globalDatasets.insolvencies;
             objglobal.saf_AdverseMedia__c = objpmind.individual.globalDatasets.adverseMedia;
           /* objglobal .saf_Fax__c = objpm.business.fax;
            objglobal .saf_Name__c = objpm.business.name;
            objglobal .saf_business__c = objpm.business.name;
            objglobal .Saf_IsActive__c  = True;*/
           //insert objglobal;
           intglobal = intglobal+1;
                if(intglobal <=25) lstglobal.add(objglobal);
           
            }
            
            for(cls_aliases objals:objpmind.individual.aliases)  
            {
                saf_pep_aliases__c objal = new saf_pep_aliases__c();
                objal.SAF_Honorific__c = objals.honorific;
                objal.SAF_AlternativeHonorific__c = objals.alternativeHonorific;
                objal.SAF_FirstName__c = objals.firstName;
                objal.SAF_MiddleName__c = objals.middleName;
                objal.SAF_LastName__c = objals.lastName;
                objal.saf_pep_sanction_Individual__c = objinfo.Id;
                lstal.add(objal);
            }
           
             Integer intaddresses = 0;
             for(cls_addresses objaddr:objpmind.individual.addresses)  
            {
                saf_Pep_addresses__c objaddrs = new saf_Pep_addresses__c();
                objaddrs.saf_FullAddress__c = objaddr.fullAddress;
                objaddrs.saf_CountryCode__c = objaddr.countryCode;
                objaddrs.saf_Address1__c    = objaddr.sourceAddress.address1;
                objaddrs.saf_Address2__c    = objaddr.sourceAddress.address2;
                objaddrs.saf_Address3__c    = objaddr.sourceAddress.address3;
                objaddrs.saf_Address4__c    = objaddr.sourceAddress.address4;
                objaddrs.saf_City__c        = objaddr.sourceAddress.city;
                objaddrs.SAF_County__c      = objaddr.sourceAddress.county;
                objaddrs.saf_PostCode__c    = objaddr.sourceAddress.postcode;
                objaddrs.saf_Country__c     = objaddr.sourceAddress.country;
                objaddrs.saf_pep_sanction_Individual__c = objinfo.Id;
                intaddresses = intaddresses+1;
                if(intaddresses <=25) lstaddr.add(objaddrs);
                 
            }
            //system.debug('lstaddr :' +lstaddr.size() );     
            for(cls_documents objdocs:objpmind.individual.documents)    
            {
                saf_Pep_documents__c objidoc = new saf_Pep_documents__c();
                objidoc.saf_OriginalUrl__c   = objdocs.originalUrl;
                objidoc.saf_DateCollected__c = objdocs.dateCollected;
                objidoc.saf_DocumentUrl__c   = objdocs.documentUrl;
                objidoc.saf_pep_sanction_Individual__c = objinfo.Id;
                lstidoc.add(objidoc);
            }
            
            for(cls_sanctions objsanc:objpmind.individual.sanctions)    
            {
                saf_Pep_sanctions__c objisanc = new saf_Pep_sanctions__c();
                objisanc.Description__c = objsanc.description;
                objisanc.IsCurrent__c = objsanc.isCurrent;
                objisanc.saf_pep_sanction_Individual__c = objinfo.Id;
                lstisanc.add(objisanc);
            }
          
            for(cls_notes objnotes:objpmind.individual.notes)    
            {
                saf_Pep_notes__c objinote = new saf_Pep_notes__c();
                objinote.SAF_Text__c = objnotes.text;
                objinote.SAF_Source__c = objnotes.source;
                objinote.saf_pep_sanction_Individual__c = objinfo.Id;
                lstinotes.add(objinote);
            }
          
            for(cls_linkedBusinesses objlinkedBuis:objpmind.individual.linkedBusinesses)    
            {
                saf_Pep_linkedBuisnesses__c objilinkbuis = new saf_Pep_linkedBuisnesses__c();
                objilinkbuis.SAF_LookUpID__c = objlinkedBuis.lookupId;
                objilinkbuis.SAF_Name__c    = objlinkedBuis.name;
                objilinkbuis.SAF_Association__c= objlinkedBuis.association;
                objilinkbuis.saf_pep_sanction_Individual__c = objinfo.Id;
                lstlinked.add(objilinkbuis);
            }
          
            for(cls_linkedIndividuals objli:objpmind.individual.linkedIndividuals)    
            {
                saf_Pep_linkedIndividuals__c objlin = new saf_Pep_linkedIndividuals__c();
                objlin.SAF_LookUpID__c = objli.lookupId;
                objlin.SAF_Name__c = objli.name;
                objlin.SAF_Position__c = objli.position;
                objlin.saf_pep_sanction_Individual__c = objinfo.Id;
                lstlid.add(objlin);
            }
            
            for(cls_politicalPositions objpp:objpmind.individual.politicalPositions)    
            {
                saf_pep_PoliticalPositions__c objpol = new saf_pep_PoliticalPositions__c();
                //objpol.Country__c = objpp.country;
                objpol.Description__c = objpp.description;
                objpol.EndDate__c = objpp.endDate;
                objpol.StartDate__c = objpp.startDate;
                objpol.saf_pep_sanction_Individual__c = objinfo.Id;
                lstpol.add(objpol);
            }
         }
        }
}        system.debug('Intabove90 :' +Intabove90 );
       if(Intabove90 > 0)
       {
            Database.SaveResult[] sr =  Database.insert(lstglobal, true); 
            Database.SaveResult[] sr1 =  Database.insert(lstaddr, true); 
            Database.SaveResult[] sr2 =  Database.insert(lstidoc , true); 
            Database.SaveResult[] sr3 =  Database.insert(lstnl , true); 
            Database.SaveResult[] sr4 =  Database.insert(lstal , true); 
            Database.SaveResult[] sr5 =  Database.insert(lstisanc , true);
            Database.SaveResult[] sr6 =  Database.insert(lstinotes, true);
            Database.SaveResult[] sr7 =  Database.insert(lstlinked , true); 
            Database.SaveResult[] sr8 =  Database.insert(lstlid , true); 
            Database.SaveResult[] sr9 =  Database.insert(lstcat , true); 
            Database.SaveResult[] sr10 =  Database.insert(lstpol , true); 
            Database.SaveResult[] sr11 =  Database.insert(lstrname , true);
             system.debug('sr1 :' +sr1);     
        } 
        else 
        {//please save only the first pepinfo record here.
            /*Database.SaveResult[] sr =  Database.insert(lstglobal, true); 
            Database.SaveResult[] sr1 =  Database.insert(lstaddr, true); 
            Database.SaveResult[] sr2 =  Database.insert(lstidoc , true); 
            Database.SaveResult[] sr3 =  Database.insert(lstnl , true); 
            Database.SaveResult[] sr4 =  Database.insert(lstal , true); 
            Database.SaveResult[] sr5 =  Database.insert(lstisanc , true);
            Database.SaveResult[] sr6 =  Database.insert(lstinotes, true);
            Database.SaveResult[] sr7 =  Database.insert(lstlinked , true); 
            Database.SaveResult[] sr8 =  Database.insert(lstlid , true); 
            Database.SaveResult[] sr9 =  Database.insert(lstcat , true); 
            Database.SaveResult[] sr10 =  Database.insert(lstpol , true); 
            Database.SaveResult[] sr11 =  Database.insert(lstrname , true); */
        }  
 
       //objduePep.AllpepInfo =lstinfo;
        objduePep.Allind =lstIndinfo;
        //objduepep.Alladdr =  lstadd;
         objduePep.strPepAppId = strPepAppId;
        objduePep.totalmatches = objPepSanction.totalMatches;
        }
     
      return objduePep;
    
   }
    Public class cls_criterias {
    public  cls_criteria criteria;

       }
    Public class cls_criteriasInd {
    public  cls_criteriaIndividual criteria;

       }
    Public class cls_criteria{
        public cls_duedilCompany duedilCompany;
    }
    Public class cls_criteriaIndividual {
        public cls_anyIndividual anyIndividual;
    }
    Public class cls_duedilCompany {
        public String companyId;    //06999618
        public String countryCode;  //gb
    }
    Public class cls_anyIndividual {
        public String firstName;    //string
        public String middleName;   //string
        public String lastName; //string
        public cls_dateOfBirth dateOfBirth;
        public String address;  //string
        public String city; //string
        public String postcode; //string
        public String countryCode;  //string
    }
    
    Public class cls_possibleMatches {
        public Integer matchScore;  //95
        public String type; //business
        public cls_business business;
        public cls_individual individual;// Added extra
       
    }
    Public class cls_business {
        public String lookupId; //XX-123
        public String name; //Dunedin Underwriters
        public String website;
        public String telephone;
        public String fax;
        public cls_addresses[] addresses;
        public cls_globalDatasets globalDatasets;
        public cls_documents[] documents;
        public cls_sanctions[] sanctions;
        public cls_notes[] notes;
        public cls_linkedBusinesses[] linkedBusinesses;
        public cls_linkedIndividuals[] linkedIndividuals;
        public cls_relatedNames[] relatedNames;
    }

    Public class cls_addresses {
        public String fullAddress;  //United Kingdom
        public String countryCode;  //GB
        public cls_sourceAddress sourceAddress;
    }
    Public class cls_sourceAddress {
        public String address1; //
        public String address2; //
        public String address3; //
        public String address4; //
        public String city; //
        public String county;   //
        public String postcode; //
        public String country;  //United Kingdom
    }
    Public class cls_globalDatasets {
        public boolean peps;
        public boolean sanctionsCurrent;
        public boolean sanctionsPrevious;
        public boolean lawEnforcement;
        public boolean financialRegulatorPenalties;
        public boolean disqualifiedDirectors;
        public boolean insolvencies;
        public boolean adverseMedia;
    }
    Public class cls_documents {
        public String documentId;   //383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d381664454161460e776861024a6f4808777e045c437969603f
        public String originalUrl;  //http://www.gazettes-online.co.uk/NoticeView.asp
        public Date dateCollected;    //2006-03-20
        public String documentUrl;  //https://duedil.io/documents/peps-and-sanctions/383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d381664454161460e776861024a6f4808777e045c437969603f
        public cls_categories[] categories;
    }
    Public class cls_categories {
        public String name; //Insolvent
    }
    Public class cls_sanctions {
     public cls_type type;
     public String description;
    public Boolean isCurrent; //true
    }
    Public class cls_type {
     public String description; //Insolvent
    }
    Public class cls_notes {
     public String text; //Insolvent
     public String source; //Insolvent
    }
    Public class cls_linkedBusinesses {
     public String lookupId; //Insolvent
     public String name; //Insolvent
     public String association; //Insolvent
   
    }
    Public class cls_linkedIndividuals {
     public String lookupId; //Insolvent
     public String name; //Insolvent
     public String position; //Insolvent
    }
    Public class cls_relatedNames {
    public String name;
    }
    public static SAF_PepSanction parse(String json){
        return (SAF_PepSanction) System.JSON.deserialize(json, SAF_PepSanction.class);
    } 

    Public class cls_individual {
        public String lookupId; //DD-123
        public String honorific;    //Mr
        public String alternativeHonorific;
        public String firstName;    //James
        public String middleName;   //
        public String lastName; //Carter
        public cls_nationalities[] nationalities;
        public String gender;   //Male
        public String imageUrl;
        public String pepLevel;
        public cls_dateOfBirth dateOfBirth;
        public boolean isDeceased;
        public cls_dateOfDeath dateOfDeath;
        public cls_aliases[] aliases;
        public String telephone;    //
        public String fax;  //
        public String mobile;   //
        public String email;    //
        public cls_addresses[] addresses;
        public cls_globalDatasets globalDatasets;
        public cls_documents[] documents;
        public cls_sanctions[] sanctions;
        public cls_notes[] notes;
        public cls_linkedBusinesses[] linkedBusinesses;
        public cls_linkedIndividuals[] linkedIndividuals;
        public cls_politicalPositions[] politicalPositions;
    }
  
    Public class cls_nationalities {
        public String demonym;  //American
    }
  
    Public class cls_dateOfBirth {
     public Integer year;  
     public Integer month; 
     public Integer day;
    }
    Public class cls_dateOfDeath {
     public Integer year;  
     public Integer month; 
     public Integer day;
    }
    Public class cls_country {
     public String Name;

    }
    Public class cls_aliases {
     public String honorific  ;
    public String alternativeHonorific;   
    public String firstName;  
    public String middleName; 
    public String lastName;

    }  
    
   Public class cls_politicalPositions {
    public String description;
    public String startDate;   
    public String endDate;  
    public cls_country country;
    }

}