trigger restructureTriggerOP on cllease__Rental_Accrual_Stream1__c (before insert) {
    System.debug(LoggingLevel.DEBUG, trigger.new); 
    ID contractId = trigger.new[0].cllease__Contract__c;
    cllease__Lease_Account__c contractDetails = [Select id, 
                                                 Rst_Total_Income__c, 
                                                 Rst_Total_Residual_Income__c, 
                                                 Rst_Total_Receivable__c, 
                                                 cllease__Active_flag__c,
                                                 cllease__Residual_Amount__c,
                                                 Rst_Residual__c
                                                 from cllease__Lease_Account__c 
                                                 where id = :contractId];
    contractDetails.Rst_Residual__c = contractDetails.cllease__Residual_Amount__c;
    if(contractDetails.Cllease__Active_flag__c == True){
        System.debug(LoggingLevel.ERROR, '###### Contract ID : ' + contractId);
        AggregateResult totalReceivable = [select SUM(Cllease__Rental_Amount__c) totalReceivable from Cllease__Payment_Stream__c where Cllease__Contract__c = :contractId and Cllease__Payment_Type__c = 'RENT'];
        contractDetails.Rst_Total_Receivable__c = (Decimal)totalReceivable.get('totalReceivable');
        System.debug(LoggingLevel.ERROR, '###### Total Receivable : ' + totalReceivable.get('totalReceivable'));
        update contractDetails;
    }
}