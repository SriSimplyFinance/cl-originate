@isTest(SeeAllData=true) 
private class CreateMasterDocsAndCreditconditions_Test {
    static testMethod void CreateMasterDocsAndCreditconditionsTest() {
       
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
        insert a;
       
        Account ai = new Account();
        ai.RecordtypeID=rec.id;
        ai.Type = 'Broker';
        ai.Name = 'phalguni2';
        ai.Phone = '98767 678987';
        ai.Landline__c= '98767 678987';
        ai.BillingPostalCode = 'BD1 2HA';
        ai.BillingCity = 'California';
        ai.ShippingPostalCode = 'BD1 2HA';
        ai.ShippingCity = 'California';
        ai.Ownership = 'Individual';
        insert ai;
        
        Account ad = new Account();
        ad.RecordtypeID=rec.id;
        ad.Type = 'Broker';
        ad.Name = 'deepak2';
        ad.Phone = '98767 678987';
        ad.Landline__c= '98767 678987';
        ad.BillingPostalCode = 'BD1 2HA';
        ad.BillingCity = 'California';
        ad.ShippingPostalCode = 'BD1 2HA';
        ad.ShippingCity = 'California';
        ad.Ownership = 'Individual';
        insert ad;
        
       /* Contact c = new Contact();
        c.LastName = 'tandel';
        c.FirstName = 'pahlguni';
        c.salutation = 'Miss';
        c.Phone = '98767 678987';
        c.CurrencyIsoCode = 'GBP';
        c.AccountId = a.Id;
         insert c;*/
         
        List<String> names = new List<String> {'Hire Purchase', 'Finance Lease','Operating Lease','Sale & Hp Back'};
       clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];
       genesis__Applications__c application = new genesis__Applications__c();
        //application.RecordTypeId = applicationRecordTypes.get('LEASE');
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        application.genesis__CL_Product__c = product.Id;
        application.genesis__Loan_Amount__c = 6700;
        application.genesis__company__c = genesis.TestHelper.createCompany().Id;
        application.genesis__Collateral_Value__c= 6700;
        application.genesis__Estimated_Selling_Price__c = 6700;
        application.genesis__Fees_Amount__c =0;
        application.genesis__Expected_Start_Date__c = Date.today();
        application.genesis__Warranty_Amount__c=0;
        application.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        application.genesis__Tax_Amount__c=0;
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;
        application.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
        application.genesis__Days_Convention__c = '30/360';
        application.genesis__Landing_Sequence__c = 3;
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        application.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
        application.genesis__Account__c = a.Id;
        application.Introducer1__c = ai.Id;
        
        insert application;
        List<genesis__Applications__c> lstApp = new List<genesis__Applications__c>(); 
        lstApp.add(application);
      
       Test.startTest();
           CreateMasterDocsAndCreditconditions gn = new  CreateMasterDocsAndCreditconditions();
           CreateMasterDocsAndCreditconditions.CreateRecords(lstApp);
            application.Security_Deposit__c = 100;
            update application;
       Test.stopTest();
       
       }
 }