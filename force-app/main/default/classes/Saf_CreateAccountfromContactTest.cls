@isTest
public class Saf_CreateAccountfromContactTest{
    static testMethod void Saf_CreateAccountfromContactTest() {       
      cllease.TestHelper.createSeedDataForTesting();
     Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;  
      clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Individual');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount1';
        //added owner,sic and type
        acc.Ownership = 'Individual';
        acc.Sic= '123456';
        acc.Type= 'Customer';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        Contact con = new Contact();
        con.clcommon__Legal_Entity_Type__c = legal.id;
        con.AccountId = acc.Id;
        con.LastName = 'Happy';
        con.FirstName = 'TestAccount';
        con.MailingStreet = 'test' ;
        con.MailingPostalCode = 'BD1 1HA';
        con.MailingCity = 'London';
        con.MailingState = 'BD1 1HA';
        con.SAF_OfficerID__c='12345';
        insert con;
             
        
      test.startTest();
 
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<Contact> lstcon = new List<Contact>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         Saf_CreateAccountfromContact ER = new  Saf_CreateAccountfromContact();
         //ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
         ER.id= con.id;
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            Contact objcon = (Contact)QIT.next();           
            System.debug('Contact:'+objcon);
            lstcon.add(objcon);
        }  
        
        system.debug('Contact: '+lstcon);     
        try{
        ER.execute(BC,lstcon);
        ER.finish(BC); 
        }
        catch(Exception e){}
        //ER.finish(BC); 
      
        test.stopTest();
    }
    static testMethod void Saf_CreateAccountfromContactTest1() {       
      cllease.TestHelper.createSeedDataForTesting();
     Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;  
      clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Individual');
        insert legal;
        
        Contact con = new Contact();
        con.clcommon__Legal_Entity_Type__c = legal.id;       
        con.LastName = 'deploymenttest';
        con.FirstName = '12july2020';
        con.MailingStreet = 'test1' ;
        con.MailingPostalCode = 'BD1 1Hb';
        con.MailingCity = 'London1';
        con.MailingState = 'BD1 1Hb';
        con.SAF_OfficerID__c='123455';
        con.AccountID = null;
        insert con;
        
        
      test.startTest();
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<Contact> lstcon = new List<Contact>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         Saf_CreateAccountfromContact ER = new  Saf_CreateAccountfromContact();
         //ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
         ER.id= con.id;
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            Contact objcon = (Contact)QIT.next();           
            System.debug('Contact:'+objcon);
            lstcon.add(objcon);           
        }  
        
        system.debug('Contact: '+lstcon);     
        try{
        ER.execute(BC,lstcon);
        ER.finish(BC); 
        }
        
       
        catch(Exception e){}
        //ER.finish(BC); 
      
        test.stopTest();
    }
    static testMethod void Saf_CreateAccountfromContactTest2() {       
      cllease.TestHelper.createSeedDataForTesting();
     Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;  
      clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Individual');
        insert legal;
          Account acc1 = new Account();
        acc1.clcommon__Legal_Entity_Type__c = legal.id;
        acc1.Name = 'different name';
        //added owner,sic and type
        acc1.Ownership = 'Individual';
        acc1.Sic= '123456';
        acc1.Type= 'Customer';
        acc1.BillingPostalCode = 'BD1 1HA';
        acc1.BillingCity = 'London';
        acc1.ShippingPostalCode = 'BD1 1HA';
        acc1.ShippingCity = 'London';
        acc1.Landline__c='12345 123456';
        insert acc1;
          Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount Happy';
        //added owner,sic and type
        acc.Ownership = 'Individual';
        acc.Sic= '123456';
        acc.Type= 'Customer';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
       Contact con = new Contact();
        con.clcommon__Legal_Entity_Type__c = legal.id;
        con.AccountId = acc1.Id;
        con.LastName = 'Happy';
        con.FirstName = 'TestAccount';
        con.MailingStreet = 'test' ;
        con.MailingPostalCode = 'BD1 1HA';
        con.MailingCity = 'London';
        con.MailingState = 'BD1 1HA';
        con.SAF_OfficerID__c='12345';
        insert con;
        
        
      test.startTest();
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<Contact> lstcon = new List<Contact>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         Saf_CreateAccountfromContact ER = new  Saf_CreateAccountfromContact();
         //ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
       //  ER.id= con.id;
       ER.isbatch = true;
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            Contact objcon = (Contact)QIT.next();           
            System.debug('Contact:'+objcon);
            lstcon.add(objcon);           
        }  
        
        system.debug('Contact: '+lstcon);     
        try{
        ER.execute(BC,lstcon);
        ER.finish(BC); 
        }
        
       
        catch(Exception e){}
        //ER.finish(BC); 
      
        test.stopTest();
    } 
}