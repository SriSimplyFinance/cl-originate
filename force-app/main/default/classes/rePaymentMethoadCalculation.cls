global class rePaymentMethoadCalculation
{
       public static Void calculateRepayMethod(List<ID> agreementIds)
       {
           try{   
           List<cllease__Lease_Account__c> updateContract = New List<cllease__Lease_Account__c>();
              Integer Percent_of_Last_Stream_for_Baloon = Integer.valueof(Label.Percent_of_Last_Stream_for_Baloon); 
              Integer Count_of_Payment_Schedule_for_Structured = Integer.valueof(Label.Count_of_Payment_Schedule_for_Structured); 
             
              User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
              Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
             //Get the month and year of Branch date
                Integer IntMon = TodaysDate.month(); 
                Integer Intyear = TodaysDate.year(); 
                
              Map<Id,PaymentStreams> Payschedule = new Map<Id,PaymentStreams>();
              AggregateResult[] groupedResults = [select Max(cllease__Number_Of_Payments__c)NO ,cllease__Contract__c,cllease__Frequency__c   from cllease__Payment_Schedule__c where cllease__Contract__c in :agreementIds group by cllease__Contract__c,cllease__Frequency__c];
              for (AggregateResult ar : groupedResults)  {
                    
                    PaymentStreams psold = new PaymentStreams();
                    psold.NoOfPayments = Integer.valueof(ar.get('NO'));
                    psold.contract = string.valueof(ar.get('cllease__Contract__c'));
                    psold.frequency = string.valueof(ar.get('cllease__Frequency__c'));
                    //System.debug('psold:' + psold);                 
                    if(Payschedule.containskey(psold.contract))
                    {        
                       PaymentStreams psnew = Payschedule.get(psold.contract);
                     // System.debug('psnew :' + psnew);
                      
                      If(psnew.NoOfPayments > psold.NoOfPayments)
                      {
                      
                       Payschedule.put(psnew.contract,psnew); 
                      }
                      else
                    { Payschedule.put(psold.contract,psold);}                  
                    } else
                    { Payschedule.put(psold.contract,psold);}
              }
               system.debug('Payschedule ####'+Payschedule);
              
          //Get all payment streams for the agreements*****************************************************************
         string paymenttype = '%RENT%';
         List<cllease__Payment_Stream__c> lstpst = [SELECT id,Name,cllease__Active__c,cllease__Rental_Amount__c,
         cllease__Contract__c,cllease__Date__c ,cllease__Payment_Date__c,cllease__Payment_Type__c,cllease__Schedule_Sequence__c
         from cllease__Payment_Stream__c 
         where CALENDAR_MONTH(cllease__Date__c) =:IntMon and CALENDAR_YEAR(cllease__Date__c) =: Intyear and 
         cllease__Contract__c In : agreementIds and cllease__Active__c =: true and cllease__Payment_Type__c like: paymenttype];
         
          Map<Id,PaymentStreams> mapPstIds = new Map<Id,PaymentStreams>();
         
           
          // populate the streams in map related to the agreement.This calulates the monthly payment amount for the particular agreement
          for(cllease__Payment_Stream__c objpst:lstpst){ 
              PaymentStreams pst = new PaymentStreams();
              pst.Monthlypayment = objpst.cllease__Rental_Amount__c ;
             // pst.Frequency = objpst.cllease__Frequency__c;
                           
              if(mapPstIds.containskey(objpst.cllease__Contract__c)) {
               pst.Monthlypayment = pst.Monthlypayment + mapPstIds.get(objpst.cllease__Contract__c).Monthlypayment;
               }
               
              
              mapPstIds.put(objpst.cllease__Contract__c,pst); 
              
          } //end of payment stream 
               
              for(cllease__Lease_Account__c contract: [Select id,MaxFrequency__c,Cais_MonthlyPayment__c,cllease__Repayment_Billing_Method__c,Total_Amount_Financed__c,(Select Id, cllease__Contract__c, cllease__Rental_Amount__c FROM cllease__Payment_Streams__r where cllease__Period_Start_Date__c != null order by ID desc Limit 1),(Select Id FROM cllease__Payment_Schedule__r) from cllease__Lease_Account__c where id in :agreementIds])
              {              
           
              Decimal streamAmount;
              Integer countStream;
              String payMethod;
                 
                 //for the ticket #161632, repayment billing method calculation
                  if(contract.cllease__Payment_Streams__r.size()>0)
                  {
                         cllease__Payment_Stream__c ps = contract.cllease__Payment_Streams__r;
                  
                         Decimal amount = (Percent_of_Last_Stream_for_Baloon *(contract.Total_Amount_Financed__c))/100;
                         if(ps  != null)
                         streamAmount = ps.cllease__Rental_Amount__c;
                         if(contract.cllease__Payment_Schedule__r.size()>0)
                         countStream = contract.cllease__Payment_Schedule__r.size();
                         
                         system.debug('Count###'+countStream +'SteamAmount####'+streamAmount+'Amount####'+amount);                     
                         
                         if(streamAmount!= null && streamAmount>amount)
                         payMethod = 'Balloon';
                         else if(countStream != null && countStream > Count_of_Payment_Schedule_for_Structured )
                         payMethod = 'Structured';
                         else
                         payMethod = 'Amortization';
                         
                         system.debug('Repay methoad ####'+contract);
                         
                         if(contract.cllease__Repayment_Billing_Method__c != payMethod)
                         {
                         contract.cllease__Repayment_Billing_Method__c = payMethod;
                         updateContract.add(contract);
                         }
                    } //End of repayment billing method calculation
                  PaymentStreams pscom =  Payschedule.get(contract.Id);
                  system.debug('pscom   ####'+pscom);  
                  If(pscom != null && contract.MaxFrequency__c != pscom.Frequency)
                  {  
                       contract.MaxFrequency__c = pscom.Frequency; 
                       if(!updateContract.contains(contract))
                       { 
                          updateContract.add(contract);
                       }
                  }
                 // system.debug('contract.MaxFrequency__c  ####'+contract.MaxFrequency__c);  
                 PaymentStreams pst =   mappstIds.get(contract.ID);
                  //system.debug('pscom   ####'+pscom);  
                 if(mappstIds.Containskey(contract.ID) && contract.Cais_MonthlyPayment__c != pst.Monthlypayment) { 
                  
                  contract.Cais_MonthlyPayment__c = pst.Monthlypayment;
                     //system.debug('pst: '+ pst + 'contract.ID'+contract.ID);
                      if(!updateContract.contains(contract))
                       { 
                          updateContract.add(contract);
                       }
                  }
              }

              if(updateContract.size()>0)
                 update(updateContract);
        system.debug('updateContract  ####'+updateContract); 
           }
           catch(Exception e)
           {
               system.debug('Main Exception Mesage: '+e.getMessage());
                system.debug('Main Exception Line: '+e.getLineNumber());
                system.debug('Main Exception Cause: '+e.getCause());
           }
       }
     public Class PaymentStreams {
    public Decimal NoOfPayments{get; set;}
    public Decimal Monthlypayment{get; set;}
    public string Frequency{get; set;}
    public string Contract{get; set;}
     public PaymentStreams () {
     
          NoOfPayments = 0;
          Frequency = 'MONTHLY';
        }
    }
}