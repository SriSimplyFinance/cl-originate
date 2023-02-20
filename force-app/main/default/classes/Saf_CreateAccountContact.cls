Public class Saf_CreateAccountContact
{
     public static List<clcommon__Relationship__c> GetRelationship(string strcontype,string Account,Account AccountRelated,Integer percent)
    {
        try
        {
          
            List<clcommon__Relationship__c> lstRel = new List<clcommon__Relationship__c>();
            clcommon__Relationship__c objRel = new clcommon__Relationship__c();
            objRel.clcommon__Entity__c = Account;
            objRel.clcommon__Ownership_Percentage__c = percent;
            objRel.clcommon__Related_Entity__r = AccountRelated;
            //clcommon__Related_Entity__c = AccountRelated;
             system.debug('strcontype:' + strcontype);
            /*string type = 'a900O000000blzWQAQ';
            if(strcontype == 'UBO') {type = 'a903O000000CamcQAC';}
            else if(strcontype == 'Parent Company') {type= 'a903O000000CamrQAC';}
            else if(strcontype == 'Group company')  {type = 'a903O000000CammQAC';}
            else if(strcontype == 'Related Company')  {type= 'a903O000000CamhQAC';}
            else if(strcontype == 'Director')  {type= 'a903O000000CamXQAS';}
            else if(strcontype == 'Parent Director')  {type= 'a903O000000CamIQAS';}
            else if(strcontype == 'Group Director')  {type= 'a903O000000CamNQAS';}
            else if(strcontype == 'UBO Director')  {type= 'a903O000000CamSQAS';}
            else if(strcontype == 'Related Customer')  {type= 'a903O000000CamwQAC';}
            objRel.clcommon__Relationship__c = type;*/
            objRel.clcommon__Relationship__c = strcontype;
              system.debug('objRel1 :' + objRel + 'objRel.clcommon__Entity__c: ' + objRel.clcommon__Entity__c);
            lstRel.add(objRel);
            if(Account != null && AccountRelated != null)  // && Account != AccountRelated
            {
               
                objRel = new clcommon__Relationship__c();
                objRel.clcommon__Entity__r = AccountRelated;
                objRel.clcommon__Ownership_Percentage__c = percent;
                objRel.clcommon__Related_Entity__c = Account;
                
                /*if(strcontype == 'UBO') { objRel.clcommon__Relationship__c = 'a903O000000CamcQAC';}
                else if(strcontype == 'Parent Company') { objRel.clcommon__Relationship__c= 'a903O000000CamrQAC';}
                else if(strcontype == 'Group company')  { objRel.clcommon__Relationship__c= 'a903O000000CammQAC';}
                else if(strcontype == 'Related Company')  { objRel.clcommon__Relationship__c= 'a903O000000CamhQAC';}
                else if(strcontype == 'Related Customer')  { objRel.clcommon__Relationship__c = 'a903O000000CamwQAC';}
                if(strcontype == 'UBO' || strcontype == 'Parent Company'|| strcontype == 'Group company' || strcontype == 'Related Company'){
                    objRel.clcommon__Relationship__c = 'a903O0000008PoGQAU';
                }
                if(strcontype == 'UBO Director'){
                    objRel.clcommon__Relationship__c = 'a903O000000CamSQAS'; //UBO director 'a903O0000008Po6QAE';
                }
                if(strcontype == 'Parent Director')
                {
                     objRel.clcommon__Relationship__c = 'a903O000000CamIQAS' ; //parent director 'a903O0000008Po1QAE'
                }
                if(strcontype == 'Group Director')
                {
                     objRel.clcommon__Relationship__c = 'a903O000000CamNQAS'; //group director 'a903O0000008PoBQAU';
                } 
                if( strcontype == 'Director')
                {
                    objRel.clcommon__Relationship__c =  'a903O000000CamXQAS'; //director 'a903O0000008PpxQAE';
                }
                if(strcontype == '' || strcontype  == null)
                {
                     objRel.clcommon__Relationship__c = 'a903O000000CamhQAC';
                }*/
                 objRel.clcommon__Relationship__c = strcontype;
                lstRel.add(objRel);
                
               // insert lstRel;
            }
            system.debug('objRel :' + objRel + 'objRel.clcommon__Entity__c: ' + objRel.clcommon__Entity__c);
            return lstRel;
            
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + date.today() + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', 'Saf_CreateAccountContact', 
                'GetRelationship',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');//String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))
            return null;
        }
    }
       public static List<clcommon__Relationship__c> GetRelationship2(string strcontype,string Account,Account AccountRelated,Integer percent)
    {
        try
        {
           
             
            List<clcommon__Relationship__c> lstRel = new List<clcommon__Relationship__c>();
            clcommon__Relationship__c objRel = new clcommon__Relationship__c();
            objRel.clcommon__Entity__c = Account;
            objRel.clcommon__Ownership_Percentage__c = percent;
            //objRel.clcommon__Related_Entity__r = AccountRelated;
            objRel.clcommon__Related_Entity__c = AccountRelated.ID;
            //clcommon__Related_Entity__c = AccountRelated;
             system.debug('strcontype:' + strcontype);
            /*string type = 'a900O000000blzWQAQ';
            if(strcontype == 'UBO') {type = 'a903O000000CamcQAC';}
            else if(strcontype == 'Parent Company') {type= 'a903O000000CamrQAC';}
            else if(strcontype == 'Group company')  {type = 'a903O000000CammQAC';}
            else if(strcontype == 'Related Company')  {type= 'a903O000000CamhQAC';}
            else if(strcontype == 'Director')  {type= 'a903O000000CamXQAS';}
            else if(strcontype == 'Parent Director')  {type= 'a903O000000CamIQAS';}
            else if(strcontype == 'Group Director')  {type= 'a903O000000CamNQAS';}
            else if(strcontype == 'UBO Director')  {type= 'a903O000000CamSQAS';}
            else if(strcontype == 'Related Customer')  {type= 'a903O000000CamwQAC';}
            objRel.clcommon__Relationship__c = type;*/
            objRel.clcommon__Relationship__c = strcontype;
              system.debug('objRel1 :' + objRel + 'objRel.clcommon__Entity__c: ' + objRel.clcommon__Entity__c);
              system.debug('*****1******objRel.clcommon__Related_Entity__r:' + objRel.clcommon__Related_Entity__r);
            lstRel.add(objRel);
            if(Account != null && AccountRelated != null)  // && Account != AccountRelated
            {
               
                objRel = new clcommon__Relationship__c();
                //objRel.clcommon__Entity__r = AccountRelated;
                objRel.clcommon__Entity__c = AccountRelated.Id;
                objRel.clcommon__Ownership_Percentage__c = percent;
                objRel.clcommon__Related_Entity__c = Account;
                
                /*if(strcontype == 'UBO') { objRel.clcommon__Relationship__c = 'a903O000000CamcQAC';}
                else if(strcontype == 'Parent Company') { objRel.clcommon__Relationship__c= 'a903O000000CamrQAC';}
                else if(strcontype == 'Group company')  { objRel.clcommon__Relationship__c= 'a903O000000CammQAC';}
                else if(strcontype == 'Related Company')  { objRel.clcommon__Relationship__c= 'a903O000000CamhQAC';}
                else if(strcontype == 'Related Customer')  { objRel.clcommon__Relationship__c = 'a903O000000CamwQAC';}
                if(strcontype == 'UBO' || strcontype == 'Parent Company'|| strcontype == 'Group company' || strcontype == 'Related Company'){
                    objRel.clcommon__Relationship__c = 'a903O0000008PoGQAU';
                }
                if(strcontype == 'UBO Director'){
                    objRel.clcommon__Relationship__c = 'a903O000000CamSQAS'; //UBO director 'a903O0000008Po6QAE';
                }
                if(strcontype == 'Parent Director')
                {
                     objRel.clcommon__Relationship__c = 'a903O000000CamIQAS' ; //parent director 'a903O0000008Po1QAE'
                }
                if(strcontype == 'Group Director')
                {
                     objRel.clcommon__Relationship__c = 'a903O000000CamNQAS'; //group director 'a903O0000008PoBQAU';
                } 
                if( strcontype == 'Director')
                {
                    objRel.clcommon__Relationship__c =  'a903O000000CamXQAS'; //director 'a903O0000008PpxQAE';
                }
                if(strcontype == '' || strcontype  == null)
                {
                     objRel.clcommon__Relationship__c = 'a903O000000CamhQAC';
                }*/
                 objRel.clcommon__Relationship__c = strcontype;
                lstRel.add(objRel);
                
               // insert lstRel;
            }
            system.debug('objRel :' + objRel + 'objRel.clcommon__Entity__c: ' + objRel.clcommon__Entity__c);
              system.debug('****2****objRel.clcommon__Related_Entity__r:' + objRel.clcommon__Related_Entity__c);
            return lstRel;
            
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + date.today() + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', 'Saf_CreateAccountContact', 
                'GetRelationship2',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');//String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))
            return null;
        }
    }   
     Public static void CreateRelationshipforDuplicateContact(string contactId)
     {
        /**
            **  Creates wrapper account for every contact where 
            **          Acount's Name = Contact Name(FirstName + LastName)
            **          Account's Legal Entity Type = Contact's Legal Entity Type
            **  Updates the wrapper Account only when these attributes change
            **/
            
        string conid = '0030O000025Brrj';
        try{
         Map<string,string> maproles = new Map<string,string>();
             List<clcommon__Reciprocal_Role__c> lst_role = [Select Id,Name,clcommon__Inverse_Role__c from clcommon__Reciprocal_Role__c];
            for(clcommon__Reciprocal_Role__c obj:lst_role)
            { 
                 MapRoles.put(obj.Name,obj.ID); 
                 system.debug('MapRoles obj.Name:' +obj.Name + obj.Id);
            }
        system.debug('MapRoles:' +MapRoles.size());
        List<Contact> lstcontact = [select Id,account.collect__External_ID__c,SAF_OfficerId__c,MailingStreet,MailingPostalCode,MailingCity,MailingState,MailingCountry,MailingLatitude,MailingLongitude,FirstName,AccountID,Account.Name,Name,Account.clcommon__Legal_Entity_Type__c, LastName,clcommon__Legal_Entity_Type__c from Contact where AccountID != null and Id =: contactId]; 
        //List<Contact> lstcontact = [select Id,FirstName,AccountID,Name,LastName,Account.Name,clcommon__Legal_Entity_Type__c from Contact where AccountID != null and Id =: contactId];//0033O00000GzWTw
        List<clcommon__Relationship__c> lstrel = new List<clcommon__Relationship__c>();
           for(Contact objcon :lstcontact)
            {    system.debug('objcon:' +objcon);
                               if(objcon.Account.Name != objcon.name)
                               {
                                      
                                  List<account> lstacc = [select Id,Name, collect__External_ID__c,clcommon__Legal_Entity_Type__c from Account where Name =: objcon.name];
                                  system.debug('=========lstacc[0].Id======:'+ lstacc[0].Id); // dean
                                  system.debug('=========objcon.Account======:'+ objcon.Account); //global
                                  string strcontype = MapRoles.get('Director');
                                 lstrel.addall(Saf_CreateAccountContact.GetRelationship2(strcontype,objcon.AccountId,lstacc[0],null));
                                 objcon.AccountId = lstacc[0].Id;
                                 system.debug('=========lstrel======:'+ lstrel);
                                
                                 insert lstrel;
                                 update objcon;
                                  system.debug('=========objcon======:'+ objcon);
                               }
                           
           } 
           }
           
         catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + date.today() + e.getMessage() + ', Line no: '+e.getLineNumber()+contactId;
            ErrorLogsUtils.createErrorLogs('Failure', 'Saf_CreateAccountContact', 
                'CreateRelationshipforDuplicateContact',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');//String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'))
           
        }
        
      
      }  
 // Public static void CreateAccountContact(genesis__Applications__c app)
// {
        /**
            **  Creates wrapper account for every contact where 
            **          Acount's Name = Contact Name(FirstName + LastName)
            **          Account's Legal Entity Type = Contact's Legal Entity Type
            **  Updates the wrapper Account only when these attributes change
            **/
            
      /*  List<genesis__Applications__c> lst = [select Id,Name, genesis__Account__c,genesis__Contact__c  from genesis__Applications__c where Id =: app.Id ];//'a7F0O000000XswP'
        Account account = [select Id,Name,clcommon__Legal_Entity_Type__c from Account where Id =: lst[0].genesis__Account__c];
        List<clcommon__Party__c> lstcommonparty = [select Id,Name, clcommon__Account__c from clcommon__Party__c where genesis__Application__c =:  app.Id];
        Account relatedaccount = [select Id,Name,clcommon__Legal_Entity_Type__c from Account where Id =: lstcommonparty [0].clcommon__Account__c];
        string conid = '0030O000025Brrj';
        List<Contact> lstcontact = [select Id,FirstName,AccountID,Name,LastName,clcommon__Legal_Entity_Type__c from Contact where Id =: conid ];//0033O00000GzWTw
        Contact contact = new contact();
        if(lstcontact.size() >0) contact = lstcontact[0];
        
        Map<String,sObject> result;
        clcommon.BankingModelBorrowerAPI handler = clcommon.APIFactory.getBankingModelBorrowerAPI(); 
        
        Map<String, sObject> relatedObjects = new Map<String, sObject>();
        //Add relatedObjects if business information is given otherwise pass it as null
        genesis__Business_Information__c bInfo;
        //Add business information here (if not passing relatedObjects as null)
        //relatedObjects.put(CustomSettingsUtil.NS_PREFIX + 'Business_Information__c', bInfo);
        system.debug('account :' + account + 'contact :' +contact + 'relatedacc :' +relatedaccount);
        result = handler.handleAccountAndContact(account, null,lstcontact[0],null);
        //Post account creation action :
        //(modify and run the below code as required by the customer)
        // get  the instance of application for which account is being created
         if(result != NULL && result.size() > 0){
               if(result.get('account') != NULL){
                        account  = (Account)result.get('account');
                        app.genesis__Account__r = account;
                        app.genesis__Account__c = account.Id;
               }
               else {     
                        contact = (Contact)result.get('contact');
                        app.genesis__Account__c = contact.AccountId;
                        app.genesis__Contact__r = contact;
               }
              // update app;
         }
      } */
}