public class XIRRAPIController {
    
    @invocablemethod(Label='XIRR Application' Description='Make a call to update the XIRR automatically on the application')
    public static void verifyXIRRAPICalls(List<string> appId){
        
        genesis__Applications__c genApp=[SELECT id FROM genesis__Applications__c where id=:appId[0] limit 1];
        
       String XIRRValues = ApplicationXIRRCtrl.calcuateApplicationXIRR(genApp.id);
        System.debug('XIRRValues'+XIRRValues);
    }

}