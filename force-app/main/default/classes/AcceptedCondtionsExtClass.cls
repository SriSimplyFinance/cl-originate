public class AcceptedCondtionsExtClass {
    Public  Underwriting__c appRec{get;set;}
    public  Id appId{get;
                        set{
                            appId=value;
                            init();
                           }
                       }
    public  void init(){
        system.debug('appid:: '+appId);
        appRec = [SELECT id,Name,(select id, Name, Condition__c, Internal__c from Underwriter_comments__r where Internal__c=false and System_Generated__c=false) from Underwriting__c where id =: appId];
    }    
}