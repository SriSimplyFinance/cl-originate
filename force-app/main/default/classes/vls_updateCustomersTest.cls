@isTest(SeeAllData=true)
private class vls_updateCustomersTest{
    static testMethod  void vls_updateCustomersTest() {
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping; 
           Saf_CompanyHouse__c objSettings1 =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings1.AccessToken__c =null;
            objSettings1.Username__c = 'Phalguni@hm.com';
            objSettings1.Password__c = 'phalguni@123';
            objSettings1.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings1.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
           objSettings1.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
           objSettings1.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
         objSettings1.UpdateContactToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/individual'; 
         objSettings1.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
         upsert objSettings1;
        
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());       
        //Create a Fee Set
        //clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        //System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.AccountNumber='6549821699';
        lessee.Name = 'TestAccountBBB';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        
        Account lessee1 = new Account();
        lessee1.RecordtypeID=rec.id;
        lessee1.AccountNumber='111111';
        lessee1.Name = 'HMAccountTESTBBB12';
        lessee1.Phone = '98734 678988';
        lessee1.Landline__c= '98734 678988';
        lessee1.BillingPostalCode = 'DC1 1HA1';
        lessee1.BillingCity = 'London';
        lessee1.ShippingPostalCode = 'DC1 1HA1'; 
        lessee1.ShippingCity = 'London';
        insert lessee1;
        
        genesis__Company__c company = new genesis__Company__c();
        company.Name ='Simply Asset Finance Operations Ltd';
        company.genesis__Short_Name__c ='HQ';
        insert company;
        
       /* User usr = new user();
        usr.FirstName = 'testF';
        usr.LastName = 'testL';
        usr.Email = 'test@example.com';
        usr.Username = 'test@test.clsdev'; 
        usr.CommunityNickname= 'tst';
        usr.UserRoleId = '876534567dfs';
        usr.ProfileId = 'fdn344453';
        usr.CompanyName = company.name;
        insert usr; */
        
        
      
        
        clcommon__Fee_Set__c feeSet = new clcommon__Fee_Set__c();
        feeSet.Name = 'Hire Purchase';
        insert feeSet;
        
        cllease__Lease_Product__c prodName = new cllease__Lease_Product__c();
        prodName.Name = 'Hire Purchases';
        prodName.cllease__Calculation_Method__c = 'IRR';
        prodName.cllease__Status__c = 'Active';
        insert prodName;
        
        cllease__Office_Name__c ofcName = new cllease__Office_Name__c();
        ofcName.Name = 'Simply Asset';
        ofcName.cllease__Office_Short_Name__c = 'saf';
        ofcName.cllease__Tax_Method__c = 'Exclusive';
        insert ofcName;
        
        
        cllease__Payment_Spread__c paySpr = new cllease__Payment_Spread__c();
        paySpr.cllease__Enabled__c = true;
        paySpr.cllease__Spread_Description__c = 'test';
        paySpr.cllease__Tax_Configuration__c = 'TAX FIRST';
        insert paySpr;
                
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = feeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = prodName.ID;
        leaseAccount.cllease__Branch__c              = ofcName.ID;
        leaseAccount.cllease__Payment_Spread__c      = paySpr.id;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 6;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
            
       insert leaseAccount;
       cllease__Lease_Account__c leaseAcc1 = [select id,Funder__c from cllease__Lease_Account__c where id =: leaseAccount.id];
        leaseAcc1.Funder__c = lessee1.id;
       update leaseAcc1;
    }
}