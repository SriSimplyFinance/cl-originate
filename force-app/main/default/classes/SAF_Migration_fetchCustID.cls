global class SAF_Migration_fetchCustID implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    global Map<String,String> appIdfolderMap=New Map<String,String>();
    //global List<Account> tobeupdatedaccList =New List<Account>();
    global Map<Id,Account> tobeupdatedaccList =New Map<Id,Account>();
    global Database.QueryLocator start(Database.BatchableContext BC) {   
       // string str='0016E00000YkoRR'; 
        string[] ids = new string[] {'ERROR','NULL',''};
       // string[] ids = new string[]{'NULL','ERROR',''};            
        String query = 'Select Id,Name,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.SAF_Sharepoint_Folder_ID__c from genesis__Applications__c';
        //where genesis__Account__r.SAF_Sharepoint_Folder_ID__c IN:ids
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<genesis__Applications__c> AppList) {
        system.debug('&&&&&AppList'+AppList);
        for(genesis__Applications__c app:AppList){   
            string custName= app.genesis__Account__r.Name.replaceAll('[|,|.|//\\,||"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"|\\\\|]', '');
           
           try{
                //SAF_CreateSharePointController.processSharePoint(custName,app.Name,app.genesis__Account__c,'');
                String resp=SAF_CreateSharePointController_cust.processSharePoint(custName,app.Name,app.genesis__Account__c,'');
                appIdfolderMap.put(app.genesis__Account__c,resp);
              }
              
           catch(exception e){
            system.debug( 'Error: '+e.getMessage() );
           }
        }
        system.debug('&&&&&appIdfolderMap'+appIdfolderMap);
        if(appIdfolderMap.size()>0){
            for(String st:appIdfolderMap.keyset()){
                Account a = new Account();
                a.id = st;               
                a.SAF_Sharepoint_Folder_ID__c = appIdfolderMap.get(st);
               // tobeupdatedaccList.add(a);
               tobeupdatedaccList.put(a.id,a);
                system.debug('&&&&&Account:'+a);
            }
        
        system.debug('&&&&&tobeupdatedaccList'+tobeupdatedaccList);
        
        if(tobeupdatedaccList.size()>0){        
            update tobeupdatedaccList.values();
            system.debug('&&&&&tobeupdatedaccList'+tobeupdatedaccList);
        }
        }
    
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    }
}