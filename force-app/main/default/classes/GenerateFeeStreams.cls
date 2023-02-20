public class GenerateFeeStreams {
    /*private Id contractId;
    private List<cllease__Lease_Account__c> lsContracts;
    private Map<Id,List<cllease__Rental_Stream__c>> incomeStreamsMap = new Map<Id,List<cllease__Rental_Stream__c>>();*/
    private Map<String, Id> transactionSubTypeIdByName = new Map<String, Id>();
    
    public GenerateFeeStreams(){
        System.debug('ENTERED CONSTRUCTOR IN GENERATE FEE STREAMS');
        getTransactionSubTypes();
    }
    
    /*public GenerateFeeStreams(){
        lsContracts = new List<cllease__Lease_Account__c>();
        
        try{
            lsContracts = [Select Id,Name,cllease__Financed_Amount__c,
                                                      cllease__Residual_Amount__c,cllease__Maturity_Date__c,
													  cllease__Next_Income_Accrual_Date__c,cllease__Contract_Date__c
                                                      from cllease__Lease_Account__c 
                                                      WHERE Id NOT IN (SELECT cllease__Contract__c FROM cllease__Fee_Stream__c)
                          							  and Id IN (SELECT cllease__Contract__c FROM cllease__Contract_Fees__c) and 
                                                     cllease__Lease_Status__c IN ('ACTIVE - GOOD STANDING','TERMINATED','ACTIVE - BAD STANDING')
                                                     and Id IN ('a690O0000004qtrQAA')];
            System.debug('IN CONSTRUCTOR:::LS CONTRACTS SIZE:::'+lsContracts.size());
            if(!lsContracts.isEmpty())
            {
                System.debug('IN IF:::LS CONTRACTS SIZE:::'+lsContracts.size());
                incomeStreamsMap = getContractIncomeStreams(lsContracts);
                System.debug('income streams for contract:::'+incomeStreamsMap.size());
                getTransactionSubTypes();
                generateIncomeFeeStreams();
                generateExpenseFeeStreams();
                for(cllease__Lease_Account__c lsContract : lsContracts)
       			{
            		lsContract.cllease__Next_Income_Accrual_Date__c = lsContract.cllease__Contract_Date__c;
        		}
        		if(lsContracts.size() > 0)
        		{
            		update lsContracts;
        		}
            }else{
                System.debug('Fee Streams already present for All contracts.');
            }
        }catch(Exception e){
            System.debug('ERROR MESSAGE::'+e.getMessage()+' at::'+e.getLineNumber());
            clcommon__Log__c log = new clcommon__Log__c();
            log.clcommon__Message__c = e.getMessage();
            log.clcommon__Time__c = datetime.now();
            insert log;
        }
    }*/
    /*public GenerateFeeStreams(String contractId){
        //this.contractId = contractId;
        lsContracts = new List<cllease__Lease_Account__c>();
        try{
            /*List<cllease__Fee_Stream__c> lsfeeStreamsList = [select Id,cllease__Contract__r.Id,Name,
                                                             cllease__Contract__r.cllease__Next_Income_Accrual_Date__c,
                                                             cllease__Contract__r.cllease__Contract_Date__c
                                                           from cllease__Fee_Stream__c 
                                                           where  cllease__Contract__r.Id = :contractId
                                                           and cllease__Contract__r.cllease__Lease_Status__c IN ('ACTIVE - GOOD STANDING','TERMINATED','ACTIVE - BAD STANDING')];*/
            /*lsContracts = [Select Id,Name,cllease__Financed_Amount__c,
                                                      cllease__Residual_Amount__c,cllease__Maturity_Date__c,
													  cllease__Next_Income_Accrual_Date__c,cllease__Contract_Date__c
                                                      from cllease__Lease_Account__c 
                                                      WHERE Id NOT IN (SELECT cllease__Contract__c FROM cllease__Fee_Stream__c)
                          							  and Id IN (SELECT cllease__Contract__c FROM cllease__Contract_Fees__c) and 
                                                     cllease__Lease_Status__c IN ('ACTIVE - GOOD STANDING','TERMINATED','ACTIVE - BAD STANDING')
                                                     and Id = :contractId];
            System.debug('ls contract list size:::'+lsContracts.size());
            if(!lsContracts.isEmpty())
            {
                //lsContracts.add(getLeaseContract(contractId)); 
                incomeStreamsMap = getContractIncomeStreams(lsContracts);
                System.debug('income streams for contract:::'+incomeStreamsMap.size());
                System.debug('ls contract list size:::'+lsContracts.size());
                getTransactionSubTypes();
                generateIncomeFeeStreams();
                generateExpenseFeeStreams();
                for(cllease__Lease_Account__c lsContract : lsContracts)
       			{
            		lsContract.cllease__Next_Income_Accrual_Date__c = lsContract.cllease__Contract_Date__c;
        		}
        		if(lsContracts.size() > 0)
        		{
            		update lsContracts;
        		}
                
            }else{
                System.debug('Fee Streams already present for this contract.');
            }
        }catch(Exception e){
            System.debug('ERROR MESSAGE::'+e.getMessage()+' at::'+e.getLineNumber());
            clcommon__Log__c log = new clcommon__Log__c();
            log.clcommon__Message__c = e.getMessage();
            log.clcommon__Time__c = datetime.now();
        }
    }*/

    public Map<Id,List<cllease__Contract_Fees__c>> getContractIncomeFees(List<cllease__Lease_Account__c> contractIds){
     	System.debug('Fetching Contract income fees');
        Map<Id,List<cllease__Contract_Fees__c>> contractIncomeFeeMap = new Map<Id,List<cllease__Contract_Fees__c>>();
        List<cllease__Contract_Fees__c> allContractIncomeFees =[Select Id,Name,cllease__Contract__r.Id,cllease__Fee_Definition__r.Name,
                                                                cllease__Fee_Definition__r.clcommon__Type__c, 
            													cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Type__c,
                                                                cllease__Fee_Definition__r.clcommon__Amortization_Period__c,
                                                                cllease__Fee_Definition__r.clcommon__Amortization_Method__c,
                                                                cllease__Amount__c,
                                                                cllease__Expense_Fee__c,
                                                                cllease__Total_Payment_Amount__c,
                                                                cllease__start_date__c
            													from cllease__Contract_Fees__c 
                                                       			where cllease__Contract__c IN :contractIds
                                                      			and cllease__Fee_Definition__r.clcommon__Class__c = 'Income'];
        System.debug('allContractIncomeFees:::::::::'+allContractIncomeFees.size());
        List<cllease__Contract_Fees__c> contractIncomeFees;
        for(cllease__Contract_Fees__c contractFee : allContractIncomeFees)
        {
            if(contractIncomeFeeMap.get(contractFee.cllease__Contract__r.Id) != null)
            {
                contractIncomeFees.add(contractFee);
            }else{
                contractIncomeFees = new List<cllease__Contract_Fees__c>();
                contractIncomeFees.add(contractFee);
            }
            contractIncomeFeeMap.put(contractFee.cllease__Contract__r.Id,contractIncomeFees);
        }
        
        return contractIncomeFeeMap;
               
    }
    public Map<Id,List<cllease__Contract_Fees__c>> getContractExpenseFees(List<cllease__Lease_Account__c> contractIds){
     
        Map<Id,List<cllease__Contract_Fees__c>> contractExpenseFeeMap = new Map<Id,List<cllease__Contract_Fees__c>>();
        List<cllease__Contract_Fees__c> allContractExpenseFees =[Select Id,Name,cllease__Contract__r.Id,cllease__Fee_Definition__r.Name,cllease__Fee_Definition__r.clcommon__Type__c, 
            													cllease__Fee_Definition__r.clcommon__Class__c,cllease__Fee_Type__c,
                                                                cllease__Fee_Definition__r.clcommon__Amortization_Period__c,
                                                                cllease__Fee_Definition__r.clcommon__Amortization_Method__c,
                                                                cllease__Amount__c,
                                                                cllease__start_date__c,
                                                                cllease__Expense_Fee__c,
                                                                cllease__Total_Payment_Amount__c
            													from cllease__Contract_Fees__c 
                                                       			where cllease__Contract__c IN :contractIds
                                                      			and cllease__Fee_Definition__r.clcommon__Class__c = 'Expense'];
        List<cllease__Contract_Fees__c> contractExpenseFees;
        for(cllease__Contract_Fees__c contractFee : allContractExpenseFees)
        {
            if(contractExpenseFeeMap.get(contractFee.cllease__Contract__r.Id) != null)
            {
                contractExpenseFees.add(contractFee);
            }else{
                contractExpenseFees = new List<cllease__Contract_Fees__c>();
                contractExpenseFees.add(contractFee);
            }
            contractExpenseFeeMap.put(contractFee.cllease__Contract__r.Id,contractExpenseFees);
        }
        return contractExpenseFeeMap;
               
    }
    
    public Map<Id,List<cllease__Rental_Stream__c>> getContractIncomeStreams(List<cllease__Lease_Account__c> contracts)
    { 
        System.debug('INSIDE GET CONTRACT INCOME STREAMS::::::::');
        Map<Id,List<cllease__Rental_Stream__c>> contractIncomeStreamsMap = new Map<Id,List<cllease__Rental_Stream__c>>();
        List<cllease__Rental_Stream__c> allContractIncomeStreams =[Select Id,Name,cllease__Contract__r.Id,cllease__Date__c,
                                                                cllease__Beginning_Net_Investment__c,cllease__Payment_Amount__c,
                                                                cllease__Monthly_Income__c,cllease__Lease_Income__c,
                                                                cllease__Capital_Recovery__c,cllease__Ending_Net_Investment__c
                                                                from cllease__Rental_Stream__c 
                                                       			where cllease__Contract__c IN :contracts];
        List<cllease__Rental_Stream__c> contractIncomeStreams;
        for(cllease__Rental_Stream__c contractIncomeStream : allContractIncomeStreams)
        {
            if(contractIncomeStreamsMap.get(contractIncomeStream.cllease__Contract__r.Id) != null)
            {
                contractIncomeStreams.add(contractIncomeStream);
            }else{
                contractIncomeStreams = new List<cllease__Rental_Stream__c>();
                contractIncomeStreams.add(contractIncomeStream);
            }
            contractIncomeStreamsMap.put(contractIncomeStream.cllease__Contract__r.Id,contractIncomeStreams);
        }
        return contractIncomeStreamsMap;
    }
    
    public void generateIncomeFeeStreams(List<cllease__Lease_Account__c> lsContracts,Map<Id,List<cllease__Rental_Stream__c>> incomeStreamsMap){
        System.debug('ENTERING GENERATE INCOME FEE STREAMS METHOD');
        List<cllease__Fee_Stream__c> feeStreamsList = new List<cllease__Fee_Stream__c>();
        Map<Id,List<cllease__Contract_Fees__c>> contractIncomeFeeMap = getContractIncomeFees(lsContracts);
        System.debug('INCOME FEES SIZE::::'+contractIncomeFeeMap.size());
        //List<cllease__Contract_Fees__c> contractIncomeFees = contractIncomeFeeMap.get(lsContracts);
        //Map<Id,List<cllease__Rental_Stream__c>> incomeStreamsMap = getContractIncomeStreams(lsContracts);
        //System.debug('INCOME STREAMS::::'+incomeStreamsMap.size());
        //List<cllease__Rental_Stream__c> incomeStreams = incomeStreamsMap.get(lsContracts);
        //Integer incomeStreamsSize = incomeStreams.size();
      	for (ID idKey : contractIncomeFeeMap.keyset())
	  	{
    		//System.debug('mkey:'+idKey+'-------------'+feeMap.get(idKey)+'------');
    		List<cllease__Contract_Fees__c> contractIncomeFees = contractIncomeFeeMap.get(idKey);
            System.debug('Income fee for contract:::'+idKey+'----'+contractIncomeFees.size());
            if(contractIncomeFees.isEmpty()){
                System.debug('No Income Fee is available to generate streams for '+idKey);
            }
            
            List<cllease__Rental_Stream__c> incomeStreams = incomeStreamsMap.get(idKey);
            for (cllease__Contract_Fees__c fee : contractIncomeFees) {
                System.debug('Entered income fee for loop to iterate over income fees:::');
                System.debug('INCOME FEE AMOUNT::::'+fee.cllease__Amount__c);
        		String  amortPeriod = fee.cllease__Fee_Definition__r.clcommon__Amortization_Period__c;
        		String  amortMethod = fee.cllease__Fee_Definition__r.clcommon__Amortization_Method__c;
                Decimal beginBalance = fee.cllease__Total_Payment_Amount__c; //cllease__Amount__c;
                Decimal totalIncome = 0;
                List<cllease__Rental_Stream__c> incomeStreamsNew = new List<cllease__Rental_Stream__c>();
                Integer i = 0;
                Date startDate,nextDate;
                startDate = fee.cllease__start_date__c;
                Date firstDayOfMonth = startDate.toStartOfMonth();
                nextDate = firstDayOfMonth.addDays(date.daysInMonth(firstDayOfMonth.year() , firstDayOfMonth.month())  - 1); //End of Month
                System.debug('FEE STREAM START DATE:::'+nextDate);                
                if(incomeStreams.size() > 0){
                	for(cllease__Rental_Stream__c iStream:incomeStreams){
                        if(iStream.cllease__Date__c >= fee.cllease__start_date__c)	
                    	{
                         	incomeStreamsNew.add(iStream);
                    	}
                    }
                    System.debug('INCOME STREAMS AMOUNT:::'+totalIncome);
            	}
            	if(incomeStreamsNew.size() > 0){
                	for(cllease__Rental_Stream__c income:incomeStreamsNew){
                        totalIncome += income.cllease__Lease_Income__c;
                    }
                    System.debug('INCOME STREAMS AMOUNT IN INCOME FEE METHD:::'+totalIncome);
            	}
                /*List<cllease__Rental_Stream__c> incomeStreamsNew = new List<cllease__Rental_Stream__c>();
                for(cllease__Rental_Stream__c iStream:incomeStreams)
                {
                    if(iStream.cllease__Date__c >= fee.cllease__start_date__c)
                    {
                         incomeStreamsNew.add(iStream);
                    }
                }*/
                if(amortPeriod != null && amortMethod != null){
                    if (amortPeriod == 'CONTRACT TERM' && amortMethod == 'Income Basis')
                    {                    
                        for(cllease__Rental_Stream__c incomeStream : incomeStreamsNew)
                        {
                            cllease__Fee_Stream__c feeStream = new cllease__Fee_Stream__c();
                            feeStream.cllease__fee_Definition__c = fee.cllease__Fee_Definition__r.Id;
                            feeStream.cllease__Contract__c = idKey;
                            feeStream.cllease__Date__c = nextDate;
                            feeStream.cllease__Contract_Fee__c = fee.Id;
                            feeStream.cllease__Expense_Fee__c  = fee.cllease__Expense_Fee__c;
                            feeStream.cllease__Fee_Type__c = fee.cllease__Fee_Definition__r.clcommon__Class__c;
                            feeStream.cllease__Beginning_Balance__c = beginBalance;
                            feeStream.cllease__active__c = true;
                            feeStream.cllease__Fee_Amount__c = ((incomeStream.cllease__Lease_Income__c/totalIncome) * fee.cllease__Amount__c).setScale(2);
                            System.debug('income stream money::'+incomeStream.cllease__Lease_Income__c);
                            System.debug('incomeStream.cllease__Lease_Income__c/totalIncome::'+incomeStream.cllease__Lease_Income__c/totalIncome);
                            feeStream.cllease__Transaction_Sub_Type__c = transactionSubTypeIdByName.get(fee.cllease__Fee_Definition__r.Name);
                            feeStream.cllease__Ending_Balance__c = feeStream.cllease__Beginning_Balance__c - feeStream.cllease__Fee_Amount__c;
                            if(feeStream.cllease__Ending_Balance__c < 0){
                                feeStream.cllease__Fee_Amount__c += feeStream.cllease__Ending_Balance__c;
                                feeStream.cllease__Ending_Balance__c = feeStream.cllease__Beginning_Balance__c - feeStream.cllease__Fee_Amount__c;
                            }
                            if(fee.cllease__Fee_Definition__r.clcommon__Class__c.equalsIgnoreCase('Income')){
                                startDate = nextDate.addDays(1);
                                nextDate = startDate.addDays(date.daysInMonth(startDate.year() , startDate.month())  - 1); //End of Month
                            }
                            feeStreamsList.add(feeStream);
                            beginBalance = feeStream.cllease__Ending_Balance__c;
                            //counter ++;
                        }                    
                    }else{
                        System.debug('ENTERED ELSE OF INCOME FEE STREAMS GENERATION::');
                            while (i < incomeStreamsNew.size()) {
                                cllease__Fee_Stream__c feeStream = new cllease__Fee_Stream__c();
                                feeStream.cllease__Fee_Definition__c = fee.cllease__Fee_Definition__r.Id;
                                feeStream.cllease__Beginning_Balance__c = beginBalance;
                                feeStream.cllease__fee_Amount__c = fee.cllease__Amount__c/incomeStreamsNew.size();
                                feeStream.cllease__ending_Balance__c = feeStream.cllease__Beginning_Balance__c - feeStream.cllease__fee_Amount__c;
                                feeStream.cllease__Date__c = nextDate;
                                feeStream.cllease__Contract_Fee__c = fee.Id;
                                feeStream.cllease__Expense_Fee__c  = fee.cllease__Expense_Fee__c;
                                feeStream.cllease__active__c = true;
                                feeStream.cllease__transaction_sub_type__c = transactionSubTypeIdByName.get(fee.cllease__Fee_Definition__r.Name);                
                                if(fee.cllease__Fee_Definition__r.clcommon__Class__c.equalsIgnoreCase('Income')){
                                   startDate = nextDate.addDays(1);
                                   nextDate = startDate.addDays(date.daysInMonth(startDate.year() , startDate.month())  - 1); //End of Month
                                }                
                                feeStreamsList.add(feeStream);
                                beginBalance = feeStream.cllease__Ending_Balance__c;
                                i++;
                            }
                    }
                }else{
                    System.debug('Amort period and amort method is not mentioned for::'+fee.cllease__Fee_Definition__r.Name);
                }
        	}
		}
        if(feeStreamsList.size()>0)
        {
        	insert feeStreamsList;  
        }
        for(cllease__Lease_Account__c lsContract : lsContracts)
       	{
            lsContract.cllease__Next_Income_Accrual_Date__c = lsContract.cllease__Contract_Date__c;
            String[] accrualStreams = lsContract.cllease__Accrual_Streams__c.split(';');
           	System.debug('accrualStreams:::'+accrualStreams);
           	boolean isFeeAccrual = false;
           	for(String s : accrualStreams){
                if(s.equalsIgnoreCase('Fee'))
                {
                    isFeeAccrual = true;
                }
           }
           System.debug('isFeeAccrual::'+isFeeAccrual);
           if(isFeeAccrual == false)
           {
                lsContract.cllease__Accrual_Streams__c = lsContract.cllease__Accrual_Streams__c + ';'+'Fee';
           }
           System.debug('lsContract.cllease__Accrual_Streams__c:::'+lsContract.cllease__Accrual_Streams__c);
        }
        if(lsContracts.size() > 0)
        {
            update lsContracts;
        }   
    }
    
    public void generateExpenseFeeStreams(List<cllease__Lease_Account__c> lsContracts,Map<Id,List<cllease__Rental_Stream__c>> incomeStreamsMap){
        List<cllease__Fee_Stream__c> feeStreamsList = new List<cllease__Fee_Stream__c>();
        Map<Id,List<cllease__Contract_Fees__c>> contractExpenseFeeMap = getContractExpenseFees(lsContracts);
        System.debug('EXPENSE FEES SIZE:::'+contractExpenseFeeMap.size());
        //List<cllease__Contract_Fees__c> contractIncomeFees = contractIncomeFeeMap.get(lsContracts);
        //Map<Id,List<cllease__Rental_Stream__c>> incomeStreamsMap = getContractIncomeStreams(lsContracts);
        
        //List<cllease__Rental_Stream__c> incomeStreams = incomeStreamsMap.get(lsContracts);
        //Integer incomeStreamsSize = incomeStreams.size();
      	for (ID idKey : contractExpenseFeeMap.keyset())
	  	{
    		//System.debug('mkey:'+idKey+'-------------'+feeMap.get(idKey)+'------');
    		List<cllease__Contract_Fees__c> contractExpenseFees = contractExpenseFeeMap.get(idKey);
            if(contractExpenseFees.isEmpty())
            {
                System.debug('No Expense Fee is available to generate streams for '+idKey);
            }
            //Decimal totalIncome = 0;
            List<cllease__Rental_Stream__c> incomeStreams = incomeStreamsMap.get(idKey);
            for (cllease__Contract_Fees__c fee : contractExpenseFees) {
        		String  amortPeriod = fee.cllease__Fee_Definition__r.clcommon__Amortization_Period__c;
        		String  amortMethod = fee.cllease__Fee_Definition__r.clcommon__Amortization_Method__c;
                Decimal beginBalance = fee.cllease__Amount__c;
                List<cllease__Rental_Stream__c> incomeStreamsNew = new List<cllease__Rental_Stream__c>();
                Integer i = 0;
                Decimal totalIncome = 0;
                Date startDate,nextDate;
                startDate = fee.cllease__start_date__c;
                Integer dueDay = startDate.day();
                String frequency = 'MONTHLY';
                Date firstDayOfMonth = startDate.toStartOfMonth();
                nextDate = firstDayOfMonth.addDays(date.daysInMonth(firstDayOfMonth.year() , firstDayOfMonth.month())  - 1); //End of Month
                if(incomeStreams.size() > 0){
                	for(cllease__Rental_Stream__c iStream:incomeStreams){
                        if(iStream.cllease__Date__c >= fee.cllease__start_date__c)	
                    	{
                         	incomeStreamsNew.add(iStream);
                    	}
                    }
                    System.debug('INCOME STREAMS AMOUNT:::'+totalIncome);
            	}
            	if(incomeStreamsNew.size() > 0){
                	for(cllease__Rental_Stream__c income:incomeStreamsNew){
                        totalIncome += income.cllease__Lease_Income__c;
                    }
                    System.debug('INCOME STREAMS AMOUNT IN INCOME FEE METHD:::'+totalIncome);
            	}
                /*List<cllease__Rental_Stream__c> incomeStreamsNew = new List<cllease__Rental_Stream__c>();
                for(cllease__Rental_Stream__c iStream:incomeStreams)
                {
                    if(iStream.cllease__Date__c >= fee.cllease__start_date__c)
                    {
                         incomeStreamsNew.add(iStream);
                    }
                }*/
                if(amortPeriod != null && amortMethod != null){
                    if (amortPeriod == 'CONTRACT TERM' && amortMethod == 'Income Basis')
                    {                    
                        System.debug('INSIDE IF CONDITION FOR AMORT PERIOD');
                        for(cllease__Rental_Stream__c incomeStream : incomeStreamsNew)
                        {
                            cllease__Fee_Stream__c feeStream = new cllease__Fee_Stream__c();
                            feeStream.cllease__fee_Definition__c = fee.cllease__Fee_Definition__r.Id;
                            feeStream.cllease__Contract__c = idKey;
                            feeStream.cllease__Date__c = nextDate;
                            feeStream.cllease__Fee_Type__c = fee.cllease__Fee_Definition__r.clcommon__Class__c;
                            feeStream.cllease__Beginning_Balance__c = beginBalance;
                            feeStream.cllease__Contract_Fee__c = fee.Id;
                            feeStream.cllease__Expense_Fee__c  = fee.cllease__Expense_Fee__c;
                            feeStream.cllease__active__c = true;
                            feeStream.cllease__Fee_Amount__c = ((incomeStream.cllease__Lease_Income__c/totalIncome) * fee.cllease__Amount__c).setScale(2);
                            feeStream.cllease__Transaction_Sub_Type__c = transactionSubTypeIdByName.get(fee.cllease__Fee_Definition__r.Name);
                            feeStream.cllease__Ending_Balance__c = feeStream.cllease__Beginning_Balance__c - feeStream.cllease__Fee_Amount__c;
                            if(feeStream.cllease__Ending_Balance__c < 0){
                                feeStream.cllease__Fee_Amount__c += feeStream.cllease__Ending_Balance__c;
                                feeStream.cllease__Ending_Balance__c = feeStream.cllease__Beginning_Balance__c - feeStream.cllease__Fee_Amount__c;
                            }
                            if(fee.cllease__Fee_Definition__r.clcommon__Class__c.equalsIgnoreCase('Expense')){
                               //nextDate = DateUtil.getNextCycleDate(nextDate, dueDay, frequency, 1, false);
                               startDate = nextDate.addDays(1);
                               nextDate = startDate.addDays(date.daysInMonth(startDate.year() , startDate.month())  - 1); //End of Month
                            }
                            feeStreamsList.add(feeStream);
                            beginBalance = feeStream.cllease__Ending_Balance__c;
                            //counter ++;
                        }                    
                    }else{
                            while (i < incomeStreamsNew.size()) {
                                System.debug('Entered while in else::::::');
                                System.debug('I value in while in else::::::'+i);
                                cllease__Fee_Stream__c feeStream = new cllease__Fee_Stream__c();
                                feeStream.cllease__Fee_Definition__c = fee.cllease__Fee_Definition__r.Id;
                                feeStream.cllease__Beginning_Balance__c = beginBalance;
                                feeStream.cllease__fee_Amount__c = fee.cllease__Amount__c/incomeStreamsNew.size();
                                feeStream.cllease__ending_Balance__c = feeStream.cllease__Beginning_Balance__c - feeStream.cllease__fee_Amount__c;
                                feeStream.cllease__Date__c = nextDate;
                                feeStream.cllease__Contract_Fee__c = fee.Id;
                                feeStream.cllease__Expense_Fee__c  = fee.cllease__Expense_Fee__c;
                                feeStream.cllease__active__c = true;
                                feeStream.cllease__transaction_sub_type__c = transactionSubTypeIdByName.get(fee.cllease__Fee_Definition__r.Name);                
                                if(fee.cllease__Fee_Definition__r.clcommon__Class__c.equalsIgnoreCase('Expense')){
                                   startDate = nextDate.addDays(1);
                                   nextDate = startDate.addDays(date.daysInMonth(startDate.year() , startDate.month())  - 1); //End of Month
                                }                
                                feeStreamsList.add(feeStream);
                                System.debug('FEE STEAMS LIST IN WHILE AFTER EACH ITERATION:'+feeStreamsList.size());
                                beginBalance = feeStream.cllease__Ending_Balance__c;
                                i++;
                            }
                      }
                }else{
                    System.debug('Amort period and amort method is not mentioned for::'+fee.cllease__Fee_Definition__r.Name);
                }
        	}
		}
        System.debug('feeStreamsList size::'+feeStreamsList.size());
        if(feeStreamsList.size()>0){
          insert feeStreamsList;
        }
        for(cllease__Lease_Account__c lsContract : lsContracts)
       	{
            lsContract.cllease__Next_Income_Accrual_Date__c = lsContract.cllease__Contract_Date__c;
            String[] accrualStreams = lsContract.cllease__Accrual_Streams__c.split(';');
           	System.debug('accrualStreams:::'+accrualStreams);
           	boolean isFeeAccrual = false;
           	for(String s : accrualStreams){
                if(s.equalsIgnoreCase('Fee'))
                {
                    isFeeAccrual = true;
                }
           }
           System.debug('isFeeAccrual::'+isFeeAccrual);
           if(isFeeAccrual == false)
           {
                lsContract.cllease__Accrual_Streams__c = lsContract.cllease__Accrual_Streams__c + ';'+'Fee';
           }
           System.debug('lsContract.cllease__Accrual_Streams__c:::'+lsContract.cllease__Accrual_Streams__c);
        }
        if(lsContracts.size() > 0)
        {
            update lsContracts;
        }   
    }
    public cllease__Lease_Account__c getLeaseContract(String contractId)
    {
        cllease__Lease_Account__c leaseAccount = [Select Id,Name,cllease__Financed_Amount__c,
                                                  cllease__Residual_Amount__c,cllease__Maturity_Date__c,
                                                  cllease__Next_Income_Accrual_Date__c,cllease__Contract_Date__c
                                                  from cllease__Lease_Account__c where 
                                                  Id =:contractId];
        return leaseAccount;
    }
    public Map<String, Id> getTransactionSubTypes(){
        List<cllease__Transaction_Sub_Type__c> transactionSubTypes = [SELECT Id, Name FROM cllease__Transaction_Sub_Type__c LIMIT 1000];
                for (cllease__Transaction_Sub_Type__c ts : transactionSubTypes) {
                    transactionSubTypeIdByName.put(ts.Name, ts.Id);
                }
        return transactionSubTypeIdByName;
    }
    
}