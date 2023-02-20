@isTest
public class SAF_CompanyRelationshipCalloutTest {
     
    public static testmethod void updateRelationshipDetailsTest(){
        	Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'andrew.trimmer@simply.finance';
            objSettings.Password__c = 'Welcome@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account'; 
            objSettings.UpdateContactToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual';
        	objSettings.Company_Shareholders__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/getCompanyShareholders?companyNumber=';
        	objSettings.Company_Officers__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/getOfficersByCRN?companyNumber=';
        	objSettings.UpdateRelationshiptoDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/relationship';
        	objSettings.UpdateRelIdtoDB__c='http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/relationship';
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
        acc.KYCDB_Unique_Key_Account__c='COMP-0000015194';
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
        insert acc;

        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new Saf_CompanyShareholderMockTest());   
         
        List<String> accNumber =new List<String>();
        accNumber.add(acc.AccountNumber);
        SAF_CompanyRelationshipCallout.updateRelationshipDetails(accNumber);
        Test.stopTest();
    }

}