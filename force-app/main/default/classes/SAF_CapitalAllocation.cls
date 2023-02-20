global class SAF_CapitalAllocation {
@InvocableMethod 
    webservice static void updateLPT(List<string> LPTIds){
       system.debug('inside lpt:');    
        if(LPTIds.size() >0)
        {
            String strLPTId = LPTIds[0];
           List<sobject> lstbpid =[SELECT Sum(Amount_Towards_Income__c) ati,sum(Amount_Towards_Capital__c) atc,sum(Amount_Towards_Capital_VAT__c) atcv,sum(Amount_Towards_Income_VAT__c) ativ,cllease__Payment_Transaction__c FROM cllease__Bill_Payment__c     
                    where  cllease__Payment_Transaction__c In: LPTIds group by cllease__Payment_Transaction__c];
           
            /*List<cllease__Bill_Payment__c> LstBPID = [SELECT Amount_Towards_Capital_VAT__c,Amount_Towards_Capital__c,Amount_Towards_Income_VAT__c,Amount_Towards_Income__c,cllease__Amount_Towards_Due__c,cllease__Amount_Towards_Tax__c,cllease__Bill__c,cllease__Payment_Amount__c,cllease__Payment_Transaction__c,Id,Name,Reversed__c FROM cllease__Bill_Payment__c     
                    where  cllease__Payment_Transaction__c In: LPTIds];
              system.debug('strLPTId :' +strLPTId ); */  
           List<cllease__Lease_Payment_Transaction__c> lstlpt = [select cllease__Cleared__c,cllease__Reversed__c,Id,cllease__Contract__c,SAF_Total_Amount_Towards_Capital__c,name,SAF_Total_Amount_Towards_Income__c,SAF_Total_Amount_Towards_Income_VAT__c,SAF_Total_Amount_Towards_Capital_VAT__c from cllease__Lease_Payment_Transaction__c where Id In:LPTIds ];
           Map<Id,cls_agreement> mapcontract = new Map<Id,cls_agreement>();
          
            for(cllease__Lease_Payment_Transaction__c objlpt:lstlpt )
            {
               
                 for(sobject objbpid: lstbpid)
                 {
                 system.debug('***cllease__Payment_Transaction__c***' + objbpid.get('cllease__Payment_Transaction__c') +'***objlpt.Id****'+ objlpt.Id + '*****objlpt.cllease__Cleared__c:****'+objlpt.cllease__Cleared__c + '****objlpt.cllease__Reversed__c***' +objlpt.cllease__Reversed__c);
                  if(objbpid.get('cllease__Payment_Transaction__c') == objlpt.Id && !objlpt.cllease__Reversed__c)
                  {
                  objlpt.SAF_Total_Amount_Towards_Income__c= double.Valueof(objbpid.get('ati'));
                  objlpt.SAF_Total_Amount_Towards_Capital__c = double.Valueof(objbpid.get('atc'));
                  objlpt.SAF_Total_Amount_Towards_Income_VAT__c = double.Valueof(objbpid.get('ativ'));
                  objlpt.SAF_Total_Amount_Towards_Capital_VAT__c = double.Valueof(objbpid.get('atcv'));
                   //objcls.TotalAmountTowardsCapital = + objlpt.SAF_Total_Amount_Towards_Capital__c;
                  //lstlpt.add(objlpt);
                   system.debug('*****objlpt:****'+objlpt);
                  }
                
                 }
                cls_agreement objcls = new cls_agreement();
                objcls.TotalAmountTowardsCapital = objlpt.SAF_Total_Amount_Towards_Capital__c;
                objcls.TotalAmountTowardsIncome = objlpt.SAF_Total_Amount_Towards_Income__c;
                objcls.TotalAmountTowardsIncomeVAT = objlpt.SAF_Total_Amount_Towards_Income_VAT__c;
                objcls.TotalAmountTowardsCapitalVAT = objlpt.SAF_Total_Amount_Towards_Capital_VAT__c;
              //3 values; 
                mapcontract.put(objlpt.Id,objcls);
                system.debug('*****mapcontract values****'+mapcontract.put(objlpt.Id,objcls));
            }   
            system.debug('******lstlpt************'+lstlpt);            
            update lstlpt;
           /* for(cllease__Lease_Payment_Transaction__c objlpt:lstlpt )
            {
              
              if(mapcontract.containskey(objlpt.Id))
              {
                decimal atc = objlpt.cllease__Contract__r.SAF_Total_Amount_Towards_Capital__c +mapcontract.get(objlpt.Id).TotalAmountTowardsCapital;
                decimal ati = objlpt.cllease__Contract__r.SAF_Total_Amount_Towards_Income__c +mapcontract.get(objlpt.Id).TotalAmountTowardsIncome;
                decimal ativ = objlpt.cllease__Contract__r.SAF_Total_Amount_Towards_Income_VAT__c +mapcontract.get(objlpt.Id).TotalAmountTowardsIncomeVAT;
                decimal atcv = objlpt.cllease__Contract__r.SAF_Total_Amount_Towards_Capital_VAT__c +mapcontract.get(objlpt.Id).TotalAmountTowardsCapitalVAT;
              //3 values; 
              }
            } */  
              
                  
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