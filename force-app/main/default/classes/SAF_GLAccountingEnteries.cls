global class SAF_GLAccountingEnteries
{
    public Transient String strBody {get;set;}
    public String strfields = 'Id';
    public class MyException extends Exception{}
    public cllease__Lease_Account__c Contract{get;set;} 
    public Manual_GL__c ManualGL{get;set;} 
    public Manual_GL__c ManualGLAccount{get;set;} 
    public Date ToDate{get;set;}  
    public Date FromDate{get;set;} 
    public datetime dtstarted{get;set;}
    public Transient List<Manual_GL__c> lstManualGlEntry {get;set;} 
    //variable used in page.
     Public Integer size{get;set;}
     Public Integer noOfRecords{get; set;}
     public List<SelectOption> paginationSizeOptions{get;set;}
     public static final Integer QUERY_LIMIT = Integer.valueof(Saf_setting__c.getOrgDefaults().GlSolution_QueryLimit__c);//2000
     public static final Integer PAGE_SIZE =  Integer.valueof(Saf_setting__c.getOrgDefaults().GlSolution_PageSize__c);//10
      private String sortDirection = 'ASC';
      private String sortExp = 'createddate';
  /*  public List<SAF_Duedil.CustomerInfo> CustomerInfo{get;set;} 
    public Integer Totalcount{get;set;} 
    public String Strlimit{get;set;}
    public String Stroffset{get;set;}
    public Integer PaginationStart{get;set;} 
    public Integer PaginationEnd{get;set;} 
    public Integer NonLimitedCust = 10000, ReduceCount = 2, Lastrecord;
    public boolean FoundLastPage{get;set;}
    public String LimitDefault = '20', OffSetDefault='0';*/
    //public List<Account> Recid{get;set;}
   
    //Error Log Starts
    public string strDateFormat = 'ddMMyyyy';
    public User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
    public Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
    //Error Log Ends
    public void SAF_GLAccountingEnteries()
    {
       //constructor calling init method.
           strbody ='';
     
           List<clcommon__DAG_Schedule__c> lstdag = [select Id,Name,clcommon__Cron_Expression__c,clcommon__DAG_Name__c from clcommon__DAG_Schedule__c where clcommon__DAG_Name__c =: 'GL Entry jobs' ];
            system.debug('lstdag  :' + lstdag );   
           list<clcommon__DAG_Logging__c> lastLogs =  [select Id,NAme,clcommon__DAG__c,clcommon__Start_Time__c,clcommon__Finish_Time__c,clcommon__Status__c  from clcommon__DAG_Logging__c where clcommon__DAG__c =: lstdag[0].Id and clcommon__Start_Time__c != null order by createddate desc limit 1];
           
           if(lastLogs.size() >0 )
           {
               //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Jobs ' + lastLogs[0].clcommon__Status__c + ' Finish time : ' + lastLogs[0].clcommon__Finish_Time__c +' Please refresh...'));
               system.debug('Jobs ' + lastLogs[0].clcommon__Status__c + ' Finish time : ' + lastLogs[0].clcommon__Finish_Time__c +' Please refresh...');
          }
           
           
            system.debug('lastLogs :' + lastLogs);   
             init();
       
    
    }
    public void pageInit()
    {
        //this.disable = false;
       
        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'STARTS: '+disable));
    }
     /** Instantiate the StandardSetController from a query locater*/
     
     public ApexPages.StandardSetController setCon {
     get {
     if(setCon == null) {
           system.debug('ManualGL :' + ManualGL);
            String strQuery = 'Select Id,MN_Company__r.Name,MN_Contract__r.Name,Saf_GL_Accounting_Entries__r.Name,Saf_Payment_Mode__r.Name';
            for(Schema.FieldSetMember fl:getGLFields())
            {
                strQuery += ',' + fl.getFieldPath(); 
                
                strfields += ',' +  fl.getLabel();         
            }
            // ManualGL.MN_Contract__c = 'a690O000000gC8p';
           if(ManualGL != null)
            {
              string conId = ManualGL.MN_Contract__c;
               system.debug('conId :' + conId );
              strQuery += ' FROM Manual_GL__c where MN_Contract__c =:conId order by MN_Contract__c desc Limit : QUERY_LIMIT';
            }
            else
            {
                Integer lt = 5000;
                strQuery += ' FROM Manual_GL__c order by MN_Contract__c desc Limit : QUERY_LIMIT'; 
            }
            
           // CustomerName = ManualGL.MN_Contract__c;
            system.debug('strQuery :' + strQuery );
            //lstManualGlEntry = Database.query(strQuery);
             setCon = new ApexPages.StandardSetController( Database.query(strQuery));
             
            //ManualGL = lstManualGlEntry[0];
            //ManualGL.MN_GL_Account__c = null;
     
     
       // sets the number of records to show in each page view
       setCon.setPageSize(PAGE_SIZE);
     }
       return setCon;
     }
     set;
     }
    public void DownloadDoc()
    {
         try 
         {
             //setCon.save();
             string id = Apexpages.currentpage().getparameters().get('Id');
             system.debug('id:' + id);
            
            Document document = new Document();
            document.AuthorId = UserInfo.getUserId();
            string DocumentName = 'GL_1.csv';
            Document.name = DocumentName;
            document.FolderId = UserInfo.getUserId(); // put it in running user's folder//FolderId; //
            integer i =0;
             strfields += ',Payment Mode, Payment Reference,GL Account Name';     
            for(Manual_GL__c obj: lstManualGlEntry)
            {
                /* strbody += obj.Id + ',' + obj.Name + ',' + obj.GL_Account_Type__c + ',' + obj.saf_Reference__c + ',' + obj.MN_Company__c + ',' + obj.MN_Contract__c + ',' +
                obj.MN_Exported_Date__c + ',' + obj.CreatedDate + ',' + obj.LastModifiedDate + ',' + obj.MN_Transaction_type1__c + ',' + obj.MN_Transaction_ID__c + ',' +
                obj.MN_Transaction_Description__c + ',' + obj.Saf_Payment_Mode__c + ',' + obj.MN_Transaction_Sub_Type__c + ',' + obj.MN_GL_Account__c + ',' +
                obj.MN_GL_Account_Code_c__c + ',' + obj.MN_Amount__c +'\n';*/
                i = i+1;
              //  if(i == 1000) { break ;}
                
                strbody += obj.Id + ',' + obj.Name + ',' + obj.MN_Company__r.Name + ',' +  obj.saf_Product__c + ','+ obj.MN_Contract__r.Name + ',' +  obj.saf_Customer__c + ',' + 
                obj.saf_GLEntry_CreatedDate__c + ',' + obj.CreatedDate + ',' + obj.LastModifiedDate + ',' + obj.MN_GL_Date__c + ',' + obj.MN_Transaction_type1__c + ',' + obj.MN_Transaction_ID__c + ',' +
                obj.MN_Transaction_Description__c + ',' + obj.saf_Reference__c + ',' + obj.MN_GL_Account__c + ',' +
                obj.MN_GL_Account_Code_c__c + ','+ obj.GL_Account_Type__c + ',' + obj.Saf_GL_Accounting_Entries__r.Name + ',' + obj.MN_Amount__c + ',' + obj.SAF_GL_Reversal__c + ',' +
                obj.Saf_Payment_Mode__r.Name + ',' + obj.saf_Payment_Reference__c + ',' + obj.MN_GL_Account__r.Name + '\n';
            }
            i=0;
            strbody = strbody.removestart('null');
            document.body = blob.valueof(strfields +'\n' +strbody);
            //document.name = 'cais.txt';
            //insert document;
           // string id = Apexpages.currentpage().getparameters().get('Id');
           // string id = '0159E0000007jpVQAQ';
           // Document doc = [Select Id,Name,BodyLength,Body,AuthorId,LastModifiedDate,LastViewedDate from Document WHERE Id =: id];
            strbody = document.body.tostring();
          }  
         catch(Exception e)
            {         
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in download:' + e.getMessage()+ ', Line no: '+e.getLineNumber()));
             system.debug('Error in download:' + e.getMessage()+ ', Line no: '+e.getLineNumber());
            //string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + 'Line no: '+e.getLineNumber();
            //ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            //'GetAccount',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            }
    }
     //Init method which queries the records from standard set controller.
     public void init() {
     lstManualGlEntry = new List<Manual_GL__c>();
     try{
     for (Manual_GL__c cont : (List<Manual_GL__c>)setCon.getRecords()) {
    
               lstManualGlEntry.add(cont);
     
         }
            if(lstManualGlEntry.size() >0)
             {
               ManualGL = lstManualGlEntry[0];
               //ManualGL.MN_GL_Account__c = null;
             }
             
         setCon.save();
        }
        catch(exception e){}
     }
 
  public void Runjobs() {
    
     datetime dtstarted = datetime.Now();
     system.debug('ManualGL.MN_GL_Account__c : ' + ManualGL.MN_Contract__c);
     If(ManualGL.MN_Contract__c != null)
     {
           List<clcommon__Job__c> lstComJob = [Select Id,Name,clcommon__Query__c,clcommon__DAG__r.Name,clcommon__DAG__c,clcommon__Label__c from clcommon__Job__c where clcommon__DAG__r.clcommon__DAG_Name__c =: 'GL Entry jobs' and clcommon__Label__c =:'GLTransactionGeneratorJob' Limit 1] ;
            system.debug('lstComJob  : ' + lstComJob );
          
           for (clcommon__Job__c obj : lstComJob)
           {
      
               obj.clcommon__Query__c = 'SELECT Id, Name FROM cllease__Lease_Account__c WHERE cllease__Invalid_Data__c = false AND (cllease__Active_flag__c = true or cllease__Installation_Flag__c = true) and Id ='+ '\'' + ManualGL.MN_Contract__c +'\'';
               system.debug('obj.clcommon__Query__c : ' + obj.clcommon__Query__c );
              
           }
             update lstComJob;
             clcommon.DynamicJobAPI2 apihandle = clcommon.APIFactory.getDynamicJobAPI2();
             apihandle.runonce('GL Entry jobs');
    
             init();
           //
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'PLEASE WAIT... Batch jobs Running for Agreement ' + ManualGL.MN_Contract__r.Name +' Start Time : '+ dtstarted ));
      }
     }
    
      public void RunjobsReverse() {
    
     datetime dtstarted = datetime.Now();
     system.debug('ManualGL.MN_GL_Account__c : ' + ManualGL.MN_Contract__c);
     If(ManualGL.MN_Contract__c != null)
     {
           List<clcommon__Job__c> lstComJob = [Select Id,Name,clcommon__Query__c,clcommon__DAG__r.Name,clcommon__DAG__c,clcommon__Label__c from clcommon__Job__c where clcommon__DAG__r.clcommon__DAG_Name__c =: 'GL Reverse Entry jobs' and clcommon__Label__c =:'GLReversalJob' Limit 1] ;
            system.debug('lstComJob  : ' + lstComJob );
          
           for (clcommon__Job__c obj : lstComJob)
           {
      
               obj.clcommon__Query__c = 'SELECT Id, Name FROM cllease__Lease_Account__c WHERE cllease__Invalid_Data__c = false AND (cllease__Active_flag__c = true or cllease__Installation_Flag__c = true) and Id ='+ '\'' + ManualGL.MN_Contract__c +'\'';
               system.debug('obj.clcommon__Query__c : ' + obj.clcommon__Query__c );
              
           }
             update lstComJob;
             clcommon.DynamicJobAPI2 apihandle = clcommon.APIFactory.getDynamicJobAPI2();
             apihandle.runonce('GL Reverse Entry jobs');
    
             init();
           //
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'PLEASE WAIT... Reversal Batch jobs Running for Agreement ' + ManualGL.MN_Contract__r.Name +' Start Time : '+ dtstarted ));
      }
     }
    public void search()
    {
        try
        {
           //if(todate < fromdate ) {  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'End Date should be greater than Start Date.'));}
            //this.disable = true;
             // lstManualGlEntry = new List<Manual_GL__c>();              
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'If Str Offset: '+Stroffset));
            //this.paginationFirst();
         
             String strQuery = 'Select Id,MN_Company__r.Name,MN_Contract__r.Name,Saf_GL_Accounting_Entries__r.Name,Saf_Payment_Mode__r.Name,Saf_Payment_Mode__c,saf_Payment_Reference__c,MN_GL_Account__r.Name';
            for(Schema.FieldSetMember fl:getGLFields())
            {
                strQuery += ',' + fl.getFieldPath();  
                system.debug('Query after schema:'+ strQuery );         
            }
            // ManualGL.MN_Contract__c = 'a690O000000gC8p';
           if(ManualGL != null)
            {
              string conId = ManualGL.MN_Contract__c;
               system.debug('conIdin :' + conId );
               //ManualGLAccount = ManualGL;
               string concode = ManualGL.MN_GL_Account__c;
               system.debug('concode :' + concode );
               
                 string GLEntry = ManualGL.Saf_GL_Accounting_Entries__c;
               system.debug('GLEntry :' + GLEntry );
               
               strQuery += ' FROM Manual_GL__c where MN_Contract__c =:conId';
              if(concode != null)
              {
                strQuery += ' and MN_GL_Account__c=:concode';
                //strQuery += ' FROM Manual_GL__c where MN_Contract__c =:conId order by MN_Contract__c desc Limit : QUERY_LIMIT';
              }
              if(ManualGL.Saf_GL_Accounting_Entries__c != null)
              {
                strQuery += ' and Saf_GL_Accounting_Entries__c =:GLEntry';
                //strQuery += ' FROM Manual_GL__c where MN_Contract__c =:conId order by MN_Contract__c desc Limit : QUERY_LIMIT';
              }
               if(todate != null || fromDate !=null) {
              
                   if(todate == fromdate){ fromdate = fromdate.adddays(1); } 
                    Date startDate = (todate == null) ? date.today() : Date.valueof(todate.year() + '-' + todate.month() + '-' + todate.day());
                    Date EndDate = (fromdate==null) ? date.today() : Date.valueof(fromdate.year() + '-' + fromdate.month() + '-' + fromdate.day());
                  
                  
                   strQuery += ' and (Createddate >=:startDate and Createddate <=:EndDate)';
                   // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,String.valueof(startDate)+' '+ String.valueof(EndDate)));
               
              }
             
            strQuery += ' order by ' + sortExpression  + ' ' + sortDirection +   ' Limit : QUERY_LIMIT';
            }
           
            
           // CustomerName = ManualGL.MN_Contract__c;
           system.debug('strQuery :' + strQuery );
           setCon = new ApexPages.StandardSetController(Database.query(strQuery));
          
           setCon.setPageSize(PAGE_SIZE);
           init();
           //setCon.save();
            // sets the number of records to show in each page view
           //setCon.setPageSize(PAGE_SIZE);
           // lstManualGlEntry = Database.query(strQuery);
           
            /* if(lstManualGlEntry.size() >0)
             {
               ManualGL = lstManualGlEntry[0];
               ManualGL.MN_GL_Account__c = null;
             }*/
           
        }
        catch(Exception e)
        {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ e.getMessage()+ ', Line no: '+e.getLineNumber()));
            system.debug('Error: in search'+ e.getMessage()+ ', Line no: '+e.getLineNumber());
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            //string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            //ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            //    'Search',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
  
    private List<Schema.FieldSetMember> getFields(SobjectType sobjType) {
            Map<String, Schema.FieldSet> fsMap = sobjType.getDescribe().FieldSets.getMap();
            return fsMap.get('ManualGLTxnFieldSet').getFields();
        }

        public List<Schema.FieldSetMember> getGLFields() {
            return getFields(Manual_GL__c.SobjectType);
        }
 
    
          /** indicates whether there are more records after the current page set.*/
         public Boolean hasNext {
         get {
           return setCon.getHasNext();
         }
         set;
         }
         
         /** indicates whether there are more records before the current page set.*/
         public Boolean hasPrevious {
         get {
           return setCon.getHasPrevious();
         }
         set;
         }
         
         /** returns the page number of the current page set*/
         public Integer pageNumber {
         get {
           return setCon.getPageNumber();
         }
         set;
         }
         
         /** return total number of pages for page set*/
           Public Integer getTotalPages(){
           try{
             Decimal totalSize = setCon.getResultSize();
             Decimal pageSize = setCon.getPageSize();
             Decimal pages = totalSize/pageSize;
             return (Integer)pages.round(System.RoundingMode.CEILING);
             }
             catch(exception e){return 1;}
         }
         
            public void setsize() {
             try 
             {
                //setCon.setPageSize(QUERY_LIMIT);
                //init();
                 setCon.save();
                 setCon.first();
                 lstManualGlEntry = new List<Manual_GL__c>();

                    while(setCon.getHasNext())
                    {
                        for(Manual_GL__c testRecord : (List<Manual_GL__c>) setCon.getRecords())
                        {
                            lstManualGlEntry.add(testRecord);
                        }
                        setCon.next();
                    }
                  for(Manual_GL__c testRecord : (List<Manual_GL__c>) setCon.getRecords())
                        {
                            lstManualGlEntry.add(testRecord);
                        }
                Downloaddoc();
               // setCon.setPageSize(PAGE_SIZE);
               // setCon.save();
            }
             catch(Exception e)
            {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ e.getMessage()+ ', Line no: '+e.getLineNumber()));
            }
         }
         
         public pageReference ViewData()
            {
            
             //build the full sort expression
               string sortFullExp = sortExpression  + ' ' + sortDirection;
              
                           
                search();
                return null;
            }
            
            

   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

         public String getSortDirection()
         {
            //if not column is selected 
            if (sortExpression == null || sortExpression == '')
              return 'ASC';
            else
             return sortDirection;
         }
        
         public void setSortDirection(String value)
         {  
           sortDirection = value;
         }
     /** returns the previous page of the page set*/
         public void previous() {
         try{
           setCon.save();
           setCon.previous();
           init();
           }
           catch(exception e){}
         }
         
         /** returns the next page of the page set*/
         public void next() {
         try{
           setCon.save();
           setCon.next();
           
           init();
           }
           catch(exception e){}
         
         }
        /** returns the first page of the page set*/
         public void first() {
         try{
           setCon.save();
           setCon.first();
           init();
           }
           catch(exception e){}
      
         }
         
         /** returns the last page of the page set*/
         public void last() {
         try{
           setCon.save(); 
           setCon.last();
           init();
           }
           catch(exception e){}
         
         }
 
}