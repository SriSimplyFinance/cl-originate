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
global class SAF_CreateSharePointController_cust
{
    private static SharePointUtlity.SharePointResponse sharePointResponse;
    private static HttpRequest request;
    private static HttpResponse response; 
    
    
    webservice static String processSharePoint(String customerName,string appName, string customerId,string spFolderId)
    {
        String response = '';   
        String ListSpID;  
        String appResponse;               
        //Invoke SharePoint to get the access token
        String accessToken =  SharePointController.fetchSharePointAccessToken();
        system.debug('Access Token### '+ accessToken);                
        //Validate access token
    if(accessToken != Label.SharePoint_Error_Flag)
    {                    
        String endPointURL = 'callout:SharePoint_CreateFolder';
        //endPointURL += ':/children';
        //endPointURL  = 'https://graph.microsoft.com/v1.0/sites/simplyfinance.sharepoint.com,90d05824-6412-49de-829c-12303bb0ca8f,0aa2e1df-71bf-4209-8038-b00edbc6874d/lists/0e15dcfe-d357-4e35-84e0-724e48b8d55f';
        String topFolderURL='/drive/root/children';
        String authorizationHeader = 'Bearer ' + accessToken;             
        String customerResponse = SAF_CreateSharePointController_cust.CreateFolderinSharePoint(endPointURL+topFolderURL,customerName, authorizationHeader);    
        
        String endPointURL1 = 'callout:SharePoint_List_ID';
        String topFolderURL1 = '/'+customerResponse+'?$select=sharepointids';
      
        //string endPointURL1='https://graph.microsoft.com/v1.0/drives/b!JFjQkBJk3kmCnBIwO7DKj9_hogq_cQlCgDiwDtvGh03-3BUOV9M1ToTgck5IuNVf/items/'+customerResponse+'?$select=sharepointids';
        if(customerResponse!=Label.SharePoint_Error_Flag)
        ListSpID = SAF_CreateSharePointController_cust.getSpID(accessToken,endPointURL1+topFolderURL1);
        system.debug('Customer Folder ListSpID ## '+ListSpID);
        //topFolderURL='/drive/root:/'+customerName+':/children';
        topFolderURL='/drive/items/'+customerResponse+'/children';

        //Create Application
        if(customerResponse!=Label.SharePoint_Error_Flag)
        appResponse = SAF_CreateSharePointController_cust.CreateFolderinSharePoint(endPointURL+topFolderURL,appName, authorizationHeader);  //Create Folders // Deepak Added 
        //appResponse = SAF_CreateSharePointController.CreateFolderinSharePoint(endPointURL+topFolderURL,appName, authorizationHeader);  //Create Folders // Deepak , Why is this using SAF_CreateSharePointController class, is it purposefully used for some reason?
        
        //Create Transact
        //topFolderURL='/drive/root:/'+customerName+':/'+appName+':/children';
        topFolderURL='/drive/items/'+appResponse+'/children';
        if(appResponse!=Label.SharePoint_Error_Flag)
        response  = SAF_CreateSharePointController_cust.CreateFolderinSharePoint(endPointURL+topFolderURL,'Transact', authorizationHeader);
        //Create Proposal
        //topFolderURL='/drive/root:/'+customerName+'/'+appName+':/children';
        topFolderURL='/drive/items/'+appResponse+'/children';
        response = SAF_CreateSharePointController_cust.CreateFolderinSharePoint(endPointURL+topFolderURL,'Proposal', authorizationHeader);
        //Create Third Party
        //topFolderURL='/drive/root:/'+customerName+'/'+appName+':/children';
        topFolderURL='/drive/items/'+appResponse+'/children';
        response = SAF_CreateSharePointController_cust.CreateFolderinSharePoint(endPointURL+topFolderURL,'In Life', authorizationHeader);
       // SAF_CreateSharePointController_cust.doUpdate(customerId,ListSpID);
       /* if(ListSpID!=null)
        {
            Account a = new Account();
            a.id = customerId;
            a.SAF_Sharepoint_Folder_ID__c = ListSpID;
            update a;
        } */
                   
    }
    else
    {
        ListSpID= accessToken;
    }
    return ListSpID;
    }
    /*****************************************************************************************************************
    *    Method Name   :    CreateFolderinSharePoint
    *    Description   :    Create a Folder in SharePoint 
    *    Params        :    endPointURL,folderName,authorizationHeader
    *    Return Type   :    String
    ******************************************************************************************************************/    
    public static String CreateFolderinSharePoint(string endPointURL, string folderName, String authorizationHeader){   
    
         String initialResponse = '';
        //Create customer folder    
        request = SAF_CreateSharePointUtlity.CreateSPFolder(endPointURL, folderName, 'POST', authorizationHeader);
        //Get the HTTP response
        Map<String,String> responseMap = SharePointUtlity.fireRequestMap(request);     
          system.debug('responseMap in fireReq-----------'+responseMap);
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process respose
           sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));
           system.debug('sharePointResponse ----------------'+sharePointResponse);
          /* if(sharePointResponse.webUrl != null){
               initialResponse = sharePointResponse.webUrl;*/
          
          if(sharePointResponse.id != null){
               initialResponse = sharePointResponse.id;
           }
           
        }else{//Handle exception/errors
            initialResponse = 'ERROR'; //Create Error logs and send mail to admin 
            ErrorLogsUtils.createErrorLogs('', 'SAF_CreateSharePointController', 'CreateFolderinSharePoint', String.valueOf(responseMap.keyset()),'', String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 'SAF_CreateSharePointController Exception in CreateFolderinSharePoint method', String.valueOf(responseMap.values()));
        }
        
       // initialResponse = sharePointResponse.id;
        return initialResponse;           
    } 
    /*****************************************************************************************************************
    *    Method Name   :    getSpID
    *    Description   :    Return the ID of SharePoint
    *    Params        :    accessToken,endPointURL
    *    Return Type   :    String
    ******************************************************************************************************************/ 
        public static String getSpID(String accessToken, String endPointURL){
       
        String initialResponse = '';
        //Prepare request body
        String reqbody = '';
        
        String authorizationHeader = 'Bearer ' + accessToken;
        
        //Prepare the HTTP request
        request = SharePointUtlity.SPprepareRequest(endPointURL, reqbody, 'GET', authorizationHeader);
        
        //Get the HTTP response
        Map<String,String> responseMap = SharePointUtlity.fireRequestMap(request);       
        System.debug('Happiestminds responseMap: '+responseMap); // Added to check for test class
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
           //Process respose
           sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));           
           
        //   system.debug('*************sharePointResponse folder ID ********'+sharePointResponse.sharepointIds.listItemId);
           if(sharePointResponse.sharepointIds != null && sharePointResponse.sharepointIds.listItemId!= null){
               initialResponse = sharePointResponse.sharepointIds.listItemId;
               }
           
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
            
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'SAF_CreateSharePointController', 'getSpID', String.valueOf(responseMap.keyset()),'', String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 'SAF_CreateSharePointController Exception in getSpID method', String.valueOf(responseMap.values()));
        }
        
        return initialResponse;
    }
    
    public static String getFileDriveId(String url){
       
        String initialResponse = '';
        List<String> urlRes = url.split('###', 2);
        url = urlRes[0];
        system.debug('### URL: '+urlRes);
        String  fileDriveId = urlRes[1];
        String endPointURL = 'callout:SharePoint_List_ID';
        String topFolderURL = '/'+fileDriveId+'?$select=sharepointids';
    
        //String endPointURL='https://graph.microsoft.com/v1.0/drives/b!JFjQkBJk3kmCnBIwO7DKj9_hogq_cQlCgDiwDtvGh03-3BUOV9M1ToTgck5IuNVf/items/'+fileDriveId+'?$select=sharepointids';
        //Invoke SharePoint to get the access token
        String accessToken =  SharePointController.fetchSharePointAccessToken();
        //String ListFolderID = SAF_CreateSharePointController.getSpID(accessToken,endPointURL+topFolderURL); // Deepak , Why is this using SAF_CreateSharePointController class, is it purposefully used for some reason?
        String ListFolderID = SAF_CreateSharePointController_cust.getSpID(accessToken,endPointURL+topFolderURL); // Deepak Added 
        
        system.debug('List Drive Id ##'+ListFolderID);
    
        return ListFolderID;
    }
    
   
}