@isTest
private class OriginateCongaExperian_Test {
    @isTest static void OriginateCongaExpe(){
       
        saf_zoho__c objZoho = saf_zoho__c.getOrgDefaults();
        objZoho.zoho_AccessEndpoint__c='dummy-url';
        objZoho.zoho_CretaOppEndpoint__c='dummy_url_2';
        upsert objZoho;
        
        Saf_Experian__c objSettings = Saf_Experian__c.getOrgDefaults();
        objSettings.username__c='simplyassetuat02';
        objSettings.password__c='Loga1987!#';
        objSettings.Client_id__c='FDzlh5CGjthS9TwWc7ppLUDsmd1O0DBK';
        objSettings.Client_secret__c ='FvSyTUG69x0wylSp';
        objSettings.content_type__c ='application/json'; 
        objSettings.content_type__c = 'application/json' ;
        objSettings.BI_Non_Ltd_Credit_Report__c='https://uat-uk-api.experian.com/risk/business/v1/nonregisteredbusinesscredit?nonlimitedkey=CompRegNo';
        UPSERT objSettings;
       
        Account a = new Account();
        a.Name = 'TestAccount';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Landline__c='12345 123456';
        insert a;
                
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c();
        prod.clcommon__Product_Name__c = 'test';
        insert prod;
        genesis__Applications__c experian = new genesis__Applications__c();
       
        
        
        experian.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        experian.genesis__Product_Type__c = 'LEASE';
        experian.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        experian.genesis__Loan_Amount__c = 6700;
        experian.genesis__company__c = genesis.TestHelper.createCompany().Id;
        experian.genesis__Expected_Start_Date__c = Date.today();
        experian.genesis__Warranty_Amount__c=0;
        experian.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        experian.genesis__Tax_Amount__c=0;
        experian.genesis__CL_Product__c = null;
        experian.genesis__Other_Financed_Fees__c = 0;
        experian.genesis__Financed_Amount__c = 6700;
        experian.genesis__Customer_cash_available__c = 1500;
        experian.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        experian.genesis__Term__c = 12;
        experian.genesis__Payment_Frequency__c = 'MONTHLY';
        experian.genesis__Interest_Rate__c = 10;
        //application.Equipment_Count__c = 10;
        experian.genesis__CL_Product__c = prod.id;
        experian.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        experian.genesis__Account__c = a.Id;
        Insert experian;
       // Test.setMock(HttpCalloutMock.class, new OriginateCongaExperianMock());
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Saf_Experian_data_processing_Mock());
        Test.setMock(WebServiceMock.class, new SFDCUserSessionGenerateCtrlMock());
        OriginateCongaExperian.experian(String.Valueof(experian.id),(a.name));
        Test.stopTest();
    }
     
}