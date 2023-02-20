//Class Name : HPIIntegration
//Function: This class contains the methods to connect to hpi 
//Created by : Happiest Minds 
//Created Date : 08/17/2018

//Methods Included: Submit
// Primary Port Class Name: STSRequestSoap  
public class HPI_Integration{
    
    //WSDL node {http://schemas.xmlsoap.org/wsdl/}portType expected after message nodes
    public class STSRequestSoap {
        public String endpoint_x = System.Label.HPI_Endpoint;  
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x = Integer.valueof(System.Label.HPI_TimeOut) ;
        private String[] ns_map_type_info = new String[]{endpoint_x,'HPI_Integration'};

       /* public String Submit(String InputSegment,String EFXEnvironment) {
            HPI_Integration.Submit_element request_x = new HPI_Integration.Submit_element();
            HPI_Integration.SubmitResponse_element response_x;
            request_x.InputSegment = InputSegment;
            request_x.EFXEnvironment = EFXEnvironment;
            Map<String, HPI_Integration.SubmitResponse_element> response_map_x = new Map<String, HPI_Integration.SubmitResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl',
                'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl',
                'Submit',
                'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl',
                'SubmitResponse',
                'HPI_Integration.SubmitResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SubmitResult;
        }
        
        private DOM.XmlNode populateDoc(DOM.Document doc,String InputSegment){
            String env = 'http://schemas.xmlsoap.org/soap/envelope/';
            String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
            String xsd = 'http://www.w3.org/2001/XMLSchema';
            String tem = 'http://tempuri.org/';
            
            DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
            envelope.setNamespace('tem', tem);
           //**envelope.setNamespace('xsd', xsd);
            //**envelope.setNamespace('xsi', xsi);
            DOM.XmlNode header = envelope.addChildElement('Header','', '');
            AddHeader(header);
            System.debug(doc.toXmlString());
                            
            Dom.XmlNode body = envelope.addChildElement('Body', env, InputSegment);
           
           System.debug('doc.toXmlString():' + doc.toXmlString());
            return body;
        }

        private void AddHeader(DOM.XmlNode header){
        }*/

        public String Submit_Http(String InputSegment,String EFXEnvironment) {
            DOM.Document doc = new DOM.Document();
            doc.load(InputSegment);

           //** DOM.XmlNode body = populateDoc(doc,InputSegment);
           // DOM.XmlNode methodNode = body.addChildElement('env', InputSegment, '');     
          
              
              
           // **HPI_Integration.Submit_element request_x = new HPI_Integration.Submit_element(InputSegment,EFXEnvironment);
            
            //request_x.populateXmlNode(methodNode);
              System.debug('doc:' + doc);  
              
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint_x);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
            req.setHeader('SOAPAction', System.Label.HPI_FinanceInquiry);//'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1/FinanceEnquiry'
            req.setBodyDocument(doc);
            System.debug('req:' + req.getBody());
            Http http = new Http();
            HTTPResponse res = http.send(req);
                    
            System.debug('resgetStatus:' + res.getStatus() + res.getStatusCode());
            Dom.Document responseDoc = res.getBodyDocument();                                   
            //string s = responseDoc.getRootElement().getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('faultstring',null).getText();
            System.debug('s :' + responseDoc.toXMLstring());            
            Dom.XmlNode rootNode = responseDoc.getRootElement();  
            Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');//'http://schemas.xmlsoap.org/soap/envelope/'
            DOM.XmlNode SubmitResultNode; 
            string noderesult = '';
           
             if(res.getStatusCode() == 200 && EFXEnvironment != 'FinanceAddResponse')
            { 
                Dom.XmlNode SubmitResponseNode = bodyNode.getChildElement(EFXEnvironment,'http://webservices.hpi.co.uk/FinanceRegistrationV1');
                if(SubmitResponseNode == null) {
                    System.debug('bodyNode:' + bodyNode.getText()); 
                    SubmitResultNode  = bodyNode.getChildElement('FinanceCodeResponse','http://webservices.hpi.co.uk/FinanceRegistrationV1'); 
                    noderesult = responseDoc.toXMLstring();
                }
                else
                {
                    if(EFXEnvironment == 'FinanceCodeResponse') {
                      SubmitResultNode = SubmitResponseNode.getChildElement('DescriptionList','http://webservices.hpi.co.uk/FinanceRegistrationV1');
                       noderesult = responseDoc.toXMLstring();
                      }
                    else
                    { SubmitResultNode = SubmitResponseNode.getChildElement('Interest','http://webservices.hpi.co.uk/FinanceRegistrationV1').getChildElement('Identification','http://webservices.hpi.co.uk/FinanceRegistrationV1').getChildElement('AgreementReference','http://webservices.hpi.co.uk/FinanceRegistrationV1');                     
                      noderesult = ' Finance Inquiry Success for :' + responseDoc.toXMLstring(); }    
                 //string SubmitResult = (SubmitResultNode == null) ? null : SubmitResultNode.getText(); 
                   
                }
               
            }
            else if(res.getStatusCode() == 200 && EFXEnvironment == 'FinanceAddResponse')
            {
                Dom.XmlNode SubmitResponseNode = bodyNode.getChildElement(EFXEnvironment,'http://webservices.hpi.co.uk/FinanceRegistrationV1');
                if(SubmitResponseNode == null) {System.debug('bodyNode:' + bodyNode.getText());}
                SubmitResultNode = SubmitResponseNode.getChildElement('Success','http://webservices.hpi.co.uk/FinanceRegistrationV1');     
               // string SubmitResult = (SubmitResultNode == null) ? null : 'Regitration Done :' + SubmitResultNode.getText(); 
               noderesult = ' Regitration Done :';
            }
            else
            {           
                Dom.XmlNode SubmitResponseNode = bodyNode.getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('faultstring',null);
                SubmitResultNode = bodyNode.getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('detail',null);        
                noderesult = (SubmitResponseNode == null) ? null : 'Error Message :' + SubmitResponseNode.getText();            
            }
            HPI_Integration.SubmitResponse_element response_x = new HPI_Integration.SubmitResponse_element(SubmitResultNode);
            
            if(response_x.SubmitResult == null) {response_x.SubmitResult= noderesult; }
            return 'Http Response :'+ res.getStatus() +' - ' + res.getStatusCode() + '\n' + noderesult + response_x.SubmitResult;//res.getBody() ;
        }
    }
  /*  public class Submit_element {
        public String InputSegment;
        public String EFXEnvironment;
        private String[] InputSegment_type_info = new String[]{'InputSegment','https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl','string','0','1','false'};
        private String[] EFXEnvironment_type_info = new String[]{'EFXEnvironment','https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl','true','false'};
        private String[] field_order_type_info = new String[]{'InputSegment','EFXEnvironment'};
        public Submit_element(){
        }
        public Submit_element(String InputSegment,String EFXEnvironment){
            this.InputSegment = InputSegment;
            this.EFXEnvironment = EFXEnvironment;
        }
        public void populateXmlNode(Dom.XmlNode outerNode){
            
            //System.assertEquals('Submit', outerNode.getName());
            Dom.XmlNode InputSegmentNode = outerNode.addChildElement('InputSegment', 'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl', '');
            InputSegmentNode.addTextNode((this.InputSegment == null) ? '' : this.InputSegment);
           //** Dom.XmlNode EFXEnvironmentNode = outerNode.addChildElement('EFXEnvironment', 'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1?wsdl', '');
            //** EFXEnvironmentNode.addTextNode((this.EFXEnvironment == null) ? '' : this.EFXEnvironment);
        }
    }*/
    public class SubmitResponse_element {
        public String SubmitResult;
        private String[] SubmitResult_type_info = new String[]{'SubmitResult',System.Label.HPI_Endpoint,'string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{System.Label.HPI_Endpoint,'true','false'};
        private String[] field_order_type_info = new String[]{'SubmitResult'};
        public SubmitResponse_element(){
        }
        public SubmitResponse_element(DOM.XmlNode responseNode){
            Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
            //System.assertEquals('SubmitResponse', responseNode.getName());
             if(responseNode !=null)
            {
                 DOM.XmlNode SubmitResultNode = responseNode.getChildElement('HpiSoapFault','http://webservices.hpi.co.uk/FinanceRegistrationV1');
                if(SubmitResultNode !=null)
               {
                    DOM.XmlNode SubmitResultNodeCode = SubmitResultNode.getChildElement('Error', 'http://webservices.hpi.co.uk/FinanceRegistrationV1').getChildElement('Code', 'http://webservices.hpi.co.uk/FinanceRegistrationV1');
                    DOM.XmlNode SubmitResultNodeDesc = SubmitResultNode.getChildElement('Error', 'http://webservices.hpi.co.uk/FinanceRegistrationV1').getChildElement('Description', 'http://webservices.hpi.co.uk/FinanceRegistrationV1');
                    this.SubmitResult = (SubmitResultNodeCode == null) ? null : '\n' + 'Error Code: ' + SubmitResultNodeCode.getText() + ' Error Description :' + SubmitResultNodeDesc.getText();
               }
               else
               {
                   
                   this.SubmitResult = (responseNode == null) ? null : responseNode.getText();
               }
            }
           
            //nodesParsed.add(SubmitResultNode2);
            //System.debug(this.SubmitResult);          
        }
    }
}