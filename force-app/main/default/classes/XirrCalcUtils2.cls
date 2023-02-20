Global class XirrCalcUtils2 {
    private static final double tol = 0.001;   
    private static XIRR_Rates__c Xr_Setting = XIRR_Rates__c.getOrgDefaults();
    
    private static List<string> getFees(string strRate){
        strRate = strRate +'%';//'Rate3'
        List<XIRR_settings__c> lstXr = [select XIRR_Fee_Name__r.Name,Id,Name from XIRR_settings__c where Name LIKE:strRate];
        List<string> strreturn =new List<string>();
        for(XIRR_settings__c objxr: lstXr){
           strreturn.add(objxr.XIRR_Fee_Name__r.Name);
         }
       
        system.debug('strreturn :' +strreturn);
        return strreturn;
    }        
        
    private static double dateDiff(Datetime d1, Datetime d2){
            long day = 24*60*60*1000L;
            double dateDiff = (d1.getTime() - d2.getTime())/day;
        
        // system.debug('dt1=>'+d1.getTime());
        // system.debug('dt2=>'+d2.getTime());
        
        //system.debug('dateDiff=>'+dateDiff);
            return dateDiff;
        }
       public static double calculateRate(Double xirr){ 
       double d = 0;//Rate = [Rate = 12 * ( ( 1+ XIRR) ^ (1/12) – 1) ]
          double part1 = ( 1+ xirr);
          double part2 = (1/12.0);
      
          double rate1 = math.pow(part1, part2) -1;
          system.debug('======rate1'+rate1);
          rate1 = 12.0* rate1*100.0;
          return rate1;
       
       }
       Webservice static string xirrCalculation_1to5(String leaseAccId)
     {
          string strVal = 'No streams or equipments found.Please generate streams or create equipments and try again.';
         try
         {
            
             Integer IntStreams = [select count() from cllease__Payment_Stream__c where Included__c = TRUE AND cllease__Contract__c =:leaseAccId];
             Integer IntEquipments = [select count() from cllease__Contract_Equipment__c where cllease__Contract__c =:leaseAccId];
            //List<cllease__Lease_account_Due_Details__c> bills = [select id,cllease__Total_Due_Amount__c,cllease__Transaction_Date__c,cllease__Due_Type_Description__c,cllease__Account__c,cllease__Lease_Account__c from cllease__Lease_account_Due_Details__c where cllease__Lease_Account__c =:leaseAccId  and cllease__Due_Type_Description__c =: 'TERMINATION'];
            
            //added by sumit
            List<cllease__Other_Transaction__c> txns = [select id,cllease__Unbilled_Rent__c,cllease__Txn_Date__c,cllease__Transaction_Type__c,cllease__Unearned_Lease_Income_Amount__c, cllease__Lease_Account__c from cllease__Other_Transaction__c where cllease__Lease_Account__c =:leaseAccId  and cllease__Transaction_Type__c =: 'TERMINATION'];
            if(IntStreams > 0 && IntEquipments > 0)
            {
                 //Double val1 = xirrCalculation1(leaseAccId,bills);
                 //Double val2 = xirrCalculation2(leaseAccId,bills);
                 //Double val3 = xirrCalculation3(leaseAccId,bills);
                 //Double val4 = xirrCalculation4(leaseAccId,bills);
                 //Double val5 = xirrCalculation5(leaseAccId,bills);
                
                //added by sumit
                 Double val1 = xirrCalculation1(leaseAccId,txns);
                 Double val2 = xirrCalculation2(leaseAccId,txns);
                 Double val3 = xirrCalculation3(leaseAccId,txns);
                 Double val4 = xirrCalculation4(leaseAccId,txns);
                 Double val5 = xirrCalculation5(leaseAccId,txns);
                 
                 strVal = 'xirr1 :' + val1 + '\n'+ ' xirr2 :' + val2 +'\n'+ ' xirr3 :' + val3 +'\n'+ ' xirr4 :' + val4 +'\n'+' xirr5 :' + val5;
            }
       }
         catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes = 'Error :' + e.getMessage() + ', Line no: '+e.getLineNumber();
              strVal = strErrordes;
            system.debug('Error in XIRR :' + strErrordes);
        }
         return strVal;
     }
      //static double xirrCalculation1(String leaseAccId,List<cllease__Lease_account_Due_Details__c> bills)
      static double xirrCalculation1(String leaseAccId,List<cllease__Other_Transaction__c> txns)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
         cllease__Lease_Account__c agreement = [select id,cllease__Financed_Amount__c,cllease__Contract_Date__c,(select id,cllease__Date__c,cllease__Payment_Type__c,cllease__Rental_Amount__c from cllease__Payment_Streams__r where Included__c = TRUE AND cllease__Payment_Type__c = 'RENT') from cllease__Lease_Account__c where id =:leaseAccId];
        
         paymentAmount.add(-agreement.cllease__Financed_Amount__c);
         paymentDate.add(agreement.cllease__Contract_Date__c);
    
         double guess = 0.1;
         for(cllease__Payment_Stream__c ps : agreement.cllease__Payment_Streams__r){
             paymentAmount.add(double.valueof(ps.cllease__Rental_Amount__c));
             paymentDate.add(ps.cllease__Date__c);
         }
         
          //for(cllease__Lease_account_Due_Details__c bill : bills){
            // paymentAmount.add(double.valueof(bill.cllease__Total_Due_Amount__c));
            // paymentDate.add(bill.cllease__Transaction_Date__c);
         //}
        
        for(cllease__Other_Transaction__c txn : txns){
             paymentAmount.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
             paymentDate.add(txn.cllease__Txn_Date__c);
         }
          
         double val= Newtons_method(guess,paymentAmount,paymentDate);
         double val1 = decimal.valueof(val).setscale(5);
         agreement.XIRR1__c =  calculateRate(val1);
        
         update agreement;
         return agreement.XIRR1__c;
     }
       //static double xirrCalculation2(String leaseAccId,List<cllease__Lease_account_Due_Details__c> bills)
       static double xirrCalculation2(String leaseAccId,List<cllease__Other_Transaction__c> txns)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
         List<string> Lstfeesinquery = getFees(Xr_Setting.Rate2__c);//'Rate2'
         cllease__Lease_Account__c agreement = [select id,cllease__Financed_Amount__c,cllease__Contract_Date__c,(select id,cllease__Date__c,cllease__Payment_Type__c ,cllease__Rental_Amount__c from cllease__Payment_Streams__r where Included__c = TRUE AND cllease__Payment_Type__c = 'RENT' ),(select id,cllease__Amount__c,cllease__start_date__c,cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Definition__r.Name, cllease__Total_Payment_Amount__c from cllease__Contract_Fees__r where cllease__Fee_Definition__r.name IN: Lstfeesinquery ) from cllease__Lease_Account__c where id =:leaseAccId];
    
         paymentAmount.add(-agreement.cllease__Financed_Amount__c);
         paymentDate.add(agreement.cllease__Contract_Date__c);
         
          for(cllease__Contract_Fees__c fees:agreement.cllease__Contract_Fees__r)
         {
         if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
         {paymentAmount.add(fees.cllease__Total_Payment_Amount__c); }
         else
         {paymentAmount.add(-fees.cllease__Total_Payment_Amount__c); }
         
         paymentDate.add(fees.cllease__start_date__c);
           system.debug('**fees.cllease__Amount__c**'+fees.cllease__Total_Payment_Amount__c);  
          
         } 
         double guess = 0.1;
         for(cllease__Payment_Stream__c ps : agreement.cllease__Payment_Streams__r){
             paymentAmount.add(double.valueof(ps.cllease__Rental_Amount__c));
             paymentDate.add(ps.cllease__Date__c);
              system.debug('**fees.cllease__Amount__c1**'+double.valueof(ps.cllease__Rental_Amount__c)); 
              
         }
           //for(cllease__Lease_account_Due_Details__c bill : bills){
             //paymentAmount.add(double.valueof(bill.cllease__Total_Due_Amount__c));
             //paymentDate.add(bill.cllease__Transaction_Date__c);
         //} 

        for(cllease__Other_Transaction__c txn : txns){
             paymentAmount.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
             paymentDate.add(txn.cllease__Txn_Date__c);
         }
         
         double val= Newtons_method(guess,paymentAmount,paymentDate);
         double val1 = decimal.valueof(val).setscale(5);
         agreement.XIRR2__c =  calculateRate(val1);
        
         update agreement;
         return agreement.XIRR2__c;
     }
       //static double xirrCalculation3(String leaseAccId,List<cllease__Lease_account_Due_Details__c> bills)
       static double xirrCalculation3(String leaseAccId,List<cllease__Other_Transaction__c> txns)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
         List<string> Lstfeesinquery = getFees(Xr_Setting.Rate3__c);
         cllease__Lease_Account__c agreement = [select id,cllease__Financed_Amount__c,cllease__Contract_Date__c,(select id,cllease__Date__c,cllease__Rental_Amount__c,cllease__Payment_Type__c  from cllease__Payment_Streams__r  where Included__c = TRUE AND cllease__Payment_Type__c = 'RENT'),(select id,cllease__Amount__c,cllease__start_date__c,cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Definition__r.Name, cllease__Total_Payment_Amount__c from cllease__Contract_Fees__r where cllease__Fee_Definition__r.name IN: Lstfeesinquery) from cllease__Lease_Account__c where id =:leaseAccId];//'Broker Commission'
                      system.debug('**agreement.cllease__Expense_Fees__r**'+agreement.cllease__Contract_Fees__r.size());

         paymentAmount.add(-agreement.cllease__Financed_Amount__c);
         paymentDate.add(agreement.cllease__Contract_Date__c);
         
        for(cllease__Contract_Fees__c fees:agreement.cllease__Contract_Fees__r)
         {
         if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
             {paymentAmount.add(fees.cllease__Total_Payment_Amount__c); }
         else
             {paymentAmount.add(-fees.cllease__Total_Payment_Amount__c); }
         
         paymentDate.add(fees.cllease__start_date__c);
           system.debug('**fees.cllease__Amount__c**'+fees.cllease__Total_Payment_Amount__c);  
         } 
         double guess = 0.1;
                 
         for(cllease__Payment_Stream__c ps : agreement.cllease__Payment_Streams__r){
             paymentAmount.add(double.valueof(ps.cllease__Rental_Amount__c));
             paymentDate.add(ps.cllease__Date__c);
              system.debug('**fees.cllease__Amount__c1**'+double.valueof(ps.cllease__Rental_Amount__c)); 
         } 
                  
           //for(cllease__Lease_account_Due_Details__c bill : bills){
            //paymentAmount.add(double.valueof(bill.cllease__Total_Due_Amount__c));
             //paymentDate.add(bill.cllease__Transaction_Date__c);
         //}
         for(cllease__Other_Transaction__c txn : txns){
             paymentAmount.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
             paymentDate.add(txn.cllease__Txn_Date__c);
         }
         double val= Newtons_method(guess,paymentAmount,paymentDate);
         
         double val1 = decimal.valueof(val).setscale(5);
         agreement.XIRR3__c =  calculateRate(val1);
        
         update agreement;
         return agreement.XIRR3__c;
         
     }
       //static double xirrCalculation4(String leaseAccId,List<cllease__Lease_account_Due_Details__c> bills)
       static double xirrCalculation4(String leaseAccId,List<cllease__Other_Transaction__c> txns)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
          List<string> Lstfeesinquery = getFees(Xr_Setting.Rate4__c);
         cllease__Lease_Account__c agreement = [select id,cllease__Financed_Amount__c,cllease__Contract_Date__c,(select id,cllease__Date__c,cllease__Rental_Amount__c,cllease__Payment_Type__c from cllease__Payment_Streams__r  where Included__c = TRUE AND cllease__Payment_Type__c = 'RENT'),(select id,cllease__Amount__c,cllease__start_date__c,cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Definition__r.Name, cllease__Total_Payment_Amount__c from cllease__Contract_Fees__r where cllease__Fee_Definition__r.name in:Lstfeesinquery) from cllease__Lease_Account__c where id =:leaseAccId];//'Broker Commission','Sales Commission','Internal commission'
    
         paymentAmount.add(-agreement.cllease__Financed_Amount__c);
         paymentDate.add(agreement.cllease__Contract_Date__c);
         for(cllease__Contract_Fees__c fees:agreement.cllease__Contract_Fees__r)
         {
           if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
         {paymentAmount.add(fees.cllease__Total_Payment_Amount__c); }
         else
         {paymentAmount.add(-fees.cllease__Total_Payment_Amount__c); }
         
         paymentDate.add(fees.cllease__start_date__c);
           system.debug('**fees.cllease__Amount__c**'+fees.cllease__Total_Payment_Amount__c);  
         } 
         double guess = 0.1;
         
         for(cllease__Payment_Stream__c ps : agreement.cllease__Payment_Streams__r){
             paymentAmount.add(double.valueof(ps.cllease__Rental_Amount__c));
             paymentDate.add(ps.cllease__Date__c);
              system.debug('**fees.cllease__Amount__c1**'+double.valueof(ps.cllease__Rental_Amount__c)); 
         }
           //for(cllease__Lease_account_Due_Details__c bill : bills){
             //paymentAmount.add(double.valueof(bill.cllease__Total_Due_Amount__c));
             //paymentDate.add(bill.cllease__Transaction_Date__c);
         //} 
         
         for(cllease__Other_Transaction__c txn : txns){
             paymentAmount.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
             paymentDate.add(txn.cllease__Txn_Date__c);
         }
           
         double val= Newtons_method(guess,paymentAmount,paymentDate);
       
         double val1 = decimal.valueof(val).setscale(5);
         agreement.XIRR4__c =  calculateRate(val1);
        
         update agreement;
         return agreement.XIRR4__c;
     } 
     //static double xirrCalculation5(String leaseAccId,List<cllease__Lease_account_Due_Details__c> bills)
     static double xirrCalculation5(String leaseAccId,List<cllease__Other_Transaction__c> txns)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
          List<string> Lstfeesinquery = getFees(Xr_Setting.Rate5__c);
         cllease__Lease_Account__c agreement = [select id,cllease__Financed_Amount__c,cllease__Contract_Date__c,(select id,cllease__Date__c,cllease__Rental_Amount__c,cllease__Payment_Type__c from cllease__Payment_Streams__r where Included__c = TRUE AND cllease__Payment_Type__c = 'RENT' ),(select id,cllease__Amount__c,cllease__start_date__c,cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Definition__r.Name, cllease__Total_Payment_Amount__c from cllease__Contract_Fees__r where cllease__Fee_Definition__r.name in:Lstfeesinquery) from cllease__Lease_Account__c where id =:leaseAccId];// ('Broker Commission','Sales Commission','Internal commission')
    
         paymentAmount.add(-agreement.cllease__Financed_Amount__c);
         paymentDate.add(agreement.cllease__Contract_Date__c);
         for(cllease__Contract_Fees__c fees:agreement.cllease__Contract_Fees__r)
         {
           if (fees.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')
         {paymentAmount.add(fees.cllease__Total_Payment_Amount__c); }
         else
         {paymentAmount.add(-fees.cllease__Total_Payment_Amount__c); }
         paymentDate.add(fees.cllease__start_date__c);
           system.debug('**fees.cllease__Amount__c**'+fees.cllease__Total_Payment_Amount__c);  
         } 
         double guess = 0.1;
         for(cllease__Payment_Stream__c ps : agreement.cllease__Payment_Streams__r){
             paymentAmount.add(double.valueof(ps.cllease__Rental_Amount__c));
             paymentDate.add(ps.cllease__Date__c);
              system.debug('**fees.cllease__Amount__c1**'+double.valueof(ps.cllease__Rental_Amount__c)); 
         }
           //for(cllease__Lease_account_Due_Details__c bill : bills){
             //paymentAmount.add(double.valueof(bill.cllease__Total_Due_Amount__c));
             //paymentDate.add(bill.cllease__Transaction_Date__c);
         //}

        for(cllease__Other_Transaction__c txn : txns){
             paymentAmount.add(double.valueof(txn.cllease__Unbilled_Rent__c - txn.cllease__Unearned_Lease_Income_Amount__c));
             paymentDate.add(txn.cllease__Txn_Date__c);
             
        }
         double val= Newtons_method(guess,paymentAmount,paymentDate);
        
         double val1 = decimal.valueof(val).setscale(5);
         agreement.XIRR5__c =  calculateRate(val1);
         update agreement;
         return agreement.XIRR5__c;
     } 
    
     private static double f_xirr(double p, Datetime dt, Datetime dt1, double x) {       
            double val1 =   1 + x;
            double val6 = dateDiff(dt1,dt)/365.0;
         
        //  double df_xirr = (1.0 / 365.0) * dateDiff(dt1,dt) * p * ((x + 1).math.pow((Integer.valueOf(dateDiff(dt1,dt))/ 365) - 1));
         
      // if(val6 == 0)
      // {
       //     val1=1;
      // }
         
        // for(integer i =0; i<val6; i++)
       // {
           // val1 = val1*val1;
      //  }
            
         double f_xirr = math.pow(val1,val6);
         
          //system.debug('val6 is=>'+val6);
          //system.debug('val1 is=>'+val1);
         
         //system.debug('======f_xirr'+f_xirr);
            double val4 = p*f_xirr;
        //system.debug('======val4'+val4);
            
            system.debug('f_xirr=>'+val4);
            return val4;
        }
    Public static double df_xirr(double p, Date dt, Date dt0, double x) {  
             
        double power = (dateDiff(dt0,dt)/ 365) - 1.0;
        //system.debug('======power'+power);
        double d1 = x+1.0;
        //system.debug('======d1'+d1);
        //for(integer i =0; i<power; i++)
        //{
           // d1 = d1*d1;
        //}
        
        d1= math.pow(d1, power);
        
        system.debug('======d1'+d1);
        
        double c = 1.0 / 365.0;
        
            double df_xirr = c * dateDiff(dt0,dt) * p * (d1);
            
        system.debug('df_xirr=>'+df_xirr);
            return df_xirr;
        }
    public static double total_f_xirr(list<double> payments, list<Date> days, double x) {
            double resf = 0.0;

            for (Integer i = 0; i < payments.size(); i++) {
                resf = resf + f_xirr(payments[i], days[i], days[0], x);
                //system.debug('======resf'+resf);
            
            }

             system.debug('total_f_xirr=>'+resf);
        
            return resf;
        }
    public static double total_df_xirr(list<double> payments, list<Date> days, double x) {
            double resf1 = 0.0;

            for (Integer i = 0; i < payments.size(); i++) {
                resf1 = resf1 + df_xirr(payments[i], days[i], days[0], x);
                //system.debug('======resf1'+resf1);
            }

         system.debug('total_df_xirr=>'+resf1);
            return resf1;
        
        }
     public static double Newtons_method(double guess, list<double> payments, list<Date> days) {
            double x0 = guess; //here it is coming as 0.1
            double x1;
            double val1=10;
            list<double> paymentStream = payments;
            //system.debug('======paymentStream'+paymentStream);
            //long err = (Long)(val1.pow(100));
            
             for(double objdb : payments){
             system.debug('***Amount : ' +objdb);
             }
             
             for(Date objdt : days){
             system.debug('***Date : ' +objdt);
             }
            double err = 10;
                for(integer i =1; i<=100; i++){
                 err = err*10;
                }
            
            //system.debug('======err'+err);
            Integer i=1;
            //tol value is 0.001
            while (err > tol) {
                //system.debug('======tol'+tol);
            
                system.debug('============== Iteration '+i+'==============');
                double num = total_f_xirr(payments, days, x0);
                //system.debug('======num'+num);
                double denom = total_df_xirr(payments, days, x0);
                
                system.debug('======denom'+denom);
                
               // if(Integer.valueOf(num) != 0 && Integer.valueOf(denom) == 0)
                  //  return null;
                double ratio = num / denom;
                //system.debug('======ratio'+ratio);
                //double ratio = 1 / 2;
                //LOG.debug("denom is "+denom);             
                x1 = x0 - ratio;
                err = Math.abs(x1 - x0);                
                x0 = x1;
                i++;          
            }
         
         system.debug('Newtons_method=>'+x0);
            return x0;          
        }
    
   /*  public static double xirrFromNewtonsMethod(list<double> payments, list<Date> days) {
            boolean flag = false;
            double guess = 0.01;
            double x0 = Newtons_method(guess, payments, days);
            
            // Re calculating the XIRR value for NaN with next date for last transaction once            
            if( x0 == null) 
            {
                //LOG.debug("Inside of failure");
                days[days.size() - 1] = XIRRUtils1.moveToNextDate(days[days.size() - 1]);
                //LOG.debug('After failing with initial date trying with next date i.e. : '+days[days.length - 1]);
                x0 = Newtons_method(guess, payments, days);
                //LOG.debug("Final calc "+x0);
                flag = true;
                
           }
        system.debug('======xirrFromNewtonsMethod=>'+x0);
            return x0;
        }*/
}