public class MigrationScript1 
{
    /***********START: PART - 1 Script: run it from developer console ******/
    //********** FEE DEFINITON:  1. Creating clcommon fee definitions from cllease fee configuration  *************************/
    Public Savepoint sp = Database.setSavepoint();
    Public Map<Id, String> oldfeeNameMap = new Map<Id, String>();
    Public Map<Id, String> oldfeeSetMap = new Map<Id, String>();
     public void MigScript1()
    {
    try{
      String namespacePrefix = 'cllease__';
      String query = ' Select id, Name, ' +
                                                   namespacePrefix + 'Amortization_Method__c, ' +
                                                   namespacePrefix + 'Amortization_Period__c, ' +
                                                   namespacePrefix + 'Amount__c, ' +         
                                                   namespacePrefix + 'Capitalize__c, ' +        
                                                   namespacePrefix + 'Fee_Calculation_Method__c, ' +
                                                   namespacePrefix + 'Fee_Type__c, ' +                 
                                                   namespacePrefix + 'Maximum_Amount__c, ' +  
                                                   namespacePrefix + 'Minimum_Amount__c, ' +  
                                                   namespacePrefix + 'State__c, ' +                 
                                                   namespacePrefix + 'Taxable__c, ' +         
                                                   namespacePrefix + 'Time_of_charge__c, ' +  
                                                   namespacePrefix + 'Type_of_charge__c ' +
                                    ' From '+namespacePrefix +'Fee__c ';
      List<sobject> oldFees = Database.query(query);
     
      // Skipping migration script run if clcommon Fee Definitions already created
      Set<String> existingFeeDefSet = new Set<String>();
      List<clcommon__Fee_Definition__c> existingFeeDefList = [SELECT Id, Name From clcommon__Fee_Definition__c];
      for(clcommon__Fee_Definition__c existingFeeDef : existingFeeDefList) {
             existingFeeDefSet.add(existingFeeDef.Name);
      }
      
      // Creating clcommon Fee Definitions from CL Lease Fees      
      List<clcommon__Fee_Definition__c> newFees = new List<clcommon__Fee_Definition__c>();
      for(sobject fee : oldFees) {
             if(existingFeeDefSet.contains((String)fee.get('Name'))) continue;
             
             clcommon__Fee_Definition__c feeDefinition = 
                                    new clcommon__Fee_Definition__c(
                                                           name = (String)fee.get('name'),
                                                     clcommon__Amortization_Method__c = (String)fee.get(namespacePrefix + 'Amortization_Method__c'),
                                                     clcommon__Amortization_Period__c = (String)fee.get(namespacePrefix + 'Amortization_Period__c') ,
                                                           clcommon__Amount__c              = (Decimal)fee.get(namespacePrefix + 'Amount__c') ,
                                                           clcommon__Capitalize__c           = (Boolean)fee.get(namespacePrefix + 'Capitalize__c') ,
                                                     clcommon__Calculation_Method__c  = (String)fee.get(namespacePrefix + 'Fee_Calculation_Method__c') ,
                                                           clcommon__Class__c                       = (String)fee.get(namespacePrefix + 'Fee_Type__c') ,
                                                           clcommon__Maximum_Amount__c    = (Decimal)fee.get(namespacePrefix + 'Maximum_Amount__c'), 
                                                           clcommon__Minimum_Amount__c    = (Decimal)fee.get(namespacePrefix + 'Minimum_Amount__c'), 
                                                           clcommon__Taxable__c             = (Boolean)fee.get(namespacePrefix + 'Taxable__c') ,
                                                           clcommon__Type__c                        = (String)fee.get(namespacePrefix + 'Type_of_charge__c'));
                     
             if(fee.get(namespacePrefix + 'State__c') == 'Active') {
                     feeDefinition.clcommon__Active__c =  true;
             }
             
             if(fee.get(namespacePrefix + 'Time_of_charge__c') == 'BOOKING') {
                     feeDefinition.clcommon__Type__c = 'BOOKING';
             }
             
             if(feeDefinition.clcommon__Class__c == null) {
                     feeDefinition.clcommon__Class__c = clcommon.CLConstants.FEE_CLASS_INCOME;
             }
             
             if(feeDefinition.clcommon__Amount__c == null) {
                     feeDefinition.clcommon__Amount__c = 0;
             }
             oldfeeNameMap.put((ID)fee.get('ID'), (String)fee.get('name'));
             newFees.add(feeDefinition);
             System.debug(LoggingLevel.ERROR, 'Fee Definition Created: '+feeDefinition);
      }
      insert newFees;
     
      //********** FEE SET: 2. Creating clcommon fee set from cllease fee set  *************************/      
      query = 'SELECT Id, Name '+
                     'FROM '+namespacePrefix +'Fee_Set__c';
      List<sObject> oldFeeSets = Database.query(query);
      List<clcommon__Fee_Set__c> newFeeSet = new list<clcommon__Fee_Set__c>();
     
      for(sobject feeSet : oldFeeSets) {
             clcommon__Fee_Set__c newFeeSet1 = new clcommon__Fee_Set__c(name = (String)feeSet.get('name'));
             newFeeSet.add(newFeeSet1);
             oldfeeSetMap.put((ID)feeSet.get('ID'), (String)feeSet.get('name'));
             System.debug(LoggingLevel.ERROR, 'Created clcommon fee set: '+newFeeSet1);
      }
      insert newFeeSet;
     
      //********** FEE JUNCTION: 3. Creating clcommon fee junction from cllease fee junction  *************************/    
      // a. Creating Maps <Name, ID> for mappting fee and fee sets
      Map<String, Id> feeNameMap = new Map<String, Id>();
      for(clcommon__Fee_Definition__c feeDef : newFees) {
             feeNameMap.put(feeDef.name, feeDef.Id);
      }
      System.debug(LoggingLevel.ERROR, '---feeNameMap: '+feeNameMap);
             
      Map<String, Id> feeSetNameMap = new Map<String, Id>();
      for(clcommon__Fee_Set__c feeSet: newFeeSet) {
             feeSetNameMap.put(feeSet.name, feeSet.Id);
      }
      System.debug(LoggingLevel.ERROR, '---feeSetNameMap: '+feeSetNameMap);
     
     
      query = ' Select id, name, ' +
                             namespacePrefix + 'Fee__c, ' +
                             namespacePrefix + 'Fee_Set__c ' +
                     ' From '+namespacePrefix +'Fee_Junction__c ';
      List<sobject> oldFeejunctions = Database.query(query);
      List<clcommon__Fee_Junction__c> newFeejunctions = new List<clcommon__Fee_Junction__c>();
      for(sobject feeJunction : oldFeejunctions) {
             
             clcommon__Fee_Junction__c newFeeJunction = new clcommon__Fee_Junction__c(
                     clcommon__Fee__c        = feeNameMap.get(oldfeeNameMap.get((ID)feeJunction.get(namespacePrefix + 'Fee__c'))),
                     clcommon__Fee_Set__c = feeSetNameMap.get(oldfeeSetMap.get((ID)feeJunction.get(namespacePrefix + 'Fee_Set__c')))
             );
            if(newFeeJunction.clcommon__Fee__c != null && newFeeJunction.clcommon__Fee_Set__c != null) {
                newFeejunctions.add(newFeeJunction);
                     System.debug(LoggingLevel.ERROR, '---newFeeJunction: '+newFeeJunction);
            }        
      }
      insert newFeejunctions;
     
      //********** LEASE PRODUCT: Fee set to Fee set1  *************************/ 
      query = ' Select id, name, ' +
                             namespacePrefix + 'Fee_set__c,  ' +
                             namespacePrefix + 'Fee_set__r.name,  ' +
                             namespacePrefix + 'fee_set1__c ' +
                     ' From '+namespacePrefix +'Lease_product__c ';
      List<sobject> products = Database.query(query);
      for(sobject product : products) {
             if((String)product.get(namespacePrefix + 'Fee_set__c') == null) continue;
             product.put(namespacePrefix + 'fee_set1__c', feeSetNameMap.get(oldfeeSetMap.get((ID)product.get(namespacePrefix + 'Fee_Set__c'))));
      }
      update products;
     
      //********** TERMINATION CONFIG FEE: Fee to Fee Definition  ***************/ 
      query = ' Select id, name, ' +
                             namespacePrefix + 'Fee__c,  ' +
                             namespacePrefix + 'Fee__r.name,  ' +
                             namespacePrefix + 'Fee_Definition__c ' +
                     ' From '+namespacePrefix +'Termination_Config_Fee__c ';
      List<sobject> termConfigFees = Database.query(query);
      for(sobject termConfig : termConfigFees) {
             if((String)termConfig.get(namespacePrefix + 'Fee__c') == null) continue;
             termConfig.put(namespacePrefix +  'Fee_Definition__c' , feeNameMap.get(oldfeeNameMap.get((ID)termConfig.get(namespacePrefix + 'Fee__c'))));
      }
      update termConfigFees; 
     
      //********** SPREAD DETAILS: Fee to Fee Definition  **********************/
      query = ' Select id, name, ' +
                             namespacePrefix + 'Fee__c,  ' +
                             namespacePrefix + 'Fee__r.name,  ' +
                             namespacePrefix + 'Fee_Definition__c ' +
                     ' From '+namespacePrefix +'Spread_Detail__c ';
      List<sobject> spreadDetailsConfig = Database.query(query);
      for(sobject spreadDetail : spreadDetailsConfig) {
             if((String)spreadDetail.get(namespacePrefix + 'Fee__c') == null) continue;
             spreadDetail.put(namespacePrefix +  'Fee_Definition__c' , feeNameMap.get(oldfeeNameMap.get((ID)spreadDetail.get(namespacePrefix + 'Fee__c'))));
      }
      update spreadDetailsConfig;
        
    } catch(Exception e) {
        System.debug(LoggingLevel.ERROR, 'Exception : '+e.getMessage() +' line: '+e.getLineNumber());
        Database.Rollback(sp);
    }
  }   
    /***********END: PART - 1 Script: run it from developer console ******/
}