trigger rePaymentMethoadCalculation on cllease__Payment_Stream__c (after insert,after update,after delete,after undelete) {

    List<Id> Ids = New List<Id>();
    List<Id> conIds = New List<Id>();
    cllease__Payment_Stream__c ps =new cllease__Payment_Stream__c();
    if(trigger.isInsert && trigger.isAfter)
    {
        for(cllease__Payment_Stream__c app : trigger.new)
        {    
             conIds.add(app.cllease__Contract__c);           
            }
    }
    else if(trigger.isUpdate && trigger.isAfter){
        for(cllease__Payment_Stream__c app : trigger.old){    
             conIds.add(app.cllease__Contract__c);           
            }
    }
            system.debug('====conIds'+conIds);

    if(conIds.size()>0)
    RepaymentTriggerHandler1.PaymentStreamUpdate(conIds);
    
    
        if(!trigger.isdelete)
        {
            for(cllease__Payment_Stream__c app : trigger.new)
            {    
             Ids.add(app.cllease__Contract__c);           
            }
        }
        else
        {
            for(cllease__Payment_Stream__c app : trigger.old){
               Ids.add(app.cllease__Contract__c);
            } 
        }
        
    if(Ids.size()>0)
    rePaymentMethoadCalculation.calculateRepayMethod(Ids);
    
}