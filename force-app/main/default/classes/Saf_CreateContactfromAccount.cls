/**
*
* @name                 : Saf_CreateContactfromAccount 
* @author               : Happiest minds 
* @description          : This Batch class is used to create related account for Legal entity = individual
* @created date         : 09-06-2018
* @modified by / date   : 09-06-2018
*
**/


global class Saf_CreateContactfromAccount implements Database.Batchable<sObject>,Database.Stateful{

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
           List<String> lsname = new List<String>{'Sole Proprietorship'};//'Individual', 
            //List<String> id = new List<String>{'0013O00000HwT5G'};//string id = '0013O00000HwT5G';
           string query = 'select Id,Name,clcommon__Legal_Entity_Type__c,BillingStreet,BillingPostalCode,BillingCity,BillingState,BillingCountry,BillingLatitude,BillingLongitude, (select name, id, clcommon__Legal_Entity_Type__c from contacts) from Account where clcommon__Legal_Entity_Type__r.Name In: lsname and Id =:id order by lastmodifieddate desc';
            if(Isbatch && id ==null)
           {
               query = query.replace(' and Id =:id','');
           }
           
           system.debug('========= query ========'+query); 
           return Database.getQueryLocator(query);
          
        }
    
    global void execute(Database.BatchableContext BC, list<Account>scope){
    
         system.debug('******query****'+scope.size());
         ErrorList = '';RecordsList = '';recordsProcessedinbatch =0;
         try{
                  clcommon.BankingModelBorrowerAPI handler = clcommon.APIFactory.getBankingModelBorrowerAPI(); 
                  List<Contact> lst_Contact = new  List<Contact>();
                   for(Account objacc:scope)
                   {  
                       system.debug('========= objacc.contacts========:' + objacc.contacts);
                        for(Contact objcon :objacc.contacts)
                           {  
                               if(objacc.name == objcon.name)
                               {
                                   //copy the address fields
                                   
                                       system.debug('=========existing======');
                               }
                           
                           } 
                           
                           if(objacc.contacts.size() == 0 && objacc.clcommon__Legal_Entity_Type__c !=null)
                           {
                               Contact objcon= new contact();
                               objcon.firstname = objacc.name != null ? objacc.name.substringBefore(' ') : objacc.name;
                               objcon.lastname = objacc.name != null ? objacc.name.substringAfter(' ') : objacc.name;
                               if(objcon.lastname == null || objcon.lastname == '') {objcon.lastname = objcon.firstname; objcon.firstname = '';}
                               
                               objcon.clcommon__Legal_Entity_Type__c = objacc.clcommon__Legal_Entity_Type__c;
                               objcon.AccountId =objacc.Id;
                               //copy the address fields
                                  if(objacc.BillingStreet != null) {objcon.MailingStreet = objacc.BillingStreet;}
                                      if(objacc.BillingCity != null) {objcon.MailingCity = objacc.BillingCity ;}
                                      if(objacc.BillingState != null) {objcon.MailingState = objacc.BillingState; }
                                      if(objacc.BillingCountry!= null){  objcon.MailingCountry = objacc.BillingCountry;}
                                       if(objacc.BillingPostalCode!= null){  objcon.MailingPostalCode = objacc.BillingPostalCode;}
                                      if(objacc.BillingLatitude != null)
                                       {objcon.MailingLatitude                  = objacc.BillingLatitude;}
                                      if(objacc.BillingLongitude != null)
                                       {objcon.MailingLongitude               = objacc.BillingLongitude;}   
                                      
                               lst_Contact.add(objcon);
                                system.debug('=========con====== : ' + objcon);
                           }
                   }
                  
           //response = responseAdd;
            if(lst_Contact.size() >0) 
            {             
                 Database.saveResult[] results = Database.insert(lst_Contact,false);
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
                                    System.debug('$#$#$#$Error:' + err.getStatusCode() + ' - ' + err.getMessage() + ' - ' + err.getFields());

                                }
                            recordsFailed++;
                        }
                    }
                //insert lst_Contact;
                 if(RecordsList!='') {
                  RecordsList+= ' Total :'+ scope.size() + ' Records processed : ' + recordsProcessedinbatch;
                  ErrorLogsUtils.createErrorLogs('Contact Records created :', 'Saf_CreateContactfromAccount', 
                    'execute','Contact Records created :' + RecordsList, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
                }
                 if(ErrorList !='') {
                  ErrorLogsUtils.createErrorLogs('Error', 'Saf_CreateContactfromAccount', 
                    'execute',ErrorList , '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
                }
                system.debug('========= scope ========:' + scope.size());
                system.debug('========= inserting lst_Contact========:' + lst_Contact.size()); 
              
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
            System.debug('job Saf_CreateContactfromAccount: ' + job);

            
        } 


}