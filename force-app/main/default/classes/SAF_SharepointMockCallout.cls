public class SAF_SharepointMockCallout {
    
    
    public static HttpResponse getInfoFromExternalService(String endPoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
   
}

}