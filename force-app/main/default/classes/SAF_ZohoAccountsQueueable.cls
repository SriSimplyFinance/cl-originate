public class SAF_ZohoAccountsQueueable implements Queueable,Database.AllowsCallouts{
    private static Boolean doChainJob = false;
    Account account;
    List<String> accIds;
    public static Id batchId1;
    boolean iscreate;
    public static string calloutResult;
    
     public SAF_ZohoAccountsQueueable(List<String> accIds,boolean iscreate){
        this.accIds = accIds;
        this.iscreate = iscreate; 
    }  
    public void execute(QueueableContext context){
        Account account = [select id, Name, AccountNumber, KYCDB_Unique_Key_Account__c, clcommon__Legal_Entity_Type__r.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, SIC_Code_Number__c, clcommon__Status__c, Ownership, clcommon__Legal_Entity_Type__c, LegalEntity_Zoho__c, Registered_Address_Road__c, Registered_Address_Premises__c from Account where Id = :accIds[0]];
       calloutResult=Saf_ZohoAccounts.CreateAccountInZoho(account.id, iscreate);
           if(calloutResult!=null){
            doChainJob=true;
        }
        if(doChainJob){
            if(account.ownership!='Individual'&&account.KYCDB_Unique_Key_Account__c!=null){
                accIds.add(account.id);
                 SAF_UpdateCustomersQueueable qClass1 = new SAF_UpdateCustomersQueueable(accIds);
            		if(!Test.isRunningTest()){
              		batchId1 = System.enqueueJob(qClass1);  
            		}
            	}
            
       		 }
       }
    
}