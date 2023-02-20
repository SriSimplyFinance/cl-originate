@isTest
global class HPIParserMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           webservicesHpiCoUkFinanceReg.UpdateResponseType response_x = new  webservicesHpiCoUkFinanceReg.UpdateResponseType();
  
        string res = '';
        /*res = res+'<?xml version="1.0" encoding="UTF-8"?>';
        res = res+'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        res = res+'<soapenv:Body>';
        res = res+'<ns1:FinanceAddResponse xmlns:ns1="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
        res = res+'<ns1:Success>TRUE</ns1:Success>';
        res = res+'</ns1:FinanceAddResponse>';
        res = res+'</soapenv:Body>';
        res = res+'</soapenv:Envelope>';*/
        res = res+'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        res = res+'<soapenv:Body>';
        res = res+'<soapenv:Fault>';
        res = res+'<faultcode>soapenv:Client</faultcode>';
        res = res+'<faultstring>Invalid Request. Please refer to detail section for more information</faultstring>';
        res = res+'<detail>';
        res = res+'<ns1:HpiSoapFault xmlns:ns1="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
        res = res+'<ns1:Error>';
        res = res+'<ns1:Code>012</ns1:Code>';
        res = res+'<ns1:Description>VRM is invalid</ns1:Description>';
        res = res+'</ns1:Error>';
        res = res+'<ns1:Error>';
        res = res+'<ns1:Code>013</ns1:Code>';
        res = res+'<ns1:Description>VIN is invalid</ns1:Description>';
        res = res+'</ns1:Error>';
        res = res+'</ns1:HpiSoapFault>';
        res = res+'</detail>';
        res = res+'</soapenv:Fault>';
        res = res+'</soapenv:Body>';
        res = res+'</soapenv:Envelope>';
            
                        
        //response_x.Success = res;
        Dom.Document doc = new Dom.Document();
        doc.load(res);
        Dom.XMLNode root = doc.getRootElement();
        webservicesHpiCoUkFinanceReg.UpdateResponseType response_node = new webservicesHpiCoUkFinanceReg.UpdateResponseType(root);     
        response_x = response_node;
        response.put('response_x', response_x);
        
        
        /*HPI_Integration.Submit_element eqcan =new HPI_Integration.Submit_element();
         eqcan.populateXmlNode(root); 
        HPI_Integration.STSRequestSoap  eqcan2 =new HPI_Integration.STSRequestSoap();*/
          
   }
}