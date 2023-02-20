@istest
class vls_scheduledUpdateBilljob_Test {

   static testmethod void test() {
   Test.startTest();
       
        User objuser = [select Id, username,cllease__Current_Branch_s_System_Date__c from User where Id = :UserInfo.getUserId()];
        Date dt = Date.valueof(objuser.cllease__Current_Branch_s_System_Date__c); 
        
      List<cllease__Lease_account_Due_Details__c> lstbills = [SELECT id,VLS_Number_Of_Instance_c__c,cllease__Lease_Account__c FROM cllease__Lease_account_Due_Details__c WHERE cllease__Due_Date__c = :dt];
      // Schedule the test job

      String jobId = System.schedule('vls_scheduledUpdateBilljob',
      vls_scheduledUpdateBilljob.CRON_EXP, 
         new vls_scheduledUpdateBilljob());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(vls_scheduledUpdateBilljob.CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run  08/05/2018 01:10
      //System.assertEquals('2018-05-08 01:10:00', 
      //   String.valueOf(ct.NextFireTime));
      //System.assertNotEquals(0,lstbills[0].VLS_Number_Of_Instance_c__c);

   Test.stopTest();

     for(cllease__Lease_account_Due_Details__c objbill1:[SELECT id,VLS_Number_Of_Instance_c__c, name FROM cllease__Lease_account_Due_Details__c 
                                                         WHERE cllease__Due_Date__c = :dt]){
     
     if(objbill1.VLS_Number_Of_Instance_c__c == null)
     {system.debug('not updated :' + objbill1.cllease__Lease_Account__c);}
    
       }
    }
}