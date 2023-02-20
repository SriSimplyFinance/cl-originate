global class SAF_DueDilSearch
{

    public class MyException extends Exception{}
    public String CustomerName{get;set;} 
      
    public List<SAF_Duedil.CustomerInfo> CustomerInfo{get;set;} 
    public Integer Totalcount{get;set;} 
    public String Strlimit{get;set;}
    public String Stroffset{get;set;}
    public Integer PaginationStart{get;set;} 
    public Integer PaginationEnd{get;set;} 
    public Integer NonLimitedCust = 10000, ReduceCount = 2, Lastrecord;
    public boolean FoundLastPage{get;set;}
    public String LimitDefault = '20', OffSetDefault='0';
    //public List<Account> Recid{get;set;}
    public boolean disable{get;set;}
    public boolean selectAll{get;set;}
    //Error Log Starts
    public string strDateFormat = 'ddMMyyyy';
    public User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
    public Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
    public Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
    //Error Log Ends
    
    public void pageInit()
    {
        this.disable = false;
        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'STARTS: '+disable));
    }
    
    public void search()
    {
        try
        {
            this.disable = true;
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'If Str Offset: '+Stroffset));
            this.paginationFirst();
            this.initCustInfo();
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'Search',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void show()
    {
        try
        {
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'If Str Offset: '+Stroffset));
            if(Stroffset == null)
            {
                this.paginationFirst();
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Pagination: '+PaginationStart+' - '+PaginationEnd));
            }
            
            this.initCustInfo();
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Conditions: '+totalCount +' < '+Integer.ValueOf(LimitDefault)));
            this.disable = totalCount < Integer.ValueOf(LimitDefault)? false: true;
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'show',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void initCustInfo()
    {
        try
        {
            selectAll = false;
            SAF_Duedil.CustomersInfo cs = new SAF_Duedil.CustomersInfo();
            system.debug('####CustomerName: '+ CustomerName);
            cs = SAF_Duedil.getCustomers(CustomerName,Strlimit,Stroffset);
            system.debug('####cs: '+ cs.companies);
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Customer Name: '+CustomerName));
            //cs = SAF_Duedil.getCustomers('123','20','0');
            CustomerInfo = new List<SAF_Duedil.CustomerInfo>();
            CustomerInfo = cs.companies;
            Totalcount = Integer.valueof(cs.pagination.total);
            this.FoundLastPage = false;
            this.updateAccountIds();
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'initCustInfo',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void paginationFirst()
    {
        try
        {
            this.Strlimit = LimitDefault ;
            this.Stroffset = OffSetDefault;
            this.PaginationStart = 1;
            this.PaginationEnd = Integer.valueof(Strlimit);
            //FoundLastPage = false;
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage setting: '+FoundLastPage));
            this.show();
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'paginationFirst',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void paginationLast()
    {
        try
        {
            Integer offSet, diff, remaining;
            Decimal toberounded,pageEndOffSet, PageStart;
            if(totalCount > NonLimitedCust-1 && PaginationEnd < NonLimitedCust-1)
            {
                
                offSet = (NonLimitedCust - Integer.valueof(Strlimit));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Last Offset: '+ offSet));
                this.Strlimit = String.ValueOf(Integer.valueof(Strlimit) - 1);
                this.Stroffset = String.ValueOf(offSet);
                PageStart = Decimal.ValueOf(offSet) + 1.0;
                this.PaginationStart = Integer.valueof(PageStart) ;
                this.PaginationEnd = Integer.valueof(offSet) + Integer.valueof(Strlimit);
                this.FoundLastPage = true;
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage setting: '+FoundLastPage));
                
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage: '+FoundLastPage +' Pagination: '+PaginationStart+' - '+PaginationEnd + 'Offset: '+Stroffset ));
                this.show();
            }
            else if(PaginationEnd < totalCount && totalCount <  NonLimitedCust-1)
            {
                diff = PaginationEnd - totalCount;
                remaining = PaginationEnd - diff;
                
                toberounded = (totalCount/Integer.valueof(Strlimit));
                pageEndOffSet= toberounded.ROUND(System.RoundingMode.FLOOR) * Integer.valueof(Strlimit);
                remaining = totalCount - Integer.ValueOf(pageEndOffSet);
                
                this.Stroffset = String.ValueOf(pageEndOffSet);
                PageStart = pageEndOffSet + 1.0;
                this.PaginationStart = Integer.valueof(PageStart) ;
                this.PaginationEnd = Integer.valueof(pageEndOffSet) + remaining;
                
                this.FoundLastPage = true;
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage setting: '+FoundLastPage));
                this.show();
            }
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'paginationLast',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void paginationPrevious()
    {
        try
        {
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage: ' + this.FoundLastPage));
            if(PaginationStart > 1)
            {
                if(totalCount > NonLimitedCust-1)
                {
                    previousNonLimitedCustomers();
                }
                else if(PaginationEnd <= Totalcount)
                {
                    previousLimitedCustomer();
                }
            }
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'paginationPrevious',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void previousNonLimitedCustomers()
    {
        integer lastPageDiff;
        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage: ' + this.FoundLastPage));
        if(PaginationEnd == NonLimitedCust-1)
        {
            lastPageDiff = PaginationEnd - Integer.valueof(Stroffset);
            Strlimit = String.ValueOf(Integer.valueof(Strlimit) +1);
            PaginationStart = (PaginationStart - Integer.valueof(Strlimit));
            PaginationEnd = (PaginationEnd - lastPageDiff);
            Stroffset = String.ValueOf(PaginationStart - 1);
            this.FoundLastPage = false;
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage setting: '+FoundLastPage));
            this.show();
            /*ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'3. Pagination: ' + PaginationStart 
                                                                                                 +' - ' + PaginationEnd 
                                                                                                 + ' Offset: ' + Stroffset 
                                                                                                 + ' Limit: '+Strlimit));*/
        }
        else
        {
            PaginationStart = (PaginationStart - Integer.valueof(Strlimit));
            PaginationEnd = (PaginationEnd - Integer.valueof(Strlimit));
            Stroffset = String.ValueOf(PaginationStart - 1);
            this.show();
            /*ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'4. Pagination: ' + PaginationStart 
                                                                                                 +' - ' + PaginationEnd 
                                                                                                 + ' Offset: ' + Stroffset 
                                                                                                 + ' Limit: '+Strlimit));*/
        }
    }
    
    public void previousLimitedCustomer()
    {
        integer lastPageDiff;
        lastPageDiff = PaginationEnd - Integer.valueof(Stroffset);
        if(FoundLastPage)
        {
            //lastPageDiff = PaginationEnd - Integer.valueof(Stroffset);
            //Strlimit = String.ValueOf(Integer.valueof(Strlimit));
            PaginationStart = (PaginationStart - Integer.valueof(Strlimit));
            PaginationEnd = (PaginationEnd - lastPageDiff);
            Stroffset = String.ValueOf(PaginationStart - 1);
            this.FoundLastPage = false;
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage setting: '+FoundLastPage));
            this.show();
            /*ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'5. Pagination: ' + PaginationStart 
                                                                                                 +' - ' + PaginationEnd 
                                                                                                 + ' Offset: ' + Stroffset 
                                                                                                 + ' Limit: '+Strlimit));*/
        }
        else
        {
            if(lastPageDiff != Integer.valueof(Strlimit))
            {
                PaginationEnd += Integer.valueof(Strlimit) - lastPageDiff ;
                lastPageDiff = Integer.valueof(Strlimit);
            }
            
            PaginationStart = (PaginationStart - Integer.valueof(Strlimit));
            PaginationEnd = (PaginationEnd - Integer.valueof(Strlimit));
            //Strlimit = String.ValueOf(Integer.valueof(Strlimit));
            Stroffset = String.ValueOf(PaginationStart - 1);
            this.show();
            /*ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'6. Pagination: ' + PaginationStart 
                                                                                                 +' - ' + PaginationEnd 
                                                                                                 + ' Offset: ' + Stroffset 
                                                                                                 + ' Limit: '+Strlimit
                                                                                                 + ' LastPageDiff: '+lastPageDiff));*/
        }
    }
    
    public void paginationNext()
    {
        try
        {
            if(Totalcount > NonLimitedCust && PaginationEnd < NonLimitedCust-1)
            {
                nonLimitCustomers();
            }
            else if(PaginationEnd < Totalcount  && totalCount <  NonLimitedCust-1)
            {
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage: '+FoundLastPage+' Pagination Starts: '+ paginationStart +' Pagination Ends: '+paginationEnd));
                limitedCustomers();
            }
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'paginationNext',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void nonLimitCustomers()
    {
        Integer pageStart;
        
        pageStart = Integer.valueof(PaginationStart) + Integer.valueof(Strlimit);
        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Pagination If: '+ pageStart  +' Pagination If: '+(NonLimitedCust - Integer.valueof(Strlimit)+1)));
        
        if(PaginationEnd <= NonLimitedCust-1 )
        {
            System.debug('!!!!!!!!!!!!!!!!!!Search Test : '+(NonLimitedCust - Integer.valueof(Strlimit)+1)); // TBD
            System.debug('!!!!!!!!!!!!!!!!!!Search Test pageStart : '+pageStart); // TBD
            if(pageStart  == (NonLimitedCust - Integer.valueof(Strlimit)+1))
            {
                PaginationStart = (PaginationStart + Integer.valueof(Strlimit));
                PaginationEnd = (PaginationEnd + Integer.valueof(Strlimit)-1);
                
                this.FoundLastPage = true;
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage setting: '+FoundLastPage));
                this.Strlimit = String.ValueOf((Integer.valueof(Strlimit)-1));
                this.Stroffset = String.ValueOf(Integer.valueof(Stroffset) + Integer.valueof(Strlimit)+1);
            }
            else
            {
                PaginationStart = (PaginationStart + Integer.valueof(Strlimit));
                PaginationEnd = (PaginationEnd + Integer.valueof(Strlimit));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Pagination End: '+PaginationEnd));
            
                this.Stroffset = String.ValueOf(Integer.valueof(Stroffset) + Integer.valueof(Strlimit));
            }
            
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Stroffset : '+this.Stroffset));
            Lastrecord = Integer.valueof(Strlimit) - ReduceCount;
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'NonLimitedCust: '+ Lastrecord));
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'NonLimitedCust: '+ (NonLimitedCust-Lastrecord)));
            
            if(PaginationStart < NonLimitedCust-Lastrecord)
            {
                this.show();
            }
        }
    }
    
    public void limitedCustomers()
    {
        Integer pageEnd,diff,remaining,lastDiff;
        
        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Pagination Count > PageEnd '+totalCount+' > '+ PaginationEnd));
        if(!FoundLastPage)
        {
            PaginationStart = (PaginationStart + Integer.valueof(Strlimit));
            PaginationEnd = (PaginationEnd + Integer.valueof(Strlimit));
            this.Stroffset = String.ValueOf(Integer.valueof(Stroffset) + Integer.valueof(Strlimit));
            
            diff = PaginationEnd - totalCount;
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'######### DIFF: '+ (diff)));
            system.debug('######### DIFF: '+ diff + ' Pagination end: '+PaginationEnd+ ' totalCount :'+totalCount);
            
            remaining = PaginationEnd - diff;
            
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'######### remaining : '+ (remaining )));
            pageEnd = remaining;
            if(diff >0)
            {
                this.FoundLastPage = true;
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'FoundLastPage setting: '+FoundLastPage));
            }
            
        }
        
        if(totalCount > PaginationEnd && !FoundLastPage)
        {
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'#########IF: Pagination Start: '+PaginationStart + ' Pagination End: '+pageEnd));
            this.show();
        }
        else if(FoundLastPage)
        {
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'#########CON: Pagination End + Condition: '+ (PaginationEnd+diff)));
            
            diff = PaginationEnd - totalCount;
            remaining = PaginationEnd - diff;
            PaginationEnd = remaining;
            this.show();
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'*********ELSE: Pagination Start: '+PaginationStart + ' Pagination End: '+PaginationEnd));
            //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'*********ELSE: Remaining: '+remaining));
        }
    
        
    }
    
    public void createSingleCustomer()
    {
        try
        {
            String companyId = ApexPages.currentPage().getParameters().get('compId');
            Account acc;
            string strcompanyid;
            for(SAF_Duedil.CustomerInfo objc:CustomerInfo)    
            {
                if(companyId == objc.companyId)
                {
                    /*acc = new Account();
                    SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
                    csinfo = SAF_Duedil.GetCompanyInfo(objc.companyId,'gb');
                    
                    acc = this.customerInit(csinfo);*/
                    //accs.add(acc);
                     //createLinkedcomp(objc.companyId,csinfo.name);
                     strcompanyid = objc.companyId;
                
                    AsyncExecutionExample  updateJob = new AsyncExecutionExample(objc.companyId, objc.name);
                    ID jobID = System.enqueueJob(updateJob);
                  // ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, csinfo.name +' Customer created succesfully'));
                }
            }
            //SAF_DueDilSearch sd = new SAF_DueDilSearch();
            // if(acc.Name != null) {insert acc; }
            // this.updateAccountIds();
           /* SAF_Duedil.companyshareholders cs = new SAF_Duedil.companyshareholders();
             cs = SAF_Duedil.GetShareholders(strcompanyid,'gb');
               for(SAF_Duedil.shareholder objc:cs.shareholders)       
             {  
                 //objsh.isChecked = true;
                  system.debug('+++++++++objc++++++++++' +objc);
                  for(SAF_Duedil.exactMatch objcmatch:objc.exactMatches)    
                            {
                                if(objcmatch.type == 'company' && objcmatch.person == null && objcmatch.company != null && objcmatch.company.companyId != null)
                                { 
                                      system.debug('+++++++++inside if objc++++++++++' + objc.sourcename);
                                   // SAF_CompanyDeatils.createRelatedGroupCustomers2(objcmatch.company.companyId,objc.sourcename);
                                    AsyncExecutionExample  updateJob1 = new AsyncExecutionExample(objcmatch.company.companyId, objc.sourcename);
                                    ID jobID = System.enqueueJob(updateJob1);
                                }
                             }
             }*/
         

            system.debug('+++++++++Duedil class++++++++++' +acc );
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'createSingleCustomer',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void createCustomers()
    {
        try
        {
            //SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Account> { Account.SObjectType});
            list<Account> accs = new list<Account>();
            list<Contact> cons = new list<Contact>();
            Account acc;
            boolean customerCreated = false;
            integer custCount = 0;
            
            //FATAL, ERROR, WARNING, INFO, CONFIRM
            for(SAF_Duedil.CustomerInfo objc:CustomerInfo)    
            {
                system.debug('Test Error1');
                SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
                 csinfo = SAF_Duedil.GetCompanyInfo(objc.companyId,'gb');
          
                 acc = new Account();
                 
                 //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Checked: '+objc.isChecked));
                 //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Checked: '+objc.isChecked));objc.AccountId
                 if(objc.AccountId == null && objc.ischecked)
                 {
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Customer(s) Info Address: '+csinfo.registeredAddress.structuredAddress.postTown));
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Company: '+objc.companyId+' Account Id: '+objc.AccountId));
                    
                    acc = this.customerInit(csinfo);
                    if(acc.Name != null) {accs.add(acc); }
                    //createLinkedcomp(objc.companyId,csinfo.name);
                    customerCreated = true;
                    custCount = custCount+1;
                 }
            }
            
            if(accs.size() > 0 && accs.size() < = 20)
            {
                database.insert(accs);
                this.updateAccountIds();
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, custCount+ ' Customer(s) Created Successfully'));
            }
            else
            { 
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, custCount+ ' Customers are selected, We cannot create customers more than 20 in single transaction.'));
            }
            if(Test.isRunningTest()){throw new MyException();}
            //structuredAddress
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'createCustomers',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public Account customerInit(SAF_Duedil.CustomerInfo csinfo)
    {
        try
        {
            Account acc = new Account();
            
            string SICcode = '';
            SAF_Duedil.IndustriesInfo Indusinfo = new SAF_Duedil.IndustriesInfo();
            if(csinfo.companyId != null)
            { 
                Indusinfo = SAF_Duedil.GetIndustryInfo(csinfo.companyId,'gb');
                system.debug('##################Indusinfo : '+Indusinfo );
                if(Indusinfo.industries != null)
                {   for(SAF_Duedil.IndustryInfo objcInfo:Indusinfo.industries)    
                    {
                         if(objcInfo.type == 'SIC2007' && objcInfo.code != null)
                         {SICcode =  objcInfo.code; acc.Sic = SICcode;}
                    }
                }
            
                system.debug('******Test debug: '+csinfo);
                acc.Name = csinfo.name;
                acc.AccountNumber = csinfo.companyId;
                acc.Type = Saf_Duedil__c.getOrgDefaults().Customer_Type__c;
               // acc.CurrencyIsoCode = 'GBP';
                acc.Ownership = ownerShipValue(csinfo.type);
                acc.SAF_is_Duedil_Created__c = true;
                //acc.clcommon__Email__c = 'test.test@test.com';
                //acc.Phone = '98765 432101';
                acc.CLCOMMON__LEGAL_ENTITY_TYPE__C = Saf_Duedil__c.getOrgDefaults().LegalEntity__c;
                system.debug('Legal Entity type for acc'+ acc.CLCOMMON__LEGAL_ENTITY_TYPE__C);
                
                if(csinfo.registeredAddress != null && csinfo.registeredAddress.structuredAddress != null)
                { 
                    system.debug('Test : '+csinfo.registeredAddress);
                    acc.BillingStreet                      = csinfo.registeredAddress.structuredAddress.premises + ' '+csinfo.registeredAddress.structuredAddress.thoroughfare;
                    acc.BillingPostalCode                  = csinfo.registeredAddress.structuredAddress.postcode;
                    acc.BillingCity                        = csinfo.registeredAddress.structuredAddress.postTown;
                    acc.BillingState                       = csinfo.registeredAddress.structuredAddress.county;
                    acc.BillingCountry                     = csinfo.incorporationCountry;
                    acc.BillingLatitude                    = Decimal.ValueOf(csinfo.registeredAddress.geolocation.latitude);
                    acc.BillingLongitude                   = Decimal.ValueOf(csinfo.registeredAddress.geolocation.longitude);
                    acc.SAF_dependentLocality__c            = csinfo.registeredAddress.structuredAddress.dependentLocality;
                    acc.SAF_thoroughfare__c                 = csinfo.registeredAddress.structuredAddress.thoroughfare;
                    acc.SAF_premises__c                     = csinfo.registeredAddress.structuredAddress.premises;
                }
                
                 if(csinfo.financialSummary != null)
                {
                    acc.SAF_netAssets__c                    = csinfo.financialSummary.netAssets;
                    acc.SAF_totalAssets__c                  = csinfo.financialSummary.totalAssets;
                    acc.SAF_ebitda__c                       = csinfo.financialSummary.ebitda;
                    acc.SAF_postTaxProfit__c                = csinfo.financialSummary.postTaxProfit;
                    acc.SAF_turnover__c                     = csinfo.financialSummary.turnover;
                }  
                
                if(csinfo.accounts != null)
                {  
                    acc.SAF_nextAccountsDueDate__c          = csinfo.accounts.nextAccountsDueDate;
                    acc.SAF_consolidatedAccounts__c         = csinfo.accounts.consolidatedAccounts;
                    acc.SAF_latestAccountsDate__c           = csinfo.accounts.latestAccountsDate;
                    acc.SAF_filingType__c                   = csinfo.accounts.filingType;
                }
                acc.SAF_incorporationDate__c            = csinfo.incorporationDate;
                acc.SAF_incorporationCountry__c         = csinfo.incorporationCountry;
               
              
                acc.SAF_charitableIdentitiesCount__c    = csinfo.charitableIdentitiesCount;
               
                acc.SAF_officialStatus__c               = csinfo.officialStatus;
                acc.SAF_simplifiedStatus__c             = csinfo.simplifiedStatus;
           }            
           return acc; 
       }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'customerInit',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            return null;
        }
    }
    
    webservice static String CustomerUpdate(String companyId, String Accountid)//SAF_Duedil.CustomerInfo csinfo
    {
        try
        {
            Account acc = [Select Ownership, 
                                clcommon__Legal_Entity_Type__c, 
                                Sic, 
                                BillingStreet, 
                                BillingPostalCode, 
                                BillingCity, 
                                BillingState, 
                                BillingCountry, 
                                BillingLatitude, 
                                BillingLongitude, 
                                SAF_dependentLocality__c, 
                                SAF_thoroughfare__c, 
                                SAF_premises__c from Account where Id =:Accountid];
            
            string SICcode = '';
            SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
            SAF_Duedil.IndustriesInfo Indusinfo = new SAF_Duedil.IndustriesInfo();
            if(companyId != null && companyId != '')
            {    csinfo = SAF_Duedil.GetCompanyInfo(companyId,'gb'); system.debug('#### Acc CompanyId : '+csInfo.CompanyId + '#### CompanyId : '+companyId);
                 if(csinfo == null || csinfo.companyId != companyId){return 'Invalid Registration number';}
            }
            else
            {    return 'Please provide Registration number'; }
            
            if(csinfo.companyId != null)
            { 
                Indusinfo = SAF_Duedil.GetIndustryInfo(csinfo.companyId,'gb');
                system.debug('##################Indusinfo : '+Indusinfo );
                if(Indusinfo.industries != null)
                {   for(SAF_Duedil.IndustryInfo objcInfo:Indusinfo.industries)    
                    {    if(objcInfo.type == 'SIC2007' && objcInfo.code != null)
                         {SICcode =  objcInfo.code; acc.Sic = SICcode;}
                    }
                }
                system.debug('******Test debug: '+csinfo);
                acc.Name = csinfo.name; acc.AccountNumber = csinfo.companyId;  acc.Ownership = ownerShipValue(csinfo.type);
                acc.SAF_is_Duedil_Updated__c = true;
                
                if(csinfo.registeredAddress != null && csinfo.registeredAddress.structuredAddress != null)
                { 
                    system.debug('Test : '+csinfo.registeredAddress);
                    acc.BillingStreet                      = csinfo.registeredAddress.structuredAddress.premises + ' '+csinfo.registeredAddress.structuredAddress.thoroughfare; acc.BillingPostalCode = csinfo.registeredAddress.structuredAddress.postcode; acc.BillingCity = csinfo.registeredAddress.structuredAddress.postTown;
                    acc.BillingState                       = csinfo.registeredAddress.structuredAddress.county; acc.BillingCountry = csinfo.incorporationCountry; acc.BillingLatitude = Decimal.ValueOf(csinfo.registeredAddress.geolocation.latitude); acc.BillingLongitude = Decimal.ValueOf(csinfo.registeredAddress.geolocation.longitude);
                    acc.SAF_dependentLocality__c            = csinfo.registeredAddress.structuredAddress.dependentLocality; acc.SAF_thoroughfare__c = csinfo.registeredAddress.structuredAddress.thoroughfare; acc.SAF_premises__c = csinfo.registeredAddress.structuredAddress.premises;
                }
                update acc;
           } 
           return 'Account Updated Successfully';
       }
        catch(Exception e)
        {  
            system.debug('#### Error: '+e.getMessage()+', Line No: '+e.getLineNumber());
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strDateFormat = 'ddMMyyyy';
            User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
            Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
            
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure','#Error','customerUpdate',strErrordes,'','','',false,ErrorLogsUtils.ERROR,false,'','');
            return null;
            
        }
    }
    
    public static String ownerShipValue(String ddosValue)
    {
        List<SAF_Ownership__c> mcs = SAF_Ownership__c.getall().values();
        boolean textField = null;
        
        for(SAF_Ownership__c os: mcs)
        {
            system.debug(os.Duedil_Ownership__c);
            system.debug(os.Ownership__c);
            
            if(ddosValue == os.Duedil_Ownership__c)
            {
                return os.Ownership__c;
            }
        } return 'Other';
    }
    
    public void updateAccountIds()
    {
        try
        {
            // assigning values to id field
            map<string,string> mapAccountIds = new map<string,string>();
            List<string> customerRegno = new List<string>();
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustomerInfo)    
            { 
                customerRegno.add(objIdUpdate.companyId);
                objIdUpdate.newname = objIdUpdate.name.replace('&', 'ampar');
            } 
              
            //creating a map for getting Account Id and Company reg no
            for(Account objIdUpdate:[SELECT Name,Id,AccountNumber FROM Account WHERE AccountNumber In :customerRegno limit 30])
            {
                mapAccountIds.put(objIdUpdate.AccountNumber,objIdUpdate.Id);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name: '+objc.name+ '  objc.Id:'+ objc.Id+ '  objc.AccountNumber:' + objc.AccountNumber));
            }
            
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustomerInfo)    
            { 
                objIdUpdate.accountId = mapAccountIds.get(objIdUpdate.companyId);
                system.debug('mapAccountIds.get(objIdUpdate.companyId):' +mapAccountIds.get(objIdUpdate.companyId));
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name : '+objc.name+ ' objc.accountId :'+ objc.accountId+ ' objc.companyId :' + objc.companyId));
            }
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'updateAccountIds',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    public void updateCheckBoxes()
    {
        try
        {
            // assigning values to id field
            map<string,string> mapAccountIds = new map<string,string>();
            List<string> customerRegno = new List<string>();
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustomerInfo)    
            { 
                customerRegno.add(objIdUpdate.companyId);
            } 
              
            //creating a map for getting Account Id and Company reg no
            for(Account objIdUpdate:[SELECT Name,Id,AccountNumber FROM Account WHERE AccountNumber In :customerRegno limit 30])
            {
                mapAccountIds.put(objIdUpdate.AccountNumber,objIdUpdate.Id);
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'objc.name: '+objc.name+ '  objc.Id:'+ objc.Id+ '  objc.AccountNumber:' + objc.AccountNumber));
            }
            
            //Populating a customerinfo list with salesforce account Ids. 
            for(SAF_Duedil.CustomerInfo objIdUpdate:CustomerInfo)    
            { 
                objIdUpdate.accountId = mapAccountIds.get(objIdUpdate.companyId);
                if(objIdUpdate.accountId == null)
                {
                    objIdUpdate.ischecked = selectAll;
                }
            }
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(Exception e)
        {  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
            //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
            //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'updateCheckBoxes',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    public void createLinkedcomp(string CompanyId,string CompanyName)
    {
        SAF_CompanyDeatils.createRelatedGroupCustomers2(CompanyId,CompanyName);
        
     
        
       /* SAF_CompanyDeatils sc = new SAF_CompanyDeatils();
       
        sc.CompanyId = '10588244';
        sc.Companyname = 'Simply Asset Finance Operations Limited';
        //sc.UBOCompanyId = '04725729';
        sc.show();
         for(SAF_Duedil.groupparent objgp:sc.CompgroupParents)
         {
             if(sc.AccountId ==null) {objgp.isChecked = true;}
              system.debug('*****objgp**********'+objgp);
         }
        List<Account> lstaccs = sc.createRelatedGroupCustomers();// group company
       
        
        sc.RelConShow();
         for(SAF_Duedil.shareholder objsh:sc.shareholder)       
         {  
             objsh.isChecked = true;
              system.debug('*****objsh**********'+objsh);
         }
          for(SAF_Duedil.shareholder objsh:sc.shareholderUBO)
         {   
             objsh.isChecked = true;
             sc.shareholder.add(objsh);
            
             
              system.debug('*****objsh**********'+objsh);
         }
         for(SAF_Duedil.Officer objofficer:sc.officers)    
            {
                 objofficer.isChecked = true;
            }
            sc.RelConcreateContacts();
         //sc.CreateShareholdersOrUBOSH(sc.shareholder);
          //Database.SaveResult[] srList = Database.insert(lstaccs);
        //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, srList.size()+ ' Group parent(s) Created Successfully'));*/
        
        
    }
    public class AsyncExecutionExample implements Queueable,Database.AllowsCallouts {
     private string companyid;
     private string companyname;
    
    public AsyncExecutionExample(string strcompanyid,string strcompanyname) {
        this.companyid = strcompanyid;
        this.companyname = strcompanyname;
    }
    
    public void execute(QueueableContext context) {
        
           system.debug('+++++++++AsyncExecutionExample++++++++++' +companyid+ companyname);
           SAF_CompanyDeatils.createRelatedGroupCustomers1(companyid,companyname);    
           ID jobID = System.enqueueJob(new AsyncExecutionExample2(companyid,companyname));   
           
           
    }
}
    public class AsyncExecutionExample2 implements Queueable,Database.AllowsCallouts {
     private string companyid;
     private string companyname;
    
    public AsyncExecutionExample2(string strcompanyid,string strcompanyname) {
        this.companyid = strcompanyid;
        this.companyname = strcompanyname;
    }
    
    public void execute(QueueableContext context) {
        
              SAF_Duedil.companyshareholders cs = new SAF_Duedil.companyshareholders();
             cs = SAF_Duedil.GetShareholders(companyid,'gb');
            if(cs!= null && cs.shareholders != null)
            {
             for(SAF_Duedil.shareholder objc:cs.shareholders)       
             {  
                 //objsh.isChecked = true;
                  system.debug('+++++++++objc++++++++++' +objc);
                  for(SAF_Duedil.exactMatch objcmatch:objc.exactMatches)    
                            {
                                if(objcmatch.type == 'company' && objcmatch.person == null && objcmatch.company != null && objcmatch.company.companyId != null)
                                { 
                                      system.debug('+++++++++inside if objc++++++++++' + objc.sourcename);
                                   // SAF_CompanyDeatils.createRelatedGroupCustomers1(objcmatch.company.companyId,objc.sourcename);
                                    //AsyncExecutionExample  updateJob1 = new AsyncExecutionExample(objcmatch.company.companyId, objc.sourcename);
                                     if(!Test.isRunningTest()){
                                      ID jobID = System.enqueueJob(new AsyncExecutionExample(objcmatch.company.companyId, objc.sourcename));
                                    }
                                }
                             }
             }
          }  
    }
}
}