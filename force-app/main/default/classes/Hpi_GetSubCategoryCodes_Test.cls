@isTest //(SeeAllData=True)
private class Hpi_GetSubCategoryCodes_Test {
   
    static testmethod void test() {        
      HPI_Parserclass_test.createrecords();
      //Select Id,Name,Code__c,Desciption__c,Category__c,Category_SubCode__c,UniqueCode__c from HPI_Agreement_Types__c where Category__c In: strlst
      HPI_Agreement_Types__c objHp = new HPI_Agreement_Types__c();
      objHp.Code__c = '1';
      objHp.Desciption__c = 'Hire Purchase';
      objHp.Category__c = 'agreementtype';
      objHp.Category_SubCode__c = '';
       insert objHp;
       
      test.startTest();
        Test.setMock(WebServiceMock.class, new HPIWebParserMock());   
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<HPI_Agreement_Types__c> lstTypes = new List<HPI_Agreement_Types__c>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         Hpi_GetSubCategoryCodes ER = new  Hpi_GetSubCategoryCodes();
         //ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            HPI_Agreement_Types__c objType = (HPI_Agreement_Types__c)QIT.next();           
            System.debug('AgreementType :'+objType);
            lstTypes.add(objType);
        }  
        
        system.debug('List of Equipments '+lstTypes);     
        try{
        ER.execute(BC, lstTypes);}
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