public class SAF_CreateSharePointUtlity{

   /*****************************************
    * Gloabl Constants & Variables
    *****************************************/
        
    private static Http httpObj = new Http();
       
    /*****************************************************************************************************************
    *    Method Name   :    CreateSPFolder
    *    Description   :    Prepares the HTTP request based on the parameters with BLOB
    *    Params        :    String endPointURL, Attachment file, String method
    *    Return Type   :    HTTP Request
    ******************************************************************************************************************/        
    
    public static HttpRequest CreateSPFolder(String endPointURL, String folderName, String method, String authorizationHeader){
       
       //endPointURL = EncodingUtil.urlEncode(endPointURL, 'UTF-8').replaceAll('\\+','%20');
       	String AppId = 'a7F7a0000000OvGEAU';
        String jsonBody = '{"name": "'+folderName+'","folder": {}, "@microsoft.graph.conflictBehavior": "replace"}';
        /* HttpRequest request = new HttpRequest();
        
        request.setMethod(method);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type','application/json');
        request.setHeader('Accept','application/json;odata.metadata=full');
        request.setHeader('Content-Length', String.valueOf(jsonBody.length()));
        request.setBody(jsonBody);
        request.setTimeout(120000);
        request.setEndpoint(endPointURL);
        return request; */
        
        //endPointURL = EncodingUtil.urlEncode(endPointURL, 'UTF-8');     
         
        httpObj = new Http();
        HttpRequest request = new HttpRequest();
        request.setBody(jsonBody);
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
    /* public static HttpRequest prepareRequestxx(String endPointURL, String requestBody, String method, String authorizationHeader){
        httpObj = new Http();
        HttpRequest request = new HttpRequest();
        //request.setBody(requestBody);
        request.setMethod(method);
        request.setTimeout(120000);
        request.setHeader('Accept', 'application/json');
        if(authorizationHeader != ''){
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Content-Type', 'application/json');
            //request.setHeader('Content-Length', '7945');
        }
        
        request.setEndpoint(endPointURL);
        return request;
    }*/
   
    
}