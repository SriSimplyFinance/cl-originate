public class ContractRestructureWrapper {
    
    Public Date startDate; // Cannot be blank
    Public Integer noOfPeriods; //Must be greater than 0
    Public String SelectedOperation; // can not be blank
    Public List<Id> feeIdsToBeUpdated; //Null in case of selected operation doesn't support or user has not selected any fee 
    Public Set<String> contractNames; // Null if operation selected is Payment By Percentage otherwise list of contract names to be processed
    Public Map<String,String> contractNamePmtAmtMap; // Not null only in case if operation selected is PAYMENT UPDATE (UPLOAD IN CSV)
    Public String selectedFeeOption; //Applicable only if operation selected is PAYMENT UPDATE (UPLOAD IN CSV) or Fee Update
    
    public ContractRestructureWrapper(Date StartDate, Integer noOfPeriods, String selectedOperation, String selectedFeeOption){
        this.startDate = startdate;
        this.noOfPeriods = noOfPeriods;
        this.selectedOperation = selectedOperation;
        this.selectedFeeOption = selectedFeeOption;
    }
    /*
    Public static String getStringFromSet(Set<String> contractIds) {
        String idStr = '';
        if(contractIds == null || contractIds.size() == 0) {
            return idStr;
        }
        for (String contractId : contractIds) {
          idStr = idStr + '\'' + String.escapeSingleQuotes(contractId) + '\'' + ',';
        }
        idStr = idStr.substring(0, idStr.length() - 1);
        System.debug('idStr: ' + idStr);
        return idStr;
    }*/

}