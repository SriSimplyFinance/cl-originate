/**
*
* @Name                 : UpdateAccountAutoAlerts 
* @Author               : Deepak - Happiest minds 
* @Description          : This Batch class is used to update Account field for Auto Alerts
* @Created date         : 28-08-2018
*
**/

global class UpdateAccountAutoAlerts implements Database.Batchable<sObject>, Database.Stateful 
{
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Set<String> accounts= new Set<String>();
    global Set<String> previousAccounts= new Set<String>();
    global List<Account> bulkaccounts = new List<Account>(), previousArrearAccounts = new List<Account>();
    //global String Id = 'a696E0000000J4ZQAU';
    global list<Account> acnts = new List<Account>();

    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        Boolean isSatisified = false;
        //String query = 'SELECT Id,Name,cllease__Lease_Account__c, cllease__Due_Date__c, cllease__Payment_Satisfied__c, cllease__Account__c,cllease__Account__r.Current_Arrears_Amount__c FROM cllease__Lease_account_Due_Details__c where cllease__Lease_Account__c=:Id';
        String query = 'SELECT Id,Name,cllease__Lease_Account__c, cllease__Due_Date__c, cllease__Payment_Satisfied__c, cllease__Account__c,cllease__Account__r.Current_Arrears_Amount__c FROM cllease__Lease_account_Due_Details__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<cllease__Lease_account_Due_Details__c> scope)
    {
        // process each batch of records
        bulkaccounts= new List<Account>();
        previousArrearAccounts = new  List<Account>();
        
        System.debug('*********************Query: '+scope+'*********************');
        Integer numberDaysDue;
        cllease__Office_Name__c company = [SELECT Id, Name,cllease__Current_System_Date__c FROM cllease__Office_Name__c Limit 1];
            
        System.debug('*********************System Date: '+company.cllease__Current_System_Date__c+'*********************');
        
        for (cllease__Lease_account_Due_Details__c bill : scope) 
        {
            
            string accountId = bill.cllease__Account__c;
            Decimal delinquentAmount = (Decimal)[SELECT SUM(cllease__Delinquent_Amount__c) currentArrears FROM cllease__Lease_Account__c where cllease__Account__c = :accountId][0].get('currentArrears');
            Boolean isAccountPaid,isPreviousAccountPaid;
            
            Account[] account = [SELECT Id,Name,Current_Arrears_Amount__c,Pay_Current_Arrears__c,Pay_Previous_Arrears__c,Previous_Arrears_Date__c from Account where Id = :accountId];
            System.debug('*********************Bills : '+bill.cllease__Lease_Account__c+'*********************');
            
            if(account.size() > 0)
            {
                System.debug('*********************Account Size: '+account.size()+ '########### Account Id: ' +accountId+'*********************');
            
                if(!bill.cllease__Payment_Satisfied__c)
                {
                    //numberDaysDue   = bill.cllease__Due_Date__c.daysBetween(date.today());
                    System.debug('*********************Bills : '+bill.cllease__Lease_Account__c+'*********************');
                    
                    numberDaysDue   = bill.cllease__Due_Date__c.daysBetween(company.cllease__Current_System_Date__c);
                    /*if(bill.cllease__Lease_Account__c == 'a696E0000000J4ZQAU')
                    {
                        System.debug('*********************LES-0000001393: '+numberDaysDue+'*********************');
                    }*/
                    
                    isAccountPaid = accounts.contains(String.valueOf(account[0].Id));
                    isPreviousAccountPaid = previousAccounts.contains(String.valueOf(account[0].Id));
                    
                    System.debug('*********************Days Due: '+numberDaysDue+ ' - Agreement: '+bill.cllease__Lease_Account__c+'*********************');
                    
                    if(numberDaysDue >= 30 && numberDaysDue <= 60)
                    {
                        System.debug('*********************For Current Arrears: '+delinquentAmount+'*********************');
                        account[0].Current_Arrears_Amount__c = delinquentAmount;
                        account[0].Pay_Current_Arrears__c = true;
                        
                        if(isAccountPaid == false)
                        {
                            accounts.add(account[0].Id);
                            bulkaccounts.add(account[0]);
                        }
                        System.debug('*********************For Current Arrears Check: '+account[0].Current_Arrears_Amount__c+'*********************');
                    }
                    
                    if(numberDaysDue > 60)
                    {
                        System.debug('*********************For Previous Arrears: '+numberDaysDue+'*********************');
                        account[0].Current_Arrears_Amount__c = delinquentAmount ;
                        account[0].Pay_Current_Arrears__c = true;
                        account[0].Pay_Previous_Arrears__c = true;
                        
                        System.debug('*********************Is Account Paid: '+isAccountPaid +'*********************');
                        
                        if(isAccountPaid == false && String.isBlank(string.ValueOf(account[0].Previous_Arrears_Date__c)))
                        {
                            account[0].Previous_Arrears_Date__c = company.cllease__Current_System_Date__c;
                            accounts.add(account[0].Id);
                            bulkaccounts.add(account[0]);
                        }
                        else
                        {
                            if(isPreviousAccountPaid == false && String.isBlank(string.ValueOf(account[0].Previous_Arrears_Date__c)))
                            {
                                account[0].Previous_Arrears_Date__c = company.cllease__Current_System_Date__c;
                                previousAccounts.add(account[0].Id);
                                previousArrearAccounts.add(account[0]);
                            }
                        }
                    }
                    
                    // increment the instance member counter
                    recordsProcessed = recordsProcessed + 1;
                }
            }
        }
        update bulkaccounts;
        update previousArrearAccounts;
        System.debug('*********************For Bulk Accounts Check: '+bulkaccounts+'*********************');
        
        acnts = [Select Id,Current_Arrears_Amount__c,Pay_Current_Arrears__c,Name From Account where Id NOT IN :accounts FOR UPDATE];
        System.debug('*********************acnts: '+acnts.size()+'*********************');
        List<Account> acntList = new List<Account>();
        Decimal currentArrears = 0;
            
        /*for (String str : accounts)
        {
            System.debug('*********************Finished Account For Loop: '+accounts.contains(str)+'*********************');
            system.debug('********************* Finished Paid Customers count: '+str+'*********************');
        }*/
            
        for(Account acnt:acnts ) 
        {
            Boolean isAccountToPaid = accounts.contains(String.valueOf(acnt.id));
            System.debug('*********************Account For Loop: '+isAccountToPaid+ ' Name: '+ acnt.Name +'*********************');
            
            if(accounts.isEmpty() || isAccountToPaid == false)
            {
                acnt.Current_Arrears_Amount__c = currentArrears;
                acnt.Pay_Current_Arrears__c = false;
                acntList.add(acnt);
                System.debug('*********************Name: '+ acnt.Name +'*********************');
            }
        }
        update acntList;
         System.debug('*********************For Accounts List Check: '+acntList+'*********************');
    }    

    global void finish(Database.BatchableContext bc)
    {
        system.debug('********************* Finished Account Size: '+accounts.size()+'*********************');
        System.debug(recordsProcessed + ' records processed. Deepak!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }    

}