/*****************************************************************************************************************
*    Class Name        :    Saf_DocuSign
*    Description       :    Class is desgined to deal with Docusign integration
*    Author            :    HappiestMinds
*    Created Date      :    9/03/2019
******************************************************************************************************************/


global class Saf_DocuSign{
    
   /*****************************************
    * Global Constants & Variables
    *****************************************/
    //private static Saf_Experian__c objSettings = Saf_Experian__c.getOrgDefaults();
    Public static Saf_setting__c objSettings = Saf_setting__c.getOrgDefaults();
    private static String clientId;
    private static String clientSecret;
    private static String resource;
    
   
    Public static HttpRequest request;
    Public static HttpResponse response;    
           
    
    /*****************************************************************************************************************
    *    Method Name   :    fetchDocusign
    *    Description   :    Returns a URL to the sender view UI. 
    *    Params        :    NULL
    *    Return Type   :    String
    ******************************************************************************************************************/    
     Public static Map<String,String> GetAllTemplates(){
       
        Map<String,String> MapTempalates = new Map<String,String>();
        Map<String,String> responseMapDetails = new Map<String,String>{};
        String initialResponse = '';
       
              
        //Get named credentials for Experian AccessToken
        String endPointURL = 'callout:Docusign' + '/templates';// '87ea2b9c-1934-4152-9837-2658e38c044c';
        system.debug('endPointURL -------'+endPointURL);
        
        Http httpObj = new Http();
        //Prepare the HTTP request
        HttpRequest req = prepareRequest(httpObj,endPointURL, '', 'GET');
        system.debug('req---------'+req);
        //Get the HTTP response
        Map<String,String> responseMap = fireRequestMap(httpObj,req);
        //System.debug('===='+responseMap);
       
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process response
           DocuSignTemplates objexp = parsetemplates(responseMap.get('SUCCESS'));
         
           if(objexp.totalSetSize !=null){
               initialResponse = objexp.totalSetSize;
               for(Saf_DocuSign.cls_envelopeTemplates objtemp:objexp.envelopeTemplates)
               {                   
                   if(!string.isblank(objtemp.name) ) { MapTempalates.put(objtemp.templateId,objtemp.name); }
               }
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
            
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'Saf_DocuSign', 'GetAllTemplates', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'Docusign Exception in GetAllTemplates method', String.valueOf(responseMap.values()));
            
        }
        
        system.debug('Templates'+MapTempalates);
        return MapTempalates;
    }

    Webservice static String GetEnvelopeSenderDetails(string strEnvelopeId){
       
        
        Map<String,String> responseMapDetails = new Map<String,String>{};
        String initialResponse = '';
       
        String reqbody = '{"returnUrl": "https://www.docusign.com"}'; 
        //Prepare request body
       
        //Get named credentials for Experian AccessToken
        String endPointURL = 'callout:Docusign' + '/envelopes/'+ strEnvelopeId + '/views/sender';// '87ea2b9c-1934-4152-9837-2658e38c044c';
        system.debug('endPointURL -------'+endPointURL);
        
        Http httpObj = new Http();
        //Prepare the HTTP request
        HttpRequest req = prepareRequest(httpObj,endPointURL, reqbody, 'POST');
        system.debug('req---------'+req);
        //Get the HTTP response
        Map<String,String> responseMap = fireRequestMap(httpObj,req);
        System.debug('===='+responseMap);
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process response
           DocusignResponse objexp = processResponse(responseMap.get('SUCCESS'));
         
           if(objexp.url!=null){
               initialResponse = objexp.url;
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
            
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'Saf_DocuSign', 'GetEnvelopeSenderDetails', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'Docusign Exception in GetEnvelopeSenderDetails method', String.valueOf(responseMap.values()));
            
        }
        
        return initialResponse;
    }
  
      
    Webservice static String CreateEnevelope(string strbody){
       
        
        Map<String,String> responseMapDetails = new Map<String,String>{};
        String initialResponse = '';
       
        //        String reqbody = '{'+
//        '                "emailSubject": "EMAIL_SUBJECT",'+
//        '                "emailBlurb": "EMAIL_BODY",'+
//        '                "status": "created",'+
//        '                "compositeTemplates": [{'+
//        '                                "serverTemplates": [{'+
//        '                                                "sequence": "1",'+
//        '                                                "templateId": "869d1c00-b824-4430-b77c-fbf888c62fcf"'+
//        '                                }],'+
//        '                                "inlineTemplates": [{'+
//        '                                                "sequence": "1",'+
//        '                                                "recipients": {'+
//        '                                                                "signers": [{'+
//        '                                                                                "email": "sumit.kamra@happiestminds.com",'+
//        '                                                                                "name": "Sumit",'+
//        '                                                                                "recipientId": "1",'+
//        '                                                                                "roleName": "Signer 1",'+
//        '                                                                                "tabs": {'+
//        '                                                                                                "textTabs": ['+
//        '                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Guarantor_Name",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "Lyncolec Holdings Ltd"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Guarantor_Address",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "22-24 Aston Road,Waterlooville,Hampshire,United Kingdom"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Guarantor_Reg_No_if_applicable_1",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "05519847"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Customer_Name",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "Independent Funding Solutions Limited"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Company_Address",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "C/O Lonsdale & Marsh, 7th Floor, Cotton House, Old Hall,L39 2AB,Merseyside"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Company_Reg_No_if_applicable_2",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "05188722"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Full_Name",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "Sumit Kamra"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                }'+
//        '                                                                                                ]'+
//        '                                                                                }'+
//        '                                                                }]'+
//        '                                                }'+
//        '                                }]'+
//        '                },'+
//        '                {                                                "serverTemplates": [{'+
//        '                                                "sequence": "2",'+
//        '                                                "templateId": "37e0fdb7-835d-41d5-8808-595f023afb5d"'+
//        '                                }],'+
//        '                                "inlineTemplates": [{'+
//        '                                                "sequence": "2",'+
//        '                                                "recipients": {'+
//        '                                                                "signers": [{'+
//        '                                                                                "email": "sumit.kamra@happiestminds.com",'+
//        '                                                                                "name": "Sumit",'+
//        '                                                                                "recipientId": "1",'+
//        '                                                                                "roleName": "Signer 1",'+
//        '                                                                                                "tabs": {'+
//        '                                                                                                "textTabs": ['+
//        '                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Guarantor_Name",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "Lyncolec Holdings Ltd"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Guarantor_Address",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "22-24 Aston Road,Waterlooville,Hampshire,United Kingdom"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Reg_No_if_Applicable_1",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "05519847"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Customer_Name",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "Independent Funding Solutions Limited"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Company_Address",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "C/O Lonsdale & Marsh, 7th Floor, Cotton House, Old Hall,L39 2AB,Merseyside"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Reg_No_if_Applicable_2",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "05188722"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                },'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                {'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "tabLabel": "Agreement_Date",'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                                "value": "10/11/2018"'+
//        '                                                                                                                                                                                                                                                                                                                                                                                                }'+
//        '                                                                                                ]'+
//        '                                                                                }'+
//        '                                                                }'+
//        '                                                ]'+
//        '                                                }'+
//        '                                }]'+
//        '                }'+
//        '                                                                '+
//        '                                                                ]'+
//        '}'+
//        '';  
        //Prepare request body
       
        //Get named credentials for Experian AccessToken
        String endPointURL = 'callout:Docusign' + '/envelopes';// '87ea2b9c-1934-4152-9837-2658e38c044c';
        system.debug('endPointURL -------'+endPointURL);
        
        Http httpObj = new Http();
        system.debug('strbody display:: '+ JSON.serializePretty(strbody));
        //Prepare the HTTP request
        HttpRequest req = prepareRequest(httpObj,endPointURL, strbody, 'POST');
        system.debug('req---------'+req);
        //Get the HTTP response
        Map<String,String> responseMap = fireRequestMap(httpObj,req);
        System.debug('===='+responseMap);
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process response
           DocusignResponse objexp = processResponse(responseMap.get('SUCCESS'));
         
           if(objexp.envelopeId!=null){
               initialResponse = objexp.envelopeId;
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
            
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'Saf_DocuSign', 'CreateEnevelope', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'Docusign Exception in CreateEnevelope method', String.valueOf(responseMap.values()));
            
        }
        
        return initialResponse;
    }  
      //Prepares the request
    public static HttpRequest prepareRequest(Http httpObj,String endPointURL, String requestBody, String method){
        
        httpObj = new Http();
        HttpRequest request = new HttpRequest();
        if(method != 'GET') request.setBody(requestBody);
        request.setMethod(method);
        request.setTimeout(120000);
       
        request.setHeader('Content-Type','application/json');
       
           String Header = '{"Username":"{{username}}","Password":"{{password}}","IntegratorKey": "{{clientId}}"}'; //grant_type=client_credentials&client_id='+clientId+'&client_secret='+clientSecret+'&resource='+resource;
            Header = Header.replace('{{clientId}}',objSettings.saf_Docusign_clientid__c).replace('{{username}}',objSettings.saf_Docusign_Username__c).replace('{{password}}',objSettings.saf_Docusign_Password__c);
        
              system.debug('Header -------'+Header);
              request.setHeader('X-DocuSign-Authentication',Header);
           // request.setHeader('Client_id', objSettings.Client_id__c);
           // request.setHeader('Client_secret', objSettings.Client_secret__c);
           // request.setHeader('accept',  objSettings.content_type__c); 
            //request.setHeader('Content-Type', objSettings.content_type__c);
    
        request.setEndpoint(endPointURL);
        system.debug('request in utility---------------'+request);
        return request;
    }
    
   
      /*****************************************************************************************************************
    *    Method Name   :    fireRequestMap
    *    Description   :    Fires HTTP request and stores the response with SUCCESS/FAILURE
    *    Params        :    HttpRequest request
    *    Return Type   :    Map<String,String>
    ******************************************************************************************************************/        
    
    public static Map<String,String> fireRequestMap(Http httpObj,HttpRequest request){
       Map<String,String> responseMap = new Map<String,String>{};
       HttpResponse response = new HttpResponse();
       
       String fetchedResponse = '';
       try {
             /*system.debug('===fireRequestMap request==='+request.getBody());
             system.debug('===fireRequestMap request==='+request.getHeader('Client_id'));
             system.debug('===fireRequestMap request==='+request.getHeader('Client_secret'));
             system.debug('===fireRequestMap request==='+request.getHeader('Content-Type'));*/
             
            response = httpObj.send(request);
           system.debug('===fireRequestMap==='+response );
            if(response.getStatusCode() == 200){//OK
                responseMap.put('SUCCESS', response.getBody());
                
            }else if(response.getStatusCode() == 201 ){//Created
                responseMap.put('SUCCESS', response.getBody());                
                
            }else{
                responseMap.put('FAILURE', response.getBody());
            }
            
       } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            responseMap.put('FAILURE', e.getMessage());           
       } 
        
       return responseMap;
    }
  
  /*****************************************************************************************************************
    *    Method Name   :    processResponse
    *    Description   :    Process the response returned from HTTP Request and deserialized the reponse
    *    Params        :    String response
    *    Return Type   :    DocusignResponse
    ******************************************************************************************************************/    
        
    public static DocusignResponse processResponse(String response){
     DocusignResponse objResponse = (DocusignResponse)JSON.deserialize(response,DocusignResponse.class);
         if(objResponse !=null){
             return objResponse ;
         }else{
             return null;
         }
    }
    
    /*****************************************************************************************************************
    *    Class Name    :    ExperianResponse
    *    Description   :    Wrapper class specifically for Experian Integration
    ******************************************************************************************************************/        
    
    public class DocusignResponse{

        public String issued_at;
        public String access_token;    
        public String expires_in;
        public String token_type;
        public String refresh_token;
        public String url;
        public String envelopeId;
        public String status;

    }
    public class DocusignEnvelope{

    public String emailSubject; //EMAIL_SUBJECT
    public String emailBlurb;   //EMAIL_BODY
    public String status;   //created
    public List<cls_compositeTemplates> compositeTemplates;
    
    }
    public class cls_compositeTemplates {
        public List<cls_serverTemplates> serverTemplates;
        public List<cls_inlineTemplates> inlineTemplates;
    }
   public class cls_serverTemplates {
        public String sequence; //1
        public String templateId;   //869d1c00-b824-4430-b77c-fbf888c62fcf
    }
    public class cls_inlineTemplates {
        public String sequence; //1
        public cls_recipients recipients;
        public cls_customFields customFields;
    }
    
    public class cls_recipients {
        public List<cls_signers> signers;
        
    }
    public class cls_customFields{
        public List<cls_textCustomFields> textCustomFields;
        
    }
    public class cls_textCustomFields{
        public String name;
        public String value;
        public Boolean show;
        public Boolean required;
    }
    public class cls_signers {
        public String email;    //sumit.kamra@happiestminds.com
        public String name; //Sumit
        public String recipientId;  //1
        public String roleName; //Signer 1
        public String accessCode;
        public String routingOrder;
        
        public cls_tabs tabs;
    }
    
   public class cls_tabs {
        public List<cls_textTabs> textTabs;
    }
   public class cls_textTabs {
        public String tabLabel; //Guarantor_Name
        public String value;    //Lyncolec Holdings Ltd
    }
   
    public static DocusignEnvelope parseEnvelopes(String json){
        return (DocusignEnvelope) System.JSON.deserialize(json, DocusignEnvelope.class);
    }

    public class DocuSignTemplates{
        public List<cls_envelopeTemplates> envelopeTemplates;
        public String resultSetSize;    //16
        public String startPosition;    //0
        public String endPosition;  //15
        public String totalSetSize; //16
    }
        public class cls_envelopeTemplates {
            public String templateId;   //a15f56f0-8098-4505-99ed-24757392d34e
            public String name; //
            public String shared;   //true
            public String password; //
            public String description;  //
            public String lastModified; //2019-08-28T07:34:30.2730000Z
            public String created;  //2019-08-28T07:34:29.0530000Z
            public String uri;  ///templates/a15f56f0-8098-4505-99ed-24757392d34e
            public String folderName;   //Templates
            public String folderId; //c6c646a0-4dda-41e7-ae35-007cdcc0b728
            public String folderUri;    ///folders/c6c646a0-4dda-41e7-ae35-007cdcc0b728
            public cls_owner owner;
            public String emailSubject; //
            public String emailBlurb;   //
            public String signingLocation;  //Online
            public String authoritativeCopy;    //false
            public String enforceSignerVisibility;  //false
            public String enableWetSign;    //true
            public String allowMarkup;  //false
            public String allowReassign;    //true
        }
       public class cls_owner {
            public String userName; //Sumit Kamra
            public String userId;   //4d684ff2-b36c-422b-ba97-35ea11afa389
            public String email;    //sumit.kamra@happiestminds.com
        }
        public static DocuSignTemplates parseTemplates(String json){
            return (DocuSignTemplates) System.JSON.deserialize(json, DocuSignTemplates.class);
        }
    
}