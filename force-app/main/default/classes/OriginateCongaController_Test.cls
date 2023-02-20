@isTest(seeAllData=true)
public class OriginateCongaController_Test {
    public class MockHttpResponseGenerator implements HttpCalloutMock 
    {
        public HTTPResponse respond(HTTPRequest req) 
        {
    
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('Target URL');
            res.setStatusCode(200);
            //System.assertEquals('POST', req.getMethod());
          
            return res;
        }
    }
    @isTest
    public static void OriginateCongaCntlr(){
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
        genesis__Applications__c application = new genesis__Applications__c();
       
        
        
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        application.genesis__Loan_Amount__c = 6700;
        application.genesis__company__c = genesis.TestHelper.createCompany().Id;
        application.genesis__Expected_Start_Date__c = Date.today();
        application.genesis__Warranty_Amount__c=0;
        application.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        application.genesis__Tax_Amount__c=0;
        application.genesis__CL_Product__c = null;
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;
        application.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
        //application.Equipment_Count__c = 10;
       application.genesis__CL_Product__c = prod.id;
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        application.genesis__Account__c = a.Id;
        insert application;
        
        
       list<MasterDocument__c> mastDocs = new list<MasterDocument__c>();
        
       MasterDocument__c mastDoc = new MasterDocument__c();
       mastDoc.Application__c = application.id;
       mastDoc.IsChecked__c = true;
       mastDoc.MasterDocumentName__c = 'HP Agreement';
       mastDocs.add(mastDoc);
        
       MasterDocument__c mastDoc1 = new MasterDocument__c();
       mastDoc1.Application__c = application.id;
       mastDoc1.IsChecked__c = true;
       mastDoc1.MasterDocumentName__c = 'Lease Agreement';
       mastDocs.add(mastDoc1);

       
       MasterDocument__c mastDoc2 = new MasterDocument__c();
       mastDoc2.Application__c = application.id;
       mastDoc2.IsChecked__c = true;
       mastDoc2.MasterDocumentName__c = 'Guarantee Letter';
       mastDocs.add(mastDoc2);

       insert mastDocs;
       
      /* genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
       appEqp.genesis__Application__c = application.id;
       insert appEqp;*/
       
       test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ()); 
      
                 OriginateCongaController.hplesae(application.id);
  
       
       test.stopTest();
        
    }
  @isTest
    public static void OriginateCongaCntlr1(){
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
        genesis__Applications__c application = new genesis__Applications__c();
       
        
        
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        application.genesis__Loan_Amount__c = 6700;
        application.genesis__company__c = genesis.TestHelper.createCompany().Id;
        application.genesis__Expected_Start_Date__c = Date.today();
        application.genesis__Warranty_Amount__c=0;
        application.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        application.genesis__Tax_Amount__c=0;
        application.genesis__CL_Product__c = null;
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;
        application.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
        //application.Equipment_Count__c = 10;
        application.genesis__CL_Product__c = prod.id;
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        application.genesis__Account__c = a.Id;
        insert application;
        genesis__Equipment_Master__c eqpMas = new genesis__Equipment_Master__c();
        eqpMas.genesis__Equipment_Type__c = 'VEHICLE';
        insert eqpMas;
        
    genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
    appEqp.genesis__Application__c = application.id;
    appEqp.Equipment_Type__c ='Tractor';
    appEqp.genesis_Equipment_Description__c = 'test';
    appEqp.genesis_Net_Asset_Cost__c = 50000;
    appEqp.genesis_make__c ='test';
        appEqp.genesis__Equipment__c = eqpMas.id;
    insert appEqp;
    
    genesis__Application_Equipment__c appEqp1 = new genesis__Application_Equipment__c();
    appEqp1.Equipment_Type__c ='Tractor';
        appEqp1.genesis__Equipment__c = eqpMas.id;
    appEqp1.genesis__Application__c = application.id;
    appEqp1.genesis_Equipment_Description__c = 'test';
    appEqp1.genesis_Net_Asset_Cost__c = 50000;
    appEqp1.genesis_make__c ='test';
    insert appEqp1;
        
    genesis__Application_Equipment__c appEqp2 = new genesis__Application_Equipment__c();
    appEqp2.Equipment_Type__c ='Tractor';
    appEqp2.genesis__Application__c = application.id;
    appEqp2.genesis_Equipment_Description__c = 'test';
    appEqp2.genesis_Net_Asset_Cost__c = 50000;
    appEqp2.genesis_make__c ='test';
        appEqp2.genesis__Equipment__c = eqpMas.id;
    insert appEqp2;
    
    genesis__Application_Equipment__c appEqp3 = new genesis__Application_Equipment__c();
    appEqp3.Equipment_Type__c ='Tractor';
    appEqp3.genesis__Application__c = application.id;
    appEqp3.genesis_Equipment_Description__c = 'test';
    appEqp3.genesis_Net_Asset_Cost__c = 50000;
    appEqp3.genesis_make__c ='test';
        appEqp3.genesis__Equipment__c = eqpMas.id;
    insert appEqp3;
        
       list<MasterDocument__c> mastDocs = new list<MasterDocument__c>();
        
       MasterDocument__c mastDoc = new MasterDocument__c();
       mastDoc.Application__c = application.id;
       mastDoc.IsChecked__c = true;
       mastDoc.MasterDocumentName__c = 'HP Agreement';
       mastDocs.add(mastDoc);
        
       MasterDocument__c mastDoc1 = new MasterDocument__c();
       mastDoc1.Application__c = application.id;
       mastDoc1.IsChecked__c = true;
       mastDoc1.MasterDocumentName__c = 'Lease Agreement';
       mastDocs.add(mastDoc1);

       
       MasterDocument__c mastDoc2 = new MasterDocument__c();
       mastDoc2.Application__c = application.id;
       mastDoc2.IsChecked__c = true;
       mastDoc2.MasterDocumentName__c = 'Guarantee Letter';
       mastDocs.add(mastDoc2);

       insert mastDocs;
     
     
       
      /* genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
       appEqp.genesis__Application__c = application.id;
       insert appEqp;*/
       
       test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ()); 
      
                 OriginateCongaController.hplesae(application.id);
  
       
       test.stopTest();
        
    }
    @isTest
    public static void OriginateCongaCntlr2(){
        Account a = new Account();
        a.Name = 'TestAccount';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Landline__c='12345 123456';
        insert a;
       
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c();
        prod.clcommon__Product_Name__c = 'Sale & HP Back';
        insert prod;
        genesis__Applications__c application = new genesis__Applications__c();
       
        
        
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'Sale & HP Back';
        application.genesis__Loan_Amount__c = 6700;
        application.genesis__company__c = genesis.TestHelper.createCompany().Id;
        application.genesis__Expected_Start_Date__c = Date.today();
        application.genesis__Warranty_Amount__c=0;
        application.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        application.genesis__Tax_Amount__c=0;
        application.genesis__CL_Product__c = null;
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;
        application.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
        //application.Equipment_Count__c = 10;
        application.genesis__CL_Product__c = prod.id;
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        application.genesis__Account__c = a.Id;
        insert application;
        
        
       list<MasterDocument__c> mastDocs = new list<MasterDocument__c>();
        
       MasterDocument__c mastDoc = new MasterDocument__c();
       mastDoc.Application__c = application.id;
       mastDoc.IsChecked__c = true;
       mastDoc.MasterDocumentName__c = 'Sale & HP Back Agreement';
       mastDocs.add(mastDoc);
        
      /* MasterDocument__c mastDoc1 = new MasterDocument__c();
       mastDoc1.Application__c = application.id;
       mastDoc1.IsChecked__c = true;
       mastDoc1.MasterDocumentName__c = 'Lease Agreement';
       mastDocs.add(mastDoc1);

       
       MasterDocument__c mastDoc2 = new MasterDocument__c();
       mastDoc2.Application__c = application.id;
       mastDoc2.IsChecked__c = true;
       mastDoc2.MasterDocumentName__c = 'Guarantee Letter';
       mastDocs.add(mastDoc2);*/

       insert mastDocs;
       
      /* genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
       appEqp.genesis__Application__c = application.id;
       insert appEqp;*/
       
       test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ()); 
      
                 OriginateCongaController.hplesae(application.id);
  
       
       test.stopTest();
        
    }
   @isTest
    public static void OriginateCongaCntlr3(){
        Account a = new Account();
        a.Name = 'TestAccount';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Landline__c='12345 123456';
        insert a;
       
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c();
        prod.clcommon__Product_Name__c = 'Sale & HP Back';
        insert prod;
        genesis__Applications__c application = new genesis__Applications__c();
       
        
        
        application.genesis__Contact__c = genesis.TestHelper.createContact().Id;
        application.genesis__Product_Type__c = 'LEASE';
        application.genesis__Product_Sub_Type__c = 'Sale & HP Back';
        application.genesis__Loan_Amount__c = 6700;
        application.genesis__company__c = genesis.TestHelper.createCompany().Id;
        application.genesis__Expected_Start_Date__c = Date.today();
        application.genesis__Warranty_Amount__c=0;
        application.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        application.genesis__Tax_Amount__c=0;
        application.genesis__CL_Product__c = null;
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;
        application.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
        //application.Equipment_Count__c = 10;
        application.genesis__CL_Product__c = prod.id;
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        application.genesis__Account__c = a.Id;
        insert application;
    
    genesis__Equipment_Master__c eqpMas = new genesis__Equipment_Master__c();
        eqpMas.genesis__Equipment_Type__c = 'VEHICLE';
        insert eqpMas;
        
    genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
    appEqp.genesis__Application__c = application.id;
    appEqp.Equipment_Type__c ='Tractor';
    appEqp.genesis_Equipment_Description__c = 'test';
    appEqp.genesis_Net_Asset_Cost__c = 50000;
    appEqp.genesis_make__c ='test';
        appEqp.genesis__Equipment__c = eqpMas.id;
    insert appEqp;
    
    genesis__Application_Equipment__c appEqp1 = new genesis__Application_Equipment__c();
    appEqp1.Equipment_Type__c ='Tractor';
        appEqp1.genesis__Equipment__c = eqpMas.id;
    appEqp1.genesis__Application__c = application.id;
    appEqp1.genesis_Equipment_Description__c = 'test';
    appEqp1.genesis_Net_Asset_Cost__c = 50000;
    appEqp1.genesis_make__c ='test';
    insert appEqp1;
        
    genesis__Application_Equipment__c appEqp2 = new genesis__Application_Equipment__c();
    appEqp2.Equipment_Type__c ='Tractor';
    appEqp2.genesis__Application__c = application.id;
    appEqp2.genesis_Equipment_Description__c = 'test';
    appEqp2.genesis_Net_Asset_Cost__c = 50000;
    appEqp2.genesis_make__c ='test';
        appEqp2.genesis__Equipment__c = eqpMas.id;
    insert appEqp2;
    
    genesis__Application_Equipment__c appEqp3 = new genesis__Application_Equipment__c();
    appEqp3.Equipment_Type__c ='Tractor';
    appEqp3.genesis__Application__c = application.id;
    appEqp3.genesis_Equipment_Description__c = 'test';
    appEqp3.genesis_Net_Asset_Cost__c = 50000;
    appEqp3.genesis_make__c ='test';
        appEqp3.genesis__Equipment__c = eqpMas.id;
    insert appEqp3;
        
        
       list<MasterDocument__c> mastDocs = new list<MasterDocument__c>();
        
       MasterDocument__c mastDoc = new MasterDocument__c();
       mastDoc.Application__c = application.id;
       mastDoc.IsChecked__c = true;
       mastDoc.MasterDocumentName__c = 'Sale & HP Back Agreement';
       mastDocs.add(mastDoc);
        
      /* MasterDocument__c mastDoc1 = new MasterDocument__c();
       mastDoc1.Application__c = application.id;
       mastDoc1.IsChecked__c = true;
       mastDoc1.MasterDocumentName__c = 'Lease Agreement';
       mastDocs.add(mastDoc1);

       
       MasterDocument__c mastDoc2 = new MasterDocument__c();
       mastDoc2.Application__c = application.id;
       mastDoc2.IsChecked__c = true;
       mastDoc2.MasterDocumentName__c = 'Guarantee Letter';
       mastDocs.add(mastDoc2);*/

       insert mastDocs;
       
      /* genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
       appEqp.genesis__Application__c = application.id;
       insert appEqp;*/
       
       test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ()); 
      
                 OriginateCongaController.hplesae(application.id);
  
       
       test.stopTest();
        
    }

}