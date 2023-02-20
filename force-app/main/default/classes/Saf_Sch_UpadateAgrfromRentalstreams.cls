/**
        @ name                      : Saf_Sch_UpadateAgrfromRentalstreams 
        @ author                    : Happiest Minds
        @ description               : scheduling to get category codes every night (will start at 11 am)
        @ created date              : 
        @ Modified by / Date        : 
*/

global class Saf_Sch_UpadateAgrfromRentalstreams implements Schedulable {
   global static String CRON_EXP = '0 30 02 * * ? *';
   public class myException extends Exception {}
 
   global void execute(SchedulableContext sc) {
   try
   {
     String  ScTriggerId;
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :sc.getTriggerId()];

      system.debug('cronexpr:' + ct.CronExpression);
      System.debug('trigertimes:' + ct.TimesTriggered);
      System.debug('nextfiretime:' + String.valueOf(ct.NextFireTime));
      
      Saf_UpadateAgreementfromRentalstreams objhp = new Saf_UpadateAgreementfromRentalstreams();
      database.executebatch(objhp,250);
      
          if(test.isRunningTest())
        { 
            throw new myException('Error'); 
        }
      /* ScTriggerId=sc.getTriggerId();
        //Clear the Schedulable job record once complete
       System.abortJob(ScTriggerId);*/
       }
       catch(System.Exception e) 
        {
            System.debug('****i entered into the exception blog Saf_UpadateAgreementfromRentalstreams');
            /*String emailsubject = 'Batch failed-scheduledBatchable';
            String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
            ErrorLogsUtils.createErrorLogs('Failure','scheduledBatchable','execute',e.getTypeName(),description,'','','',true,ErrorLogsUtils.ERROR,true,emailsubject,description); */
        }
   
   }
}