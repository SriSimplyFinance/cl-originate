global with sharing class HPI_FaultcalloutMock implements HTTPCalloutMock{
     global HTTPResponse respond(HTTPRequest req){
       
         string InputSegment = '';
      
        InputSegment = InputSegment+'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        InputSegment = InputSegment+'<soapenv:Body>';
        InputSegment = InputSegment+'<soapenv:Fault>';
        InputSegment = InputSegment+'<faultcode>soapenv:Client</faultcode>';
        InputSegment = InputSegment+'<faultstring>Invalid Request. Please refer to detail section for more information</faultstring>';
        InputSegment = InputSegment+'<detail>';
        InputSegment = InputSegment+'<ns1:HpiSoapFault xmlns:ns1="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
        InputSegment = InputSegment+'<ns1:Error>';
        InputSegment = InputSegment+'<ns1:Code>012</ns1:Code>';
        InputSegment = InputSegment+'<ns1:Description>VRM is invalid</ns1:Description>';
        InputSegment = InputSegment+'</ns1:Error>';
        InputSegment = InputSegment+'<ns1:Error>';
        InputSegment = InputSegment+'<ns1:Code>013</ns1:Code>';
        InputSegment = InputSegment+'<ns1:Description>VIN is invalid</ns1:Description>';
        InputSegment = InputSegment+'</ns1:Error>';
        InputSegment = InputSegment+'</ns1:HpiSoapFault>';
        InputSegment = InputSegment+'</detail>';
        InputSegment = InputSegment+'</soapenv:Fault>';
        InputSegment = InputSegment+'</soapenv:Body>';
        InputSegment = InputSegment+'</soapenv:Envelope>';

       
       DOM.Document doc = new DOM.Document();
            doc.load(InputSegment);
            
        HttpResponse res = new HTTPResponse();
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        res.setBody(InputSegment);
        //res.setBodyDocument(doc);
        res.setStatusCode(500);
        return res;
        
         

          
    }
}