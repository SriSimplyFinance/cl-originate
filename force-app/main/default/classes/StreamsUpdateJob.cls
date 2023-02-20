global class StreamsUpdateJob extends clcommon.DynamicJob{
    
    private Set<String> contractNames;
    private String contractNamesStr;
    
    global StreamsUpdateJob(){}
    
    global StreamsUpdateJob(Set<String> contractNames){
        this.contractNames = contractNames;
    } 
    
    global StreamsUpdateJob(String contractName){
        this.contractNames = new Set<String>{contractName};
    } 
    
    
    global override String getRuntimeQuery(){
        String nsPrefix = 'cllease__';
        String query = 'SELECT Id, Name, ' +    
            nsPrefix + 'Product_Sub_Type__c, ' +
            nsPrefix + 'Contract_Date__c, ' +
            nsPrefix + 'Residual_Amount__c, ' +  
            nsPrefix + 'Initial_Direct_Cost_Amount1__c, ' +
            nsPrefix + 'Financed_Amount__c, ' + 
            nsPrefix + 'Lease_Product_Name__r.' + nsPrefix + 'Track_Cash_Account_Balances__c, ' + 
            nsPrefix + 'Lease_Product_Name__r.' + nsPrefix + 'Track_Non_Cash_Account_Balances__c, ' +  
            nsPrefix + 'Last_Due_Date__c,' + 
            nsPrefix + 'Lease_Status__c ' +
            'from cllease__Lease_Account__c '; 
        
        if(contractNames != null && contractNames.size() > 0){
            contractNamesStr = getStringFromIds(contractNames);
        }else{
            contractNamesStr = getStringFromIds(getAllContracts());
        }
        query += ' Where Name IN (' + contractNamesStr + ')';
        System.debug(LoggingLevel.Error, 'Query : '+Query);
        List<cllease__Lease_Account__c> contracts = database.query(query);
        System.debug('size : '+contracts.size());
        return query;
    }
    
    
    global override void doStart(Database.BatchableContext bc) {
        
        
    }
    
    global override void doExecute(Database.BatchableContext bc,List<sobject> scope) {
        List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
        cllease__Lease_Account__c contract = contracts[0];
        Savepoint sp = Database.setSavepoint() ;
        try{
            
            String status = contract.cllease__Lease_Status__c;
            
            //Status --> Partial-Application
            contract.cllease__Lease_Status__c = cllease.LendingConstants.STATUS_PARTIAL_APPLICATION;
            update contract;
            
            //Regenerate Streams
            String streamStatus = cllease.RegenerateStreamsCtrl.regenerateStreamsInBatch(contract.Id);
            System.debug(LoggingLevel.Error, 'streamStatus : ' + streamStatus );
            if(streamStatus != 'Generating Streams...'){
                Database.rollback(sp);
                cllease__Batch_Process_Log__c log = new cllease__Batch_Process_Log__c();
                log.cllease__Message__c = 'Contract ID : ' + contract.Id  + ' Exception in regenerating streams: ' + streamStatus ;
                log.Name = 'Yield Update Error';
                insert log;
                return;
            }
            contract.cllease__Lease_Status__c = status;
            contract.cllease__Next_Income_Accrual_Date__c = contract.cllease__Contract_Date__c;
            update contract;
            
            //Marking pmt stream as Billed
            Date lastDueGenerationDate = contract.cllease__Last_Due_Date__c;
            List<cllease__Payment_Stream__c> paymentStreams = [Select Id,
                                                               cllease__Date__c
                                                               From cllease__Payment_Stream__c 
                                                               Where cllease__Date__c <= :lastDueGenerationDate
                                                               And cllease__Contract__c =: contract.Id];
            
            for(cllease__Payment_Stream__c pmtStream : paymentStreams){
                pmtStream.cllease__Billed__c = true;
            }
            update paymentStreams;
            
            CashBalanceCorrector cashBalanceJob = new CashBalanceCorrector();
            cashBalanceJob.execute(new List<cllease__Lease_Account__c> {contract});
            
            List<cllease__Lease_Trx_Header__c> accrualTxns = [Select Id 
                                                              from cllease__Lease_Trx_Header__c 
                                                              where cllease__Contract__c = :contract.Id];
            delete accrualTxns;
            
           
            
        }catch(Exception e){
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, 'Exception: ' +  e.getMessage());
            System.debug(LoggingLevel.ERROR, 'Exception: ' +  e.getStackTraceString());
            
            cllease__Batch_Process_Log__c log = new cllease__Batch_Process_Log__c();
            log.cllease__Message__c = 'Contract ID : ' + contract.Id  + ' Exception: ' + e.getMessage() + ' StackTrace : ' + 
                						e.getStackTraceString();
            log.Name = 'Yield Update Error';
            insert log;
            
        }
        
    }
    
    global override void doInitialize(){}
    
  /*  private void updateStreamsONPartialTermination(Id contractId, Date terminationDate){
        List<cllease__Payment_Stream__c> pmtStreams = [Select Id,
                                                       cllease__Beginning_Receivable__c,
                                                       cllease__Ending_Receivable__c,
                                                       cllease__Rental_Amount__c 
                                                       From cllease__Payment_Stream__c
                                                       where cllease__Date__c >= :terminationDate And
                                                       cllease__Contract__c = :contractId];
        
        List<cllease__Amz_Stream__c> amzStreams = [Select Id, 
                                                   cllease__Monthly_Earning__c,
                                                   cllease__Unearned_Beginning_balance__c,
                                                   cllease__Unearned_Ending_balance__c
                                                   From cllease__Amz_Stream__c
                                                   where cllease__Date__c >= :terminationDate And
                                                   cllease__Contract__c = :contractId];
        
        List<cllease__Dep_Streams__c> depStreams = [Select Id,
                                                           cllease__Beginning_Residual__c,
                                                    	   cllease__Ending_Residual__c,
                                                           cllease__Dep_Expense__c    
                                                    From cllease__Dep_Streams__c
                                                    where cllease__Date__c >= :terminationDate And
                                                    cllease__Contract__c = :contractId];
        
        List<cllease__Initial_Direct_Cost_Stream__c> idcStreams = [Select Id,
                                                                   cllease__Beginning_Initial_Direct_Cost__c,
                                                                   cllease__Ending_Initial_Direct_Cost__c,
                                                                   cllease__Expense_Initial_Direct_Cost__c
                                                                   From cllease__Initial_Direct_Cost_Stream__c
                                                                   where cllease__Date__c >= :terminationDate And
                                                                   cllease__Contract__c = :contractId];
        
     
        
        List<cllease__Rental_Accrual_Stream1__c> rentalAccrualStreams = [Select Id,
                                                                         cllease__Beginning_Net_Book_Value__c,
                                                                         cllease__Ending_Net_Book_Value__c
                                                                         From cllease__Rental_Accrual_Stream1__c
                                                                         Where cllease__Date__c >= :terminationDate And
                                                                         cllease__Contract__c = :contractId];
        
        List<cllease__Rental_Stream__c> rentalStreams = [Select Id,
                                                        		cllease__Beginning_Net_Book_Value__c,
                                                        		cllease__Beginning_Net_Investment__c,
                                                        		cllease__Beginning_Lease_Receivable__c,
                                                         		cllease__Beginning_Unearned_Income__c,
                                                         		cllease__Capital_Recovery__c,
                                                         		cllease__Ending_Net_Book_Value__c,
                                                         		cllease__Ending_Net_Investment__c,
                                                         		cllease__Ending_Lease_Receivable__c,
                                                         		cllease__Ending_Unearned_Income__c,
                                                         		cllease__Lease_Income__c,
                                                         		cllease__Pro_Rated_Income__c,
                                                         		cllease__Monthly_Income__c,
                                                         		cllease__Investment_Income__c,
                                                         		cllease__Payment_Amount__c
                                                         From cllease__Rental_Stream__c 
                                                         Where cllease__Date__c >= :terminationDate And
                                                                         cllease__Contract__c = :contractId];
        
        List<cllease__Subsidy_Stream__c> subsidyStreams = [Select Id,
                                                           cllease__Beginning_Balance__c,
                                                           cllease__Ending_Balance__c,
                                                           cllease__Accrued_Amount__c
                                                           From cllease__Subsidy_Stream__c
                                                           Where cllease__Date__c >= :terminationDate And
                                                           cllease__Contract__c = :contractId];
        
        List<cllease__Residual_Stream__c> residualStreams = [Select Id,
                                                            		cllease__Beginning_Residual_Net_Book_Value__c,
                                                            		cllease__Beginning_Lease_Residual__c,
                                                            		cllease__Beginning_Unearned_Residual_Income__c,
                                                            		cllease__Ending_Net_Book_Value__c,
                                                             		cllease__Ending_Lease_Residual__c,
                                                             		cllease__Ending_Unearned_Residual_Income__c,
                                                             		cllease__Residual_Amount__c,
                                                             		cllease__Residual_Income__c
                                                             From cllease__Residual_Stream__c
                                                             Where cllease__Date__c >= :terminationDate And
                                                           cllease__Contract__c = :contractId];
        
    }*/
    
    global override void doFinish(Database.BatchableContext bc) {}
    
    private Set<String> getAllContracts(){
        Set<String> contractNames = new Set<String>();
        contractNames.add('LES-0000000069');
        contractNames.add('LES-0000000070');
        contractNames.add('LES-0000000082');
        contractNames.add('LES-0000000092');
        contractNames.add('LES-0000000172');
        contractNames.add('LES-0000000213');
        contractNames.add('LES-0000000230');
        contractNames.add('LES-0000000231');
        contractNames.add('LES-0000000254');
        contractNames.add('LES-0000000277');
        contractNames.add('LES-0000000290');
        contractNames.add('LES-0000000343');
        contractNames.add('LES-0000000363');
        contractNames.add('LES-0000000380');
        contractNames.add('LES-0000000390');
        contractNames.add('LES-0000000413');
        contractNames.add('LES-0000000431');
        contractNames.add('LES-0000000438');
        contractNames.add('LES-0000000439');
        contractNames.add('LES-0000000457');
        contractNames.add('LES-0000000459');
        contractNames.add('LES-0000000495');
        contractNames.add('LES-0000000497');
        contractNames.add('LES-0000000503');
        contractNames.add('LES-0000000507');
        contractNames.add('LES-0000000511');
        contractNames.add('LES-0000000538');
        contractNames.add('LES-0000000544');
        contractNames.add('LES-0000000562');
        contractNames.add('LES-0000000605');
        contractNames.add('LES-0000000628');
        contractNames.add('LES-0000000650');
        contractNames.add('LES-0000000665');
        contractNames.add('LES-0000000886');
        contractNames.add('LES-0000000896');
        contractNames.add('LES-0000000969');
        contractNames.add('LES-0000000970');
        contractNames.add('LES-0000001122');
        contractNames.add('LES-0000001139');
        contractNames.add('LES-0000001310');
        contractNames.add('LES-0000001490');
        contractNames.add('LES-0000001617');
        contractNames.add('LES-0000001625');
        contractNames.add('LES-0000001682');
        contractNames.add('LES-0000001686');
        contractNames.add('LES-0000001723');
        contractNames.add('LES-0000001866');
        contractNames.add('LES-0000001885');
        contractNames.add('LES-0000001950');
        contractNames.add('LES-0000001964');
        contractNames.add('LES-0000001991');
        contractNames.add('LES-0000002024');
        contractNames.add('LES-0000002041');
        contractNames.add('LES-0000002103');
        contractNames.add('LES-0000002268');
        return contractNames;
    }
    		
    private String getStringFromIds(Set<String> contractIds){
        String idStr = '';
        if(contractIds == null || contractIds.size() == 0) {
            return idStr;
        }
        for (String contractId : contractIds) {
            System.debug(logginglevel.error,'contractId - '+contractId);
            idStr = idStr + '\'' + String.escapeSingleQuotes(contractId) + '\'' + ',';
        }
        idStr = idStr.substring(0, idStr.length() - 1);
        System.debug('idStr: ' + idStr);
        return idStr;
    }
    
   /* public static void runQuery(){
        List<cllease__Other_Transaction__c> txns = [SELECT Id, 
                                                    cllease__Lease_Account__c, 
                                                    cllease__Transaction_Type__c,
                                                    cllease__Lease_Account__r.cllease__Lease_Status__c 
                                                    FROM cllease__Other_Transaction__c 
                                                    where cllease__Transaction_Type__c ='TERMINATION' AND 
                                                    cllease__Lease_Account__r.cllease__Lease_Status__c !='TERMINATED' AND
                                                    cllease__Lease_Account__r.Name IN ('LES-0000000069',
                                                             'LES-0000000070',
                                                             'LES-0000000082',
                                                             'LES-0000000089',
                                                             'LES-0000000092',
                                                             'LES-0000000093',
                                                             'LES-0000000095',
                                                             'LES-0000000098',
                                                             'LES-0000000101',
                                                             'LES-0000000105',
                                                             'LES-0000000108',
                                                             'LES-0000000110',
                                                             'LES-0000000112',
                                                             'LES-0000000166',
                                                             'LES-0000000169',
                                                             'LES-0000000172',
                                                             'LES-0000000213',
                                                             'LES-0000000230',
                                                             'LES-0000000231',
                                                             'LES-0000000236',
                                                             'LES-0000000254',
                                                             'LES-0000000268',
                                                             'LES-0000000277',
                                                             'LES-0000000290',
                                                             'LES-0000000343',
                                                             'LES-0000000380',
                                                             'LES-0000000390',
                                                             'LES-0000000392',
                                                             'LES-0000000396',
                                                             'LES-0000000412',
                                                             'LES-0000000413',
                                                             'LES-0000000439',
                                                             'LES-0000000457',
                                                             'LES-0000000459',
                                                             'LES-0000000497',
                                                             'LES-0000000503',
                                                             'LES-0000000507',
                                                             'LES-0000000508',
                                                             'LES-0000000511',
                                                             'LES-0000000538',
                                                             'LES-0000000544',
                                                             'LES-0000000562',
                                                             'LES-0000000599',
                                                             'LES-0000000605',
                                                             'LES-0000000644',
                                                             'LES-0000000650',
                                                             'LES-0000000663',
                                                             'LES-0000000665',
                                                             'LES-0000000902',
                                                             'LES-0000000886',
                                                             'LES-0000000896',
                                                             'LES-0000000921',
                                                             'LES-0000000933',
                                                             'LES-0000000969',
                                                             'LES-0000000970',
                                                             'LES-0000001139',
                                                             'LES-0000001198',
                                                             'LES-0000001441',
                                                             'LES-0000001490',
                                                             'LES-0000001508',
                                                             'LES-0000001515',
                                                             'LES-0000001617',
                                                             'LES-0000001625',
                                                             'LES-0000001866',
                                                             'LES-0000001964',
                                                             'LES-0000002024',
                                                             'LES-0000002050',
                                                             'LES-0000002094',
                                                             'LES-0000002268',
                                                             'LES-0000000236', 
                                                             'LES-0000000172', 
                                                             'LES-0000000355', 
                                                             'LES-0000000363', 
                                                             'LES-0000000412', 
                                                             'LES-0000000431', 
                                                             'LES-0000000438', 
                                                             'LES-0000000439', 
                                                             'LES-0000000457', 
                                                             'LES-0000000495', 
                                                             'LES-0000000507', 
                                                             'LES-0000000503', 
                                                             'LES-0000000886', 
                                                             'LES-0000000605', 
                                                             'LES-0000000628', 
                                                             'LES-0000000650', 
                                                             'LES-0000000654', 
                                                             'LES-0000000665', 
                                                             'LES-0000001122', 
                                                             'LES-0000001310', 
                                                             'LES-0000001625', 
                                                             'LES-0000001682', 
                                                             'LES-0000001686', 
                                                             'LES-0000001723', 
                                                             'LES-0000001490', 
                                                             'LES-0000001885', 
                                                             'LES-0000001947', 
                                                             'LES-0000001950', 
                                                             'LES-0000001964', 
                                                             'LES-0000001991', 
                                                             'LES-0000002041', 
                                                             'LES-0000002050', 
                                                             'LES-0000002103'
                                                            )
                                                    
                                                   ];
        
        System.debug('Txns : ' + txns);
    }*/
    
}