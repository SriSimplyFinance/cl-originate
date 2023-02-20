@isTest
global class MockHttpResponseForCreateRealtionship implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('{"results":[{"status":"Not Sent","link":"http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=682&companyNumber=11541440"}]}');
        res.setStatusCode(200);
        res.setStatus('ok');
        return res;
    }
}