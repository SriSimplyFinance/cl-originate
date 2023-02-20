Global class AppXirrCalcUtilBO {
    private static final double tol = 0.001;   
    private static XIRR_Rates__c Xr_Setting = XIRR_Rates__c.getOrgDefaults();
    
    private static List<string> getFees(string strRate){
        strRate = strRate +'%';//'Rate3'
        List<XIRR_settings__c> lstXr = [select XIRR_Fee_Name__r.Name,Id,Name from XIRR_settings__c where Name LIKE:strRate];
        List<string> strreturn =new List<string>();
        for(XIRR_settings__c objxr: lstXr) {
            strreturn.add(objxr.XIRR_Fee_Name__r.Name);
        }
       
        system.debug('strreturn :' +strreturn);
        return strreturn;
    }        
        
    private static double dateDiff(Datetime d1, Datetime d2){
            long day = 24*60*60*1000L;
            double dateDiff = (d1.getTime() - d2.getTime())/day;
            return dateDiff;
        }
        
    public static double calculateRate(Double xirr) { 
        double d = 0;//Rate = [Rate = 12 * ( ( 1+ XIRR) ^ (1/12) – 1) ]
        double part1 = ( 1+ xirr);
        double part2 = (1/12.0);
        
        double rate1 = math.pow(part1, part2) -1;
        system.debug('======rate1'+rate1);
        rate1 = 12.0* rate1*100.0;
        return rate1;
        
    }
    
    public static string xirrCalculation_1to5(String applicationId) {
         
        try { 
            string strVal = 'No streams or equipments found.Please generate streams or create equipments and try again.';
            Integer IntStreams = [select count() from genesis__Payment_Stream__c where genesis__Application__c = :applicationId];
         
        
            if(IntStreams > 0) {
                 
                //added by sumit
                Double val1 = xirrCalculation1(applicationId);
                Double val2 = xirrCalculation2(applicationId);
                Double val3 = xirrCalculation3(applicationId);
                Double val4 = xirrCalculation4(applicationId);
                Double val5 = xirrCalculation5(applicationId);
                 
                //System.debug('xirr1 :' + val1 + '\n'+ ' xirr2 :' + val2 +'\n'+ ' xirr3 :' + val3 +'\n'+ ' xirr4 :' + val4 +'\n'+' xirr5 :' + val5);
                strVal = 'XIRR Calculated successfully.';
                
            }
           
             return strVal;
         } catch(Exception e){
             return e.getMessage();
         }
     }
     
    static double xirrCalculation1(String applicationId) {
        List<double> paymentAmount = new list<double>();
        list<date> paymentDate = new list<date>();
        genesis__Applications__c application = [Select id,Funder_Agreed_Advance__c,genesis__Expected_Start_Date__c,
                                                            genesis__Payment_Frequency__c,
                                                            (Select id,genesis__Start_Date__c,genesis__Sequence__c,
                                                                genesis__Number_of_Payments__c,genesis__Payment_Amount__c 
                                                            From genesis__Payment_Streams__r)
                                                        From genesis__Applications__c 
                                                        Where id = :applicationId];
        
        if(application.Funder_Agreed_Advance__c== null) {
            throw new genesis.OriginationException('Agreed advance can not be blank.');
        }
        if(application.genesis__Expected_Start_Date__c == null || application.genesis__Payment_Frequency__c == null){
            throw new genesis.OriginationException('Expected Start Date or Payment Frequency cannot be blank.');
        }
        
        paymentAmount.add(-application.Funder_Agreed_Advance__c);
        paymentDate.add(application.genesis__Expected_Start_Date__c);
        
        double guess = 0.1;
        for(genesis__Payment_Stream__c ps : application.genesis__Payment_Streams__r) {
            Integer i = 1;
            if(ps.genesis__Number_of_Payments__c == null || 
                    ps.genesis__Payment_Amount__c == null || 
                    ps.genesis__Start_Date__c ==null){
                
                throw new genesis.OriginationException('Payment Schedule values cannot be blank.');
            }
            while(i <= ps.genesis__Number_of_Payments__c) {
                paymentAmount.add(double.valueof(ps.genesis__Payment_Amount__c));
                Date nextCycleDate = genesis.DateUtil.getNextCycleDate(ps.genesis__Start_Date__c,
                                                                        ps.genesis__Start_Date__c.day(),
                                                                        application.genesis__Payment_Frequency__c,
                                                                        (i-1));
                paymentDate.add(nextCycleDate);
                System.debug(nextCycleDate);
                i++;
            }
        }
         
        
        double val= Newtons_method(guess,paymentAmount,paymentDate);
        double val1 = decimal.valueof(val).setscale(5);
        application.XIRR1__c =  calculateRate(val1);
        
        update application;
        return application.XIRR1__c;
    }
    
    static double xirrCalculation2(String applicationId) {
    
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
         List<string> Lstfeesinquery = getFees(Xr_Setting.Rate2__c);//'Rate2'
         genesis__Applications__c application = [Select id,Funder_Agreed_Advance__c,genesis__Expected_Start_Date__c,genesis__Payment_Frequency__c,
                                                         (Select id,genesis__Start_Date__c,genesis__Sequence__c,
                                                                 genesis__Number_of_Payments__c,genesis__Payment_Amount__c 
                                                             From genesis__Payment_Streams__r),
                                                         (select id,genesis__Amount__c,Start_Date_For_Agreement__c,
                                                                 genesis__Fee_Definition__r.clcommon__Class__c,genesis__Fee_Definition__r.Name
                                                             From genesis__Fee_Schedules__r 
                                                             Where genesis__Fee_Definition__r.name IN: Lstfeesinquery ) 
                                                        From genesis__Applications__c
                                                        Where id = :applicationId];
    
         paymentAmount.add(-application.Funder_Agreed_Advance__c);
         paymentDate.add(application.genesis__Expected_Start_Date__c);
         
        for(genesis__Fee_Schedule__c fees : application.genesis__Fee_Schedules__r) {
            
            if(fees.genesis__Fee_Definition__c == null || fees.genesis__Fee_Definition__r.clcommon__Class__c == null || 
                fees.genesis__Amount__c == null || fees.Start_Date_For_Agreement__c == null) {
                
                throw new genesis.OriginationException('Fees details cannot be blank.');
            }
             
         
         if (fees.genesis__Fee_Definition__r.clcommon__Class__c == 'Income') {
             paymentAmount.add(fees.genesis__Amount__c); 
         }
         else {
             paymentAmount.add(-fees.genesis__Amount__c); 
         }
         
         paymentDate.add(fees.Start_Date_For_Agreement__c);
           system.debug('**fees.cllease__Amount__c**'+fees.genesis__Amount__c);  
          
         } 
         double guess = 0.1;
         
         /*
         for(clleas__Payment_Stream__c ps : agreement.cllease__Payment_Streams__r){
             paymentAmount.add(double.valueof(ps.cllease__Rental_Amount__c));
             paymentDate.add(ps.cllease__Date__c);
              system.debug('**fees.cllease__Amount__c1**'+double.valueof(ps.cllease__Rental_Amount__c)); 
              
         }
         */
         
         for(genesis__Payment_Stream__c ps : application.genesis__Payment_Streams__r) {
            Integer i = 1;
            while(i <= ps.genesis__Number_of_Payments__c) {
                paymentAmount.add(double.valueof(ps.genesis__Payment_Amount__c));
                Date nextCycleDate = genesis.DateUtil.getNextCycleDate(ps.genesis__Start_Date__c,
                                                                        ps.genesis__Start_Date__c.day(),
                                                                        application.genesis__Payment_Frequency__c,
                                                                        (i-1));
                paymentDate.add(nextCycleDate);
                i++;
            }
        }
       
         double val= Newtons_method(guess,paymentAmount,paymentDate);
         double val1 = decimal.valueof(val).setscale(5);
         application.XIRR2__c =  calculateRate(val1);
        
         update application;
         return application.XIRR2__c;
     }

      
    static double xirrCalculation3(String applicationId) {
    
         List<double> paymentAmount = new list<double>();
         List<date> paymentDate = new list<date>();
         List<string> Lstfeesinquery = getFees(Xr_Setting.Rate3__c);
         genesis__Applications__c application = [Select id,Funder_Agreed_Advance__c,genesis__Expected_Start_Date__c,genesis__Payment_Frequency__c,
                                                         (Select id,genesis__Start_Date__c,genesis__Sequence__c,
                                                                 genesis__Number_of_Payments__c,genesis__Payment_Amount__c 
                                                             From genesis__Payment_Streams__r),
                                                         (select id,genesis__Amount__c,Start_Date_For_Agreement__c,
                                                                 genesis__Fee_Definition__r.clcommon__Class__c,genesis__Fee_Definition__r.Name
                                                             From genesis__Fee_Schedules__r 
                                                             Where genesis__Fee_Definition__r.name IN: Lstfeesinquery ) 
                                                        From genesis__Applications__c
                                                        Where id = :applicationId]; 
         
         
         paymentAmount.add(-application.Funder_Agreed_Advance__c);
         paymentDate.add(application.genesis__Expected_Start_Date__c);
         
        for(genesis__Fee_Schedule__c fees : application.genesis__Fee_Schedules__r) {
            if (fees.genesis__Fee_Definition__r.clcommon__Class__c == 'Income') {
                paymentAmount.add(fees.genesis__Amount__c); 
            }
            else {
                 paymentAmount.add(-fees.genesis__Amount__c); 
            }
             
            paymentDate.add(fees.Start_Date_For_Agreement__c);
            system.debug('**fees.cllease__Amount__c**'+fees.genesis__Amount__c);  
        }
         
        Double guess = 0.1;
                 
        for(genesis__Payment_Stream__c ps : application.genesis__Payment_Streams__r) {
            Integer i = 1;
            while(i <= ps.genesis__Number_of_Payments__c) {
                paymentAmount.add(double.valueof(ps.genesis__Payment_Amount__c));
                Date nextCycleDate = genesis.DateUtil.getNextCycleDate(ps.genesis__Start_Date__c,
                                                                        ps.genesis__Start_Date__c.day(),
                                                                        application.genesis__Payment_Frequency__c,
                                                                        (i-1));
                paymentDate.add(nextCycleDate);
                i++;
            }
        }
        
          
         double val= Newtons_method(guess,paymentAmount,paymentDate);
         
         double val1 = decimal.valueof(val).setscale(5);
         application.XIRR3__c =  calculateRate(val1);
        
         update application;
         return application.XIRR3__c;
         
     }
       //static double xirrCalculation4(String leaseAccId,List<cllease__Lease_account_Due_Details__c> bills)
       static double xirrCalculation4(String applicationId)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
         List<string> Lstfeesinquery = getFees(Xr_Setting.Rate4__c);
         
         genesis__Applications__c application = [Select id,Funder_Agreed_Advance__c,genesis__Expected_Start_Date__c,genesis__Payment_Frequency__c,
                                                         (Select id,genesis__Start_Date__c,genesis__Sequence__c,
                                                                 genesis__Number_of_Payments__c,genesis__Payment_Amount__c 
                                                             From genesis__Payment_Streams__r),
                                                         (select id,genesis__Amount__c,Start_Date_For_Agreement__c,
                                                                 genesis__Fee_Definition__r.clcommon__Class__c,genesis__Fee_Definition__r.Name
                                                             From genesis__Fee_Schedules__r 
                                                             Where genesis__Fee_Definition__r.name IN: Lstfeesinquery ) 
                                                        From genesis__Applications__c
                                                        Where id = :applicationId]; 
         
         paymentAmount.add(-application.Funder_Agreed_Advance__c);
         paymentDate.add(application.genesis__Expected_Start_Date__c);
         
         for(genesis__Fee_Schedule__c fees : application.genesis__Fee_Schedules__r) {
            if (fees.genesis__Fee_Definition__r.clcommon__Class__c == 'Income') {
                paymentAmount.add(fees.genesis__Amount__c); 
            }
            else {
                 paymentAmount.add(-fees.genesis__Amount__c); 
            }
             
            paymentDate.add(fees.Start_Date_For_Agreement__c);
            system.debug('**fees.cllease__Amount__c**'+fees.genesis__Amount__c);  
        }
        
        double guess = 0.1;
         
         for(genesis__Payment_Stream__c ps : application.genesis__Payment_Streams__r) {
            Integer i = 1;
            while(i <= ps.genesis__Number_of_Payments__c) {
                paymentAmount.add(double.valueof(ps.genesis__Payment_Amount__c));
                Date nextCycleDate = genesis.DateUtil.getNextCycleDate(ps.genesis__Start_Date__c,
                                                                        ps.genesis__Start_Date__c.day(),
                                                                        application.genesis__Payment_Frequency__c,
                                                                        (i-1));
                paymentDate.add(nextCycleDate);
                i++;
            }
        }
          
           
         double val= Newtons_method(guess,paymentAmount,paymentDate);
       
         double val1 = decimal.valueof(val).setscale(5);
         application.XIRR4__c =  calculateRate(val1);
        
         update application;
         return application.XIRR4__c;
     } 
    
     static double xirrCalculation5(String applicationId) {
         List<double> paymentAmount = new list<double>();
         List<date> paymentDate = new list<date>();
         List<string> Lstfeesinquery = getFees(Xr_Setting.Rate5__c);
         
         genesis__Applications__c application = [Select id,Funder_Agreed_Advance__c,genesis__Expected_Start_Date__c,genesis__Payment_Frequency__c,
                                                         (Select id,genesis__Start_Date__c,genesis__Sequence__c,
                                                                 genesis__Number_of_Payments__c,genesis__Payment_Amount__c 
                                                             From genesis__Payment_Streams__r),
                                                         (Select id,genesis__Amount__c,Start_Date_For_Agreement__c,
                                                                 genesis__Fee_Definition__r.clcommon__Class__c,genesis__Fee_Definition__r.Name
                                                             From genesis__Fee_Schedules__r 
                                                             Where genesis__Fee_Definition__r.name IN: Lstfeesinquery ) 
                                                        From genesis__Applications__c
                                                        Where id = :applicationId]; 
         
         paymentAmount.add(-application.Funder_Agreed_Advance__c);
         paymentDate.add(application.genesis__Expected_Start_Date__c);
         
         for(genesis__Fee_Schedule__c fees : application.genesis__Fee_Schedules__r) {
            if (fees.genesis__Fee_Definition__r.clcommon__Class__c == 'Income') {
                paymentAmount.add(fees.genesis__Amount__c); 
            }
            else {
                 paymentAmount.add(-fees.genesis__Amount__c); 
            }
             
            paymentDate.add(fees.Start_Date_For_Agreement__c);
            system.debug('**fees.cllease__Amount__c**'+fees.genesis__Amount__c);  
        }
        
         double guess = 0.1;
         for(genesis__Payment_Stream__c ps : application.genesis__Payment_Streams__r) {
            Integer i = 1;
            while(i <= ps.genesis__Number_of_Payments__c) {
                paymentAmount.add(double.valueof(ps.genesis__Payment_Amount__c));
                Date nextCycleDate = genesis.DateUtil.getNextCycleDate(ps.genesis__Start_Date__c,
                                                                        ps.genesis__Start_Date__c.day(),
                                                                        application.genesis__Payment_Frequency__c,
                                                                        (i-1));
                paymentDate.add(nextCycleDate);
                i++;
            }
        }
           
        
         double val= Newtons_method(guess,paymentAmount,paymentDate);
        
         double val1 = decimal.valueof(val).setscale(5);
         application.XIRR5__c =  calculateRate(val1);
         update application;
         return application.XIRR5__c;
    }
     
    
     private static double f_xirr(double p, Datetime dt, Datetime dt1, double x) {       
            double val1 =   1 + x;
            double val6 = dateDiff(dt1,dt)/365.0;
         
            
         double f_xirr = math.pow(val1,val6);

            double val4 = p*f_xirr;

            return val4;
        }
    Public static double df_xirr(double p, Date dt, Date dt0, double x) {  
             
        double power = (dateDiff(dt0,dt)/ 365) - 1.0;
        system.debug('======power'+power);
        double d1 = x+1.0;
        system.debug('======d1'+d1);
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
                system.debug('======num'+num);
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
   
}