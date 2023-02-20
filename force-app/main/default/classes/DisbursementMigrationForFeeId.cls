global class DisbursementMigrationForFeeId extends cllease.LeaseDynamicJob{
    String customQuery;
    String nsPrefix = 'cllease__';
    static final String JOB_NAME = 'DisbursementMigrationForFeeId';

    global DisbursementMigrationForFeeId(){
        super(JOB_NAME, null);
    }
    global DisbursementMigrationForFeeId(String query){
        super(JOB_NAME, null);
        this.customQuery = query;
    }

    global override String getRuntimeQuery(){
        if(customQuery != null){
            return customQuery;
        }
        String query = 'Select Id, ' +
                               'cllease__Disbursement_Transaction__r.clcommon__Amount__c,' + 
                               'cllease__Disbursement_Transaction__r.clcommon__Equipment_Id__c,' + 
                               'cllease__Disbursement_Transaction__r.cllease__Transaction_Sub_Type__r.Name,' +
                               'cllease__Disbursement_Transaction__r.cllease__Contract__r.Name, ' + 
                               'cllease__Contract_Fee__c ' +                               
                        'From ' + 'cllease__Expense_Fee_Transaction__c ' + 
                        ' Where ' + 'cllease__Disbursement_Transaction__r.clcommon__Transaction_Type__c = \'DISBURSEMENT\' AND  '+ 
                                'cllease__Disbursement_Transaction__r.cllease__Contract_Fee__c = null'; 
        System.debug('query: ' + query);
        return query;

    }

    global override void doInitialize() {}

    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(Database.BatchableContext bc,List<sobject> scope) {
        try{
            List<cllease__Expense_Fee_Transaction__c> expTxns = (List<cllease__Expense_Fee_Transaction__c>) scope;
            List<clcommon__Disbursement_Transaction__c> disbTxns = new List<clcommon__Disbursement_Transaction__c>();
            Set<String> leaseAccNames = new Set<String>();
            Set<String> disbTxnSubTypeNames = new Set<String>();
            for(cllease__Expense_Fee_Transaction__c expTxn : expTxns){
                leaseAccNames.add(expTxn.cllease__Disbursement_Transaction__r.cllease__Contract__r.Name);
                disbTxnSubTypeNames.add(expTxn.cllease__Disbursement_Transaction__r.cllease__Transaction_Sub_Type__r.Name);
            }
            List<cllease__Contract_Fees__c> feeSchedules = [Select Id,
                                                   cllease__Contract__r.Name,
                                                   cllease__Fee_Definition__r.Name,
                                                   cllease__Amount__c,
                                                   cllease__Contract_Equipment__r.cllease__Warehouse_Equipment__c
                                                   From cllease__Contract_Fees__c
                                                   Where cllease__Fee_Definition__r.Name In :disbTxnSubTypeNames AND
                                                   cllease__Contract__r.Name In :leaseAccNames AND
                                                   cllease__Fee_Definition__r.clcommon__Class__c = :clcommon.CLConstants.FEE_CLASS_EXPENSE];


            Map<String,Id> feeSchedulesByKey = new Map<String,Id>();
            for(cllease__Contract_Fees__c feeSchedule : feeSchedules){
                DisbursementKey keyObj = new DisbursementKey(feeSchedule.cllease__Fee_Definition__r.Name,
                                                             cllease.ValueUtil.round(feeSchedule.cllease__Amount__c),
                                                             feeSchedule.cllease__Contract__r.Name,
                                                             feeSchedule.cllease__Contract_Equipment__r.cllease__Warehouse_Equipment__c);

                feeSchedulesByKey.put(keyObj.getKey(),feeSchedule.Id);
            }

            for(cllease__Expense_Fee_Transaction__c expTxn : expTxns){

                DisbursementKey keyObj = new DisbursementKey(expTxn.cllease__Disbursement_Transaction__r.cllease__Transaction_Sub_Type__r.Name,
                                                             cllease.ValueUtil.round(expTxn.cllease__Disbursement_Transaction__r.clcommon__Amount__c),
                                                             expTxn.cllease__Disbursement_Transaction__r.cllease__Contract__r.Name,
                                                             expTxn.cllease__Disbursement_Transaction__r.clcommon__Equipment_Id__c);
                String key = keyObj.getkey();
                if(feeSchedulesByKey.containsKey(key)){
                    expTxn.cllease__Contract_Fee__c = feeSchedulesByKey.get(key);
                }
                clcommon__Disbursement_Transaction__c disbTxn = new clcommon__Disbursement_Transaction__c(Id = expTxn.cllease__Disbursement_Transaction__c,
                                                                                                          cllease__Contract_Fee__c = expTxn.cllease__Contract_Fee__c);
                disbTxns.add(disbTxn);
            }
            update(expTxns);
            update(disbTxns);
        }
        catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            throw e;
        }
    }

    global override void doFinish(Database.BatchableContext bc) {}

    class DisbursementKey{
        String txnType;
        Decimal amount;
        String contractName;
        Id equipmentId;

        DisbursementKey(String txnType,Decimal amount,String contractName,Id equipmentId){
            this.txnType = txnType;
            this.amount = amount;
            this.contractName = contractName;
            this.equipmentId = equipmentId;
        }

        String getKey(){
            return String.valueOf(this);
        }

    }
}