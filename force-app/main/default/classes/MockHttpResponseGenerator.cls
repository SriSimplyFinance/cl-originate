@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        
        res.setBody('{"results":[{"status":"Not Sent","link":"http://kycapiprod.simply.finance:9090/api/kyc/login"}]}');
        res.setStatusCode(200);
        res.setStatus('ok');
        return res;
    }
}