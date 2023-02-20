@isTest(seealldata = true)
public class HPI_scheduleCategoryCodesTest{

   static testMethod void HPI_scheduleCategoryCodesTest(){
      // test.startTest();
       //String CRON_EXP = '0 30 11 * * ? *';
       String jobId = System.schedule('testScheduledApex',HPI_scheduleCategoryCodes.CRON_EXP,new HPI_scheduleCategoryCodes());
       CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
       System.assertEquals(HPI_scheduleCategoryCodes.CRON_EXP,ct.CronExpression);
       System.assertEquals(0, ct.TimesTriggered);
     
      // test.stopTest();
   
   }

}