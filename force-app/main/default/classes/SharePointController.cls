/*****************************************************************************************************************
*    Class Name        :    SharePointController
*    Description       :    Class is desgined to deal with SharePoint integration essentially does file upload
*    Author            :    HappiestMinds
*    Created Date      :    28/05/2018
*-----------------------------------------------------------------------------------------------------------------  
*        Modification Logs
*-----------------------------------------------------------------------------------------------------------------
*    Modified Date        Developer            Description
*-----------------------------------------------------------------------------------------------------------------
*    28/05/2018        HappiestMinds         Initial version
*    06/06/2018        HappiestMinds         Added functionality to deal with Share Point file processing
******************************************************************************************************************/


global class SharePointController{
    
   /*****************************************
    * Gloabl Constants & Variables
    *****************************************/
    
    private static String clientId;
    private static String clientSecret;
    private static String resource;
    
    private static SharePointUtlity.SharePointResponse sharePointResponse;
    private static HttpRequest request;
    private static HttpResponse response;    
    
    
    /*****************************************************************************************************************
    *    Method Name   :    init
    *    Description   :    Initialiser of Share Point credentials
    *    Params        :    NULL
    *    Return Type   :    Void
    ******************************************************************************************************************/
    
    private static void init(){
        //Load credentials from custom setting
        SFDCSharepointFileUpload__c sharePointCS = SFDCSharepointFileUpload__c.getOrgDefaults();
            clientId  = sharePointCS.Client_Id__c;
            clientSecret  = sharePointCS.Client_Secret__c;
            resource  = sharePointCS.Resource__c;
    }
    
    /*****************************************************************************************************************
    *    Method Name   :    fetchSharePointAccessToken
    *    Description   :    Does the initial task of getting the acess token from SharePoint
    *    Params        :    NULL
    *    Return Type   :    String
    ******************************************************************************************************************/    
    
    public static String fetchSharePointAccessToken(){
        //Get the credentials 
        init();
        
        Map<String,String> responseMapDetails = new Map<String,String>{};
        String initialResponse = '';
        
        //Prepare request body
        String reqbody = 'grant_type=client_credentials&client_id='+clientId+'&client_secret='+clientSecret+'&resource='+resource;
        system.debug('Request Body:'+reqbody);
              
        //Get named credentials for SharePoint AccessToken
        String endPointURL = 'callout:SharePoint_AccessToken';
        system.debug('endpoint url:'+endPointURL);
        
        //Prepare the HTTP request
        HttpRequest req = SharePointUtlity.prepareRequest(endPointURL, reqbody, 'POST', '');
        
        //Get the HTTP response
        Map<String,String> responseMap = SharePointUtlity.fireRequestMap(req);
        
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process respose
           sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));
           
           if(sharePointResponse.access_token!=null){
               initialResponse = sharePointResponse.access_token;
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
            
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'SharePointController', 'fetchSharePointAccessToken', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'SharePointController Exception in fetchSharePointAccessToken method', String.valueOf(responseMap.values()));
            
        }
        
        return initialResponse;
    }
    
    /*****************************************************************************************************************
    *    Method Name   :    createUploadSession
    *    Description   :    Creates a Share Point sessions to initiate file upload
    *    Params        :    String accessToken, String filePathURL, String fileName
    *    Return Type   :    String
    ******************************************************************************************************************/        
    
    public static String createUploadSession(String accessToken, String filePathURL, String fileName){
       
        String initialResponse = '';
        //Get named credentials for SharePoint CreateSession to initiate file upload
        String endPointURL = 'callout:SharePoint_CreateSession/';
        endPointURL += filePathURL+'/';
        endPointURL += fileName+ ':/createUploadSession';

        //Prepare request body
        String reqbody = '{item:{"@microsoft.graph.conflictBehavior":"rename"}}';
        
        String authorizationHeader = 'Bearer ' + accessToken;
        
        //Prepare the HTTP request
        request = SharePointUtlity.prepareRequest(endPointURL, reqbody, 'POST', authorizationHeader);
        
        //Get the HTTP response
        Map<String,String> responseMap = SharePointUtlity.fireRequestMap(request);       
        
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
           //Process respose
           sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));
           
           if(sharePointResponse.uploadUrl != null){
               initialResponse = sharePointResponse.uploadUrl;
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
            
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'SharePointController', 'createUploadSession', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'SharePointController Exception in createUploadSession method', String.valueOf(responseMap.values()));
        }
        
        return initialResponse;
    }
    
    /*****************************************************************************************************************
    *    Method Name   :    uploadFile
    *    Description   :    Uploads file to Share Point
    *    Params        :    String uploadURI & Attachment file
    *    Return Type   :    String
    ******************************************************************************************************************/        
        
    public static String uploadFile(String uploadURI, Attachment file){
        
        String initialResponse = '';
        
        //Prepare request body        
        request = SharePointUtlity.prepareRequestWithBlob(uploadURI, file, 'PUT');
        
        //Get the HTTP response
        Map<String,String> responseMap = SharePointUtlity.fireRequestMap(request);     
          
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process respose
           sharePointResponse = SharePointUtlity.processResponse(responseMap.get('SUCCESS'));
           
           if(sharePointResponse.webUrl != null){
               initialResponse = sharePointResponse.webUrl+'###'+sharePointResponse.id;
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';

            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'SharePointController', 'uploadFile', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'SharePointController Exception in uploadFile method', String.valueOf(responseMap.values()));
        }
        
        return initialResponse;           
    }   
    
}