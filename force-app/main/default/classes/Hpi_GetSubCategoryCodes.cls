/**
*
* @name                 : Hpi_RegisterEquipments 
* @author               : Happiest minds 
* @description          : This Batch class is used to register equipments
* @created date         : 09-06-2018
* @modified by / date   : 09-06-2018
*
**/


global class Hpi_GetSubCategoryCodes implements Database.Batchable<sObject>,Database.Stateful,
   Database.AllowsCallouts{

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
    global List<String> strlst = new List<string> {'category','agreementtype','makecode'};
    global Map<String,HPI_Agreement_Types__c> map_duplicate = new Map<String,HPI_Agreement_Types__c> (); 
    global Integer recordsProcessed = 0;
    global Integer recordscount;
    global Database.QueryLocator start(Database.BatchableContext BC){
           
           
           Boolean Is_Registration_required = true ;   
           Boolean Is_Registered = false;
           
           //string id = 'a9t9E0000000Rpt';   
           String query = 'Select Id,Name,Code__c,Desciption__c,Category__c,Category_SubCode__c,UniqueCode__c from HPI_Agreement_Types__c where Category__c In: strlst';
          
           system.debug('========= query ========'+query); 
           return Database.getQueryLocator(query);
              
       
        }
    
    global void execute(Database.BatchableContext BC, list<HPI_Agreement_Types__c>scope){
    
         system.debug('******query****'+scope.size());
         try{
               
               List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> lst_CodeDescriptionType = HPI_Parserclass.getCategoryCodes();
               List<HPI_Agreement_Types__c> lst_AgreementType = new  List<HPI_Agreement_Types__c>();
               //Map<String,HPI_Agreement_Types__c> map_duplicate = new  Map<String,HPI_Agreement_Types__c>();
                system.debug('map_duplicate0 : ' +map_duplicate.size());
               for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :lst_CodeDescriptionType)
                   {
                       HPI_Agreement_Types__c objAgType = new HPI_Agreement_Types__c();
                       objAgType.Category__c = 'category';
                       objAgType.Category_SubCode__c = ''.trim();
                       objAgType.Code__c = objdlcode.Code.trim();
                       objAgType.Desciption__c = objdlcode.Description.trim();
                       string struniquecode = string.valueof(objAgType.Category__c) + ':' + objAgType.Category_SubCode__c + ':' + objAgType.Code__c + ':' + objAgType.Desciption__c;
                       map_duplicate.put(struniquecode,objAgType);
                       lst_AgreementType.add(objAgType);
                       //system.debug(struniquecode + 'map_duplicate1 : ' +map_duplicate.get(struniquecode));
                       
                       List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> lst_makecode =  HPI_Parserclass.getMakeCodes(objAgType.Code__c);
                        for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objmakecode :lst_makecode)
                           {
                             objAgType = new HPI_Agreement_Types__c();
                               objAgType.Category__c = 'makecode';
                               objAgType.Category_SubCode__c = objdlcode.Code.trim();
                               objAgType.Code__c = objmakecode.Code.trim();
                               objAgType.Desciption__c = objmakecode.Description.trim();
                               string struniquemakecode = string.valueof(objAgType.Category__c) + ':' + objAgType.Category_SubCode__c + ':' + objAgType.Code__c + ':' + objAgType.Desciption__c;
                               
                               map_duplicate.put(struniquemakecode,objAgType);
                               // system.debug(struniquemakecode + 'map_duplicate2 : ' + map_duplicate.get(struniquemakecode));
                               lst_AgreementType.add(objAgType);
                           }
                       //system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                   }
                   
                   
                   List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> lst_products =  HPI_Parserclass.getAgreementTypes();  
                   for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :lst_products)
                   {
                       HPI_Agreement_Types__c objAgType = new HPI_Agreement_Types__c();
                       objAgType.Category__c = 'agreementtype';
                       objAgType.Category_SubCode__c = '';
                       objAgType.Code__c = objdlcode.Code.trim();
                       objAgType.Desciption__c = objdlcode.Description.trim();
                       string struniquecode = string.valueof(objAgType.Category__c) + ':' + objAgType.Category_SubCode__c + ':' + objAgType.Code__c + ':' + objAgType.Desciption__c;
                       map_duplicate.put(struniquecode,objAgType);
                       lst_AgreementType.add(objAgType);
                        // system.debug(struniquecode + 'map_duplicate3 : ' +map_duplicate.get(struniquecode));
                       //system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                   } 
                     system.debug('lst_AgreementType : ' + lst_AgreementType.size() );
                     system.debug('map_duplicate: ' + map_duplicate.size());
                 
                   for(HPI_Agreement_Types__c objhp :scope)
                   {      system.debug('objhp : ' + objhp);   
                       if(map_duplicate.containskey(objhp.UniqueCode__c))
                       { system.debug('map_duplicate4: ' + map_duplicate.get(objhp.UniqueCode__c)); 
                           HPI_Agreement_Types__c obj = map_duplicate.get(objhp.UniqueCode__c);
                          
                           objhp.Category__c = obj.Category__c;
                           objhp.Category_SubCode__c = obj.Category_SubCode__c;
                           objhp.Code__c = obj.Code__c.trim();
                           objhp.Desciption__c = obj.Desciption__c.trim();
                           Integer index = lst_AgreementType.indexOf(obj);// map_duplicate.get(objhp.UniqueCode__c)
                           system.debug('index:' + index);
                           if(index > -1) { lst_AgreementType.remove(index); }
                       }                       
                   }
            
           //response = responseAdd;
            if(scope.size() >0) 
            {             
                update scope;
                system.debug('========= updating scope ========:' + scope.size()); 
              
            }  if(lst_AgreementType.size() > 0){ 
              system.debug('========= insert lst_AgreementType========:' + lst_AgreementType.size());
              Set<String> Ids = new Set<String>();
              for(HPI_Agreement_Types__c objType :lst_AgreementType)
                   { 
                       string struniquecode = string.valueof(objType.Category__c) + ':' + objType.Category_SubCode__c.trim() + ':' + objType.Code__c.trim() + ':' + objType.Desciption__c.trim();
                      
                       Ids.add(struniquecode);
                   }
              List<HPI_Agreement_Types__c> lst_AgrTypes = [Select Id,Name,Code__c,Desciption__c,Category__c,Category_SubCode__c,UniqueCode__c from HPI_Agreement_Types__c where UniqueCode__c In: Ids];   
              system.debug('========= insert lst_AgrTypes ========:' + lst_AgrTypes.size());
              if(lst_AgrTypes.size() == 0){ insert lst_AgreementType; system.debug('========= insert lst_AgreementType========:');}
             }
             
        }
        catch(exception e)
        {
          system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
         // String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
         // ErrorLogsUtils.createErrorLogs('Failure','Hpi_GetSubCategoryCodes','execute','',description,'','','',false,'',false,'',''); 

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