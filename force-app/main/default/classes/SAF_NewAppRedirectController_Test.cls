@IsTest
public class SAF_NewAppRedirectController_Test{
    @isTest static void newAppTest() {
    
     test.startTest();
        id recid = Schema.sObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Lease').getRecordTypeId();
           
        //NewAppRedirectController ctrl = new NewAppRedirectController(new ApexPages.StandardController());
        PageReference pageRef = Page.NewApplicationRedirect;
            Test.setCurrentPage(pageRef);
             genesis__Applications__c application = new genesis__Applications__c();
        ApexPages.StandardController sc = new ApexPages.standardController(application);
        NewAppRedirectController ctrl = new NewAppRedirectController(sc);     
        ctrl.redirect();
        
     test.stopTest();
   
   }
}