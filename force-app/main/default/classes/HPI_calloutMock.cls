@isTest
global with sharing class HPI_calloutMock implements HTTPCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
       
        string InputSegment= '<?xml version="1.0" encoding="UTF-8"?>';
        InputSegment= InputSegment+'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        InputSegment= InputSegment+'<soapenv:Body>';
        InputSegment= InputSegment+'<ns1:FinanceAddResponse xmlns:ns1="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
        InputSegment= InputSegment+'<ns1:Success>TRUE</ns1:Success>';
        InputSegment = InputSegment+'</ns1:FinanceAddResponse>';
        InputSegment= InputSegment+'</soapenv:Body>';
        InputSegment= InputSegment+'</soapenv:Envelope>';

       
        DOM.Document doc = new DOM.Document();
            doc.load(InputSegment);
            
        HttpResponse res = new HTTPResponse();
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        res.setBody(InputSegment);
        //res.setBodyDocument(doc);
        res.setStatusCode(200);
        return res;
        
         

          
    }
}