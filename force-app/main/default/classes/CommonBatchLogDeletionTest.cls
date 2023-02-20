@isTest
public class CommonBatchLogDeletionTest {
    static testMethod void testCommonLogDeletionJob(){
        //Inserting Org Parameters Custom Custom Settings
        cllease__Org_Parameters__c orgParams = new cllease__Org_Parameters__c();
        orgParams.Log_Validity__c = -1;
        insert orgParams;
        
        //Inserting Common Batch Log 
        clcommon__Batch_Process_Log__c batchLog = new clcommon__Batch_Process_Log__c();
        batchLog.clcommon__Type__c = 'Exception';
        batchLog.clcommon__Log_Level__c = 'INTERNAL';
        insert batchLog;
        
        test.startTest();
        CommonBatchLogDeletionJob job = new CommonBatchLogDeletionJob();
        Database.executeBatch(job);
        test.stopTest();
        List<clcommon__Batch_Process_Log__c> logs = [SELECT Id FROM clcommon__Batch_Process_Log__c];
        System.assert(logs.size() == 0);
    }
}