@isTest(seealldata = true)
public class Saf_Sch_UpadateAgrfromRentalstreamsTest{

   static testMethod void Saf_Sch_UpadateAgrfromRentalstreamsTest(){
      // test.startTest();
       //String CRON_EXP = '0 30 11 * * ? *';
       /*String jobId = System.schedule('testScheduledApex',Saf_Sch_UpadateAgrfromRentalstreams.CRON_EXP,new Saf_Sch_UpadateAgrfromRentalstreams());
       CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
       System.assertEquals(Saf_Sch_UpadateAgrfromRentalstreams.CRON_EXP,ct.CronExpression);
       System.assertEquals(0, ct.TimesTriggered);*/
     
      // test.stopTest();
      	Database.BatchableContext BC;
        List<cllease__Rental_Stream__c> rentStream = [select id,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c order by cllease__Contract__r.cllease__Lease_Status__c DESC limit 30];
   		Saf_UpadateAgreementfromRentalstreams1 objhp = new Saf_UpadateAgreementfromRentalstreams1();
       	objhp.dostart(bc);
        objhp.doInitialize();
       
        test.startTest();
        try
        {
            objhp.getRuntimeQuery();
            objhp.doExecute(BC, rentStream);
            objhp.doFinish(BC);
        }
        catch(Exception e)
        {}
        test.stopTest();
   }

}