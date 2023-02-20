@isTest 
Private class SettlementQuote_Test{
    
    public static   SettlementQuoteNewCtrl sqn;
    public static   SettlementQuoteCtrl sq;
    public static PageReference pref;
    Public static List<cllease__Office_Name__c> complst= new List<cllease__Office_Name__c>();
    
    @testsetup Static void createTestContract()
    {  
        Test.setMock(HttpCalloutMock.class, new SuccessMock());
        Test.startTest(); 
        Saf_CompanyHouse__c ch = new Saf_CompanyHouse__c();
        ch.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/saveCLSAccount';
        ch.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        insert ch;
        
        Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableAgreementTriggers__c= true;    
        UPSERT objSettings1;
        
        List<clcommon__Collateral_Type__c> ct = new List<clcommon__Collateral_Type__c>();
        ct.add(new clcommon__Collateral_Type__c(Name = 'Equipment'));
        insert(ct);
        clcommon__Collateral_Category__c collCategory = new clcommon__Collateral_Category__c(Name ='Lease Category');
        insert(collCategory);
        List<clcommon__Collateral_Category_Type_Association__c> ccta = new List<clcommon__Collateral_Category_Type_Association__c>();
        ccta.add(new clcommon__Collateral_Category_Type_Association__c(clcommon__Collateral_Type__c = ct[0].Id,
                                   clcommon__Collateral_Category__c = collCategory.Id));
        insert(ccta);
        
        clcommon__Fee_Definition__c feeDefinition = new clcommon__Fee_Definition__c();
        feeDefinition.Name = 'Option to Purchase';
        feeDefinition.clcommon__Active__c = true;
        feeDefinition.clcommon__Class__c = 'Income';
        feeDefinition.clcommon__Amount__c = 100;
        insert feeDefinition; 
                
        HelperClass1.firstRun = false;
        HelperClass1.firstRunCustomer = false;
        cllease__Rental_Stream__c rentalStream = new cllease__Rental_Stream__c();
        
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.AccountNumber='65498';
        lessee.Name = 'TestHMNew';
        lessee.Phone = '98767 678988';
        lessee.Landline__c= '98767 678988';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        System.debug('lessee:'+lessee.id);
        system.assertNotEquals(Null,lessee.id);
        System.debug(LoggingLevel.ERROR, '*** lessee : ' + lessee);
        
        Contact dummyClient = new Contact(lastname='dummyClient',accountid=lessee.id);
        cllease__Payment_Spread__c paySpr = new cllease__Payment_Spread__c();
        paySpr.cllease__Enabled__c = true;
        paySpr.cllease__Spread_Description__c = 'test';
        paySpr.cllease__Tax_Configuration__c = 'RECEIVABLE FIRST';
        insert paySpr;
        
        //1.Pre-Setup
        //KYC ENDPOINT SETTING        
        Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
            settings.AccessToken__c ='142';
            settings.LoginURL__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/relationship?kycNumber=30&companyNumber=06625914';
            settings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            settings.UpdateRelIdtoDB__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            upsert settings;
            
        //ContactUtils code start
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            List<string> lst = new List<string>();
            lst.add('0011x00001ByXxJ');
            SAF_ContactsUtils.UpdateNewCustomerToDB(lst);
        
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);        
        
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
    
        cllease.TestHelper.systemDate = Date.parse('1/1/2018');
        
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
        
        clcommon__Company__c concompany=new clcommon__Company__c();
        concompany.clcommon__Company_Name__c='Simply Asset';
        concompany.clcommon__Branch_Date__c=Date.newInstance(2018, 12, 12);
        insert concompany;
        clcommon__Collateral__c collTrel=new clcommon__Collateral__c();
        collTrel.clcommon__Collateral_Name__c='Coll123';
        collTrel.clcommon__Equipment_NBV__c=1000;
        collTrel.clcommon__Company__c=concompany.id;
        insert collTrel;
        System.debug('collTrel='+collTrel);
        //2.Create a dummy Lease Product
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
        System.debug('dummyLP iD:-'+dummyLP.id);
        HelperClass1.firstRun = false;
        //3.Create Contract
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
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
        //leaseAccount.cllease__Maturity_Date__c = Date.newInstance(2022, 04, 27);
        insert leaseAccount;
        system.debug('*****Contract status After insert----'+leaseAccount.cllease__lease_status__c);
        system.debug('*****Contract cllease__Lease_Product_Name__r.name After insert----'+leaseAccount.cllease__Lease_Product_Name__r.Name);
        system.debug('*****Contract cllease__Account__r.name After insert----'+leaseAccount.cllease__Account__r.name);
        //4. Creating Contract Equipments
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000,cllease__Life_In_Months__c=18,cllease__Equipment_Type__c='Equipment',cllease__Contract__c =leaseAccount.Id,cllease__Equipment_Description__c ='OK',Net_Asset_Cost__c =1000));
        insert contractEquipments;
        System.debug(LoggingLevel.ERROR, '*** contractEquipments : ' + contractEquipments);
        
        //5. Creating Payment Schedule
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Contract__c=leaseAccount.Id,
                                                cllease__Payment_Amount__c=1000,cllease__Total_Payment__c=12000,
                                                cllease__Payment_Date__c=Date.newInstance(2016, 01, 01)));
        insert paymentDetails;
        System.debug(LoggingLevel.ERROR, '*** paymentDetails : ' + paymentDetails );
        
      
        //6. Calling ContractBuilder for Contract Creation                 
        //cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        //builder.addChildObjects(contractEquipments);
        //builder.addChildObjects(contractParty);
       // builder.addChildObjects(paymentDetails);
        
        //String response = builder.createContract(null);
        //System.debug(LoggingLevel.ERROR, '*** response: ' + response);
        HelperClass1.firstRun = false;
        //7.Generate streams and activate contract
        cllease.RegenerateStreamsCtrl.regenerateStreams(leaseAccount.Id);
        //leaseAccount.cllease__Lease_Status__c = 'ACTIVE - GOOD STANDING';      
        //update leaseAccount;  
        HelperClass1.firstRun = false;
        //system.debug('*****Contract ----'+leaseAccount.id);       
        //cllease.ActivateContractCtrl.activateContract(leaseAccount.id);
        //system.debug('*****Contract status after activate----'+leaseAccount.cllease__lease_status__c);
                
        //8.Generate Bill
        cllease__Lease_account_Due_Details__c bill = new cllease__Lease_account_Due_Details__c();        
        bill.cllease__Account__c = lessee.ID;
        bill.cllease__Lease_Account__c = leaseAccount.Id;
        //bill.cllease__Lease_Account__r.cllease__Account__c = '';
        bill.cllease__Total_Due_Amount__c = 0.00;
        bill.cllease__Due_Type_Description__c = 'TERMINATION';   
        bill.cllease__Due_Date__c = Date.today();
        bill.cllease__Transaction_Date__c = Date.today();
        insert bill;
        
        cllease__Contract_Fees__c confee=new cllease__Contract_Fees__c();
        confee.cllease__Fee_Definition__c=feeDefinition.id;
        confee.cllease__Total_Payment_Amount__c=100;
        confee.cllease__Contract__c=leaseAccount.Id;
        insert confee;
        
        cllease__Office_Name__c company = new cllease__Office_Name__c();
        company.Name = 'Test-Company';
        company.cllease__Current_System_Date__c = Date.newInstance(2018, 01, 01);
        company.cllease__Office_Short_Name__c = 'TC-Test';
        company.cllease__Tax_Method__c = 'Exclusive';
        complst.add(company);         
        insert complst;
        
        leaseAccount.cllease__Next_Due_Generation_Date__c = Date.today().addDays(28);
        //update leaseAccount;
        leaseAccount.cllease__Lease_Status__c = 'ACTIVE - GOOD STANDING'; //'TERMINATED';       
        update leaseAccount;
        system.debug('*****Contract status before running class----'+leaseAccount.cllease__lease_status__c);
    }  
    
   @isTest static void generateAcceptSettlementQuote()
    {   
        Date quoteDate;
        Date expiryDate;
        Date acceptanceDate;
        cllease__Lease_Account__c leaseAccount = [SELECT id,name,cllease__Maturity_Date__c from cllease__Lease_Account__c LIMIT 1];
        System.debug('leaseAccount:-'+leaseAccount);
        List<Termination_Quote_Figures__c> tquotes;
        List<Termination_Quote_Figures_Header__c> tquoteheader;
        List<cllease__Termination_Quote_Header__c> acceptedquote;
                
        Test.startTest(); 
        pref = Page.SettlementQuoteNew;
        pref.getParameters().put('id',leaseAccount.id);        
        Test.setCurrentPage(pref);
        clcommon__Fee_Definition__c feelist=[Select id,name from clcommon__Fee_Definition__c limit 1];
        ApexPages.StandardController con = new ApexPages.StandardController(leaseAccount);
        sqn = new    SettlementQuoteNewCtrl(con);
        sqn.FPSelect='Full';
        sqn.QuoteReasonSelect = 'Early Settlement';
        quoteDate = sqn.dateOfQuote;
        expiryDate = sqn.Expirydate;
        System.AssertNotequals(Null,quoteDate);
        System.AssertNotequals(Null,expiryDate);
        sqn.equipmentSelection();
        sqn.BreakDAsset();
        tquotes = [SELECT id,name FROM Termination_Quote_Figures__c];
        System.Assert(tquotes.size()==0);
        sqn.generateQuoteFigures();
        sqn.rowwrapperList[0].isSelectedQuote = true;      
        tquoteheader = [SELECT id,name FROM Termination_Quote_Figures_Header__c where Agreement__c = :leaseAccount.name];
        System.Assert(tquoteheader.size()==0);
        sqn.saveQuoteDetails();
        tquoteheader = [SELECT id,name FROM Termination_Quote_Figures_Header__c where Agreement__c = :leaseAccount.name];
        System.Assert(tquoteheader.size()==1);
        sqn.acceptTerminationQuote();
        //sqn.disableAssetSaleButton(tquoteheader[0].id);
        acceptedquote = [SELECT id,name FROM cllease__Termination_Quote_Header__c where cllease__Contract__c = :leaseAccount.id];
        System.Assert(acceptedquote.size()==1);
        sqn.initiateAssetSale();
        sqn.datechange();
        sqn.amountchange();
        sqn.AcceptedTerminationQuote = 'LOCKED';
        sqn.quotechange();        
        sqn.displayassetsale=true;
        sqn.ThirdPartySelect = 'Yes';
        List<cllease__Payment_Stream__c> contractPayments1 = new List<cllease__Payment_Stream__c>();
        cllease__Payment_Stream__c paymentstream1 = new cllease__Payment_Stream__c();
        paymentstream1.cllease__Contract__c = leaseAccount.id;
        paymentstream1.cllease__Date__c = Date.newInstance(2022, 05, 27);
        paymentstream1.cllease__Payment_Type__c = 'RENT';
        paymentstream1.cllease__Rental_Amount__c=1000;
        insert paymentstream1;
        contractPayments1.add(paymentstream1);
        sqn.CalculateSettlementFigure('Standard',contractPayments1);
        sqn.CalculateSettlementFigure('NewBusiness',contractPayments1);
        sqn.CalculateSettlementFigure('NBV',contractPayments1);
        sqn.CalculateSettlementFigure('Other',contractPayments1);
        sqn.CalculateFutureRentals(contractPayments1);
        sqn.close();
        con = new ApexPages.StandardController(tquoteheader[0]);
        sq = new    SettlementQuoteCtrl(con);        
        system.debug('*************Expiry Date****************:'+sq.expirydate);
        sq.FPSelect='Full';
        System.Assert(sq.FPSelect=='Full');
        System.Assert(sq.QuoteReasonSelect == 'Early Settlement');
        System.Assert(quoteDate == sq.dateOfQuote);
        System.Assert(expiryDate == sq.Expirydate);
        sq.equipmentSelection();
        tquotes = [SELECT id,name FROM Termination_Quote_Figures__c];
        sq.generateQuoteFigures();
        System.Assert(tquotes.size()>0);       
        sq.rowwrapperList[0].isSelectedQuote = true;
        sq.saveQuoteDetails();
        delete tquoteheader;
        sq.saveQuoteDetails();
        tquoteheader = [SELECT id,name FROM Termination_Quote_Figures_Header__c where Agreement__c = :leaseAccount.name];
        System.Assert(tquoteheader.size()==1);
        sq.acceptTerminationQuote();
        acceptedquote = [SELECT id,name FROM cllease__Termination_Quote_Header__c where cllease__Contract__c = :leaseAccount.id];
        System.Assert(acceptedquote.size()==2);
        sq.InvoiceSaleAmount();
        sq.initiateAssetSale();
        acceptedquote[0].cllease__Status__c = 'TERMINATION PROCESSED';
        update acceptedquote;
        leaseAccount.cllease__Lease_Status__c = 'TERMINATED';  
        HelperClass1.firstRun = false;
        update leaseAccount;
        List<Id> ContractIds = New List<Id>();
        sq.datechange();
        sq.amountchange();
        sq.AcceptedTerminationQuote = 'LOCKED';
        sq.quotechange();        
        sq.displayassetsale=true;
        sq.ThirdPartySelect = 'Yes';
        sq.InvoiceSaleAmount();
        sq.close();
        sq.createTerminationQuoteLine(100, 'test', tquotes[0], acceptedquote[0], true, 'FEE', tquotes[0].Id);
        List<cllease__Payment_Stream__c> contractPayments = new List<cllease__Payment_Stream__c>();
        cllease__Payment_Stream__c paymentstream = new cllease__Payment_Stream__c();
        paymentstream.cllease__Contract__c = leaseAccount.id;
        paymentstream.cllease__Date__c = Date.newInstance(2022, 05, 27);
        paymentstream.cllease__Payment_Type__c = 'RENT';
        paymentstream.cllease__Rental_Amount__c=1000;
        insert paymentstream;
        contractPayments.add(paymentstream);
        sq.CalculateSettlementFigure('Standard',contractPayments);
        sq.CalculateSettlementFigure('NewBusiness',contractPayments);
        sq.CalculateSettlementFigure('NBV',contractPayments);
        sq.CalculateSettlementFigure('Other',contractPayments);
        sq.CalculateFutureRentals(contractPayments);
        sq.getLoadTermQuote();
        Test.stopTest();
        ContractIds.add(leaseAccount.id);
        HelperClass1.firstRun = false;
        SettlementQuoteAssetReturnDelete.AssetReturnDelete(ContractIds);
        
        system.debug('*****Contract status after running class----'+leaseAccount.cllease__lease_status__c); 
        
    }
    
    public class SuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'text/xml');
            response.setBody('');
            response.setStatusCode(200);
            return response; 
        }    
    }
    
}