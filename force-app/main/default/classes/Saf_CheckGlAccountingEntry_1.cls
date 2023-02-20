/**
*
* @name                 : Saf_CheckGlAccountingEntry_1
* @author               : Happiest minds 
* @description          : This Batch class is used to tick the gl entries where manual record are created
* @created date         : 18-02-2020
* @modified by / date   : 18-02-2020
*
**/


global class Saf_CheckGlAccountingEntry_1 extends cllease.LeaseDynamicJob{

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 

     global static String NAME = 'Saf_CheckGlAccountingEntry_1';
     global static String query; 
     public class MyException extends Exception{} 
     global Integer recordsProcessed = 0;  
     global override void doInitialize()
     {}
     global Saf_CheckGlAccountingEntry_1()
    {   
        super(NAME,buildquery());
    }  
     global override string getRuntimeQuery()
    { 
        
        String query = 'SELECT Id,Name,saf_manualGl_Reversed__c,saf_Transaction_Type2__c,Saf_Manual_GL_Entry_created__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c WHERE ID in (select Saf_GL_Accounting_Entries__c from Manual_GL__c) and saf_manualGl_Reversed__c = false and (Saf_Manual_GL_Entry_created__c = false or saf_Transaction_Type2__c = null)';
           
        return query;
    }
      global override void dostart(Database.BatchableContext BC){
      
      }
     /*global Database.QueryLocator start(Database.BatchableContext BC){
           
          
           //string id = 'a9t9E0000000Rpt';   
           String query = 'SELECT Id,Name,Saf_Manual_GL_Entry_created__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c WHERE ID in (select Saf_GL_Accounting_Entries__c from Manual_GL__c) and Saf_Manual_GL_Entry_created__c = false';
           
           system.debug('========= query ========'+query); 
           return Database.getQueryLocator(query);
              
       
        }*/
    
     global override  void doexecute(Database.BatchableContext BC, list<sobject>scope){
    
         system.debug('******query****'+scope.size());
         try{
               
            
                  List<cllease__GL_Transaction_Detail__c> lstTxn = scope; 
                  List<cllease__GL_Transaction_Detail__c> lst_GLTxn = new  List<cllease__GL_Transaction_Detail__c>();
                   for(cllease__GL_Transaction_Detail__c objhp :lstTxn)
                   {   
                     if(objhp.saf_Transaction_Type2__c == null && objhp.Saf_Manual_GL_Entry_created__c)
                       {
                           objhp.saf_manualGl_Reversed__c = true;
                           lst_GLTxn.add(objhp);
                       }
                     if(!objhp.Saf_Manual_GL_Entry_created__c)
                         {
                          objhp.Saf_Manual_GL_Entry_created__c  = true;
                          lst_GLTxn.add(objhp);   
                         }                                                                                        
                   }
                  
           //response = responseAdd;
            if(lst_GLTxn.size() >0) 
            {             
                update lst_GLTxn;
                system.debug('========= updating lst_GLTxn========:' + lst_GLTxn.size()); 
              
            }  
        }
        catch(exception e)
        {
          system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
          String strErrordes= 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
          ErrorLogsUtils.createErrorLogs('Failure', 'Saf_CheckGlAccountingEntry_1', 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');

        }
    }
      
         global override void dofinish(Database.BatchableContext BC){
            
            System.debug('Records processed checkManualGl: ' + recordsProcessed);
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job checkManualGL: ' + job);
        } 

        global static string buildquery(){
        //build query.
          String query = 'SELECT Id,Name,saf_manualGl_Reversed__c,saf_Transaction_Type2__c,Saf_Manual_GL_Entry_created__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c WHERE ID in (select Saf_GL_Accounting_Entries__c from Manual_GL__c) and saf_manualGl_Reversed__c = false and (Saf_Manual_GL_Entry_created__c = false or saf_Transaction_Type2__c = null)';
       
         system.debug('--Query--'+ query);      
         return query;
    }
}