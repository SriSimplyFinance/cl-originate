@isTest //(SeeAllData=True)
private class Hpi_RegisterEquipments_Test {
   
    static testmethod void test() {        
      HPI_Parserclass_test.createrecords();
      test.startTest();
        Test.setMock(HttpCalloutMock.class, new HPI_calloutMock());         
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<cllease__Contract_Equipment__c> lstEquips = new List<cllease__Contract_Equipment__c>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         Hpi_RegisterEquipments ER = new  Hpi_RegisterEquipments();
         ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            cllease__Contract_Equipment__c  objEquip = (cllease__Contract_Equipment__c)QIT.next();           
            System.debug('Equipment :'+objEquip);
            lstEquips.add(objEquip );
        }  
        
        system.debug('List of Equipments '+lstEquips);     
        try{
        ER.execute(BC, lstEquips);}
        catch(Exception e){}
        //ER.finish(BC); 
        test.stopTest();
        
         // after the testing stops, assert records were updated properly
         /* for(cllease__Contract_Equipment__c objbill : lstbills)
                 {                
                    if(objbill.VLS__c == null)
                    {system.debug('Bills not updated properly: ' + objbill.cllease__Lease_Account__c);}
                 }*/
    }
    
}