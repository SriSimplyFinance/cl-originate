Global class OACallout {
    
    public static void CreateAssetIdentity(string VRM,string type){
        //select the Asset, change the input to the asset id
        String search = SearchCallout(VRM,type);
        
        //update the asset with the details provided
    }
     
    Webservice static string SearchCallout(string VRM, string type) {
    system.debug('Incallout'+ VRM);
    
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://api-sandbox.open-assets.co.uk/asset-identity-search');
    req.setMethod('POST');
    req.setHeader('Content-Type','application/json');
    req.setHeader('Accept','application/json');
    req.setHeader('Connection','keep-alive');
    req.setHeader('x-api-key','iT0zP1.QUtZXzE4QTlSREZUMDFfWUVZS1NNLldWTWNpbG1OMDVhZ1RyTTFDTHVYSTJUZHVCWTFPeXdTN0FRcFZmMHIwUVU9');
    req.setHeader('Accept-Encoding','gzip, deflate, br');
    req.setBody('{"primaryIdentifierType":"' + type + '","primaryIdentifierSearchTerm":"'+ VRM +'"}');

    // Send the request, and return a response
    HttpResponse createres = h.send(req);
    string identity = createres.getbody();
    System.debug(identity);
    return identity;   
        //{"id":"e67e2a3e-8db5-4f37-b12e-cec25d3f33fe"}
}
     
 Webservice static string ReportCallout(string repid, string OAID) {
    system.debug('Incallout');
    
       //build endpoint
    string endpointa = 'https://api-sandbox.open-assets.co.uk/assets/';
    string OpenID = OAID;
    string endpointb = '/asset-report-types/';
    string reportType = repid;
    string endpointc = '/input-suggestion';
    string endpointfinal = endpointa + OpenID + endpointb + reportType + endpointc;
    system.debug(endpointfinal);
    
    //build body
    
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointfinal);
    req.setMethod('GET');
    req.setHeader('Content-Type','application/json');
    req.setHeader('Accept','application/json');
    req.setHeader('Connection','keep-alive');
    req.setHeader('x-api-key','iT0zP1.QUtZXzE4QTlSREZUMDFfWUVZS1NNLldWTWNpbG1OMDVhZ1RyTTFDTHVYSTJUZHVCWTFPeXdTN0FRcFZmMHIwUVU9');
    req.setHeader('Accept-Encoding','gzip, deflate, br');

    // Send the request, and return a response
    HttpResponse createres = h.send(req);
    string suggestion= createres.getbody();
    System.debug(suggestion);
    return suggestion;   
        //{"id":"e67e2a3e-8db5-4f37-b12e-cec25d3f33fe"}
}

Webservice static string RunReportCallout(string reqbody, string url) {
    system.debug('Incallout');
       
    //build body
    
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('POST');
    req.setHeader('Content-Type','application/json');
    req.setHeader('Accept','application/json');
    req.setHeader('Connection','keep-alive');
    req.setHeader('x-api-key','iT0zP1.QUtZXzE4QTlSREZUMDFfWUVZS1NNLldWTWNpbG1OMDVhZ1RyTTFDTHVYSTJUZHVCWTFPeXdTN0FRcFZmMHIwUVU9');
    req.setHeader('Accept-Encoding','gzip, deflate, br');
     req.setBody(reqbody);

    // Send the request, and return a response
    HttpResponse createres = h.send(req);
    string report= createres.getbody();
    System.debug(report);
    return report;   
        //{"id":"e67e2a3e-8db5-4f37-b12e-cec25d3f33fe"}
}

}