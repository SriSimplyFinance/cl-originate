@isTest(SeeAllData = true)
public class TestPayable
{
    
    static testmethod void TestPayableCtrl()
    {
       SAF_HelperTest.Helper1();  
           //User creation
    List<Profile> PROFILE1 = [SELECT Id, Name FROM Profile WHERE name='System Administrator' LIMIT 1];
    String MyProflieId1 = PROFILE1[0].Id;
    User u1 = new User(Alias = 'admin', Email='safAdminuser@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = MyProflieId1, 
    TimeZoneSidKey='America/Los_Angeles', UserName='safAdminuser@testorg.com');
    
    //cllease__Lease_Product__c Product = [select id,name from cllease__Lease_Product__c where name='Finance Lease'];
     cllease__Lease_Product__c prd = [Select Id,name from cllease__Lease_Product__c where cllease__Status__c= 'Active' limit 1];
     clcommon__Fee_Set__c fs = [SELECT Id, name FROM clcommon__Fee_Set__c LIMIT 1]; 
     
     saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        objSettings.zoho_CretaOppEndpoint__c='sssss';
        UPSERT objSettings;
        
        List<Saf_ZohoLSFieldMapping__c> mcs = Saf_ZohoLSFieldMapping__c.getall().values();
        Saf_ZohoLSFieldMapping__c   m1 =new Saf_ZohoLSFieldMapping__c();
        m1.Salesforce_Field__c='Agreement_link__c';
        m1.Zoho_Fields__c='Agreement_Link';
        m1.Name='Contract_Ref';
        upsert m1;
        mcs.add(m1);        
        Saf_ZohoLSFieldMapping__c   m2 =new Saf_ZohoLSFieldMapping__c();
        m2.Salesforce_Field__c='cllease__contract_date__c';
        m2.Zoho_Fields__c='Start_Date';
        m2.Name='name';
        upsert m2;
        mcs.add(m2);
        
        Saf_ZohoLSFieldMapping__c   m3 =new Saf_ZohoLSFieldMapping__c();
        m3.Salesforce_Field__c='XIRR5__c';
        m3.Zoho_Fields__c='Yield';
        m3.Name='yieldd';
        upsert m3;
        mcs.add(m3);
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());   
    //Account a = [Select name,ID from account where name like'%Test%' limit 1];
            Account a = new Account();
           // a.RecordtypeID=rec.id;
            a.Name = 'TestAccount-DealerFunding';
            a.Phone = '98767 678987';
            a.Landline__c= '98767 678987';
            a.BillingPostalCode = 'BD1 1HA';
            a.BillingCity = 'London';
            a.ShippingPostalCode = 'BD1 1HA';
            a.ShippingCity = 'London';
            insert a;
         
    cllease__Lease_Account__c Agreement = new cllease__Lease_Account__c (cllease__Account__c=a.id,cllease__Lease_Product_Name__c=prd.id,
                                           cllease__Lease_Status__c='ACTIVE - GOOD STANDING',   cllease__Fee_Set1__c=fs.id
                                           ,cllease__Contract_Date__c=System.Today(),cllease__First_Payment_Date__c=System.Today()+1
                                           ,cllease__Current_Term__c=24,cllease__Payment_Frequency__c='Monthly',cllease__Grace_Period_for_Repayments__c=6
                                           ,cllease__Delinquency_Grace_Days__c=30,cllease__Pre_Bill_Days__c=30,cllease__Active_flag__c=True
                                           ,cllease__Term__c=12);
    //cllease__Lease_Account__c Agreement = new cllease__Lease_Account__c();
    //Agreement.cllease__Lease_Status__c='ACTIVE - GOOD STANDING';
    //Agreement.cllease__Account__c = acct.id;
    //Agreement.cllease__Lease_Product_Name__c = Product.name;
    insert Agreement;
     
  
    Contact contact = new Contact();
    contact.FirstName = 'Test1';
    contact.LastName = 'contact';
    contact.Account = a;
    clcommon__Bank_Account__c BankAcct =new clcommon__Bank_Account__c();
    BankAcct.clcommon__Account__c=a.id;
    BankAcct.Account_Number__c = '123456789';
    BankAcct.clcommon__Routing_Number__c = '909090';
    BankAcct.clcommon__Active__c=true;
    BankAcct.clcommon__Contact__c = contact.id;
    insert BankAcct;
    cllease__Contract_Parties__c party = new cllease__Contract_Parties__c();
    party.cllease__Contract__c = Agreement.id;
    party.cllease__Party_Type__c = 'DEALER';
    party.cllease__Party_Account_Name__c = a.id;
    party.cllease__Party_Name__c = contact.id;
    insert party;
    
  
    
    Dealer_Funding__c Df = new Dealer_Funding__c();
    Df.Contract__c = Agreement.Id;
    Df.Dealer__c=party.Id ;
    Df.Bank_Account__c = BankAcct.Id;
    Df.Dealer_Charges__c = 10;
    Df.Dealer_Funded__c=false;
    Df.Reference__c='Test';
    insert Df;
    
    system.debug('Data created ' );
    ApexPages.currentPage().getParameters().put('id',Agreement.Id);
    PayablesController  testPayable = new PayablesController();
    testPayable.cParam=Df.id;
   
    Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());   
    PayablesController.dealerFundingwrapper wrapper = new PayablesController.dealerFundingwrapper(Df);
 
    testPayable.dealerFundingList[0].selected = true;
    
    System.Assert(testPayable.dealerFundingList!=null);
    PageReference pageRef = Page.payables; 
    Test.setCurrentPage(pageRef);
    System.assertEquals(false,testPayable.required);
    //System.assertEquals(true,testPayable.selected);
    testPayable.getdealerFunding();
    testPayable.getSelected();
    System.assertEquals(true,testPayable.dealerFundingList[0].selected);
    System.debug('DealerListValue ' +testPayable.dealerFundingList);
    testPayable.FundPart();
    Integer checkExists = [SELECT Count() FROM cllease__Other_Transaction__c  where cllease__Lease_Account__c =:Agreement.Id];
    testPayable.FundAll();
    testPayable.deleteDealerFunding();
    testPayable.cancel();
    testPayable.redirect();
    
     //User creation
    List<Profile> PROFILEFin = [SELECT Id, Name FROM Profile WHERE name='SAF-Finance' LIMIT 1];
    String MyProflieId = PROFILEFin[0].Id;
    User u = new User(Alias = 'saff', Email='saffinanceuser@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = MyProflieId, 
    TimeZoneSidKey='America/Los_Angeles', UserName='saffinanceuser@testorg.com');
    
     Dealer_Funding__c Df1 = new Dealer_Funding__c();
    Df1.Contract__c = Agreement.Id;
    Df1.Dealer__c= party.Id ;
    Df1.Bank_Account__c = BankAcct.Id;
    Df1.Dealer_Charges__c = 10;
    Df1.Dealer_Funded__c=false;
    Df1.Reference__c='Test1';
    insert Df1;
   
    List<User> user1 = [SELECT Id, Name FROM USer WHERE Profile.Id =: MyProflieId and IsActive = true LIMIT 1];// '0050O0000088aE8'
    System.runAs(user1[0]) 
    {
  
    ApexPages.currentPage().getParameters().put('id',Agreement.Id);
    PayablesController  testPayable1 = new PayablesController();
    testPayable1.cParam=Df1.id;
    
    PayablesController.dealerFundingwrapper wrapper1 = new PayablesController.dealerFundingwrapper(Df);
    
    testPayable1.dealerFundingList[0].selected = true;
    
    System.Assert(testPayable1.dealerFundingList!=null);
    PageReference pageRef1 = Page.payables; 
    Test.setCurrentPage(pageRef1);
    System.assertEquals(false,testPayable1.required);
    
      testPayable1.dealerFundingList[0].selected = true;
      testPayable1.FundPart();
      testPayable1.FundAll ();
      testPayable1.deleteDealerFunding();
   }
     List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE name='SAF-Underwriting' LIMIT 1];
    String MyProflieUnd = PROFILE[0].Id;
    List<User> user2 = [SELECT Id, Name FROM USer WHERE Profile.Id =: MyProflieUnd and IsActive = true LIMIT 1];//Id ='0050O0000074LoX'
    System.runAs(user2[0]) 
    {
  
    ApexPages.currentPage().getParameters().put('id',Agreement.Id);
    PayablesController  testPayable1 = new PayablesController();
    testPayable1.cParam=Df1.id;
    
    PayablesController.dealerFundingwrapper wrapper1 = new PayablesController.dealerFundingwrapper(Df);
    
    //testPayable1.dealerFundingList[0].selected = true;
    
    System.Assert(testPayable1.dealerFundingList!=null);
    PageReference pageRef1 = Page.payables; 
    Test.setCurrentPage(pageRef1);
    System.assertEquals(false,testPayable1.required);
    
     // testPayable1.dealerFundingList[0].selected = true;
      testPayable1.FundPart();
      testPayable1.FundAll ();
      
     
      testPayable1.deleteDealerFunding();
      }
     try
        {
             Df1 = new Dealer_Funding__c();
             Df1.Contract__c = Agreement.Id;
            Df1.Dealer__c= party.Id ;
            Df1.Bank_Account__c = BankAcct.Id;
             df1.Dealer_Charges__c= 10000000;
            Df1.Dealer_Funded__c=false;
            Df1.Reference__c='Test1';
            insert Df1;
             testPayable.FundAll();
          
         }
         catch (exception ex)
         {
             system.debug('ex excess: ' + ex);
         }
     
        try
            {
                delete BankAcct; 
                 Df1 = new Dealer_Funding__c();
                 Df1.Contract__c = Agreement.Id;
                Df1.Dealer__c= party.Id ;
                Df1.Bank_Account__c = BankAcct.Id;
                 df1.Dealer_Charges__c= 10;
                Df1.Dealer_Funded__c=false;
                insert Df1;
               
                
                
                    testPayable.FundAll();
             }
             catch (exception ex)
             {
                 system.debug('ex1 : ' + ex);
             } 

}

 static testmethod void TestPayableCtrl2()
    {
   
     SAF_HelperTest.Helper1();  
    
    //cllease__Lease_Product__c Product = [select id,name from cllease__Lease_Product__c where name='Finance Lease'];
     cllease__Lease_Product__c prd = [Select Id,name from cllease__Lease_Product__c where cllease__Status__c= 'Active' limit 1];
     //cllease__Lease_Product__c prd = [Select Id,name from cllease__Lease_Product__c  /*name like'%Test%'*/ limit 1];//where cllease__Status__c='Active'
     clcommon__Fee_Set__c fs = [SELECT Id, name FROM clcommon__Fee_Set__c LIMIT 1]; 
     
     saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        objSettings.zoho_CretaOppEndpoint__c='sssss';
        UPSERT objSettings;
        
        List<Saf_ZohoLSFieldMapping__c> mcs = Saf_ZohoLSFieldMapping__c.getall().values();
        Saf_ZohoLSFieldMapping__c   m1 =new Saf_ZohoLSFieldMapping__c();
        m1.Salesforce_Field__c='Agreement_link__c';
        m1.Zoho_Fields__c='Agreement_Link';
        m1.Name='Contract_Ref';
        upsert m1;
        mcs.add(m1);        
        Saf_ZohoLSFieldMapping__c   m2 =new Saf_ZohoLSFieldMapping__c();
        m2.Salesforce_Field__c='cllease__contract_date__c';
        m2.Zoho_Fields__c='Start_Date';
        m2.Name='name';
        upsert m2;
        mcs.add(m2);
        
        Saf_ZohoLSFieldMapping__c   m3 =new Saf_ZohoLSFieldMapping__c();
        m3.Salesforce_Field__c='XIRR5__c';
        m3.Zoho_Fields__c='Yield';
        m3.Name='yieldd';
        upsert m3;
        mcs.add(m3);   
    //Account a = [Select name,ID from account where name like'%Test%' limit 1];
            Account a = new Account();
           // a.RecordtypeID=rec.id;
            a.Name = 'TestAccount-DealerFunding';
            a.Phone = '98767 678987';
            a.Landline__c= '98767 678987';
            a.BillingPostalCode = 'BD1 1HA';
            a.BillingCity = 'London';
            a.ShippingPostalCode = 'BD1 1HA';
            a.ShippingCity = 'London';
            insert a;
      Test.setMock(HttpCalloutMock.class,new SAF_AddDocumentCategoryToApp_Test.Saf_ZohoUnderWritingMock());
      
     
       clcommon__Fee_Set__c  fee=new clcommon__Fee_Set__c();
        //fee.CurrencyIsoCode ='GBP';
        fee.Name='hh';
        insert fee;
   
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = ' Operating Lease ';
        pr1.Fee_Set__c=fee.id;
        INSERT pr1;
        clcommon__Party_Type__c objtype = new clcommon__Party_Type__c();
        objtype.Name = 'DEALER';
        insert objtype;
         //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 12000;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';        
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__CL_Product__c=pr1.id;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Dealer_Payment_Date__c= date.newInstance(2019, 12, 12);
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = date.newInstance(2019, 12, 12);
        genApp.genesis__Account__c = a.Id; 
          INSERT genApp;
          
        clcommon__Party__c Orgparty = new clcommon__Party__c();
    Orgparty.genesis__Application__c = genApp.Id ; //'a7F3O000000CfMbUAK';
    Orgparty.clcommon__Type__c = objtype.ID; //'a4y0O0000004N7i';
    Orgparty.clcommon__Account__c = a.id;  
    insert Orgparty ;
    
   
    Invoice__c objin = new Invoice__c();
    objin.Application__c =genApp.Id ; //'a7F3O000000CfMbUAK';
    objin.Deposit_Paid_To_Supplier__c = 100;
    objin.Invoice_Number__c = 'INC-09090';
    objin.Supplier1__c = Orgparty.Id;
    objin.Invoice_Due_Date__c = date.valueof('2020-01-01');
      insert objin;   
    
    cllease__Lease_Account__c Agreement = new cllease__Lease_Account__c (cllease__Account__c=a.id,cllease__Lease_Product_Name__c=prd.id,
                                           cllease__Lease_Status__c='ACTIVE - GOOD STANDING',   cllease__Fee_Set1__c=fs.id
                                           ,cllease__Contract_Date__c=System.Today(),cllease__First_Payment_Date__c=System.Today()+1
                                           ,cllease__Current_Term__c=24,cllease__Payment_Frequency__c='Monthly',cllease__Grace_Period_for_Repayments__c=6
                                           ,cllease__Delinquency_Grace_Days__c=30,cllease__Pre_Bill_Days__c=30,cllease__Active_flag__c=True
                                           ,cllease__Term__c=12);
    //cllease__Lease_Account__c Agreement = new cllease__Lease_Account__c();
    //Agreement.cllease__Lease_Status__c='ACTIVE - GOOD STANDING';
    //Agreement.cllease__Account__c = acct.id;
    //Agreement.cllease__Lease_Product_Name__c = Product.name;
    insert Agreement;
    Contact contact = new Contact();
    contact.FirstName = 'Test1';
    contact.LastName = 'contact';
    contact.Account = a;
    clcommon__Bank_Account__c BankAcct =new clcommon__Bank_Account__c();
    BankAcct.clcommon__Account__c=a.id;
    BankAcct.Account_Number__c = '123456789';
    BankAcct.clcommon__Routing_Number__c = '909090';
    BankAcct.clcommon__Active__c=true;
    BankAcct.clcommon__Contact__c = contact.id;
    insert BankAcct;
    cllease__Contract_Parties__c party = new cllease__Contract_Parties__c();
    party.cllease__Contract__c = Agreement.id;
    party.cllease__Party_Type__c = 'BROKER';
    party.cllease__Party_Account_Name__c = a.id;
    //party.cllease__Party_Name__c = contact.id;
    insert party;
   
    cllease__Contract_Fees__c objfee = new cllease__Contract_Fees__c ();
   objfee.Pay_To_Account_Id__c = a.Id;
   objfee.cllease__Amount__c= 100;
   objfee.cllease__Contract__c = Agreement.id;
   objfee.cllease__Fee_Definition__c = 'a4p0O000000g78M'; 
    insert objfee;
        
     Saf_CommissionFunding__c  df1 = new Saf_CommissionFunding__c ();
      df1.LS_Contract__c = Agreement.Id;
      df1.saf_Amount__c = 100; //objfee.cllease__Amount__c;
      //obj.saf_Reference__c = objfee.Name;
      df1.saf_Date__c = null; //objfee.cllease__start_date__c;
      df1.Fee_Schedule__c = objfee.Id;
      df1.Payment_Mode__c = Label.PayablesPaymentMode; //'a6S0O0000005Vgg';
      df1.saf_contractParty__c = party.Id;
       df1.saf_Bank_Account__c = BankAcct.Id;
       // df1.saf_Dealer_Charges__c = 10;
        df1.saf_Fee_Funded__c =false;
   insert df1;
    system.debug('Data created ' );
    ApexPages.currentPage().getParameters().put('id',Agreement.Id);
   // PayablesController  testPayablenew = new PayablesController();
   //    testPayablenew.GetCommissionDet();
   // testPayablenew.getSelectedComm();
   // insert df1;
      PayablesController  testPayable = new PayablesController();
    testPayable.cParam=Df1.id;
    Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());
    //PayablesController.dealerFundingwrapper wrapper = new PayablesController.dealerFundingwrapper(Df1);
    
    testPayable.ExpenseFeeList[0].saf_Selected__c = true;
    
    System.Assert(testPayable.ExpenseFeeList !=null);
    PageReference pageRef = Page.payables; 
    Test.setCurrentPage(pageRef);
    System.assertEquals(false,testPayable.required);
    //System.assertEquals(true,testPayable.selected);
    testPayable.GetCommissionDet();
    testPayable.getSelectedComm();
    //System.assertEquals(true,testPayable.ExpenseFeeList[0].saf_Selected__c );
    System.debug('ExpenseFeeList ' +testPayable.ExpenseFeeList);
    testPayable.FundAllCom();
    Integer checkExists = [SELECT Count() FROM cllease__Other_Transaction__c  where cllease__Lease_Account__c =:Agreement.Id];
    testPayable.FundAllCom();
    testPayable.deleteCommFunding();
    testPayable.cancel();
    testPayable.redirectcomm();
    
    //User creation
    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE name='SAF-Finance' LIMIT 1];
    String MyProflieId = PROFILE[0].Id;
    User u = new User(Alias = 'saff', Email='saffinanceuser@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = MyProflieId, 
    TimeZoneSidKey='America/Los_Angeles', UserName='saffinanceuser@testorg.com');
      List<User> user1 = [SELECT Id, Name FROM USer WHERE Id ='0050O0000088aE8' LIMIT 1];
     Saf_CommissionFunding__c  df = new Saf_CommissionFunding__c ();
      df.LS_Contract__c = Agreement.Id;
      df.saf_Amount__c = 100; //objfee.cllease__Amount__c;
      //obj.saf_Reference__c = objfee.Name;
      df.saf_Date__c = null; //objfee.cllease__start_date__c;
      df.Fee_Schedule__c = objfee.Id;
      df.Payment_Mode__c = Label.PayablesPaymentMode; //'a6S0O0000005Vgg';
      df.saf_contractParty__c = party.Id;
      //  df.saf_Bank_Account__c = BankAcct.Id;

    df.saf_Fee_Funded__c =false;
    insert df;
     df.saf_Amount__c = 90;
        update df;
    try
    {
        df.saf_Amount__c = 100000000;
        update df;
     }
     catch (exception ex)
     {
         system.debug('ex : ' + ex);
     }
     
    
    System.runAs(user1[0]) 
    {
   
    ApexPages.currentPage().getParameters().put('id',Agreement.Id);
    PayablesController  testPayable2 = new PayablesController();
    testPayable2.cParam=df.id;
    
   // PayablesController.dealerFundingwrapper wrapper1 = new PayablesController.dealerFundingwrapper(Df);
    
    testPayable2.ExpenseFeeList[0].saf_Selected__c  = true;
    
    System.Assert(testPayable2.ExpenseFeeList !=null);
    PageReference pageRef1 = Page.payables; 
    Test.setCurrentPage(pageRef1);
    System.assertEquals(false,testPayable2.required);
    
      testPayable2.ExpenseFeeList[0].saf_Selected__c = true;
      testPayable2.FundAllCom();
     
    
    
      }
       List<Profile> PROFILE1 = [SELECT Id, Name FROM Profile WHERE name='SAF-Underwriting' LIMIT 1];
    String MyProflieUnd = PROFILE1[0].Id;
    List<User> user2 = [SELECT Id, Name FROM USer WHERE Id ='0050O0000074LoX' LIMIT 1];
     System.runAs(user2[0]) 
        {
       
        ApexPages.currentPage().getParameters().put('id',Agreement.Id);
        //PayablesController  testPayable2 = new PayablesController();
        testPayable.cParam=df.id;
        
       // PayablesController.dealerFundingwrapper wrapper1 = new PayablesController.dealerFundingwrapper(Df);
        
        testPayable.ExpenseFeeList[0].saf_Selected__c  = true;
        
        System.Assert(testPayable.ExpenseFeeList !=null);
        PageReference pageRef1 = Page.payables; 
        Test.setCurrentPage(pageRef1);
        System.assertEquals(false,testPayable.required);
        
          testPayable.ExpenseFeeList[0].saf_Selected__c = true;
          testPayable.FundAllCom();
        // testPayable.deleteCommFunding();
        
        
          }
         try
            {
                delete BankAcct; 
                 df.saf_Amount__c = 80;
                update df; 
               
                
                
                    testPayable.FundAllCom();
             }
             catch (exception ex)
             {
                 system.debug('ex2 : ' + ex);
             }
   //   test.stoptest();   
}
  
 static testmethod void TestPayableCtrl3()
    {
      SAF_HelperTest.Helper1();  
      cllease__Lease_Product__c prd = [SELECT Id,Name FROM cllease__Lease_Product__c WHERE cllease__Status__c = 'Active' LIMIT 1];
      //cllease__Lease_Product__c prd = [Select Id,name from cllease__Lease_Product__c  /*name like'%Test%'*/ limit 1];
     clcommon__Fee_Set__c fs = [SELECT Id, name FROM clcommon__Fee_Set__c LIMIT 1]; 
     
     saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        objSettings.zoho_CretaOppEndpoint__c='sssss';
        UPSERT objSettings;
        
        List<Saf_ZohoLSFieldMapping__c> mcs = Saf_ZohoLSFieldMapping__c.getall().values();
        Saf_ZohoLSFieldMapping__c   m1 =new Saf_ZohoLSFieldMapping__c();
        m1.Salesforce_Field__c='Agreement_link__c';
        m1.Zoho_Fields__c='Agreement_Link';
        m1.Name='Contract_Ref';
        upsert m1;
        mcs.add(m1);        
        Saf_ZohoLSFieldMapping__c   m2 =new Saf_ZohoLSFieldMapping__c();
        m2.Salesforce_Field__c='cllease__contract_date__c';
        m2.Zoho_Fields__c='Start_Date';
        m2.Name='name';
        upsert m2;
        mcs.add(m2);
        
        Saf_ZohoLSFieldMapping__c   m3 =new Saf_ZohoLSFieldMapping__c();
        m3.Salesforce_Field__c='XIRR5__c';
        m3.Zoho_Fields__c='Yield';
        m3.Name='yieldd';
        upsert m3;
        mcs.add(m3);   
    //Account a = [Select name,ID from account where name like'%Test%' limit 1];
      Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());
            Account a = new Account();
           // a.RecordtypeID=rec.id;
            a.Name = 'TestAccount-DealerFunding';
            a.Phone = '98767 678987';
            a.Landline__c= '98767 678987';
            a.BillingPostalCode = 'BD1 1HA';
            a.BillingCity = 'London';
            a.ShippingPostalCode = 'BD1 1HA';
            a.ShippingCity = 'London';
            insert a;
      Test.setMock(HttpCalloutMock.class,new SAF_AddDocumentCategoryToApp_Test.Saf_ZohoUnderWritingMock());
       clcommon__Fee_Set__c  fee=new clcommon__Fee_Set__c();
        //fee.CurrencyIsoCode ='GBP';
        fee.Name='hh';
        insert fee;
   
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = ' Operating Lease ';
        pr1.Fee_Set__c=fee.id;
        INSERT pr1;
         clcommon__Party_Type__c objtype = new clcommon__Party_Type__c();
        objtype.Name = 'BROKER';
        insert objtype;
         clcommon__Party_Type__c objtype1 = new clcommon__Party_Type__c();
        objtype1.Name = 'DEALER';
        insert objtype1;
         //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 12000;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';        
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__CL_Product__c=pr1.id;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Dealer_Payment_Date__c= date.newInstance(2019, 12, 12);
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = date.newInstance(2019, 12, 12);
        genApp.genesis__Account__c = a.Id; 
          INSERT genApp;
        
        clcommon__Party__c Orgparty = new clcommon__Party__c();
        Orgparty.genesis__Application__c =genApp.Id ;//'a7F3O000000CfMbUAK';
        Orgparty.clcommon__Type__c = objtype.Id; //'a4y0O0000004N7i';
        Orgparty.clcommon__Account__c = a.id;  
        insert Orgparty ;
        
       
        Invoice__c objin = new Invoice__c();
        objin.Application__c = genApp.Id; //'a7F3O000000CfMbUAK';
        objin.Deposit_Paid_To_Supplier__c = 100;
        objin.Invoice_Number__c = 'INC-09090';
        objin.Supplier1__c = Orgparty.Id;
        objin.Invoice_Due_Date__c = date.valueof('2020-01-01');
          insert objin;   
    
    cllease__Lease_Account__c Agreement = new cllease__Lease_Account__c (cllease__Account__c=a.id,cllease__Lease_Product_Name__c=prd.id,
                                           cllease__Lease_Status__c='ACTIVE - GOOD STANDING',   cllease__Fee_Set1__c=fs.id
                                           ,cllease__Contract_Date__c=System.Today(),cllease__First_Payment_Date__c=System.Today()+1
                                           ,cllease__Current_Term__c=24,cllease__Payment_Frequency__c='Monthly',cllease__Grace_Period_for_Repayments__c=6
                                           ,cllease__Delinquency_Grace_Days__c=30,cllease__Pre_Bill_Days__c=30,cllease__Active_flag__c=True
                                           ,cllease__Term__c=12);
    //cllease__Lease_Account__c Agreement = new cllease__Lease_Account__c();
    //Agreement.cllease__Lease_Status__c='ACTIVE - GOOD STANDING';
    //Agreement.cllease__Account__c = acct.id;
    //Agreement.cllease__Lease_Product_Name__c = Product.name;
    insert Agreement;
      cllease__Contract_Fees__c obj = new cllease__Contract_Fees__c ();
       obj.Pay_To_Account_Id__c = a.Id;
       obj.cllease__Amount__c= 100;
       obj.cllease__Contract__c = Agreement.id;
       obj.cllease__Fee_Definition__c = 'a4p0O000000g78M'; 
        insert obj;
    Contact contact = new Contact();
    contact.FirstName = 'Test1';
    contact.LastName = 'contact';
    contact.Account = a;
    clcommon__Bank_Account__c BankAcct =new clcommon__Bank_Account__c();
    BankAcct.clcommon__Account__c=a.id;
    BankAcct.Account_Number__c = '123456789';
    BankAcct.clcommon__Routing_Number__c = '909090';
    BankAcct.clcommon__Active__c=true;
    BankAcct.clcommon__Contact__c = contact.id;
    insert BankAcct;
    cllease__Contract_Parties__c party = new cllease__Contract_Parties__c();
    party.cllease__Contract__c = Agreement.id;
    party.cllease__Party_Type__c = 'BROKER';
    party.cllease__Party_Account_Name__c = a.id;
    //party.cllease__Party_Name__c = contact.id;
    insert party;
    cllease__Contract_Parties__c partydeal= new cllease__Contract_Parties__c();
    partydeal.cllease__Contract__c = Agreement.id;
    partydeal.cllease__Party_Type__c = 'DEALER';
    partydeal.cllease__Party_Account_Name__c = a.id;
    //party.cllease__Party_Name__c = contact.id;
    insert partydeal;
           
     Saf_CommissionFunding__c  df1 = new Saf_CommissionFunding__c ();
      df1.LS_Contract__c = Agreement.Id;
      df1.saf_Amount__c = 100; //objfee.cllease__Amount__c;
      //obj.saf_Reference__c = objfee.Name;
      df1.saf_Date__c = null; //objfee.cllease__start_date__c;
      df1.Fee_Schedule__c = obj.Id;
      df1.Payment_Mode__c = Label.PayablesPaymentMode; //'a6S0O0000005Vgg';
      df1.saf_contractParty__c = party.Id;
       df1.saf_Bank_Account__c = BankAcct.Id;
       // df1.saf_Dealer_Charges__c = 10;
        df1.saf_Fee_Funded__c =false;
    //insert df1;
      Dealer_Funding__c Df = new Dealer_Funding__c();
    Df.Contract__c = Agreement.Id;
    Df.Dealer__c=party.Id ;
    Df.Bank_Account__c = BankAcct.Id;
    Df.Dealer_Charges__c = 10;
    Df.Dealer_Funded__c=false;
    //insert Df;
         // Test.setMock(HttpCalloutMock.class, new SAFpaybales()); 
            
         PayablesController.UpdateDealerFundingParty(Agreement.Id,genApp.Id);//'a7F3O000000CfMbUAK','a693O000000D4mQ'
       
            try
            {
                  ApexPages.currentPage().getParameters().put('id',Agreement.Id);
                PayablesController  testPayable2 = new PayablesController();
                testPayable2.cParam=df1.id;
                
               // PayablesController.dealerFundingwrapper wrapper1 = new PayablesController.dealerFundingwrapper(Df);
                 List<Saf_CommissionFunding__c> lstcomm = [SELECT Id,Name,saf_Amount__c FROM Saf_CommissionFunding__c WHERE LS_Contract__c =: Agreement.Id]; 
                   system.debug('lstcomm : ' + lstcomm.size());
                   
                testPayable2.ExpenseFeeList[0].saf_Selected__c  = true;
                //insert BankAcct;
                BankAcct =new clcommon__Bank_Account__c();
                BankAcct.clcommon__Account__c=a.id;
                BankAcct.Account_Number__c = '1234567891';
                BankAcct.clcommon__Routing_Number__c = '909090';
                BankAcct.clcommon__Active__c=true;
                BankAcct.clcommon__Contact__c = contact.id; 
                  insert BankAcct;
                  List<clcommon__Bank_Account__c> lstbnk = [SELECT Id,Name FROM clcommon__Bank_Account__c WHERE clcommon__Account__c =: a.Id]; 
                   system.debug('lstbnk  : ' + lstbnk.size());
               lstcomm[0].saf_Amount__c = 80;
               update lstcomm[0]; 
                         
                
                    testPayable2.FundAllCom();
             }
             catch (exception ex)
             {
                 system.debug('ex3 : ' + ex);
             }
                  try
            {
              
              
                  ApexPages.currentPage().getParameters().put('id',Agreement.Id);
                PayablesController  testPayable2 = new PayablesController();
                testPayable2.cParam=df.id;
                
               // PayablesController.dealerFundingwrapper wrapper1 = new PayablesController.dealerFundingwrapper(Df);
                 List<Dealer_Funding__c> lstcomm = [SELECT Id,Name,Dealer_Charges__c,Contract__c,Reference__c FROM Dealer_Funding__c WHERE Contract__c =: Agreement.Id]; 
                   system.debug('lstcomm : ' + lstcomm.size());
                   
                testPayable2.DealerFundingList[0].Selected  = true;
                //insert BankAcct;
                BankAcct =new clcommon__Bank_Account__c();
                BankAcct.clcommon__Account__c=a.id;
                BankAcct.Account_Number__c = '1234567891';
                BankAcct.clcommon__Routing_Number__c = '909090';
                BankAcct.clcommon__Active__c=true;
                BankAcct.clcommon__Contact__c = contact.id; 
                  insert BankAcct;
                  List<clcommon__Bank_Account__c> lstbnk = [SELECT Id,Name FROM clcommon__Bank_Account__c WHERE clcommon__Account__c =: a.Id]; 
                   system.debug('lstbnk  : ' + lstbnk.size());
               lstcomm[0].Dealer_Charges__c = 5;
               update lstcomm[0]; 
                         
                
                    testPayable2.FundAll();
             }
             catch (exception ex)
             {
                 system.debug('ex3 dealer: ' + ex);
             }
             
       //  test.stoptest();
         
  
    }
}