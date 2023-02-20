@isTest(SeeAllData=true)
private class vls_TestUpdateContractRentalsFromStreams{

static testMethod void TestUpdateContractRentalsFromStreams(){

    cllease__Rental_Stream__c rentalStream = new cllease__Rental_Stream__c();
    
     RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.AccountNumber='6549821699';
        lessee.Name = 'TestAccount1';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA'; 
        lessee.ShippingCity = 'London';
        insert lessee;
        
        clcommon__Fee_Set__c feeSet = new clcommon__Fee_Set__c();
        feeSet.Name = 'Hire Purchase';
        insert feeSet;
        
        cllease__Lease_Product__c prodName = new cllease__Lease_Product__c();
        prodName.Name = 'Hire Purchases';
        prodName.cllease__Calculation_Method__c = 'IRR';
        prodName.cllease__Status__c = 'Active';
        insert prodName;
        
        cllease__Office_Name__c ofcName = new cllease__Office_Name__c();
        ofcName.Name = 'Simply Asset';
        ofcName.cllease__Office_Short_Name__c = 'saf';
        insert ofcName;
        
        
        cllease__Payment_Spread__c paySpr = new cllease__Payment_Spread__c();
        paySpr.cllease__Enabled__c = true;
        paySpr.cllease__Spread_Description__c = 'test';
        insert paySpr;
                
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = feeSet.ID;
        leaseAccount.cllease__Lease_Product_Name__c  = prodName.ID;
        leaseAccount.cllease__Branch__c              = ofcName.ID;
        leaseAccount.cllease__Payment_Spread__c      = paySpr.id;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Term__c                = 6;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2016, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
    insert leaseAccount;
    List<Id> IdsRentalstreams =new List<Id>();
    rentalStream.cllease__Capital_Recovery__c = 3000;
    rentalStream.cllease__Lease_Income__c = 1000;
    rentalStream.cllease__Contract__c = leaseAccount.Id;
    rentalStream.cllease__Date__c = date.today() + 1;
    insert rentalStream;
    IdsRentalstreams.add(leaseAccount.Id);
    
    vls_updateContractRentalsFromStreams.updateContractRentals();
    
}


}