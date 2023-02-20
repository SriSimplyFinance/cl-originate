public class SAF_CompanyDetailsQueueable implements Queueable,Database.AllowsCallouts{
    List<String> accountNumbers;
    private static Boolean doChainJob = false;
    public static String calloutResult;
    public static Id batchId1;
    
    public SAF_CompanyDetailsQueueable(List<String> accountNumbers){
        this.accountNumbers=accountNumbers;
    }    
    public void execute(QueueableContext context){
       calloutResult = SAF_CompanyDetailService.updateShareholderDetails(accountNumbers);
        system.debug('calloutResult'+calloutResult);
        if(calloutResult.contains('Account Created/updated successfully')){
            doChainJob = true;
        }
        if(doChainJob){
            SAF_CompanyRelationShipQueueable qClass1 = new SAF_CompanyRelationShipQueueable(this.accountNumbers);
        	system.debug('Relationship created');
            if(!Test.isRunningTest()){
              batchId1 = System.enqueueJob(qClass1);  
            }
    	}
            
     }
        

}