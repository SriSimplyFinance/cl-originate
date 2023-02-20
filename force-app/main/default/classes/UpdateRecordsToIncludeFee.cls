// Batch job for updating existing contract records to include 'Fee' value in Accrual Streams picklist
public class UpdateRecordsToIncludeFee implements Database.Batchable<sObject>{
  private Set<String> contractNames;

    public UpdateRecordsToIncludeFee(Set<String> contractNames){ 
      this.contractNames = contractNames;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
      String query =  ' SELECT Id, cllease__Accrual_Streams__c FROM cllease__Lease_Account__c';

    if(contractNames != null && contractNames.size() > 0) {
      String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
      query += ' WHERE Name in ('+ contractNamesStr + ')';
    }

    query += ' ORDER BY Name ';
        
        System.debug(LoggingLevel.ERROR, 'UpdateRecordsToIncludeFee Query: '+query);
        
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
      List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;

       Savepoint sp = database.setsavepoint();
       try {

         // Contract Update
      for(cllease__Lease_Account__c contract : contracts) {
        String streams = contract.cllease__Accrual_Streams__c;
                streams = (streams == null ? 'Fee;' : (streams.contains('Fee') ? streams : streams + ';Fee;'));
                contract.cllease__Accrual_Streams__c = streams;
      }
      
            if(contracts.size() > 0) {
        update contracts;
            }

     } catch(Exception e) {
       database.rollback(sp); 
       System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
             System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());            
             //insert batch process log for exceptions
             insert new cllease__Batch_Process_Log__c(Name='UpdateRecordsToIncludeFee: ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
              +' in line number: '+ e.getlinenumber());
     }
    
    }

   public void finish(Database.BatchableContext BC){}
}