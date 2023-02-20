global class ContractWithFaultyData implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {   
        String query = 'Select Id,(Select Id,cllease__Monthly_Income__c,cllease__Lease_Income__c From cllease__Rental_Streams__r),';
        query += '(Select Id From cllease__Other_Lease_Transactions__r WHERE cllease__Transaction_Type__c = \'TERMINATION\')';
        query += ' From cllease__Lease_Account__c';
        query += ' WHERE cllease__Is_Rescheduled__c = false';
        query += ' AND cllease__Lease_Status__c In (\'ACTIVE - GOOD STANDING\', \'ACTIVE - BAD STANDING\')';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<cllease__Lease_Account__c> contracts) {
        Set<Id> contractIds = new Set<Id>();
        contractIds = fetchContractIds(contracts);
        markFaultyContract(contractIds);
    }
    
    public static Set<Id> fetchContractIds(List<cllease__Lease_Account__c> contracts){
        Set<Id> contractIds = new Set<Id>();
        for(cllease__Lease_Account__c contract : contracts){
            if(contract.cllease__Other_Lease_Transactions__r.size() == 0){
                Decimal sumOfMonthlyIncome = 0;
                Decimal sumOfIncome = 0;
                Decimal difference = 0;
                for(cllease__Rental_Stream__c stream : contract.cllease__Rental_Streams__r){
                    sumOfMonthlyIncome += stream.cllease__Monthly_Income__c == null ? 0 : stream.cllease__Monthly_Income__c;
                    sumOfIncome += stream.cllease__Lease_Income__c == null ? 0 : stream.cllease__Lease_Income__c;
                }
                difference = sumOfMonthlyIncome - sumOfIncome;
                if(math.round(difference) > 0.10 || math.round(difference) < -0.10){
                    contractIds.add(contract.Id);
                    System.debug(LoggingLevel.ERROR, '^^^^ Id : ' + contract.Id);
                    System.debug(LoggingLevel.ERROR, '^^^^ sumOfMonthlyIncome : ' + sumOfMonthlyIncome);
                    System.debug(LoggingLevel.ERROR, '^^^^ sumOfIncome : ' + sumOfIncome);
                }
            }
        }
        System.debug(LoggingLevel.ERROR, '^^^^ contractIds : ' + contractIds);
        
        for(cllease__Lease_Account__c contract : contracts){
            if(contract.cllease__Other_Lease_Transactions__r.size() == 0){
                for(cllease__Rental_Stream__c stream : contract.cllease__Rental_Streams__r){
                    if(stream.cllease__Monthly_Income__c < -0.10 ||
                       stream.cllease__Lease_Income__c < -0.10){
                           contractIds.add(contract.Id);
                           System.debug(LoggingLevel.ERROR, '^^^^ Id : ' + contract.Id);
                           System.debug(LoggingLevel.ERROR, '^^^^ MonthlyIncome : ' + stream.cllease__Monthly_Income__c);
                           System.debug(LoggingLevel.ERROR, '^^^^ Income : ' + stream.cllease__Lease_Income__c);
                           break;
                       }
                }
            }
        }
        System.debug(LoggingLevel.ERROR, '^^^^ contractIds : ' + contractIds);
        return contractIds;
    }
    
    public static void markFaultyContract(Set<Id> contractIds){
        List<cllease__Lease_Account__c> contractsToUpdate = new List<cllease__Lease_Account__c>();
        for(Id contractId : contractIds){
            cllease__Lease_Account__c contract = new cllease__Lease_Account__c();
            contract.Id = contractId;
            contract.faulty_Data_Contract__c = true;
            contractsToUpdate.add(contract);
        }
        System.debug(LoggingLevel.ERROR, '^^^^ contractsToUpdate : ' + contractsToUpdate);
        // performing DML
        if(contractsToUpdate.size() > 0){
            update contractsToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC) {}
}