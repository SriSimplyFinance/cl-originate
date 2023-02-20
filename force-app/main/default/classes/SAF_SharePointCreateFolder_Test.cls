@isTest
 global class SAF_SharePointCreateFolder_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        //System.assertEquals('callout:SharePoint_CreateSession//Test/123/Test.png/method:/createUploadSession', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        
        String body ='{"access_token":"accesstoken09876",'+
           		'"uploadUrl":"Test//123/Test.png",'+
            '"webUrl":"Test//555/testtt.png",'+
            '"name":"Test",'+
            '"error_description":"fake response",'+
            '"message":"Test purpose",'+
            '"id":"0013Y00002hYLpkQAG",'+
            //'"fields":"Test Fields",'+
            '"expirationDateTime":"2019-08-01T15"}';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('X-AUTH-TOKEN', 'uthtoken12345');
        res.setBody(body);
        
        res.setStatusCode(200);
        return res;
    }

}