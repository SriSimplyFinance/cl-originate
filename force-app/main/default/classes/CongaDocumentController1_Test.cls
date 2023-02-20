@isTest
public class CongaDocumentController1_Test{
    public static string actObj{get;set;}
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
    public static void CongaDocCtl1_Test(){
        
        cllease__Fee_Set__c fee = new cllease__Fee_Set__c();
        fee.name = 'sample fee';
        insert fee;
        
        cllease.TestHelper.createSeedDataForTesting();
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, 
                                              clcommon__Fee_Set__c  = dummyFeeSet.ID);

        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        Account dummyAccount = new Account(Name = 'Sample Account');
        //  dummyAccount.fee_set__c = fee.id;
        insert dummyAccount;
                
        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        //dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        // dummyLP.cllease__Product_Sub_Type__c ='Hire Purchase';
        dummyLP.name='Hire Purchase';
        update dummyLP;

        // 3.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c contract      = new cllease__Lease_Account__c();
        contract.cllease__Account__c            = dummyAccount.ID;
        contract.cllease__Lease_Product_Name__c = dummyLP.ID;
        contract.cllease__Contract_Date__c      = currentDate;
        contract.cllease__Financed_Amount__c    = 10000;
        contract.cllease__Term__c               = 12;
        contract.cllease__Lease_Status__c ='PARTIAL APPLICATION';
        contract.Conga_Docs__c = 'Full Settlement Quote';
        // contract.cllease__Lease_Product_Name__r.name = 'Hire Purchase';
        //contract.Termination_Interest_Rate__c = 100;
        insert contract;
              //  cllease__Lease_Account__c congadocs= 'Full Settlement Quote';

        cllease__Termination_Quote_Header__c termQuote = new cllease__Termination_Quote_Header__c();
        termQuote.cllease__Full_Termination__c = true;
        termQuote.cllease__Contract__c = contract.id;
        termQuote.cllease__Requested_Termination_Date__c = currentDate;
        termQuote.cllease__Termination_Date__c = currentDate;
        insert termQuote;
        
        String sessionId1 = UserInfo.getSessionId();
        PageReference pgRef = Page.CongaDOcs; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', contract.id);
         string congaDoc ='Part Settlement Quote';
        string url = 'test';
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ());
        ApexPages.StandardController standrdcontroller = new ApexPages.StandardController(contract);
        // Test.setCurrentPageReference(new PageReference('Page.CongaDOcs')); 
        // System.currentPageReference().getParameters().put('Conga_Docs__c', 'Full settlement Quote');
        CongaDocumentController1 conDoc = new CongaDocumentController1();
        conDoc.actObj = contract; 
       string data1=string.valueOf(conDoc.actObj);
        // string data2='Full Settlement Quote';
        condoc.CongaSettlementDoc1();
        condoc.ProcessSelected();
         condoc.Cancel();
         CongaDocumentController1.PartSettlementDoc(congaDoc,sessionId1,contract.id,termQuote.id);
        CongaDocumentController1.getCalloutToConga(url);
        test.stopTest();
    }
     @isTest
    public static void CongaDocCtl1_Test1(){
        
        cllease__Fee_Set__c fee = new cllease__Fee_Set__c();
        fee.name = 'sample fee';
        insert fee;
        
        cllease.TestHelper.createSeedDataForTesting();
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, 
                                              clcommon__Fee_Set__c  = dummyFeeSet.ID);

        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        Account dummyAccount = new Account(Name = 'Sample Account');
        //  dummyAccount.fee_set__c = fee.id;
        insert dummyAccount;
                
        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        //dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        // dummyLP.cllease__Product_Sub_Type__c ='Hire Purchase';
        dummyLP.name='Finance Lease';
        update dummyLP;

        // 3.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c contract      = new cllease__Lease_Account__c();
        contract.cllease__Account__c            = dummyAccount.ID;
        contract.cllease__Lease_Product_Name__c = dummyLP.ID;
        contract.cllease__Contract_Date__c      = currentDate;
        contract.cllease__Financed_Amount__c    = 10000;
        contract.cllease__Term__c               = 12;
        contract.cllease__Lease_Status__c ='PARTIAL APPLICATION';
        contract.Conga_Docs__c = 'FUll Settlement Quote';
        // contract.cllease__Lease_Product_Name__r.name = 'Hire Purchase';
        //contract.Termination_Interest_Rate__c = 100;
        insert contract;
              //  cllease__Lease_Account__c congadocs= 'Full Settlement Quote';

        cllease__Termination_Quote_Header__c termQuote = new cllease__Termination_Quote_Header__c();
        termQuote.cllease__Full_Termination__c = true;
        termQuote.cllease__Contract__c = contract.id;
        termQuote.cllease__Requested_Termination_Date__c = currentDate;
        termQuote.cllease__Termination_Date__c = currentDate;
        insert termQuote;
        
        String sessionId1 = UserInfo.getSessionId();
        PageReference pgRef = Page.CongaDOcs; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', contract.id);
         string congaDoc ='Part Settlement Quote';
        string url = 'test';
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ());
        ApexPages.StandardController standrdcontroller = new ApexPages.StandardController(contract);
        // Test.setCurrentPageReference(new PageReference('Page.CongaDOcs')); 
        // System.currentPageReference().getParameters().put('Conga_Docs__c', 'Full settlement Quote');
        CongaDocumentController1 conDoc = new CongaDocumentController1();
        conDoc.actObj = contract; 
        string data1=string.valueOf(conDoc.actObj);
        // string data2='Full Settlement Quote';
        condoc.CongaSettlementDoc1();
        condoc.ProcessSelected();
         condoc.Cancel();
         CongaDocumentController1.PartSettlementDoc(congaDoc,sessionId1,contract.id,termQuote.id);
        CongaDocumentController1.getCalloutToConga(url); 
       test.stopTest();
    }    
    @isTest
    public static void CongaDocCtl1_Test2(){
        
        cllease__Fee_Set__c fee = new cllease__Fee_Set__c();
        fee.name = 'sample fee';
        insert fee;
        
        cllease.TestHelper.createSeedDataForTesting();
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, 
                                              clcommon__Fee_Set__c  = dummyFeeSet.ID);

        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        Account dummyAccount = new Account(Name = 'Sample Account');
        //  dummyAccount.fee_set__c = fee.id;
        insert dummyAccount;
                
        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        //dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        // dummyLP.cllease__Product_Sub_Type__c ='Hire Purchase';
        dummyLP.name='Finance Lease';
        update dummyLP;

        // 3.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c contract      = new cllease__Lease_Account__c();
        contract.cllease__Account__c            = dummyAccount.ID;
        contract.cllease__Lease_Product_Name__c = dummyLP.ID;
        contract.cllease__Contract_Date__c      = currentDate;
        contract.cllease__Financed_Amount__c    = 10000;
        contract.cllease__Term__c               = 12;
        contract.cllease__Lease_Status__c ='PARTIAL APPLICATION';
        contract.Conga_Docs__c = 'Reschedule Letter';
        // contract.cllease__Lease_Product_Name__r.name = 'Hire Purchase';
        //contract.Termination_Interest_Rate__c = 100;
        insert contract;
              //  cllease__Lease_Account__c congadocs= 'Full Settlement Quote';

        cllease__Termination_Quote_Header__c termQuote = new cllease__Termination_Quote_Header__c();
        termQuote.cllease__Full_Termination__c = false; 
        termQuote.cllease__Contract__c = contract.id;
        termQuote.cllease__Requested_Termination_Date__c = currentDate;
        termQuote.cllease__Termination_Date__c = currentDate;
        insert termQuote;
        
        String sessionId1 = UserInfo.getSessionId();
        PageReference pgRef = Page.CongaDOcs; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', contract.id);
         string congaDoc ='Part Settlement Quote';
        string url = 'test';
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ());
        ApexPages.StandardController standrdcontroller = new ApexPages.StandardController(contract);
        // Test.setCurrentPageReference(new PageReference('Page.CongaDOcs')); 
        // System.currentPageReference().getParameters().put('Conga_Docs__c', 'Full settlement Quote');
        CongaDocumentController1 conDoc = new CongaDocumentController1();
        conDoc.actObj = contract; 
        string data1=string.valueOf(conDoc.actObj);
        // string data2='Full Settlement Quote';
        condoc.CongaSettlementDoc1();
        condoc.ProcessSelected();
        condoc.Cancel();
        CongaDocumentController1.PartSettlementDoc(congaDoc,sessionId1,contract.id,termQuote.id);
        CongaDocumentController1.getCalloutToConga(url); 
       test.stopTest();
    }      
       @isTest
    public static void CongaDocCtl1_Test3(){
        
        cllease__Fee_Set__c fee = new cllease__Fee_Set__c();
        fee.name = 'sample fee';
        insert fee;
        
        cllease.TestHelper.createSeedDataForTesting();
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, 
                                              clcommon__Fee_Set__c  = dummyFeeSet.ID);

        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        Account dummyAccount = new Account(Name = 'Sample Account');
        //  dummyAccount.fee_set__c = fee.id;
        insert dummyAccount;
                
        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        //dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        // dummyLP.cllease__Product_Sub_Type__c ='Hire Purchase';
        dummyLP.name='Hire Purchase';
        update dummyLP;
        list<id> contracts = new list<id>();
        // 3.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c contract      = new cllease__Lease_Account__c();
        contract.cllease__Account__c            = dummyAccount.ID;
        contract.cllease__Lease_Product_Name__c = dummyLP.ID;
        contract.cllease__Contract_Date__c      = currentDate;
        contract.cllease__Financed_Amount__c    = 10000;
        contract.cllease__Term__c               = 12;
        contract.cllease__Lease_Status__c ='PARTIAL APPLICATION';
        contract.Conga_Docs__c = 'Part Settlement Quote';
        // contract.cllease__Lease_Product_Name__r.name = 'Hire Purchase';
        //contract.Termination_Interest_Rate__c = 100;
        insert contract;
        contracts.add(contract.id);
              //  cllease__Lease_Account__c congadocs= 'Full Settlement Quote';

        cllease__Termination_Quote_Header__c termQuote = new cllease__Termination_Quote_Header__c();
        termQuote.cllease__Full_Termination__c = false; 
        termQuote.cllease__Contract__c = contract.id;
        termQuote.isChecked__c = true;
        termQuote.cllease__Requested_Termination_Date__c = currentDate;
        termQuote.cllease__Termination_Date__c = currentDate;
        insert termQuote;
        
        String sessionId1 = UserInfo.getSessionId();
        PageReference pgRef = Page.CongaDOcs; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', contract.id);
         string congaDoc ='Part Settlement Quote';
        string url = 'test';
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator ());
        ApexPages.StandardController standrdcontroller = new ApexPages.StandardController(contract);
        // Test.setCurrentPageReference(new PageReference('Page.CongaDOcs')); 
        // System.currentPageReference().getParameters().put('Conga_Docs__c', 'Full settlement Quote');
        CongaDocumentController1 conDoc = new CongaDocumentController1();
        try{
        CongaDocumentController1.wrapaccount wrapAcc = new CongaDocumentController1.wrapaccount(termQuote);
        wrapAcc.isSelected = false;
        
        wrapAcc.accn = termQuote;
        //wrapAcc.wrapaccount(a)
        conDoc.actObj = contract; 
      
        // string data2='Full Settlement Quote';
        condoc.CongaSettlementDoc1();
        }
        catch(exception e)
        {}
        CongaDocumentController1.getCalloutToConga(url); 
        saf_contra.getTerminationqotes(termQuote.Id);
        saf_contra.getAgreements(contract.Id);
        test.stopTest();
    }    

}