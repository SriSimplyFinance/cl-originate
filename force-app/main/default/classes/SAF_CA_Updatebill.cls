global class SAF_CA_Updatebill {
@InvocableMethod 
    webservice static void updateBill(List<string> BpIds){
        
       system.debug('inside updateBill:');    
        if(BpIds.size() >0)
        {
            
          /* List<sobject> lstbpid =[SELECT Sum(Amount_Towards_Income__c) ati,sum(Amount_Towards_Capital__c) atc,sum(Amount_Towards_Capital_VAT__c) atcv,sum(Amount_Towards_Income_VAT__c) ativ,cllease__Payment_Transaction__c FROM cllease__Bill_Payment__c     
                    where  cllease__Payment_Transaction__c In: BpIds group by cllease__Payment_Transaction__c];*/
           
            List<cllease__Bill_Payment__c> LstBpid = [SELECT Amount_Towards_Income_VAT__c,Amount_Towards_Income__c,Amount_Towards_Capital__c,Amount_Towards_Capital_VAT__c,cllease__Payment_Transaction__r.SAF_Income_Capital_reversed__c,cllease__Payment_Transaction__r.Id,cllease__Payment_Transaction__c,cllease__Payment_Transaction__r.SAF_Total_Amount_Towards_Capital__c,cllease__Payment_Transaction__r.cllease__Contract__r.SAF_Total_Amount_Towards_Capital__c,cllease__Payment_Transaction__r.cllease__Contract__r.SAF_Total_Amount_Towards_Income__c,cllease__Payment_Transaction__r.cllease__Contract__r.SAF_Total_Amount_Towards_Income_VAT__c,cllease__Payment_Transaction__r.cllease__Contract__r.SAF_Total_Amount_Towards_Capital_VAT__c,cllease__Payment_Transaction__r.cllease__Contract__c,cllease__Payment_Transaction__r.cllease__Restructured__c,cllease__Payment_Transaction__r.cllease__Reversed__c,cllease__Payment_Transaction__r.cllease__Cleared__c,cllease__Bill__c,cllease__Bill__r.Monthly_Income__c,cllease__Bill__r.Income_Received__c,cllease__Bill__r.Monthly_Income_VAT__c,cllease__Bill__r.Income_VAT_Received__c,Id,Name FROM cllease__Bill_Payment__c where Id In: BpIds];
              system.debug('LstBpid :' +LstBpid); 
           Map<Id,cllease__Lease_Payment_Transaction__c> maplpt = new Map<Id,cllease__Lease_Payment_Transaction__c>();
           Map<Id,cllease__Lease_Account__c> mapcontract = new Map<Id,cllease__Lease_Account__c>();
           Map<Id,cllease__Lease_account_Due_Details__c> mapbills = new Map<Id,cllease__Lease_account_Due_Details__c>();
            for(cllease__Bill_Payment__c objbp:LstBpid)
            {
               if(objbp.cllease__Payment_Transaction__r.cllease__Cleared__c && (objbp.cllease__Payment_Transaction__r.cllease__Reversed__c ||  objbp.cllease__Payment_Transaction__r.cllease__Restructured__c))
                  {   
                   //objbp.cllease__Bill__r.Income_Received__c= objbp.cllease__Bill__r.Income_Received__c- objbp.Amount_Towards_Income__c;
                   //objbp.cllease__Bill__r.Income_VAT_Received__c= objbp.cllease__Bill__r.Income_VAT_Received__c- objbp.Amount_Towards_Income_VAT__c;
                    system.debug(' objbp.Amount_Towards_Income__c:'+ objbp.Amount_Towards_Income__c); 
                  cllease__Lease_account_Due_Details__c objbill = objbp.cllease__Bill__r;
                   if(!mapbills.containskey(objbill.Id))
                   {             
                       mapbills.put(objbill.Id,objbill);
                   }
                 //  cllease__Lease_account_Due_Details__c objbill = objbp.cllease__Bill__r;
                   objbill.Income_Received__c = (mapbills.get(objbill.Id).Income_Received__c > 0 ) ? (mapbills.get(objbill.Id).Income_Received__c - objbp.Amount_Towards_Income__c) : objbill.Income_Received__c ;
                   objbill.Income_VAT_Received__c =(mapbills.get(objbill.Id).Income_VAT_Received__c > 0) ? (mapbills.get(objbill.Id).Income_VAT_Received__c-objbp.Amount_Towards_Income_VAT__c) :objbill.Income_VAT_Received__c;
                    system.debug(' objbill.Income_Received__c:'+ objbill.Income_Received__c);   
                    system.debug(' objbill.Income_VAT_Received__c :'+ objbill.Income_VAT_Received__c );         
                    mapbills.put(objbill.Id,objbill);
                   
                   
                    cllease__Lease_Account__c objcls = objbp.cllease__Payment_Transaction__r.cllease__Contract__r;
                    system.debug(' Before objcls  :'+ objcls);    
                    if(objcls.SAF_Total_Amount_Towards_Capital__c > 0) objcls.SAF_Total_Amount_Towards_Capital__c= objcls.SAF_Total_Amount_Towards_Capital__c - objbp.Amount_Towards_Capital__c;//cllease__Payment_Transaction__r.
                    if(objcls.SAF_Total_Amount_Towards_Income__c >0 ) objcls.SAF_Total_Amount_Towards_Income__c= objcls.SAF_Total_Amount_Towards_Income__c - objbp.Amount_Towards_Income__c;
                    if(objcls.SAF_Total_Amount_Towards_Income_VAT__c > 0) objcls.SAF_Total_Amount_Towards_Income_VAT__c= objcls.SAF_Total_Amount_Towards_Income_VAT__c - objbp.Amount_Towards_Income_VAT__c;
                    if(objcls.SAF_Total_Amount_Towards_Capital_VAT__c >0 ) objcls.SAF_Total_Amount_Towards_Capital_VAT__c= objcls.SAF_Total_Amount_Towards_Capital_VAT__c - objbp.Amount_Towards_Capital_VAT__c;
                    system.debug('after objcls  :'+ objcls);  
                     maplpt.put(objbp.cllease__Payment_Transaction__r.Id,objbp.cllease__Payment_Transaction__r);
                     mapcontract.put(objcls.Id,objcls);
                 }
                 else if(objbp.cllease__Payment_Transaction__r.cllease__Cleared__c)
                 {
                   cllease__Lease_Account__c objcls = objbp.cllease__Payment_Transaction__r.cllease__Contract__r;
                    system.debug(' Before objcls  cleared:'+ objcls);    
                    objcls.SAF_Total_Amount_Towards_Capital__c= objcls.SAF_Total_Amount_Towards_Capital__c + objbp.Amount_Towards_Capital__c;//cllease__Payment_Transaction__r.
                     objcls.SAF_Total_Amount_Towards_Income__c= objcls.SAF_Total_Amount_Towards_Income__c + objbp.Amount_Towards_Income__c;
                     objcls.SAF_Total_Amount_Towards_Income_VAT__c= objcls.SAF_Total_Amount_Towards_Income_VAT__c + objbp.Amount_Towards_Income_VAT__c;
                    objcls.SAF_Total_Amount_Towards_Capital_VAT__c= objcls.SAF_Total_Amount_Towards_Capital_VAT__c + objbp.Amount_Towards_Capital_VAT__c;
                    system.debug('after objcls  cleared:'+ objcls);  
                     mapcontract.put(objcls.Id,objcls);
                 } 
               
              /*    objlpt.SAF_Total_Amount_Towards_Income__c= double.Valueof(objbpid.get('ati'));
                  objlpt.SAF_Total_Amount_Towards_Capital__c = double.Valueof(objbpid.get('atc'));
                  objlpt.SAF_Total_Amount_Towards_Income_VAT__c = double.Valueof(objbpid.get('ativ'));
                  objlpt.SAF_Total_Amount_Towards_Capital_VAT__c = double.Valueof(objbpid.get('atcv'));
                   //objcls.TotalAmountTowardsCapital = + objlpt.SAF_Total_Amount_Towards_Capital__c;
                  //lstlpt.add(objlpt);
                 
                 
                cls_agreement objcls = new cls_agreement();
                objcls.TotalAmountTowardsCapital = objlpt.SAF_Total_Amount_Towards_Capital__c;
                objcls.TotalAmountTowardsIncome = objlpt.SAF_Total_Amount_Towards_Income__c;
                objcls.TotalAmountTowardsIncomeVAT = objlpt.SAF_Total_Amount_Towards_Income_VAT__c;
                objcls.TotalAmountTowardsCapitalVAT = objlpt.SAF_Total_Amount_Towards_Capital_VAT__c;
              //3 values; 
                mapcontract.put(objlpt.Id,objcls);
                system.debug('*****mapcontract values****'+mapcontract.put(objlpt.Id,objcls));*/
            }   
            system.debug('******mapbills************'+mapbills);    
            system.debug('******maplpt************'+maplpt);        
            if(mapbills.size() >0) { update mapbills.values();}
            if(mapcontract.size() >0) { update mapcontract.values();}
              
                  
        }
       
                  
  } 
   
  Public class cls_agreement
  {
       public string AgreementId;
       public decimal TotalAmountTowardsCapital;
       public decimal TotalAmountTowardsIncome;
       public decimal TotalAmountTowardsIncomeVAT;
       public decimal TotalAmountTowardsCapitalVAT;
      // public decimal AgreementId;
  }  
}