@isTest 
public class Saf_CreateContactfromAccountTest{
    static testMethod void Saf_CreateContactfromAccountTest() {       
      cllease.TestHelper.createSeedDataForTesting();
     Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;  
      clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Sole Proprietorship');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount1';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;                 
        
      test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<Account> lstacc = new List<Account>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         Saf_CreateContactfromAccount ER = new  Saf_CreateContactfromAccount();
         //ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
        ER.id= acc.id; 
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            Account objacc = (Account)QIT.next();           
            System.debug('Account:'+objacc);
            lstacc.add(objacc);
        }  
        
        system.debug('Account: '+lstacc);     
        try{
        ER.execute(BC,lstacc);
        ER.finish(BC); 
        }
        catch(Exception e){}
        //ER.finish(BC); 
      
        test.stopTest();
    }
  
}