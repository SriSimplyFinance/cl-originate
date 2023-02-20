/* The below class is used to update Future Rentals and Unearned Interest in Lease contract which calculates the sum of all Capital and sum of all Income for Future Rentals and Sum of all Income for Unearned Interest from Lease Income streams*/
public Class CreateMasterDocsAndCreditconditions{
    
    @InvocableMethod 
    public static void CreateRecords(List<genesis__Applications__c> ApplicationIds){
        String strApplicationId;
        String strProductId ;
        
        if(ApplicationIds.size() >0)
        {
        strApplicationId = ApplicationIds[0].Id;
        strProductId = ApplicationIds[0].genesis__CL_Product__c;
          CheckExistingRecordsandDelete(strApplicationId);
        }
         list<MasterDocument__c> lstappMasterdocs  = new  list<MasterDocument__c>();    
        //Query for Capital and Income fields from Rental streams where date > system date and it to a list.
        list<genesis__Document_Master__c> lstMasterdocs = [Select Id,Master_Document_Type__c,Master_Document_Type__r.Name,CL_Product__c From genesis__Document_Master__c Where  CL_Product__c =:strProductId];
       
       for(genesis__Document_Master__c objmd:lstMasterdocs) {
            MasterDocument__c objAppDocs = new MasterDocument__c(); objAppDocs.Application__c = strApplicationId; objAppDocs.Document_Master__c = objmd.Id; objAppDocs.MasterDocumentName__c = objmd.Master_Document_Type__r.Name;lstappMasterdocs.add(objAppDocs);
        }     
       if(lstMasterdocs.size() >0) { insert lstappMasterdocs; }
       
        
        list<CreditConditionsApp__c> lstappCreditConditions  = new  list<CreditConditionsApp__c>();    
        //Query for Capital and Income fields from Rental streams where date > system date and it to a list.
        list<CreditConditions__c> lstCreditConditions = [Select Id, CreditConditionType__c,CreditConditionType__r.Name,CL_Product__c From CreditConditions__c Where  CL_Product__c =:strProductId];
       
       for(CreditConditions__c objcc:lstCreditConditions) {
            CreditConditionsApp__c objAppCC = new CreditConditionsApp__c();
            objAppCC.Application__c = strApplicationId;
            objAppCC.CreditConditions__c = objcc.Id;
            objAppCC.CreditconditionsName__c = objcc.CreditConditionType__r.Name;
            lstappCreditConditions.add(objAppCC);
        }
        
        if(lstCreditConditions.size() >0) { insert lstappCreditConditions;} 
    }   
    
      public static void CheckExistingRecordsandDelete(string strApplicationId){
     
       list<CreditConditionsApp__c> lstCreditConditionsApp = [Select Id, IsChecked__c,Application__c,CreditConditions__c From CreditConditionsApp__c Where Application__c =:strApplicationId];
       if(lstCreditConditionsApp.size() >0)
       {delete lstCreditConditionsApp; }
     
       list<MasterDocument__c> lstMasterDocApp = [Select Id,  Application__c From MasterDocument__c Where Application__c =:strApplicationId];
       if(lstMasterDocApp.size() >0)
       {delete lstMasterDocApp; }
       
     } 
    }