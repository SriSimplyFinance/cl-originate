public class Saf_SharepointAPIController {
    
    @invocablemethod(Label='Sharepoint API' Description='Make sharepoint API call to create folders')
    public static void verifySharepointAPICalls(List<string> appId){
        
        genesis__Applications__c genApp=[SELECT id,Name,genesis__Account__r.SAF_Sharepoint_Folder_ID__c,Sharepoint_SiteName__c,Sharepoint_Proposal_FolderID__c, genesis__Account__c,genesis__Account__r.Name,Is_Contract_created__c FROM genesis__Applications__c where id=:appId[0] limit 1];
        
        SAF_Custom_FolderCreation.sendApplicationDocToSharePointCustom(genApp.id);    
    }

}