global class AssetSaleProcessing {
    WebService static String processAssetSale(String assetWorkBenchID) {
        List<cllease__Asset_workbench__c> assetProcessings = [Select Id, name,
                                                                cllease__Contract__c,
                                                                cllease__Contract__r.cllease__Residual_Amount__c, 
                                                                cllease__Contract_Equipment__c,
                                                                cllease__Contract_Equipment__r.cllease__Status__c,
                                                                cllease__Contract_Equipment__r.cllease__Residual_Amount__c,
                                                                cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c,
                                                                Date_Sold__c,
                                                                Sale_Price__c,
                                                                Sold_to__c
                                                            From cllease__Asset_workbench__c
                                                            Where id =: assetWorkBenchID];
        cllease__fee__c fee = [SELECT id,name 
                               FROM cllease__fee__c
                               WHERE name = 'ASSET SALE' limit 1];
        
        cllease__Transaction_Sub_Type__c transactionType = [SELECT id,name
                                                            FROM cllease__Transaction_Sub_Type__c
                                                            WHERE name = 'ASSET SALE' limit 1]; 
        try {
            if(assetProcessings.size() >=0) {
                cllease__Asset_workbench__c assetProcessing = assetProcessings.get(0);
                validate(assetProcessing);
                // 1. Create Other transaction of ASSET SALE Type
                ID assetRecordTypeId;
                List<RecordType> exlist = [select Id
                                           , Name
                                           , SobjectType
                                           from RecordType
                                           where Name = 'Asset Sale'
                                           and DeveloperName = 'Asset_Sale'
                                           and SObjectType = 'cllease__Other_Transaction__c'];
                
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
                insert termTrx;
                
                //Create Charge
                cllease__charge__c charge              =   new cllease__charge__c();
                charge.cllease__Lease_Account__c       =   assetProcessing.cllease__Contract__c;
                charge.cllease__Date__c                =   assetProcessing.Date_Sold__c;
                charge.cllease__Original_Amount__c     =   assetProcessing.Sale_Price__c;
                charge.cllease__Fee__c                 =   fee.id;
                charge.cllease__Transaction_Sub_Type__c=   transactionType.id;
                charge.cllease__GL_Transaction_Flag__c =   TRUE;
                insert charge;
               
                cllease__Contract_Equipment__C equip = [Select id, name, cllease__Status__c
                                                        From cllease__Contract_Equipment__C
                                                        Where id =: assetProcessing.cllease__Contract_Equipment__c];
                equip.cllease__Status__c = 'SOLD';
                update equip;
            }
        } Catch(Exception e) {
            return 'Exception: '+e.getMessage();
        }   
        return 'Processed Asset Sale Successfully';
    }
    
    WebService static String multiAssetProcess() {
        
        Database.executeBatch(new AssetProcessingJob(), 50);
        return 'Batch Process Initiated';
    } 
              
    private static void validate(cllease__Asset_workbench__c assetProcessing) {
        if(assetProcessing.cllease__Contract_Equipment__r.cllease__Status__c == 'SOLD') {
            throw new cllease.LeaseServicingException('Equipment is already sold', 'ERROR');
        }
        if(assetProcessing.Sale_Price__c==null || assetProcessing.Sale_Price__c <= 0) {
            throw new cllease.LeaseServicingException('Please enter Sale Prices', 'ERROR');
        }
        if(assetProcessing.Sold_to__c==null) {
            throw new cllease.LeaseServicingException('Please enter Sale To', 'ERROR');
        }
        if(assetProcessing.Date_Sold__c==null) {
            throw new cllease.LeaseServicingException('Please enter Sale Date', 'ERROR');
        }
        if(assetProcessing.cllease__Contract__c==null) {
            throw new cllease.LeaseServicingException('Contract is missing from Asset Processing', 'ERROR');
        }
        if(assetProcessing.cllease__Contract_Equipment__c==null) {
            throw new cllease.LeaseServicingException('Contract Equipment missing from Asset Processing', 'ERROR');
        }
    }
}