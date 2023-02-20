trigger SAF_BrokerApplicationTrigger on genesis__Applications__c (after insert,after update) {

   //Added for Broker app Integration
        //To send the App id details to broker app when updated in CL
        List<id> AppList = new List<id>();
        for(genesis__Applications__c App: trigger.new)
        {
        if(genesis__Applications__c.Introducer1__c != null)
        {
        system.debug('Introducer value of app::' +genesis__Applications__c.Introducer1__c);
        if(!System.isFuture() && !System.isBatch()){

        AppList.add(App.Id);
        system.debug('Application list:' +AppList);
        }

        }
        if(trigger.isUpdate)
        {
        system.debug('list of application to update:' +AppList);
        SAF_BrokerAppUpdate.UpdateAppId(AppList);
        }
        }


        }