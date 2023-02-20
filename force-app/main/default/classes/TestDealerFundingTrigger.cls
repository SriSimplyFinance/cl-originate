@isTest(SeeAllData=true)

public class TestDealerFundingTrigger
{
public testmethod static void InsertDealerfund()
{
try
{
//Id AgreementID = 'a699E000000206Y';
cllease__Lease_Product__c prd = [Select Id,name from cllease__Lease_Product__c where cllease__Status__c='Active' /*name like'%Test%'*/ limit 1];
 clcommon__Fee_Set__c fs = [SELECT Id, name FROM clcommon__Fee_Set__c LIMIT 1];    
Account a = [Select name,ID from account where name like'%Test%' limit 1];

cllease__Lease_Account__c Agreement = new cllease__Lease_Account__c (cllease__Account__c=a.id,cllease__Lease_Product_Name__c=prd.id,
                                       cllease__Lease_Status__c='ACTIVE - GOOD STANDING',   cllease__Fee_Set1__c=fs.id
                                       ,cllease__Contract_Date__c=System.Today(),cllease__First_Payment_Date__c=System.Today()+1
                                       ,cllease__Current_Term__c=24,cllease__Payment_Frequency__c='Monthly',cllease__Grace_Period_for_Repayments__c=6
                                       ,cllease__Delinquency_Grace_Days__c=30,cllease__Pre_Bill_Days__c=30,cllease__Active_flag__c=True
                                       ,cllease__Term__c=12);
insert Agreement;
Contact contact = new Contact();
contact.FirstName = 'Test1';
contact.LastName = 'contact';
contact.Account = a;

clcommon__Bank_Account__c BankAcct =new clcommon__Bank_Account__c();
BankAcct.clcommon__Account__c=a.id;
BankAcct.Account_Number__c = '123456789';
BankAcct.clcommon__Routing_Number__c = '909090';
BankAcct.clcommon__Active__c=true;
BankAcct.clcommon__Contact__c = contact.id;
insert BankAcct;

cllease__Contract_Parties__c party = new cllease__Contract_Parties__c();
party.cllease__Contract__c = Agreement.id;
party.cllease__Party_Type__c = 'Dealer';
party.cllease__Party_Account_Name__c = a.id;
party.cllease__Party_Name__c = contact.id;
insert party;

//cllease__Lease_Account__c Agreement = [select id,name,cllease__Lease_Status__c,Total_Amount_Payable__c,(select id,cllease__Party_Account_Name__c  from cllease__Contract_Parties__r) from cllease__Lease_Account__c  where id = :AgreementID  ];
//cllease__Contract_Parties__c Dealer  = Agreement.cllease__Contract_Parties__r;
//clcommon__Bank_Account__c BankAccounts = [select id,clcommon__Bank_Account_Number__c,name from clcommon__Bank_Account__c where clcommon__Account__r.id=:Dealer.cllease__Party_Account_Name__c limit 1];
List<Dealer_Funding__c> RecordLst = new List<Dealer_Funding__c>();

for(Integer i=0;i<10;i++)
{
Dealer_Funding__c Df = new Dealer_Funding__c();
//Df.name = 'TestDF'+i;
Df.Contract__c = Agreement.Id;
Df.Dealer__c=party.Id ;
Df.Bank_Account__c = BankAcct.Id;
Df.Account_Number__c =BankAcct.Account_Number__c;
Df.Sort_Code__c=BankAcct.clcommon__Routing_Number__c ;
Df.Dealer_Charges__c = 10;
RecordLst.add(Df);

}
insert RecordLst;
clcommon__Bank_Account__c BankAcct1 =new clcommon__Bank_Account__c();
BankAcct1.clcommon__Account__c=a.id;
BankAcct1.Account_Number__c = '1234567';
BankAcct1.clcommon__Routing_Number__c = '99090';
BankAcct1.clcommon__Active__c=true;
BankAcct1.clcommon__Contact__c = contact.id;
insert BankAcct1; 

Dealer_Funding__c Df = new Dealer_Funding__c();
Df.Contract__c = Agreement.Id;
Df.Dealer__c=party.Id ;
Df.Bank_Account__c = BankAcct.Id;
//Df.Dealer_Charges__c = 10;
Df.Account_Number__c =BankAcct1.Account_Number__c;
Df.Sort_Code__c=BankAcct1.clcommon__Routing_Number__c ;
insert Df;

Df.Dealer_Charges__c = 1000;
Df.Account_Number__c =BankAcct.Account_Number__c;
update Df;

for(Dealer_Funding__c dealerFunding : RecordLst)
{
System.assert(dealerFunding.Dealer_Charges__c !=null);
System.assertEquals(10,dealerFunding.Dealer_Charges__c);
}
}
catch (Exception e)
{
System.debug('Exception occurs ' +e);
}
}

}