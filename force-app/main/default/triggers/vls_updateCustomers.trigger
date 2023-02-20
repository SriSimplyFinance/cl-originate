trigger vls_updateCustomers on Account(after insert,after update)
        {

 Vls_AccountTriggerHandler handle=new Vls_AccountTriggerHandler(trigger.new,trigger.oldMap);
        Saf_setting__c objsettings=Saf_setting__c.getOrgDefaults();
          
        if(!objsettings.DisableCustomerTriggers__c)
        {
        Boolean blnTrigger=false;
        if(System.IsBatch()==false)
        {
        if(trigger.isInsert){blnTrigger=true;}
        handle.AfterUpdateInsert(blnTrigger);

        }  
 
        Set<Id> setAccids=new Set<Id>();
        //Added for SharePoint Metadat change
        if(trigger.isUpdate)
        {
        if(HelperClass1.firstRunCustomer){
        //system.debug('trigger.isUpdate: ' + trigger.isUpdate);
        for(Account spAcc:trigger.New)
        {
        if(spAcc.Id!=Null)
        {
        boolean iscreate=true;
        system.debug('Zoho customer ID'+spAcc.Zoho_Customer_Id__c);
        if(spAcc.Zoho_Customer_Id__c!=Null)
        {
        iscreate=false;
        }
        List<string> accId=new List<string>();
        accId.add(spAcc.Id);
        //System.enqueueJob(new SAF_ZohoAccountsQueueable(accId,iscreate));
        /*system.debug('spAcc.Id: '+spAcc.Id);
        system.debug('*****System is future******'+System.isFuture());
        system.debug('*****System is IsBatch******'+System.IsBatch());*/
       
        if(System.IsBatch()==false&&System.isFuture()==false)
        {
        setAccids.add(spAcc.Id);
        system.debug('spAcc.Id: '+spAcc.Id);
        System.debug('isCreate:'+iscreate);
        
        Saf_ZohoAccounts.CreateInZoho(accId,iscreate);
        //break;

        }
        }
        if(spAcc.SAF_Sharepoint_Folder_ID__c!='ERROR')
        {
        String oldvalue=trigger.oldMap.get(spAcc.Id).SAF_Sharepoint_Folder_ID__c;
        String newValue=spAcc.SAF_Sharepoint_Folder_ID__c;

        system.debug('oldvalue : '+oldvalue);
        system.debug('NewValue : '+newValue);

        if(oldvalue!=NewValue)
        {
        system.debug('spAcc.Id: '+spAcc.Id);
        updateCustomer.createRecords(Trigger.New);
        break;
        }
        }
        String oldvaluecust=trigger.oldMap.get(spAcc.Id).Name;
        String newValuecust=spAcc.Name;

        system.debug('oldvaluecust : '+oldvaluecust);
        system.debug('newValuecust : '+newValuecust);

        if(oldvaluecust!=newValuecust)
        {
        system.debug('spAcc.Id: '+spAcc.Id);
        updateCustomer.changeRecords(Trigger.New);
        break;
        }
        }
        HelperClass1.firstRunCustomer=false;
        }
        }
        //for duedil contact creation

       /* List<account> lstaccount=new List<account>();
        List<account> lstaccountUpdate=new List<account>();
        List<account> lstDirAccounts=new List<account>();

        // if(HelperClass1.firstRunContact)
        //{
        for(Account spAcc:trigger.New)
        {
        if(!string.Isblank(spAcc.Customer_Created_Platform__c)&&trigger.isInsert)// 
        {
        lstDirAccounts.add(spAcc);
        }
        if(!spAcc.SAF_is_Duedil_Created__c&&trigger.isInsert)
        {
        lstaccount.add(spAcc);

        }

        if(trigger.isUpdate)
        {
        lstaccountUpdate.add(spAcc);

        }
        }
        if(System.IsBatch()==false&&System.isFuture()==false&&lstDirAccounts.size()>0)
        {
        system.debug('lstDirAccounts: '+lstDirAccounts);
        SAF_CompanyDeatils.createRelatedGroupCustomers2(lstDirAccounts[0].accountnumber,lstDirAccounts[0].name);
        }
        if(System.IsBatch()==false&&System.isFuture()==false&&lstaccount.size()>0)
        {
        system.debug('lstaccount: '+lstaccount);
        updateCustomer.createcontact(lstaccount);
        }
        if(System.IsBatch()==false&&System.isFuture()==false&&lstaccountUpdate.size()>0)
        {
        system.debug('lstaccountUpdate: '+lstaccountUpdate);
        updateCustomer.Updatecontact(lstaccountUpdate);
        }*/

        //       HelperClass1.firstRunContact=false;
        // }  

        //For company house integration to update new customer to kyc db
        List<id> newaccount=new List<id>();
        List<id> newIndividualAccount=new List<id>();
        List<id> newCustomers=new List<id>();

        for(account newacc:trigger.new){
        if(newacc.ownership!='Individual'&&string.isBlank(newacc.KYCDB_Unique_Key_Account__c)){

        // if(System.IsBatch() == false){
        newaccount.add(newacc.id);
        system.debug('newaccount'+newaccount);
              /* if(newacc.shareholderStructureRequired__c == True){
                   newCustomers.add(newacc.id);
                     SAF_CompanyDetailService.updateShareholderDetails(newCustomers);
                 }*/
        }
        if(newacc.ownership=='Individual'&&string.isBlank(newacc.KYCDB_Unique_Key_Account__c)){
        //  if(string.isBlank(newacc.KYCDB_Unique_Key_Account__c)){
        // if(System.IsBatch() == false){
        newIndividualAccount.add(newacc.id);
        system.debug('newIndividualAccount'+newIndividualAccount);
        }
        }

        if(trigger.isInsert)
        {
        system.debug('new customer inside if');
        system.debug('newaccount.size()::'+newaccount.size());
        if(newaccount.size()!=0){

        SAF_ContactsUtils.UpdateNewCustomerToDB(newaccount);
        }else{
        SAF_ContactsUtils.insertIndividualinDB(newIndividualAccount);
        }


        }

        }


        //to update the existing customer details back to kyc db
        List<id> updatedAccList=new List<id>();
        if(SAF_ContactsUtils.runTrigger){

        SAF_ContactsUtils.runTrigger=false;

        for(Account updatedAcc:trigger.new){

        if(updatedAcc.ownership!='Individual'&&trigger.isUpdate)
        {
        Account accountOld=Trigger.oldMap.get(updatedAcc.ID);
        system.debug('ownership value::'+updatedAcc.ownership);
        if(!System.isBatch())
        {
        updatedAccList.add(updatedAcc.id);
        }
        system.debug('updatedAccListlist:'+updatedAccList);
        if((accountOld.KYCDB_Unique_Key_Account__c!=null)&&(accountOld.KYCDB_Unique_Key_Account__c==updatedAcc.KYCDB_Unique_Key_Account__c)){
        //System.enqueueJob(new SAF_UpdateCustomersQueueable(updatedAccList));     
        SAF_ContactsUtils.UpdateContacts(updatedAccList);
        }
        }
         
         
         /*if(trigger.isUpdate)
         {    
                 system.debug('updating old account inside if::' +oldaccount);
                  SAF_ContactsUtils.UpdateContacts(oldaccount);
         }*/

        }
        SAF_ContactsUtils.runTrigger=true;
        }

        //UpdateIndividual in DB when Individual customer is updated in CL
        List<id> IndAccount=new List<id>();
        if(SAF_ContactsUtils.runTrigger){

        SAF_ContactsUtils.runTrigger=false;
        for(Account IndAcc:trigger.new){

        System.debug('***SFDC: Trigger.old is: '+Trigger.old);
        System.debug('***SFDC: Trigger.new is: '+Trigger.new);

        if(IndAcc.ownership=='Individual')
        {
        system.debug('ownership value::'+IndAcc.ownership);
        if(!System.isFuture()&&!System.isBatch())
        {
        IndAccount.add(IndAcc.id);
        }
        system.debug('IndAccount list:'+IndAccount);
        }

        if(trigger.isAfter&&trigger.isUpdate)
        {
        Account oldAccount=Trigger.oldMap.get(IndAcc.ID);
        if((oldAccount.KYCDB_Unique_Key_Account__c!=null)&&(oldAccount.KYCDB_Unique_Key_Account__c==IndAcc.KYCDB_Unique_Key_Account__c)){
        system.debug('updating old account inside if::'+IndAccount);
        SAF_ContactsUtils.UpdateIndividual(IndAccount);
        }

        }

        }
     
        }
        }