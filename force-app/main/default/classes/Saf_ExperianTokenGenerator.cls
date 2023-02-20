/*****************************************************************************************************************
*    Class Name        :    Saf_ExperianTokenGenerator
*    Description       :    Class is desgined to deal with Experian integration essentially does file upload
*    Author            :    HappiestMinds
*    Created Date      :    2/07/2019
******************************************************************************************************************/


global class Saf_ExperianTokenGenerator{
    
   /*****************************************
    * Global Constants & Variables
    *****************************************/
    private static Saf_Experian__c objSettings = Saf_Experian__c.getOrgDefaults();
    private static String clientId;
    private static String clientSecret;
    private static String resource;
    
   
    private static HttpRequest request;
    private static HttpResponse response;    
           
    
    /*****************************************************************************************************************
    *    Method Name   :    fetchExperianAccessToken
    *    Description   :    Does the initial task of getting the acess token from Experian
    *    Params        :    NULL
    *    Return Type   :    String
    ******************************************************************************************************************/    
    
    public static String fetchExperianAccessToken(){
       
        
        Map<String,String> responseMapDetails = new Map<String,String>{};
        String initialResponse = '';
        
        //Prepare request body
        String reqbody = '{ "username": "' +objSettings.username__c + '",' + 
        '"password": "' + objSettings.password__c+ '" } '; //grant_type=client_credentials&client_id='+clientId+'&client_secret='+clientSecret+'&resource='+resource;
        system.debug('reqbody -------'+reqbody);
        //Get named credentials for Experian AccessToken
        String endPointURL = 'callout:ExperianUAT_Token';// 'https://uat-uk-api.experian.com/oauth2/v1/token';
        system.debug('endPointURL -------'+endPointURL);
        
        Http httpObj = new Http();
        //Prepare the HTTP request
        HttpRequest req = prepareRequest(httpObj,endPointURL, reqbody, 'POST', 'Token');
        system.debug('req---------'+req);
        //Get the HTTP response
        Map<String,String> responseMap = fireRequestMap(httpObj,req);
        System.debug('===='+responseMap);
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process response
           ExperianResponse objexp = processResponse(responseMap.get('SUCCESS'));
         
           if(objexp.access_token!=null){
               initialResponse = objexp.access_token;
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
            
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'Saf_ExperianTokenGenerator', 'fetchExperianAccessToken', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'ExperianController Exception in fetchExperianAccessToken method', String.valueOf(responseMap.values()));
            
        }
        
        return initialResponse;
    }
    
      //Prepares the request
    public static HttpRequest prepareRequest(Http httpObj,String endPointURL, String requestBody, String method, String authorizationHeader){
        
        httpObj = new Http();
        HttpRequest request = new HttpRequest();
        request.setBody(requestBody);
        request.setMethod(method);
        request.setTimeout(120000);
       
        //request.setHeader('Content-Type','application/x-www-form-urlencoded');
        if(authorizationHeader == 'Token'){
            request.setHeader('Client_id', objSettings.Client_id__c);
            request.setHeader('Client_secret', objSettings.Client_secret__c);
            request.setHeader('accept',  objSettings.content_type__c); 
            request.setHeader('Content-Type', objSettings.content_type__c);
         
        }
        
        request.setEndpoint(endPointURL);
        system.debug('request in utility---------------'+request);
        return request;
    }
    
      /*****************************************************************************************************************
    *    Method Name   :    fireRequestMap
    *    Description   :    Fires HTTP request and stores the response with SUCCESS/FAILURE
    *    Params        :    HttpRequest request
    *    Return Type   :    Map<String,String>
    ******************************************************************************************************************/        
    
    public static Map<String,String> fireRequestMap(Http httpObj,HttpRequest request){
       Map<String,String> responseMap = new Map<String,String>{};
       HttpResponse response = new HttpResponse();
       
       String fetchedResponse = '';
       try {
             /*system.debug('===fireRequestMap request==='+request.getBody());
             system.debug('===fireRequestMap request==='+request.getHeader('Client_id'));
             system.debug('===fireRequestMap request==='+request.getHeader('Client_secret'));
             system.debug('===fireRequestMap request==='+request.getHeader('Content-Type'));*/
             
            response = httpObj.send(request);
           system.debug('===fireRequestMap==='+response );
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
        
       return responseMap;
    }
  
  /*****************************************************************************************************************
    *    Method Name   :    processResponse
    *    Description   :    Process the response returned from HTTP Request and deserialized the reponse
    *    Params        :    String response
    *    Return Type   :    ExperianResponse
    ******************************************************************************************************************/    
        
    public static ExperianResponse processResponse(String response){
     ExperianResponse objResponse = (ExperianResponse)JSON.deserialize(response,ExperianResponse.class);
         if(objResponse !=null){
             return objResponse ;
         }else{
             return null;
         }
    }
    
    /*****************************************************************************************************************
    *    Class Name    :    ExperianResponse
    *    Description   :    Wrapper class specifically for Experian Integration
    ******************************************************************************************************************/        
    
    public class ExperianResponse{

        public String issued_at;
        public String access_token;    
        public String expires_in;
        public String token_type;
        public String refresh_token;
      

    }
}