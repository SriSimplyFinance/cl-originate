public class UnderWritingTriggerhandler
{
    public static void allowCallout(List<id> underwritingIds,set<id> ApplicationIdset,List<Underwriting__c> UpdatedUnderwritingList,Map<id,Underwriting__c> OldUnderWritingMap)
    {
        if(UpdatedUnderwritingList.size()>0)
        {
        List<genesis__Applications__c> ApplicationList=[select id, Zoho_Customer_Id__c FROM genesis__Applications__c WHERE Id IN:ApplicationIdset];
        Map<id,genesis__Applications__c> ApplicationIdtoZohoidMap=new Map<id,genesis__Applications__c>(ApplicationList);
        for(Underwriting__c underWrite:UpdatedUnderwritingList)
        {
            String NewZohoId=underWrite.genesis_Application__r.Zoho_Customer_Id__c ;
            String oldZohoid=ApplicationIdtoZohoidMap.get(underWrite.genesis_Application__c).Zoho_Customer_Id__c;
            System.debug('NewZohoId'+NewZohoId);
            System.debug('oldZohoid'+oldZohoid);
            if(NewZohoId != oldZohoid)
            {
                underwritingIds.add(underWrite.id);
            }
            else
            {}
        }
        }
        System.debug('underwritingIds'+underwritingIds);
        if(underwritingIds.size()>0)
        {
        Saf_ZohoUnderwriting.CreateInZoho(underwritingIds, false);
        }
    }
}