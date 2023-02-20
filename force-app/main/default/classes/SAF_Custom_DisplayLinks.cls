global with sharing class SAF_Custom_DisplayLinks 
{
webservice static void displayLinksCustom(String fileReturnUrl, String url, String appId)
{
    string ListfolderSpID;
    if(url!=null)
    {
        system.debug('fileReturnUrl---------- ## '+fileReturnUrl);
        system.debug('URL---------- ## '+url);
        ListfolderSpID = SAF_CreateSharePointController.getFileDriveId(url);
        List<String> urlRes = url.split('###', 2);
        url = urlRes[0];
        system.debug('Customer Folder ListfolderSpID ## '+ListfolderSpID);
   }
    String customerName;
    String inLifeVal;
    String inProposalVal;
    String filePathTransact;
    String inTransactVal;   
    String inThirdPartyVal;
    String filePathThirdParty;
    String filePathInLife;
    String filePathProposal;
    String AgreementNo;
    
    String appName; 
    String sharePointResponse = url;   
    genesis__Application_Document_Category__c appDocId;
    SAF_Document_Links__c fileRecord;
    String msFiles;
    SFDCSharepointFileUpload__c spFileUpload= SFDCSharepointFileUpload__c.getInstance();
     
    if(spFileUpload != null){
        inLifeVal= spFileUpload.In_Life__c;
        inProposalVal= spFileUpload.Proposal__c;
        inTransactVal = spFileUpload.Transact__c;
        inThirdPartyVal = spFileUpload.Third_Party_Documents__c;
        filePathThirdParty = spFileUpload.FilePathForThirdPartyDocs__c;
        filePathInLife = spFileUpload.File_Path_For_ThirdParty_InLife__c;
        filePathProposal = spFileUpload.File_Path_For_ThirdParty_Proposal__c;
        filePathTransact = spFileUpload.File_Path_For_ThirdParty_Transact__c;
        msFiles = spFileUpload.Microsoft_Files__c;
     }  
        string finalUrl = sharePointResponse;
        system.debug('finalUrl -----'+finalUrl);
        String decoded = EncodingUtil.urlDecode(finalUrl, 'UTF-8');
        system.debug('decoded--------'+decoded);
        String str = decoded;
        List<String> strSplit = str.split('/');
        String fileName = str.substring(str.lastIndexOf('/') + 1, str.length());
        system.debug('fileName------------'+fileName);
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
                    if(fileFolder.equals(inTransactVal) || fileFolder.equals(inLifeVal)){
                        if(fileFolder.equals(inLifeVal)){ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inLifeVal,Document_Path__c= decoded,File_Name__c = fileNamMS,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);
                            insert fileRecord;                     
                    }else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name =inTransactVal,Document_Path__c= decoded,File_Name__c = fileNamMS,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);
                           insert fileRecord;     
                    } }else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inThirdPartyVal,Document_Path__c= decoded,File_Name__c = fileNamMS,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);
                        insert fileRecord;    
                    } } } } }     
              
    }else{ 
            if(strSplit.contains('Transact') || strSplit.contains('In Life')){
              if(strSplit.contains('In Life')){fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inLifeVal,Document_Path__c= decoded,File_Name__c = fileName,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID); insert fileRecord;                       
          }else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inTransactVal,Document_Path__c= decoded,File_Name__c = fileName,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Agreement_Number__c = AgreementNo,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID);insert fileRecord; }
     }
     else{ fileRecord = new SAF_Document_Links__c(Application__c = genApp.id, Name = inThirdPartyVal,Document_Path__c= decoded,File_Name__c = fileName,SAF_SP_Customer_Name__c = customerName, SAF_Application_Number__c = appName,SAF_Customer_ID__c = genApp.genesis__Account__c,SAF_Sharepoint_Document_ID__c=ListfolderSpID); insert fileRecord; }            
          }  }catch(Exception e){system.debug(e.getMessage());}
}

webservice static String displayLinksExp(String url,String folderName,String fileNameOriginal)
{
    
    String sharePointResponse = url;    
    SAF_Document_Links__c fileRecord; 
        string finalUrl = sharePointResponse;
        system.debug('finalUrl -----'+finalUrl);
        String decoded = EncodingUtil.urlDecode(finalUrl, 'UTF-8');
        system.debug('decoded--------'+decoded);
        String str = decoded;
        List<String> strSplit = str.split('/');
        //String fileName = strSplit[3];
        String fileName = str.substring(str.lastIndexOf('/') + 1, str.length());
        system.debug('strSplit ------------'+fileName);
        //String result = 'str.link("decoded", "View Document")';
        if(folderName != null && (folderName == 'Proposal' || folderName == 'In Life' || folderName == 'Transact')){
           
             fileRecord = new SAF_Document_Links__c(Name = folderName,Document_Path__c= decoded,File_Name__c = fileNameOriginal);
             insert fileRecord;
             system.debug('appDocIds----------------'+fileRecord);
            
         
       }
       else{
              system.debug('=========== In Third Party ==========');
              
             
              fileRecord = new SAF_Document_Links__c(Name = 'Third Party Document',Document_Path__c= decoded,File_Name__c = fileNameOriginal);
              insert fileRecord;
              system.debug('appDocIds----------------'+fileRecord);
          }   
        
       return null;
}

}