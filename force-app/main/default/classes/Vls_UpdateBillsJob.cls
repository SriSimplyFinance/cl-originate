/**
*
* @name                 : Vls_UpdateBillsJob 
* @author               : Happiest minds 
* @description          : This Batch class is used to update vls field for reports
* @created date         : 05-05-2018
* @modified by / date   : 05-05-2018
*
**/


global class Vls_UpdateBillsJob implements Database.Batchable<sObject>{

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
    
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext BC){
    
         String query='select id,VLS_Number_Of_Instance_c__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c from cllease__Lease_account_Due_Details__c order by cllease__Due_Date__c';
            
           return Database.getQueryLocator(query);
            
        }
    
    global void execute(Database.BatchableContext BC, list<cllease__Lease_account_Due_Details__c>scope){
    
         system.debug('******query****'+scope);
         try{
            
            set<id>Conids=new set<id>();
            for(cllease__Lease_account_Due_Details__c objbill : scope)
                 {                
                    Conids.add(objbill.cllease__Lease_Account__c);
                 }
           list<cllease__Payment_Schedule__c> lstPayschedule = new list<cllease__Payment_Schedule__c>([select id,Name,cllease__Contract__c,cllease__Number_Of_Payments__c,cllease__Frequency__c,cllease__Sequence__c,cllease__Payment_Date__c from cllease__Payment_Schedule__c where cllease__Contract__c in :Conids]);
           
        for(cllease__Lease_account_Due_Details__c objbill1:scope){
            system.debug('objbill1 : '+ objbill1);
            Integer IntPsNo;
           for(cllease__Payment_Schedule__c objps:lstPayschedule){ 
             
               if(objps.cllease__Number_Of_Payments__c != null) {IntPsNo = Integer.valueof(objps.cllease__Number_Of_Payments__c);} 
               system.debug('IntPsNo: '+ IntPsNo);
               if(objbill1.cllease__Lease_Account__c == objps.cllease__Contract__c)
                {
                     Datetime dt_ps = objps.cllease__Payment_Date__c;
                    DateTime dt_enddate = dt_ps;
                    if(objps.cllease__Frequency__c == 'Weekly')
                    {
                        Decimal days = 7 * IntPsNo;
                        dt_enddate = dt_ps.addDays(Integer.valueof(days));
                    }
                    else
                    {    
                        Integer IntNoPay = Integer.valueof(IntPsNo);
                        if(IntNoPay > 1) {IntNoPay  = IntNoPay -1 ;
                        dt_enddate = dt_ps.addMonths(IntNoPay);
                        }
                        else {
                        Integer numberOfDays = Date.daysInMonth(dt_ps.year(), dt_ps.month());
                        Date lastDayOfMonth = Date.newInstance(dt_ps.year(), dt_ps.month(), numberOfDays);
                        dt_enddate = lastDayOfMonth;
                        }
                        
                    }
                    system.debug('objps.cllease__Payment_Date__c: '+ objps.cllease__Payment_Date__c);
                    system.debug('objbill1.cllease__Due_Date__c: '+ objbill1.cllease__Due_Date__c);
                    system.debug('dt_enddate: '+ dt_enddate);
                    if(objps.cllease__Payment_Date__c <= objbill1.cllease__Due_Date__c && objbill1.cllease__Due_Date__c <= dt_enddate)
                    {
                     objbill1.VLS_Number_Of_Instance_c__c = IntPsNo;
                      system.debug('inside');
                       // increment the instance member counter
                    recordsProcessed = recordsProcessed + 1;
                     break;
                    }
                   }
                }
            system.debug('objbill1.VLS_Number_Of_Instance_c__c : '+ objbill1.VLS_Number_Of_Instance_c__c);
            }     
            update scope;
             
        }
        catch(exception e)
        {
          system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
           //String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
           //ErrorLogsUtils.createErrorLogs('Failure','CL_VersapayAutoDebitJob','execute','',description,LoanAcc.id,'','',false,ErrorLogsUtils.ERROR,false,'',''); 

        }
    }
      
        global void finish(Database.BatchableContext BC){
            
            System.debug('Records processed: ' + recordsProcessed);
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job : ' + job);
        } 


}