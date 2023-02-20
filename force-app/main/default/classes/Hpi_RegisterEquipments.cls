/**
*
* @name                 : Hpi_RegisterEquipments 
* @author               : Happiest minds 
* @description          : This Batch class is used to register all equipments
* @created date         : 09-06-2018
* @modified by / date   : 09-06-2018
*
**/


global class Hpi_RegisterEquipments implements Database.Batchable<sObject>,Database.Stateful,
   Database.AllowsCallouts{

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
    global string strContractId;
    global Integer recordsProcessed = 0;
    global Integer recordscount;
    global Database.QueryLocator start(Database.BatchableContext BC){
    
           Boolean Is_Registration_required = true ;   
           Boolean Is_Registered = false;      
           String query = 'select Id,Name,IS_Registered__c,cllease__Contract__c,cllease__Contract__r.cllease__Contract_Date__c,cllease__Contract__r.Name,cllease__Contract__r.cllease__Term__c,' +
           'HPI_Code__c,HPI_Registration_Required__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,Vehicle_Registration_Number__c,Vehicle_Chassis_Number__c,' +
           'cllease__VIN__c,cllease__Equipment_Description__c,cllease__Equipment_Serial_Number__c,cllease__Equipment_Type__c,cllease__Contract__r.cllease__Lease_Product_Name__r.Name,cllease__Make__c, cllease__Model__c,  NewUsed__c ' +
           'from cllease__Contract_Equipment__c where cllease__Contract__c =:strContractId and HPI_Registration_Required__c =: Is_Registration_required and IS_Registered__c =: Is_Registered';
          
           system.debug('========= query ========'+query); 
           return Database.getQueryLocator(query);
              
       
        }
    
    global void execute(Database.BatchableContext BC, list<cllease__Contract_Equipment__c>scope){
    
         system.debug('******query****'+scope);
         try{
            
               for(cllease__Contract_Equipment__c objEquip :scope)
                   {
                        string response = HPI_Parserclass.hpi_FinanceAdd(objEquip);
                       
                        system.debug('========= response ======== for Equipment :' +objEquip.Name +response);   
                        if(response.contains('TRUE') && response.contains('200'))
                            {
                                objEquip.IS_Registered__c = true ;  
                           
                                system.debug('========= response objContractEquipment========'+objEquip);                             
                            }
                     
                         
                       objEquip.HPI_Error_Message__c = response;
                   }
           //response = responseAdd;
            if(scope.size() == recordscount || scope.size() >0) 
            {
                system.debug('========= updating scope ========'); 
                 update scope;
            }system.debug('========= scope ========'+scope);    
             
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