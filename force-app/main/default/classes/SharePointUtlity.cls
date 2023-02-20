/*****************************************************************************************************************
*    Class Name        :    SharePointUtlity
*    Description       :    This is a utilty class dealing with HTTP Request and Response
*    Author            :    HappiestMinds
*    Created Date      :    28/05/2018
*-----------------------------------------------------------------------------------------------------------------  
*        Modification Logs
*-----------------------------------------------------------------------------------------------------------------
*    Modified Date        Developer            Description
*-----------------------------------------------------------------------------------------------------------------
*    28/05/2018        HappiestMinds         Initial version
*    06/06/2018        HappiestMinds         Added functionality to handle request and response
******************************************************************************************************************/

public class SharePointUtlity{

   /*****************************************
    * Gloabl Constants & Variables
    *****************************************/
        
    private static Http httpObj = new Http();
    
    /*****************************************************************************************************************
    *    Method Name   :    prepareRequest
    *    Description   :    Prepares the HTTP request based on the parameters
    *    Params        :    String endPointURL, String requestBody, String method, String authorizationHeader
    *    Return Type   :    HTTP Request
    ******************************************************************************************************************/    
    
    //Prepares the request
    public static HttpRequest prepareRequest(String endPointURL, String requestBody, String method, String authorizationHeader){
        httpObj = new Http();
        HttpRequest request = new HttpRequest();
        request.setBody(requestBody);
        request.setMethod(method);
        request.setTimeout(120000);
        request.setHeader('Accept', 'application/json');
        if(authorizationHeader != ''){
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Content-Length', '7945');
        }
        
        request.setEndpoint(endPointURL);
        return request;
    }
    
    public static HttpRequest SPprepareRequest(String endPointURL, String requestBody, String method, String authorizationHeader){
        httpObj = new Http();
        HttpRequest request = new HttpRequest();
        //request.setBody(requestBody);
        request.setMethod(method);
        request.setTimeout(120000);
        request.setHeader('Accept', 'application/json');
        if(authorizationHeader != ''){
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Content-Type', 'application/json');
           // request.setHeader('Content-Length', '7945');
        }
        if(requestBody != ''){
            request.setBody(requestBody);
        }
        
        request.setEndpoint(endPointURL);
        return request;
    }
    
    /*****************************************************************************************************************
    *    Method Name   :    prepareRequestWithBlob
    *    Description   :    Prepares the HTTP request based on the parameters with BLOB
    *    Params        :    String endPointURL, Attachment file, String method
    *    Return Type   :    HTTP Request
    ******************************************************************************************************************/        
    
    public static HttpRequest prepareRequestWithBlob(String endPointURL, Attachment file, String method){
       
        String fileByteSize = String.valueOf(file.BodyLength-1)+'/'+String.valueOf(file.BodyLength);
        HttpRequest request = new HttpRequest();
        if (Limits.getHeapSize() < Limits.getLimitHeapSize()){
        request.setMethod(method);
        request.setHeader('Content-Type','application/json');
        request.setHeader('Accept','application/json;odata.metadata=full');
        request.setHeader('Content-Length', String.valueOf(file.BodyLength));
        request.setHeader('Content-Range', 'bytes 0-'+fileByteSize);
        system.debug('request in SPU---------'+request);
         
            
           string fileEncoded = EncodingUtil.base64Encode(file.Body);
      
        Blob bodyBlob = EncodingUtil.base64Decode(fileEncoded);
   
        request.setBodyAsBlob(bodyBlob);
        request.setTimeout(120000);
        request.setEndpoint(endPointURL);
        }else{
            system.debug('Throw custom exception');
        }
        
        return request;
    }
    
    /*****************************************************************************************************************
    *    Method Name   :    fireRequestMap
    *    Description   :    Fires HTTP request and stores the response with SUCCESS/FAILURE
    *    Params        :    HttpRequest request
    *    Return Type   :    Map<String,String>
    ******************************************************************************************************************/        
    
    public static Map<String,String> fireRequestMap(HttpRequest request){
       Map<String,String> responseMap = new Map<String,String>{};
       HttpResponse response = new HttpResponse();
       
       String fetchedResponse = '';
       try {
           system.debug('request :: '+request.getEndpoint());
            response = httpObj.send(request);  
           system.debug('request'+request);
           
           system.debug(response.getStatusCode());
            if(response.getStatusCode() == 200){//OK
                responseMap.put('SUCCESS', response.getBody());
                
            }else if(response.getStatusCode() == 201 ){//Created
                responseMap.put('SUCCESS', response.getBody());                
                
            }else{
                responseMap.put('FAILURE', response.getBody());
            }
            
       } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            responseMap.put('FAILURE', e.getMessage());           
       } 
       
       
       //system.debug('Actual Responses ####'+ responseMap);
          
       return responseMap;
    }

    /*****************************************************************************************************************
    *    Method Name   :    processResponse
    *    Description   :    Process the response returned from HTTP Request and deserialized the reponse
    *    Params        :    String response
    *    Return Type   :    SharePointResponse 
    ******************************************************************************************************************/    
        
    public static SharePointResponse processResponse(String response){
     SharePointUtlity.SharePointResponse sharePointResponse = (SharePointUtlity.SharePointResponse)JSON.deserialize(response,SharePointUtlity.SharePointResponse.class);
         system.debug('***********sharePointResponse*******************'+sharePointResponse);
         if(sharePointResponse!=null){
             return sharePointResponse;
         }else{
             return null;
         }
    }
    
    /*****************************************************************************************************************
    *    Class Name    :    SharePointResponse
    *    Description   :    Wrapper class specifically for Share Point Integration
    ******************************************************************************************************************/        
    public class sharepointIds{
        public string listItemId;
    }

    
    public class SharePointResponse{

        public String id;
        public String access_token;    
        public String uploadUrl;
        public String expirationDateTime;
        public String webUrl;
        public String name;
        public String message;        
        public String error_description;
        public SharePointField fields;
        
        public sharepointIds sharepointIds;

    }
    
    public class SharePointField{
        public String ApplicationID;
    }
}