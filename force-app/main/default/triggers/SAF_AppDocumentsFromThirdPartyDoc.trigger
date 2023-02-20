trigger SAF_AppDocumentsFromThirdPartyDoc on genesis__Application_Document_Category__c (after insert) {
   
    genesis__Application_Document_Category__c applicationsDocCat = trigger.New.get(0);
    SAF_DocumentUploadToSharePoint.populateThirdpartyDocs((string) applicationsDocCat.genesis__Application__c);
}