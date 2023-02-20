trigger SAF_CapitalAllocation_bill on cllease__Lease_account_Due_Details__c (before insert,before update) {
        system.debug('SAF_CapitalAllocation_bill : ');
        list<date> lstdates = new list<date>();
        list<date> lstdatesOther = new list<date>();
        Map<string,double> mapdates = new Map<string,double>();
        Map<date,double> mapOtherdates = new Map<date,double>();
        Set<Id> contractIds = new set<Id>();
        Set<Id> billIds = new set<Id>();
        list<cllease__Rental_Stream__c> lststream = new list<cllease__Rental_Stream__c> ();
      // if(HelperClass3.firstRun){
        //list<cllease__Lease_account_Due_Details__c> lstbills = new list<cllease__Lease_account_Due_Details__c> ();
        Integer i = 1;
        for(cllease__Lease_account_Due_Details__c objbill:Trigger.New){
              //For loop for fetching the ID's
              i++;
              System.debug(logginglevel.Error,'i - '+i);
              if(trigger.isUpdate)
              {
               i++;
               System.debug(logginglevel.Error,'i - '+i);
                   cllease__Lease_account_Due_Details__c oldbill = Trigger.oldMap.get(objbill.Id);
                    Decimal oldvalue = trigger.oldMap.get(objbill.Id).Monthly_Income__c ;
                    Decimal NewValue = objbill.Monthly_Income__c;
                    system.debug('oldvalueIncome : ' + oldvalue);
                    system.debug('NewValueIncome : ' + NewValue);
                    if(oldvalue != NewValue || NewValue == 0)
                    { 
                        
                       lstdates.add(oldbill.cllease__Due_Date__c);
                       contractIds.add(oldbill.cllease__Lease_Account__c);
                       billIds.add(oldbill.Id);
                       System.debug('objbill.Id: ' + objbill.Id);
                       lstdatesOther.add(objbill.cllease__Transaction_Date__c);
                      
                    }
                    
              }
              if(trigger.isInsert)
              {
                i++;
                System.debug(logginglevel.Error,'i - '+i);
                lstdates.add(objbill.cllease__Due_Date__c);
                contractIds.add(objbill.cllease__Lease_Account__c);
                lstdatesOther.add(objbill.cllease__Transaction_Date__c);
                billIds.add(objbill.Id);
                 system.debug('**********billIds**************'+billIds);
              }
              System.debug(logginglevel.Error,'i - '+i);
        }
   
              
        if( lstdates.size() >0)
        {
          i++;
              System.debug(logginglevel.Error,'i - '+i);
           List<Integer> lstmonth = new  List<Integer>();
           List<Integer> lstyear = new List<Integer>(); 
             for(date objdate:lstdates)
             {
               i++;
                System.debug(logginglevel.Error,'i - '+i);
              lstmonth.add(objdate.month());
              lstyear.add(objdate.year());
             }
           lststream=[select id,Name,cllease__Monthly_Income__c,cllease__Date__c,Monthly_Income_Date__c,cllease__Contract__c from cllease__Rental_Stream__c where cllease__Contract__c In : contractIds and CALENDAR_MONTH(Monthly_Income_Date__c) In: lstmonth and CALENDAR_YEAR(Monthly_Income_Date__c) In: lstyear];
           system.debug('**********lststream**************'+lststream);
           i++;
            System.debug(logginglevel.Error,'i - '+i);
           for(cllease__Rental_Stream__c objstream:lststream)
             {
               i++;
                System.debug(logginglevel.Error,'i - '+i);
              string strdate = string.valueof(objstream.Monthly_Income_Date__c.month()) + string.valueof(objstream.Monthly_Income_Date__c.year());
              mapdates.put(strdate + objstream.cllease__Contract__c,objstream.cllease__Monthly_Income__c);
              
             }
             i++;
                System.debug(logginglevel.Error,'i - '+i);
          List<cllease__Other_Transaction__c> lstotherTxn = [select cllease__Transaction_Type__c,cllease__Unearned_Lease_Income_Amount__c,cllease__Unbilled_Rent__c,cllease__Lease_Account__c,cllease__Txn_Date__c from cllease__Other_Transaction__c where cllease__Transaction_Type__c = 'TERMINATION' and cllease__Lease_Account__c In : contractIds and cllease__Txn_Date__c In :lstdatesOther];
            System.debug('lstotherTxn :' +lstotherTxn);  System.debug('lstdatesOther:' +lstdatesOther); System.debug('contractIds :' +contractIds );
           for(cllease__Other_Transaction__c objtxn:lstotherTxn)
             {
               i++;
                System.debug(logginglevel.Error,'i - '+i);
              //string strdate = string.valueof(objstream.cllease__Date__c.month()) + string.valueof(objstream.cllease__Date__c.year());
              //mapOtherdates.put(objtxn.cllease__Txn_Date__c, objtxn.cllease__Unearned_Lease_Income_Amount__c); - Removed by Sumit
              mapOtherdates.put(objtxn.cllease__Txn_Date__c,(objtxn.cllease__Unbilled_Rent__c - objtxn.cllease__Unearned_Lease_Income_Amount__c));   //Added by Sumit
             }
        } 
       for(cllease__Lease_account_Due_Details__c objbill:Trigger.New){
              //For loop for fetching the ID's
              i++;
                System.debug(logginglevel.Error,'i - '+i);
               string strdate = string.valueof(objbill.cllease__Due_Date__c.month()) + string.valueof(objbill.cllease__Due_Date__c.year()) + objbill.cllease__Lease_Account__c;
              if(trigger.isbefore && mapdates.containsKey(strdate))
              { 
                If(objbill.cllease__Status__c == 'Tax Calculated' && objbill.cllease__Due_Type_Description__c == 'BILL / DUE DATE') 
                {
                  system.debug('**********objbill**************'+objbill);
                  objbill.Monthly_Income__c =  mapdates.get(strdate);
                  system.debug('**********objbill.Monthly_Income__c*******'+objbill.Monthly_Income__c);
                 }
                
              }
               if(trigger.isbefore && mapOtherdates.containsKey(objbill.cllease__Transaction_Date__c))
               {
               if(objbill.cllease__Status__c == 'Tax Calculated' && objbill.cllease__Due_Type_Description__c == 'Termination') 
                 {
                  system.debug('**********objbill**************'+objbill);
                  //objbill.Monthly_Income__c =  mapOtherdates.get(objbill.cllease__Transaction_Date__c); - Removed by Sumit
                  objbill.Monthly_Capital__c =  mapOtherdates.get(objbill.cllease__Transaction_Date__c);  //Added by sumit
                 }
               }
            }

                System.debug(logginglevel.Error,'i - '+i);
     
    }