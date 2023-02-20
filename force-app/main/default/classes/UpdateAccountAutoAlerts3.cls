/**
*
* @Name                 : UpdateAccountAutoAlerts3 
* @Author               : Happiest minds - Megha
* @Description          : This Batch class is used to update Account field for Auto Alerts Modified class on mar24 to resolve CPU timelimit error
* @Created date         : 24-03-2020
*
**/

global class UpdateAccountAutoAlerts3 extends cllease.LeaseDynamicJob
{   
    // instance member to retain state across transactions
    global static String NAME = 'UpdateAccountAutoAlerts3';
    global Integer recordsProcessed = 0;
    global Set<String> accounts= new Set<String>();
    global Set<String> previousAccounts= new Set<String>();
    global List<Account> bulkaccounts = new List<Account>(), previousArrearAccounts = new List<Account>();
    //global String Id = 'a696E0000000J4ZQAU';
    global list<Account> acnts = new List<Account>();
    
    public Map<Id,Double>  CAA_map = new Map<Id,Double> ();
    public Map<Id,Boolean> PCA_map = new Map<Id,Boolean> ();
    public Map<Id,Boolean> PPA_map = new Map<Id,Boolean> ();
    public Map<Id,Date>    PAD_map = new Map<Id,Date> ();
    public Map<Id,Double>  DA_map  = new Map<Id,Double> ();
    public Set<Id> accountIds= new Set<Id> (), agreementIds= new Set<Id> ();
     global UpdateAccountAutoAlerts3()
    {   
       super(NAME,buildquery());
    } 
    global override void doInitialize()
    {}
     global override string getRuntimeQuery()
    { 
    //Error Log Starts
   /* public string strDateFormat = 'ddMMyyyy';
    public User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
    public Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c; */
    //Error Log Ends
        string query = 'SELECT Id,Name,cllease__Lease_Account__c, cllease__Due_Date__c, cllease__Payment_Satisfied__c, cllease__Account__c FROM cllease__Lease_account_Due_Details__c WHERE cllease__Payment_Satisfied__c = false';
        system.debug('========= query ========'+query); 
        return query;
     }
     global override void dostart(Database.BatchableContext BC){        
   }
    global override void doexecute(Database.BatchableContext BC, list<sobject>scope)
    {
        try{
            // process each batch of records
            bulkaccounts= new List<Account>();
            previousArrearAccounts = new  List<Account>();
            
            System.debug('*********************Query: '+scope+'*********************');
            Integer numberDaysDue;
            cllease__Office_Name__c company = [SELECT Id, Name,cllease__Current_System_Date__c FROM cllease__Office_Name__c Limit 1];
                
            System.debug('*********************System Date: '+company.cllease__Current_System_Date__c+'*********************');
             List<cllease__Lease_account_Due_Details__c> lstbills = scope;
             System.debug('*********************lstbills: '+lstbills.size()+'*********************');
            // Getting the Related customers from Non Satisfied Bill and Processing Arrear details from bills
            for(cllease__Lease_account_Due_Details__c bill : lstbills) 
            {
               System.debug('BillName: ' + bill.Name);
                System.debug('CPU Usage in billforloop1: ' +  Limits.getCpuTime());
                accountIds.add(bill.cllease__Account__c);
                System.debug('*********************accountIds: '+accountIds.size()+'*********************');
                System.debug('*********************accountIds: '+accountIds+'*********************');
                Boolean isAccountPaid,isPreviousAccountPaid;
                
                numberDaysDue           = bill.cllease__Due_Date__c.daysBetween(company.cllease__Current_System_Date__c);
                
                if(numberDaysDue >= 30 && numberDaysDue <= 60)
                {
                    if(!PCA_map.ContainsKey(bill.cllease__Account__c))
                    {
                        PCA_map.put(bill.cllease__Account__c, true);
                        accounts.add(bill.cllease__Account__c);
                    }
                }
                
                if(numberDaysDue > 60)
                {
                    PCA_map.put(bill.cllease__Account__c, true);
                    PPA_map.put(bill.cllease__Account__c, true);
                    PAD_map.put(bill.cllease__Account__c, company.cllease__Current_System_Date__c);
                    accounts.add(bill.cllease__Account__c);
                }
                System.debug('CPU Usage in billforloop2: ' +  Limits.getCpuTime());
            }
            
            List<cllease__Lease_Account__c> Agreementlist = [SELECT Id, cllease__Account__c, SAF_AutoAlert_Cal__c, cllease__Delinquent_Amount__c FROM cllease__Lease_Account__c where cllease__Account__c = :accountIds ORDER BY cllease__Account__c ASC];
            //Calculating the Delinquent Amount for Each customer
            System.debug('*********************Agreementlist: '+Agreementlist.size()+'*********************');
            for(cllease__Lease_Account__c Agreeements: Agreementlist)
            {
                System.debug('CPU Usage in Agreeementsforloop1: ' +  Limits.getCpuTime());
                Decimal delinquentAmount = Agreeements.SAF_AutoAlert_Cal__c;
                
                if(!agreementIds.contains(Agreeements.Id)) // !DA_map.ContainsKey(Agreeements.cllease__Account__c)
                {
                    if(DA_map.ContainsKey(Agreeements.cllease__Account__c))
                    {
                        delinquentAmount = DA_map.get(Agreeements.cllease__Account__c) + delinquentAmount;
                    }
                    DA_map.put(Agreeements.cllease__Account__c, delinquentAmount);
                    agreementIds.add(Agreeements.Id);
                }
                //Decimal delinquentAmount = (Decimal)[SELECT SUM(cllease__Delinquent_Amount__c) currentArrears FROM cllease__Lease_Account__c where cllease__Account__c = :accountId][0].get('currentArrears');
               System.debug('CPU Usage in Agreeementsforloop2: ' +  Limits.getCpuTime());
            }
            
             List<Account> AccountList = [Select Id,Current_Arrears_Amount__c,Pay_Current_Arrears__c,Previous_Arrears_Date__c,Name From Account where Id IN:accounts];
            // Processing the selected Accounts
            System.debug('*********************AccountList : '+AccountList.size()+'*********************');
            for (Account act: AccountList)
            {
                System.debug('CPU Usage in Accountforloop1: ' +  Limits.getCpuTime());
                act.Current_Arrears_Amount__c = DA_map.get (act.Id) != null? DA_map.get (act.Id): 0.00;
                act.Pay_Current_Arrears__c    = PCA_map.get(act.Id) != null? PCA_map.get(act.Id): false;
                act.Pay_Previous_Arrears__c   = PPA_map.get(act.Id) != null? PPA_map.get(act.Id): false;
                //system.debug('###Pay Previous Arrears: '+ PPA_map.get(act.Id));
                if(String.isBlank(string.ValueOf(act.Previous_Arrears_Date__c))) { act.Previous_Arrears_Date__c  = PAD_map.get(act.Id);}
                bulkaccounts.add(act);
                System.debug('CPU Usage in Accountforloop2: ' +  Limits.getCpuTime());
            }
            update bulkaccounts; // Updating all the accounts
            
            // Processing the remaining accounts which are not selected from the above bills
           acnts = [Select Id,Current_Arrears_Amount__c,Pay_Current_Arrears__c,Name From Account where Id NOT IN :accounts FOR UPDATE];
            System.debug('*********************acnts: '+acnts.size()+'*********************');
            List<Account> acntList = new List<Account>();
            Decimal currentArrears = 0;
                
            for(Account acnt:acnts ) 
            {
               System.debug('CPU Usage in Accforloop1: ' +  Limits.getCpuTime()); 
                Boolean isAccountToPaid = accounts.contains(String.valueOf(acnt.id));
                System.debug('*********************Account For Loop: '+isAccountToPaid+ ' Name: '+ acnt.Name +'*********************');
                
                if((accounts.isEmpty() || isAccountToPaid == false) && (acnt.Current_Arrears_Amount__c != 0 && acnt.Pay_Current_Arrears__c != false))
                {
                    acnt.Current_Arrears_Amount__c = currentArrears;
                    acnt.Pay_Current_Arrears__c = false;
                    acntList.add(acnt);
                    System.debug('*********************Name: '+ acnt.Name +'*********************');
                }
                System.debug('CPU Usage in Accforloop2: ' +  Limits.getCpuTime());
            }
            System.debug('CPU Usage in Accforloop3: ' +  Limits.getCpuTime());
            update acntList; // Updating the non selected bills
            System.debug('*********************For Accounts List Check: '+acntList+'*********************');
        }
        catch(exception e)
        {
            system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
           
           // string strErrordes = 'Branch Date : ' + TodaysDate + e.getMessage() + ', Line no: '+e.getLineNumber();
           // ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
           // 'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
        }
    }    

      global override void dofinish(Database.BatchableContext BC){
           System.debug('Records processed: ' + recordsProcessed);
           AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job : ' + job);
    } 
    global static string buildquery(){
    string query = 'SELECT Id,Name,cllease__Lease_Account__c, cllease__Due_Date__c, cllease__Payment_Satisfied__c, cllease__Account__c FROM cllease__Lease_account_Due_Details__c WHERE cllease__Payment_Satisfied__c = false';
        system.debug('========= query ========'+query); 
        return query;
      }

}