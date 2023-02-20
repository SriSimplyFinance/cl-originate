trigger vls_updateContacts on Contact(after update) 
{
     List<id> ContactRecods = new List<id>();
     for(contact cont: trigger.new){
       if(string.isNotBlank(cont.KYCDB_Unique_Key_Contact__c))
        {
            If(Trigger.isUpdate)
            {
                ContactRecods.add(cont.id);
             }
             
         }
         
         if(trigger.isUpdate)
         {    
              SAF_ContactsUtils.UpdateContactToDB(ContactRecods);
                break;
         }
 }        
   /* Set<Id> AccountIds = new Set<Id>();
    Map<Id,contact> Mapcontact = new Map<Id,Contact>();
  
    Boolean ischanged = false;
    List<Contact> lstcontact = new List<Contact>();
    
       if(!Trigger.isupdate)
        {lstcontact = Trigger.New;}
        else {lstcontact = Trigger.Old;} */
     
      /*if(HelperClass2.firstRunContact)
      { 
        for(Contact objCon:lstcontact){  
           AccountIds.add(objCon.AccountId);
           Mapcontact.put(objCon.AccountId,objCon);
        }
         list<Account> accountsForUpdate = new list<Account>([select id,VLS_Surname_or_Business_Name2__c,Ownership,Name from Account where id in :AccountIds]);
         system.debug('AccountIds :' +AccountIds);
         system.debug('Mapcontact :' +Mapcontact);
         
           for(Account objAcc:accountsForUpdate){ 
              
                if(objAcc.Ownership == 'Sole Trader')
                {
                 if(Trigger.isdelete) {objAcc.VLS_Surname_or_Business_Name2__c = 'UNKNOWN';}
                 else {objAcc.VLS_Surname_or_Business_Name2__c = mapcontact.get(objAcc.Id).LastName;}
                 ischanged = true;
                }

            }
         if(ischanged) update accountsForUpdate;
        HelperClass2.firstRunContact=false;
      } */
    }