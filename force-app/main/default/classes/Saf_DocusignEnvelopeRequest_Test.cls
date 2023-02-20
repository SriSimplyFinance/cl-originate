@isTest(SeeAllData = True)
public class Saf_DocusignEnvelopeRequest_Test {

  @isTest
  static void CreateEnvelopeRequestbodyTest() {

    Saf_setting__c objSettings = Saf_setting__c.getOrgDefaults();
    objSettings.saf_Docusign_clientid__c = '385389435';
    upsert objSettings;

    clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name = 'ZX');
    INSERT legal;

    //Create Account
    Account acc = new Account();
    acc.clcommon__Legal_Entity_Type__c = legal.id;
    acc.Name = 'TestAccount-Happy';
    acc.BillingPostalCode = 'BD1 1HA';
    acc.BillingCity = 'London';
    acc.ShippingPostalCode = 'BD1 1HA';
    acc.ShippingCity = 'London';
    acc.Landline__c = '12345 123456';
    acc.clcommon__Email__c = 'yahoo@gmail.com';
    INSERT acc;

    Account acc1 = new Account();
    acc1.clcommon__Legal_Entity_Type__c = legal.id;
    acc1.Name = 'TestAccount-Simply011';
    acc1.BillingPostalCode = 'BD1 1HA';
    acc1.BillingCity = 'London';
    acc1.ShippingPostalCode = 'BD1 1HA';
    acc1.ShippingCity = 'London';
    acc1.Landline__c = '12345 123457';
    acc1.clcommon__Email__c = 'yahoo101@gmail.com';
    INSERT acc1;

    Account acc2 = new Account();
    acc2.clcommon__Legal_Entity_Type__c = legal.id;
    acc2.Name = 'TestAccount-Simply022';
    acc2.BillingPostalCode = 'BD1 1HA';
    acc2.BillingCity = 'London';
    acc2.ShippingPostalCode = 'BD1 1HA';
    acc2.ShippingCity = 'London';
    acc2.Landline__c = '12345 123457';
    acc2.clcommon__Email__c = 'yahoo102@gmail.com';
    INSERT acc2;

    List<String> names = new List<String> {
      'Finance Lease'
    } ;

    clcommon__CL_Product__c pr1 = new clcommon__CL_Product__c();
    pr1.clcommon__Product_Name__c = 'Finance Lease';
    INSERT pr1;


    clcommon__CL_Product__c product =  [select Id, Name, clcommon__Product_Name__c from clcommon__CL_Product__c
    where clcommon__Product_Name__c in:
    names limit 1 ];
    cllease.TestHelper.createSeedDataForTesting();

    // Create a Fee Set
    clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
    clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
    clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
    cllease.TestHelper.createOffice('Test Office', true);
    cllease__Office_Name__c dummyOffice = [select Id, Name from cllease__Office_Name__c limit 1];

    //Create a dummy Lease Product
    cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
    dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
    dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
    dummyLP.cllease__Dep_over_asset_life__c = true;
    dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
    dummyLP.cllease__idc_Accrual_Flag__c = true;

    UPDATE dummyLP;

    clcommon__Fee_Definition__c feedef = new clcommon__Fee_Definition__c();
    feedef.clcommon__Active__c = true;
    feedef.Name = 'Security Deposit';
    feedef.clcommon__Class__c = 'Income';
    feedef.clcommon__Calculation_Method__c = 'fixed';
    feedef.clcommon__Amount__c = 998.9;
    insert feedef;

    //Create Application
    genesis__Applications__c genApp = new genesis__Applications__c();
    genApp.genesis__Expected_Start_Date__c = Date.Today();
    genApp.genesis__Financed_Amount__c = 1200;
    genApp.genesis__Product_Type__c = 'LEASE';
    genApp.genesis__Product_Sub_Type__c = 'FINANCE LEASE';
    genApp.genesis__CL_Product__c = product.Id;
    genApp.genesis__Loan_Amount__c = 6700;
    genApp.genesis__Fees_Amount__c = 0;
    genApp.genesis__Term__c = 12;
    genApp.genesis__Payment_Frequency__c = 'MONTHLY';
    genApp.genesis__Interest_Rate__c = 10;
    genApp.genesis__Expected_Close_Date__c = Date.Today().addDays(60);
    genApp.genesis__Account__c = acc.Id;

    INSERT genApp;

    genesis__Equipment_Master__c eqpMas = new genesis__Equipment_Master__c();
    eqpMas.genesis__Equipment_Type__c = 'VEHICLE';
    insert eqpMas;

    genesis__Application_Equipment__c appEqp = new genesis__Application_Equipment__c();
    appEqp.genesis__Application__c = acc.Id;
    appEqp.Equipment_Type__c = 'Tractor';
    appEqp.genesis_Equipment_Description__c = 'test';
    appEqp.genesis_Net_Asset_Cost__c = 50000;
    appEqp.genesis_make__c = 'test';
    appEqp.genesis_Vehicle_Chassis_Number__c = '2342432';
    appEqp.genesis_County__c = 'count';
    appEqp.genesis_Street_Address__c = 'madiwala';
    appEqp.genesis_Equipment_Serial_Number__c = '1232';
    appEqp.genesis__Application__c = genApp.id;
    appEqp.genesis__Equipment__c = eqpMas.id;
    insert appEqp;

    genesis__Payment_Stream__c genpyst = new genesis__Payment_Stream__c();
    genpyst.genesis__Application__c = genApp.Id;
    genpyst.genesis__Sequence__c = 1;
    genpyst.genesis__Payment_Amount__c = 366.00;
    genpyst.genesis__Number_of_Payments__c = 1;
    Insert genpyst;
    genesis__Payment_Stream__c genpyst1 = new genesis__Payment_Stream__c();
    genpyst1.genesis__Application__c = genApp.Id;
    genpyst1.genesis__Sequence__c = 2;
    genpyst1.genesis__Payment_Amount__c = 366.00;
    genpyst1.genesis__Number_of_Payments__c = 12;
    Insert genpyst1;
    genesis__Payment_Stream__c genpyst2 = new genesis__Payment_Stream__c();
    genpyst2.genesis__Application__c = genApp.Id;
    genpyst2.genesis__Sequence__c = 3;
    genpyst2.genesis__Payment_Amount__c = 366.00;
    genpyst2.genesis__Number_of_Payments__c = 12;
    Insert genpyst2;
    genesis__Fee_Schedule__c genfee = new genesis__Fee_Schedule__c();
    genfee.genesis__Application__c = genApp.Id;
    genfee.genesis__Number_of_Periods__c = 1;
    genfee.genesis__Frequency__c = 'MONTHLY';
    genfee.genesis__Start_Date__c = genApp.genesis__Expected_Start_Date__c;
    genfee.genesis__Fee_Definition__c = feedef.Id;
    genfee.genesis__Amount__c = 300;
    Insert genfee;


    clcommon__Bank_Account__c BankAcc = new clcommon__Bank_Account__c();
    BankAcc.clcommon__Account__c = acc.id;
    BankAcc.clcommon__Bank_Account_Name__c = 'madina';
    BankAcc.Account_Number__c = '6656756234';
    BankAcc.clcommon__Routing_Number__c = '77777';
    BankAcc.clcommon__Active__c = True;
    insert BankAcc;

    dsfs__DocuSign_Envelope__c objEnvelope = new dsfs__DocuSign_Envelope__c();
    objEnvelope.dsfs__DocuSign_Email_Subject__c = 'Test for Welcome';
    objEnvelope.dsfs__Custom_Field_1_Name__c = genApp.Name;
    insert objEnvelope;

    dsfs__DocuSign_Envelope_Recipient__c envelopeRecipient = new dsfs__DocuSign_Envelope_Recipient__c();
    envelopeRecipient.Account__c = acc1.Id;
    envelopeRecipient.dsfs__DocuSign_Signature_Name__c = 'Test_Signer1';
    envelopeRecipient.dsfs__DocuSign_Recipient_Role__c = 'Signer 1';
    envelopeRecipient.dsfs__Access_Code__c = '9654';
    envelopeRecipient.dsfs__DocuSign_Signer_Type__c = 'Signer';
    envelopeRecipient.dsfs__Routing_Order__c = 1;
    envelopeRecipient.dsfs__DocuSign_EnvelopeID__c = objEnvelope.Id;
    envelopeRecipient.dsfs__Recipient_Email__c = 'test@test.com';
    insert envelopeRecipient;

    dsfs__DocuSign_Envelope_Recipient__c envelopeRecipient1 = new dsfs__DocuSign_Envelope_Recipient__c();
    envelopeRecipient1.Account__c = acc1.Id;
    envelopeRecipient1.dsfs__DocuSign_Signature_Name__c = 'Test_guarantor1';
    envelopeRecipient1.dsfs__DocuSign_Recipient_Role__c = 'Guarantor 1';
    envelopeRecipient1.dsfs__Access_Code__c = '965401';
    envelopeRecipient1.dsfs__DocuSign_Signer_Type__c = 'Signer';
    envelopeRecipient1.dsfs__Routing_Order__c = 1;
    envelopeRecipient1.dsfs__DocuSign_EnvelopeID__c = objEnvelope.Id;
    envelopeRecipient1.dsfs__Recipient_Email__c = 'test1@test.com';
    insert envelopeRecipient1;

    Payment_Stream_Proposal__c objPaymentStreamProposal = new Payment_Stream_Proposal__c();
    objPaymentStreamProposal.Application__c = genApp.Id;
    objPaymentStreamProposal.Number_of_Payments__c = 1;
    objPaymentStreamProposal.Payment_Amount__c = 250;
    objPaymentStreamProposal.Payment_inc_VAT__c = 500;
    insert objPaymentStreamProposal;

    Saf_DocusignPayload payload = new Saf_DocusignPayload();
    payload.templates = new List<String> {
      '1351ad58-c461-47c2-b712-2c72faebbba8'
    } ;
    payload.objpartyIds = new List<String> {
      acc1.id
    } ;
    payload.genappId = string.valueof(genApp.id);
    payload.genappName = genApp.Name;
    payload.straccountId = acc.id;
    payload.recipientEnvelopeId = objEnvelope.id;


    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new Saf_DocuSignEnevelope_Mock());

    Saf_DocusignEnvelopeRequest.CreateEnvelopeRequestbody(payload);

    Test.stopTest();
  }


}