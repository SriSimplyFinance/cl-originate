trigger restructureTriggerFin on cllease__Rental_Stream__c (before delete) {
  
    ID contractId = trigger.old[0].cllease__Contract__c;
   if(contractId != null)
    {
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
          AggregateResult totalIncome = [select SUM(Cllease__Lease_Income__c) totalIncome from Cllease__Rental_Stream__c where Cllease__Contract__c = :contractId];
          contractDetails.Rst_Total_Income__c = (Decimal)totalIncome.get('totalIncome');
          System.debug(LoggingLevel.ERROR, '###### Total Income : ' + totalIncome.get('totalIncome'));
          List<cllease__Residual_Stream__c> residualValues = [select id, Cllease__Residual_Income__c from Cllease__Residual_Stream__c where Cllease__Contract__c = :contractId];
          System.debug(LoggingLevel.ERROR, '###### residualValues.size() : ' + residualValues.size());
          if(residualValues.size() > 0){
              AggregateResult totalResidual = [select SUM(Cllease__Residual_Income__c) residualIncome from Cllease__Residual_Stream__c where Cllease__Contract__c = :contractId];
              contractDetails.Rst_Total_Residual_Income__c = (Decimal)totalResidual.get('residualIncome');
              System.debug(LoggingLevel.ERROR, '###### Total Residual : ' + totalResidual.get('residualIncome'));
          }
          AggregateResult totalReceivable = [select SUM(Cllease__Rental_Amount__c) totalReceivable from Cllease__Payment_Stream__c where Cllease__Contract__c = :contractId and Cllease__Payment_Type__c = 'RENT'];
          contractDetails.Rst_Total_Receivable__c = (Decimal)totalReceivable.get('totalReceivable');
          System.debug(LoggingLevel.ERROR, '###### Total Receivable : ' + totalReceivable.get('totalReceivable'));
          update contractDetails;
      }
  }
}