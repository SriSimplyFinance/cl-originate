/*Trigger to update the Bank account number, name and sort code from Bank Account of clcommon to Account object. This values will further be used to display in custom report from Lease Contract*/

trigger vls_updateAccbankInfo on clcommon__Bank_Account__c (after insert, after update)
{
    Set<Id> accountIds = new Set<Id>();
    //Get the Bank account records which is associated to an account.
    for(clcommon__Bank_Account__c bankAcc : Trigger.new)
    {
       if(bankAcc.clcommon__Account__c != null)
         accountIds.add(bankAcc.clcommon__Account__c);
    }
    
    list<clcommon__Bank_Account__c> banksAccountList = new list<clcommon__Bank_Account__c>([select clcommon__Bank_Account_Name__c,Account_Number__c,clcommon__Routing_Number__c,id,clcommon__Account__c,clcommon__Active__c from clcommon__Bank_Account__c where clcommon__Account__c in :accountIds and clcommon__Active__c=true  order by LastModifiedDate desc]);
    //verify if the bank acc is active.
    map<id,clcommon__Bank_Account__c> accountsWithTrue = new map<id,clcommon__Bank_Account__c>();
    for(clcommon__Bank_Account__c bankAcctWithTrue :banksAccountList){
        if(!accountsWithTrue.containsKey(bankAcctWithTrue.clcommon__Account__c)){
            accountsWithTrue.put(bankAcctWithTrue.clcommon__Account__c,bankAcctWithTrue);   
        }
    }
    //Get the account not associated to bank account so that the values for bank account in Account object can be changed to blank.
    for(Id acctId:accountIds){
        if(!accountsWithTrue.containsKey(acctId)){
            accountsWithTrue.put(acctId,null);
        }
    }
    //update Account fields from Bank Account object.
    list<Account> accountsForUpdate = new list<Account>([select Bank_Account_Name__c,id,Bank_Account_Number__c,Bank_Sort_Code__c from Account where id in :accountsWithTrue.keySet()]);
    try{
    for(Account acct:accountsForUpdate){
        clcommon__Bank_Account__c bankAcct = accountsWithTrue.get(acct.id);
        if(bankAcct != null){
            acct.Bank_Account_Name__c = bankAcct.clcommon__Bank_Account_Name__c;
            acct.Bank_Account_Number__c =bankAcct.Account_Number__c;
            acct.Bank_Sort_Code__c = bankAcct.clcommon__Routing_Number__c;
        }else{
            acct.Bank_Account_Name__c = null;
            acct.Bank_Account_Number__c = null;
            acct.Bank_Sort_Code__c = null;
        }
    }
    
    update accountsForUpdate;
    }catch(Exception e){}
    
 }