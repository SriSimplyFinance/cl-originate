@IsTest
public class SAF_ValidateApplication_Test{
    @isTest static void valAppTest() { 
       Account a = new Account();
        a.Name = 'TestAccount';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        a.Landline__c='12345 123456';
        insert a;
       
       list<genesis__Applications__c> applist = new list<genesis__Applications__c>();
       genesis__Applications__c app = new genesis__Applications__c();   
       app.genesis__Account__c = a.Id;
       app.genesis__Expected_Start_Date__c = Date.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app.genesis__Sales_Division__c = 'DIRECT';
       app.genesis__Payment_Frequency__c = 'MONTHLY';
       app.genesis__Financed_Amount__c = 123;
      // app.genesis__Status__c ='PROPOSAL';
       app.genesis__Status__c ='APPROVED';
       app.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       applist.add(app);
       
        genesis__Applications__c app1 = new genesis__Applications__c();   
       app1.genesis__Account__c = a.Id;
       app1.genesis__Expected_Start_Date__c = Date.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app1.genesis__Sales_Division__c = 'DIRECT';
       app1.genesis__Payment_Frequency__c = 'MONTHLY';
       app1.genesis__Financed_Amount__c = 123;
      // app.genesis__Status__c ='PROPOSAL';
       app1.genesis__Status__c ='PROPOSAL- REWORK';
       app1.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       applist.add(app1);
       
       genesis__Applications__c app2 = new genesis__Applications__c();   
       app2.genesis__Account__c = a.Id;
       app2.genesis__Expected_Start_Date__c = Date.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app2.genesis__Sales_Division__c = 'DIRECT';
       app2.genesis__Payment_Frequency__c = 'MONTHLY';
       app2.genesis__Financed_Amount__c = 123;
      // app.genesis__Status__c ='PROPOSAL';
       app2.genesis__Status__c ='TRANSACT';
       app2.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       applist.add(app2);
       
       genesis__Applications__c app3 = new genesis__Applications__c();   
       app3.genesis__Account__c = a.Id;
       app3.genesis__Expected_Start_Date__c = Date.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app3.genesis__Sales_Division__c = 'DIRECT';
       app3.genesis__Payment_Frequency__c = 'MONTHLY';
       app3.genesis__Financed_Amount__c = 123;
      // app.genesis__Status__c ='PROPOSAL';
       app3.genesis__Status__c ='DOCUMENTS RAISED';
       app3.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       applist.add(app3);
       
        genesis__Applications__c app4 = new genesis__Applications__c();   
       app4.genesis__Account__c = a.Id;
       app4.genesis__Expected_Start_Date__c = Date.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app4.genesis__Sales_Division__c = 'DIRECT';
       app4.genesis__Payment_Frequency__c = 'MONTHLY';
       app4.genesis__Financed_Amount__c = 123;
      // app.genesis__Status__c ='PROPOSAL';
       app4.genesis__Status__c ='TRANSACT';
       app4.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       applist.add(app4);
       
        genesis__Applications__c app5 = new genesis__Applications__c();   
       app5.genesis__Account__c = a.Id;
       app5.genesis__Expected_Start_Date__c = Date.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app5.genesis__Sales_Division__c = 'DIRECT';
       app5.genesis__Payment_Frequency__c = 'MONTHLY';
       app5.genesis__Financed_Amount__c = 123;
      // app.genesis__Status__c ='PROPOSAL';
       //app5.genesis__Status__c ='DOCUMENTS RECEIVED'; // Commented by Deepak M on 31 OCT 2018 for new Status
       app5.genesis__Status__c ='READY TO CONVERT'; // Added by Deepak M on 31 Oct 2018 for new status values
       app5.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       applist.add(app5);
       
       //Added by Sumit for Activated Brokered Out status change on 17/16/2019
       genesis__Applications__c app6 = new genesis__Applications__c();   
       app6.genesis__Account__c = a.Id;
       app6.genesis__Expected_Start_Date__c = Date.Today();
       app6.Activated_Date__c = System.Today();
     //app.genesis__CL_Product__c = clProdName.Id;
       app6.genesis__Sales_Division__c = 'DIRECT';
       app6.genesis__Payment_Frequency__c = 'MONTHLY';
       app6.genesis__Financed_Amount__c = 123;
      // app.genesis__Status__c ='PROPOSAL';
       //app5.genesis__Status__c ='DOCUMENTS RECEIVED'; // Commented by Deepak M on 31 OCT 2018 for new Status
       app6.genesis__Status__c ='ACTIVATED - BROKERED OUT'; // Added by Deepak M on 31 Oct 2018 for new status values
       app6.genesis__Term__c =12;
       //app.genesis__CL_Product_Name__c = clProdName.Id;
       applist.add(app6);
       
       /* cllease__Lease_Account__c cll = new cllease__Lease_Account__c();
       cll.Application__c = applist[0].id;
       insert cll; */
                         
       insert applist;
       
       string appid = applist[0].id;
       string appid1 = applist[1].id;
       string appid2 = applist[2].id;
       string appid3 = applist[3].id;
       string appid4 = applist[4].id;
       string appid5 = applist[5].id;
       string appid6 = applist[6].id; //Added by Sumit on 17/06/2019
       
       System.debug('*****Status:'+applist[5].genesis__Status__c+'********************************************');
       test.startTest();
       
       SAF_ValidateApplication.Validatestatus(appid);     
       SAF_ValidateApplication.Validatestatus(appid1);
       SAF_ValidateApplication.ValidateDocumentRaised(appid2);                   
       SAF_ValidateApplication.ValidateDocumentCollected(appid3); 
       SAF_ValidateApplication.moreInformationRequired(appid4); 
       SAF_ValidateApplication.onConvert(appid5); 
       SAF_ValidateApplication.ActivateBrokeredOut(appid6); //Added by Sumit on 17/06/2019
            
       test.stopTest();
    } 
}