global class RestructureAPIJob extends cllease.LeaseDynamicJob implements Database.AllowsCallouts, Database.Stateful {
    String customQuery;
    private final static String JOB_NAME = 'RestructureAPIJob';
    private Set<Id> lsIds;
    private Date todaysDate;
    private Integer actionParam;
    
    global RestructureAPIJob(Set<Id> lsIds, Integer actionParam) {
        super(JOB_NAME, null);
        this.lsIds = lsIds;
        this.actionParam = actionparam;
        this.todaysDate = cllease.SystemDateUtil.getCurrentSystemDate();
        System.debug(LoggingLevel.ERROR, 'In RestructureAPIJob  constructor');
    }
    
    global override String getRuntimeQuery(){
        String lsIdsString = getStringFromIds(this.lsIds);
        String query =  'SELECT Id ' +
                       'FROM cllease__lease_Account__c ' +
                       'WHERE Id IN (' + lsIdsString + ')';
        System.debug(loggingLevel.error, 'RestructureAPIJob Query ' + query + ' action ' + actionParam);
        return query;
    }
    
    global override void doInitialize() {}
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(Database.BatchableContext bc,List<sobject> scope) {
        System.debug(LoggingLevel.ERROR, 'Inside RestructureAPIJob execute ' + scope.size());
        List<cllease__Lease_Account__c> leaseContracts = (List<cllease__Lease_Account__c>)scope;
        String rstrDate = formatDate(todaysDate);
        ErrorLogUtil logUtil = new ErrorLogUtil();
        
        try {
            for(cllease__Lease_Account__c lsAcc : leaseContracts) {
                createRestBodyAndCall(lsAcc.Id, rstrDate, actionParam);
            }
        } catch(Exception e) {
            String error = 'Cause : ' + e.getCause() + '\n';
            error += 'Line No : ' + e.getLineNumber() + '\n';
            error += 'Message : ' + e.getMessage() + '\n';
            error += 'Stack Trace : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, '^^^^ ERROR : ' + error);
            logUtil.addError(bc.getJobId(), leaseContracts[0].Id, error, 'STREAMS_DATA_FIX', cllease.SystemDateUtil.getCurrentSystemDate());
            logUtil.commitErrors();
        }
    }
    
    global override void doFinish(Database.BatchableContext bc) {
        if(this.actionParam == 1) {
            Integer actionParam2 = 2; // approve restructure Contract
            RestructureAPIJob job = new RestructureAPIJob(this.lsIds, actionParam2);
            Database.executeBatch(job, 1);
        }
    }
    
    public void createRestBodyAndCall(Id leaseId, String rstrDate, Integer actionParam) {
        try {
            clcommon.Response res = new clcommon.Response(); 
            HttpRequest req = new HttpRequest();
            req.setTimeOut(30000);
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            String baseUrl = 'Https://' + System.URL.getSalesforceBaseUrl().getHost();
            req.setEndpoint(baseUrl + '/services/apexrest/cllease/v1/restructureContract/');
            req.setMethod('POST');
            req.setHeader('Authorization','Bearer ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            req.setHeader('Content-Length', '0');
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('contracts');
            gen.writeStartObject();
            gen.writeStringField('contractId',String.valueOf(leaseId));
            gen.writeStringField('restructureDate',rstrDate);
            gen.writeStringField('restructureReason','Streams Data Fix');
            gen.writeStringField('actionParameter', string.valueOf(actionParam));
            gen.writeEndObject();
            gen.writeEndObject();
            req.setbody(gen.getAsString());
            System.debug(LoggingLevel.ERROR, '^^^^ req.Body : ' + req.getBody());
            
            if(!Test.isRunningTest()) {
                response = http.send(req);
                System.debug(LoggingLevel.ERROR, '^^^^ response.Body : ' + response);
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String content = String.valueOf(results.get('content'));
                
                if(response.getStatusCode() != 200){
                    res.errorMessage = String.valueOf(results.get('msgAlerts'));
                    throw new TransactionException(res.errorMessage);
                }
            }
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, '^^^^ ERROR : ' + e.getMessage());
            throw e;
        }
    }
    
    public String formatDate(Date tempDate){
        String paymentDate;
        String month;
        String day;
        if(tempDate.month()<9){
            month = '0'+String.valueOf(tempDate.month());
        }else{
            month = String.valueOf(tempDate.month());
        }
        if(tempDate.day()<9){
            day = '0'+String.valueOf(tempDate.day());
        }else{
            day = String.valueOf(tempDate.day());
        }
        paymentDate = day +'/'+ month +'/'+ String.valueOf(tempDate.year());
        return paymentDate;
    }
    
    private class TransactionException extends Exception {
    }
    
    public static String getStringFromIds(Set<Id> idsList) {
        String IdsString = '';
        if(idsList == null || idsList.size() == 0) {
            return IdsString;
        }
        for (Id idValue : idsList) {
          IdsString = IdsString + '\'' + String.escapeSingleQuotes(idValue) + '\'' + ',';
        }
        IdsString = IdsString.substring(0, IdsString.length() - 1);
        System.debug('IdsString: ' + IdsString);
        return IdsString;
    }
}