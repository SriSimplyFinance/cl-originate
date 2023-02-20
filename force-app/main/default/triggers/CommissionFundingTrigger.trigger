trigger CommissionFundingTrigger on Saf_CommissionFunding__c (before insert,before update) {
Set<Id> contractIds = new Set<Id>();
public class CustomException extends Exception {}
try {
for(Saf_CommissionFunding__c dealer : Trigger.New)
{

    System.debug('************ ' + Trigger.New);
    contractIds.add(dealer.LS_Contract__c);
    //Saf_CommissionFunding__c NewRecord = [select id,Dealer_Charges__c,Contract__r.id from Saf_CommissionFunding__c where id=:Trigger.New];
    Id AgreementId = dealer.LS_Contract__c;
    System.debug('******' + AgreementId);
    AggregateResult[] AggregateResult1 = [Select SUM(cllease__Amount__c) totalFees From cllease__Contract_Fees__c where cllease__Contract__c =:AgreementId and cllease__Fee_Definition__r.clcommon__Class__c ='Expense'];
    Decimal Total_Amount_Payable =(Decimal)AggregateResult1[0].get('totalFees');
    
    AggregateResult[] AggregateResult = [Select SUM(saf_Amount__c) SumExp From Saf_CommissionFunding__c  where LS_Contract__c=:AgreementId ] ;
    Decimal ExistingSumExp = (Decimal)AggregateResult[0].get('SumExp');
    Decimal ExistingSumExp_updated;
    if (ExistingSumExp==null)
    {
        ExistingSumExp_updated = 0;
    }
    else
    {
        ExistingSumExp_updated=ExistingSumExp;
    }
    System.debug('****** dealer charges ' + ExistingSumExp );
    System.debug('****** Total_Amount_Payable  ' + Total_Amount_Payable);
    Decimal TotalSumExp;
    System.debug('****** saf_Amount__c  ' + dealer.saf_Amount__c);
    if(dealer.saf_Amount__c!=null && Trigger.isInsert && dealer.saf_Amount__c!=null)
    {
        TotalSumExp = ExistingSumExp_updated+dealer.saf_Amount__c;
    }
    else if (Trigger.isUpdate && dealer.saf_Amount__c !=null)
    {
        Saf_CommissionFunding__c DfUpdate = [select id,saf_Amount__c from Saf_CommissionFunding__c where id=:dealer.id];
        if (DfUpdate.saf_Amount__c > dealer.saf_Amount__c)
        {
            Decimal tmp = DfUpdate.saf_Amount__c- dealer.saf_Amount__c;
            TotalSumExp = ExistingSumExp_updated-tmp;
        }
        else
        {
            Decimal tmp=dealer.saf_Amount__c-DfUpdate.saf_Amount__c;
            TotalSumExp = ExistingSumExp_updated+tmp;
        }
    }
    else
    {
        TotalSumExp = ExistingSumExp_updated+0.0;
    }
    if (TotalSumExp>0 && Total_Amount_Payable>0 && TotalSumExp>Total_Amount_Payable && TotalSumExp!=Total_Amount_Payable)
    {
        System.debug('Total Dealer Charges are ' +TotalSumExp );
        dealer.addError('Sum of fees cannot be greater than Total Fees '+Total_Amount_Payable);
        throw new customException('Sum of fees cannot be greater than Total Fees '+Total_Amount_Payable);
    }
    cllease__Contract_Parties__c ContractParty;
    //List<Saf_CommissionFunding__c> Existingrecords = [select id,Dealer_Charges__c from Saf_CommissionFunding__c where Contract__r.id=:AgreementId];
    System.debug('Dealer id is ' +dealer.saf_contractParty__r.Id);
    if (dealer.saf_contractParty__c !=null)
    {
        ContractParty = [select id,cllease__Party_Account_Name__c,cllease__Party_Account_Name__r.name,cllease__Party_Name__r.name from cllease__Contract_Parties__c where id=:dealer.saf_contractParty__c];
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
        
            dealer.saf_Bank_Account__c = BankAccounts[0].id;
            dealer.saf_Account_Number__c = BankAccounts[0].Account_Number__c;
            dealer.saf_Sort_Code__c =  BankAccounts[0].clcommon__Routing_Number__c;
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
    
    List<cllease__Contract_Fees__c> lstfees = [Select Id,cllease__Amount__c,cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Definition__c From cllease__Contract_Fees__c where cllease__Contract__c  In:contractIds and cllease__Fee_Definition__r.clcommon__Class__c ='Expense'];
    
    List<Saf_CommissionFunding__c> lstcomm = [Select saf_Bank_Account__r.id,saf_Bank_Account_Reference__c,saf_Account_Number__c,saf_Sort_Code__c,Id,Name,saf_Amount__c,Fee_Schedule__c,Fee_Schedule__r.cllease__Fee_Definition__c,Fee_Schedule__r.cllease__Amount__c From Saf_CommissionFunding__c  where LS_Contract__c In:contractIds] ;
    //Decimal ExistingSumExp = (Decimal)AggregateResult[0].get('SumExp');
      System.debug('lstfees :' +lstfees );
       Map<Id,Decimal> mapfees = new  Map<Id,Decimal>();
    
       for(cllease__Contract_Fees__c obj: lstfees)
        {
            mapfees.put(obj.Id,obj.cllease__Amount__c);
        }
      for(Saf_CommissionFunding__c obj: lstcomm)
    {
         Decimal decAmt = 0; //= mapfees.get(obj.Fee_Schedule__c) == null ? 0 : mapfees.get(obj.Fee_Schedule__c);
        //if(obj.saf_Amount__c > decAmt) mapfees.put(obj.Fee_Schedule__c,(obj.saf_Amount__c-decAmt));
        if(mapfees.containskey(obj.Fee_Schedule__c)) 
          {
            decAmt =  mapfees.get(obj.Fee_Schedule__c) - obj.saf_Amount__c;
            mapfees.put(obj.Fee_Schedule__c,decAmt);//,math.abs(decAmt)
          }
    }
    System.debug('mapfees1:' +mapfees);
     for(Saf_CommissionFunding__c objcom: Trigger.New)
    {
          Decimal decAmt = 0; //= mapfees.get(obj.Fee_Schedule__c) == null ? 0 : mapfees.get(obj.Fee_Schedule__c);
        //if(obj.saf_Amount__c > decAmt) mapfees.put(obj.Fee_Schedule__c,(obj.saf_Amount__c-decAmt));
        if(mapfees.containskey(objcom.Fee_Schedule__c) && trigger.isupdate) 
          {
                Decimal oldvalueFee = trigger.oldMap.get(objcom.Id).saf_Amount__c;
                Decimal NewValueFee = objcom.saf_Amount__c;
                system.debug('oldvalueFee : ' + oldvalueFee );
                system.debug('NewValueFee : ' + NewValueFee );
                   string oldvalueFeeName = trigger.oldMap.get(objcom.Id).Fee_Schedule__c;
                string NewValueFeeName = objcom.Fee_Schedule__c;
                if(oldvalueFee != NewValueFee && (oldvalueFee <= mapfees.get(objcom.Fee_Schedule__c)  || NewValueFee >= mapfees.get(objcom.Fee_Schedule__c)))
                {
                    decAmt =  mapfees.get(objcom.Fee_Schedule__c) + oldvalueFee;
                    mapfees.put(objcom.Fee_Schedule__c,(decAmt));
                    system.debug('decAmt:'+ decAmt);
                }
               else if( oldvalueFee == NewValueFee && oldvalueFeeName == NewValueFeeName)
                 {
                   decAmt =  mapfees.get(objcom.Fee_Schedule__c) + oldvalueFee;
                    mapfees.put(objcom.Fee_Schedule__c,(decAmt));
                    system.debug('decAmt2:'+ decAmt);
                  }
          }  
      }
        System.debug('mapfees2:' +mapfees);
        for(Saf_CommissionFunding__c objcom: Trigger.New)
       {
        
           System.debug('objcomm :' +objcom.Fee_Schedule__c + 'objcom.saf_Amount__c :' + objcom.saf_Amount__c);
            if(mapfees.containskey(objcom.Fee_Schedule__c) && !objcom.saf_Fee_Funded__c)
            {    
              
               
                if(objcom.saf_Amount__c > mapfees.get(objcom.Fee_Schedule__c))
                {
                    objcom.addError('Remaining amount to be funded is '+mapfees.get(objcom.Fee_Schedule__c));
                      throw new customException('Remaining amount to be funded is '+mapfees.get(objcom.Fee_Schedule__c));
                  //  break;
                }
            }
        
        } 
    }
    catch(Exception ex) {
            System.debug('Custom Exception Message ===> '+ex.getMessage());
        }
}