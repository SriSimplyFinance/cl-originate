global class CommonBatchLogDeletionJob extends clcommon.DynamicJob {
    private final Date dDate;
    global CommonBatchLogDeletionJob() {
        //Query Custom Settings
        cllease__Org_Parameters__c orgParams = cllease__Org_Parameters__c.getOrgDefaults();
        //Default Value
        Integer days = -30;
        if (orgParams.Log_Validity__c != null) {
            days = 0 - Integer.valueOf(orgParams.Log_Validity__c);
        }
        dDate = System.today().addDays(days);
    }
    global CommonBatchLogDeletionJob(Date dDate) {
        this.dDate = dDate;
    }
    global override String getRuntimeQuery() {
        Datetime qDatetime = datetime.newInstance(dDate.year(), dDate.month(),dDate.day());
        String qDate = qDatetime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String query = 'SELECT Id FROM clcommon__Batch_Process_Log__c WHERE createdDate <= '+qDate;
        system.debug('Query::'+query);
        return query;
    }
    global override void doStart(Database.BatchableContext bc) {}
    global override void doExecute(Database.BatchableContext bc, List<sobject> scope) {
        if(scope != null){
            DELETE scope;
        }
    }
    global override void doInitialize() {}
    global override void doFinish(Database.BatchableContext bc) {}
}