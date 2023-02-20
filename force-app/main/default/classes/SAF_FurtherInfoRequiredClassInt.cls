public class SAF_FurtherInfoRequiredClassInt {
    Public  Underwriting__c appRec{get;set;}
    public  Id appId{get;
                        set{
                            appId=value;
                            init();
                           }
                       }
    public  void init(){
        system.debug('appid:: '+appId);
        appRec = [SELECT id,Name,(select id,Further_Information_Request__c,Reason__c,Internal_Only__c from Further_Information_Requests__r where Internal_Only__c = true) from Underwriting__c where id =: appId];
    }    
}