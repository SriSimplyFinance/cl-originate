trigger SAF_AppStatusforDocusign on dsfs__DocuSign_Status__c (before insert,before update) {
        system.debug('SAF_AppStatusforDocusign : ');
        Map<string,string> Ids = new Map<string,string>();
        string ApplicationId;
       
      // if(HelperClass3.firstRun){
     
        for(dsfs__DocuSign_Status__c objbill:Trigger.New){
              //For loop for fetching the ID's
              if(trigger.isUpdate)
              {
               
                    dsfs__DocuSign_Status__c oldbill = Trigger.oldMap.get(objbill.Id);
                    string oldvalue = oldbill.dsfs__Envelope_Status__c ;
                    string NewValue = objbill.dsfs__Envelope_Status__c;
                    system.debug('oldvalue : ' + oldvalue);
                    system.debug('NewValue : ' + NewValue);
                    if(oldvalue != NewValue && NewValue == 'Completed')
                    { 
                        
                       Ids.put(objbill.dsfs__DocuSign_Envelope_ID__c,objbill.dsfs__Envelope_Status__c);
                       System.debug('objbill.Id: ' + objbill.Id);
                       //lstdatesOther.add(objbill.cllease__Transaction_Date__c);
                      
                    }
              }
              if(trigger.isInsert)
              {
                
              }
            }
   
     
      
       for(Saf_Docusign_Application__c obj: [select Id,Name,saf_Application__c from Saf_Docusign_Application__c where saf_EnvelopeId__c In: Ids.keyset()]){
              //For loop for fetching the ID's
          
              System.debug('obj.saf_Application__c: ' + obj.saf_Application__c);
              SAF_ValidateApplication.ValidateDocumentCollected(obj.saf_Application__c);
              break;
            }
     
    }