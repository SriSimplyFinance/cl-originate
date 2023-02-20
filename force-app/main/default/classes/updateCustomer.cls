public Class updateCustomer
{
    public static void createRecords(List<Account> Account)
    {
        String  strCustId;
        String  strSpId;
        String  customerName;
        if(Account.size() >0)
        {
            strCustId = Account[0].Id;
            strSpId = Account[0].SAF_Sharepoint_Folder_ID__c;
            customerName = Account[0].Name;
            createCR(strCustId,strSpId,customerName);
        }
    }
    public static void createCR(String strCustId, String strSpId, String customerName)
    {
        SAF_Document_ChangeRequest__c crSP = new SAF_Document_ChangeRequest__c();
        crSP.SAF_Change_Type__c = 'Customer_Creation';
        crSP.SAF_Customer_ID__c = strCustId;
        crSP.SAF_SharePoint_DocumentID__c = strSpId;
        crSP.SAF_SP_Customer_Name__c = customerName;
        insert crSP;
    }
    public static void changeRecords(List<Account> Account)
    {
        String  strCustId;
        String  strSpId;
        String  customerName;
        if(Account.size() >0)
        {
            strCustId = Account[0].Id;
            strSpId = Account[0].SAF_Sharepoint_Folder_ID__c;
            customerName = Account[0].Name;
            custCR(strCustId,strSpId,customerName);
        }
    }
    public static void custCR(String strCustId, String strSpId, String customerName)
    {
        SAF_Document_ChangeRequest__c crSP1 = new SAF_Document_ChangeRequest__c();
        crSP1.SAF_Change_Type__c = 'Rename_Customer';
        crSP1.SAF_Customer_ID__c = strCustId;
        crSP1.SAF_SharePoint_DocumentID__c = strSpId;
        crSP1.SAF_SP_Customer_Name__c = customerName;
        insert crSP1;
    }
    
     public static void createcontact( List<account> LstAccounts) 
    {
          Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
          List<contact> lstcontact1 = new List<contact>();
         for(Account acc :LstAccounts)
          {
                   Contact objContact1 = new Contact();
                   
                  system.debug('acc.SAF_Connection_Type__c :' + acc.SAF_Connection_Type__c); 
                   
                if(acc.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Sole__c || acc.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Individual__c)
                {
                    system.debug('Inside if loop of new method'+acc.clcommon__Legal_Entity_Type__c);          
                       
                    objContact1.LastName                             = acc.name;//objofficer.person.middlename + ' ' +
                   // objContact1.FirstName                            = objofficer.person.firstName;
                    //objContact1.title                                = 'Director/Officer';
                    //objContact1.Salutation                           = objofficer.person.honorific;
                    string AccountId = acc.Id;
                    objContact1.AccountId                            = (AccountId != null && AccountId.length() >= 15) ? AccountId : null;
                    
                  
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
         } 
         
        if(lstcontact1.size() >0 ) insert lstcontact1;  
      } 
      
   public static void Updatecontact(List<account> LstAccounts) 
    {
          Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
          List<contact> lstupdateCon = new List<contact>();
          Set<Id> accountIds = new Set<Id>();
         for(Account acc :LstAccounts)
          {
                accountIds.add(acc.Id);
                 
          }          
          List<contact> lstcontact1 = [Select Id,LastName,FirstName,MailingStreet,MailingPostalCode, MailingCity,MailingState,MailingCountry,MailingLatitude,MailingLongitude,AccountId,Account.name,Account.clcommon__Legal_Entity_Type__c,Account.BillingStreet,account.BillingPostalCode,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingLatitude,account.BillingLongitude  from Contact where AccountId In:accountIds];
           for(Contact objContact1 :lstcontact1)
              {
                if(objContact1.account.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Sole__c || objContact1.account.clcommon__Legal_Entity_Type__c == SETTINGS.LegalEntity_Individual__c)
                {
                    system.debug('Inside if loop of new method'+objContact1.account.clcommon__Legal_Entity_Type__c);          
                       
                         
                     string straccname = objContact1.account.name;
                     system.debug('******straccname *****'+straccname );
                   if(straccname !=null || straccname !='')
                   {
                        straccname = straccname + ' ';
                        string firstname = straccname.substringbefore(' ');  
                        string lastname = straccname.substringafter(' ');
                       
                        if(lastname == null || lastname == '')
                        { lastname = firstname; firstname = '';}
                      
                         system.debug('******lastname *****'+lastname );
                          system.debug('******firstname *****'+firstname );
                        if(firstname != objContact1.firstname)
                        { 
                          objContact1.FirstName = firstname;  
                           system.debug('******Contact firstName*****'+objContact1.LastName);
                        }
                        if(lastname != objContact1.lastname)
                        { 
                        objContact1.LastName   = lastname;//objofficer.person.middlename + ' ' +
                        system.debug('******Contact Name*****'+objContact1.LastName);
                        }
                        
                   }
                    // objContact1.LastName                             = (objContact1.account.name !=null ? objContact1.account.name : objContact1.LastName);//objofficer.person.middlename + ' ' +
                   
                    //objContact1.title                                = 'Director/Officer';
                    //objContact1.Salutation                           = objofficer.person.honorific;
                   // string AccountId = acc.Id;
                   // objContact1.AccountId                            = (AccountId != null && AccountId.length() >= 15) ? AccountId : null;
                    
                  
                        objContact1.MailingStreet                     =  (objContact1.account.BillingStreet != null ? objContact1.account.BillingStreet : objContact1.MailingStreet);
                        objContact1.MailingPostalCode                  = (objContact1.account.BillingPostalCode!= null ? objContact1.account.BillingPostalCode : objContact1.MailingPostalCode);
                        objContact1.MailingCity                       = (objContact1.account.BillingCity != null ? objContact1.account.BillingCity: objContact1.MailingCity);
                        objContact1.MailingState                     =(objContact1.account.BillingState != null ? objContact1.account.BillingState: objContact1.MailingState);
                        objContact1.MailingCountry                     = (objContact1.account.BillingCountry != null ? objContact1.account.BillingCountry: objContact1.MailingCountry);
                        //if(csinfo.registeredAddress.geolocation != null){
                            objContact1.MailingLatitude                    = (objContact1.account.BillingLatitude!= null ? objContact1.account.BillingLatitude: objContact1.MailingLatitude);
                            objContact1.MailingLongitude                   = (objContact1.account.BillingLongitude!= null ? objContact1.account.BillingLongitude: objContact1.MailingLongitude);
                          //  }
                        
                  
                   
                   
                   lstupdateCon.add(objContact1);
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Acc: '+acc));
                   
             } 
         } 
         
        if(lstupdateCon.size() >0 ) update lstupdateCon;  
      } 
}