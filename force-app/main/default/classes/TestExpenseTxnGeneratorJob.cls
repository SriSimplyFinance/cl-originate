@isTest
public class TestExpenseTxnGeneratorJob {
    @isTest
    public static void testExpTxnGeneration() {
        Account dummyAccount = new Account(Name = 'Sample Account');
        clcommon__Disbursement_Transaction__c dsbrTxn = new clcommon__Disbursement_Transaction__c();
        dsbrTxn.clcommon__Amount__c = 200;
        dsbrTxn.clcommon__Due_Date__c = Date.newInstance(2020, 12, 31);
        dsbrTxn.clcommon__Account__c = dummyAccount.Id;
        dsbrTxn.clcommon__Transaction_Date__c = Date.newInstance(2020, 12, 31);
        dsbrTxn.clcommon__Transaction_Type__c = 'DISBURSEMENT';  
        dsbrTxn.clcommon__GL_Transaction_Flag__c = false;
        dsbrTxn.clcommon__Net_Amount__c = 210;
        dsbrTxn.clcommon__Tax_Amount__c  = 10;
        insert(dsbrTxn);
        Test.startTest();
        ExpenseTransactionMigrationJob job = new ExpenseTransactionMigrationJob();
        Database.executeBatch(job);
        Test.stopTest();
        List<cllease__Expense_Fee_Transaction__c> expTxns = [Select Id, Name FROM cllease__Expense_Fee_Transaction__c];
        System.assertEquals(1, expTxns.size(), 'Expense txns did not get created');
    }
}