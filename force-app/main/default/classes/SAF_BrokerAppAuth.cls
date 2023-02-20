Public class SAF_BrokerAppAuth
{
    Public static SAF_BrokerApp__c objSettings =  SAF_BrokerApp__c.getOrgDefaults();
     
    public static string BrokerAppAccessToken = '';
    public static integer RetryToken =1;
    //public static boolean TokenExpired;
    
     public static string fetchBrokerAppAccessToken(boolean IsTokenExpired)
     {
    
        String initialResponse = '';
        Http httpObj = new Http();
        string strrespHeader;
        string requestBody = '{"userName":"' +objSettings.UserName__c+ '","password":"' +objSettings.Password__c+ '"}' ;
        
        if((objSettings.AccessToken__c == null && BrokerAppAccessToken == '') || (IsTokenExpired && BrokerAppAccessToken != ''))
        {
        
            system.debug('inside fetchBrokerAppAccessToken: '+ IsTokenExpired);
            HttpRequest request = new HttpRequest();
            request.setBody(requestBody );
            system.debug('requestBody ---------------'+requestBody);
            request.setMethod('POST');
            
            request.setHeader('Content-Type','application/json');
            request.setHeader('Accept','application/json');
            
             request.setEndpoint(objSettings.LoginURL__c); //http://51.132.26.170:9091/api/login
             system.debug('request in utility---------------'+request);
             HttpResponse response = new HttpResponse();
             
             //Get the HTTP response
             response = httpObj.send(request);
            
            if(response.getStatusCode() == 200)
            {
            
                strrespHeader = response.getHeader('X-AUTH-TOKEN');
                system.debug('===strrespHeader ==='+strrespHeader);
            }
             //Validate response
            if(strrespHeader != ' ' && strrespHeader != null)
            {
                initialResponse = strrespHeader;
                 RetryToken = RetryToken + 1;
                
            }  
            else{
                initialResponse = 'ERROR';
                 RetryToken =0;
                /* ErrorLogsUtils.createErrorLogs('', 'SAF_BrokerAppAuth', 'fetchBrokerAppAccessToken', String.valueOf(response.keyset()),'', 
                String.valueOf(request), String.valueOf(response.values()), true, ErrorLogsUtils.ERROR, true, 
                'SAF_BrokerAppAuth Exception in fetchBrokerAppAccessToken method', String.valueOf(response.values())); */
            }
            BrokerAppAccessToken = initialResponse;
        }
        else
        {
            if(objSettings.AccessToken__c != '') 
             initialResponse = objSettings.AccessToken__c;
             system.debug('initialResponse '+initialResponse ); 
        }
        return initialResponse;
        
    }
}