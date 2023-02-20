/*=========================================================== PART 2 ==========================================================================*/
/*========================================================= PART 1 ===============================================================*/

/**

* Copies Expense_Fees__c to Contract_Fees__c

* creates Expense_Fees__c for fee definition present in fee set of the contract

*/

public class ExpenseFeesDataMigrator extends cllease.LeaseDynamicJob {

    private final static String JOB_NAME = 'Upgrade Job';

    private String nsPrefix = 'cllease'; 

    

    public ExpenseFeesDataMigrator() {

        super(JOB_NAME, null);

        if(String.isEmpty(nsPrefix)) {

            nsPrefix = '';

        } else {

            nsPrefix += '__';

        }

    }

    

    

    public override void doInitialize() {}

    

    public override String getRuntimeQuery() {

        String query = 'SELECT Id, Name, ' +

                            nsPrefix + 'Fee_Set1__c, ' +

                            nsPrefix + 'Contract_Date__c, ' +

                            '(SELECT Id, Name, ' +

                                nsPrefix + 'Amount__c, ' +

                                nsPrefix + 'Fee_Definition__c, ' +

                                nsPrefix + 'Frequency__c, ' +

                                nsPrefix + 'Number_of_Periods__c, ' +                              

                                nsPrefix + 'Account__c, ' +

                                nsPrefix + 'Transaction_Sub_Type__c ' +

                            'FROM ' + nsPrefix + 'Expense_Fees__r), ' +

                            '(SELECT Id, Name, ' +

                                nsPrefix + 'Contract_Fee__c, ' +

                                nsPrefix + 'Expense_Fee__c ' +

                            'FROM ' + nsPrefix + 'Fee_Streams__r) ' +

                        ' FROM ' + nsPrefix + 'Lease_Account__c';

        System.debug(LoggingLevel.ERROR, 'query : ' + query);

        return query;            

    }

    

    public override void doStart(Database.BatchableContext bc) {}

 

    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {

        /**

        * 1) Query all contract's fee set's fee

        * 1a) insert expense_fees__c (fee configuration for all the fees in the fee set for each contract), with this maintain a map of fee def to expense_fees__c

        * 1b) insert parties for all expense fee's "Account" with some party type, a map of account id to party

        * 2) insert contract_fees__c for all expense fees, maintain a map of expense_fees__c to contract_fees__c

        * 3)

        * 4) iterate over old expense fees and create a fee payment

        **/

        SavePoint sp = Database.setSavePoint();

        try {

            List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;

            List<Id> feeSetIds = new List<Id>();

            

            Map<Id, ContractDetail> contractDetailsByContractId = new Map<Id, ContractDetail>();

            List<cllease__Contract_Parties__c> partiesToInsert = new List<cllease__Contract_Parties__c>();

            List<cllease__Contract_Fees__c> newExpenseFeesToInsert = new List<cllease__Contract_Fees__c>();

            List<cllease__Expense_Fees__c> confFeesToInsert = new List<cllease__Expense_Fees__c>();

            for(cllease__Lease_Account__c contract : contracts) {

                ContractDetail detail = new ContractDetail();

                detail.contract = contract;

                contractDetailsByContractId.put(contract.Id, detail);

                if(contract.cllease__Fee_Set1__c != null) {

                    detail.feeSetPresent = true;

                    feeSetIds.add(contract.cllease__Fee_Set1__c);

                }

            }

            Map<Id, List<clcommon__Fee_Definition__c>> feesByFeeSetId = cllease.LeaseFeeUtil.getFeesInFeeSets(feeSetIds, null);

            

            System.debug(LoggingLevel.ERROR, 'after getting fees in feeset : ' + feesByFeeSetId.size());

            //insert fee config(cllease__expense_fees__c)

            

            for(cllease__Lease_Account__c contract : contracts) {

                

                //check if this contract is a new one - created after upgrade

                //in this case expense fee should have frequency and number of periods          

                //Also check if we already have fee configuration for any fee defs

                

                ContractDetail detail = contractDetailsByContractId.get(contract.Id);

                for(cllease__Expense_Fees__c oldExpenseFee : contract.cllease__Expense_Fees__r) {

                    //it is actually an old expense fee

                    if(oldExpenseFee.cllease__Number_Of_Periods__c != null) { //&& oldExpenseFee.cllease__Frequency__c != null

                        if(!detail.feeSetPresent) {

                            throw new ProcessingException('Contract ' + contract.name + ' does not have a fee set but is having expense fee to be migrated');

                        }

                        detail.oldExpenseFees.add(oldExpenseFee);

                    } else { //this is a fee config

                        detail.feeDefsForExistingConfs.add(oldExpenseFee.cllease__Fee_Definition__c);

                    }

                }

                //if expnese fees and fee set are not present we do not want process

                if(contract.cllease__Fee_Set1__c == null) {

                    continue;

                }

                

                for(clcommon__Fee_Definition__c feeDef : feesByFeeSetId.get(contract.cllease__Fee_Set1__c)) {

                    if(!detail.feeDefsForExistingConfs.contains(feeDef.Id)) {

                        cllease__Expense_Fees__c feeConf = new cllease__Expense_Fees__c();

                        feeConf.cllease__Contract__c = contract.Id;

                        feeConf.cllease__Fee_Definition__c = feeDef.Id;

                        feeConf.cllease__Type__c = feeDef.clcommon__Fee_Type__c;

                        feeConf.cllease__Apply_Pre_Bill_Days__c = feeDef.clcommon__Apply_Pre_Bill_Days__c;

                        detail.feeConfsByFeeDefId.put(feeDef.Id, feeConf);

                        confFeesToInsert.add(feeConf);

                    }

                }

            }      

            insert confFeesToInsert;

            for(cllease__Lease_Account__c contract : contracts) {

                ContractDetail detail = contractDetailsByContractId.get(contract.Id);

                if(detail.oldExpenseFees.size() > 0) {              

                    //contractDetails.add(detail);

                    for(cllease__Expense_Fees__c oldExpenseFee : detail.oldExpenseFees) {

                        if(oldExpenseFee.cllease__Account__c != null) {

                            if(!detail.partyByAccountId.containsKey(oldExpenseFee.cllease__Account__c)) {

                                cllease__Contract_Parties__c newParty = new cllease__Contract_Parties__c(cllease__Party_Account_Name__c = oldExpenseFee.cllease__Account__c,

                                                                        cllease__Contract__c = contract.Id,

                                                                        cllease__Party_Type__c = 'VENDOR');                         

                                detail.partyByAccountId.put(oldExpenseFee.cllease__Account__c, newParty); 

                                partiesToInsert.add(newParty);

                            }

                        }

                        //get new expense fee (fee schedule - cllease__contract_fees__c)

                        //there can be a case where old expense fee can be on a fee def which was not part of the fee set

                        //in this case we are throwing an excpetion

                        if(!detail.feeConfsByFeeDefId.containsKey(oldExpenseFee.cllease__Fee_Definition__c)) {

                            throw new ProcessingException('Fee for expense fee' + oldExpenseFee.Name + ' is not part of the contract\'s fee set');

                        }

                        cllease__Contract_Fees__c newExpenseFee = new cllease__Contract_Fees__c(cllease__Fee_Definition__c = oldExpenseFee.cllease__Fee_Definition__c,

                                                                                cllease__Amount__c = oldExpenseFee.cllease__Amount__c,

                                                                                cllease__Contract__c = contract.Id,

                                                                                cllease__Start_Date__c = contract.cllease__Contract_Date__c,

                                                                                cllease__Frequency__c = oldExpenseFee.cllease__Frequency__c,

                                                                                cllease__Number_of_Periods__c = oldExpenseFee.cllease__Number_of_Periods__c,

                                                                                cllease__Total_Payment_Amount__c = oldExpenseFee.cllease__Amount__c,

                                                                                cllease__Expense_Fee__c = detail.feeConfsByFeeDefId.get(oldExpenseFee.cllease__Fee_Definition__c).Id,

                                                                                cllease__VAT__c = 0);

                        detail.newExpenseFeeByOldExpenseFeeId.put(oldExpenseFee.Id, newExpenseFee);

                        newExpenseFeesToInsert.add(newExpenseFee);

                    }

                }

            }

            insert partiesToInsert;

            insert newExpenseFeesToInsert;

            List<cllease__Fee_Stream__c> feeStreamsToUpdate = new List<cllease__Fee_Stream__c>();

            List<cllease__Expense_Fees__c> expenseFeesToDelete = new List<cllease__Expense_Fees__c>();

            List<cllease__Contract_Fee_Payment__c> contractFeePayments = new List<cllease__Contract_Fee_Payment__c>();

            //insert contract fee payment now

            for(cllease__Lease_Account__c contract : contracts) { 

                ContractDetail detail = contractDetailsByContractId.get(contract.Id);

                for(cllease__Expense_Fees__c oldExpenseFee : detail.oldExpenseFees) {

                    if(oldExpenseFee.cllease__Account__c != null

                            && contractDetailsByContractId.get(contract.Id).newExpenseFeeByOldExpenseFeeId.containsKey(oldExpenseFee.Id)) {

                        if(contractDetailsByContractId.get(contract.Id).partyByAccountId.containsKey(oldExpenseFee.cllease__Account__c)) {

                            //check with Siva for start date, end date and percentage

                            cllease__Contract_Fee_Payment__c payment = new cllease__Contract_Fee_Payment__c(cllease__Contract_Fee__c = contractDetailsByContractId.get(contract.Id).feeConfsByFeeDefId.get(oldExpenseFee.cllease__Fee_Definition__c).Id,

                                                                        cllease__Contract__c = contract.id,

                                                                        cllease__Pay_To__c = contractDetailsByContractId.get(contract.Id).partyByAccountId.get(oldExpenseFee.cllease__Account__c).Id);

                            contractFeePayments.add(payment);

                        }

                    }

                }

                //delete old expense fees

                expenseFeesToDelete.addAll(detail.oldExpenseFees);

                for(cllease__Fee_Stream__c feeStream : contract.cllease__Fee_Streams__r) {

                    if(feeStream.cllease__Expense_Fee__c != null && detail.newExpenseFeeByOldExpenseFeeId.containsKey(feeStream.cllease__Expense_Fee__c)) {                      

                        feeStream.cllease__Contract_Fee__c = detail.newExpenseFeeByOldExpenseFeeId.get(feeStream.cllease__Expense_Fee__c).Id;

                        feeStream.cllease__Expense_Fee__c = null;

                        feeStreamsToUpdate.add(feeStream);

                    }

                }      

            }

            insert contractFeePayments;

            update feeStreamsToUpdate;

            delete expenseFeesToDelete;

        } catch(Exception e) {

            Database.rollback(sp);

            System.debug(LoggingLevel.ERROR, 'Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());

        }

    }

 

    public override void doFinish(Database.BatchableContext bc) {

    

    }

    

    private class ContractDetail {

        cllease__Lease_Account__c contract;

        Map<Id, cllease__Expense_Fees__c> feeConfsByFeeDefId = new Map<Id, cllease__Expense_Fees__c>();

        Map<Id, cllease__Contract_Parties__c> partyByAccountId = new Map<Id, cllease__Contract_Parties__c>();

        Map<Id, cllease__Contract_Fees__c> newExpenseFeeByOldExpenseFeeId = new Map<Id, cllease__Contract_Fees__c>(); 

        Set<Id> feeDefsForExistingConfs = new Set<Id>();

        List<cllease__Expense_Fees__c> oldExpenseFees = new List<cllease__Expense_Fees__c>();

        Boolean feeSetPresent = false;   

    }

    

    class ProcessingException extends Exception {

    }

}

//------------------Part 2-------------------
//ExpenseFeesDataMigrator job = new ExpenseFeesDataMigrator();
//Database.executeBatch(job);