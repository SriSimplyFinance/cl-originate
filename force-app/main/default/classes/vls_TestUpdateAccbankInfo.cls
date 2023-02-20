@isTest
private class vls_TestUpdateAccbankInfo {
 
    static testMethod  void TestUpdateAccbankInfo() {
        Account acc = new Account();
        acc.AccountNumber ='123456';
        acc.Landline__c = '12345 123456';
        acc.Phone = '12345 123456';
        acc.BillingCity = 'Norwich';
        acc.BillingPostalCode = '125478';
        acc.ShippingPostalCode = '123';
        acc.ShippingCity = 'Norwich';
        acc.Name = 'TestAccount';
        insert acc;
        clcommon__Bank_Account__c bankAcc = new clcommon__Bank_Account__c();
        bankAcc.clcommon__Bank_Account_Name__c = 'TestBankAccount';
        bankAcc.Account_Number__c = '32578549';
        bankAcc.clcommon__Routing_Number__c = '258963';
        bankAcc.clcommon__Account__c = acc.Id;
       // bankAcc.clcommon__Active__c =true;
        insert bankAcc;
        
    }
    
}