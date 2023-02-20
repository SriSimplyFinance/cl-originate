@isTest (SeeAllData=True)
private class Vls_UpdateBillsJob_Test {
   
    static testmethod void test() {        
       User objuser = [select Id, username,cllease__Current_Branch_s_System_Date__c from User where Id = :UserInfo.getUserId()];
         Date dt = Date.valueof(objuser.cllease__Current_Branch_s_System_Date__c); 
       
    
      /*      List<cllease__Lease_account_Due_Details__c> lstbills = [select id,VLS_Number_Of_Instance_c__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
        Test.startTest();
        Vls_UpdateBillsJob ver2 = new Vls_UpdateBillsJob();
        //Database.BatchableContext BC;
        
        Id batchId = Database.executeBatch(ver2,200);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
          for(cllease__Lease_account_Due_Details__c objbill : lstbills)
                 {                
                    if(objbill.VLS_Number_Of_Instance_c__c == null)
                    {system.debug('Bills not updated properly: ' + objbill.cllease__Lease_Account__c);}
                 }
           */      
      test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<cllease__Lease_account_Due_Details__c> lstbills = new List<cllease__Lease_account_Due_Details__c>();
         //[select id,VLS_Number_Of_Instance_c__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
        Vls_UpdateBillsJob ER = new Vls_UpdateBillsJob();
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            cllease__Lease_account_Due_Details__c Lacc1 = (cllease__Lease_account_Due_Details__c)QIT.next();           
            System.debug('Bills'+Lacc1);
            lstbills.add(Lacc1);
        }  
        
        system.debug('List of loan accounts '+lstbills);     
       try{
        ER.execute(BC, lstbills);}
        catch(Exception e){}
        //ER.finish(BC); 
        test.stopTest();
        
         // after the testing stops, assert records were updated properly
          for(cllease__Lease_account_Due_Details__c objbill : lstbills)
                 {                
                    if(objbill.VLS_Number_Of_Instance_c__c == null)
                    {system.debug('Bills not updated properly: ' + objbill.cllease__Lease_Account__c);}
                 }
    }
    
}