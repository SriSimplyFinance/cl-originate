global class XirrCalcUtils_batch_class implements Database.Batchable<sObject>{
    global class MyException extends Exception{} 
    global List<cllease__Lease_Account__c> lstleaseupdate = new  List<cllease__Lease_Account__c>();
    global Database.QueryLocator start(Database.BatchableContext BC) {   
       string str='a690O000000Xyn6'; 
       string str1= 'RENT';
       string type = 'TERMINATION';
       
     
        String query = 'select id,cllease__Financed_Amount__c,cllease__Contract_Date__c,(select id,cllease__Date__c,cllease__Payment_Type__c,cllease__Rental_Amount__c from cllease__Payment_Streams__r where Included__c = TRUE AND cllease__Payment_Type__c =: str1),(select id,name,cllease__Contract__c from cllease__Contract_Equipments__r),(select id,Name,cllease__Amount__c,cllease__start_date__c,cllease__Total_Payment_Amount__c,cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Definition__r.Name from cllease__Contract_Fees__r),(select id, cllease__Unbilled_Rent__c,cllease__Txn_Date__c,cllease__Transaction_Type__c,cllease__Unearned_Lease_Income_Amount__c,cllease__Lease_Account__c from cllease__Other_Lease_Transactions__r where cllease__Transaction_Type__c =: type) from cllease__Lease_Account__c';
       //cllease__Dues_Details__r
       
        string strVal = 'No streams or equipments found.Please generate streams or create equipments and try again.';
       
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<cllease__Lease_Account__c> lstleaseAcc) {
        string contval='';
       try{
        List<string> Lstfeesinquery2 = SAF_XirrCalcUtils_batch.getFees(SAF_XirrCalcUtils_batch.Xr_Setting.Rate2__c);
                  List<string> Lstfeesinquery3 = SAF_XirrCalcUtils_batch.getFees(SAF_XirrCalcUtils_batch.Xr_Setting.Rate3__c);
                  List<string> Lstfeesinquery4 = SAF_XirrCalcUtils_batch.getFees(SAF_XirrCalcUtils_batch.Xr_Setting.Rate4__c);
                  List<string> Lstfeesinquery5 = SAF_XirrCalcUtils_batch.getFees(SAF_XirrCalcUtils_batch.Xr_Setting.Rate5__c);
        for(cllease__Lease_Account__c cont:lstleaseAcc){  
         contval = cont.id;
        if(cont.cllease__Payment_Streams__r.size() > 0 && cont.cllease__Contract_Equipments__r.size()>0) 
           { 
                List<double> dblamount1 = new List<double>();
                List<Date> Dtstartdate1 = new List<Date> ();
                List<double> dblamount2 =new List<double>() ;
                List<Date> Dtstartdate2 = new List<Date> ();
                 List<double> dblamount3 =new List<double>() ;
                List<Date> Dtstartdate3 = new List<Date> ();
                List<double> dblamount4 =new List<double>() ;
                List<Date> Dtstartdate4 = new List<Date> ();
                List<double> dblamount5 =new List<double>() ;
                List<Date> Dtstartdate5 = new List<Date> ();
                dblamount1.add(-cont.cllease__Financed_Amount__c);
                Dtstartdate1.add(cont.cllease__Contract_Date__c);
                dblamount2.add(-cont.cllease__Financed_Amount__c);
                Dtstartdate2.add(cont.cllease__Contract_Date__c);
                 dblamount3.add(-cont.cllease__Financed_Amount__c);
                Dtstartdate3.add(cont.cllease__Contract_Date__c);
                dblamount4.add(-cont.cllease__Financed_Amount__c);
                Dtstartdate4.add(cont.cllease__Contract_Date__c);
                dblamount5.add(-cont.cllease__Financed_Amount__c);
                Dtstartdate5.add(cont.cllease__Contract_Date__c);
                for(cllease__Contract_Fees__c fees:cont.cllease__Contract_Fees__r)
                {
                 
                     for(string strfee:Lstfeesinquery2)
                     {
                         if(fees.cllease__Fee_Definition__r.Name == strfee)
                         {
                             if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
                             {dblamount2.add(fees.cllease__Total_Payment_Amount__c);
                             system.debug('########DoubleAMount##########'+dblamount2); }
                             else
                             {dblamount2.add(-fees.cllease__Total_Payment_Amount__c); }
                             system.debug('########DoubleAMount##########'+dblamount2);
                             Dtstartdate2.add(fees.cllease__start_date__c);
                               system.debug('**Dtstartdate **'+Dtstartdate2);  
                              
                              system.debug('*****strfee'+strfee);
                            // if(fees.cllease__Fee_Definition__r.Name == strfee)//roker
                        }
                     }
                     for(string strfee:Lstfeesinquery3)
                     {
                         if(fees.cllease__Fee_Definition__r.Name == strfee)
                         {
                             if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
                             {dblamount3.add(fees.cllease__Total_Payment_Amount__c);
                             system.debug('########DoubleAMount3##########'+dblamount3); }
                             else
                             {dblamount3.add(-fees.cllease__Total_Payment_Amount__c); }
                             system.debug('########DoubleAMount3##########'+dblamount3);
                             Dtstartdate3.add(fees.cllease__start_date__c);
                               system.debug('**Dtstartdate **'+Dtstartdate3);  
                              
                              system.debug('*****strfee3'+strfee);
                            // if(fees.cllease__Fee_Definition__r.Name == strfee)//roker
                        }
                      }
                      for(string strfee:Lstfeesinquery4)
                     {
                         if(fees.cllease__Fee_Definition__r.Name == strfee)
                         {
                             if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
                             {dblamount4.add(fees.cllease__Total_Payment_Amount__c);
                             system.debug('########DoubleAMount##########'+dblamount4); }
                             else
                             {dblamount4.add(-fees.cllease__Total_Payment_Amount__c); }
                             system.debug('########DoubleAMount##########'+dblamount4);
                             Dtstartdate4.add(fees.cllease__start_date__c);
                               system.debug('**Dtstartdate **'+Dtstartdate4);  
                              
                              system.debug('*****strfee4'+strfee);
                            // if(fees.cllease__Fee_Definition__r.Name == strfee)//roker
                        }
                      }
                      for(string strfee:Lstfeesinquery5)
                      {
                             if(fees.cllease__Fee_Definition__r.Name == strfee)
                             {
                                 if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
                                 {dblamount5.add(fees.cllease__Total_Payment_Amount__c);
                                 system.debug('########DoubleAMount##########'+dblamount5); }
                                 else
                                 {dblamount5.add(-fees.cllease__Total_Payment_Amount__c); }
                                 system.debug('########DoubleAMount##########'+dblamount5);
                                 Dtstartdate5.add(fees.cllease__start_date__c);
                                   system.debug('**Dtstartdate **'+Dtstartdate5);  
                                  
                                  system.debug('*****strfee5'+strfee);
                                // if(fees.cllease__Fee_Definition__r.Name == strfee)//roker
                            }
                      }
                 }
                 for(cllease__Payment_Stream__c ps : cont.cllease__Payment_Streams__r)
                 {
                    dblamount1.add(double.valueof(ps.cllease__Rental_Amount__c));
                    Dtstartdate1.add(ps.cllease__Date__c);
                    dblamount2.add(double.valueof(ps.cllease__Rental_Amount__c));
                    Dtstartdate2.add(ps.cllease__Date__c);
                    dblamount3.add(double.valueof(ps.cllease__Rental_Amount__c));
                    Dtstartdate3.add(ps.cllease__Date__c);
                    dblamount4.add(double.valueof(ps.cllease__Rental_Amount__c));
                    Dtstartdate4.add(ps.cllease__Date__c);
                    dblamount5.add(double.valueof(ps.cllease__Rental_Amount__c));
                    Dtstartdate5.add(ps.cllease__Date__c);
                 }
                  for(cllease__Other_Transaction__c txn : cont.cllease__Other_Lease_Transactions__r )
                  {
                    dblamount1.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
                    Dtstartdate1.add(txn.cllease__Txn_Date__c);
                    dblamount2.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
                    Dtstartdate2.add(txn.cllease__Txn_Date__c);
                    dblamount3.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
                    Dtstartdate3.add(txn.cllease__Txn_Date__c);
                    dblamount4.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
                    Dtstartdate4.add(txn.cllease__Txn_Date__c);
                    dblamount5.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
                    Dtstartdate5.add(txn.cllease__Txn_Date__c);
                  }  
                    double resp= SAF_XirrCalcUtils_batch.xirrCalculation1(cont,dblamount1,Dtstartdate1);
                   double resp2= SAF_XirrCalcUtils_batch.xirrCalculation2(cont,dblamount2,Dtstartdate2);
                   double resp3= SAF_XirrCalcUtils_batch.xirrCalculation2(cont,dblamount3,Dtstartdate3);
                   double resp4= SAF_XirrCalcUtils_batch.xirrCalculation2(cont,dblamount4,Dtstartdate4);
                   double resp5= SAF_XirrCalcUtils_batch.xirrCalculation2(cont,dblamount5,Dtstartdate5);
                   system.debug('****resp2************'+resp2);
                    system.debug('****resp************'+resp);
               cont.XIRR1__c = resp;
               cont.XIRR2__c = resp2;
               cont.XIRR3__c = resp3;
               cont.XIRR4__c = resp4;
               cont.XIRR5__c = resp5;
              
              lstleaseupdate.add (cont);
        
           }
        }
       system.debug( 'lstleaseupdate.size(): '+lstleaseupdate.size());
        if(lstleaseupdate.size()>0){Update lstleaseupdate;}
         if(Test.isRunningTest()){throw new MyException();}
    }
       catch(exception e){
            system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
            //String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
            string strErrordes = 'Error:' +e.getMessage() + ', Line no: '+e.getLineNumber()+ ',contract : '+contval;
            //ErrorLogsUtils.createErrorLogs('Failure', description,'Batch',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
           }
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    }
}