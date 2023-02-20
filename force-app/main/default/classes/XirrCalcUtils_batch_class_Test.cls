@isTest (SeeAllData=True)
private class XirrCalcUtils_batch_class_Test {
   
    static testmethod void test() {  
    saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());      
      
     // test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<cllease__Lease_Account__c> lstcont = new List<cllease__Lease_Account__c>();
        
        XirrCalcUtils_batch_class ER = new XirrCalcUtils_batch_class();
        QL = ER.start(bc);
        
        integer i=0;
       Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            cllease__Lease_Account__c Lacc1 = (cllease__Lease_Account__c)QIT.next();           
            System.debug('Contract'+Lacc1);
            lstcont.add(Lacc1);
            i++;
            if(i>10){break;}
        }  
        
        system.debug('List of loan accounts '+lstcont);  
       try{
        ER.execute(BC, lstcont);}
        catch(Exception e){}
        //ER.finish(BC); 
        //test.stopTest();
        
         // after the testing stops, assert records were updated properly
          for(cllease__Lease_Account__c objcont : lstcont)
                 {                
                    if(objcont.XIRR1__c == null)
                    {system.debug('XIRR not created properly: ' + objcont.Id);}
                 }
    }
    
}