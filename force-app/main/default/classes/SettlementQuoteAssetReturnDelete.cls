public class SettlementQuoteAssetReturnDelete
{
    @InvocableMethod
    public static void AssetReturnDelete(List<Id> ContractIds)
    {   
        system.debug('****ContractIds****:'+ContractIds); 
        List<cllease__Other_Transaction__c> AssetReturnLst =[SELECT name,cllease__Lease_Account__r.name,cllease__Transaction_Type__c FROM cllease__Other_Transaction__c
                     WHERE cllease__Lease_Account__c in :ContractIds AND cllease__Transaction_Type__c = 'ASSET RETURN'];
        system.debug('**Total Asset return transaction being deleted are**:' + AssetReturnLst.size());
        if(AssetReturnLst.size()>0){                          
            delete AssetReturnLst;
        }    
   }
}