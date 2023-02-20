public class PayoutsCommentary {
    Public  genesis__Applications__c appRec{get;set;}
    public  Id appId{get;
                        set{
                            appId=value;
                            init();
                           }
                       }
    public  void init(){
        system.debug('appid:: '+appId);
        appRec = [Select id,Name,(select id,Commentary__c from Tasks where  Commentary__c != NULL order by LastModifiedDate ASC) from genesis__Applications__c where Id =: appId];
    }    
}