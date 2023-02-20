public class SAF_FurtherInfoRequiredClass {
    Public  Underwriting__c appRec{get;set;}
    public  Id appId{get;
                        set{
                            appId=value;
                            init();
                           }
                       }
    public  void init(){
        system.debug('appid:: '+appId);
        appRec = [SELECT id,Name,(select id,Further_Information_Request__c,Reason__c from Further_Information_Requests__r)  from Underwriting__c where id =: appId];
    }    
}