trigger DealerFundingTrigger on Dealer_Funding__c (before insert,before update) {
public class CustomException extends Exception {}
try
{
for(Dealer_Funding__c dealer : Trigger.New)
{
    System.debug('************ ' + Trigger.New);
    //Dealer_Funding__c NewRecord = [select id,Dealer_Charges__c,Contract__r.id from Dealer_Funding__c where id=:Trigger.New];
    Id AgreementId = dealer.Contract__c;
    System.debug('******' + AgreementId);
    cllease__Lease_Account__c AgreementObj = [select id,name,Total_Amount_Payable__c from cllease__Lease_Account__c where id=:AgreementId];
    Decimal Total_Amount_Payable = AgreementObj.Total_Amount_Payable__c ;
    
    AggregateResult[] AggregateResult = [Select SUM(Dealer_Charges__c) DealerCharges From Dealer_Funding__c  where Contract__r.id=:AgreementId] ;
    Decimal ExistingDealerCharges = (Decimal)AggregateResult[0].get('DealerCharges');
    Decimal ExistingDealerCharges_updated;
    if (ExistingDealerCharges==null)
    {
        ExistingDealerCharges_updated = 0;
    }
    else
    {
        ExistingDealerCharges_updated=ExistingDealerCharges;
    }
    System.debug('****** dealer charges ' + ExistingDealerCharges );
    System.debug('****** Total_Amount_Payable  ' + Total_Amount_Payable);
    Decimal TotalDealerCharges;
    System.debug('****** Total_dealer charges  ' + dealer.Dealer_Charges__c);
    if(dealer.Dealer_Charges__c!=null && Trigger.isInsert && dealer.Dealer_Charges__c!=null)
    {
        TotalDealerCharges = ExistingDealerCharges_updated+dealer.Dealer_Charges__c;
    }
    else if (Trigger.isUpdate && dealer.Dealer_Charges__c!=null)
    {
        Dealer_Funding__c DfUpdate = [select id,Dealer_Charges__c from Dealer_Funding__c where id=:dealer.id];
        if (DfUpdate.Dealer_Charges__c > dealer.Dealer_Charges__c)
        {
            Decimal tmp = DfUpdate.Dealer_Charges__c- dealer.Dealer_Charges__c;
            TotalDealerCharges = ExistingDealerCharges_updated-tmp;
        }
        else
        {
            Decimal tmp=dealer.Dealer_Charges__c-(DfUpdate.Dealer_Charges__c !=null ?DfUpdate.Dealer_Charges__c :0);
            TotalDealerCharges = ExistingDealerCharges_updated+tmp;
        }
    }
    else
    {
        TotalDealerCharges = ExistingDealerCharges_updated+0.0;
    }
    if (TotalDealerCharges>0 && Total_Amount_Payable>0 && TotalDealerCharges>Total_Amount_Payable && TotalDealerCharges!=Total_Amount_Payable)
    {
        System.debug('Total Dealer Charges are ' +TotalDealerCharges );
        dealer.addError('Sum of Dealer Charges cannot be greater than Total Amount Payable '+Total_Amount_Payable);
        throw new customException('Sum of Dealer Charges cannot be greater than Total Amount Payable '+Total_Amount_Payable);
    }
    cllease__Contract_Parties__c ContractParty;
    //List<Dealer_Funding__c> Existingrecords = [select id,Dealer_Charges__c from Dealer_Funding__c where Contract__r.id=:AgreementId];
    System.debug('Dealer id is ' +dealer.Dealer__r.Id);
    if (dealer.Dealer__c!=null)
    {
        ContractParty = [select id,cllease__Party_Account_Name__c,cllease__Party_Account_Name__r.name,cllease__Party_Name__r.name from cllease__Contract_Parties__c where id=:dealer.Dealer__c];
    }
    System.debug('Contract party is ' + ContractParty);
//if(ContractParty !=null && dealer.Bank_Account_Reference__c !=null)
    if(ContractParty !=null)
        {
//cllease__Contract_Parties__c ContractParty = [select id,cllease__Party_Account_Name__c,cllease__Party_Account_Name__r.name,cllease__Party_Name__r.name from cllease__Contract_Parties__c where id=:dealer.Dealer__r.Id];

        String AccountName = ContractParty.cllease__Party_Account_Name__r.name;
        String PartyName = ContractParty.cllease__Party_Name__r.name;
        
        List<clcommon__Bank_Account__c> BankAccounts = [select id,clcommon__Bank_Account_Number__c,Account_Number__c,clcommon__Routing_Number__c,name from clcommon__Bank_Account__c where (clcommon__Account__r.id=:ContractParty.cllease__Party_Account_Name__c and clcommon__Active__c=true)];
        
        if (BankAccounts.size()>1)
        {
            List<String> BankAccs = new List<String>();
            for(clcommon__Bank_Account__c BA: BankAccounts)
            {
                System.debug('Bank Account is ' + BA.name);
                BankAccs.add(BA.name);
            }
            
            dealer.addError('Multiple active Bank Accounts found for Account name '+AccountName+ ' and Party name ' + PartyName  +'.' + ' List of available Active Bank Accounts are ' + BankAccs);
             throw new customException('Multiple active Bank Accounts found for Account name '+AccountName+ ' and Party name ' + PartyName  +'.' + ' List of available Active Bank Accounts are ' + BankAccs);
        }
        else if (BankAccounts.size()==0)
        {
            dealer.addError('No Bank Account found for Account name '+AccountName+ ' and Party name ' + PartyName  +'.');
            throw new customException('No Bank Account found for Account name '+AccountName+ ' and Party name ' + PartyName  +'.');
        }
        else if (Trigger.isInsert)
        {
        
            dealer.Bank_Account__c = BankAccounts[0].id;
            dealer.Account_Number__c = BankAccounts[0].Account_Number__c;
            dealer.Sort_Code__c =  BankAccounts[0].clcommon__Routing_Number__c;
        }
    /*
    System.debug('Bank Account is ' + dealer.Bank_Account_Reference__c);
    List<String> BankAccs = new List<String>();
    
    for(clcommon__Bank_Account__c BA: BankAccounts)
    {
    System.debug('Bank Account is ' + BA.name);
    BankAccs.add(BA.name);
    }
    System.debug('List of BA ' + BankAccs);
    //if (BA.name!=dealer.Bank_Account_Reference__c)
    if(!BankAccs.contains(dealer.Bank_Account_Reference__c))
    {
    dealer.addError('Please select corect Bank Account corresponding to Account name '+AccountName+ ' and Part name ' + PartyName +'.' 
                    + ' List of available Bank Accounts are  ' + BankAccs);
    
    //dealer.addError('List of available Bank Accounts are  ' + BankAccs );
    } */
    }
    }
 }
   catch(Exception ex) {
            System.debug('Custom Exception Message ===> '+ex.getMessage());
        }
}