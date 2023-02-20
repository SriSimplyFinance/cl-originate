@isTest  
   global class SAF_CA_Updatebill_Test
{

    public static testMethod void UpdatebillTest()
   { 
       clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        INSERT legal;
        
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.zoho_AccessEndpoint__c='dummy url';
        objSettings.zoho_CretaOppEndpoint__c='dummy_access_url';
        upsert objSettings;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        INSERT acc;
        
        List<String> names = new List<String> {'Finance Lease'};
        //List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = 'Finance Lease';
        //pr1.RecordTypeId = 'LEASE';
        INSERT pr1;
            
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];
        cllease.TestHelper.createSeedDataForTesting();
        // Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
         cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office1', true);
        //cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;
              
        UPDATE dummyLP;
        //Create Application
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 1200;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
        genApp.genesis__Account__c = acc.Id;
        //genApp.Security_Deposit__c = 100;
        INSERT genApp;
        //Create UnderWritting
        Underwriting__c under = new Underwriting__c();
        under.genesis_Application__c = genApp.Id;
        under.genesis_Decision__c = 'ACCEPTED';
        under.genesis_Trade_value__c = 200;
        under.Asset_quality__c = 'B';
        under.genesis_Customer_quality__c = 'c';
        under.UREL__c = 780;
        INSERT under;
        
        cllease__Payment_Mode__c paymentmode =new Cllease__payment_Mode__c();
        paymentmode.Name='Check';
        INSERT  paymentmode;
            
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = acc.ID;
        leaseAccount.Application__c                  = genApp.Id;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2017, 02, 01);
        leaseAccount.cllease__Term__c                = 12.0;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2017, 03, 01);
        leaseAccount.cllease__Product_Sub_Type__c    = 'FINANCE LEASE';
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2017, 02, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 1100.0;
        leaseAccount.cllease__Due_Day__c             = 1.0;
        leaseAccount.cllease__Lease_Status__c= 'ACTIVE - BAD STANDING';
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.Rental_Payment_Method__c=paymentmode.Id;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        INSERT leaseAccount;  
       
        cllease__Lease_account_Due_Details__c newDueData =new cllease__Lease_account_Due_Details__c();
        newDueData.Monthly_Income__c=10987;
        newDueData.cllease__Due_Date__c=Date.newInstance(2018, 07, 11);
        newDueData.cllease__Transaction_Date__c=Date.newInstance(2018, 12, 31);
        newDueData.cllease__Account__c=acc.Id;
        newDueData.cllease__Status__c='Tax Calculated';
        newDueData.cllease__Due_Type_Description__c= 'BILL / DUE DATE';
        newDueData.cllease__Lease_Account__c=leaseAccount.Id;
        newDueData.Income_Received__c = 456.45;
        newDueData.Income_VAT_Received__c= 345.56;
        INSERT newDueData;
       
        cllease__Rental_Stream__c rentalStream =new cllease__Rental_Stream__c();
        rentalstream.cllease__Date__c=Date.newInstance(2018, 07, 11);
        rentalstream.cllease__Contract__c=leaseAccount.Id;
        rentalStream.cllease__Monthly_Income__c=10589;
        INSERT rentalstream;    
            
        
        
       clcommon__Fee_Definition__c definition =new clcommon__Fee_Definition__c();
       definition.clcommon__Amount__c=0.0;
       definition.Name='Interim Rent';
       definition.clcommon__Active__c=true;
       definition.clcommon__Apply_Pre_Bill_Days__c ='No';
       definition.clcommon__Calculation_Method__c ='Fixed';
       definition.clcommon__Capitalize__c =false;
       definition.clcommon__Class__c='Income';          
       INSERT definition;
               
     /*   cllease__Charge__c charge =new cllease__Charge__c();
        charge.cllease__Lease_Account__c=leaseAccount.Id;
        charge.cllease__Date__c=Date.newInstance(2017, 03, 01);
        charge.cllease__Fee_Definition__c=definition.Id;
        INSERT charge;*/
       
       
               
        cllease__Lease_Payment_Transaction__c paymentTransactions =new cllease__Lease_Payment_Transaction__c();
        paymentTransactions.cllease__Account__c=acc.Id;
        paymentTransactions.cllease__Contract__c=leaseAccount.Id;
        paymentTransactions.cllease__Bill__c=newDueData.Id;
        paymentTransactions.cllease__Reversed__c=true;
        paymentTransactions.cllease__Cleared__c=true;
      //  paymentTransactions.Saf_Payment_Method__c='Check';
        paymentTransactions.cllease__Receipt_Date__c = Date.newInstance(2017, 03, 08);
        paymentTransactions.cllease__Transaction_Amount__c = 300;
        paymentTransactions.cllease__Transaction_Date__c = Date.newInstance(2017, 03, 08);       
       INSERT paymentTransactions;
       /*paymentTransactions.cllease__Reversed__c=false;
       paymentTransactions.cllease__Transaction_Amount__c = 400;
       Update paymentTransactions;*/
       cllease__bill_payment__c payment = new cllease__bill_payment__c();
       payment.Amount_Towards_Capital__c = 435.35;
       payment.Amount_Towards_Capital_VAT__c= 766.00;
       payment.Amount_Towards_Income__c = 876.00;
       payment.Amount_Towards_Income_VAT__c  = 99.98;
       payment.cllease__Payment_Amount__c = 100.47;
       payment.cllease__Bill__c=newDueData.Id;
       payment.cllease__Payment_Transaction__c=paymentTransactions.id;       
       INSERT payment;
       
       
     /*  paymentTransactions1.cllease__Account__c= acc.Id;
       paymentTransactions1.Income_Received__c = 456.45;
       paymentTransactions1.Income_VAT_Received__c= 345.56;
      
       
      cllease__Lease_Payment_Transaction__c paymentTransactions1 =new cllease__Lease_Payment_Transaction__c();
        paymentTransactions1.cllease__Account__c=acc.Id;
        paymentTransactions1.cllease__Contract__c=leaseAccount.Id;
        paymentTransactions1.cllease__Bill__c=newDueData.Id;
        paymentTransactions1.cllease__Reversed__c=false;
        //paymentTransactions.cllease__Charge__c=charge.Id;
        paymentTransactions1.Saf_Payment_Method__c='Check';
        paymentTransactions1.cllease__Receipt_Date__c = Date.newInstance(2017, 04, 07);
        paymentTransactions1.cllease__Transaction_Amount__c = 158;
        paymentTransactions1.cllease__Transaction_Date__c = Date.newInstance(2017, 04, 12);       
       INSERT paymentTransactions1;
       
       cllease__bill_payment__c payment1 = new cllease__bill_payment__c ();
       payment1.Amount_Towards_Capital__c = 200.35;
       payment1.Amount_Towards_Capital_VAT__c=135.00;
       payment1.Amount_Towards_Income__c = 400.00;
       payment1.Amount_Towards_Income_VAT__c  = 500.00;  
       payment1.cllease__Payment_Amount__c = 235.45;
       payment1.cllease__Payment_Transaction__c = paymentTransactions1.id ;
       Insert payment1;  
       
       cllease__Lease_Payment_Transaction__c paymentTransactions2 = new cllease__Lease_Payment_Transaction__c();
       paymentTransactions2.SAF_Total_Amount_Towards_Capital__c = 219.154;
       paymentTransactions2.SAF_Total_Amount_Towards_Capital_VAT__c= 3.200;
       paymentTransactions2.SAF_Total_Amount_Towards_Income__c = 154.309;
       paymentTransactions2.SAF_Total_Amount_Towards_Income_VAT__c = 45.200;
       paymentTransactions2.cllease__Reversed__c = True;
       paymentTransactions2.Saf_Payment_Method__c = 'Check';
       paymentTransactions2.cllease__Receipt_Date__c = Date.newInstance(2019, 05, 12);
       paymentTransactions2.cllease__Transaction_Date__c = Date.newInstance(2020, 08, 12);
       paymentTransactions2.cllease__Transaction_Amount__c = 250.00;
       Insert paymentTransactions2;
        
       cllease__bill_payment__c payment2 = new cllease__bill_payment__c();
       payment2.Amount_Towards_Capital__c = 435.35;
       payment2.Amount_Towards_Capital_VAT__c= 766.00;
       payment2.Amount_Towards_Income__c = 876.00;
       payment2.Amount_Towards_Income_VAT__c  = 99.98;
       payment2.cllease__Payment_Amount__c = 100.47;
       payment2.cllease__Payment_Transaction__c = paymentTransactions2.id ;
       Insert payment2;*/
       cllease__other_Transaction__c othertrans =new cllease__other_Transaction__c();
        othertrans.cllease__Lease_Account__c=leaseAccount.id;
        othertrans.cllease__Transaction_Type__c='TERMINATION';
        othertrans.cllease__Unearned_Lease_Income_Amount__c=56421;  
        othertrans.cllease__Txn_Date__c=Date.newInstance(2018, 12, 31);
        Insert othertrans;
        
       List<id> BpIds = new List<id>();      
       BpIds.add(payment.id);     
      
       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new Test_SAFDocumentUploadToSharePoint.SharePointmock ());
       SAF_CA_Updatebill.updateBill(BpIds);
       Test.stopTest();
       }
}