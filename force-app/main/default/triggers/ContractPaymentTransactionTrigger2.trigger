trigger ContractPaymentTransactionTrigger2 on cllease__Lease_Payment_Transaction__c(after insert,after update) 
{
   
     List<Id> LptIds = new List<Id>();
     List<Id> LptIdCa = new List<Id>();
    
     for(cllease__Lease_Payment_Transaction__c e:Trigger.new){
      system.debug('e:'+e );
        if(trigger.isUpdate)  
             {
            Boolean oldvalueReversed = trigger.oldMap.get(e.Id).cllease__Reversed__c;
            Boolean NewValueReversed = e.cllease__Reversed__c;
            Boolean oldvalue = trigger.oldMap.get(e.Id).cllease__Restructured__c;
            Boolean NewValue = e.cllease__Restructured__c;
            Boolean oldvalueclear = trigger.oldMap.get(e.Id).cllease__Cleared__c;
            Boolean NewValueclear = e.cllease__Cleared__c;
            System.debug('******oldvalueRestructure*******'+oldvalue);
            System.debug('******NewValueRestructure*******'+NewValue);
            System.debug('******oldvalueClear*******'+oldvalueclear);
            System.debug('******NewValueClear*******'+NewValueclear);
            System.debug('******oldvalueReversed*******'+oldvalueReversed);
            System.debug('******NewValueReversed*******'+NewValueReversed);
             if(e.cllease__Reversed__c && oldvalueReversed!=NewValueReversed) {LptIdCa.add(e.id);}
             if(e.cllease__Restructured__c && oldvalue!=NewValue) {LptIdCa.add(e.id);}//&& oldvalue!=NewValue
             if(e.cllease__Cleared__c && oldvalueclear!=NewValueclear) {LptIdCa.add(e.id);}
              }
         /*  if(trigger.isInsert)  
             {
              if(e.cllease__Cleared__c) {LptIdCa.add(e.id);}
             } */
     }
     List<cllease__Bill_Payment__c> LstBpid = [SELECT Id,Name,cllease__Payment_Transaction__c FROM cllease__Bill_Payment__c where cllease__Payment_Transaction__c In:LptIdCa]; 
     system.debug('***LstBpid values*******'+LstBpid);
     Map<Id,string> mapbpids = new Map<Id,string>();
      for(cllease__Bill_Payment__c objbpid: LstBpid){
          mapbpids.put(objbpid.id,objbpid.id);
      }
        If(lstbpid.size() >0)
        {
        SAF_CA_Updatebill.updateBill(mapbpids.values());
    
        }
 
   
}