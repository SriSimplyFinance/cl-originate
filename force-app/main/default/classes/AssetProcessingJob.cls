global class AssetProcessingJob implements Database.Batchable<sObject>{
   
   String query;
    
   global AssetProcessingJob(){         
      
     
      query  = 'Select Id, name,cllease__Contract__c,cllease__Contract__r.cllease__Residual_Amount__c,';
      query += 'cllease__Contract_Equipment__c,cllease__Contract_Equipment__r.cllease__Residual_Amount__c,cllease__Contract_Equipment__r.cllease__Status__c,cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c,';
      query += 'Date_Sold__c,Sale_Price__c,Sold_to__c';
      query += ' From cllease__Asset_workbench__c';
      query += ' Where process_asset_sale__c = true'; 
      query += ' AND cllease__Contract_Equipment__r.cllease__Status__c != \'SOLD\'';
     
       //add more validations in the query
   }         
    
   
   global Database.QueryLocator start(Database.BatchableContext BC)     {  
            
              return Database.getQueryLocator(query);    
   } 
       
   global void execute(Database.BatchableContext BC, List<cllease__Asset_workbench__c> assetProcessings){    
     
        try {
            if(assetProcessings.size() >=0) {
                
                system.debug('assets:'+assetProcessings);
                //Query record type Asset Sale
                ID assetRecordTypeId;
                List<RecordType> exlist = [select Id
                                           , Name
                                           , SobjectType
                                           from RecordType
                                           where Name = 'Asset Sale'
                                           and DeveloperName = 'Asset_Sale'
                                           and SObjectType = 'cllease__Other_Transaction__c'];
                
                //Query Asset Sale Fee
                cllease__fee__c fee = [SELECT id,name 
                               FROM cllease__fee__c
                               WHERE name = 'ASSET SALE' limit 1];
                
                //Query Asset Sale Transaction Type
                cllease__Transaction_Sub_Type__c transactionType = [SELECT id,name
                                                            FROM cllease__Transaction_Sub_Type__c
                                                            WHERE name = 'ASSET SALE' limit 1]; 
              
                List<cllease__Contract_Equipment__C> equipmentList  = new List<cllease__Contract_Equipment__C>();
                List<cllease__Other_Transaction__c> transactionList = new List<cllease__Other_Transaction__c>();
                List<cllease__charge__c>            chargeList      = new List<cllease__charge__c>();
                    
                for(cllease__Asset_workbench__c assetProcessing : assetProcessings){
              
                    if (exList != null && exList.size() > 0) {
                        assetRecordTypeId = exList.get(0).Id;
                    }
                    
                    cllease__Other_Transaction__c termTrx    = new cllease__Other_Transaction__c();
                    termTrx.cllease__Lease_Account__c        = assetProcessing.cllease__Contract__c;
                    termTrx.cllease__txn_date__c             = assetProcessing.Date_Sold__c;
                    termTrx.cllease__Txn_Amt__c              = assetProcessing.Sale_Price__c;
                    termTrx.Sold_to__c                       = assetProcessing.Sold_to__c;
                    termTrx.cllease__GL_Transaction_Flag__c  = true;
                    termTrx.cllease__Transaction_Type__c     = 'ASSET SALE';
                    termTrx.cllease__Residual_Amount_New__c  = assetProcessing.cllease__Contract_Equipment__r.cllease__Residual_Amount__c;
                    termTrx.RecordTypeId                     = assetRecordTypeId;
                    termTrx.Contract_Equipment__c            = assetProcessing.cllease__Contract_Equipment__c;
                    termTrx.Asset_workbench__c               = assetProcessing.id; 
                    termTrx.Asset_Sale_Value__c              = assetProcessing.Sale_Price__c;
                    termTrx.Asset_Cost_of_Sale__c            = assetProcessing.cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c;
                    transactionList.add(termTrx);
                    
                    cllease__charge__c charge              =   new cllease__charge__c();
                    charge.cllease__Lease_Account__c       =   assetProcessing.cllease__Contract__c;
                    charge.cllease__Date__c                =   assetProcessing.Date_Sold__c;
                    charge.cllease__Original_Amount__c     =   assetProcessing.Sale_Price__c;
                    charge.cllease__Fee__c                 =   fee.id;
                    charge.cllease__Transaction_Sub_Type__c=   transactionType.id;
                    charge.cllease__GL_Transaction_Flag__c =   TRUE;
                    chargeList.add(charge);
                            
                   cllease__Contract_Equipment__C equip = [Select id, name, cllease__Status__c
                                                            From cllease__Contract_Equipment__C
                                                            Where id =: assetProcessing.cllease__Contract_Equipment__c];
                    equip.cllease__Status__c = 'SOLD';
                    equipmentList.add(equip);
              }
            
                insert transactionList;
                insert chargeList;
                update equipmentList;
            }
         } Catch(Exception e) {
            system.debug('Exception: '+e.getMessage());
        }   
      
   }
    
   global void finish(Database.BatchableContext BC)   {     
         
      
   } 
}