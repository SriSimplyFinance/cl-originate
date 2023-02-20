global class ExpenseTransactionMigrationJob extends cllease.LeaseDynamicJob {
    String customQuery;
    String nameSpacePrefix = 'cllease__';
    private final static String JOB_NAME = 'ExpenseTransactionMigrationJob';

    global ExpenseTransactionMigrationJob() {
        super(JOB_NAME, null);
        System.debug(LoggingLevel.ERROR, 'In ExpenseTransactionMigrationJob  constructor');
    }
    
    global ExpenseTransactionMigrationJob(String query) {
        super(JOB_NAME, null);
        customQuery = query;
        System.debug(LoggingLevel.ERROR, 'In ExpenseTransactionMigrationJob  constructor');
        System.debug(System.LoggingLevel.ERROR, 'ExpenseTransactionMigrationJob Job Query: ' + query);
    }
    
    global override String getRuntimeQuery(){
        if(customQuery != null){
            return customQuery;
        }
        String query = 'SELECT Id, Name, ' + 
                     nameSpacePrefix + 'Contract__c, ' +
             nameSpacePrefix + 'Contract_Fee__c, ' +
                     nameSpacePrefix + 'Transaction_Sub_Type__c, ' +
                     nameSpacePrefix + 'Transaction_Sub_Type__r.Name, ' +
                     'clcommon__Amount__c, ' +
                     'clcommon__Due_Date__c, ' +
                     'clcommon__Account__c, ' +
                     'clcommon__Transaction_Date__c, ' +
                     'clcommon__Transaction_Type__c, ' +
                     'clcommon__Net_Amount__c, ' +
                     'clcommon__Tax_Amount__c ' +
                     'FROM clcommon__Disbursement_Transaction__c ' +
                     'WHERE Id NOT IN (SELECT ' + nameSpacePrefix + 'Disbursement_Transaction__c FROM ' + 
                                        nameSpacePrefix + 'Expense_Fee_Transaction__c)';
        System.debug(System.LoggingLevel.ERROR, 'ExpenseTransactionMigrationJob Job Query: ' + query);
        return query;
    }
        
    global override void doInitialize() {}
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(Database.BatchableContext bc,List<sobject> scope) {
        System.debug(LoggingLevel.ERROR, 'Inside ExpenseTransactionMigrationJob execute ' + scope.size());
        try{
            List<clcommon__Disbursement_Transaction__c> disbursementTxns = (List<clcommon__Disbursement_Transaction__c>)scope;
            List<cllease__Expense_Fee_Transaction__c> expenseTxns = new List<cllease__Expense_Fee_Transaction__c>(); 
            
            List<clcommon__Fee_Definition__c> feeDefinitions = [Select Id, Name FROM clcommon__Fee_Definition__c];
            Map<String, Id> feeIdByName = new Map<String, Id>();
            for(clcommon__Fee_Definition__c feeDef : feeDefinitions) {
                feeIdByName.put(feeDef.Name, feeDef.Id);
            }
            
            for(clcommon__Disbursement_Transaction__c disbTxn : disbursementTxns) {
                cllease__Expense_Fee_Transaction__c expTxn = new cllease__Expense_Fee_Transaction__c();
                expTxn.Name = 'EXP-' + disbTxn.Name.subString(4, disbTxn.Name.length());
                expTxn.cllease__Disbursement_Transaction__c = disbTxn.Id;
                expTxn.cllease__Contract__c = disbTxn.cllease__Contract__c;            
                expTxn.cllease__Amount__c = disbTxn.clcommon__Amount__c;
                expTxn.cllease__Due_Date__c = disbTxn.clcommon__Due_Date__c;
                expTxn.cllease__Account__c = disbTxn.clcommon__Account__c;
                expTxn.cllease__Transaction_Date__c = disbTxn.clcommon__Transaction_Date__c;
                expTxn.cllease__Fee_Definition__c = feeIdByName.get(disbTxn.cllease__Transaction_Sub_Type__r.Name);
                expTxn.cllease__Transaction_Sub_Type__c = disbTxn.cllease__Transaction_Sub_Type__c;  
                expTxn.cllease__Contract_Fee__c = disbTxn.cllease__Contract_Fee__c;
                expTxn.cllease__Transaction_Type__c = 'EXPENSE FEE';
                expTxn.cllease__GL_Transaction_Flag__c = false;
                expTxn.cllease__Net_Amount__c = disbTxn.clcommon__Net_Amount__c;
                expTxn.cllease__Tax_Amount__c = disbTxn.clcommon__Tax_Amount__c;
                expenseTxns.add(expTxn);    
            }
            System.debug(LoggingLevel.ERROR, 'expenseTxns ' + expenseTxns.size());
            insert(expenseTxns);
        } catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            throw e;
        }
    }

    global override void doFinish(Database.BatchableContext bc) {}
}