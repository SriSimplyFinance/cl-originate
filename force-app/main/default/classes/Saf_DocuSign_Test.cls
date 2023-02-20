@isTest(SeeAllData=True)
public class Saf_DocuSign_Test {
    public with sharing class Saf_DocuSign_Mock1 implements HTTPCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
            res.setBody('body');
            res.setStatusCode(403);
            return res;
        }
    }
    public with sharing class Saf_DocuSign_Mock2 implements HTTPCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
            res.setBody('body');
            res.setStatusCode(200);
            return res;
        }
    }
    public with sharing class Saf_DocuSign_Mock3 implements HTTPCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            res.setHeader('X-AUTH-TOKEN', ''); //for exception handling 
            res.setBody('body');
            res.setStatusCode(500);
            return res;
        }
  }
    @isTest static void GetEnvelopeSenderDetailsTest()
    { 
         Saf_setting__c objSettings = Saf_setting__c.getOrgDefaults();
        objSettings.saf_Docusign_clientid__c='385389435';
        upsert objSettings;       
        String json='{'+
            '"DocusignResponse":{'+  
                               '  "issued_at":"ghsdgh",' +      
                               '  "access_token":"bdhfghfhf",'   +    
                               '  "expires_in":"ryetryueu",'+       
                                '  "refresh_token":"asdadfafs",'+   
                                '  "url":"folders/c6c646a0-4dda-41e7-ae35-007cdcc0b728",'+ 
                                '  "envelopeId":"wiqurewugw",'+    
                                '  "status":"Active"'+
                                             '},'+
              '"DocuSignTemplates":{'+
                    '"envelopeTemplates":[{'+
                              '" templateId":"a15f56f0-8098-4505-99ed-24757392d34e",'+
                              '" name ":"kjhgs",'+
                              '" shared ":"true",'+
                              '" password":"kjhgs",'+
                              '" description":"kjhgs",'+
                              '" lastModified":"2019-08-28T07:34:30.2730000Z",'+
                              '" created":"2019-08-28T07:34:29.0530000Z",'+
                              '" uri":"/templates/a15f56f0-8098-4505-99ed-24757392d34e",'+
                              '" folderName":"Templates",'+
                             '" folderId":"c6c646a0-4dda-41e7-ae35-007cdcc0b728",'+
                              '" folderUri":"/folders/c6c646a0-4dda-41e7-ae35-007cdcc0b728",'+
                             '"owner":{'+
                                     '" userName":"Sumit Kamra",'+
                                      '" userId":"4d684ff2-b36c-422b-ba97-35ea11afa389",'+
                                     '" email":"sumit.kamra@happiestminds.com"'+
                                     '},'+
                         '"emailSubject":"kjhgs",'+
                         '" emailBlurb":"kjhgs",'+
                         '" signingLocation":"Online",'+
                         '" authoritativeCopy":"false",'+
                        '" enforceSignerVisibility":"false",'+
                       '" enableWetSign":"true",'+
                       '" allowMarkup":"false",'+
                      '" allowReassign":"true"'+
                         '}],'+
        '"resultSetSize":"16",'+
        '"startPosition":"0",'+
        '"endPosition":"15",'+
        '"totalSetSize":"16"'+
            '},'+
            '"DocusignEnvelope":{'+
        '                "emailSubject": "EMAIL_SUBJECT",'+
        '                "emailBlurb": "EMAIL_BODY",'+
        '                "status": "created",'+
        '                "compositeTemplates": [{'+
        '                                "serverTemplates": [{'+
        '                                                "sequence": "1",'+
        '                                                "templateId": "869d1c00-b824-4430-b77c-fbf888c62fcf"'+
        '                                }],'+
        '                                "inlineTemplates": [{'+
        '                                                "sequence": "1",'+
        '                                                "recipients": {'+
        '                                                                "signers": [{'+
        '                                                                                "email": "sumit.kamra@happiestminds.com",'+
        '                                                                                "name": "Sumit",'+
        '                                                                                "recipientId": "1",'+
        '                                                                                "roleName": "Signer 1",'+
        '                                                                                "tabs": {'+
        '                                                                                                "textTabs": ['+
        '                                                                                                {'+
        '                                                                                                   "tabLabel": "Guarantor_Name",'+
        '                                                                                                   "value": "Lyncolec Holdings Ltd"'+
                                                                                                           '}]'+   
        '                                                                                }'+
        '                                                                }]'+
        '                                                }'+
        '                                }]'+
        '                }'+
        '                                                                ]'+
            '}'+
        '}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSign_Mock());
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSign_Mock1());
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSign_Mock2());
        Test.setMock(HttpCalloutMock.class, new Saf_DocuSign_Mock3());
        Saf_DocuSign.CreateEnevelope('7612gvashg98');   
        Saf_DocuSign.GetEnvelopeSenderDetails('7612gvashg98');  
        Saf_DocuSign.DocusignEnvelope s1 = Saf_DocuSign.parseEnvelopes(json);
        Saf_DocuSign.DocuSignTemplates s2 = Saf_DocuSign.parseTemplates(json);
        Map<String,String> sss=Saf_DocuSign.GetAllTemplates();
        Test.stopTest();
        }
}