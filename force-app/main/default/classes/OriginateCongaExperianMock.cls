@isTest
public class OriginateCongaExperianMock implements HttpCalloutMock
{
    public HTTPResponse respond(HTTPRequest req) 
        {   
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/xml');
            response.setBody('Target URL');
            response.setStatusCode(201);
            response.setStatus('success');
            return response;
        }
    }