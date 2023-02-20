public class SAF_ExperianAPIController {
    @invocablemethod(Label='Experian API Controller' Description='Make a Company API call for Experian credit report search')
        public static void verifyAPICalls(List<Request_Details> requestDetails){
            
            if(requestDetails[0].accountId==NULL&&requestDetails[0].companyType==NULL){
                Logger.error('Account Id'+requestDetails[0].accountId+'or Company Type'+requestDetails[0].companyType+'is null');
            }
            else{

                SAF_ExperianCreditSearchService.updateCompanyDetailsOnExperianSearch(requestDetails[0].accountId,requestDetails[0].companyType);
    
            }
        Logger.saveLog();
    }
    
    public class Request_Details{
   @InvocableVariable(required=true)
    public String accountId;
    
    @InvocableVariable(required=true)
    public String companyType;
    
}

}