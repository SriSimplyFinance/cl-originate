//SubsidyUpdateBatch.cls- Batch job for updating subsidy amounts

public class SubsidyUpdateBatch implements Database.Batchable<sObject>{
private Set<String> contractNames;

public SubsidyUpdateBatch(Set<String> contractNames){
this.contractNames = contractNames;
}

public Database.QueryLocator start(Database.BatchableContext BC){
String query = ' SELECT Id, Name, '+
' cllease__Subsidy__c, '+
' cllease__Subsidy1__c, '+
' (SELECT Id, Name, '+
' cllease__Equipment__c, '+
' cllease__Amount__c '+
' FROM cllease__Contract_Subsidy__r), '+
' (SELECT Id, Name, '+
' cllease__Subsidy__c '+
' FROM cllease__Contract_Equipments__r) '+
' FROM cllease__Lease_Account__c ';

if(contractNames != null && contractNames.size() > 0) {
String contractNamesStr = '';
for (String contractName : contractNames) {
contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
}
contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
query += ' WHERE Name in ('+ contractNamesStr + ')';
}

query += ' ORDER BY Name ';

System.debug(LoggingLevel.ERROR, 'SubsidyUpdateBatch Query: '+query);

return Database.getQueryLocator(query);
}

public void execute(Database.BatchableContext BC, List<sObject> scope){
List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
List<cllease__contract_equipment__c> eqpToUpdate = new List<cllease__contract_equipment__c>();

Savepoint sp = database.setsavepoint();
try {

// Contract Update
for(cllease__Lease_Account__c contract : contracts) {
// Loop through Subsidy objects and create Map of Equipment objects creation
Map<Id, Decimal> equipmentSubsidyMap = new Map<Id, Decimal>();
for(cllease__Subsidy__c subsidy : contract.cllease__Contract_Subsidy__r) {
equipmentSubsidyMap.put(subsidy.cllease__Equipment__c, subsidy.cllease__Amount__c);
}

// Looping through Contract Equipment for Subsidy Field Update
for(cllease__contract_equipment__c eqp : contract.cllease__Contract_Equipments__r) {
if(equipmentSubsidyMap.containsKey(eqp.Id)) {
eqpToUpdate.add(new cllease__contract_equipment__c(Id = eqp.Id, cllease__Subsidy__c = equipmentSubsidyMap.get(eqp.Id)));
}
}

// Copying Subsidy rollup summary field value to new subsidy field
contract.cllease__subsidy1__c = contract.cllease__Subsidy__c;
}

if(eqpToUpdate.size() > 0) {
update eqpToUpdate;
}

update contracts;

} catch(Exception e) {
database.rollback(sp); 
System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage()); 
System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString()); 
//insert batch process log for exceptions
insert new cllease__Batch_Process_Log__c(Name='SubsidyUpdateBatch: ',
cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
+' in line number: '+ e.getlinenumber());
}

}

public void finish(Database.BatchableContext BC){}
}