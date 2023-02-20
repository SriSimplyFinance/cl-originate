/*****************************************************************************************************************
*    Class Name        :    DocumentUploadClass
*    Description       :    Class is desgined to process SharePoint integration from SKUID page
*    Author            :    HappiestMinds
*    Created Date      :    28/05/2018
*-----------------------------------------------------------------------------------------------------------------  
*        Modification Logs
*-----------------------------------------------------------------------------------------------------------------
*    Modified Date        Developer            Description
*-----------------------------------------------------------------------------------------------------------------
*    23/05/2018        HappiestMinds         Initial version
*    06/06/2018        HappiestMinds         Added method to process SharePoint integration from SKUID page
******************************************************************************************************************/

global class DocumentUploadClass{
    
    /*****************************************************************************************************************
    *    Method Name   :    processSharePoint
    *    Description   :    Does the functionality of invoking Share Point and processing the responses
    *    Params        :    String filePathURL, String attachmentId
    *    Return Type   :    String
    ******************************************************************************************************************/
     
      webservice static String processSharePoint(String filePathURL, String attachmentId){
         
         String response = '';
         String documentPath = EncodingUtil.urlEncode(filePathURL, 'UTF-8').replaceAll('\\+','%20');
            
         //Invoke SharePoint to get the access token
         String accessToken =  SharePointController.fetchSharePointAccessToken();
         
         //Validate access token
         if(accessToken != Label.SharePoint_Error_Flag){
         
             //Grab the file stored
             List<Attachment> file = [select id, name, ContentType, BodyLength, Body from Attachment where id=:attachmentId];
             
             //Check file exists?    
             if(file.size()>0){
                 //Encode file name
                 String documentName = EncodingUtil.urlEncode(file.get(0).Name, 'UTF-8').replaceAll('\\+','%20');
                 
                 //Invoke 2nd request to create Upload Session
                 String uploadURLResponse = SharePointController.createUploadSession(accessToken, documentPath, documentName);
                 
                 //Store the response for further request
                 response = uploadURLResponse;
                 
                     //Validate 2nd response
                     if(uploadURLResponse != Label.SharePoint_Error_Flag){
                         
                         //Invoke 3rd request to do file upload
                         String fileUploadURLResponse  = SharePointController.uploadFile(uploadURLResponse, file.get(0));
                         
                         //Validate 3rd response
                         if(fileUploadURLResponse != Label.SharePoint_Error_Flag){
                         
                             //Store the response to show the view URL
                             response = fileUploadURLResponse;
                         }else{
                             response = fileUploadURLResponse;
                         }
                         
                     }else{
                         response = uploadURLResponse;
                     }
                     
                }else{
                    response = Label.SharePoint_FileNotFoundError;
                }     
                     
         }else{
             response = accessToken;
         }
         return response;
     }
    
}