/*****************************************************************************************************************
*    Class Name        :    AttachmentTriggerHelper 
*    Description       :    It's a helper class of AttachmentTrigger
*    Author            :    HappiestMinds
*    Created Date      :    05/06/2018
*-----------------------------------------------------------------------------------------------------------------  
*        Modification Logs
*-----------------------------------------------------------------------------------------------------------------
*    Modified Date        Developer            Description
*-----------------------------------------------------------------------------------------------------------------
*    05/06/2018        HappiestMinds         Initial version
*    06/06/2018        HappiestMinds         Added functionality to handle unlisted file upload to attachment
******************************************************************************************************************/

public class AttachmentTriggerHelper {


    /*****************************************************************************************************************
    *    Method Name   :    restrictUnlistedFiles
    *    Description   :    Restricts unlisted file being uploaded to attachment
    *    Params        :    List<Attachment> trigger.NEW
    *    Return Type   :    Void
    ******************************************************************************************************************/  
    
    public static void restrictUnlistedFiles(List<Attachment> triggerNew){
        //Fetch files that are listed 
        List<String> filesNotSupported = Label.FileExtensionsNotAllowed.split(',');
        
        //Stores the map with attachment and extension
        Map<Attachment, String> extensionAttachMap = new Map<Attachment, String>{};
        
        //Loop through the trigger.New
        for(Attachment attach: triggerNew){
            
            String fileName =  attach.Name;
            List<String> fileNameithExtension = fileName.split('\\.');
            String fileExtension = fileNameithExtension[fileNameithExtension.size() - 1];
            
            //Validates whether the file is listed?    
            if(filesNotSupported.contains(fileExtension)){                
                extensionAttachMap.put(attach, fileExtension);
            }            
        }
        //Handle the files and throw the error
        for(Attachment attach : extensionAttachMap.keySet()){
            attach.addError(extensionAttachMap.get(attach) + ' '+Label.FileExtensionErrorMessage);
        }
    }
}