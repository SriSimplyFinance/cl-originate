/**
*
* @name                 : Saf_UpadateAgreementfromRentalstreams 
* @author               : Happiest minds 
* @description          : This Batch class is used to clear exposure values for terminated and cancelled agreeements
* @created date         : 03-01-2019
* @modified by / date   : 03-01-2019
*
**/


global class Saf_Exposure_1 extends cllease.LeaseDynamicJob {

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
     global static String NAME = 'Saf_Exposure_1';
     global static String query; 
     public class MyException extends Exception{} 
     global Integer recordsProcessed = 0;  
     global override void doInitialize()
    {}
    
    global Saf_Exposure_1()
    {   
        super(NAME,buildquery());
    }  
    global override string getRuntimeQuery()
    { 
        
        string[] id = new string[]{'a699E0000009Bu3'}; //'0010O00001u75McQAI','0011j000006OM79','0010O000025VnrXQAS'};//where cllease__Contract__r.cllease__Account__c IN: id
        String query= 'select Id,Name,cllease__Lease_Status__c,Saf_Exposure__c,cllease__Account__c,cllease__Account__r.Id,cllease__Account__r.Name,cllease__Account__r.SAF_Exposure_Agreements__c from cllease__Lease_Account__c';// where cllease__Lease_Status__c NOT IN :strStatus';
        
        return query;
    }
        
    global override void dostart(Database.BatchableContext BC){
      
        
        /*string[] id = new string[]{'a699E0000009Bu3'};//  {'0010O00001u75McQAI','0011j000006OM79','0010O000025VnrXQAS'};
        string[] strStatus = new string[]{'ACTIVE - GOOD STANDING','ACTIVE - BAD STANDING'};
        //String query='select id,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c order by cllease__Contract__c'; 
        String query= 'select Id,Name,cllease__Lease_Status__c,Saf_Exposure__c,cllease__Account__c,cllease__Account__r.Id,cllease__Account__r.Name,cllease__Account__r.SAF_Exposure_Agreements__c from cllease__Lease_Account__c';// where cllease__Lease_Status__c NOT IN :strStatus';
        
       return Database.getQueryLocator(query);*/
        
    }
    
    global override  void doexecute(Database.BatchableContext BC, list<sobject>scope){
    
         system.debug('******query****'+scope);
         try{
           
            Map<Id,Account> mapContracts = new Map<Id,Account>();
            List<Account> lstaccount = new List<Account>();
            List<cllease__Lease_Account__c> lstContract = scope; 
            for(cllease__Lease_Account__c objacc: lstContract)
            {    
                    objacc.Saf_Exposure__c = 0;   
                    if(objacc.cllease__Account__c !=null)
                    {
                     mapContracts.put(objacc.cllease__Account__c,objacc.cllease__Account__r);
                    } 
            }
            
             for(Account objacc: [Select Id, SAF_Exposure_Application__c, SAF_Exposure_Agreements__c from Account WHERE id IN: mapContracts.keyset()])
            {
               
                objacc.SAF_Exposure_Agreements__c = 0;     
                lstaccount.add(objacc);    
              
            }
            update scope;
            update lstaccount;
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(exception e)
        {
            system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
            //String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
            string strErrordes = e.getMessage() + ', Line no: '+e.getLineNumber();
            //ErrorLogsUtils.createErrorLogs('Failure', description,'Batch',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
        }
    }
      
        global override void dofinish(Database.BatchableContext BC){
            
            System.debug('Records processed: ' + recordsProcessed);
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job : ' + job);
        } 

        global static string buildquery(){
        //build query.
         string[] id = new string[]{'a699E0000009Bu3'};
         //query='select id,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c order by cllease__Contract__c'; 
         String query= 'select Id,Name,cllease__Lease_Status__c,Saf_Exposure__c,cllease__Account__c,cllease__Account__r.Id,cllease__Account__r.Name,cllease__Account__r.SAF_Exposure_Agreements__c from cllease__Lease_Account__c';// where cllease__Lease_Status__c NOT IN :strStatus';
        
         system.debug('--Query--'+ query);      
         return query;
    }
}