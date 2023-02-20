@isTest(seeAllData=true)
public class Saf_CreateAccountContactTest{
    static testMethod void Saf_CreateAccountContactTest() {       
      cllease.TestHelper.createSeedDataForTesting();
     Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;  
      clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Individual');
        insert legal;
        clcommon__Legal_Entity__c legal1 = new clcommon__Legal_Entity__c(name='Limited Liability Company');
        insert legal1;
        Account acc1 = new Account();
        acc1.clcommon__Legal_Entity_Type__c = legal1.id;
        acc1.Name = 'TestAccount Happy';
        acc1.BillingPostalCode = 'BD1 1HA';
        acc1.BillingCity = 'London';
        acc1.ShippingPostalCode = 'BD1 1HA';
        acc1.ShippingCity = 'London';
        acc1.Landline__c='12345 123456';
        insert acc1;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount1';
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
        string strcontype = 'Director';         
        string strcontype1 = 'Related Customer';    
        Integer percent = 12;
      test.startTest();
      Saf_CreateAccountContact.GetRelationship(strcontype,con.AccountId,acc,percent);
      Saf_CreateAccountContact.GetRelationship2(strcontype,con.AccountId,acc,percent);
      Saf_CreateAccountContact.GetRelationship2(strcontype1,acc1.Id,acc1,percent);
      Saf_CreateAccountContact.CreateRelationshipforDuplicateContact(con.id);
      test.stopTest();
      }
    }