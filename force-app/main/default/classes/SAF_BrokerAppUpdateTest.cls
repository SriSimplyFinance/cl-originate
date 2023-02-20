@isTest//(seeAllData=true)
Public class SAF_BrokerAppUpdateTest {

 
      public static testmethod void UpdateContactToDBtest()
      {    
      
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
            
            
            
            Test.startTest();
             Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock()); 
        
            
            Account a = new Account();
            a.Name = 'MyTestAccount';
            a.BillingPostalCode = 'BD1 1HA';
            a.BillingCity = 'London';
            a.ShippingPostalCode = 'BD1 1HA';
            a.ShippingCity = 'London';
            a.Landline__c='12345 123456';
            insert a;
            
            clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
            pr1.clcommon__Product_Name__c = ' Operating Lease ';
            
            genesis__Applications__c app = new genesis__Applications__c();   
            app.genesis__Account__c = a.Id;
            app.genesis__Expected_Start_Date__c = Date.Today();
            app.genesis__Sales_Division__c = 'DIRECT';
            app.genesis__Payment_Frequency__c = 'MONTHLY';
            app.genesis__Financed_Amount__c = 123;
            app.genesis__Status__c ='DOCUMENTS RAISED';
            app.genesis__Term__c =12;
            app.genesis__CL_Product__c = pr1.id;
            app.genesis_ProposalName__c = 'Test';
            insert app;
            
            List<string> lst = new List<string>();
            lst.add(app.Id); //'0011x00001ByXxJ'
           
            SAF_BrokerAppUpdate.UpdateAppId(lst);
            Test.stopTest();
                    
      }
}