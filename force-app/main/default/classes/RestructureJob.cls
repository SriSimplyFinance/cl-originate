global with sharing virtual class RestructureJob extends clcommon.DynamicJob implements Database.AllowsCallouts{
    
    private Integer action;
    private static Set<String> contractNames;

    global RestructureJob(Integer actionCode){
        action = actionCode;
    }
    global override String getRuntimeQuery(){
        return 'SELECT id,Name,Restructure_Date__c,LS_Contract__c from Restructure_Staging__c'; 
    }

    public static string initialize(Map<String, String> contractDetails) {
        contractNames = contractDetails.keySet();
        String query = 'SELECT Id, Name, cllease__Restructured_Contract__c,cllease__Next_Income_Accrual_Date__c FROM Cllease__Lease_Account__c WHERE Name in (' +  getStringFromIds(contractNames) + ')' ;
        System.debug(LoggingLevel.ERROR, '^^^^ query : ' + query);
        return query;
    }
    
    public static String getStringFromIds(Set<String> contractNames) {
        String contractNameStr = '';
        if(contractNames == null || contractNames.size() == 0) {
            return contractNameStr;
        }
        for (String contractName : contractNames) {
          contractNameStr = contractNameStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
        }
        contractNameStr = contractNameStr.substring(0, contractNameStr.length() - 1);
        return contractNameStr;
    }
    
    public override void doInitialize() { }

    public override void doStart(Database.BatchableContext bc) { }
    
    public override void doFinish(Database.BatchableContext bc) {
		if(action == 1){
            RestructureJob job = new RestructureJob(2);
            Database.executeBatch(job, 1);
        }
    }
    
    public override void doExecute(Database.BatchableContext bc,List<sobject> scope) {
        Date sodDate;
        Map<String, String> contractMap = new Map<String, String>();
        for(sobject s : scope){
            Restructure_Staging__c restStagg = (Restructure_Staging__c)s;
            System.debug(LoggingLevel.ERROR, '^^^^ s : ' + s);
            contractMap.put(restStagg.Name,'0');
            sodDate = restStagg.Restructure_Date__c;
        }
        String contractQuery = initialize(contractMap);
        List<Cllease__Lease_Account__c> lAccList = database.query(contractQuery);
        system.debug('lAccList'+lAccList);
        RestructureHandler restructureHdlr = new RestructureHandler(lAccList, sodDate, 0, contractMap);
        restructureHdlr.process(bc.getJobId(), action);        
        if(action == 2){
            List<Cllease__Lease_Account__c> updatelAccList = new List<Cllease__Lease_Account__c>();
            for(Cllease__Lease_Account__c ls :lAccList) {
                system.debug('------->>'+lAccList);
                system.debug('------->>'+sodDate);
                ls.cllease__Next_Income_Accrual_Date__c = sodDate;
                updatelAccList.add(ls);
                system.debug('------->>'+lAccList);
            }
            update updatelAccList;
        }
    }
}