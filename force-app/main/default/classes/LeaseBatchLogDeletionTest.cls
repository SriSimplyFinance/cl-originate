@isTest
public class LeaseBatchLogDeletionTest {
    static testMethod void testleaseLogDeletionJob(){
        //Inserting Org Parameters Custom Custom Settings
        cllease__Org_Parameters__c orgParams = new cllease__Org_Parameters__c();
        orgParams.Log_Validity__c = -1;
        insert orgParams;
        
        //Inserting Common Batch Log 
        cllease__Batch_Process_Log__c batchLog = new cllease__Batch_Process_Log__c();
        batchLog.cllease__Type__c = 'Exception';
        insert batchLog;
        
        test.startTest();
        LeaseBatchLogDeletionJob job = new LeaseBatchLogDeletionJob();
        Database.executeBatch(job);
        test.stopTest();
        List<cllease__Batch_Process_Log__c> logs = [SELECT Id FROM cllease__Batch_Process_Log__c];
        System.assert(logs.size() == 0);
    }
}