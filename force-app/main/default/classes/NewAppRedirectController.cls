public class NewAppRedirectController {
    public NewAppRedirectController(ApexPages.StandardController stdController) {
        
    }
    public PageReference redirect(){
        RecordType rcrdType = [SELECT DeveloperName,Id,Name,NamespacePrefix,SobjectType FROM RecordType WHERE SobjectType = 'genesis__Applications__c' AND DeveloperName = 'Lease' LIMIT 1];
        PageReference pageRef;
        if(rcrdType != null){
            String hostURL = System.URL.getSalesforceBaseUrl().getHost();
            System.debug('***hostURL***'+hostURL);
            hostURL = hostURL.replace('c.cs', 'genesisextn.cs');
            System.debug('***hostURL***'+hostURL);
            //pageRef = new PageReference('https://'+hostURL+'/apex/NewApplication?retURL=%2Fa7F%2Fo&RecordType='+rcrdType.id+'&ent=01I0O000000vYCu&save_new=1&sfdc.override=1'); 
            pageRef = new PageReference('/apex/genesisExtn__NewApplication?retURL=%2Fa7F%2Fo&RecordType='+rcrdType.id+'&ent=01I0O000000vYCu&save_new=1&sfdc.override=1');             
        }
        return pageRef;
    }
}