public Class SAF_UploadCongadocsp
{
    @future(callout=true) 
    public static void uploadDoc(String attId,String expId,String FileName)
    {
       String ExperianID = expId;
      List<SAF_Experian_Info__c> ExpInfo = [SELECT Account__c,Id,Name,Account__r.Name FROM SAF_Experian_Info__c where Id = : expId];  
        for(SAF_Experian_Info__c objexp:ExpInfo)
      {
       String CustName = objexp.Account__r.Name;        
       CustName = CustName.replaceAll('[|,|.|//\\,||"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"|\\\\|]', '');
        if(attId!= null )
              {
                     system.debug('Invoke Document Response :'+attId);

                     String sharePointResponse = DocumentUploadClass.processSharePoint(CustName,attId);
                       if(sharePointResponse != null && sharePointResponse != 'Error'){ 
                      system.debug('Invoke SharePoint Response :'+sharePointResponse);
                      SAF_Custom_DisplayLinks.displayLinksExp(sharePointResponse,'Third Party Document',FileName);
                      }
                      if(sharePointResponse != null && sharePointResponse != 'Error'){
                      system.debug('Invoke SharePoint Response to delete the file :'+sharePointResponse);
                      system.debug('Att Id'+attId);
                      SAF_DocumentUploadToSharePoint.deleteexpAttachment(attId);
                      }
                     
               }
      }
    }
}