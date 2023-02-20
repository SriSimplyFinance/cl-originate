/**
*
* @Name                 : UpdateAccountAutoAlerts 
* @Author               : Deepak - Happiest minds 
* @Description          : This Batch class is used to update Account field for Auto Alerts
* @Created date         : 28-08-2018
*
**/

global class UpdateAccountAutoAlerts1 extends cllease.LeaseDynamicJob { 

    // instance member to retain state across transactions
    global static String NAME = 'UpdateAccountAutoAlerts1';
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
    
    //Error Log Starts
    public string strDateFormat = 'ddMMyyyy';
    public User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
    public Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
    //Error Log Ends

    global override string getRuntimeQuery()
    {
        Boolean isSatisified = false;
        //String query = 'SELECT Id,Name,cllease__Lease_Account__c, cllease__Due_Date__c, cllease__Payment_Satisfied__c, cllease__Account__c,cllease__Account__r.Current_Arrears_Amount__c FROM cllease__Lease_account_Due_Details__c where cllease__Lease_Account__c=:Id';
        String query = 'SELECT Id,Name,cllease__Lease_Account__c, cllease__Due_Date__c, cllease__Payment_Satisfied__c, cllease__Account__c,cllease__Account__r.Current_Arrears_Amount__c FROM cllease__Lease_account_Due_Details__c WHERE cllease__Payment_Satisfied__c = false';
        return query;
    }
       global override void doStart(Database.Batchablecontext bc)
    {
        
       // Database.getQueryLocator(getRuntimeQuery());
    }
    global UpdateAccountAutoAlerts1()
    {   
        super(NAME,buildquery());
    }
     global override void doInitialize()
    {}
    global override void doExecute(Database.BatchableContext bc, List<Sobject> scope)
    {
        try{
            // process each batch of records
            bulkaccounts= new List<Account>();
            previousArrearAccounts = new  List<Account>();
            
            System.debug('*********************Query: '+scope+'*********************');
            Integer numberDaysDue;
            cllease__Office_Name__c company = [SELECT Id, Name,cllease__Current_System_Date__c FROM cllease__Office_Name__c Limit 1];
                
            System.debug('*********************System Date: '+company.cllease__Current_System_Date__c+'*********************');
             List<cllease__Lease_account_Due_Details__c> lstbills = (List<cllease__Lease_account_Due_Details__c>) scope;
             
            // Getting the Related customers from Non Satisfied Bill and Processing Arrear details from bills
            for(cllease__Lease_account_Due_Details__c bill : lstbills) 
            {
               
                accountIds.add(bill.cllease__Account__c);
                
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
                
            }
            
            //Calculating the Delinquent Amount for Each customer
            for(cllease__Lease_Account__c Agreeements: [SELECT Id, cllease__Account__c, SAF_AutoAlert_Cal__c, cllease__Delinquent_Amount__c FROM cllease__Lease_Account__c where cllease__Account__c = :accountIds ORDER BY cllease__Account__c ASC])
            {
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
            }
            
            // Processing the selected Accounts
            for (Account act: [Select Id,Current_Arrears_Amount__c,Pay_Current_Arrears__c,Previous_Arrears_Date__c,Name From Account where Id IN:accounts])
            {
                act.Current_Arrears_Amount__c = DA_map.get (act.Id) != null? DA_map.get (act.Id): 0.00;
                act.Pay_Current_Arrears__c    = PCA_map.get(act.Id) != null? PCA_map.get(act.Id): false;
                act.Pay_Previous_Arrears__c   = PPA_map.get(act.Id) != null? PPA_map.get(act.Id): false;
                //system.debug('###Pay Previous Arrears: '+ PPA_map.get(act.Id));
                if(String.isBlank(string.ValueOf(act.Previous_Arrears_Date__c))) { act.Previous_Arrears_Date__c  = PAD_map.get(act.Id);}
                bulkaccounts.add(act);
            }
            update bulkaccounts; // Updating all the accounts
            
            // Processing the remaining accounts which are not selected from the above bills
            acnts = [Select Id,Current_Arrears_Amount__c,Pay_Current_Arrears__c,Name From Account where Id NOT IN :accounts];// FOR UPDATE];
            System.debug('*********************acnts: '+acnts.size()+'*********************');
            List<Account> acntList = new List<Account>();
            Decimal currentArrears = 0;
                
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
            update acntList; // Updating the non selected bills
            System.debug('*********************For Accounts List Check: '+acntList+'*********************');
        }
        catch(exception e)
        {
            system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
           
            string strErrordes = 'Branch Date : ' + TodaysDate + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
        }
    }    

     global override void doFinish(Database.BatchableContext bc)
    {       System.debug('Records processed: ' + recordsProcessed);
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job : ' + job);
    }
      global static string buildquery(){
        //build query.
         string query = 'SELECT Id,Name,cllease__Lease_Account__c, cllease__Due_Date__c, cllease__Payment_Satisfied__c, cllease__Account__c,cllease__Account__r.Current_Arrears_Amount__c FROM cllease__Lease_account_Due_Details__c WHERE cllease__Payment_Satisfied__c = false';
       
         system.debug('--Query--'+ query);      
         return query;
    }

}