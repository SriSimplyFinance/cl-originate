@isTest
Public class SAF_FeeeScheduleProposalTrigger_Test{
    
    @isTest
    public static void feeScheduleTest(){
    
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;

      
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'accounttt';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
         
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
        application.genesis__Other_Financed_Fees__c = 0;
        application.genesis__Financed_Amount__c = 6700;
        application.genesis__Customer_cash_available__c = 1500;
        application.genesis__Status__c = genesis.LendingConstants.APPL_STATUS_NEW_ENTERED;
        application.genesis__Term__c = 12;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Interest_Rate__c = 10;
       
        application.genesis__Lending_Product__c = genesis.TestHelper.createLeaseProduct().Id;
        
        application.genesis__Account__c = acc.Id;
        insert application;
        
        Fee_Schedule_Proposal__c fs = new Fee_Schedule_Proposal__c();

        fs.Number_of_Periods__c               = 10;
        fs.Amount__c                          = 2000;
        fs.frequency__c                       = 'Monthly';
        fs.Start_Date__c                      = system.today();
        fs.Application__c                   = application.id;  
            
        insert fs;
          
        genesis__Fee_Schedule__c feeSch = new genesis__Fee_Schedule__c(); //instantiate the object to put values for future record
        feeSch.genesis__Number_of_Periods__c     = fs.Number_of_Periods__c;
        feeSch.genesis__Amount__c                = fs.Amount__c;
        feeSch.genesis__Frequency__c             = fs.frequency__c;
        feeSch.genesis__Start_Date__c            = fs.Start_Date__c;
        feeSch.genesis__Application__c           = fs.Application__c;
        feeSch.Fee_Schedule_Proposal__c          = fs.Id;
         
        insert feeSch;
        delete fs;
          
            
    }
    
  
    
}