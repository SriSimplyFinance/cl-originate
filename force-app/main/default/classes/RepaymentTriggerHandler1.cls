public class RepaymentTriggerHandler1{

   
    public static void PaymentStreamUpdate(list<id> conIds){
    //string id=string.valueOf(conIds);
    map<Decimal,Integer> smapCount = new map<Decimal,Integer>();
    map<Decimal,Date> smapDate = new map<Decimal,Date>();

        list<cllease__Payment_Stream__c> pay = [Select Id,cllease__Contract__c,cllease__Billed__c, cllease__Rental_Amount__c,cllease__Date__c From cllease__Payment_Stream__c Where cllease__Contract__c in:conIds and cllease__Billed__c = false and cllease__Payment_Type__c = 'RENT' Order by cllease__Date__c ASC];
        system.debug('===='+pay );
        
        string id1;
        if(pay.size() >0) {id1 =pay[0].cllease__Contract__c;}
        
        for(cllease__Payment_Stream__c p:pay){
         if(smapCount.containsKey(p.cllease__Rental_Amount__c)){
          integer count =smapCount.get(p.cllease__Rental_Amount__c) +1;
          smapCount.put(p.cllease__Rental_Amount__c,count);
                  system.debug('==smapCount=='+smapCount );

         }else {
         smapCount.put(p.cllease__Rental_Amount__c,1);
         }
         if(!smapDate.containsKey(p.cllease__Rental_Amount__c)){
          smapDate.put(p.cllease__Rental_Amount__c,p.cllease__Date__c );
                          system.debug('==smapDate=='+smapDate );

         }
        }
         
         set<Decimal> oldRecKey = new set<Decimal>();
         list <Payment_Schedule__c> paycloneList = [SELECT Id, Payment_Amount__c,LS_Contract__c,Payment_Count__c,Payment_Date__c FROM Payment_Schedule__c WHERE LS_Contract__c =:id1];
         
         system.debug('===='+paycloneList );
         
         list<Payment_Schedule__c> newPaylist = new list<Payment_Schedule__c> ();
         
         for(Payment_Schedule__c payclone: paycloneList ){
          if(smapDate.containsKey(payclone.Payment_Amount__c)){
           payclone.Payment_Count__c = smapCount.get(payclone.Payment_Amount__c);
           payclone.Payment_Date__c = smapDate.get(payclone.Payment_Amount__c);
           oldRecKey.add(payclone.Payment_Amount__c);
          }
        }
        
          system.debug('====oldRecKey===='+oldRecKey );
         
        if(!paycloneList.isEmpty()){
         update paycloneList;
        } else {
           for(Decimal amt : smapCount.keySet()){  
                      system.debug('====New amt===='+amt );

            if(!oldRecKey.contains(amt)){
                 Payment_Schedule__c payclone = new Payment_Schedule__c();
                 payclone.Payment_Amount__c= amt;
                           system.debug('====payclone.Amount__c===='+payclone.Payment_Amount__c);

                 payclone.Payment_Count__c = smapCount.get(amt);
                                      

                 payclone.Payment_Date__c = smapDate.get(amt);
                                         

                 payclone.LS_Contract__c = id1;
                 newPaylist.add(payclone);
            }
           }
        }
        
        system.debug('====newPaylist===='+newPaylist );
        if(!newPaylist.isEmpty()) insert newPaylist;
        
    }
}