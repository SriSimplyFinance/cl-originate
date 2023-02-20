/**
 * Following Global class will be using for CLO Application to Contract Creation
 * Need to mention following class NAME with namespace to Use for conversion process
 * Setup:
 *      Custom settings
 *      --> Custom Logic Parameters(genesis)
 *      --> Edit
 *      --> genesis__Custom_Contract_Generation_Class__c = 'cllease.ContractProcessor'
 * Note:
 *     ContractProcessor not bulkied, it should call with batch size = 1
 */
global virtual class ContractProcessor1 implements clcommon.IContractProcessor {

    private cllease__Lease_Account__c leaseAccount;
    private SObject product;
    private SObject purpose;
    private sObject application;
    private Map<String, List<SObject>> childObjects;
    private Map<String,Id> contEquipmentIdMap;
    private Map<String,Id> partyContractPartyMap;
    private Map<String,Id> feeToContractFeeMap;

    /**
     *  Getting details from clcommon.ApplicationContractBO for Contract Processing
     */
    global virtual Map<Id, SObject> createContracts(List<clcommon.ApplicationContractBO> appContracts) {
        System.debug(LoggingLevel.Error ,'In custom class');
        if(appContracts == null || appContracts.size() == 0) {
            return null;
        }
        /**
         *  Creating [Application,Contract] Map for tracking details
         */
        Map<Id, SObject> appToContract = new Map<Id, SObject>();
        for(clcommon.ApplicationContractBO app:appContracts) {
            this.leaseAccount   = (cllease__Lease_Account__c)app.getContract();
            this.product        = app.getProduct();
            this.purpose        = app.getPurpose();
            this.childObjects   = app.getChildObjects();
            this.application    = app.getApplication();
            this.processContract(app.getApplication().Id);
            appToContract.put(app.getApplication().Id, leaseAccount);
        }
        return appToContract;
    }

    /**
     *  Internal helper class to process Contract
     *  methods helps in contract creation , GenerateStreams and ActivateContract based on the Application's Status
     */
    private void processContract(Id applicationId) {
        System.debug(Logginglevel.Error, 'Contract Conversion Process Starting for Application: '+application.get('Name'));
        cllease__Lending_Account_Validation__c loggingValidation = new cllease__Lending_Account_Validation__c();
        cllease.ContractBuilder builder;
        String response;

        SavePoint sp = Database.setSavePoint();
        /**
         * 1. Insert Contract and also linked Child Objects
         *    and creating 2 SavePoint to make sure contract create happens
         *    if failure comes from regenerate streams and activate contract
         */
        try {
            // Getting Product details which links to CL Lease Product
            this.getLeaseProduct();
            /**
             * 1. Create LS Contract through ContractBuilder
             */
            builder = new cllease.ContractBuilder(leaseAccount);
            builder.addChildObjects(childObjects);
            builder.setSkipCalcSetup();
            response = builder.createContract(null);
            System.debug(LoggingLevel.DEBUG, 'Lease Account Details in ContractProcessor: '+leaseAccount);
            System.debug(LoggingLevel.DEBUG, 'Child Object Details in ContractProcessor: '+childObjects);
            if(!response.containsIgnoreCase('Contract Creation Successful')) {
                throw new cllease.LeaseServicingException(response, 'ERROR');
            }
            contEquipmentIdMap = new Map<String,Id>();
            partyContractPartyMap = new Map<String,Id>();
            feeToContractFeeMap = new map<String,Id>();
            
            /**Code by Mohini start
             * Give a lookup to Contract Party and create one formula field that will have an Account Id associated with the Party and map formula field
            This code creates contract fee payments related to Expense Fee. In CLO a lookup field to Account "Pay To"
            will be given while creating Expense Fee. This will be mapped to Fee Schedule in CL Lease also. 
Assumption : Party is already added for the selected account in Expense Fee otherwise Fee Payments won't be created and application conversion will fail.

            //Create a field called "Pay To" Lookup to Account at genesis fee schedule and also at cllease fee schedule. Map field in conversion mapping
            */
           List<cllease__Contract_Fees__c> feeSchedules = [Select Id,
                                                           		  Pay_To_Account_Id__c,
                                                            	  cllease__Expense_Fee__c
                                                           from cllease__Contract_Fees__c 
                                                           where cllease__Contract__c = :leaseAccount.Id
                                                           And cllease__Fee_Definition__r.clcommon__Class__c = 'EXPENSE'
                                                           And Pay_To_Account_Id__c != null];
            System.debug(LoggingLevel.Error,'feeSchedules == ' + feeSchedules);
            if(!feeSchedules.isEmpty()){
                List<cllease__Contract_Parties__c> parties = [Select Id,
                                                              		cllease__Party_Account_Name__r.Name
                                                              From cllease__Contract_Parties__c
                                                              Where cllease__Contract__c =: leaseAccount.Id];
                
                Map<String,Id> partyAccountIdVspartyIdMap = new Map<String,Id>();
                for(cllease__Contract_Parties__c party : parties){
                  //  patryAccountIdVspartyIdMap.put(party.cllease__Party_Account_Name__r.Name,party.Id);
                  partyAccountIdVspartyIdMap.put(((String)party.cllease__Party_Account_Name__c).substring(0,15),party.Id);
                }
                System.debug(LoggingLevel.Error,'partyAccountIdVspartyIdMap == ' + partyAccountIdVspartyIdMap);
                List<cllease__Contract_Fee_Payment__c> feePayments = new List<cllease__Contract_Fee_Payment__c>();
                for(cllease__Contract_Fees__c feeSchedule : feeSchedules){
                    //If party is already added for "Pay To" Account
                    if(partyAccountIdVspartyIdMap.containskey(feeSchedule.Pay_To_Account_Id__c.subString(0,15))){ 
                        cllease__Contract_Fee_Payment__c feePayment = new cllease__Contract_Fee_Payment__c();
                        feePayment.cllease__Contract__c = leaseAccount.id;
                        feePayment.cllease__Contract_Fee__c = feeSchedule.cllease__Expense_Fee__c;
                        feePayment.cllease__Payment_Percentage__c = 100;
                        //Getting party Related to Account Id selected in Fee Schedule.
                        feePayment.cllease__Pay_To__c = partyAccountIdVspartyIdMap.get(feeSchedule.Pay_To_Account_Id__c.subString(0,15)); 
                        System.debug('Pay to = =' +feePayment.cllease__Pay_To__c);
                        feePayments.add(feePayment);
                    }
                }
                if(feePayments.size()>0){
                	insert feePayments;
                }
            }

        } catch(Exception e) {
            //Database.rollback(sp);
            //throw is needed as CL O might want to throw its own exception and also error code.
            throw e;
        }


    }

    /**
     * Hence if an explicit mapping is not provided,
     * Passed product's instance is supposed to have a lending product's lookup
     */
   private void getLeaseProduct() {
        if(this.product != null && this.leaseAccount.cllease__Lease_Product_Name__c == null) {
            String cloProductID = (String)this.product.get('id');
            if(cloProductID != null) {
                List<cllease__Lease_Product__c> products = [Select Id,Name
                                                    From cllease__Lease_Product__c
                                                    Where cllease__CL_Product__c =:cloProductID ];
                if(products.size()>0) {
                    this.leaseAccount.cllease__Lease_Product_Name__c = products[0].id;
                }
            }
        }
    }
}