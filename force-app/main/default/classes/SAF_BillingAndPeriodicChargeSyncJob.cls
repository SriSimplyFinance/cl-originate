global class SAF_BillingAndPeriodicChargeSyncJob 
{   public static Set<Id> branchIds = new Set<Id>();
    public static Set<Id> AgreementIds = new Set<Id>();
    public static date TodaysDate;
    public static string AgreementId;
    Webservice static string RunBillingDAG(String Status)
    {   
        string strReturn = System.Label.saf_Billingbutton; 
        if(Status.contains('ACTIVE'))
        {
        clcommon.DynamicJobAPI2 apiHandle = clcommon.APIFactory.getDynamicJobAPI2();
        apiHandle.runOnce(System.Label.saf_Billingbuttondag);//'Billing Job through Button'); 
        } else 
        {strReturn = 'Agreement is not Activated.';}
        return strReturn;
    }
    
   /* Webservice static string generateBillingAndPeriodicJob(String AgreementId,String Status)
    {
        string strReturn = System.Label.saf_Billingbutton;
        User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
        TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
        cllease__Office_Name__c objofc = [Select Id, Name,cllease__Is_Branch__c from cllease__Office_Name__c where cllease__Is_Branch__c =: true];
        branchIds.add(objofc.Id);       
        AgreementIds.add(AgreementId);
        //strAgreementId = AgreementId;
         if(Status.contains('ACTIVE'))
         {
            system.debug('***Billing AgreementIds : ' +AgreementIds);
            
            
            cllease.BillGeneratorJob objbill = new cllease.BillGeneratorJob(TodaysDate, branchIds, AgreementIds);
            Database.executebatch(objbill,1);
            
             // schedule the class after 2 mins
           /* Datetime sysTime = System.now().addSeconds(10); 
            system.debug('====sysTime with add 10secs===='+sysTime);     
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            system.debug('====chronExpression===='+chronExpression);    
            String jId = System.schedule( 'Start BillDetailGeneratorJob' + sysTime, chronExpression, new cllease.BillDetailGeneratorJob (TodaysDate, branchIds, AgreementIds));
           */
            //cllease.BillDetailGeneratorJob bill = new cllease.BillDetailGeneratorJob(TodaysDate, branchIds, AgreementIds);
            //Database.executebatch(bill,1);
            
           /* Datetime sysTime2 =sysTime.addSeconds(10); 
            system.debug('====sysTime2with add 10secs===='+sysTime2);     
            String chronExpression2 = '' + sysTime2.second() + ' ' + sysTime2.minute() + ' ' + sysTime2.hour() + ' ' + sysTime2.day() + ' ' + sysTime2.month() + ' ? ' + sysTime2.year();
            system.debug('====chronExpression2===='+chronExpression2);    
            String jIdperiodic = System.schedule( 'Start PeriodicJob' + sysTime2, chronExpression2, new cllease.PeriodicChargeGeneratorJob(TodaysDate, branchIds, AgreementIds));
           
            
            
             AsyncExecutionPeriodicJob objPerJob = new AsyncExecutionPeriodicJob(); 
            objPerJob.TodaysDate = TodaysDate; 
            objPerJob.AgreementIds.addall(AgreementIds);
            objPerJob.branchIds.addall(branchIds);
            System.enqueueJob(objPerJob);
            
            AsyncExecutionBillingJob obj = new AsyncExecutionBillingJob(); 
            obj.TodaysDate = TodaysDate; 
            obj.AgreementIds.add(AgreementId);
            obj.branchIds.add(objofc.Id);
            System.enqueueJob(obj);
           
        }
        else 
        {strReturn = 'Agreement is not Activated.';}
      
        //bill.BillDetailGeneratorJob(TodaysDate, branchIds, AgreementIds);
        
        //cllease__Lease_Account__c contract = [select Id from cllease__Lease_Account__c where Id =: AgreementId];
        //new cllease.PeriodicChargeJob('select Id from cllease__Lease_Account__c where Id =:'+ AgreementId, false, TodaysDate, branchIds);
        return strReturn;
    
    }
  
   public class AsyncExecutionBillingJob implements Queueable {
        public Set<Id> branchIds = new Set<Id>();
        public Set<Id> AgreementIds = new Set<Id>();
        public date TodaysDate;
        public void execute(QueueableContext context) {
            // Your processing logic here       
       
            //new cllease.BillDetailGeneratorJob(TodaysDate, branchIds, AgreementId); 
            //cllease.BillDetailGeneratorJob bill = new cllease.BillDetailGeneratorJob();//(TodaysDate, branchIds, AgreementId);
            cllease.BillGeneratorJob bill = new cllease.BillGeneratorJob(TodaysDate, branchIds, AgreementIds);
            Database.executebatch(bill,1);
           
            AsyncExecutionPeriodicJob objPerJob = new AsyncExecutionPeriodicJob(); 
            objPerJob.TodaysDate = TodaysDate; 
            objPerJob.AgreementIds.addall(AgreementIds);
            objPerJob.branchIds.addall(branchIds);
            System.enqueueJob(objPerJob);
            // Chain this job to next job by submitting the next job
           
        }
       
    }
     public class AsyncExecutionPeriodicJob implements Queueable {
        public Set<Id> branchIds = new Set<Id>();
        public Set<Id> AgreementIds = new Set<Id>();
        public date TodaysDate;
        public void execute(QueueableContext context) { 
           
            system.debug('***AgreementIds : ' +AgreementIds);
            cllease.PeriodicChargeGeneratorJob objchr = new cllease.PeriodicChargeGeneratorJob(TodaysDate, branchIds, AgreementIds);
            Database.executebatch(objchr,1);
            //System.enqueueJob(new cllease.BillDetailGeneratorJob(TodaysDate, branchIds, AgreementIds));
            // Chain this job to next job by submitting the next job
            
        }
       }*/
}