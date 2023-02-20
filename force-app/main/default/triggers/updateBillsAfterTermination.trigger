trigger updateBillsAfterTermination on cllease__Lease_Account__c (after update,After Insert) {
    //system.debug('**************Trigger Start***********************');
  /*  List<Id> ContractId = new List<Id>();
    List<cllease__Lease_account_Due_Details__c> Bills = new List<cllease__Lease_account_Due_Details__c>();
    Map<Id,Date> ExpiryDateMap = new Map<Id,Date>();
    List<cllease__Termination_Quote_Header__c> TermQuoteList = new List<cllease__Termination_Quote_Header__c>();*/
    List<id> AgreementIdsforZoho=new List<id>();
   
    Saf_setting__c objsettings = Saf_setting__c.getOrgDefaults();
    if(!objsettings.DisableAgreementTriggers__c)
    {     
           
       for(cllease__Lease_Account__c contract: trigger.new){
       if(System.IsBatch() == false)
        {
            If(Trigger.isUpdate)
            {
             AgreementIdsforZoho.add(contract.id);
            //system.debug('*******Contract id from Trigger updateBillsAfterTermination*******:'+ contract.id);
            //system.debug('*******Contract Status from Trigger updateBillsAfterTermination*******:'+ contract.cllease__Lease_Status__c);
           /* if(contract.cllease__Lease_Status__c == 'TERMINATED'){
                ContractId.add(contract.Id);
            }*/
           }
            else { AgreementIdsforZoho.add(contract.id);}
        }
        }
        
      /*  //Create Map of contract id and Expiry Date
        TermQuoteList = [SELECT cllease__Contract__c,cllease__Effective_To__c FROM cllease__Termination_Quote_Header__c WHERE cllease__Status__c = 'TERMINATION PROCESSED' AND cllease__Contract__c = :ContractId ORDER BY cllease__Contract__c,LastModifiedDate];
        for(cllease__Termination_Quote_Header__c termQuote: TermQuoteList){
            ExpiryDateMap.put(termQuote.cllease__Contract__c,termQuote.cllease__Effective_To__c);        
        }
        system.debug('**********ExpiryDateMap*************' + ExpiryDateMap);
         
        Bills = [SELECT name,cllease__Lease_Account__c,cllease__Due_Type_Description__c,cllease__Due_Date__c,cllease__Rental_Due_Amount__c,cllease__Total_Due_Amount__c,cllease__Total_Paid_Amount__c,cllease__Payment_Satisfied__c FROM cllease__Lease_account_Due_Details__c where cllease__Lease_Account__c = :ContractId];
        if(Bills.size()>0){
            for(cllease__Lease_account_Due_Details__c bill: Bills){
                if(bill.cllease__Due_Type_Description__c == 'BILL / DUE DATE' && bill.cllease__Payment_Satisfied__c == false && (bill.cllease__Due_Date__c > ExpiryDateMap.get(bill.cllease__Lease_Account__c))){
                    system.debug('*********Bill:'+ bill.name);
                    //bill.cllease__Total_Paid_Amount__c = 0;
                    bill.cllease__Rental_Due_Amount__c = 0;
                    bill.cllease__Total_Due_Amount__c = 0;
                }
            }
        }    
        update Bills;*/
        if (trigger.isUpdate || trigger.isInsert) 
        {  
            if(HelperClass1.firstRunZohoContract){
                
                //system.debug('trigger.isUpdate: ' + trigger.isUpdate);
                for(cllease__Lease_Account__c objacc:trigger.New)
                {
                   
                  //AgreementIdsforZoho.add(objacc.id); 
                   if(System.IsBatch() == false && System.isFuture() == false)
                    {  
                          Saf_ZohoLSContract.CreateInZoho(AgreementIdsforZoho,false);
                         
                    }
                }
        
        //system.debug('**************Trigger End***********************');
            }HelperClass1.firstRunZohoContract =false;
        }
   }
}