@isTest
public class PayablesControllerTest {
    

    static testmethod void Test(){
        SAF_BrokerApp__c settings = SAF_BrokerApp__c.getOrgDefaults();
        settings.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
        settings.LoginURL__c = 'http://51.132.26.170:9091/api/login';
        settings.UserName__c = 'andrew.trimmer@simply.finance';
        settings.Password__c = 'Test@1234';
        upsert settings;
        
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
            objSetting.client_id__c = 'Dummy client Id'; 
            objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        	objSetting.zoho_CretaOppEndpoint__c = 'dummy_Oppy_Endpoint';
            UPSERT objSetting;
            
          
            Saf_CompanyHouse__c objSet =  Saf_CompanyHouse__c.getOrgDefaults();
            objSet.AccessToken__c ='123';
            objSet.Username__c = 'Phalguni@hm.com';
            objSet.Password__c = 'phalguni@123';
            objSet.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSet.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSet.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSet.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            upsert objSet;
        
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
        
        clcommon__Bank_Account__c bank = new clcommon__Bank_Account__c();
        bank.Account_Number__c = '12345';
        bank.clcommon__Bank_Account_Name__c = 'Royal bank of scotland';
        bank.clcommon__Routing_Number__c = '026009140';
        bank.clcommon__Bank_Name__c = 'RBS';
        bank.clcommon__Active__c = True;
        bank.clcommon__Account__c = acc.Id;
        insert bank;
        
       genesis__Applications__c app = new genesis__Applications__c();
       app.genesis__Account__c = acc.Id;
       app.genesis__Expected_Start_Date__c = Date.Today();
       app.genesis__Sales_Division__c = 'DIRECT';
       app.genesis__Payment_Frequency__c = 'MONTHLY';
       app.genesis__Financed_Amount__c = 123;
       app.genesis__Status__c ='PROPOSAL';
       app.genesis__Term__c =12;
       app.genesis__Financed_Amount__c = 460000;
       app.Bank_Account_Application__c = bank.Id;
       insert app;
        
       genesis__Fee_Schedule__c fee = new genesis__Fee_Schedule__c();
       fee.genesis__Application__c = app.Id;
       fee.genesis__Amount__c = 500;
       fee.genesis__Fee_Definition__c = 'a4p0O000000cFBlQAM';
       insert fee;
        
        
        
        clcommon__Party__c supplier = new clcommon__Party__c();
        //supplier.RecordTypeId = 'a4y0O000000g0Z8QAI';
        supplier.genesis__Application__c = app.Id;
        supplier.clcommon__Account__c = acc.Id;
        insert supplier;
        Date lastDay = Date.newInstance(2022, 6, 5);
        Invoice__c invoice = new Invoice__c();
        invoice.Application__c = app.Id;
        invoice.Deposit_Paid_To_Supplier__c = 20000;
        invoice.Deposit_Validation_Check__c = True;
        invoice.Generate_Auto_Payables__c = True;
        invoice.HSBC_Created__c = True;
        invoice.Payable_Amount_For_Auto_Generation__c = 10000;
        invoice.Supplier1__c = supplier.Id;
        invoice.Invoice_Due_Date__c = lastDay;
        invoice.Invoice_Number__c = '112233';
        insert invoice;
        
        Invoice__c invoicelist=[SELECT Total_Asset_Cost__c,Payable_Amount__c,VAT_Amount__c,Id,Name,Application__r.Name,Application__c,Supplier1__c,Supplier1__r.clcommon__Account__c,Deposit_Paid_To_Supplier__c,Invoice_Number__c,Invoice_Due_Date__c,Contract_Party__c,Payment_Mode__c,(Select Id,Name,Amount__c, Payment_Mode1__r.Payment_Mode_CL_Lease__c,Payment_Mode1__c,Supplier__c,Supplier__r.clcommon__Account__c,Reference__c from Application_Payables__r) from Invoice__c where Application__c=: app.Id];
        System.debug('Invoice__c:'+invoicelist);
        
       
        
        clcommon__VAT_Rate_Setup__c vat = new clcommon__VAT_Rate_Setup__c ();
        vat.Name = '14.0 Percent';
        vat.clcommon__Tax_Rate__c = 0.2;
        vat.Tax_Code__c = '012345';
        vat.clcommon__Active__c = true;
        vat.cllease__No_of_VAT_Rates__c = 1;        
        insert vat;        

        
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office1', true);
        dummyOffice.cllease__Current_System_Date__c = Date.newInstance(2018, 12, 12);
        dummyOffice.cllease__VAT_Code__c = vat.ID;
        update dummyOffice;
        
         clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        dummyFee.clcommon__Class__c='Expense';
        update dummyFee;
        
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        
        cllease__Payment_Spread__c paySpr = new cllease__Payment_Spread__c();
        paySpr.cllease__Enabled__c = true;
        paySpr.cllease__Spread_Description__c = 'test';
        paySpr.cllease__Tax_Configuration__c = 'RECEIVABLE FIRST';
        insert paySpr;
        
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;       
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP;  
        
        Contact dummyClient = new Contact(lastname='dummyClient',accountid=acc.id);
        
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = acc.ID;
        leaseAccount.Application__c                  = app.Id;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.Id; //'a6N0O0000005JXyUAM';//ofcName.ID;
        leaseAccount.cllease__Payment_Spread__c      = paySpr.id;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        leaseAccount.cllease__Lease_Status__c = 'PARTIAL APPLICATION';
        leaseAccount.cllease__Maturity_Date__c = Date.newInstance(2017, 01, 01);
        insert leaseAccount;
        
        
        cllease__Contract_Fees__c contractFees = new cllease__Contract_Fees__c();
        contractFees.Pay_To_Account_Id__c= acc.id;
        contractFees.cllease__Amount__c=300;
        contractFees.cllease__Contract__c=leaseAccount.Id;
        contractFees.cllease__Fee_Definition__c=dummyFee.Id;
        contractFees.cllease__start_date__c= Date.newInstance(2020, 01, 01);
        insert contractFees;
        
        cllease__Contract_Parties__c party2 = new cllease__Contract_Parties__c();
        party2.cllease__Contract__c = leaseAccount.Id;
        party2.cllease__Party_Type__c = 'DEALER';
        party2.cllease__Party_Account_Name__c = acc.id;
        insert party2;
        
        
        Application_Payables__c appPayable= new Application_Payables__c();
        appPayable.Amount__c = 300;
        appPayable.Supplier__c=supplier.Id;
        appPayable.Invoice__c=invoice.Id;
        insert appPayable;
        
       
    
        test.startTest();
         Test.setMock(HttpCalloutMock.class, new SAF_ExperianCreditSearchServiceMockTest());   
        PageReference pageRef = Page.Payables;
        Test.setCurrentPage(pageRef);
        system.debug('in first test');
        ApexPages.currentPage().getParameters().put('id',leaseAccount.Id);
        PayablesController controller= new PayablesController();
        PayablesController.UpdateDealerFundingParty(leaseAccount.Id, app.Id);
        controller.DFRecords = controller.GetDealerFundingDet();
        
        controller.getCommissions();
        controller.FundAll();
        controller.FundAllCom();
        controller.FundPart();
        controller.CommissionProcess();
        controller.redirect();
        controller.redirectComm();
        controller.getSelectedComm();
        controller.getSelected();
        controller.Cancel();
       
        test.stopTest();
    }
    static testmethod void test2(){
        SAF_BrokerApp__c settings1 = SAF_BrokerApp__c.getOrgDefaults();
        settings1.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
        settings1.LoginURL__c = 'http://51.132.26.170:9091/api/login';
        settings1.UserName__c = 'andrew.trimmer@simply.finance';
        settings1.Password__c = 'Test@1234';
        upsert settings1;
        
        saf_zoho__c objSetting1 = saf_zoho__c.getOrgDefaults();
            objSetting1.client_id__c = 'Dummy client Id'; 
            objSetting1.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        	objSetting1.zoho_CretaOppEndpoint__c = 'dummy_Oppy_Endpoint';
            UPSERT objSetting1;
            
          
            Saf_CompanyHouse__c objSet1 =  Saf_CompanyHouse__c.getOrgDefaults();
            objSet1.AccessToken__c ='123';
            objSet1.Username__c = 'Phalguni@hm.com';
            objSet1.Password__c = 'phalguni@123';
            objSet1.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSet1.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSet1.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSet1.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            upsert objSet1;
        
            Saf_ZohoFieldMapping__c zohomapping1 =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
            zohomapping1.Salesforce_Field__c='rrrrr';
            zohomapping1.Zoho_Fields__c='sss';
            zohomapping1.Name='duplicateName';
            UPSERT zohomapping1; 

        clcommon__Legal_Entity__c legal1 = new clcommon__Legal_Entity__c(name='Limited Liability Company');
         insert legal1;
        Account acc1 = new Account();
        acc1.clcommon__Legal_Entity_Type__c = legal1.id;
        acc1.Name = 'TestAccount';
        acc1.BillingPostalCode = 'BD1 1HA';
        acc1.BillingCity = 'London';
        acc1.ShippingPostalCode = 'BD1 1HA';
        acc1.ShippingCity = 'London';
        acc1.Landline__c='12345 123456';
        acc1.KYCDB_Unique_Key_Account__c='COMP-0000015194';
        acc1.AccountNumber='06625914';
        acc1.Sic ='0000';
        acc1.Type = 'Account';
        acc1.UK_Region__c ='0000';
        acc1.Phone='9898787656';
        acc1.clcommon__Email__c ='test@example.com';
        acc1.Ownership='Private Limited Company';
        acc1.BillingStreet ='test Street';
        acc1.BillingState ='UK';
        acc1.BillingCountry = 'UK';
        acc1.ShippingStreet ='test Street';
        acc1.ShippingCountry='UK';
        acc1.ShippingState ='UK';
        acc1.Zoho_Customer_Id__c = '10777000005023458';
        insert acc1;
        
        clcommon__Bank_Account__c bank1 = new clcommon__Bank_Account__c();
        bank1.Account_Number__c = '12345';
        bank1.clcommon__Bank_Account_Name__c = 'Royal bank of scotland';
        bank1.clcommon__Routing_Number__c = '026009140';
        bank1.clcommon__Bank_Name__c = 'RBS';
        bank1.clcommon__Active__c = True;
        bank1.clcommon__Account__c = acc1.Id;
        insert bank1;
        
       genesis__Applications__c app1 = new genesis__Applications__c();
       app1.genesis__Account__c = acc1.Id;
       app1.genesis__Expected_Start_Date__c = Date.Today();
       app1.genesis__Sales_Division__c = 'DIRECT';
       app1.genesis__Payment_Frequency__c = 'MONTHLY';
       app1.genesis__Financed_Amount__c = 123;
       app1.genesis__Status__c ='PROPOSAL';
       app1.genesis__Term__c =12;
       app1.genesis__Financed_Amount__c = 460000;
       app1.Bank_Account_Application__c = bank1.Id;
       insert app1;
        
       genesis__Fee_Schedule__c fee1 = new genesis__Fee_Schedule__c();
       fee1.genesis__Application__c = app1.Id;
       fee1.genesis__Amount__c = 500;
       fee1.genesis__Fee_Definition__c = 'a4p0O000000cFBlQAM';
       insert fee1;
        
        
        
        clcommon__Party__c supplier1 = new clcommon__Party__c();
        //supplier.RecordTypeId = 'a4y0O000000g0Z8QAI';
        supplier1.genesis__Application__c = app1.Id;
        supplier1.clcommon__Account__c = acc1.Id;
        insert supplier1;
        Date lastDay = Date.newInstance(2022, 6, 5);
        Invoice__c invoice1 = new Invoice__c();
        invoice1.Application__c = app1.Id;
        invoice1.Deposit_Paid_To_Supplier__c = 20000;
        invoice1.Deposit_Validation_Check__c = True;
        invoice1.Generate_Auto_Payables__c = True;
        invoice1.HSBC_Created__c = True;
        invoice1.Payable_Amount_For_Auto_Generation__c = 10000;
        invoice1.Supplier1__c = supplier1.Id;
        invoice1.Invoice_Due_Date__c = lastDay;
        invoice1.Invoice_Number__c = '112233';
        insert invoice1;
        
        Invoice__c invoicelist=[SELECT Total_Asset_Cost__c,Payable_Amount__c,VAT_Amount__c,Id,Name,Application__r.Name,Application__c,Supplier1__c,Supplier1__r.clcommon__Account__c,Deposit_Paid_To_Supplier__c,Invoice_Number__c,Invoice_Due_Date__c,Contract_Party__c,Payment_Mode__c,(Select Id,Name,Amount__c, Payment_Mode1__r.Payment_Mode_CL_Lease__c,Payment_Mode1__c,Supplier__c,Supplier__r.clcommon__Account__c,Reference__c from Application_Payables__r) from Invoice__c where Application__c=: app1.Id];
        System.debug('Invoice__c:'+invoicelist);
       
        
        clcommon__VAT_Rate_Setup__c vat1 = new clcommon__VAT_Rate_Setup__c ();
        vat1.Name = '14.0 Percent';
        vat1.clcommon__Tax_Rate__c = 0.2;
        vat1.Tax_Code__c = '012345';
        vat1.clcommon__Active__c = true;
        vat1.cllease__No_of_VAT_Rates__c = 1;        
        insert vat1;        

        
        cllease__Office_Name__c dummyOffice1 = cllease.TestHelper.createOffice('Test Office1', true);
        dummyOffice1.cllease__Current_System_Date__c = Date.newInstance(2018, 12, 12);
        dummyOffice1.cllease__VAT_Code__c = vat1.ID;
        update dummyOffice1;
        
         clcommon__Fee_Definition__c dummyFee1 = cllease.TestHelper.createLeaseFee();
        dummyFee1.clcommon__Class__c='Expense';
        update dummyFee1;
        
        clcommon__Fee_Set__c dummyFeeSet1 = cllease.TestHelper.createLeaseFeeSet();
        
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee1.id, dummyFeeSet1.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        
        cllease__Payment_Spread__c paySpr1 = new cllease__Payment_Spread__c();
        paySpr1.cllease__Enabled__c = true;
        paySpr1.cllease__Spread_Description__c = 'test';
        paySpr1.cllease__Tax_Configuration__c = 'RECEIVABLE FIRST';
        insert paySpr1;
        
        cllease__Lease_Product__c dummyLP1 = cllease.TestHelper.createLeaseProduct(dummyOffice1,dummyFeeSet1);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP1);
        dummyLP1.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP1.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP1.cllease__Dep_over_asset_life__c = true;
        dummyLP1.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP1.cllease__idc_Accrual_Flag__c = true;       
        dummyLP1.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP1.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP1;  
        
        Contact dummyClient = new Contact(lastname='dummyClient',accountid=acc1.id);
        
        cllease__Lease_Account__c leaseAccount2       = new cllease__Lease_Account__c();
        leaseAccount2.cllease__Account__c             = acc1.ID;
        leaseAccount2.Application__c                  = app1.Id;
        leaseAccount2.cllease__Fee_Set1__c             = dummyFeeSet1.ID;
        leaseAccount2.cllease__Lease_Product_Name__c  = dummyLP1.ID;
        leaseAccount2.cllease__Branch__c              = dummyOffice1.Id; //'a6N0O0000005JXyUAM';//ofcName.ID;
        leaseAccount2.cllease__Payment_Spread__c      = paySpr1.id;
        leaseAccount2.cllease__Product_Type__c        = 'LEASE';
        leaseAccount2.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount2.cllease__Term__c                = 12;
        leaseAccount2.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount2.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount2.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount2.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount2.cllease__Financed_Amount__c     = 10000;
        leaseAccount2.cllease__Due_Day__c             = 1;
        leaseAccount2.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount2.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount2.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        leaseAccount2.cllease__Lease_Status__c = 'PARTIAL APPLICATION';
        leaseAccount2.cllease__Maturity_Date__c = Date.newInstance(2017, 01, 01);
        insert leaseAccount2;
        
        cllease__Contract_Fees__c contractFees = new cllease__Contract_Fees__c();
        contractFees.Pay_To_Account_Id__c= acc1.id;
        contractFees.cllease__Amount__c=300;
        contractFees.cllease__Contract__c=leaseAccount2.Id;
        contractFees.cllease__Fee_Definition__c=dummyFee1.Id;
        contractFees.cllease__start_date__c= Date.newInstance(2020, 01, 01);
        insert contractFees;
        
        cllease__Contract_Parties__c party = new cllease__Contract_Parties__c();
        party.cllease__Contract__c = leaseAccount2.Id;
        party.cllease__Party_Type__c = 'BROKER';
        party.cllease__Party_Account_Name__c = acc1.id;
        insert party;
        
         User userRec = [Select Id,Name,Email, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE Email=:'andrew.trimmer@simply.finance' ];
       
        Saf_CommissionFunding__c comFunding = new Saf_CommissionFunding__c();
        System.runAs(userRec){
            
        comFunding.saf_Amount__c=30;
        comFunding.saf_contractParty__c=party.id;
        comFunding.Payment_Mode__c='a6S0O000001UsEZUA0';
        comFunding.saf_Selected__c=true;
        comFunding.saf_Fee_Funded__c=false;    
        comFunding.LS_Contract__c=leaseAccount2.id;
        insert comFunding;
            
        }
        
       
   
        test.startTest();
         Test.setMock(HttpCalloutMock.class, new SAF_ExperianCreditSearchServiceMockTest()); 
        
         PageReference pageRef = Page.Payables;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id',leaseAccount2.Id);
        PayablesController controller= new PayablesController();
        
        system.debug('inside second test');

        PayablesController.UpdateDealerFundingParty(leaseAccount2.Id, app1.Id);
        controller.CommissionProcess();
             
        test.stopTest();
        
    }

    static testmethod void test3(){
        SAF_BrokerApp__c settings1 = SAF_BrokerApp__c.getOrgDefaults();
        settings1.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
        settings1.LoginURL__c = 'http://51.132.26.170:9091/api/login';
        settings1.UserName__c = 'andrew.trimmer@simply.finance';
        settings1.Password__c = 'Test@1234';
        upsert settings1;
        
        saf_zoho__c objSetting1 = saf_zoho__c.getOrgDefaults();
            objSetting1.client_id__c = 'Dummy client Id'; 
            objSetting1.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        	objSetting1.zoho_CretaOppEndpoint__c = 'dummy_Oppy_Endpoint';
            UPSERT objSetting1;
            
          
            Saf_CompanyHouse__c objSet1 =  Saf_CompanyHouse__c.getOrgDefaults();
            objSet1.AccessToken__c ='123';
            objSet1.Username__c = 'Phalguni@hm.com';
            objSet1.Password__c = 'phalguni@123';
            objSet1.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSet1.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSet1.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSet1.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            upsert objSet1;
        
            Saf_ZohoFieldMapping__c zohomapping1 =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
            zohomapping1.Salesforce_Field__c='rrrrr';
            zohomapping1.Zoho_Fields__c='sss';
            zohomapping1.Name='duplicateName';
            UPSERT zohomapping1; 

        clcommon__Legal_Entity__c legal1 = new clcommon__Legal_Entity__c(name='Limited Liability Company');
         insert legal1;
        Account acc1 = new Account();
        acc1.clcommon__Legal_Entity_Type__c = legal1.id;
        acc1.Name = 'TestAccount';
        acc1.BillingPostalCode = 'BD1 1HA';
        acc1.BillingCity = 'London';
        acc1.ShippingPostalCode = 'BD1 1HA';
        acc1.ShippingCity = 'London';
        acc1.Landline__c='12345 123456';
        acc1.KYCDB_Unique_Key_Account__c='COMP-0000015194';
        acc1.AccountNumber='06625914';
        acc1.Sic ='0000';
        acc1.Type = 'Account';
        acc1.UK_Region__c ='0000';
        acc1.Phone='9898787656';
        acc1.clcommon__Email__c ='test@example.com';
        acc1.Ownership='Private Limited Company';
        acc1.BillingStreet ='test Street';
        acc1.BillingState ='UK';
        acc1.BillingCountry = 'UK';
        acc1.ShippingStreet ='test Street';
        acc1.ShippingCountry='UK';
        acc1.ShippingState ='UK';
        acc1.Zoho_Customer_Id__c = '10777000005023458';
        insert acc1;
        
        clcommon__Bank_Account__c bank1 = new clcommon__Bank_Account__c();
        bank1.Account_Number__c = '12345';
        bank1.clcommon__Bank_Account_Name__c = 'Royal bank of scotland';
        bank1.clcommon__Routing_Number__c = '026009140';
        bank1.clcommon__Bank_Name__c = 'RBS';
        bank1.clcommon__Active__c = True;
        bank1.clcommon__Account__c = acc1.Id;
        insert bank1;
        
       genesis__Applications__c app1 = new genesis__Applications__c();
       app1.genesis__Account__c = acc1.Id;
       app1.genesis__Expected_Start_Date__c = Date.Today();
       app1.genesis__Sales_Division__c = 'DIRECT';
       app1.genesis__Payment_Frequency__c = 'MONTHLY';
       app1.genesis__Financed_Amount__c = 123;
       app1.genesis__Status__c ='PROPOSAL';
       app1.genesis__Term__c =12;
       app1.genesis__Financed_Amount__c = 460000;
       app1.Bank_Account_Application__c = bank1.Id;
       insert app1;
        
       genesis__Fee_Schedule__c fee1 = new genesis__Fee_Schedule__c();
       fee1.genesis__Application__c = app1.Id;
       fee1.genesis__Amount__c = 500;
       fee1.genesis__Fee_Definition__c = 'a4p0O000000cFBlQAM';
       insert fee1;
        
        
        
        clcommon__Party__c supplier1 = new clcommon__Party__c();
        //supplier.RecordTypeId = 'a4y0O000000g0Z8QAI';
        supplier1.genesis__Application__c = app1.Id;
        supplier1.clcommon__Account__c = acc1.Id;
        insert supplier1;
        Date lastDay = Date.newInstance(2022, 6, 5);
        Invoice__c invoice1 = new Invoice__c();
        invoice1.Application__c = app1.Id;
        invoice1.Deposit_Paid_To_Supplier__c = 20000;
        invoice1.Deposit_Validation_Check__c = True;
        invoice1.Generate_Auto_Payables__c = True;
        invoice1.HSBC_Created__c = True;
        invoice1.Payable_Amount_For_Auto_Generation__c = 10000;
        invoice1.Supplier1__c = supplier1.Id;
        invoice1.Invoice_Due_Date__c = lastDay;
        invoice1.Invoice_Number__c = '112233';
        insert invoice1;
        
        Invoice__c invoicelist=[SELECT Total_Asset_Cost__c,Payable_Amount__c,VAT_Amount__c,Id,Name,Application__r.Name,Application__c,Supplier1__c,Supplier1__r.clcommon__Account__c,Deposit_Paid_To_Supplier__c,Invoice_Number__c,Invoice_Due_Date__c,Contract_Party__c,Payment_Mode__c,(Select Id,Name,Amount__c, Payment_Mode1__r.Payment_Mode_CL_Lease__c,Payment_Mode1__c,Supplier__c,Supplier__r.clcommon__Account__c,Reference__c from Application_Payables__r) from Invoice__c where Application__c=: app1.Id];
        System.debug('Invoice__c:'+invoicelist);
       
        
        clcommon__VAT_Rate_Setup__c vat1 = new clcommon__VAT_Rate_Setup__c ();
        vat1.Name = '14.0 Percent';
        vat1.clcommon__Tax_Rate__c = 0.2;
        vat1.Tax_Code__c = '012345';
        vat1.clcommon__Active__c = true;
        vat1.cllease__No_of_VAT_Rates__c = 1;        
        insert vat1;        

        
        cllease__Office_Name__c dummyOffice1 = cllease.TestHelper.createOffice('Test Office1', true);
        dummyOffice1.cllease__Current_System_Date__c = Date.newInstance(2018, 12, 12);
        dummyOffice1.cllease__VAT_Code__c = vat1.ID;
        update dummyOffice1;
        
         clcommon__Fee_Definition__c dummyFee1 = cllease.TestHelper.createLeaseFee();
        dummyFee1.clcommon__Class__c='Expense';
        update dummyFee1;
        
        clcommon__Fee_Set__c dummyFeeSet1 = cllease.TestHelper.createLeaseFeeSet();
        
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee1.id, dummyFeeSet1.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        
        cllease__Payment_Spread__c paySpr1 = new cllease__Payment_Spread__c();
        paySpr1.cllease__Enabled__c = true;
        paySpr1.cllease__Spread_Description__c = 'test';
        paySpr1.cllease__Tax_Configuration__c = 'RECEIVABLE FIRST';
        insert paySpr1;
        
        cllease__Lease_Product__c dummyLP1 = cllease.TestHelper.createLeaseProduct(dummyOffice1,dummyFeeSet1);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP1);
        dummyLP1.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP1.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP1.cllease__Dep_over_asset_life__c = true;
        dummyLP1.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP1.cllease__idc_Accrual_Flag__c = true;       
        dummyLP1.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP1.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP1;  
        
        Contact dummyClient = new Contact(lastname='dummyClient',accountid=acc1.id);
        
        cllease__Lease_Account__c leaseAccount2       = new cllease__Lease_Account__c();
        leaseAccount2.cllease__Account__c             = acc1.ID;
        leaseAccount2.Application__c                  = app1.Id;
        leaseAccount2.cllease__Fee_Set1__c             = dummyFeeSet1.ID;
        leaseAccount2.cllease__Lease_Product_Name__c  = dummyLP1.ID;
        leaseAccount2.cllease__Branch__c              = dummyOffice1.Id; //'a6N0O0000005JXyUAM';//ofcName.ID;
        leaseAccount2.cllease__Payment_Spread__c      = paySpr1.id;
        leaseAccount2.cllease__Product_Type__c        = 'LEASE';
        leaseAccount2.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount2.cllease__Term__c                = 12;
        leaseAccount2.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount2.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount2.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount2.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount2.cllease__Financed_Amount__c     = 10000;
        leaseAccount2.cllease__Due_Day__c             = 1;
        leaseAccount2.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount2.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount2.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        leaseAccount2.cllease__Lease_Status__c = 'PARTIAL APPLICATION';
        leaseAccount2.cllease__Maturity_Date__c = Date.newInstance(2017, 01, 01);
        insert leaseAccount2;
        
        cllease__Contract_Fees__c contractFees = new cllease__Contract_Fees__c();
        contractFees.Pay_To_Account_Id__c= acc1.id;
        contractFees.cllease__Amount__c=300;
        contractFees.cllease__Contract__c=leaseAccount2.Id;
        contractFees.cllease__Fee_Definition__c=dummyFee1.Id;
        contractFees.cllease__start_date__c= Date.newInstance(2020, 01, 01);
        insert contractFees;
        
        cllease__Contract_Parties__c party = new cllease__Contract_Parties__c();
        party.cllease__Contract__c = leaseAccount2.Id;
        party.cllease__Party_Type__c = 'BROKER';
        party.cllease__Party_Account_Name__c = acc1.id;
        insert party;
        
        
        test.startTest();
         Test.setMock(HttpCalloutMock.class, new SAF_ExperianCreditSearchServiceMockTest()); 
        
        system.debug('inside second test');

        PayablesController.UpdateDealerFundingParty(leaseAccount2.Id, app1.Id);
       
             
        test.stopTest();
        
    }
    static testmethod void Test4(){
        SAF_BrokerApp__c settings = SAF_BrokerApp__c.getOrgDefaults();
        settings.EndPointURL__c = 'https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM';
        settings.LoginURL__c = 'http://51.132.26.170:9091/api/login';
        settings.UserName__c = 'andrew.trimmer@simply.finance';
        settings.Password__c = 'Test@1234';
        upsert settings;
        
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
            objSetting.client_id__c = 'Dummy client Id'; 
            objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        	objSetting.zoho_CretaOppEndpoint__c = 'dummy_Oppy_Endpoint';
            UPSERT objSetting;
            
          
            Saf_CompanyHouse__c objSet =  Saf_CompanyHouse__c.getOrgDefaults();
            objSet.AccessToken__c ='123';
            objSet.Username__c = 'Phalguni@hm.com';
            objSet.Password__c = 'phalguni@123';
            objSet.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSet.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSet.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSet.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            upsert objSet;
        
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
        
        clcommon__Bank_Account__c bank = new clcommon__Bank_Account__c();
        bank.Account_Number__c = '12345';
        bank.clcommon__Bank_Account_Name__c = 'Royal bank of scotland';
        bank.clcommon__Routing_Number__c = '026009140';
        bank.clcommon__Bank_Name__c = 'RBS';
        bank.clcommon__Active__c = True;
        bank.clcommon__Account__c = acc.Id;
        insert bank;
        
       genesis__Applications__c app = new genesis__Applications__c();
       app.genesis__Account__c = acc.Id;
       app.genesis__Expected_Start_Date__c = Date.Today();
       app.genesis__Sales_Division__c = 'DIRECT';
       app.genesis__Payment_Frequency__c = 'MONTHLY';
       app.genesis__Financed_Amount__c = 123;
       app.genesis__Status__c ='PROPOSAL';
       app.genesis__Term__c =12;
       app.genesis__Financed_Amount__c = 460000;
       app.Bank_Account_Application__c = bank.Id;
       insert app;
        
       genesis__Fee_Schedule__c fee = new genesis__Fee_Schedule__c();
       fee.genesis__Application__c = app.Id;
       fee.genesis__Amount__c = 500;
       fee.genesis__Fee_Definition__c = 'a4p0O000000cFBlQAM';
       insert fee;
        
        
        
        clcommon__Party__c supplier = new clcommon__Party__c();
        //supplier.RecordTypeId = 'a4y0O000000g0Z8QAI';
        supplier.genesis__Application__c = app.Id;
        supplier.clcommon__Account__c = acc.Id;
        insert supplier;
        Date lastDay = Date.newInstance(2022, 6, 5);
        Invoice__c invoice = new Invoice__c();
        invoice.Application__c = app.Id;
        invoice.Deposit_Paid_To_Supplier__c = 20000;
        invoice.Deposit_Validation_Check__c = True;
        invoice.Generate_Auto_Payables__c = True;
        invoice.HSBC_Created__c = True;
        invoice.Payable_Amount_For_Auto_Generation__c = 10000;
        invoice.Supplier1__c = supplier.Id;
        invoice.Invoice_Due_Date__c = lastDay;
        invoice.Invoice_Number__c = '112233';
        insert invoice;
        
        Invoice__c invoicelist=[SELECT Total_Asset_Cost__c,Payable_Amount__c,VAT_Amount__c,Id,Name,Application__r.Name,Application__c,Supplier1__c,Supplier1__r.clcommon__Account__c,Deposit_Paid_To_Supplier__c,Invoice_Number__c,Invoice_Due_Date__c,Contract_Party__c,Payment_Mode__c,(Select Id,Name,Amount__c, Payment_Mode1__r.Payment_Mode_CL_Lease__c,Payment_Mode1__c,Supplier__c,Supplier__r.clcommon__Account__c,Reference__c from Application_Payables__r) from Invoice__c where Application__c=: app.Id];
        System.debug('Invoice__c:'+invoicelist);
        
       
        
        clcommon__VAT_Rate_Setup__c vat = new clcommon__VAT_Rate_Setup__c ();
        vat.Name = '14.0 Percent';
        vat.clcommon__Tax_Rate__c = 0.2;
        vat.Tax_Code__c = '012345';
        vat.clcommon__Active__c = true;
        vat.cllease__No_of_VAT_Rates__c = 1;        
        insert vat;        

        
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office1', true);
        dummyOffice.cllease__Current_System_Date__c = Date.newInstance(2018, 12, 12);
        dummyOffice.cllease__VAT_Code__c = vat.ID;
        update dummyOffice;
        
         clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        dummyFee.clcommon__Class__c='Expense';
        update dummyFee;
        
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        
        cllease__Payment_Spread__c paySpr = new cllease__Payment_Spread__c();
        paySpr.cllease__Enabled__c = true;
        paySpr.cllease__Spread_Description__c = 'test';
        paySpr.cllease__Tax_Configuration__c = 'RECEIVABLE FIRST';
        insert paySpr;
        
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;       
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
            cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP;  
        
        Contact dummyClient = new Contact(lastname='dummyClient',accountid=acc.id);
        
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = acc.ID;
        leaseAccount.Application__c                  = app.Id;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.Id; //'a6N0O0000005JXyUAM';//ofcName.ID;
        leaseAccount.cllease__Payment_Spread__c      = paySpr.id;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        leaseAccount.cllease__Lease_Status__c = 'PARTIAL APPLICATION';
        leaseAccount.cllease__Maturity_Date__c = Date.newInstance(2017, 01, 01);
        insert leaseAccount;
        
        
        cllease__Contract_Fees__c contractFees = new cllease__Contract_Fees__c();
        contractFees.Pay_To_Account_Id__c= acc.id;
        contractFees.cllease__Amount__c=300;
        contractFees.cllease__Contract__c=leaseAccount.Id;
        contractFees.cllease__Fee_Definition__c=dummyFee.Id;
        contractFees.cllease__start_date__c= Date.newInstance(2020, 01, 01);
        insert contractFees;
        
        cllease__Contract_Parties__c party2 = new cllease__Contract_Parties__c();
        party2.cllease__Contract__c = leaseAccount.Id;
        party2.cllease__Party_Type__c = 'DEALER';
        party2.cllease__Party_Account_Name__c = acc.id;
        insert party2;
        
        
        Application_Payables__c appPayable= new Application_Payables__c();
        appPayable.Amount__c = 300;
        appPayable.Supplier__c=supplier.Id;
        appPayable.Invoice__c=invoice.Id;
        insert appPayable;
        
        User userRec = [Select Id,Name,Email, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE Email=:'andrew.trimmer@simply.finance' ];
        Dealer_Funding__c dealer = new Dealer_Funding__c();
        Saf_CommissionFunding__c comFunding = new Saf_CommissionFunding__c();
        System.runAs(userRec){
            
        dealer.Account_Number__c = acc.id;
        dealer.Dealer__c = party2.id;
        dealer.Payment_Mode__c = 'a6S0O000001UsEZUA0';
        dealer.Contract__c = leaseAccount.Id;
        dealer.Dealer_Funded__c= false;
       
        insert dealer;
            
        }
        
       
    
        test.startTest();
         Test.setMock(HttpCalloutMock.class, new SAF_ExperianCreditSearchServiceMockTest());   
        PageReference pageRef = Page.Payables;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',leaseAccount.Id);
        PayablesController controller= new PayablesController();
        controller.DFRecords = controller.GetDealerFundingDet();
        controller.dealerFundingList = controller.getdealerFunding();
        controller.dealerFundingList[0].selected=true;
       
       
        controller.dealerFundingProcess();
     
        test.stopTest();
    }
}