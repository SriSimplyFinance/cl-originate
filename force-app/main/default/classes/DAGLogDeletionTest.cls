@isTest
public class DAGLogDeletionTest {
    static testMethod void testDAGLogDeletionJob(){
        //Inserting Org Parameters Custom Custom Settings
        cllease__Org_Parameters__c orgParams = new cllease__Org_Parameters__c();
        orgParams.Log_Validity__c = -1;
        insert orgParams;
        
        //Inserting DAG Log 
        clcommon__DAG_Logging__c dagLog = new clcommon__DAG_Logging__c();
        dagLog.clcommon__Status__c = 'Success';
        insert dagLog;
        
        test.startTest();
        DAGLogDeletionJob job = new DAGLogDeletionJob();
        Database.executeBatch(job);
        test.stopTest();
        List<clcommon__DAG_Logging__c> logs = [SELECT Id FROM clcommon__DAG_Logging__c];
        System.assert(logs.size() == 0);
    }
}