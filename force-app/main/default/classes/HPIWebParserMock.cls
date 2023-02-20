@isTest
global class HPIWebParserMock implements WebServiceMock {
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
           webservicesHpiCoUkFinanceReg.FinanceCodeResponseType response_x = new  webservicesHpiCoUkFinanceReg.FinanceCodeResponseType();
  
        string res = '';
        res = res+'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        res = res+'<soapenv:Body>';
        res = res+'<ns1:FinanceCodeResponse xmlns:ns1="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
        res = res+'<ns1:Parameters>';
        res = res+'<ns1:DataType>agreementtype</ns1:DataType>';
        res = res+'</ns1:Parameters>';
        res = res+'<ns1:DescriptionList>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>1</ns1:Code>';
        res = res+'<ns1:Description>Hire Purchase</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>2</ns1:Code>';
        res = res+'<ns1:Description>Conditional Sale</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>3</ns1:Code>';
        res = res+'<ns1:Description>Credit Sale</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>4</ns1:Code>';
        res = res+'<ns1:Description>Lease</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>5</ns1:Code>';
        res = res+'<ns1:Description>Personal Loan</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>6</ns1:Code>';
        res = res+'<ns1:Description>Miscellaneous</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>7</ns1:Code>';
        res = res+'<ns1:Description>Contract Hire</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>8</ns1:Code>';
        res = res+'<ns1:Description>Chattel Mortgage</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>9</ns1:Code>';
        res = res+'<ns1:Description>Personal Contract Plan</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>G</ns1:Code>';
        res = res+'<ns1:Description>Unit Stocking</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>H</ns1:Code>';
        res = res+'<ns1:Description>Demonstrator Stocking</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>M</ns1:Code>';
        res = res+'<ns1:Description>Marine Mortgage</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>P</ns1:Code>';
        res = res+'<ns1:Description>Pre Stocking</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'<ns1:CodeDescription>';
        res = res+'<ns1:Code>Z</ns1:Code>';
        res = res+'<ns1:Description>Miscellaneous, Default</ns1:Description>';
        res = res+'</ns1:CodeDescription>';
        res = res+'</ns1:DescriptionList>';
        res = res+'</ns1:FinanceCodeResponse>';
        res = res+'</soapenv:Body>';
        res = res+'</soapenv:Envelope>';

            
                      
        
        Dom.Document doc = new Dom.Document();
        doc.load(res);
        Dom.XMLNode root = doc.getRootElement();
       
        webservicesHpiCoUkFinanceReg.FinanceCodeResponseType response_node = new webservicesHpiCoUkFinanceReg.FinanceCodeResponseType(root);
         response_x = response_node;
         response.put('response_x', response_x);
        /*HPI_Integration.Submit_element eqcan =new HPI_Integration.Submit_element();
         eqcan.populateXmlNode(root); 
        HPI_Integration.STSRequestSoap  eqcan2 =new HPI_Integration.STSRequestSoap();*/
          
   }
}