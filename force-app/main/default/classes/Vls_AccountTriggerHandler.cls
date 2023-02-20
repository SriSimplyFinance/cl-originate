public with sharing class Vls_AccountTriggerHandler
{
    @TestVisible static Boolean bypassTrigger = false;

    final List<Account> newRecords;
    final Map<Id, Account> oldMap;
    
    public Vls_AccountTriggerHandler(List<Account> newRecords, Map<Id, Account> oldMap)
    {
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }
    
    public void AfterUpdateInsert(Boolean IsInsert)
    {
         Set<Id> accountIds = new Set<Id>();
        // Get all the new records from Trigger.New 
        //IF( ISPICKVAL( Account.Ownership ,'Sole Trader' ),LastName, LEFT(Account.Name,80 ))
        
        for(Account objacc:newRecords){
              if (!IsInsert)
               {
                   string oldvalue = oldMap.get(objacc.Id).Ownership;
                   string NewValue = objacc.Ownership;
                   system.debug('oldvalue : ' + oldvalue);
                    system.debug('NewValue : ' + NewValue);
                   if(oldvalue != NewValue || String.isBlank(objacc.VLS_Surname_or_Business_Name2__c))
                   { accountIds.add(objacc.Id); }
               } 
               else {accountIds.add(objacc.Id);}
               
            }
        list<Account> accountsForUpdate = new list<Account>([select id,VLS_Surname_or_Business_Name2__c,Ownership,Name from Account where id in :accountIds]);
       //system.debug('accountsForUpdate : ' + accountsForUpdate);
      list<Contact> lstcontacts = new list<Contact>();
       if(accountsForUpdate.size() >0) {lstcontacts = new list<Contact>([select AccountId, LastName from Contact where AccountId in :accountIds]);}
       Map<Id,Contact> mapcontact = new  Map<Id,Contact>();
        for(Contact objCon:lstcontacts){
           mapcontact.put(objCon.AccountId,objCon);
       }
       //system.debug('mapcontact : '+ mapcontact);
       for(Account objacc1:accountsForUpdate){
       //system.debug('objacc1.Ownership : '+ objacc1.Ownership);
            if(objacc1.Ownership != 'Sole Trader')
            {
                objacc1.VLS_Surname_or_Business_Name2__c = objacc1.Name.left(80);
            }
            else
            { 
                if(mapcontact.containskey(objacc1.Id))
                { objacc1.VLS_Surname_or_Business_Name2__c = mapcontact.get(objacc1.Id).LastName;}
                else
                {objacc1.VLS_Surname_or_Business_Name2__c = 'UNKNOWN';}
            }
            //system.debug('objacc1.VLS_Surname_or_Business_Name2__c : '+ objacc1.VLS_Surname_or_Business_Name2__c);
        } 
        
        update accountsForUpdate;
         system.debug('accountsForUpdate : '+ accountsForUpdate);
    }
    
}