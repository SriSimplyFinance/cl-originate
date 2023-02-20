trigger SumofPaymentStreamAmount on genesis__Payment_Stream__c (After Insert,After Update) {
    
    if(checkRecursive.runOnce())
    {
        Decimal Totalamount=0;
        list<id> appIds=new list<id>();
        list<genesis__Payment_Stream__c> payments = new list<genesis__Payment_Stream__c>();
        for(genesis__Payment_Stream__c ps:Trigger.new)
        {
            appIds.add(ps.genesis__Application__c);
        }
              
        list<genesis__Payment_Stream__c> payStrs = [select Total_Payment_amount_transact__c,Sum_of_Payment_Amount__c,genesis__Application__c from genesis__Payment_Stream__c where genesis__Application__c in:appIds];
        system.debug('**payStrs '+payStrs); 
        for(genesis__Payment_Stream__c PayStr: payStrs){
            
            if(PayStr.Total_Payment_amount_transact__c !=null)
            {
                Totalamount = Totalamount + PayStr.Total_Payment_amount_transact__c;
    
            }
        }
        system.debug('**Totalamount**'+Totalamount );   
    
        for(genesis__Payment_Stream__c paySum : payStrs ){
                paySum.Sum_of_Payment_Amount__c = Totalamount;
                payments.add(paySum);
        system.debug('**sum'+paySum.Sum_of_Payment_Amount__c);
    
        }
    
         update payments;
    }
}