Global class saf_RunSoleTrader{
    static Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
    public static boolean TokenExpired = false;

    webservice static String RunSoleTrader(Id applicationId, Id accountId, String businessRef) {
        String returnmsg = 'Success';  

        try {  
            String token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);
            
            Account accountRecord = [SELECT Id, KYCDB_Unique_Key_Account__c FROM Account WHERE Id =: accountId];
            system.debug('KYCDB_Unique_Key_Account :'+accountRecord.KYCDB_Unique_Key_Account__c);

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            string endpointURL = settings.SoleTrader__c;
            request.setEndpoint(endpointURL+'kycNumber='+accountRecord.KYCDB_Unique_Key_Account__c+'&businessRef='+businessRef);//'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/nonreg/updateBusinessRef?kycNumber=COMP-0000013239&businessRef=12166510';
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', token); 

            HttpResponse response = http.send(request);
            System.debug('Responce Body : '+response.getBody());
             System.debug('Responce Body New : '+response);
            String responceBody = response.getbody();
            if(responceBody.contains('"errorCode":404')){
                return '404';  
            }else if(responceBody.contains('"errorCode":500')){
                return '500';  
            }else if(response.getStatusCode() == 500){
                return String.valueof(response.getStatusCode());  
            }
        }catch(Exception ex){
            return 'Exception : '+ex.getMessage();
        }
        return returnmsg;
    }
}