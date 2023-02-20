public class CopyFieldValue implements Database.Batchable<sObject>{

    private String sourceAPIName;

    private String destFeeAPIName;

    private String objectName;

    private String feeOrFeeSet; // FEE, FEESET

    private Map<Id, String> oldMap;

    private Map<String, Id> newMap;

    private String ns; 

   

    public CopyFieldValue(String objectName, String sourceAPIName, String destFeeAPIName, String feeOrFeeSet, String ns) {

        this.objectName     = objectName;

        this.sourceAPIName  = sourceAPIName;

        this.destFeeAPIName = destFeeAPIName;

        this.feeOrFeeSet    = feeOrFeeSet;

        this.ns = ns;

        initialize();

    }  

    

    private void initialize() {

        Map<Id, String> oldnamespacePrefix = new Map<Id, String>();

        Map<Id, String> oldfeeSetMap = new Map<Id, String>();

        Map<String, Id> namespacePrefix = new Map<String, Id>();

        Map<String, Id> feeSetNameMap = new Map<String, Id>();

        

        if(feeOrFeeSet == 'FEE') {

            String query = ' Select id, Name From '+ ns +'Fee__c ';

            List<sobject> oldFees = Database.query(query);

            for(sobject fee : oldFees) {

                System.debug(LoggingLevel.ERROR, '---fee: '+fee);

                oldnamespacePrefix.put((ID)fee.get('ID'), (String)fee.get('name'));

            }

            List<clcommon__Fee_Definition__c> newFees = [Select id, name From clcommon__Fee_Definition__c];

            for(clcommon__Fee_Definition__c feeDef : newFees) {

                namespacePrefix.put(feeDef.name, feeDef.Id);

            }

            oldMap = oldnamespacePrefix;

            newMap = namespacePrefix;

            

        } else {

            String query = ' Select id, Name From '+ ns +'Fee_Set__c ';

            List<sobject> oldFeeSet = Database.query(query);

            for(sobject feeSet: oldFeeSet) {

                oldfeeSetMap.put((ID)feeSet.get('ID'), (String)feeSet.get('name'));

            }

 

            List<clcommon__Fee_Set__c> newFeeSet = [Select id, name From clcommon__Fee_Set__c];

            for(sobject feeSet: newFeeSet) {

                feeSetNameMap.put((String)feeSet.get('name'), feeSet.Id);

            }         

            oldMap = oldfeeSetMap;

            newMap = feeSetNameMap;

        }

    }

    

    public Database.QueryLocator start(Database.BatchableContext BC){

        String query =' Select id, name, '+

                       sourceAPIName+', '+

                       destFeeAPIName +

                      ' From '+ objectName;  

        return Database.getQueryLocator(query);

    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){           

        // Replacing cllease fee link with clcommon fee defination link for objects.

        Set<Id> objectIds = new Set<Id>();

        Map<Id, sObject> objectMap = new Map<Id, sObject>();

        for(sObject obj : scope) {

            if(feeOrFeeSet == 'FEE'){

                if(obj.get(ns+'Fee__c') != null){

                    obj.put(destFeeAPIName, newMap.get(oldMap.get((ID)obj.get(sourceAPIName))));

                    objectIds.add((Id)obj.get('Id'));

                }

            }

            else{

                obj.put(destFeeAPIName, newMap.get(oldMap.get((ID)obj.get(sourceAPIName))));

                objectIds.add((Id)obj.get('Id'));

            }

        }

        // Update the mapped fields.

        update scope;

        

        // Extra processing for objects: Contract_Fees__c , Charge__c. check for updating Expense_Fee__c link

        if(objectName == ns +'Contract_Fees__c' || objectName == ns +'Charge__c') {

            Set<Id> contractIds = new Set<Id>();

            Map<Id, Map<Id, Id>> feeToContractFeeMapMap = new Map<Id, Map<Id, Id>>();

            List<sObject> objects;

            // DO another query for contract field & get all contractIds in Set

            if(objectName == ns+'Contract_Fees__c') {

                objects = Database.query('Select Id, Name, '+ ns + 'Contract__c, '+ ns + 'Expense_Fee__c, '+

                                            sourceAPIName+', '+ destFeeAPIName +

                                        ' From '+objectName+ ' Where id in :objectIds');

                for(sobject obj: objects) {

                    contractIds.add((ID)obj.get(ns + 'Contract__c'));

                }

            } else if(objectName == ns+'Charge__c') {

                objects = Database.query('Select Id, Name, '+ ns + 'Lease_Account__c, '+ ns + 'Expense_Fee__c, '+

                                            sourceAPIName+', '+ destFeeAPIName +

                                        ' From '+objectName+ ' Where id in :objectIds');

                for(sobject obj: objects) {

                    contractIds.add((ID)obj.get(ns + 'Lease_Account__c'));

                }

            }

 

            if(contractIds.size() == 0) return;

            

            // Do run query Object: Expense_Fees__c for creating Map<feeId, ContractFeeId>

            List<sObject> contractFeeObjects = Database.query('Select Id, '+ ns + 'Fee_Definition__c, '+ ns + 'Contract__c '+

                                                            ' From '+ ns + 'Expense_Fees__c ' +

                                                            ' Where '+ ns + 'Contract__c in :contractIds');

            

            if(contractFeeObjects == null || contractFeeObjects.size() == 0) return;

 

            for(sobject obj : contractFeeObjects) {

                if(feeToContractFeeMapMap.containsKey((Id)obj.get(ns + 'Contract__c'))) {

                    Map<Id, Id> feeContractFeeMap = feeToContractFeeMapMap.get((Id)obj.get(ns + 'Contract__c'));

                    if(feeContractFeeMap==null) {

                        feeContractFeeMap = new Map<Id, Id> {(Id)obj.get(ns + 'Fee_Definition__c') => (Id)obj.get('Id')};

                    } else if(!feeContractFeeMap.containsKey((Id)obj.get(ns + 'Fee_Definition__c'))){

                        feeContractFeeMap.put((Id)obj.get(ns + 'Fee_Definition__c') , (Id)obj.get('Id'));

                    }

                    feeToContractFeeMapMap.put((Id)obj.get(ns + 'Contract__c'), feeContractFeeMap);

                } else {

                    feeToContractFeeMapMap.put((Id)obj.get(ns + 'Contract__c'),

                        new Map<Id, Id> {(Id)obj.get(ns + 'Fee_Definition__c') => (Id)obj.get('Id')});

                }

            }

            

            // Update Expense_Fee__c on objects.

            if(objectName == ns+'Contract_Fees__c') {

                for(sObject obj : objects) {

                    obj.put(destFeeAPIName, newMap.get(oldMap.get((ID)obj.get(sourceAPIName))));

                    obj.put(ns + 'Expense_Fee__c', feeToContractFeeMapMap.get((Id)obj.get(ns + 'Contract__c')).get((ID)obj.get(destFeeAPIName)));

                }

            } else if(objectName == ns+'Charge__c') {

                for(sObject obj : objects) {

                    obj.put(destFeeAPIName, newMap.get(oldMap.get((ID)obj.get(sourceAPIName))));

                    obj.put(ns + 'Expense_Fee__c', feeToContractFeeMapMap.get((Id)obj.get(ns + 'Lease_Account__c')).get((ID)obj.get(destFeeAPIName)));

                }

            }

            

            update objects;

        }             

    }

    public void finish(Database.BatchableContext BC){}

}