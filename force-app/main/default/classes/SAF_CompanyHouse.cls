Public class SAF_CompanyHouse
{
    Public static Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
     
    public static string KycAccessToken = '';
    public static integer RetryToken =1;
    //public static boolean TokenExpired;
    
     public static string fetchKycAccessToken(boolean IsTokenExpired)
     {
    
        String initialResponse = '';
        Http httpObj = new Http();
        string requestBody = '{"username":"' +objSettings.Username__c+ '","password":"' +objSettings.Password__c+ '"}' ;
        
        if((objSettings.AccessToken__c == null && KycAccessToken == '') || (IsTokenExpired && KycAccessToken != ''))
        {
        
            system.debug('inside fetchaccesstoken: '+ IsTokenExpired);
            HttpRequest request = new HttpRequest();
            request.setBody(requestBody );
            system.debug('requestBody ---------------'+requestBody);
            request.setMethod('POST');
            
            request.setHeader('Content-Type','application/json');
            request.setHeader('Accept','application/json');
            
             request.setEndpoint(objSettings.LoginURL__c); //http://kycapiprod.simply.finance:9090/api/kyc/login
             system.debug('request in utility---------------'+request);
             HttpResponse response = new HttpResponse();
            
             //Get the HTTP response
             Map<String,String> responseMap = fireRequestMap(httpObj,request);
             
             //Validate response
             if(responseMap.size()>0 && responseMap.containsKey('SUCCESS'))
             {
        
                //Process response
                KYCAccessResponse objexp = processResponse(responseMap.get('SUCCESS')); 
                RetryToken = RetryToken + 1;
             
                if(objexp.access_token!=null){
                initialResponse = objexp.access_token;
               }
             }
             else
             {
                 //Handle exception/errors
                 initialResponse = 'ERROR';
                 RetryToken =0;
                 //Create Error logs and send mail to admin
                ErrorLogsUtils.createErrorLogs('', 'SAF_CompanyHouse', 'fetchKycAccessToken', String.valueOf(responseMap.keyset()),'', 
                String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
                'SAF_CompanyHouse Exception in fetchKycAccessToken method', String.valueOf(responseMap.values()));
                
             }
             system.debug('initialResponseeeeeeeeeeeeeee'+initialResponse);
             KycAccessToken = initialResponse;
        }
    
        else
         {
             if(objSettings.AccessToken__c != '') 
             KycAccessToken = objSettings.AccessToken__c;
             system.debug('KycAccessToken '+KycAccessToken ); 
         }

        return KycAccessToken;  
     }
     
      /*****************************************************************************************************************
        *    Method Name   :    fireRequestMap
        *    Description   :    Fires HTTP request and stores the response with SUCCESS/FAILURE
        *    Params        :    HttpRequest request
        *    Return Type   :    Map<String,String>
      ******************************************************************************************************************/ 
     public static Map<String,String> fireRequestMap(Http httpObj,HttpRequest request)
     {
         
         Map<String,String> responseMap = new Map<String,String>{};  
             
             HttpResponse response = new HttpResponse();
   
         String fetchedResponse = '';
         try 
         {
             response = httpObj.send(request);
             system.debug('===fireRequestMap==='+response );
             if(response.getStatusCode() == 200) //OK
             {
                 string strbodyresp = response.getbody();
                 responseMap.put('SUCCESS', strbodyresp );
                 system.debug('===strbodyresp ==='+strbodyresp);
             }  
             else if(response.getStatusCode() == 201 ) //Created
             {
                responseMap.put('SUCCESS', response.getBody());   
             }
             else
             {
                responseMap.put('FAILURE', response.getBody());
             }  
         } 
         catch(System.CalloutException e) 
         {
             System.debug('Callout error: '+ e);
             responseMap.put('FAILURE', e.getMessage());           
         } 
        
       return responseMap;
     
     }
     
     public static KYCAccessResponse processResponse(string response)
     {
         KYCAccessResponse objResponse = (KYCAccessResponse)JSON.deserialize(response,KYCAccessResponse.class);
         if(objResponse !=null)
         {
             return objResponse ;
         }
         else
         {
             return null;
         }
     }
     
     //Description   :    Wrapper class specifically for kyc Integration
       public class KYCAccessResponse{

        public Integer expires_in_sec;
        public string access_token;    
        public String api_domain;
        public String token_type;
        public Integer expires_in;
      

    }
          
}