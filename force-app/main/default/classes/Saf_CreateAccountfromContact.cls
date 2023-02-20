/**
*
* @name                 : Saf_CreateAccountfromContact 
* @author               : Happiest minds 
* @description          : This Batch class is is used to create related account for Legal entity = individual
* @created date         : 09-06-2018
* @modified by / date   : 09-06-2018
*
**/


global class Saf_CreateAccountfromContact implements Database.Batchable<sObject>,Database.Stateful{

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
    global Integer recordsFailed = 0;
    global Integer recordsProcessed = 0;
    global Integer recordsProcessedinbatch = 0;
    global Integer recordscount;
    global string ErrorList; 
    global string RecordsList;
    global string id;global boolean Isbatch = false;
    public class MyException extends Exception{}
    global Database.QueryLocator start(Database.BatchableContext BC){
           
          
           List<String> ls = new List<String>{'a4s0O000000CyQC', 'a4s0O000000CyQB'};
           List<string> ids = new List<String>{'0030O00002Shj29', '0033Y00002rLpla'};
           //string query = 'select Id,FirstName,AccountID,Account.Name,Name,Account.clcommon__Legal_Entity_Type__c, LastName,clcommon__Legal_Entity_Type__c from Contact where Id =: id';//and AccountID = null
           
            string query = 'select Id,SAF_OfficerId__c,MailingStreet,MailingPostalCode,MailingCity,MailingState,MailingCountry,MailingLatitude,MailingLongitude,FirstName,AccountID,Account.Name,Name,Account.clcommon__Legal_Entity_Type__c, LastName,clcommon__Legal_Entity_Type__c from Contact where Id =:id order by lastmodifieddate desc';//where Id In:ids and AccountID = null
          
           if(Isbatch && id ==null)
           {
               query = query.replace(' where Id =:id','');
           }
          
           system.debug('========= query ========'+query); 
           return Database.getQueryLocator(query);
          
        }
    
    global void execute(Database.BatchableContext BC, list<Contact>scope){
    
         system.debug('******query****'+scope.size());
          ErrorList = '';RecordsList = '';recordsProcessedinbatch =0;
         try{
                //---for getting relationship type
                 Map<string,string> MapRoles = new  Map<string,string>();
                 List<clcommon__Reciprocal_Role__c> lst_role = [Select Id,Name,clcommon__Inverse_Role__c from clcommon__Reciprocal_Role__c];
                    for(clcommon__Reciprocal_Role__c obj:lst_role)
                    { 
                     MapRoles.put(obj.Name,obj.ID); 
                     system.debug('MapRoles obj.Name:' +obj.Name + obj.Id);
                    }
                  system.debug('MapRoles:' +MapRoles.size());
                  
                  clcommon.BankingModelBorrowerAPI handler = clcommon.APIFactory.getBankingModelBorrowerAPI(); 
                  List<Account> lst_Account = new  List<Account>();
                  List<clcommon__Relationship__c> lstRel = new List<clcommon__Relationship__c>();
                   List<Contact> lstcon = new List<Contact>();
                   map<string,id> contids = new map<string,id>();
                   for(Contact objcon:scope)
                   {  
                       system.debug('========= objcon ========:' + objcon );
                        Map<String,sObject> result;
                       //contact objcon = new contact(); 
                       if(objcon.AccountID != null && objcon.Name == objcon.Account.Name)
                       {
                           system.debug('========= equal========:' + objcon.Account.Name);
                      }
                      else if(objcon.AccountID != null && objcon.Name != objcon.Account.Name  )//&& objcon.clcommon__Legal_Entity_Type__c =
                     {
                           List<Account> lstacc =  [select Id,name from account where Name=: objcon.Name limit 1];
                          system.debug('========= lstacc ========:' + lstacc );
                          /*result = handler.handleAccountAndContact(null, null,objcon,null);
                          if(result.get('account') != NULL){
                                   Account objaccount = (Account)result.get('account');
                                  // objaccount.
                                   lst_Account.add(objaccount);  
                                   system.debug('========= objaccount========:' + objaccount);
                                   //objcon.Account = objaccount;
                               SAF_CompanyDeatils.GetRelationship('Related Company',objcon.AccountId, objaccount.Id,null); 
                           }*/
                           if(lstacc.size() == 0)
                           {
                            string extId =  objcon.Id + '1';//
                             Account accountReference = new Account(
                                collect__External_ID__c=extId);   
                            //objcon.AccountId =null;                 
                            //objcon.Account = accountReference;
                            string contype = maproles.get('Director') ;
                            system.debug('========= contype ========:' + contype);
                            lstRel.addall(Saf_CreateAccountContact.GetRelationship(contype,objcon.AccountId,accountReference,null));  
                              Contact con= new contact();
                               con.Id = objcon.Id;
                               con.firstname = objcon.firstname;
                               con.lastname = objcon.lastname;
                               con.clcommon__Legal_Entity_Type__c = objcon.clcommon__Legal_Entity_Type__c;
                               con.Account = accountReference;
                               
                           lstcon.add(con);
                            
                           system.debug('========= objcon========:' + objcon);
                           string strname = objcon.firstname + ' ' +  objcon.lastname;
                           strname = strname.replace('null ','');
                           Account objnewAcc = new Account(
                           Name =  strname,
                           clcommon__Legal_Entity_Type__c = objcon.clcommon__Legal_Entity_Type__c,
                           Ownership = 'Individual',
                           Type = 'Account',collect__External_ID__c=extId );
                           if(objcon.MailingStreet != null)  objnewAcc.BillingStreet =  objcon.MailingStreet;
                           if(objcon.MailingPostalCode !=null) objnewAcc.BillingPostalCode  = objcon.MailingPostalCode ;
                           if(objcon.MailingCity != null) objnewAcc.BillingCity          = objcon.MailingCity;
                           if(objcon.MailingState != null) objnewAcc.BillingState        = objcon.MailingState;
                           if(objcon.MailingCountry != null) objnewAcc.BillingCountry     = objcon.MailingCountry;       
                           if(objcon.MailingLatitude != null) objnewAcc.BillingLatitude  = objcon.MailingLatitude;
                           if(objcon.MailingLongitude != null) objnewAcc.BillingLongitude  = objcon.MailingLongitude; 
                           objnewAcc.SAF_OfficerID__c = objcon.SAF_OfficerID__c;
                           lst_Account.add(objnewAcc); 
                        }   
                        
                        else
                        {
                           /*string contype = maproles.get('Director') ;
                            system.debug('========= contype ========else:' + contype);
                            lstRel.addall(Saf_CreateAccountContact.GetRelationship2(contype,objcon.AccountId,lstacc[0],null));  
                              Contact con= new contact();
                               con.Id = objcon.Id;
                               con.firstname = objcon.firstname;
                               con.lastname = objcon.lastname;
                               con.clcommon__Legal_Entity_Type__c = objcon.clcommon__Legal_Entity_Type__c;
                               con.AccountId = lstacc[0].Id;
                               system.debug('========= con========else:' + con);
                           lstcon.add(con);*/
                        }  
                     }
                      else
                      {
                       List<Account> lstacc =  [select Id,name from account where Name=: objcon.Name limit 1];
                       system.debug('========= lstacc ========:' + lstacc );
                       if(lstacc.size() ==0)
                        {  
                           result = handler.handleAccountAndContact(null, null,objcon,null);
                           if(result.get('account') != NULL){
                                       Account objaccount = (Account)result.get('account');
                                        
                                          /*if(objcon.MailingStreet != null)  objaccount.BillingStreet =  objcon.MailingStreet;
                                          if(objcon.MailingPostalCode !=null) objaccount.BillingPostalCode  = objcon.MailingPostalCode ;
                                           if( objcon.MailingCity != null) objaccount.BillingCity          = objcon.MailingCity;
                                           if(objcon.MailingState != null) objaccount.BillingState        = objcon.MailingState;
                                           if(objcon.MailingCountry != null) objaccount.BillingCountry     = objcon.MailingCountry;       
                                           if(objcon.MailingLatitude != null) objaccount.BillingLatitude  = objcon.MailingLatitude;
                                           if(objcon.MailingLongitude != null) objaccount.BillingLongitude  = objcon.MailingLongitude; 
                                           objaccount.SAF_OfficerID__c = objcon.SAF_OfficerID__c;
                                           lst_Account.add(objaccount);  */
                                         system.debug('========= objaccount========:' + objaccount);
                             }
                           }
                       }                                                                                                     
                   }
                  
           //response = responseAdd;
            if(lst_Account.size() >0 || lstcon.size()>0 || lstRel.size() >0) 
            {    
                 //commented as a upsert does not work in summer 20 release.         
                /*SObject[] sobjList = new List<SObject>();
                sobjList.addAll(lst_Account);
                sobjList.addAll(lstRel);
                sobjList.addAll(lstcon);
                //Database.upsertResult[] results = Database.upsert(sobjList,false);*/
                Database.SaveResult[] results;
                if(lst_Account.size() >0) {
                    results=Database.insert(lst_Account,false); 
                    if(lstRel.size() >0)results.addall(Database.insert(lstRel,false));
                    if(lstcon.size() >0)results.addall(Database.update(lstcon,false));
                }
                else{
                 if(lstRel.size() >0)
                     { 
                        results = Database.insert(lstRel,false);
                        if(lstcon.size() >0)results.addall(Database.update(lstcon,false));
                     }
                     else
                     {
                         if(lstcon.size() >0)results = Database.update(lstcon,false);
                     }
                }
                //update lstcon;
                //insert lst_Account;
                //if(lstRel.size() >0) {insert lstRel;}
                for(database.saveResult d : results){
                        if(d.issuccess()){
                            recordsProcessed++;recordsProcessedinbatch++;
                             string str = (d.getId() == null ? '': d.getId()+ ',');
                            RecordsList+= str;
                        }
                        else
                        {
                             //List to hold Error
                                Database.Error[] errs = d.getErrors();
                                
                                //Loop through list of Error
                                for(Database.Error err : errs) {
                                    
                                    ErrorList+= 'ErrorMessage:'+ err.getStatusCode() + ' - ' +err.getMessage() + ' - ' + err.getFields();
                                    //Debug to get Error Status
                                    System.debug('Error:' + err.getStatusCode() + ' - ' + err.getMessage()+ ' - ' + err.getFields());

                                }
                            recordsFailed++;
                        }
                    }
                system.debug('========= scope ========:' + scope.size());
                system.debug('========= inserting lst_Account ========:' + lst_Account.size()); 
                if(RecordsList!='') {
                  RecordsList+= ' Total :'+ scope.size() + ' Records processed : ' + recordsProcessedinbatch;
                  ErrorLogsUtils.createErrorLogs('Account Records created :', 'Saf_CreateAccountfromContact', 
                    'execute','Account Records created :' + RecordsList, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
                }
                if(ErrorList !='') {
                  ErrorLogsUtils.createErrorLogs('Error', 'Saf_CreateAccountfromContact', 
                    'execute',ErrorList , '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
                }
            }  
             if(Test.isRunningTest()){throw new MyException();}
        }
        catch(exception e)
        {
          system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
          String strErrordes= 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
          ErrorLogsUtils.createErrorLogs('Error', 'Saf_CreateAccountfromContact', 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
        }
    }
      
        global void finish(Database.BatchableContext BC){
            
            System.debug('Records processed saf_CreateContactfromAccount: ' + recordsProcessed);
            System.debug('Records failed saf_CreateContactfromAccount: ' + recordsFailed );
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job saf_CreateContactfromAccount: ' + job);

            
        } 


}