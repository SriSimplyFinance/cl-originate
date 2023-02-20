@isTest
public class Saf_DocuSign_Mock implements HttpCalloutMock
{
    public HTTPResponse respond(HTTPRequest request)
    {
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
        HttpResponse response=new HttpResponse();
        response.setStatus('success');
        response.setStatusCode(200);
        response.setBody(json);      
        response.setHeader('Content-Type','application/json');
        return response;         
    }
}