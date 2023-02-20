/*****************************************************************************************************************
*    Class Name        :    SAF_DocumentUploadToSharePoint 
*    Description       :    The class has the functionality to move to file to their respective document Category on upload
*    Author            :    HappiestMinds
*    Created Date      :    14/06/2018
*-----------------------------------------------------------------------------------------------------------------  
*        Modification Logs
*-----------------------------------------------------------------------------------------------------------------
*    Modified Date        Developer            Description
*-----------------------------------------------------------------------------------------------------------------
*    14/06/2018        HappiestMinds         Initial version
******************************************************************************************************************/

global Class SAF_Custom_DocumentUploadToSharePoint {
         
webservice static List<String> sendApplicationDocToSharePointCustom(string folderName, Id attchmentId, string appId){
    
    /*****************************************
    * Gloabl Constants & Variables
    *****************************************/ 
    string customerName;
    string filePathUrl;
    String inThirdPartyVal;
    string filePathThirdParty;
    String filePathInLife;
    String filePathProposal;
    String filePathTransact;
    string accessTokenRes;
    Attachment att;
    DocumentUploadClass attHandler = new DocumentUploadClass();
    List<String> documentInfo= new List<String>{};
    String appName;  
    genesis__AppDocCatAttachmentJunction__c fileRecord;
    genesis__Application_Document_Category__c appDocId;
    SFDCSharepointFileUpload__c spFileUpload= SFDCSharepointFileUpload__c.getInstance();
     
    if(spFileUpload != null){
        
        inThirdPartyVal = spFileUpload.Third_Party_Documents__c;
        filePathThirdParty = spFileUpload.FilePathForThirdPartyDocs__c;
        filePathInLife = spFileUpload.File_Path_For_ThirdParty_InLife__c;
        filePathProposal = spFileUpload.File_Path_For_ThirdParty_Proposal__c;
        filePathTransact = spFileUpload.File_Path_For_ThirdParty_Transact__c;
       
     }
    
    //Get Customer Name
    genesis__Applications__c  genApp = [SELECT id,Name, genesis__Account__r.Name,Is_Contract_created__c FROM genesis__Applications__c where id =:appId limit 1];
    
    if(genApp  != null){
        // string customerName= 'Hello ////////////// Customer %16/07/2018 %2:15 PM \\PK %@ &&&&&&&&SB/UAT';
        customerName= genApp.genesis__Account__r.Name.replaceAll('[|,|.|//\\,||"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"|\\\\|]', '');
        system.debug('customerName:' +customerName);
        //customerName = genApp.genesis__Account__r.Name.replace('/','').replace('%','').replace('','');
        appName = genApp.Name;  
    }
        if(folderName!= null && folderName.length()>0){                
               appDocId = [select id from genesis__Application_Document_Category__c where (Name=:folderName and genesis__Application__c =:appId) limit 1];          
               filePathUrl = customerName+'/'+appName+'/'+folderName;               
         }
        else {
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

   /*****************************************
    * Send Failure Notofication incase of file upload failed
    *****************************************/ 
    webservice static void sendFailureEmail(string error,string Name){
    
     if(Label.admin_email != null)
      {       
      // Step 0: Create a master list to hold the emails we'll send
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
      // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        List<String> idList = new List<String>();
       
       Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name =: Label.Sharepoint_Group];
        for (GroupMember gm : gp.GroupMembers) {
            idList.add(gm.UserOrGroupId);
        }
         system.debug('Group :' +gp);
        List<User> userList = [SELECT Email FROM User WHERE Id IN :idList];
        for(User u : userList) {
            sendTo.add(u.email);
        } 
    
      sendTo.add(UserInfo.getUserEmail());
      mail.setToAddresses(sendTo);
      system.debug('sendTo :' +sendTo);
      // Step 3: Set who the email is sent from
      mail.setReplyTo(Label.admin_email);
      mail.setSenderDisplayName('IT Support');
   
 
      // Step 4. Set email contents - you can use variables!
      mail.setSubject('Document Upload Failure Notice');
      String body = '<html><head></head><body>Hi Admin,<br><br>Document uploaded by  '+ UserInfo.getName()+' is failed due to the following reason(s): <br><br>  Error Message: ' + error;
             body += '<br><br>Application ID : '+Name+' <br><br> Regards,<br>Admin</body></html> <br><br>';
     
      mail.setHtmlBody(body);
   
      // Step 5. Add your email to the master list
      mails.add(mail);
        
      // Step 6: Send all emails in the master list
      Messaging.sendEmail(mails);
     }
  
    }

}