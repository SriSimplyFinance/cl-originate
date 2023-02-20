@isTest//(SeeAllData = true)
    private class saf_CreateRelationshipTest {
        @isTest static  void CreateRelationshipTest(){
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseForCreateRealtionship());
            Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
            settings.AccessToken__c ='142';
            settings.LoginURL__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=30&companyNumber=06625914';
            settings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=30&companyNumber=06625914';
            settings.UpdateRelIdtoDB__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            upsert settings;
            clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
            insert legal;
            
         Saf_setting__c objSettings2 = Saf_setting__c.getOrgDefaults();
         objSettings2.DisableCustomerTriggers__c = true;    
         UPSERT objSettings2;  
            
         clcommon__Reciprocal_Role__c recip = new clcommon__Reciprocal_Role__c();
         recip.Name ='UBO';
          recip.clcommon__Inverse_Role__c = 'UBO';
          insert recip;
            
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='509';
        acc.AccountNumber='06625914';
        //acc.ky
        insert acc;
        
        acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount269';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='269';
        acc.AccountNumber='12607565';
        //acc.ky
        insert acc;
            //String mapaccountIDs = '{71=, 787832=}';
            String Relationresp='['+
 ' {'+
  '"errors":['+
      '  ],'+
        ' "kyc_relationship_id":689,'+
         '"kyc_party1_id":269,'+
         '"kyc_party1_regNumber":"12607565",'+
         '"kyc_party2_id":509,'+
         '"kyc_party2_regNumber":"gIugsHhPrlVvPvm7kYLdcCYvjEg",'+
         '"shareholder_bracket":"ownership-of-shares-75-to-100-percent,voting-rights-75-to-100-percent,right-to-appoint-and-remove-directors",'+
         '"shareholder_perc":"75-100",'+
         '"shareholder_type":"officers",'+
         '"cls_relationship_id":null,'+
         '"zoho_relationship_id":null,'+
         '"source_data_system":"Company House",'+
         '"modified_on":1613383727000,'+
         '"created_on":null,'+
         '"joint_shareholding":null,'+
         '"joint_value":null,'+
         '"individual_value":null,'+
         '"total_value_tier_0":null,'+
         '"officer_role":"Director",'+
         '"share_class":null,'+
         '"nominal_value":null,'+
         '"no_of_shares":null,'+
         '"total_value":null,'+
         '"parent_company":1,'+
        ' "share_bracket_Value":null'+
     ' }'+
  ' ]'; 
            saf_CreateRelationship.CreateRelationship('06625914', '82', Relationresp );
             }
        
        

        @isTest static  void updateRelationshipfromDBTest(){
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseForCreateRealtionship());
            Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
            settings.AccessToken__c ='142';
            settings.LoginURL__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=30&companyNumber=06625914';
            settings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=30&companyNumber=06625914';
            settings.UpdateRelIdtoDB__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            upsert settings;
            clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
            insert legal;
            
         Saf_setting__c objSettings2 = Saf_setting__c.getOrgDefaults();
         objSettings2.DisableCustomerTriggers__c = true;    
         UPSERT objSettings2;  
            
         clcommon__Reciprocal_Role__c recip = new clcommon__Reciprocal_Role__c();
         recip.Name ='UBO';
          recip.clcommon__Inverse_Role__c = 'UBO';
          insert recip;
            
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='509';
        acc.AccountNumber='06625914';
        //acc.ky
        insert acc;
        
        acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount269';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='269';
        acc.AccountNumber='12607565';
        //acc.ky
        insert acc;
            //String mapaccountIDs = '{71=, 787832=}';
            String Relationresp='['+
 ' {'+
  '"errors":['+
      '  ],'+
        ' "kyc_relationship_id":689,'+
         '"kyc_party1_id":269,'+
         '"kyc_party1_regNumber":"12607565",'+
         '"kyc_party2_id":509,'+
         '"kyc_party2_regNumber":"gIugsHhPrlVvPvm7kYLdcCYvjEg",'+
         '"shareholder_bracket":"ownership-of-shares-75-to-100-percent,voting-rights-75-to-100-percent,right-to-appoint-and-remove-directors",'+
         '"shareholder_perc":"75-100",'+
         '"shareholder_type":"officers",'+
         '"cls_relationship_id":null,'+
         '"zoho_relationship_id":null,'+
         '"source_data_system":"Company House",'+
         '"modified_on":1613383727000,'+
         '"created_on":null,'+
         '"joint_shareholding":null,'+
         '"joint_value":null,'+
         '"individual_value":null,'+
         '"total_value_tier_0":null,'+
         '"officer_role":"Director",'+
         '"share_class":null,'+
         '"nominal_value":null,'+
         '"no_of_shares":null,'+
         '"total_value":null,'+
         '"parent_company":1,'+
        ' "share_bracket_Value":null'+
     ' }'+
  ' ]'; 
            saf_CreateRelationship.updateRelationshipfromDB(Relationresp);
             }
        
        
            public static testmethod void updateRelationshipTest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
           objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
           objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        objSettings.UpdateRelationshiptoDB__c ='http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            upsert objSettings;
             saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
        objSetting.client_id__c = 'Dummy client Id'; 
        objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSetting;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;   
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
         clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
            insert legal;
         Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='';
        acc.AccountNumber='06625914';
        acc.Sic ='0000';
        acc.Type = 'Account';
        acc.UK_Region__c ='0000';
        acc.Phone='9898787656';
        acc.clcommon__Email__c ='test@example.com';
        acc.Ownership='Private Limited Company';
        acc.BillingStreet ='test Street';
        acc.BillingState ='UK';
        acc.BillingCountry = 'UK';
        acc.ShippingStreet ='test Street';
        acc.ShippingCountry='UK';
        acc.ShippingState ='UK';
        acc.Zoho_Customer_Id__c = '10777000005023458';
       // acc.
        //acc.ky
        insert acc;
         clcommon__Relationship__c relationship = new clcommon__Relationship__c();
             relationship.Saf_Shareholder_Bracket__c = 'ownership-of-shares-25-to-50-percent,voting-rights-25-to-50-percent23';
             relationship.clcommon__Entity__c = String.valueof(acc.id);
             relationship.clcommon__Related_Entity__c = String.valueof(acc.id);
             relationship.Id = String.valueof(relationship.id);
            relationship.KYC_DB_Relationship_Id__c='123432';
            relationship.clcommon__Ownership_Percentage__c = 10;
            relationship.clcommon__Relationship__c = String.valueof(relationship.id);
           // relationship.Saf_Shareholder_Bracket__c='ownership-of-shares-75-to-100-percent121';

             insert relationship;
     
        List<string> lst = new List<string>();
        lst.add(acc.Id); //'0011x00001ByXxJ'
       
        saf_CreateRelationship.updateRelationship(relationship);
        Test.stopTest();
    }
        
        
        
        
     private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'your Json Response';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    }