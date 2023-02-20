public class importDataFromCSVController {
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<Restructure_Staging__c> conlist{get;set;}
    public importDataFromCSVController(){
        csvFileLines = new String[]{};
        conlist = New List<Restructure_Staging__c>();
        
    }
    public void runBatch(){
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Something went wrong.Check logs');
        try{
            RestructureJob job = new RestructureJob(1);
            Database.executeBatch(job, 1);
        }
        catch (Exception e)
        {
            
            ApexPages.addMessage(errorMessage);
        }
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
    public void updateAccuralDates(){
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Something went wrong.Check logs');
        try{
            List<Restructure_Staging__c> restList = [SELECT id,Name,Restructure_Date__c,LS_Contract__c from Restructure_Staging__c];
            Map<String, Date> resContractMap = new Map<String, Date>();
            for(Restructure_Staging__c s : restList){
                resContractMap.put(s.Name,s.Restructure_Date__c);
            }
            Map<String, Id> contractMap = new Map<String, ID>();
            List<Cllease__Lease_Account__c> lAccList = database.query(initialize(resContractMap));
            for(Cllease__Lease_Account__c con : lAccList){
                contractMap.put(con.Name,con.id);
                if(resContractMap.containsKey(con.Name)) {
                	con.cllease__Next_Income_Accrual_Date__c = resContractMap.get(con.Name);
                }
            }
            for(Restructure_Staging__c s : restList){
                if(contractMap.containsKey(s.Name)) {
                    s.LS_Contract__c = contractMap.get(s.Name);
                }
            }
            update restList;
            update lAccList;
            conlist = [SELECT id,Name,Restructure_Date__c,LS_Contract__r.cllease__Next_Income_Accrual_Date__c,LS_Contract__r.cllease__Contract_Restructured__c from Restructure_Staging__c];
            
        }
        catch (Exception e)
        {
            
            ApexPages.addMessage(errorMessage);
        }
    }
    public static string initialize(Map<String, Date> contractDetails) {
        String query = 'SELECT Id, Name, cllease__Restructured_Contract__c,cllease__Next_Income_Accrual_Date__c FROM Cllease__Lease_Account__c WHERE Name in (' +  getStringFromIds(contractDetails.keySet()) + ')' ;
        System.debug(LoggingLevel.ERROR, '^^^^ query : ' + query);
        return query;
    }
    
    public void importCSVFile(){
        conlist = New List<Restructure_Staging__c>();
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
        try{
            List<Restructure_Staging__c> resList = [Select id,Name from Restructure_Staging__c];
            if(!reslist.isEmpty()) {
                delete resList;
            }
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            for(Integer i=1;i<csvFileLines.size();i++){
                Restructure_Staging__c resObj = new Restructure_Staging__c() ;
                string[] csvRecordData = csvFileLines[i].split(',');              
                resObj.name = csvRecordData[0];
                resObj.Restructure_Date__c = Date.valueof(csvRecordData[1]);
                conlist.add(resObj);
            }
            insert conlist;
        }
        catch (Exception e)
        {
            
            ApexPages.addMessage(errorMessage);
        }
    }
}