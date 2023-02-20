@isTest
public class SAF_PaymentStreamProposalTrigger_Test{

     @isTest
     public static void PaymentStreamTest(){
     
      //User userRec = [Select Id, loan__Current_Branch_s_System_Date__c from user where id =: UserInfo.getUserId()];
        Date todaysDate = system.today();
    
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
        application.genesis__Expected_Start_Date__c = todaysDate;
        application.genesis__Warranty_Amount__c=0;
        application.genesis__Sales_Division__c =genesis.LendingConstants.SOURCE_DIRECT;
        application.genesis__Tax_Amount__c=0;
        application.genesis__Expected_First_Payment_Date__c = todaysDate.addDays(30);
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
        
        Payment_Stream_Proposal__c  ps = new Payment_Stream_Proposal__c ();
        ps.Number_of_Payments__c = 1;
        ps.Payment_Amount__c     = 10000;
        ps.Payment_Frequency__c  = 'Monthly';
        ps.Start_Date__c         = todaysDate;
        ps.Application__c        = application.id;
        
        insert ps;

        try
        {
          genesis__Payment_Stream__c clPS = new genesis__Payment_Stream__c(); //instantiate the object to put values for future record
            clPS.genesis__Number_of_Payments__c    = 1;
            clPS.genesis__Payment_Amount__c        = 10000;
            clPS.genesis__Payment_Frequency__c     = 'Monthly';
           clPS.genesis__Start_Date__c             =  ps.Start_Date__c;
            clPS.genesis__Application__c           = application.id;
            clPS.Payment_Stream_Proposal__c        = ps.Id;
            clPS.genesis__Payment_Type__c          = 'Rent';
          
       insert clPS;
       }
       catch(exception e)
       {
       }
                           delete ps;

    
            
    }

}