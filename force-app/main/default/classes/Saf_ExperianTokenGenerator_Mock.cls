@isTest
public class Saf_ExperianTokenGenerator_Mock implements HttpCalloutMock
{
    public HTTPResponse respond(HTTPRequest request)      
    {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        String jsonResponse ='{"issued_at" : "12/9/2017" , "access_token" : "DUMMY-ACCESSTOKEN" , "expires_in":"two" , "token_type":"sss" , "refresh_token" : "dummy-api" }';
         //   '{"access_token" : "DUMMY-ACCESSTOKEN"}';
        response.setBody(jsonResponse);
        response.setStatusCode(200);  
        response.setStatus('ok');  
        return response;        
    }
}

    
       
       
       
//'{"issued_at" : "12/9/2017" , "access_token" : "DUMMY-ACCESSTOKEN" , "expires_in":"two" , "token_type":"sss" , "refresh_token" : "dummy-api" }';