@isTest
public class Saf_ZohoLScontractTest 
{
   public class Saf_ZohoLScontractMock implements HttpCalloutMock
{
    public HttpResponse respond(HttpRequest request)
    {
        HttpResponse response=new httpResponse();
        response.setStatusCode(200);
        response.setStatus('Success');
        response.setHeader('Content-Type', 'application/json');
       String json='{'+       
                                  '"users":[{'+
                                  '"country":"gb",'+
                                  '"role":{' +
                                          '"name":"SalesManager",'+
                                          '"id":"10777000001201297"'+
                                         '},'+      
                                  '"language":"en_TB",'+
                                  '"locale":"en_US",'+
                                  '" microsoft":"false",'+
                                //  '"Isonline":"false",'+
                                  '"Modified_By":{'+
                                                '"name":"System Admin",'+
                                                '"id":"10777000000140034"'+
                                                 '},' +
                                  '"id":"10777000001268001",'+
                                  '"country_locale":"US",'+
                                  '"first_name":"Paul",'+
                                  '"email":"paul.morrison@simply.finance",'+    
                                  '"created_time":"2019-08-01T15:35:00+05:30",'+
                                  '"Modified_Time":"2019-08-01T15:35:00+05:30",'+
                                  '"time_format":"hh:mm a",'+
                                  '"offset":"0",'+
                                  '"profile":{'+
                                           '"name":"Standard",'+
                                           '"id":"10777000001182794"'+
                                            '},'   +  
                                 '"last_name":"Morrison",'+
                                 '"time_zone":"GMT",'+
                                 '"created_by":{'+
                                               '"name":"System Admin",'+
                                               '"id":"10777000000140034"'+
                                              '},'+
                                '"zuid":"20067174770",'+
                            //      '"confirm":"true",'+
                                '"full_name":"PaulMorrison",'+
                                '"SFDC":"sfdc",'+
                                '"territories":[{'+
                                               '}],'+    
                               '"date_format":"MM/dd/yyyy",'+
                               '"status":"active"'+
                                '}],'+
                              '"info":{'+
                                       '"per_page":"200",'+
                                       '"count":"117",'+
                                       '"page":"1"'+
                                    //   '"more_records":"true"'+
                                       '},'+
                             '"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]'+                    
            '}';
        response.setBody(json);
        response.setBody(json);
        return response;
        }
}
    @isTest static void zohoContarctTest()
    {
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
        
        Account acc = new Account();     
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        INSERT acc;
        
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
         cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
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
        List<id> agreementids=new List<id>();
        agreementids.add(leaseAccount.id);
        
        Test.startTest();
        Saf_ZohoLScontract.CreateInZoho(agreementids, false);
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractMock());
        Test.stopTest();
    }
    @istest static void updateTest()
    {
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
        
        Account acc = new Account();     
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        INSERT acc;
        
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
         cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
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
        
        cllease__Lease_Account__c leaseAcc=[select id,cllease__Term__c from cllease__Lease_Account__c where Id=:leaseAccount.id];
        leaseAcc.cllease__Term__c=13;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoLScontractMock());
        update leaseAcc;        
        Test.stopTest();
        
        }
}