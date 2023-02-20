@isTest
public class TestContractProcessor1 {
    static Account borrower;
    static cllease__Lease_Product__c dummyLP;
    static cllease__Payment_Mode__c anyPaymentMode;
    
    @testSetup
    public static void  dataSetup(){
        cllease.TestHelper.createSeedDataForTesting();
        cllease.TestHelper.integrateWithSFCRM();
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = createLeaseFeeJunction(dummyFee,dummyFeeSet);
        
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice();
        
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLeaseProduct = cllease.TestHelper.createLeaseProduct(
            dummyOffice,
            dummyFeeSet);
        
        HelperClass1.firstRunCustomer = false;
        List<Account> accounts = new List<Account>();
        Account borrowerAccount = new Account(Name = 'Borrower');
        accounts.add(borrowerAccount);
        
        Account borrowerAccount2 = new Account(Name = 'Borrower2');
        accounts.add(borrowerAccount2);
        insert(accounts);
        
        /* saf_zoho__c safZoho = new saf_zoho__c();
safZoho.zoho_AccessEndpoint__c = 'sample';
insert safZoho;*/
    }
    
    public static  clcommon__Fee_Junction__c createLeaseFeeJunction(clcommon__Fee_Definition__c  fee, clcommon__Fee_Set__c  feeSet) {
        clcommon__Fee_Junction__c dummyFeeJunction = new clcommon__Fee_Junction__c(clcommon__Fee__c = fee.ID,
                                                                                   clcommon__Fee_Set__c  = feeSet.ID);
        insert(dummyFeeJunction);
        return dummyFeeJunction;
    }
    
    private static void querySetupData() {
        dummyLP = [SELECT Id, Name, cllease__Maturity_Calculation_Base__c
                   FROM cllease__Lease_Product__c
                   WHERE cllease__Lease_Product_Type__c = :cllease.LeaseConstants.LEASE];
        dummyLP.cllease__Maturity_Calculation_Base__c = False;
        update(dummyLP);
        borrower = [SELECT Id, Name
                    FROM Account 
                    Where Name ='Borrower'];
        
    }
    public static testMethod void createContractsInPartialApplication() {
        querySetupData();
        cllease__Lease_Account__c leaseAccount = new cllease__Lease_Account__c(cllease__Financed_Amount__c = 10000,
                                                                               cllease__Product_Type__c = cllease.LeaseConstants.LEASE,
                                                                               cllease__Account__c = borrower.Id,
                                                                               cllease__Lease_Product_Name__c = dummyLP.Id,
                                                                               cllease__Term__c = 12,
                                                                               cllease__Contract_Date__c = Date.parse('01/07/2016'),
                                                                               cllease__First_Payment_Date__c = Date.parse('01/07/2016'),
                                                                               cllease__Maturity_Date__c = Date.parse('30/06/2017')); //Other values should be defaulted
        
        cllease__Contract_Parties__c party = new cllease__Contract_Parties__c(cllease__Party_Type__c='LESSEE',
                                                                              cllease__Party_Account_Name__c=borrower.id);
        
        Account broker = [Select id from Account where name = 'Borrower2'];
        cllease__Contract_Parties__c party1 = new cllease__Contract_Parties__c(cllease__Party_Type__c='BROKER',
                                                                               cllease__Party_Account_Name__c=broker.id);
        List<SObject> parties = new List<cllease__Contract_Parties__c> {party,party1};
            /**
* Creating Contract Equipments
*/
            List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));
        
        /**
* Creating Payment Schedule
*/
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                            cllease__Frequency__c=cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                            cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                            cllease__Payment_Date__c=Date.parse('01/07/2016')));
        
        
        clcommon__Fee_Definition__c fees = [Select id from clcommon__Fee_Definition__c limit 1];
        fees.clcommon__Class__c = 'EXPENSE';
        update fees;
        
        List<cllease__Contract_Fees__c> feeSchedules = new List<cllease__Contract_Fees__c>();
        cllease__Contract_Fees__c contfee = new cllease__Contract_Fees__c();
        // contfee.contract__c = leaseAccount.id;
        contfee.cllease__Capitalize__c = false;
        contfee.cllease__Capitalize__c = false;
        contfee.cllease__Fee_Type__c  = 'AMORTIZED FEES';
        contfee.cllease__Fee_Definition__c= fees.id;
        //contfee.cllease__Expense_Fee__c = fees[0].Id;
        contfee.cllease__amount__c =  500;
        contfee.cllease__Total_Payment_Amount__c =  500;
        contfee.cllease__VAT__c =  0;
        contfee.cllease__Number_of_Periods__c = 1;
        contfee.cllease__start_date__c = leaseAccount.cllease__First_Payment_Date__c;
        contFee.Pay_To_Account_Id__c = broker.Id;
        contFee.cllease__Frequency__c = 'MONTHLY';
        feeSchedules.add(contfee);
        
        //we will a pass a dummy object instead of CL O application
        Map<String, List<SObject>> childObjects = new Map<String, List<SObject>>();
        childObjects.put('cllease__Contract_Parties__c',parties);
        childObjects.put('cllease__Contract_Equipment__c',contractEquipments);
        childObjects.put('cllease__Payment_Schedule__c',paymentDetails);
        childObjects.put('cllease__Contract_Fees__c',feeSchedules);
        
        
        
        //we will a pass a dummy object instead of CL O application
        clcommon.ApplicationContractBO appContract = new clcommon.ApplicationContractBO();
        //appContract.setProduct(dummyLP);
        appContract.setApplication(dummyLP);
        appContract.setContract(leaseAccount);
        appContract.setChildObjects(childObjects);
        
        HelperClass1.firstRun = false;
        ContractProcessor1 processor = new ContractProcessor1();
        Map<Id, SObject> res = processor.createContracts(new List<clcommon.ApplicationContractBO>{appContract});
        
        List<cllease__Lease_Account__c> leaseAccounts = [SELECT Id, Name,
                                                         cllease__Account__c,
                                                         cllease__Lease_Product_Name__c,
                                                         cllease__Lease_Status__c,
                                                         cllease__Financed_Amount__c,
                                                         cllease__Term__c
                                                         FROM cllease__Lease_Account__c];
        System.assert(leaseAccounts.size() == 1);
        System.assert(leaseAccounts.get(0).cllease__Lease_Status__c.equalsIgnoreCase(cllease.LeaseConstants.LEASE_STATUS_PARTIAL_APPLICATION));
        System.assert(leaseAccounts.get(0).cllease__Financed_Amount__c == 10000);
        System.assert(leaseAccounts.get(0).cllease__Account__c == borrower.Id);
        
    }
    
    
    
    
}