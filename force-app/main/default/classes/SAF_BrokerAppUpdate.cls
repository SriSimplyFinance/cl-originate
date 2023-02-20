Global class SAF_BrokerAppUpdate
{

    static SAF_BrokerApp__c settings = SAF_BrokerApp__c.getOrgDefaults();
    
    webservice static String UpdateAppId(List<String> AppId)
    {
    
          List<genesis__Applications__c> appl = [SELECT id, name FROM genesis__Applications__c WHERE Id =: AppId];
        
        
        system.debug('App list size::' +appl.size());
        system.debug('::::App list:::::' +appl);
        
        if(appl.size() > 0)
        {
            for(genesis__Applications__c app: appl)
            {
                
                String JsonString;
                
                system.debug('application id inside for loop:' +app);
                
                JSONGenerator gen = JSON.createGenerator(true);
                 gen.writeStartObject();
                 
                   if(String.isNotBlank(app.Id))
                   {
                     gen.writeStringField('id', app.id);
                   }
                 gen.writeEndObject();
                 JsonString = gen.getAsString();  
                if(String.isNotBlank(JsonString)){
                  UpdateAppIdtoBrokerDB(JsonString);
                
            }
            
        }
    
    }
    return 'SUCCESS';
    }
   
    @future(callout = true)
     public static void UpdateAppIdtoBrokerDB(string JsonString){
        //do callout here rest or soap
        //public static void
       
        
            System.debug('JsonString::'+JsonString);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            string AppURL = settings.EndPointURL__c;
            request.setEndpoint(AppURL);  //https://prod-25.uksouth.logic.azure.com:443/workflows/ea71cffefb414a79ba0028649464bb95/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=BhwwWY0MnYjkOyMoTQvsecoy0hR0fyVgYSpiFR392WM
            request.setMethod('POST');
            //request.setHeader('Authorization', token);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody(JsonString);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            } else {
                System.debug('Updated..in CLS '); 
                System.debug(response.getBody());
            }
           /* if(response.getStatusCode() == 401 || response.getStatusCode() == 400)
            {  
                return 'Failure';
                
                 
            } */
    }
    
}