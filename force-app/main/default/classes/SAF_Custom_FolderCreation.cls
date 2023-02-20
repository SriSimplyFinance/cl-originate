global Class SAF_Custom_FolderCreation {

  webservice static string sendApplicationDocToSharePointCustom(string appId) {

    /*****************************************
     * Gloabl Constants & Variables
     *****************************************/
    string customerName;
    string filePathUrl;
    String sharePointResponse = '';
    String appName;
    String customerId;
    String spFolderId;

    genesis__Applications__c genApp = [SELECT id, Name, genesis__Account__r.SAF_Sharepoint_Folder_ID__c, genesis__Account__c, genesis__Account__r.Name, Is_Contract_created__c FROM genesis__Applications__c where id = :appId limit 1];

    if (genApp != null) {
      customerName = genApp.genesis__Account__r.Name.replaceAll('[|,|.|//\\,||"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"|\\\\|]', '');
      Logger.debug('customerName:' + customerName);
      appName = genApp.Name;

      customerId = genApp.genesis__Account__c;
      spFolderId = genApp.genesis__Account__r.SAF_Sharepoint_Folder_ID__c;

      sharePointResponse = SAF_CreateSharePointController.processSharePoint(customerName, appName, customerId, spFolderId, appId);
    }
    Logger.saveLog();
    return sharePointResponse;
    
  }

  webservice static string getSharepointWebUrl(string siteName, string itemId) {
    String sharePointResponse = '';
    if (siteName != null && itemId != null) {
      sharePointResponse = SAF_CreateSharePointController.getDynamicWebUrl(siteName, itemId);
    }

    return sharePointResponse;
  }
}