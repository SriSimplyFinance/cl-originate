trigger PaymentScheduleRestructure on cllease__Payment_Schedule__c (before insert, before update) {

    List<cllease__Payment_Schedule__c> paymentSchedule = new List<cllease__Payment_Schedule__c>();
    List<cllease__Payment_Schedule__c> updatePaymentSchedule = new List<cllease__Payment_Schedule__c>();
    //Set<Id> ids = new Set<Id>();
    List<Id> ids = new List<Id>();
    //List<cllease__Contract_Equipment__c> updateEquip = new List<cllease__Contract_Equipment__c>();
    Double payAmnt;
    
    try{
        for (cllease__Payment_Schedule__c pmtSchedule : trigger.new) {
            //payAmnt = pmtSchedule.cllease__Total_Payment__c;
            if(pmtSchedule.cllease__Contract__c!=null) {
                ids.add(pmtSchedule.cllease__Contract__c);
                paymentSchedule.add(pmtSchedule);
            }
        }
        
        //Added condition for ticket #161632, copied the code from dev from rePaymentMethoadCalculationOne trigger
        if(Ids.size()>0)
        rePaymentMethoadCalculation.calculateRepayMethod(Ids);
        
        System.debug(LoggingLevel.ERROR, '#### Contracts: = ' + ids);
       /* Integer psSize = paymentSchedule.size();
        List<cllease__Lease_Account__c> contracts = [SELECT id from cllease__Lease_Account__c where id = :ids];
    
        if(contracts.size() > 0){
    
            List<cllease__Contract_Equipment__c> equips = [SELECT id, cllease__Override_Tax_Flag__c, cllease__Override_Tax_Rate__c from cllease__Contract_Equipment__c where cllease__Contract__c = :contracts AND cllease__Override_Tax_Flag__c = TRUE LIMIT 1];

            for(cllease__Contract_Equipment__c equipmentNew : equips){
                for(Integer i=0; i <= psSize; i++){
                    Double payAmnt = paymentSchedule.get(i).cllease__Total_Payment__c;
                    System.debug(LoggingLevel.ERROR, '#### payAmnt : = ' + payAmnt );
                    paymentSchedule.get(i).cllease__VAT__c = (payAmnt)*(equipmentNew.cllease__Override_Tax_Rate__c / 100);
                    Double vatAmount = paymentSchedule.get(i).cllease__VAT__c;
                    System.debug(LoggingLevel.ERROR, '#### vatAmount : = ' + vatAmount );
                    paymentSchedule.get(i).cllease__Payment_Amount__c = payAmnt + vatAmount;
                    System.debug(LoggingLevel.ERROR, '#### cllease__Payment_Amount__c : = ' + paymentSchedule.get(i).cllease__Payment_Amount__c);
                    updatePaymentSchedule.add(paymentSchedule.get(i));
                }    
            }
            update updatePaymentSchedule;
            
        } */   
    }
    catch (Exception ex) {
        system.debug('ExceptionMesage: '+ex.getMessage());
        system.debug('ExceptionLine: '+ex.getLineNumber());
        system.debug('ExceptionCause: '+ex.getCause());
    }
}