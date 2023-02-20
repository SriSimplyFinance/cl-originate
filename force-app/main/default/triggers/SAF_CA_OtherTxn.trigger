trigger SAF_CA_OtherTxn on cllease__Other_Transaction__c (after insert,after update) {
       system.debug('SAF_CA_OtherTxn : ');
        list<date> lstdatesOther = new list<date>();
        Map<date,double> mapOtherdates = new Map<date,double>();
        Set<Id> contractIds = new set<Id>();
        List<Id> OTds = new List<Id>();
        list<cllease__Rental_Stream__c> lststream = new list<cllease__Rental_Stream__c> ();
      // if(HelperClass3.firstRun)
        //list<cllease__Other_Transaction__c > lstbills = new list<cllease__Other_Transaction__c > ();
        for(cllease__Other_Transaction__c  objOT:Trigger.New){
              //For loop for fetching the ID's
              system.debug('inside objOT :' + objOT );
              if(trigger.isUpdate)
              {
               if(objOT.cllease__Transaction_Type__c =='BOOKING' || objOT.cllease__Transaction_Type__c =='TERMINATION' || objOT.cllease__Transaction_Type__c =='RESTRUCTURE')
                {
                   cllease__Other_Transaction__c  oldOT = Trigger.oldMap.get(objOT.Id);
                  /*  Decimal oldvalue = trigger.oldMap.get(objOT.Id).cllease__Unearned_Lease_Income_Amount__c;
                    Decimal NewValue = objOT.cllease__Unearned_Lease_Income_Amount__c;
                    system.debug('oldvalue : ' + oldvalue);
                    system.debug('NewValue : ' + NewValue);
                    if(oldvalue != NewValue || NewValue ==null)
                    { */
                        
                      
                       contractIds.add(oldOT.cllease__Lease_Account__c);
                       OTds.add(oldOT.Id);
                       system.debug('objOT.Id: ' + objOT.Id);
                       lstdatesOther.add(objOT.cllease__Txn_Date__c);
                       //}
                      
               }
              }
              if(trigger.isInsert)
              {
               if(objOT.cllease__Transaction_Type__c =='BOOKING' || objOT.cllease__Transaction_Type__c =='TERMINATION' || objOT.cllease__Transaction_Type__c =='RESTRUCTURE')
                {
                        contractIds.add(objOT.cllease__Lease_Account__c);
                        lstdatesOther.add(objOT.cllease__Txn_Date__c);
                        OTds.add(objOT.Id);
                        system.debug('**********OTds **************'+OTds );
                 }
              }
            }
   
      list<cllease__Lease_account_Due_Details__c> lstbills  = new list<cllease__Lease_account_Due_Details__c>([select cllease__Due_Type_Description__c,saf_Other_Transaction__c,cllease__Transaction_Date__c,Monthly_Income__c,id,Name, cllease__Lease_Account__c,cllease__Due_Date__c from cllease__Lease_account_Due_Details__c 
                     where cllease__Lease_Account__c in :contractIds and cllease__Due_Type_Description__c = 'TERMINATION' and cllease__Transaction_Date__c In:lstdatesOther and saf_Other_Transaction__c = '' order by cllease__Due_Date__c]);
       system.debug('lstbills  : ' + lstbills);
     // Map<Id,cllease__Lease_account_Due_Details__c> mapbills2 = new Map<Id,cllease__Lease_account_Due_Details__c>();
       for(cllease__Lease_account_Due_Details__c objbill:lstbills) {
                         
               objbill.saf_Other_Transaction__c = OTds[0];
              
            }
          if(lstbills.size()>0) {update lstbills ;}
           //Added Code for Xirr Ticket SAFCIF-240(Sprint 17)
            List<cllease__Lease_Account__c> agreementIds = new List<cllease__Lease_Account__c>();
            list<cllease__Lease_Account__c> lstcon = new list<cllease__Lease_Account__c>([select Id,Name from cllease__Lease_Account__c where Id in:contractIds]);
             system.debug('**********lstcon*******'+lstcon);
             for(cllease__Lease_Account__c objcon:lstcon)
             {
                XirrCalcUtils2.xirrCalculation_1to5(objcon.Id);
                 break;
             }
       // if(contractIds.size()>0){XirrCalcUtils2.xirrCalculation_1to5(agreementIds);}   
}