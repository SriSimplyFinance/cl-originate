@isTest
private class SAF_GLAccountingEnteriesTest{
    public cllease__Lease_Account__c Contract{get;set;} 
    public Manual_GL__c ManualGL{get;set;} 
    public Manual_GL__c ManualGLAccount{get;set;} 
    static testMethod  void glacctest() {      
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;
         Saf_setting__c objSetting1 = Saf_setting__c.getOrgDefaults();
        objSetting1.GlSolution_QueryLimit__c = 2000; 
        objSetting1.GlSolution_PageSize__c = 10;
        objSetting1.DisableCustomerTriggers__c = true;
        objSetting1.DisableAgreementTriggers__c = true;
        UPSERT objSetting1;
        
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractTest.Saf_ZohoLScontractMock());       
        //Create a Fee Set
        //clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        //System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.AccountNumber='6549821699';
        lessee.Name = 'TestAccountBBB';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        
        Account lessee1 = new Account();
        lessee1.RecordtypeID=rec.id;
        lessee1.AccountNumber='111111';
        lessee1.Name = 'HMAccountTESTBBB12';
        lessee1.Phone = '98734 678988';
        lessee1.Landline__c= '98734 678988';
        lessee1.BillingPostalCode = 'DC1 1HA1';
        lessee1.BillingCity = 'London';
        lessee1.ShippingPostalCode = 'DC1 1HA1'; 
        lessee1.ShippingCity = 'London';
        insert lessee1;
        
    
        
        cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
          List<String> names = new List<String> {'Operating Lease'};
       // List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = ' Operating Lease ';
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
        // cllease.TestHelper.createOffice('Test Office', true);
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
        /*genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Expected_Start_Date__c = Date.Today();
        genApp.genesis__Financed_Amount__c = 12000;
        genApp.genesis__Product_Type__c = 'LEASE';
        genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
        genApp.genesis__CL_Product__c = product.Id;
        genApp.genesis__Loan_Amount__c = 6700;
        genApp.genesis__Fees_Amount__c =0;
        genApp.genesis__Term__c = 12;
        genApp.genesis__Payment_Frequency__c = 'MONTHLY';
        genApp.genesis__Interest_Rate__c = 10;
        genApp.genesis__Expected_Close_Date__c = date.newInstance(2019, 12, 12);
        genApp.genesis__Account__c = acc.Id;    
        INSERT genApp;
     
        Underwriting__c under = new Underwriting__c();
        under.genesis_Application__c = genApp.Id;
        under.genesis_Decision__c = 'ACCEPTED';
        under.genesis_Trade_value__c = 200;
        under.Asset_quality__c = 'B';
        under.genesis_Customer_quality__c = 'c';
        under.UREL__c = 780;
        INSERT under;*/
        
        cllease__Payment_Mode__c paymentmode =new Cllease__payment_Mode__c();
        paymentmode.Name='Check';
        INSERT  paymentmode;
            
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee1.ID;
        //leaseAccount.Application__c                  = genApp.Id;
        leaseAccount.cllease__Fee_Set1__c            = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2019, 02, 01);
        leaseAccount.cllease__Term__c                = 12.0;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2019, 03, 01);
        leaseAccount.cllease__Product_Sub_Type__c    = 'FINANCE LEASE';
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2019, 02, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 1100.0;
        leaseAccount.cllease__Due_Day__c             = 1.0;
        leaseAccount.cllease__Lease_Status__c= 'ACTIVE - BAD STANDING';
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.Rental_Payment_Method__c=paymentmode.Id;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        INSERT leaseAccount;
      
      
      
       cllease__GL_Account__c objaccCR = new cllease__GL_Account__c();
       objaccCR.cllease__Account_Code__c = '39900';
       objaccCR.Name = 'Suspense Account';
      
       insert objaccCR;
       cllease__GL_Account__c objaccDb = new cllease__GL_Account__c();
       objaccDb.cllease__Account_Code__c = '12700';
       objaccDb.Name = 'HSBC (24598873)';
       insert objaccDb ;
       
      cllease__GL_Transaction_Detail__c objGl = new cllease__GL_Transaction_Detail__c ();
      objGl.cllease__Company__c = dummyOffice.Id; 
      objGl.cllease__Credit_GL_Account__c = objaccCR.Id;
      objGl.cllease__Debit_GL_Account__c = objaccDb.Id;
      objGl.cllease__Contract__c = leaseAccount.id;
      insert objGl;
      
         cllease__GL_Transaction_Detail__c objhp =  [SELECT cllease__Accrual_Transaction__c,cllease__Billing_Transactions__c,cllease__Cash_Receipt_Transaction__c,cllease__Cash_Receipt__c,cllease__Company__c,cllease__Contract__c,
           cllease__Credit_Amount__c,cllease__Credit_GL_Account_Code__c,cllease__Credit_GL_Account__c,cllease__Debit_Amount__c, 
           cllease__Debit_GL_Account_Code__c,cllease__Debit_GL_Account__c,cllease__Debt_Schedule__c,cllease__Depreciation_Stream__c, 
           cllease__Disbursement_Transaction__c,cllease__Disbursement_Txn__c,cllease__Equipment_Transaction__c,cllease__Equipment__c, 
           cllease__Expense_Fee_Transaction__c,cllease__Exported_Date__c,cllease__Exported_Flag__c,cllease__Generation_Scheme__c, 
           cllease__GL_Batch_Post_Date__c,cllease__GL_Date__c,cllease__Item_Id__c,cllease__Item_Name__c,cllease__LeaseApplicationNumber__c, 
           cllease__Lease_Accrual_Transaction__c,cllease__Lease_Payment_Detail__c,cllease__Other_Transactions__c, 
           cllease__Payment_Transaction_Reversal__c,cllease__Payment_Transaction__c,cllease__Reversal_Processed__c,cllease__Transaction_Description__c, 
           cllease__Transaction_type1__c,saf_Transaction_Type2__c,cllease__Transaction_Type__c,CreatedById,CreatedDate,Id,LastModifiedDate, 
           cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Payment_Transaction__r.cllease__Cheque_Number__c, 
            cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Cheque_Number__c, 
           cllease__Contract__r.Pre_Fund_Offer_Date__c,cllease__Contract__r.Funder_1_Acceptance_Date__c,cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c,
           cllease__Contract__r.Funder_2_Acceptance_Date__c ,cllease__Contract__r.Funder_2__c,cllease__Contract__r.X2_BBB_Enable_Repurchase_Date__c, 
           Name,cllease__Contract__r.cllease__Lease_Product_Name__c,Saf_Manual_GL_Entry_created__c,cllease__Charge__c,cllease__Contract__r.Funder__c, 
           cllease__Contract__r.X3_BBB_Enable_Repurchase_Date__c,cllease__Contract__r.Funder_3__c,cllease__Contract__r.Funder_3_Acceptance_Date__c, 
           Transaction_Date__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c Limit 1];
     
       
     
        
          list<Manual_GL__c> lstmn = new List<Manual_GL__c>();
       Manual_GL__c gl = new Manual_GL__c();
       gl.MN_Contract__c =objhp.cllease__Contract__c ;// leaseAccount.id;
       gl.MN_Company__c = objhp.cllease__Company__c; //'a6N0O0000005JXyUAM';
       gl.MN_GL_Account__c = objhp.cllease__Credit_GL_Account__c ; //'a620O00000005biQAA';
       gl.GL_Account_Type__c = 'Credit';
       gl.Saf_GL_Accounting_Entries__c =objhp.Id ;// 'a633O000000D3gqQAC';
       lstmn.add(gl);
       insert gl;
       gl = new Manual_GL__c();
       gl.MN_Contract__c =objhp.cllease__Contract__c ;// leaseAccount.id;
       gl.MN_Company__c = objhp.cllease__Company__c; //'a6N0O0000005JXyUAM';
       gl.MN_GL_Account__c = objhp.cllease__Debit_GL_Account__c; //'a620O00000005biQAA';
       gl.GL_Account_Type__c = 'Debit';
       gl.Saf_GL_Accounting_Entries__c =objhp.Id ;// 'a633O000000D3gqQAC';
       lstmn.add(gl);
       insert gl;
        
       //**********uncomment the block if validation failed for this class because of dag schdeule. 
       clcommon__DAG_Schedule__c dag = new clcommon__DAG_Schedule__c();
       dag.clcommon__DAG_Name__c = 'GL Entry jobs';
       insert dag;
       clcommon__DAG_Schedule__c dag1 = new clcommon__DAG_Schedule__c();
       dag1.clcommon__DAG_Name__c = 'GL Reverse Entry jobs';
       insert dag1;
       
       clcommon__Job__c dagjob = new clcommon__Job__c();
       string id = 'a690O000000gCAbQAM';
       dagjob.clcommon__Label__c = 'GLReversalJob';
       dagjob.clcommon__DAG__c = dag1.Id;
       dagjob.clcommon__Query__c = 'SELECT Id, Name FROM cllease__Lease_Account__c WHERE cllease__Invalid_Data__c = false AND (cllease__Active_flag__c = true or cllease__Installation_Flag__c = true)  and Id =:id';
       dagjob.clcommon__Batch_Size__c = 200;
       dagjob.clcommon__Fail_Type__c = 'Logging';
       dagjob.clcommon__Number_Of_Instances__c = 1;
       dagjob.clcommon__Class__c = 'cllease.GLReversalJob';
       insert  dagjob;
       dagjob = new clcommon__Job__c();
         dagjob.clcommon__DAG__c = dag.Id;
       dagjob.clcommon__Label__c = 'GLTransactionGeneratorJob';
       dagjob.clcommon__Query__c = 'SELECT Id, Name FROM cllease__Lease_Account__c WHERE cllease__Invalid_Data__c = false AND (cllease__Active_flag__c = true or cllease__Installation_Flag__c = true)  and Id =:id';
       dagjob.clcommon__Batch_Size__c = 200;
       dagjob.clcommon__Fail_Type__c = 'Logging';
       dagjob.clcommon__Number_Of_Instances__c = 1;
       dagjob.clcommon__Class__c = 'cllease.GLTransactionGeneratorJob';
       insert  dagjob;
       
       
        string value = 'ASC';
        Test.startTest();

            apexpages.standardsetcontroller setCon =new apexpages.StandardSetController(lstmn);
          //  setCon.setselected(lstmn);          
            
        PageReference pageRef = Page.SAF_VF_GLManualEnteries;       
        Test.setCurrentPageReference(pageRef);
         // load the extension
         //   opportunityContactEntryExtension oCEE = new OpportunityContactEntryExtension(new ApexPages.StandardSetController(cocr.Opportunity__c));

        
        SAF_GLAccountingEnteries glentry = new SAF_GLAccountingEnteries();
        glentry.ManualGL = gl;
        glentry.lstManualGlEntry = lstmn;
        System.assertEquals(glentry.lstManualGlEntry, lstmn);
        System.assertEquals(glentry.ManualGL, gl);
        glentry.SAF_GLAccountingEnteries();
       
        glentry.pageInit();
        glentry.RunjobsReverse();
        glentry.search();
        glentry.Runjobs();
        glentry.DownloadDoc();
        glentry.getGLFields();
        glentry.setsize();
        glentry.ViewData();
        glentry.getTotalPages();
        glentry.getSortDirection();
        glentry.setSortDirection(value);
        glentry.previous();
        glentry.next();
        glentry.first();
        glentry.last();
        
        glentry.todate = date.today();
        glentry.fromDate = date.today();
        
        glentry.ManualGLAccount = gl;
        glentry.dtstarted =  date.today();
        glentry.size = 10;
        glentry.noOfRecords = 10;
        glentry.hasnext = true;
        glentry.hasPrevious = true;
        glentry.pageNumber = 1;
        boolean bln =  glentry.hasnext;
        boolean bln2 =  glentry.hasPrevious;
        Integer Int1 =  glentry.pageNumber;
        glentry.search();
        
        Test.stopTest();        
    }
}