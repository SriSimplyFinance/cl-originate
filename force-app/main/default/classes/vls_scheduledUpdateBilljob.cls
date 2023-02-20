/**
        @ name                      : vls_scheduledUpdateBilljob 
        @ author                    : Happiest Minds
        @ description               : scheduling vls_scheduledUpdateBilljob  (will start at 12:30 am after cl jobs complete)
        @ created date              : 
        @ Modified by / Date        : 
*/

global class vls_scheduledUpdateBilljob implements Schedulable {
   public static String CRON_EXP =  '0 10 1 ? * *';

   global void execute(SchedulableContext sc) {
   
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :sc.getTriggerId()];

          system.debug('cronexpr:' + ct.CronExpression);
          System.debug('trigertimes:' + ct.TimesTriggered);
          System.debug('nextfiretime:' + String.valueOf(ct.NextFireTime));
          
          
           //scheduling vls update bill batch job
           Vls_UpdateBillsJob ver1= new Vls_UpdateBillsJob();
           string IdVls_Updatebilljob = database.executebatch(ver1,200);
          System.debug('=======IdVls_Updatebilljob ======' + IdVls_Updatebilljob ); 
          
          /*vls_scheduledUpdateBilljob m = new vls_scheduledUpdateBilljob();
            String sch = '0 10 1 ? * *';
            String jobID = system.schedule('Vls-Bill update', sch, m);*/
                     

   }
}