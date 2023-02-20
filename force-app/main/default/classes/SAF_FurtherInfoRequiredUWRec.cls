public class SAF_FurtherInfoRequiredUWRec {
    Public  Recommend__c appRec{get;set;}
    public  Id appId{get;
                        set{
                            appId=value;
                            init();
                           }
                       }
    public  void init(){
        system.debug('appid:: '+appId);
        appRec = [SELECT id,Name,(select id,Further_Information_Request__c,Reason__c from Further_Information_Requests__r)  from Recommend__c where id =: appId];
    }    
}