/*****************************************************************************************************************
 *    Class Name        :    SAF_CreateSharePointController
 *    Description       :    Class is desgined to Create a Folders in SharePoint and also for saving SP Id
 *    Author            :    HappiestMinds
 *    Created Date      :    08/01/2019
 *-----------------------------------------------------------------------------------------------------------------  
 *        Modification Logs
 *-----------------------------------------------------------------------------------------------------------------
 *    Modified Date        Developer            Description
 *-----------------------------------------------------------------------------------------------------------------
 *    08/01/2019        HappiestMinds         Initial version
 *    24/01/2019        HappiestMinds         Added method to process SharePoint integration from SKUID page
 ******************************************************************************************************************/
global without sharing

class SAF_CreateSharePointController {

  private static SharePointUtlity.SharePointResponse sharePointResponse;

  private static HttpRequest request;

  private static HttpResponse response;

  webservice static String processSharePoint(String customerName, string appName, string customerId, string spFolderId,
          string appId) {
    String response = '';
    String ListSpID;
    String appResponse;
    String accessToken = SharePointController.fetchSharePointAccessToken();
    system.debug('Access Token### ' + accessToken);
    if (accessToken != Label.SharePoint_Error_Flag) {
      String endPointURL = 'callout:SharePoint_CreateFolder';
      String topFolderURL = '/drive/root/children';
      String authorizationHeader = 'Bearer ' + accessToken;
      String customerResponse = SAF_CreateSharePointController.CreateFolderinSharePoint(endPointURL + topFolderURL,
              customerName,
              authorizationHeader);
      system.debug('customer Resposne:: ' + customerResponse);
      String endPointURL1 = 'callout:SharePoint_List_ID';
      String topFolderURL1 = '/' + customerResponse + '?$select=sharepointids';
      system.debug('top folder url:' + topFolderURL1);
      if (customerResponse != Label.SharePoint_Error_Flag) {
        ListSpID = SAF_CreateSharePointController.getSpID(accessToken, endPointURL1 + topFolderURL1);
      }
      system.debug('Customer Folder ListSpID ## ' + ListSpID);
      topFolderURL = '/drive/items/' + customerResponse + '/children';

      if (customerResponse != Label.SharePoint_Error_Flag) {
        appResponse = SAF_CreateSharePointController.CreateFolderinSharePoint(endPointURL + topFolderURL,
                appName,
                authorizationHeader);  //Create Folders
      }

      String appFolderID;
      String appFolderUrl = '/' + appResponse + '?$select=sharepointids';
      if (appResponse != Label.SharePoint_Error_Flag) {
        appFolderID = SAF_CreateSharePointController.getSpID(accessToken, endPointURL1 + appFolderUrl);
      }
      system.debug('Application Folder ListSpID ## ' + appFolderID);
      SAF_CreateSharePointController.updateApplicationId(appId, appFolderID, authorizationHeader);

      topFolderURL = '/drive/items/' + appResponse + '/children';
      System.debug('Top folder URL:' + topFolderURL);
      if (appResponse != Label.SharePoint_Error_Flag) {
        response = SAF_CreateSharePointController.CreateFolderinSharePoint(endPointURL + topFolderURL,
                'Transact',
                authorizationHeader);
      }
      String transactFolderID;
      String transactFolderUrl = '/' + response + '?$select=sharepointids';
      if (response != Label.SharePoint_Error_Flag) {
        transactFolderID = SAF_CreateSharePointController.getSpID(accessToken, endPointURL1 + transactFolderUrl);
      }
      system.debug('Transact Folder ListSpID ## ' + transactFolderID);
      SAF_CreateSharePointController.updateApplicationId(appId, transactFolderID, authorizationHeader);
      topFolderURL = '/drive/items/' + appResponse + '/children';
      response = SAF_CreateSharePointController.CreateFolderinSharePoint(endPointURL + topFolderURL,
              'Proposal',
              authorizationHeader);
      String proposalFolderID;
      String proposalFolderUrl = '/' + response + '?$select=sharepointids';
      if (response != Label.SharePoint_Error_Flag) {
        proposalFolderID = SAF_CreateSharePointController.getSpID(accessToken, endPointURL1 + proposalFolderUrl);
      }
      system.debug('Transact Folder ListSpID ## ' + proposalFolderID);
      SAF_CreateSharePointController.updateApplicationId(appId, proposalFolderID, authorizationHeader);
      topFolderURL = '/drive/items/' + appResponse + '/children';
      response = SAF_CreateSharePointController.CreateFolderinSharePoint(endPointURL + topFolderURL,
              'In Life',
              authorizationHeader);
      String inLifeFolderID;
      String inLifeFolderUrl = '/' + response + '?$select=sharepointids';
      if (response != Label.SharePoint_Error_Flag) {
        inLifeFolderID = SAF_CreateSharePointController.getSpID(accessToken, endPointURL1 + inLifeFolderUrl);
      }
      system.debug('Transact Folder ListSpID ## ' + inLifeFolderID);
      SAF_CreateSharePointController.updateApplicationId(appId, inLifeFolderID, authorizationHeader);
      response = SAF_CreateSharePointController.getWebUrl(accessToken, ListSpID);
      if (ListSpID != null) {
        Account a = new Account();
        a.id = customerId;
        a.SAF_Sharepoint_Folder_ID__c = ListSpID;
        update a;
      }
      if (appFolderID != null) {
        genesis__Applications__c genAppList = [SELECT id, Name, genesis__Account__r.SAF_Sharepoint_Folder_ID__c, Sharepoint_FolderID__c, Sharepoint_Transact_FolderID__c, Sharepoint_Proposal_FolderID__c, Sharepoint_InLife_FolderID__c, genesis__Account__c, genesis__Account__r.Name, Is_Contract_created__c FROM genesis__Applications__c where id = :appId limit 1];
        genAppList.Sharepoint_FolderID__c = appFolderID;
        genAppList.Sharepoint_Transact_FolderID__c = transactFolderID;
        genAppList.Sharepoint_Proposal_FolderID__c = proposalFolderID;
        genAppList.Sharepoint_InLife_FolderID__c = inLifeFolderID;
        Update genAppList;

      }

    } else {
      response = accessToken;
    } return response;
  }

  /*****************************************************************************************************************
   *    Method Name   :    CreateFolderinSharePoint
   *    Description   :    Create a Folder in SharePoint 
   *    Params        :    endPointURL,folderName,authorizationHeader
   *    Return Type   :    String
   ******************************************************************************************************************/
  public static String CreateFolderinSharePoint(string endPointURL, string folderName, String authorizationHeader) {

    String initialResponse = '';
    request = SAF_CreateSharePointUtlity.CreateSPFolder(endPointURL, folderName, 'POST', authorizationHeader);
    system.debug('request ::' + request);

    Map<String, String> responseMap = SharePointUtlity.fireRequestMap(request);
    system.debug('responseMap in fireReq-----------' + responseMap);
    if (responseMap.size() > 0 && responseMap.containsKey('SUCCESS')) {

      sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));
      system.debug('sharePointResponse ----------------' + sharePointResponse);

      if (sharePointResponse.id != null) {
        initialResponse = sharePointResponse.id;
      }

    } else {
      initialResponse = 'ERROR';
      ErrorLogsUtils.createErrorLogs('',
              'SAF_CreateSharePointController',
              'CreateFolderinSharePoint',
              String.valueOf(responseMap.keyset()),
              '',
              String.valueOf(request),
              String.valueOf(responseMap.values()),
              true,
              ErrorLogsUtils.ERROR,
              true,
              'SAF_CreateSharePointController Exception in CreateFolderinSharePoint method',
              String.valueOf(responseMap.values()));
    }

    return initialResponse;
  }

  /*****************************************************************************************************************
   *    Method Name   :    getSpID
   *    Description   :    Return the ID of SharePoint
   *    Params        :    accessToken,endPointURL
   *    Return Type   :    String
   ******************************************************************************************************************/
  public static String getSpID(String accessToken, String endPointURL) {

    String initialResponse = '';
    String reqbody = '';

    String authorizationHeader = 'Bearer ' + accessToken;
    request = SharePointUtlity.SPprepareRequest(endPointURL, reqbody, 'GET', authorizationHeader);
    Map<String, String> responseMap = SharePointUtlity.fireRequestMap(request);

    if (responseMap.size() > 0 && responseMap.containsKey('SUCCESS')) {

      sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));
      if (sharePointResponse.sharepointIds != null && sharePointResponse.sharepointIds.listItemId != null) {
        initialResponse = sharePointResponse.sharepointIds.listItemId;
      }

    } else {

      initialResponse = 'ERROR';
      ErrorLogsUtils.createErrorLogs('',
              'SAF_CreateSharePointController',
              'getSpID',
              String.valueOf(responseMap.keyset()),
              '',
              String.valueOf(request),
              String.valueOf(responseMap.values()),
              true,
              ErrorLogsUtils.ERROR,
              true,
              'SAF_CreateSharePointController Exception in getSpID method',
              String.valueOf(responseMap.values()));
    }

    return initialResponse;
  }

  public static String getFileDriveId(String url) {

    String initialResponse = '';
    List<String> urlRes = url.split('###', 2);
    url = urlRes[0];
    system.debug('### URL: ' + urlRes);
    String fileDriveId = urlRes[1];
    String endPointURL = 'callout:SharePoint_List_ID';
    String topFolderURL = '/' + fileDriveId + '?$select=sharepointids';
    String accessToken = SharePointController.fetchSharePointAccessToken();
    String ListFolderID = SAF_CreateSharePointController.getSpID(accessToken, endPointURL + topFolderURL);

    system.debug('List Drive Id ##' + ListFolderID);

    return ListFolderID;
  }

/*webservice static String getWebUrlFromID(String spId) {
    String accessToken = SharePointController.fetchSharePointAccessToken();
    return SAF_CreateSharePointController.getWebUrl(accessToken, spId);
  }*/

  public static String getDynamicWebUrl(String siteName, String spId) {

    String accessToken = SharePointController.fetchSharePointAccessToken();
    String initialResponse = '';
    String endPointURL = '';
    String topFolderItemUrl = '/items/' + spId;
    String reqbody = '';
    String authorizationHeader = 'Bearer ' + accessToken;
    if (siteName != null && spId != null) {
      if (siteName == 'CLO-Production' || siteName == 'CLO-Test') {
        endPointURL = 'callout:SharePoint_CreateFolder';
      } else {
        if (siteName.contains('-')) {
          siteName.replace('-', '_');
        }
        endPointURL = 'callout:' + siteName;
      }


      Logger.debug('endpoint URL :: ' + endPointURL + topFolderItemUrl);
      request = SharePointUtlity.SPprepareRequest(endPointURL + topFolderItemUrl, reqbody, 'GET', authorizationHeader);
      Map<String, String> responseMap = SharePointUtlity.fireRequestMap(request);
      Logger.debug('response' + response);
      if (responseMap.size() > 0 && responseMap.containsKey('SUCCESS')) {
        sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));


        if (sharePointResponse.webUrl != null) {
          initialResponse = sharePointResponse.webUrl;
        }

      } else {
        initialResponse = 'ERROR';
        ErrorLogsUtils.createErrorLogs('',
                'SAF_CreateSharePointController',
                'getSpID',
                String.valueOf(responseMap.keyset()),
                '',
                String.valueOf(request),
                String.valueOf(responseMap.values()),
                true,
                ErrorLogsUtils.ERROR,
                true,
                'SAF_CreateSharePointController Exception in getSpID method',
                String.valueOf(responseMap.values()));
      }
    }
    Logger.saveLog();
    return initialResponse;
    
  }

  public static String getWebUrl(String accessToken, String spId) {

    String initialResponse = '';
    String endPointURL = 'callout:SharePoint_CreateFolder';
    String topFolderItemUrl = '/items/' + spId;
    String reqbody = '';
    String authorizationHeader = 'Bearer ' + accessToken;

    system.debug('endpoint URL :: ' + endPointURL + topFolderItemUrl);
    request = SharePointUtlity.SPprepareRequest(endPointURL + topFolderItemUrl, reqbody, 'GET', authorizationHeader);
    Map<String, String> responseMap = SharePointUtlity.fireRequestMap(request);
    system.debug('response' + response);
    if (responseMap.size() > 0 && responseMap.containsKey('SUCCESS')) {
      sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));
      if (sharePointResponse.webUrl != null) {
        initialResponse = sharePointResponse.webUrl;
      }

    } else {
      initialResponse = 'ERROR';
      ErrorLogsUtils.createErrorLogs('',
              'SAF_CreateSharePointController',
              'getSpID',
              String.valueOf(responseMap.keyset()),
              '',
              String.valueOf(request),
              String.valueOf(responseMap.values()),
              true,
              ErrorLogsUtils.ERROR,
              true,
              'SAF_CreateSharePointController Exception in getSpID method',
              String.valueOf(responseMap.values()));
    }

    return initialResponse;
  }

  public static String updateApplicationId(String appId, String appFolderId, String authorizationHeader) {

    String initialResponse = '';
    String endPointURL = 'callout:SharePoint_CreateFolder';
    String topFolderItemUrl = '/items/' + appFolderId;
    String reqbody = '{"fields": { "ApplicationID": "' + appId + '" } }';

    request = SharePointUtlity.SPprepareRequest(endPointURL + topFolderItemUrl, reqbody, 'PATCH', authorizationHeader);

    Map<String, String> responseMap = SharePointUtlity.fireRequestMap(request);
    system.debug('response' + response);
    if (responseMap.size() > 0 && responseMap.containsKey('SUCCESS')) {
      sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));


      if (sharePointResponse.fields != null && sharePointResponse.fields.ApplicationID != null) {
        initialResponse = sharePointResponse.webUrl;
      }

    } else {
      initialResponse = 'ERROR';
      ErrorLogsUtils.createErrorLogs('',
              'SAF_CreateSharePointController',
              'getSpID',
              String.valueOf(responseMap.keyset()),
              '',
              String.valueOf(request),
              String.valueOf(responseMap.values()),
              true,
              ErrorLogsUtils.ERROR,
              true,
              'SAF_CreateSharePointController Exception in getSpID method',
              String.valueOf(responseMap.values()));
    }

    return initialResponse;
  }

}