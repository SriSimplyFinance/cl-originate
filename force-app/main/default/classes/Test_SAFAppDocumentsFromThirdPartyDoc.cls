@isTest
private class Test_SAFAppDocumentsFromThirdPartyDoc{
    @isTest 
    static void Test_SAFAppDocumentsFromThirdPartyDoc() {
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        SFDCSharepointFileUpload__c setting = new SFDCSharepointFileUpload__c();
        setting.In_Life__c = 'In Life';
      setting.Proposal__c ='Proposal';
      setting.Third_Party_Documents__c='Third Party Documents';
      setting.FilePathForThirdPartyDocs__c='/Third Party Documents';
      setting.File_Path_For_ThirdParty_InLife__c='/Third Party Documents/App/In Life';
      setting.File_Path_For_ThirdParty_Proposal__c='/Third Party Documents/App/Proposal';
      insert setting;
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
        
        genesis__Document_Category__c docCat3 = new genesis__Document_Category__c();
        docCat3.genesis__Category_Name__c= 'Proposal';
      //  docCat3.genesis__Parent_Document_Category__c = docCat.Id;
        insert docCat3;
        
        genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat.genesis__Application__c = application.Id;
        appDocCat.genesis__Document_Category__c = docCat3.Id;
        appDocCat.Name = 'In Life';
        insert appDocCat;
        
        SAF_DocumentUploadToSharePoint.populateThirdpartyDocs(appDocCat.genesis__Application__c);
    }
    
  }