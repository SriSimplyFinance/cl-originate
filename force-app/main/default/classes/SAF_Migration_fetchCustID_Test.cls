@isTest 
public class SAF_Migration_fetchCustID_Test {
    static testMethod void SAF_Migration_fetchCustIDTest() {       
      cllease.TestHelper.createSeedDataForTesting();
     
      clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount-Happy';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
        List<String> names = new List<String> {'Finance Lease'};
        //List<String> names = new List<String> {'Hire Purchase'};
        
        clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
        pr1.clcommon__Product_Name__c = 'Finance Lease';
        //pr1.RecordTypeId = 'LEASE';
        insert pr1;
            
        clcommon__CL_Product__c product =  [select Id, Name,clcommon__Product_Name__c from clcommon__CL_Product__c where clcommon__Product_Name__c in:names limit 1 ];

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
        insert genApp; 
        
        SFDCSharepointFileUpload__c sharePointCS = new SFDCSharepointFileUpload__c();
        sharePointCS.Client_Id__c				 = '3ede7085-8344-4f2d-ab7b-6b6a8e23bad6';
        sharePointCS.Client_Secret__c			 = 'FJyderZmunqoK6ke53LpSYRYFaIx8L3lCtOsZadiE1s=';
        sharePointCS.Resource__c				 = 'https://graph.microsoft.com';
        sharepointCS.Proposal__c				 = 'Proposal';
        sharepointCS.Root__c					 = 'Root';
        sharepointCS.In_Life__c					 = 'In Life';
        sharepointCS.Transact__c				 = 'Transact';
        sharepointCS.Third_Party_Documents__c	 = 'Third Party Documents';
        sharepointCS.Microsoft_Files__c			 = 'doc,xls';
        sharepointCS.App__c						 = 'App';
        
        insert sharepointCS;
        
      test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
         List<genesis__Applications__c> lstTypes = new List<genesis__Applications__c>();
         //[select id,VLS__c,Name, cllease__Lease_Account__c,cllease__Due_Date__c FROM cllease__Lease_account_Due_Details__c ];//WHERE cllease__Due_Date__c = :dt
          // Schedule the test job
         SAF_Migration_fetchCustID ER = new  SAF_Migration_fetchCustID();
         //ER.strContractId = HPI_Parserclass_test.leaseAccount.Id;
        QL = ER.start(bc);
        
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            genesis__Applications__c objType = (genesis__Applications__c)QIT.next();           
            System.debug('genesis__Applications__c :'+objType);
            lstTypes.add(objType);
        }  
        
        system.debug('Applications: '+lstTypes);     
        try{
        ER.execute(BC,lstTypes);
        ER.finish(BC); 
        }
        catch(Exception e){}
        //ER.finish(BC); 
      
        test.stopTest();
    }
}