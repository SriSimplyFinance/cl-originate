@isTest
global class Test_vls_updateContacts{

static testmethod void test1(){
   Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;
    Saf_CompanyHouse__c objSettings2=Saf_CompanyHouse__c.getOrgDefaults(); 
     //objSettings2.DisableCustomerTriggers__c = true;    
      objSettings2.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
      objSettings2.UpdateContactToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/individual';
        UPSERT objSettings2;
     Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            upsert objSettings;
            
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
           
        List<string> lst = new List<string>();
        lst.add('0031x000011SPHW');
        //SAF_ContactsUtils.UpdateContactToDB(lst);
      
  
  
  
  
    Account acc = new Account(Name='Test Account');
       /* acc.AccountNumber ='87832';
        acc.Landline__c = '9999999';
        acc.Phone = '34567 123456';
        acc.BillingCity = 'abcdef';
        acc.BillingPostalCode = '128000';
        acc.ShippingPostalCode = '333';
        acc.ShippingCity = 'abcdef';
        acc.Name = 'TA';
        acc.Ownership = 'Sole Trader';*/
        insert acc;
    system.debug('Account'+acc);
        Contact c = new Contact();
        c.LastName = 'TC';
        c.Accountid = acc.id;
        insert c;
        c.KYCDB_Unique_Key_Contact__c = '1045';
        update c;
    system.debug('Contact'+c);
      Test.stopTest();
    
    for (Account a : [select id,name,(select id,accountid,lastname from Contacts limit 1) from Account]){ //where id=:acc.id]){
    Contact co = a.Contacts;
     co.firstname = 'abc';
        delete co;   
    system.debug('AccContact==='+c);
    }
    //system.debug('Account'+acc);
        
}
}