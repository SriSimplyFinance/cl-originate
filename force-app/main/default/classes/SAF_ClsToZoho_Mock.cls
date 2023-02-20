@isTest
public class SAF_ClsToZoho_Mock implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse ReturnResponse;
        // Create a fake response
         if(request.getEndpoint()=='FAKE_ZOHO_END_POINT')
         {
             HttpResponse response = new HttpResponse();
             response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             String json='{"access_token" : "bc426429ff05e9258ab32f182300efa9.89f6e7470e6a6367b1f6d5126b9efd67"}';       
             response.setBody(json);
             response.setStatusCode(200);
             response.setStatus('ok');
             ReturnResponse=response;             
         }
        else if(request.getEndpoint()=='fail')
         {
             HttpResponse response = new HttpResponse();
             response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             String json='{"access_token" : null}';       
             response.setBody(json);
             response.setStatusCode(401);
             response.setStatus('ERROR');
             ReturnResponse=response;             
         }
        else
        {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            String json='{"access_token" :"null"}';       
            response.setBody(json);
            response.setStatusCode(201);
            response.setStatus('ok');
            ReturnResponse=response;            
       }
        
        return ReturnResponse; 
    }   
}