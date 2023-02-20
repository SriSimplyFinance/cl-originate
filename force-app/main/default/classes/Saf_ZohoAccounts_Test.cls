@isTest
private class Saf_ZohoAccounts_Test 
{
    @istest static void CreateAccountInZoho()
    {
           Test.setMock(HttpCalloutMock.class, new MockHttpResponseForCreateRealtionship());
            Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
            settings.AccessToken__c ='142';
            settings.LoginURL__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=30&companyNumber=06625914';
            settings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=30&companyNumber=06625914';
            settings.UpdateRelIdtoDB__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            upsert settings;
        List<String>  accountIdList=new List<String>();
        Account acc=new Account();
        acc.Name='happiestminds';
        acc.Zoho_Customer_Id__c='10777000001228063';
        INSERT acc;
        accountIdList.add(acc.id);
        Account acc1=new Account();
        acc1.Name='happiestminds1';
        acc1.Zoho_Customer_Id__c='10777000001228062';
        INSERT acc1;
        accountIdList.add(acc.id);
        accountIdList.add(acc1.id);
               
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());     
        Saf_ZohoAccounts.CreateInZoho(accountIdList, true);
        Test.stopTest();
    }
}