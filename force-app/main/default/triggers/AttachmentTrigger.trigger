/*****************************************************************************************************************
*    Trigger Name      :    AttachmentTrigger 
*    Description       :    Trigger to handle all events
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
trigger AttachmentTrigger on Attachment (before insert,after insert) {
if (Trigger.isInsert)
{
    if (Trigger.isBefore) 
    {
    //handle unlisted files being uploaded
    AttachmentTriggerHelper.restrictUnlistedFiles(trigger.New);
    }
    else if (Trigger.isAfter) {
    for(Attachment Attlst:trigger.New)
     {
          string attId = string.valueof(Attlst.Id);
          string expId = string.valueof(Attlst.ParentId);
          string FileName = string.valueof(Attlst.Name);
          String atttype = string.valueof(Attlst.Parent.type);
          system.debug('Attachment ID string****'+AttId+expId+FileName);
          system.debug('Parent Type'+atttype);
         // if(atttype == 'SAF_Experian_Info__c')
         // {
              system.debug('***Inside If ****');
              SAF_UploadCongadocsp.uploadDoc(attId,expId,FileName); 
         // }
     }   
       }        
}
}