/********Apex class to calculate the XIRR for all the agreement at one time************/

Global class SAF_XirrCalcUtils_batch{
    private static final double tol = 0.001;   
    Public static XIRR_Rates__c Xr_Setting = XIRR_Rates__c.getOrgDefaults();
    
      Public static List<string> getFees(string strRate){
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
       
      Public static double xirrCalculation1(cllease__Lease_Account__c agreement,List<Double> dblAmount,List<Date> Dtstartdate)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
        
         double guess = 0.1;
         if(dblAmount != NULL) { paymentAmount.addall(dblAmount);}
         if(Dtstartdate!= NULL){paymentDate.addall(Dtstartdate);}
         double val= Newtons_method(guess,paymentAmount,paymentDate);
         double val1 = decimal.valueof(val).setscale(5);
         double XIRR =  calculateRate(val1);
        
       // update agreement;
         return XIRR ;
     }
      Public static double xirrCalculation2(cllease__Lease_Account__c agreement,List<Double> dblAmount,List<Date> Dtstartdate)
     {
         List<double> paymentAmount = new list<double>();
         list<date> paymentDate = new list<date>();
        
         if(dblAmount != NULL) { paymentAmount.addall(dblAmount);}
         if(Dtstartdate!= NULL){paymentDate.addall(Dtstartdate);}
         double guess = 0.1;  
         double val= Newtons_method(guess,paymentAmount,paymentDate);
         double val1 = decimal.valueof(val).setscale(5);
         double XIRR =  calculateRate(val1);
        
         //update agreement;
         return XIRR;
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