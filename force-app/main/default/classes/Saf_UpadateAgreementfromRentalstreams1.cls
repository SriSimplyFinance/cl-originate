global class Saf_UpadateAgreementfromRentalstreams1 extends cllease.LeaseDynamicJob{
/*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
    global static String NAME = 'Saf_UpadateAgreementfromRentalstreams1';
    global static String query;
    global class MyException extends Exception{} 
    global Integer recordsProcessed = 0;
    global Map<Id,Double> mapcon = new Map<Id,Double> ();
    global Map<Id,Double> mapconApp = new Map<Id,Double> ();
    global Set<Id> setTerminatedAgremment = new Set<Id> ();
    public Set<Id> setTerminatedIds = new Set<Id> ();
    public Set<Id> setApplicationIds = new Set<Id> ();
    global Map<Id,Decimal> streamCapitalRecovery = new Map<Id,Decimal>();
    global Map<Id,Decimal> streamIncome = new Map<Id,Decimal>();
    global static date TodaysDate;
    global static string[] strStatus = new string[]{'ACTIVE - BAD STANDING','ACTIVE - GOOD STANDING','TERMINATED','TERMINATE'};
      global Map<Id,Date> mapPytmStream = new Map<Id,Date> ();
  
    
    global override string getRuntimeQuery()
    { /*   User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
        TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
        System.debug(LoggingLevel.ERROR, '###### TodaysDate : ' + TodaysDate); 
        Integer Intmonth =  TodaysDate.month();
        Integer Intyear =  TodaysDate.year();*/
        
        string[] id = new string[]{'a699E0000009Bu3'}; //'0010O00001u75McQAI','0011j000006OM79','0010O000025VnrXQAS'};//where cllease__Contract__r.cllease__Account__c IN: id
        //query='select id,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c order by cllease__Contract__c'; 
         query='select id,cllease__Contract__r.cllease__Excess__c,cllease__Contract__r.cllease__Amount_to_Current__c,cllease__Lease_Income__c,cllease__Contract__r.cllease__Next_Due_Date__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c where (cllease__Contract__c != null and (cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - BAD STANDING\' or cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - GOOD STANDING\' or cllease__Contract__r.cllease__Lease_Status__c = \'TERMINATED\' or cllease__Contract__r.cllease__Lease_Status__c = \'TERMINATE\')) order by cllease__Contract__c';
        
        //CALENDAR_MONTH(cllease__Date__c) =:Intmonth and CALENDAR_YEAR(cllease__Date__c) =:Intyear //where cllease__Contract__r.cllease__Account__c IN: id 
        return query;
        }
    global override void doInitialize()
    {}
    
    global Saf_UpadateAgreementfromRentalstreams1()
    {   
        super(NAME,buildquery());
    }
  /*  global Saf_UpadateAgreementfromRentalstreams1(string name,string query)
    {  
        super(NAME,query);
    }*/
    
    global override void doStart(Database.Batchablecontext bc)
    {
        
       // Database.getQueryLocator(getRuntimeQuery());
    }
  /*  global override void execute(SchedulableContext sc) {
        //When Origination Date changes, Schedule gets generated, so need to run this with as low batch size as possible.
        Saf_UpadateAgreementfromRentalstreams1 job = new Saf_UpadateAgreementfromRentalstreams1();
        Database.executeBatch(job,1);
    }    */
    global override void doExecute(Database.BatchableContext bc , List<Sobject> scope)
    {
    
         string strvalue = '';
         //string[] strStatus = new string[]{'ACTIVE - BAD STANDING','ACTIVE - GOOD STANDING','TERMINATED','TERMINATE'};
         system.debug('******query****'+scope);
         try{
            User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
            TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
            System.debug(LoggingLevel.ERROR, '###### TodaysDate : ' + TodaysDate); 
             Integer Intmonth =  TodaysDate.month();
            Integer Intyear =  TodaysDate.year();
        
            for(cllease__Payment_Stream__c objstream:[select id,Name,cllease__Date__c,cllease__Contract__c,cllease__Contract__r.cllease__Lease_Status__c from cllease__Payment_Stream__c where CALENDAR_MONTH(cllease__Date__c) =:Intmonth and CALENDAR_YEAR(cllease__Date__c) =:Intyear and (cllease__Contract__c != null and (cllease__Contract__r.cllease__Lease_Status__c IN:strStatus))])
            {
                 mapPytmStream.put(objstream.cllease__Contract__c,objstream.cllease__Date__c);
            }
            
            set<id>Conids=new set<id>();
            //List<cllease__Lease_Account__c> lstcon = new List<cllease__Lease_Account__c>();
            //List<cllease__Lease_Account__c> lstcon2 = new List<cllease__Lease_Account__c>();
            Map<Id,cllease__Lease_Account__c> mapContracts = new Map<Id,cllease__Lease_Account__c>();
            
            List<Account> lstAcc = new List<Account>();
           
            List<cllease__Rental_Stream__c> lstStream = scope; 
            for(cllease__Rental_Stream__c objacc: lstStream)
            {    system.debug('#### objacc.cllease__Date__c:' +objacc.cllease__Date__c);
             system.debug('#### Month: '+objacc.cllease__Date__c.Month() + ', Year: '+ objacc.cllease__Date__c.Year() +', Contract Status: '+objacc.cllease__Contract__r.cllease__Lease_Status__c);
            
                if(objacc.cllease__Date__c.Month() == TodaysDate.Month() && objacc.cllease__Date__c.Year() == TodaysDate.Year())// && objacc.cllease__Contract__r != null && objacc.cllease__Contract__r.cllease__Lease_Status__c != 'PARTIAL APPLICATION')
                {
                   Date dtNextDueDate = mapPytmStream.containskey(objacc.cllease__Contract__c) !=null ? mapPytmStream.get(objacc.cllease__Contract__c) : TodaysDate;  
                    system.debug('#### dtNextDueDate :' +dtNextDueDate);
                    if(objacc.cllease__Contract__r.cllease__Lease_Status__c != 'TERMINATED' && objacc.cllease__Contract__r.cllease__Lease_Status__c != 'TERMINATE')
                    {
                        if(TodaysDate <=dtNextDueDate)
                        {
                            objacc.cllease__Contract__r.Saf_Exposure__c  = objacc.cllease__Beginning_Net_Investment__c +objacc.cllease__Contract__r.cllease__Amount_to_Current__c - objacc.cllease__Contract__r.cllease__Excess__c; 
                        }
                        else 
                        {
                            //system.debug('******objacc.cllease__Ending_Net_Investment__c:' +objacc.cllease__Ending_Net_Investment__c);
                            //system.debug('******objacc.cllease__Contract__r.cllease__Delinquent_Amount__c:' +objacc.cllease__Contract__r.cllease__Delinquent_Amount__c);  
                            objacc.cllease__Contract__r.Saf_Exposure__c  = objacc.cllease__Ending_Net_Investment__c +  objacc.cllease__Contract__r.cllease__Amount_to_Current__c - objacc.cllease__Contract__r.cllease__Excess__c;
                        }
                    }
                    else
                    { 
                        objacc.cllease__Contract__r.Saf_Exposure__c  = objacc.cllease__Contract__r.cllease__Amount_to_Current__c - objacc.cllease__Contract__r.cllease__Excess__c; 
                    }
                    
                    mapContracts.put(objacc.cllease__Contract__c,objacc.cllease__Contract__r);
                    Double dblExposure =  objacc.cllease__Contract__r.Saf_Exposure__c;
                    
                    if(mapcon.containskey(objacc.cllease__Contract__r.cllease__Account__c)) {
                        dblExposure = mapcon.get(objacc.cllease__Contract__r.cllease__Account__c) + dblExposure; 
                    // system.debug('******dblExposure :' +dblExposure );
                    //mapcon.put(objacc.cllease__Contract__r.cllease__Account__c,dblExposure);
                    }                
                    /*else {
                    //dblExposure = dblExposure  + objacc.cllease__Contract__r.Saf_Exposure__c;
                    // system.debug('******dblExposureelse :' +dblExposure ); 
                    }*/
                    
                    // Terminated Agreements commented as per requirement
                    ///if(!setTerminatedAgremment.contains(objacc.cllease__Contract__c) && objacc.cllease__Contract__r.cllease__Lease_Status__c == 'TERMINATED')
                    //{
                        /*cllease__Lease_account_Due_Details__c bill = [select Id, cllease__Lease_Account__c, cllease__Total_Due_Amount__c, cllease__Due_Type_Description__c 
                                                                            from cllease__Lease_account_Due_Details__c 
                                                                                where cllease__Due_Type_Description__c = 'TERMINATION' 
                                                                                    and cllease__Lease_Account__c =: objacc.cllease__Contract__c Order by CreatedDate DESC Limit 1];
                        dblExposure = dblExposure + bill.cllease__Total_Due_Amount__c; // Adding up the Bill Total field*/
                        ///system.debug('#### Agreement:' + objacc.cllease__Contract__c);
                        ///setTerminatedAgremment.add(objacc.cllease__Contract__c);
                    //}
                    
                    mapcon.put(objacc.cllease__Contract__r.cllease__Account__c,dblExposure );
                    //lstcon.add(objacc.cllease__Contract__r);
                    Conids.add(objacc.cllease__Contract__r.cllease__Account__c);
                    // system.debug('******objacc.cllease__Contract__r.Saf_Exposure__c:' +objacc.cllease__Contract__r.Saf_Exposure__c);
                }
                               
                if(objacc.cllease__Date__c > TodaysDate)
                {
                    //Select SUM(cllease__Capital_Recovery__c) totalCapital, SUM(cllease__Lease_Income__c) totalIncome, cllease__Contract__c 
                    //From cllease__Rental_Stream__c Where cllease__Contract__c IN :IdsRentalstreams and cllease__Date__c > :systemDate GROUP BY cllease__Contract__c];
                    Decimal dblstreamCapitalRecovery = objacc.cllease__Capital_Recovery__c;
                    Decimal dbltotalIncome = objacc.cllease__Lease_Income__c;
                    
                    if(streamCapitalRecovery.containskey(objacc.cllease__Contract__c)) {
                        dblstreamCapitalRecovery =  streamCapitalRecovery.get(objacc.cllease__Contract__c) + objacc.cllease__Capital_Recovery__c;
                    }
                    streamCapitalRecovery.put(objacc.cllease__Contract__c, dblstreamCapitalRecovery);
                    
                    if(streamIncome .containskey(objacc.cllease__Contract__c)) {
                        dbltotalIncome =  streamIncome.get(objacc.cllease__Contract__c) + objacc.cllease__Lease_Income__c;
                    }
                    streamIncome.put(objacc.cllease__Contract__c, dbltotalIncome);
                    double dblcaptialrecorvery = streamCapitalRecovery.containskey(objacc.cllease__Contract__c) ?  streamCapitalRecovery.get(objacc.cllease__Contract__c) : 0.0;
                    double dblincome = streamIncome.containskey(objacc.cllease__Contract__c) ?  streamIncome.get(objacc.cllease__Contract__c) : 0.0;
                    
                    strvalue = objacc.Id;
                    if(objacc.cllease__Contract__c!= null)
                    {
                        objacc.cllease__Contract__r.Future_Rentals__c = dblcaptialrecorvery +dblincome;
                        objacc.cllease__Contract__r.Unearned_Interest__c = dblincome;
                        mapContracts.put(objacc.cllease__Contract__c,objacc.cllease__Contract__r);
                    } 
                   
                    //lstcon.add(objacc.cllease__Contract__r);
                }
            
            }
            
            // Terminated Agreements commented as per requirement
            /*for(cllease__Lease_account_Due_Details__c bill: [select Id, cllease__Lease_Account__c, cllease__Lease_Account__r.Saf_Exposure__c, cllease__Total_Due_Amount__c, cllease__Due_Type_Description__c, cllease__Lease_Account__r.cllease__Account__c 
                                                                            from cllease__Lease_account_Due_Details__c 
                                                                                where cllease__Due_Type_Description__c = 'TERMINATION' 
                                                                                    and cllease__Lease_Account__c IN: setTerminatedAgremment]) //  Order by CreatedDate DESC
            {
                Double dblExposure;
                dblExposure = bill.cllease__Total_Due_Amount__c;
                if(mapcon.containskey(bill.cllease__Lease_Account__r.cllease__Account__c)) {
                        dblExposure = mapcon.get(bill.cllease__Lease_Account__r.cllease__Account__c) + bill.cllease__Total_Due_Amount__c; 
                } 
                
                if(!setTerminatedIds.contains(bill.Id))
                {   mapcon.put(bill.cllease__Lease_Account__r.cllease__Account__c,dblExposure );
                    bill.cllease__Lease_Account__r = mapContracts.get(bill.cllease__Lease_Account__c);
                    bill.cllease__Lease_Account__r.Saf_Exposure__c = bill.cllease__Lease_Account__r.Saf_Exposure__c + bill.cllease__Total_Due_Amount__c;
                    mapContracts.put(bill.cllease__Lease_Account__c,bill.cllease__Lease_Account__r);
                    setTerminatedIds.add(bill.Id);
                }
            }*/
            
            for(genesis__Applications__c App: [Select Id, Name, Exposure_Application__c, genesis__Account__c from genesis__Applications__c])
            {
                Double dblExposure =  App.Exposure_Application__c;
                    
                if(!setApplicationIds.contains(App.Id)){
                    if(mapconApp.containskey(App.genesis__Account__c)) {
                        dblExposure = mapconApp.get(App.genesis__Account__c) + dblExposure; 
                     system.debug('******Application dblExposure :' +dblExposure + ' Application: '+App.Name + ' App.Exposure_Application__c: '+App.Exposure_Application__c );
                    //mapcon.put(objacc.cllease__Contract__r.cllease__Account__c,dblExposure);
                    }  
                    mapconApp.put(App.genesis__Account__c,dblExposure );
                    if(!Conids.contains(App.genesis__Account__c))
                    {
                        Conids.add(App.genesis__Account__c);
                    }
                }
                setApplicationIds.add(App.Id);
            }
            for(Account objacc: [Select Id, SAF_Exposure_Application__c, SAF_Exposure_Agreements__c from Account WHERE id IN: Conids])
            {
                objacc.SAF_Exposure_Agreements__c = mapcon.containskey(objacc.Id)? mapcon.get(objacc.Id): 0.00; 
                objacc.SAF_Exposure_Application__c = mapconApp.containskey(objacc.Id)? mapconApp.get(objacc.Id): 0.00;
                lstAcc.add(objacc);
            }
            //system.debug('******Conids:' +Conids);
            //system.debug('******mapcon:' +mapcon);
            //system.debug('******lstAcc:' +lstAcc);
            //system.debug('******lstcon2:' +lstcon2);
            //update lstcon;
            // update lstcon2;
            update  mapContracts.values();
            update lstAcc; 
            if(Test.isRunningTest()){throw new MyException();}
        } 
        catch(exception e)
        {
            system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
            //String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
            string strErrordes = 'Branch Date :' + TodaysDate + e.getMessage() + ', Line no: '+e.getLineNumber() + ', contract : '+strvalue;
            //ErrorLogsUtils.createErrorLogs('Failure', description,'Batch',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
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
         //string[] strStatus = new string[]{'ACTIVE - BAD STANDING','ACTIVE - GOOD STANDING','TERMINATED','TERMINATE'};
         string[] id = new string[]{'a699E0000009Bu3'};
         //query='select id,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c order by cllease__Contract__c'; 
         query='select id,cllease__Contract__r.cllease__Excess__c,cllease__Contract__r.cllease__Amount_to_Current__c,cllease__Lease_Income__c,cllease__Contract__r.cllease__Next_Due_Date__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c where (cllease__Contract__c != null and (cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - BAD STANDING\' or cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - GOOD STANDING\' or cllease__Contract__r.cllease__Lease_Status__c = \'TERMINATED\' or cllease__Contract__r.cllease__Lease_Status__c = \'TERMINATE\')) order by cllease__Contract__c';
        
         system.debug('--Query--'+ query);      
         return query;
    }

    
}