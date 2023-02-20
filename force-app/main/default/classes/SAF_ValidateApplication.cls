global class SAF_ValidateApplication
{

webservice static String Validatestatus(String AppId)
{
genesis__Applications__c Application=[select id,genesis_Proposed_Funder__c,genesis__Status__c from genesis__Applications__c where id = :AppID];
if(Application.genesis__Status__c=='APPROVED')
{
Application.genesis__Status__c='TRANSACT';
update Application;
return 'success';
}else
{
//List<clcommon__Party__c > Party = [SELECT id FROM clcommon__Party__c WHERE genesis__Application__c =:AppID];
//List<genesis__Application_Equipment__c> Equipment = [select id from genesis__Application_Equipment__c  where genesis__Application__c =:AppID] ;
//List<genesis__Payment_Stream__c> Payment= [select id from genesis__Payment_Stream__c  where genesis__Application__c =:AppID];

if((Application.genesis__Status__c=='Proposal'|| Application.genesis__Status__c =='PROPOSAL- REWORK' || Application.genesis__Status__c =='PROPOSAL-UNDERWRITER DECLINED'|| Application.genesis__Status__c =='DOCUMENTS RECEIVED')&& Application.genesis_Proposed_Funder__c =='SAF')
{
Application.genesis__Status__c='UNDERWRITING';
update Application;
return 'success';
}
else if((Application.genesis__Status__c=='Proposal'|| Application.genesis__Status__c =='PROPOSAL- REWORK' || Application.genesis__Status__c =='PROPOSAL-UNDERWRITER DECLINED'|| Application.genesis__Status__c =='DOCUMENTS RECEIVED')&& Application.genesis_Proposed_Funder__c !='SAF')
{
Application.genesis__Status__c='UNDERWRITING - MULTIPLE';
update Application;
return 'success';
}
else
{
return 'failure';
}

}
}

webservice static String ValidateDocumentRaised(String AppId)
{
genesis__Applications__c Application=[select id,genesis__Status__c from genesis__Applications__c where id = :AppID];
if (Application.genesis__Status__c=='TRANSACT')
{
System.debug('*****Inside method2');
Application.genesis__Status__c='DOCUMENTS RAISED';
update Application;
return 'success';
}else{
return 'failure';
}
}

webservice static String ValidateDocumentCollected(String AppId)
{
genesis__Applications__c Application=[select id,genesis__Status__c from genesis__Applications__c where id = :AppID];
if (Application.genesis__Status__c=='DOCUMENTS RAISED' || Application.genesis__Status__c=='READY TO CONVERT')
//if (Application.genesis__Status__c=='DOCUMENTS RAISED')
{
Application.genesis__Status__c='DOCUMENTS RECEIVED';
update Application;
return 'success';
}else{
return 'failure';
}
}

webservice static String moreInformationRequired(String AppId)
{
genesis__Applications__c Application=[select id,genesis__Status__c from genesis__Applications__c where id = :AppID];
if(Application.genesis__Status__c=='TRANSACT'|| Application.genesis__Status__c=='DOCUMENTS RAISED'|| Application.genesis__Status__c=='DOCUMENTS RECEIVED'||Application.genesis__Status__c=='TRANSFERED'||Application.genesis__Status__c=='UNDERWRITING'||Application.genesis__Status__c=='PROPOSAL-UNDERWRITER DECLINED'||Application.genesis__Status__c=='RECOMMENDED'||Application.genesis__Status__c=='APPROVED' ||Application.genesis__Status__c=='FURTHER INFORMATION REQUIRED' || Application.genesis__Status__c=='READY TO CONVERT')
{
Application.genesis__Status__c='PROPOSAL- REWORK';
update Application;
return 'success';
}else{
return 'failure';
}
}

webservice static String ActivateBrokeredOut(String AppId)
{
genesis__Applications__c Application=[select id,genesis__Status__c, Activated_Date__c from genesis__Applications__c where id = :AppID];
System.debug('*****Activated Brokered Out method');
Application.genesis__Status__c='ACTIVATED - BROKERED OUT';
Application.Activated_Date__c=System.today();
update Application;
return 'success';
}

webservice static String onConvert(String AppId)
{
genesis__Applications__c Application=[select id,genesis__Status__c from genesis__Applications__c where id = :AppID];
List<cllease__Lease_Account__c > Aggreement = [SELECT id FROM cllease__Lease_Account__c WHERE Application__c =:AppID];

System.debug('*****CLS Status:'+Application.genesis__Status__c+'********************************************');
System.debug('*****CLS Size:'+Aggreement.size()+'********************************************');
if(Aggreement.size()>0 && (Application.genesis__Status__c=='READY TO CONVERT'))
{
Application.genesis__Status__c='TRANSFERED';
update Application;
return 'success';
}else{
return 'failure';
}
}
}