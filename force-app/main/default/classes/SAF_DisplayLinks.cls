global with sharing class SAF_DisplayLinks 
{
webservice static void displayLinks(String fileReturnUrl, String url, String appId)
{
    string ListfolderSpID;
    if(url!=null)
    {
        ListfolderSpID = SAF_CreateSharePointController.getFileDriveId(url);
        List<String> urlRes = url.split('###', 2);
        url = urlRes[0];
        system.debug('Customer Folder ListfolderSpID ## '+ListfolderSpID);
   }
    String customerName;
    String inLifeVal;
    String inProposalVal;
    String inThirdPartyVal;
    String filePathThirdParty;
    String filePathInLife;
    String filePathProposal;
    String appName; 
    String AgreementNo;
    String sharePointResponse = url;   
    genesis__Application_Document_Category__c appDocId;
    SAF_Document_Links__c fileRecord;
    String msFiles;
    SFDCSharepointFileUpload__c spFileUpload= SFDCSharepointFileUpload__c.getInstance();
     
    if(spFileUpload != null){
        inLifeVal= spFileUpload.In_Life__c;
        inProposalVal= spFileUpload.Proposal__c;
        inThirdPartyVal = spFileUpload.Third_Party_Documents__c;
        filePathThirdParty = spFileUpload.FilePathForThirdPartyDocs__c;
        filePathInLife = spFileUpload.File_Path_For_ThirdParty_InLife__c;
        filePathProposal = spFileUpload.File_Path_For_ThirdParty_Proposal__c;
        msFiles = spFileUpload.Microsoft_Files__c;
     }  
        string finalUrl = sharePointResponse;
        system.debug('finalUrl -----'+finalUrl);
        String decoded = EncodingUtil.urlDecode(finalUrl, 'UTF-8');
        system.debug('decoded--------'+decoded);
        String str = decoded;
        List<String> strSplit = str.split('/');
        String fileName = str.substring(str.lastIndexOf('/') + 1, str.length());
        //Get Customer Name
        genesis__Applications__c  genApp = [SELECT id,Name, genesis__Account__r.Name,Agreement_No__c FROM genesis__Applications__c where id =:appId limit 1];
        if(genApp  != null){
        customerName = genApp.genesis__Account__r.Name;
        appName = genApp.Name;
        AgreementNo = genApp.Agreement_No__c;
        system.debug('customer name---'+genApp);
        }
        
     try{  
    if(fileName.contains('sourcedoc=')){
        List<String> fileNamList = fileName.split('&');
        for(String eachFileExt : fileNamList){ if(eachFileExt != null){ List<string> fileCheckEquals = eachFileExt.split('='); string fileNamMS = fileCheckEquals.get(1); List<String> msFilesList = msFiles.split(',');
                for(String msFileStr : msFilesList){
                if(fileNamMS.contains(msFileStr)){ string filePathForMS = fileReturnUrl + '/' + fileNamMS; string fileFolder = fileReturnUrl.substring(fileReturnUrl.lastIndexOf('/') + 1);
                    if(fileFolder.equals(inProposalVal) || fileFolder.equals(inLifeVal)){
                        if(fileFolder.equals(inLifeVal)){ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inLifeVal,Document_Path__c= decoded,File_Name__c = fileNamMS,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);
                            insert fileRecord;                     
                    }else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name =inProposalVal,Document_Path__c= decoded,File_Name__c = fileNamMS,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);
                           insert fileRecord;     
                    } }else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inThirdPartyVal,Document_Path__c= decoded,File_Name__c = fileNamMS,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);
                        insert fileRecord;    
                    } } } } }     
              
    }else{ 
            if(strSplit.contains('Proposal') || strSplit.contains('In Life')){
              if(strSplit.contains('In Life')){fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inLifeVal,Document_Path__c= decoded,File_Name__c = fileName,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID); insert fileRecord;                       
          }else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inProposalVal,Document_Path__c= decoded,File_Name__c = fileName,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);insert fileRecord; }
     }
     else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inThirdPartyVal,Document_Path__c= decoded,File_Name__c = fileName,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID); insert fileRecord; }            
          }  }catch(Exception e){system.debug(e.getMessage());}
}

webservice static void populateThirdpartyDocs(string appId){
    system.debug('Calling TPD from Display Links');
    String customerName;
    String inThirdPartyValFiles;
    SFDCSharepointFileUpload__c spFileUpload= SFDCSharepointFileUpload__c.getInstance();
     
    if(spFileUpload != null){        
        inThirdPartyValFiles = spFileUpload.Third_Party_Documents__c;
    }
    genesis__Applications__c  genApp1 = new genesis__Applications__c();
        
    List<genesis__Applications__c>  genAppList = new List<genesis__Applications__c>([SELECT id,Name,genesis__Account__r.Name FROM genesis__Applications__c where id =:appId limit 1]);
    
    if(genAppList.size() > 0){
        customerName = genAppList.get(0).genesis__Account__c;
    }
 
list<SAF_Document_Links__c> genericDocList = [select Application__c,Document_Path__c,File_Name__c,SAF_SP_Customer_Name__c,SAF_Application_Number__c,SAF_Customer_ID__c,SAF_Sharepoint_Document_ID__c,CreatedDate from SAF_Document_Links__c where Application__r.genesis__Account__c=:customerName and Name=:inThirdPartyValFiles order by CreatedDate desc limit 1];
Id recentApplicationId=null;
if(genericDocList.size()>0){ recentApplicationId= genericDocList.get(0).Application__c;
    genericDocList = [select Application__c,Document_Path__c,File_Name__c,SAF_SP_Customer_Name__c,SAF_Application_Number__c,SAF_Customer_ID__c,SAF_Sharepoint_Document_ID__c,CreatedDate from SAF_Document_Links__c where Application__r.genesis__Account__c=:customerName and Name=:inThirdPartyValFiles and Application__c=:recentApplicationId ORDER BY CreatedDate asc limit 500];
    set<string> previousDocumentPathSet = new set<string>(); for(SAF_Document_Links__c rec:genericDocList){ previousDocumentPathSet.add(rec.Document_Path__c); }
   
    if(genericDocList != null && genericDocList.size()>0){
        Datetime recentCreatedDate = genericDocList.get(0).CreatedDate;
        list<SAF_Document_Links__c> genericDocListLastCreated = [select Application__c,Document_Path__c,File_Name__c,SAF_SP_Customer_Name__c,SAF_Application_Number__c,SAF_Customer_ID__c,SAF_Sharepoint_Document_ID__c,CreatedDate from SAF_Document_Links__c where Application__r.genesis__Account__c=:customerName and Name=:inThirdPartyValFiles and Application__c != :recentApplicationId and 
        CreatedDate >= :recentCreatedDate order by CreatedDate desc limit 500];
        if(genericDocListLastCreated != null && genericDocListLastCreated.size()>0){
            for(SAF_Document_Links__c createdRec:genericDocListLastCreated ){ if(!previousDocumentPathSet.contains(createdRec.Document_Path__c)){genericDocList.add(createdRec);
                    previousDocumentPathSet.add(createdRec.Document_Path__c);
                } } } }
    list<SAF_Document_Links__c> docLinksForInsert = new list<SAF_Document_Links__c>();
    for(SAF_Document_Links__c docLinkRec: genericDocList){ SAF_Document_Links__c docRec = new SAF_Document_Links__c(); docRec.Application__c = appId;
        docRec.Name = inThirdPartyValFiles;
        docRec.File_Name__c = docLinkRec.File_Name__c;
        docRec.Document_Path__c = docLinkRec.Document_Path__c;
        docLinksForInsert.add(docRec);
    }
   
    try{
    insert docLinksForInsert;
    }catch(Exception e){
        system.debug(e.getMessage());
    } } } }