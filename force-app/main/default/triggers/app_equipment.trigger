trigger app_equipment on genesis__Application_Equipment__c (after update) {

List<id> AppList = new List<id>();
for(genesis__Application_Equipment__c Equ: trigger.new)
{
if (genesis__Application_Equipment__c.OA_ID__c !=null)
{
string id = String.valueof(genesis__Application_Equipment__c.id);
OACallout.CreateAssetOA(id);
}
else {
string id = String.valueof(genesis__Application_Equipment__c.id);
OACallout.CreateAsset(id);
}
}
}