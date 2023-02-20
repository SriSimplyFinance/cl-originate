@isTest
    public class saf_RunSoleTraderTest {

    @isTest static void RunSoleTraderTest(){
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();

            req.requestURI = '/company/gb/10672557/group-parents';
            req.httpMethod = 'GET';

            RestContext.request=req;
            RestContext.response=res;

            SAF_BrokerApp__c Settings = SAF_BrokerApp__c.getOrgDefaults();
            Settings.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
            UPSERT Settings;

            Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateContactToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/individual';
            objSettings.SoleTrader__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/nonreg/updateBusinessRef?';
            upsert objSettings;

            saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
            objSetting.client_id__c = 'Dummy client Id';
            objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
            objSetting.zoho_GetUsersEndpoint__c = 'dummyURL';
            objSetting.zoho_CretaOppEndpoint__c = 'dummyOppEndpoint';
            objSetting.saf_getZohoAccount__c='hghsaas';
            UPSERT objSetting;

            Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults();
            zohomapping.Salesforce_Field__c='rrrrr';
            zohomapping.Zoho_Fields__c='sss';
            zohomapping.Name='duplicateName';
            UPSERT zohomapping;

            Account acc = new Account();
            acc.Name = 'MyTestAccount';
            acc.BillingPostalCode = 'BD1 1HA';
            acc.BillingCity = 'London';
            acc.ShippingPostalCode = 'BD1 1HA';
            acc.ShippingCity = 'London';
            acc.Landline__c='12345 123456';
            acc.KYCDB_Unique_Key_Account__c = 'COMP-0000000000457';
            insert acc;

            clcommon__CL_Product__c pr2 = new clcommon__CL_Product__c();
            pr2.clcommon__Product_Name__c = ' Operating Lease ';

            genesis__Applications__c appl = new genesis__Applications__c();
            appl.genesis__Account__c = acc.Id;
            appl.genesis__Expected_Start_Date__c = Date.Today();
            appl.genesis__Sales_Division__c = 'DIRECT';
            appl.genesis__Payment_Frequency__c = 'MONTHLY';
            appl.genesis__Financed_Amount__c = 123;
            appl.genesis__Status__c ='DOCUMENTS RAISED';
            appl.genesis__Term__c =12;
            appl.genesis__CL_Product__c = pr2.id;
            appl.genesis_ProposalName__c = 'Test';
            insert appl;

            Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock()); 
            Test.startTest();
                List<string> lst1 = new List<string>();
                lst1.add(appl.Id);
                saf_RunSoleTrader.RunSoleTrader(String.valueof(appl.Id), String.valueof(appl.genesis__Account__c),'UI10514726');
                 saf_RunSoleTrader.RunSoleTrader(String.valueof(appl.Id), String.valueof(appl.genesis__Account__c),'');
              
        Test.stopTest();
    }
      
       
}