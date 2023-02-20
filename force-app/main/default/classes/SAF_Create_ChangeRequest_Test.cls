@isTest(SeeAllData=true)
public class SAF_Create_ChangeRequest_Test {
  public  static genesis__Applications__c genApp = new genesis__Applications__c();
static testMethod void SAF_Create_ChangeRequesttest() {
    clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
       List<String> names = new List<String> {'Finance Lease'};
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
        system.debug('Application Number'+genApp.Name);
        genApp.Agreement_No__c = 'LES-0000001713';
        update genApp;
    
      SAF_Document_Links__c  docLink = new SAF_Document_Links__c ();
        docLink.Name='Proposal';
        docLink.Document_Path__c ='/test/test1.png';
        docLink.File_Name__c='test1.png';
        docLink.SAF_IsSharepoint__c=false;
        docLink.SAF_Application_Number__c = genApp.Name;    
        docLink.SAF_SP_Customer_Name__c ='TestAccount';
        docLink.SAF_Sharepoint_Document_ID__c ='3456';
        insert docLink;
        docLink.Application__c =genApp.Id;
        update docLink;
        docLink.SAF_IsSharepoint__c=false;
        docLink.File_Name__c ='test2.png';
        docLink.SAF_Document_Type__c = 'HP Agreement';
        update docLink;
        docLink.SAF_Agreement_Number__c = genAPP.Agreement_No__c;
        update docLink;
        MasterDocument__c masDoc = new MasterDocument__c();
        masDoc.Application__c = genApp.Id;
        masDoc.MasterDocumentName__c = 'HP Agreement';
        insert masDoc;
        if(masDoc.MasterDocumentName__c == docLink.SAF_Document_Type__c && masdoc.Application__c == docLink.Application__c)
        {
        masDoc.Application__c = docLink.Application__c;
        masDoc.IsChecked__c = true;
        update masDoc;
        }
       
        SAF_Document_ChangeRequest__c spdocCr = new SAF_Document_ChangeRequest__c();
        spdocCr.SAF_Change_Type__c = 'Metadata_Insert';
        spdocCr.SAF_Folder__c = docLink.Name;
        spdocCr.SAF_Application_Number__c = docLink.SAF_Application_Number__c;
        spdocCr.SAF_SP_Customer_Name__c = docLink.SAF_SP_Customer_Name__c;
        spdocCr.SAF_DocumentType__c = docLink.SAF_Document_Type__c;
       // spdocCr.SAF_Customer_ID__c = customerID;
        spdocCr.SAF_SharePoint_DocumentID__c = docLink.SAF_Sharepoint_Document_ID__c;
         insert spdocCr;
        SAF_Document_ChangeRequest__c spdocCr1 = new SAF_Document_ChangeRequest__c();
        spdocCr1.SAF_Change_Type__c = 'Metadata_Update';
        spdocCr1.SAF_Folder__c = docLink.Name;
        spdocCr1.SAF_Application_Number__c = docLink.SAF_Application_Number__c;
        spdocCr1.SAF_SP_Customer_Name__c = docLink.SAF_SP_Customer_Name__c;
        spdocCr1.SAF_DocumentType__c = docLink.SAF_Document_Type__c;
       // spdocCr.SAF_Customer_ID__c = customerID;
        spdocCr1.SAF_SharePoint_DocumentID__c = docLink.SAF_Sharepoint_Document_ID__c;
         insert spdocCr1;
        
        docLink.SAF_Document_Type__c = 'Lease Agreement';
        update docLink;
        MasterDocument__c masDoc1 = new MasterDocument__c();
        if(masDoc1.MasterDocumentName__c == docLink.SAF_Document_Type__c && masdoc1.Application__c == docLink.Application__c)
        {
        masDoc1.Application__c = docLink.Application__c;
        masDoc1.IsChecked__c = true;
        update masDoc1;
        }
        SAF_Document_ChangeRequest__c spdocCr3 = new SAF_Document_ChangeRequest__c();
        spdocCr3.SAF_Change_Type__c = 'Metadata_Update';
        spdocCr3.SAF_Folder__c = docLink.Name;
        spdocCr3.SAF_Application_Number__c = docLink.SAF_Application_Number__c;
        spdocCr3.SAF_SP_Customer_Name__c = docLink.SAF_SP_Customer_Name__c;
        spdocCr3.SAF_DocumentType__c = docLink.SAF_Document_Type__c;
       // spdocCr.SAF_Customer_ID__c = customerID;
        spdocCr3.SAF_SharePoint_DocumentID__c = docLink.SAF_Sharepoint_Document_ID__c;
         insert spdocCr3;
        SAF_Document_ChangeRequest__c spdocCr2 = new SAF_Document_ChangeRequest__c();
        spdocCr2.SAF_Change_Type__c = 'Metadata_Update_of_Agreements';
        spdocCr2.SAF_Folder__c = docLink.Name;
        spdocCr2.SAF_Application_Number__c = docLink.SAF_Application_Number__c;
        spdocCr2.SAF_SP_Customer_Name__c = docLink.SAF_SP_Customer_Name__c;
        spdocCr2.SAF_DocumentType__c = docLink.SAF_Document_Type__c;
       // spdocCr.SAF_Customer_ID__c = customerID;
        spdocCr2.SAF_SharePoint_DocumentID__c = docLink.SAF_Sharepoint_Document_ID__c;
        spdocCr2.SAF_AgreementNumber__c = docLink.SAF_Agreement_Number__c;
         insert spdocCr2;
       }
    static testMethod void SAF_Create_ChangeRequesttest1() 
    {
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
       List<String> names = new List<String> {'Finance Lease'};
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
        SAF_Document_Links__c  docLink = new SAF_Document_Links__c ();
        docLink.Name='Transact';
        docLink.Document_Path__c ='/test/test1.png';
        docLink.File_Name__c='test1.png';
        docLink.SAF_IsSharepoint__c=true;
        //docLink.SAF_Application_Number__c = 'APP-0000001623'; 
        docLink.SAF_Application_Number__c = genApp.Name; 
        docLink.SAF_SP_Customer_Name__c ='TestAccount1';
        docLink.SAF_Sharepoint_Document_ID__c ='3456';
        insert docLink;
        
        //for third party folders
         docLink = new SAF_Document_Links__c ();
        docLink.Name='Third Party Documents';
        docLink.Document_Path__c ='/test/test1.png';
        docLink.File_Name__c='test1.png';
        docLink.SAF_IsSharepoint__c=false;
        //docLink.SAF_Application_Number__c = 'APP-0000001623'; 
        docLink.SAF_Application_Number__c = genApp.Name; 
        docLink.SAF_SP_Customer_Name__c ='TestAccount1';
        docLink.SAF_Sharepoint_Document_ID__c ='3456';
        insert docLink;
        }
    static testMethod void SAF_Create_ChangeRequesttest2() 
    {
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        insert acc;
        
       List<String> names = new List<String> {'Finance Lease'};
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
        MasterDocument__c masDoc = new MasterDocument__c();
        //masDoc.Application__c ='a7F6E000000CmZV';
        masDoc.Application__c =genApp.Id;
        masDoc.MasterDocumentName__c = 'HP Agreement';
        insert masDoc;
        SAF_Document_Links__c  docLink1 = new SAF_Document_Links__c ();
        docLink1.Name='Transact';
        docLink1.Document_Path__c ='/test/test1.png';
        docLink1.File_Name__c='test1.png';
        docLink1.SAF_IsSharepoint__c=true;
        docLink1.SAF_Application_Number__c = 'APP-0000001623'; 
        //docLink1.SAF_Application_Number__c = genApp.Name;     
        docLink1.SAF_SP_Customer_Name__c ='TestAccount1';
        docLink1.SAF_Sharepoint_Document_ID__c ='3456';
        insert docLink1;
        docLink1.SAF_Document_Type__c = 'HP Agreement';
       // docLink1.Application__c = 'a7F6E000000CmZV';
       docLink1.Application__c = genApp.Id;
        update docLink1;
        docLink1.SAF_Document_Type__c = 'Lease Agreement';
       // docLink1.Application__c = 'a7F6E000000CmZV';
       docLink1.Application__c = genApp.Id;
        update docLink1;
        }
 }