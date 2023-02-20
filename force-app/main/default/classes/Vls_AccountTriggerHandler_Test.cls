@isTest 
private class Vls_AccountTriggerHandler_Test {
    static testMethod void Vls_AccountTriggerHandlerTest() {
       RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
      Account a = new Account();
        a.RecordtypeID=rec.id;
        a.Name = 'TestAccount-phalguni';
        a.Phone = '98767 678987';
        a.Landline__c= '98767 678987';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Ownership = 'Sole Trader';
        a.Customer_Created_Platform__c = 'web/Mobile';
        a.SAF_Sharepoint_Folder_ID__c = '67897'; 
        insert a;       
        
       
        Contact c = new Contact();
        c.LastName = 'tandel';
        c.FirstName = 'pahlguni';
        c.salutation = 'Miss';
        c.Phone = '98767 678987';
        //c.CurrencyIsoCode = 'GBP';
        c.AccountId = a.Id;
         insert c;
         
       List<Account> newRecords = new List<Account>();
       Map<Id, Account> oldMap = new Map<Id, Account>();
       newRecords.add(a);
       oldMap.put(a.id,a);
       Test.startTest();
       
       Vls_AccountTriggerHandler objAcc = new Vls_AccountTriggerHandler(newRecords,oldMap);
       objAcc.AfterUpdateInsert(true);
       a.Ownership = 'Company';
       a.name = 'TestAccount-phalguni-update';
       a.SAF_Sharepoint_Folder_ID__c = '6789'; 
       update a;
       objAcc.AfterUpdateInsert(false); 
       updateCustomer.createRecords(newRecords);
       updateCustomer.changeRecords(newRecords);
       delete c;
       Test.stopTest();
       
       }
 }