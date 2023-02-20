@IsTest
private class Test_redirectToProposal{

@testSetup static void setup() {
 
     clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;

      
        Account acc = new Account(name='test account');
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;

        genesis__Applications__c application = new genesis__Applications__c();
        //application.RecordTypeId = applicationRecordTypes.get('LEASE');
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
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
        application.genesis__Account__c = acc.Id;
        insert application;


}
    
    static testMethod void Test_redirectToProposal(){
    
        genesis__Applications__c application = [SELECT Id FROM genesis__Applications__c WHERE genesis__Account__r.Name='TestAccount' LIMIT 1];
           
        test.startTest();        
            
            PageReference pageRef = Page.redirectToProposal;
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put('id',application.id);
            System.currentPageReference().getParameters().put('skuidonly', 'true');
            ApexPages.StandardController sc = new ApexPages.standardController(application);
            
            redirectToProposal controller = new redirectToProposal(sc);
            controller.redirect();

        test.stopTest();
        
    }
    
    static testMethod void testASCcontroller1SkuidOnlynull(){
    
     genesis__Applications__c application1 = [SELECT Id FROM genesis__Applications__c WHERE genesis__Account__r.Name='TestAccount' LIMIT 1];
 
        test.startTest();        
            
            PageReference pageRef = Page.redirectToProposal;
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put('id',application1.id);
            //System.currentPageReference().getParameters().put('skuidonly', 'true');
            ApexPages.StandardController sc = new ApexPages.standardController(application1);
            
            redirectToProposal controller = new redirectToProposal(sc);
            controller.redirect();

        test.stopTest();
        
    }
    
    static testMethod void testASCcontroller1SkuidandIdnull(){
    
     genesis__Applications__c application2 = [SELECT Id FROM genesis__Applications__c WHERE genesis__Account__r.Name='TestAccount' LIMIT 1];
 
        test.startTest();        
            
            PageReference pageRef = Page.redirectToProposal;
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController sc = new ApexPages.standardController(application2);
            
            redirectToProposal controller = new redirectToProposal(sc);
            controller.redirect();

        test.stopTest();
        
    }
    
}