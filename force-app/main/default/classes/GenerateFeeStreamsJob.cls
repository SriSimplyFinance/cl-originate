global class GenerateFeeStreamsJob extends clcommon.DynamicJob{
    
    private final String contractId;
    global GenerateFeeStreamsJob(String contractId){
        this.contractId = contractId;
    }
    
    global GenerateFeeStreamsJob(){        
    }

    global override String getRuntimeQuery() {
        String query = null;
        
        if(String.isNotBlank(contractId)) {
            System.debug('contractId:::'+contractId);
            query = 'Select Id,Name,cllease__Financed_Amount__c,cllease__Residual_Amount__c,cllease__Maturity_Date__c,cllease__Next_Income_Accrual_Date__c,cllease__Contract_Date__c,cllease__Accrual_Streams__c from cllease__Lease_Account__c ' + 
                'WHERE Id NOT IN (SELECT cllease__Contract__c FROM cllease__Fee_Stream__c) ' + 
                'and Id IN (SELECT cllease__Contract__c FROM cllease__Contract_Fees__c) and ' +
                'cllease__Lease_Status__c IN (\'ACTIVE - GOOD STANDING\',\'TERMINATED\',\'ACTIVE - BAD STANDING\') AND ' +
                'Id = \'' + contractId + '\'';
        } else {
            query = 'Select Id,Name,cllease__Financed_Amount__c,cllease__Residual_Amount__c,cllease__Maturity_Date__c,cllease__Next_Income_Accrual_Date__c,cllease__Contract_Date__c,cllease__Accrual_Streams__c from cllease__Lease_Account__c ' + 
                'WHERE Id NOT IN (SELECT cllease__Contract__c FROM cllease__Fee_Stream__c) ' +  
                'and Id IN (SELECT cllease__Contract__c FROM cllease__Contract_Fees__c) and ' +
                'cllease__Lease_Status__c IN (\'ACTIVE - GOOD STANDING\',\'TERMINATED\',\'ACTIVE - BAD STANDING\') ';
        }
        
        System.debug('Query ' + query);
        return query;
    }    
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(Database.BatchableContext bc, List<sobject> scope) {
        
        try{
            System.debug('scope size:'+scope.size());
            GenerateFeeStreams generateFeeStreams = new GenerateFeeStreams();
        //Map<Id,List<cllease__Contract_Fees__c>> contractIncomeFeeMap = generateFeeStreams.getContractIncomeFees(scope);
        //Map<Id,List<cllease__Contract_Fees__c>> contractExpenseFeeMap = generateFeeStreams.getContractExpenseFees(scope);
            Map<Id,List<cllease__Rental_Stream__c>> incomeStreamsMap = generateFeeStreams.getContractIncomeStreams(scope);
            generateFeeStreams.generateIncomeFeeStreams(scope,incomeStreamsMap);
            generateFeeStreams.generateExpenseFeeStreams(scope,incomeStreamsMap);       
        
       }catch(Exception e){
            System.debug('ERROR MESSAGE::'+e.getMessage()+' at::'+e.getLineNumber());
            clcommon__Log__c log = new clcommon__Log__c();
            log.clcommon__Message__c = e.getMessage();
            log.clcommon__Time__c = datetime.now();
        }
    }
    
    global override void doInitialize() {}
    global override void doFinish(Database.BatchableContext bc) {}

}