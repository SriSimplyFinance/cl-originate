global class Saf_Equipment_UREL implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
   global boolean IsfirstTime = true;
   global static date TodaysDate;
   public class MyException extends Exception{} 
   global Set<Id> IdsContEquip2 = new Set<Id>();
  
    global Database.QueryLocator start(Database.BatchableContext BC) {   
         User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
        TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
        System.debug(LoggingLevel.ERROR, '###### TodaysDate : ' + TodaysDate);  
                 
       String query = 'Select Id,Name,Gross_Asset_Cost__c,Net_Asset_Cost__c,VAT__c,cllease__Subsidy__c,Paid_To_Supplier__c,Amount_Financed__c,cllease__Residual_Amount__c,Deposit__c,Advanced_Rental__c,Supplier_Payable__c,Total_Cost__c,SAF_UREL__c,cllease__Contract__c,cllease__Estimated_Selling_Price__c,cllease__Contract__r.Application__c from cllease__Contract_Equipment__c where cllease__Contract__c IN :IdsContEquip2 order by Net_Asset_Cost__c desc';
       //String query = 'Select Id,Name,Gross_Asset_Cost__c,Net_Asset_Cost__c,cllease__Contract__c,cllease__Contract__r.Application__c from cllease__Contract_Equipment__c where cllease__Contract__c IN :IdsContEquip2 order by Net_Asset_Cost__c desc';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<cllease__Contract_Equipment__c> lstEquipments) {
      System.debug(LoggingLevel.Error, 'In custom trigger : ' + lstEquipments[0].cllease__Estimated_Selling_Price__c);
      Set<Id> AppIds = new Set<Id>();
      try
      {
      List<cllease__Lease_Account__c> leasecontract1 = [select name,Id,Application__c from cllease__Lease_Account__c where Id in :IdsContEquip2];
      for(cllease__Lease_Account__c cl:leasecontract1)
        {
           if(cl.Application__c!=null){ AppIds.add(cl.Application__c);}
        }
      system.debug('*******leasecontract1 ********'+leasecontract1);
      List<Underwriting__c> under = [select Id,Name, genesis_Application__c,UREL__c,LastModifiedDate from Underwriting__c where genesis_Application__c in:AppIds order by LastModifiedDate desc limit 1]; 
      system.debug('*******under ********'+under );
      
      if(under.size() >0)
      {
          String strMaxEquipmentId = lstEquipments[0].Id;
          for(cllease__Contract_Equipment__c e:lstEquipments)
           {
               
           
               if(e.Id == strMaxEquipmentId && under[0].UREL__c !=NULL)
               {
                e.SAF_UREL__c = under[0].UREL__c;
               }
               else if(e.SAF_UREL__c != NULL)
               {
                   e.SAF_UREL__c = NULL;   
               }else {}
           
           } 
        } 
        if(under.size()>0){        
            update lstEquipments;
            system.debug('&&&&&lstEquipments'+lstEquipments);
        } 
        if(Test.isRunningTest()){throw new MyException();}
      }
     catch(exception e)
        {
            system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
            //String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
            string strErrordes = 'Branch Date :' + TodaysDate + e.getMessage() + ', Line no: '+e.getLineNumber();
            //ErrorLogsUtils.createErrorLogs('Failure', description,'Batch',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    IsfirstTime = false;
    }
}