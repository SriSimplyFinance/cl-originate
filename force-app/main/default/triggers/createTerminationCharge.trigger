trigger createTerminationCharge on cllease__Termination_Quote_Header__c (after update) {
    List<Id> termid = new List<Id>();
   /* List<cllease__Charge__c> chargeLst = new List<cllease__Charge__c>();
    List<cllease__Termination_Quote_Line__c> quotelineLst = new List<cllease__Termination_Quote_Line__c>();
    Map<Id,cllease__Termination_Quote_Line__c> termquoteMap = new Map<Id,cllease__Termination_Quote_Line__c>();
    Map<object,object> contractEquipMap = new Map<object,object>();
    Map<object,object> contractTermEquipMap = new Map<object,object>();
    Map<Id,cllease__Termination_Quote_Header__c> contractidTermMap = new Map<Id,cllease__Termination_Quote_Header__c>();  
    Map<Id,Decimal> EquipProportion = new Map<Id,Decimal>(); 
    List<cllease__Lease_account_Due_Details__c> Bills = new List<cllease__Lease_account_Due_Details__c>();
   
    Decimal VAT = 0.0;
    List<cllease__Office_Name__c> Company = New List<cllease__Office_Name__c>(); 
    system.debug('********************Trigger Fired**************************');
    
    for(cllease__Termination_Quote_Header__c termQuote : trigger.new){
        system.debug('********************Trigger Fired**************************');
        if(termQuote.cllease__Status__c == 'TERMINATION PROCESSED'){
            termid.add(termQuote.id);
            //contractidList.add(termQuote.cllease__Contract__c);
            if(termQuote.cllease__Full_Termination__c == false){
                contractidTermMap.put(termQuote.cllease__Contract__c,termQuote);
            }
        }    
    }
    
   system.debug('************Quote Header**************' + termid);
   Company = [SELECT cllease__Vat_Rate__c FROM cllease__Office_Name__c];
   If (Company.size()>0){
       VAT = Company[0].cllease__Vat_Rate__c!=Null?Company[0].cllease__Vat_Rate__c:0;
   }
   
   /* Commenting it as VAT needs to be read from company object, not lease product
   termContractList = [SELECT id,name,cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c FROM cllease__Lease_Account__c 
                        WHERE Id = :contractidList ];
   if(termContractList.size()>0){                     
       for(cllease__Lease_Account__c con: termContractList){
           conVATMap.put(con.id,con.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c);
       }
       system.debug('************conVATMap*************:' + conVATMap);
   }
   
                            
   quotelineLst = [SELECT cllease__Quote_Header__c,cllease__Quote_Header__r.cllease__Contract__c,cllease__Quote_Header__r.cllease__Contract__r.SAF_term_quote_option_to_purchase__c, cllease__Line_Type__c,cllease__Amount__c FROM cllease__Termination_Quote_Line__c WHERE cllease__Line_Type__c = 'Option To Purchase' AND cllease__Quote_Header__c = :termid];
   if(quotelineLst.size()>0){

       for(cllease__Termination_Quote_Line__c termQuoteline : quotelineLst){
           
           //charge.cllease__Original_Amount__c = termquoteMap.get(termQuote.id).cllease__Amount__c;
           /*Commenting it as VAT needs to be read from company object, not lease product
           if(conVATMap.containsKey(termQuoteline.cllease__Quote_Header__r.cllease__Contract__c) && conVATMap.get(termQuoteline.cllease__Quote_Header__r.cllease__Contract__c)!=Null){
               VAT = conVATMap.get(termQuoteline.cllease__Quote_Header__r.cllease__Contract__c);
               system.debug('**********VAT available:'+VAT);
           }
           else{
               VAT = 0.0;
               system.debug('**********VAT assigned:'+VAT);
           } 
             
           
           List<clcommon__Fee_Definition__c> optionToPurchaseFees = [Select id 
                                                                    from clcommon__Fee_Definition__c 
                                                                    where Name = 'Option to Purchase' And
                                                                    clcommon__Active__c = true
                                                                    limit 1];
           if(optionToPurchaseFees.size()>0){
               cllease__Charge__c charge = new cllease__Charge__c();
               charge.cllease__Fee_Definition__c  = optionToPurchaseFees[0].Id;
               charge.cllease__Transaction_Date__c = Date.today();
               charge.cllease__Transaction_Sub_Type__c = [Select id from cllease__Transaction_Sub_Type__c where Name = 'Option to Purchase'][0].id;
               charge.cllease__Quote_header__c = termQuoteline.cllease__Quote_Header__c;
               charge.cllease__Date__c = Date.today();
               charge.cllease__Original_Amount__c = (termQuoteline.cllease__Quote_Header__r.cllease__Contract__r.SAF_term_quote_option_to_purchase__c)/(1+VAT/100);
               charge.cllease__Lease_Account__c = termQuoteline.cllease__Quote_Header__r.cllease__Contract__c;
               chargeLst.add(charge);
           }

       }
   
   }
   

   if(chargeLst.size()>0){
       insert chargeLst;
       system.debug('************Charge record inserted**************' + chargeLst);
   }
    
   //****Update Bills, in case of Partial Termination**** 
   //1.Get the list of Termination Quotes having partial termination
   //2.Calculate EquipmentProportion for each Termination Quote and store in a Map.
   //3.Select Bills for the contracts and update them in loop. 
   
   // Commented by Mohini. Product update bills to Inactive. No need to reduce amount of bills otherwise accounting on bills will go wrong
    AggregateResult[] contractEquipResults = [SELECT SUM(Net_Asset_Cost__c) netTotalCost,cllease__Contract__c FROM cllease__Contract_Equipment__c where cllease__Contract__c = :contractidTermMap.keyset() group by cllease__Contract__c];
   AggregateResult[] terminatedEquipResults = [SELECT SUM(cllease__Contract_Equipment__r.Net_Asset_Cost__c) netPartialTotalCost,MAX(cllease__Termination_Quote_Header__r.cllease__Contract__c) contract FROM cllease__Termination_Quote_Equipment__c where cllease__Termination_Quote_Header__r.cllease__Contract__c = :contractidTermMap.keyset() group by cllease__Termination_Quote_Header__c]; 
   
   if(contractEquipResults.size()>0){
       for(AggregateResult ar: contractEquipResults){
           contractEquipMap.put(ar.get('cllease__Contract__c'),ar.get('netTotalCost'));
       }
       system.debug('************contractEquipMap*****************' + contractEquipMap);
   }
   if(terminatedEquipResults.size()>0){    
       for(AggregateResult ar: terminatedEquipResults){
           contractTermEquipMap.put(ar.get('contract'),ar.get('netPartialTotalCost'));
       }
       system.debug('************contractTermEquipMap*****************' + contractTermEquipMap);
   }
   if(contractidTermMap.size()>0){    
       for(Id cid : contractidTermMap.keyset()){
          EquipProportion.put(cid,(Decimal)contractTermEquipMap.get(cid)/(Decimal)contractEquipMap.get(cid)); 
       }
       system.debug('************Equipment Proportion*****************' + EquipProportion);
   }
    Bills = [SELECT id,name,cllease__Payment_Stream__c,cllease__Due_Type_Description__c,cllease__Due_Date__c,cllease__Rental_Due_Amount__c,cllease__Total_Due_Amount__c,cllease__Total_Paid_Amount__c,cllease__Payment_Satisfied__c,cllease__Lease_Account__c FROM cllease__Lease_account_Due_Details__c where cllease__Lease_Account__c = :EquipProportion.keyset()];
    if(Bills.size()>0){
        for(cllease__Lease_account_Due_Details__c bill: Bills){
            system.debug('*************cllease__Due_Date__c*************' + bill.cllease__Due_Date__c);
            System.debug('payment Stream: ' + bill.cllease__Payment_Stream__c);
            system.debug('*****contractidTermMap.get(cllease__Lease_Account__c).cllease__Effective_To__c****' + contractidTermMap.get(bill.cllease__Lease_Account__c).cllease__Effective_To__c);
            if(bill.cllease__Due_Type_Description__c == 'BILL / DUE DATE' && bill.cllease__Payment_Satisfied__c == false && (bill.cllease__Due_Date__c > contractidTermMap.get(bill.cllease__Lease_Account__c).cllease__Effective_To__c)){
                system.debug('*********Bill:'+ bill.name);
                system.debug('*********Bill cllease__Total_Paid_Amount__c BEFORE UPDATE:'+ bill.cllease__Total_Paid_Amount__c);
                //bill.cllease__Total_Paid_Amount__c = (bill.cllease__Total_Paid_Amount__c)*(1-EquipProportion.get(bill.cllease__Lease_Account__c));
                bill.cllease__Rental_Due_Amount__c = (bill.cllease__Rental_Due_Amount__c)*(1-EquipProportion.get(bill.cllease__Lease_Account__c));
                bill.cllease__Total_Due_Amount__c = (bill.cllease__Total_Due_Amount__c)*(1-EquipProportion.get(bill.cllease__Lease_Account__c));
                system.debug('*********Bill cllease__Total_Paid_Amount__c AFTER UPDATE:'+ bill.cllease__Total_Paid_Amount__c);
            }
        }
        system.debug('************Bills*****************' + Bills);
    }
    update Bills;*/

}