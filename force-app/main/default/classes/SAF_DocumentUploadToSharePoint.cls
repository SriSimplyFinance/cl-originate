/*****************************************************************************************************************
*    Class Name        :    SAF_DocumentUploadToSharePoint 
*    Description       :    The class has the functionality to move to file to their respective document Category on upload
*    Author            :    HappiestMinds
*    Created Date      :    24/05/2018
*-----------------------------------------------------------------------------------------------------------------  
*        Modification Logs
*-----------------------------------------------------------------------------------------------------------------
*    Modified Date        Developer            Description
*-----------------------------------------------------------------------------------------------------------------
*    24/05/2018        HappiestMinds         Initial version
*    04/06/2018        HappiestMinds         Added functionality to load all files under third party.
******************************************************************************************************************/

global with sharing Class SAF_DocumentUploadToSharePoint {
         
webservice static List<String> sendApplicationDocToSharePoint(boolean isAppSpecific, Id attchmentId, string appId){
    
    /*****************************************
    * Gloabl Constants & Variables
    *****************************************/ 
    
    boolean isAgreementConverted = false;
    string customerName;
    string filePathUrl;
    String inLifeVal;
    String inProposalVal;
    String inThirdPartyVal;
    string filePathThirdParty;
    String filePathInLife;
    String filePathProposal;
    string accessTokenRes;
    Attachment att;
    DocumentUploadClass attHandler = new DocumentUploadClass();
    List<String> documentInfo= new List<String>{};
    String appName;  
    genesis__AppDocCatAttachmentJunction__c fileRecord;
    genesis__Application_Document_Category__c appDocId;
    SFDCSharepointFileUpload__c spFileUpload= SFDCSharepointFileUpload__c.getInstance();
     
    if(spFileUpload != null){
        inLifeVal= spFileUpload.In_Life__c;
        inProposalVal= spFileUpload.Proposal__c;
        inThirdPartyVal = spFileUpload.Third_Party_Documents__c;
        filePathThirdParty = spFileUpload.FilePathForThirdPartyDocs__c;
        filePathInLife = spFileUpload.File_Path_For_ThirdParty_InLife__c;
        filePathProposal = spFileUpload.File_Path_For_ThirdParty_Proposal__c;
       
     }
     
    
    //Get Customer Name
    genesis__Applications__c  genApp = [SELECT id,Name, genesis__Account__r.Name,Is_Contract_created__c FROM genesis__Applications__c where id =:appId limit 1];
    
    if(genApp  != null){
       
       // string customerName= 'Hello ////////////// Customer %16/07/2018 %2:15 PM \\PK %@ &&&&&&&&SB/UAT';
        customerName= genApp.genesis__Account__r.Name.replaceAll('[|,|.|//\\,||"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"|\\\\|]', '');
        system.debug('customerName:' +customerName);
         
        //customerName = genApp.genesis__Account__r.Name.replace('/','').replace('%','');
        appName = genApp.Name;
        isAgreementConverted = genApp.Is_Contract_created__c;       
    }
    if(isAppSpecific){
    
        if(isAgreementConverted){
           appDocId = [select id from genesis__Application_Document_Category__c where (Name=:inLifeVal and genesis__Application__c =:appId) limit 1];          
           filePathUrl = customerName+'/'+appName+'/'+inLifeVal;
           
          }else{
              appDocId =[select id from genesis__Application_Document_Category__c where (Name=:inProposalVal and genesis__Application__c =:appId) limit 1];
              filePathUrl = customerName+'/'+appName+'/'+inProposalVal;  
          }
     }
     else{
              appDocId =[select id from genesis__Application_Document_Category__c where (Name=:inThirdPartyVal and genesis__Application__c =:appId) limit 1];
              filePathUrl = customerName;
          }
           if(appDocId  != null){
               fileRecord = new genesis__AppDocCatAttachmentJunction__c(genesis__Application_Document_Category__c=appDocId.Id,genesis__AttachmentId__c=attchmentId);
               try{
                   insert fileRecord;
               }catch(Exception e){
                   system.debug('Exception-----'+e.getMessage());
               }
              
               documentInfo.add(filePathUrl);
               documentInfo.add(attchmentId);             
                   
    }
    
    return documentInfo;
    

}

// to populate all the third party documents
webservice static void populateThirdpartyDocs(string appId){
    system.debug('Calling appId from the populating Third party Docs');
    String customerName;
    String inThirdPartyValFiles;
    SFDCSharepointFileUpload__c spFileUpload= SFDCSharepointFileUpload__c.getInstance();
     
    if(spFileUpload != null){        
        inThirdPartyValFiles = spFileUpload.Third_Party_Documents__c;
    }
    genesis__Applications__c  genApp1 = new genesis__Applications__c();
        
    List<genesis__Applications__c>  genAppList = new List<genesis__Applications__c>([SELECT id,Name,genesis__Account__r.Name FROM genesis__Applications__c where id =:appId limit 1]);
    
    if(genAppList.size() > 0){
       // customerName = genAppList.get(0).genesis__Account__r.Id;
        customerName = genAppList.get(0).genesis__Account__c;
        system.debug('customerName ========='+customerName);
    }
    
    map<Id,genesis__Application_Document_Category__c> adcList = new map<Id,genesis__Application_Document_Category__c>([select id,name,genesis__Application__c from genesis__Application_Document_Category__c where genesis__Application__r.genesis__Account__c=:customerName and Name=:inThirdPartyValFiles and genesis__Application__c !=:appId order by CreatedDate desc limit 1]);  
    system.debug('adcList --------'+adcList);
    list<genesis__Application_Document_Category__c> newApplciationADCList = new list<genesis__Application_Document_Category__c>([select id,name,genesis__Application__c from genesis__Application_Document_Category__c where genesis__Application__c=:appId and Name=:inThirdPartyValFiles]);
    genesis__Application_Document_Category__c newApplciationADC = new genesis__Application_Document_Category__c();
    if(newApplciationADCList.size()>0){
        newApplciationADC = newApplciationADCList.get(0);
    }
    Set<id> attachmentIdSet = new set<id>();
    list<genesis__AppDocCatAttachmentJunction__c> juctionList = [select genesis__AttachmentId__c,CreatedDate from genesis__AppDocCatAttachmentJunction__c where genesis__Application_Document_Category__c in :adcList.keySet() order by CreatedDate desc];
    //juctionList = [select genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunction__c where genesis__Application_Document_Category__r.Name=:inThirdPartyValFiles and genesis__Application_Document_Category__r.genesis__Application__r.genesis__Account__c=:customerName and CreatedDate>:juctionList.get(0).CreatedDate];
    system.debug('juctionList --------'+juctionList);
    for(genesis__AppDocCatAttachmentJunction__c rec:juctionList){
    
       attachmentIdSet.add(rec.genesis__AttachmentId__c);
       system.debug('attachmentIdSet------------'+attachmentIdSet);
    }
    list<Attachment> newAttachmentList = new list<Attachment>();
    list<Attachment> perviousAttachments = new list<Attachment>([SELECT Id,ParentId,Body,name,CreatedDate,ContentType FROM Attachment where id in :attachmentIdSet order by CreatedDate desc limit 20]);
    if(juctionList.size()>0){
        juctionList = [select genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunction__c where genesis__Application_Document_Category__r.Name=:inThirdPartyValFiles and genesis__Application_Document_Category__r.genesis__Application__r.genesis__Account__c=:customerName and CreatedDate>:juctionList.get(0).CreatedDate];
         attachmentIdSet.clear();
        for(genesis__AppDocCatAttachmentJunction__c rec:juctionList){       
           attachmentIdSet.add(rec.genesis__AttachmentId__c);
        }
        if(perviousAttachments.size()>0){
           // list<Attachment> perviousAttachmentsFromUpdate = new list<Attachment>([SELECT Id,ParentId,name,ContentType FROM Attachment where id in :attachmentIdSet and CreatedDate>:perviousAttachments.get(0).CreatedDate order by CreatedDate desc limit 20]);
           list<Attachment> perviousAttachmentsFromUpdate = new list<Attachment>([SELECT Id,ParentId,name,ContentType FROM Attachment where id in :attachmentIdSet and CreatedDate>:perviousAttachments.get(0).CreatedDate order by CreatedDate desc limit 20]);
            system.debug('perviousAttachmentsFromUpdate ----------'+perviousAttachmentsFromUpdate);
            for(Attachment att:perviousAttachmentsFromUpdate){perviousAttachments.add(att);}
        } }
    
    for(Attachment atmt : perviousAttachments){ Attachment atmtRec = new Attachment();
        Blob bodyBlob= Blob.valueOf('');
        atmtRec.parentId = appId;
        atmtRec.Body =bodyBlob;
        atmtRec.Name = atmt.name;
        atmtRec.ContentType = atmt.ContentType;
        newAttachmentList.add(atmtRec);
        
    }
    
    try{
        insert newAttachmentList;
    }catch(Exception e){ system.debug(e.getMessage()); }
        
    list<genesis__AppDocCatAttachmentJunction__c> newJuctionList = new list<genesis__AppDocCatAttachmentJunction__c>();
    for(Attachment atmt :newAttachmentList){
        genesis__AppDocCatAttachmentJunction__c adaj = new genesis__AppDocCatAttachmentJunction__c();
        adaj.genesis__AttachmentId__c = atmt.id;
        adaj.genesis__Application_Document_Category__c = newApplciationADC.id;
        newJuctionList.add(adaj);
        system.debug('newJuctionList--------------'+newJuctionList);
    }
    try{
        insert newJuctionList;
    }catch(Exception e){
        system.debug(e.getMessage());
    }
}

webservice static void deleteAttachment(string attId,string appId){

    Attachment attDelete = [select id,name,body from Attachment where id=:attId];
    if(attDelete != null){
        attDelete.Body = null;
    }
    try{
        update attDelete;
    }catch(Exception e){
        system.debug(e.getMessage());
    }
}

webservice static void deleteexpAttachment(string attId){

    Attachment attDelete = [select id,name,body from Attachment where id=:attId];
    if(attDelete != null){
        attDelete.Body = null;
    }
    try{
        update attDelete;
    }catch(Exception e){
        system.debug(e.getMessage());
    }
}
/*webservice static void deleteAttachment(List<string> attId,string appId){
Set<String> deleteAttId = new Set<String>();
for(String deleteAttRec : attId){
    deleteAttId.add(deleteAttRec);
}
    system.debug('attId in delete--------'+attId);
    List<Attachment> attDelete = [select id,name,body from Attachment where id IN :deleteAttId];
    List<Attachment> attDeleteForUpdate = new List<Attachment>();
    for(Attachment att : attDelete){
        system.debug('attDelete-----------'+attDelete);
        if(att != null){
            att.Body = null;
        }
        attDeleteForUpdate.add(att);
    }
    try{
        update attDeleteForUpdate;
    }catch(Exception e){
        system.debug(e.getMessage());
    }
}*/

webservice static boolean attachmentSize(Id attachmentId){
boolean isSizeGreater = false;
    Attachment att = [select id,name,Body from Attachment where id=:attachmentId];
     
      if(Limits.getHeapSize() < Limits.getLimitHeapSize()){
          string fileEncoded = EncodingUtil.base64Encode(att.Body);
          //system.debug('fileEncoded----'+fileEncoded);
          isSizeGreater = true;
          system.debug('fileEncoded----'+isSizeGreater);
      
    }else{
        isSizeGreater = false;
    }
    system.debug('fileEncoded1----'+isSizeGreater);
    return isSizeGreater;
}
}