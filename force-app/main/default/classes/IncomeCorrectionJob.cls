global class IncomeCorrectionJob extends cllease.LeaseDynamicJob implements Database.AllowsCallouts, Database.Stateful {
    String customQuery;
    Boolean doRestructure;
    private Set<Id> lsIdsToFix = new Set<Id>();
    private final static String JOB_NAME = 'IncomeCorrectionJob';
    
    global IncomeCorrectionJob() {
        super(JOB_NAME, null);
        doRestructure = true;
        System.debug(LoggingLevel.ERROR, 'In IncomeCorrectionJob  constructor');
    }
    
    global IncomeCorrectionJob(String query) {
        super(JOB_NAME, null);
        customQuery = query;
        doRestructure = true;
        System.debug(LoggingLevel.ERROR, 'In IncomeCorrectionJob  constructor');
        System.debug(System.LoggingLevel.ERROR, 'IncomeCorrectionJob Job Query: ' + query);
    }
    
    global IncomeCorrectionJob(String query, Boolean doRestructure) {
        super(JOB_NAME, null);
        customQuery = query;
        this.doRestructure = doRestructure;
        System.debug(LoggingLevel.ERROR, 'In IncomeCorrectionJob  constructor');
        System.debug(System.LoggingLevel.ERROR, 'IncomeCorrectionJob Job Query: ' + query);
    }
    
    global override String getRuntimeQuery(){
        if(customQuery != null){
            return customQuery;
        }
        String query = 'SELECT Id ' +
                       'FROM cllease__lease_Account__c ' +
                       'WHERE cllease__lease_Status__c IN  (\'' + cllease.LendingConstants.STATUS_ACTIVE_GOOD_STANDING + '\', \'' +
                                                                      cllease.LendingConstants.STATUS_ACTIVE_BAD_STANDING + '\') ' + 
                       'AND cllease__Product_Sub_Type__c = \'' + cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE + '\' ' +
            		   'AND Id = \'a690O000000kF2u\' '+
                       'ORDER BY Name';
        System.debug(System.LoggingLevel.ERROR, 'IncomeCorrectionJob Job Query: ' + query);
        return query;
    }
        
    global override void doInitialize() {}
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(Database.BatchableContext bc, List<sobject> scope) {
        List<cllease__Lease_Account__c> allContracts = (List<cllease__Lease_Account__c>)scope;
        System.debug(LoggingLevel.ERROR, 'Inside IncomeCorrectionJob execute ' + scope.size());
        
        ErrorLogUtil logUtil = new ErrorLogUtil();
        Set<Id> allLsIds = new Set<Id>();
        try{
            for(cllease__Lease_Account__c cnt : allContracts) {
                allLsIds.add(cnt.Id);
            }
            System.debug(loggingLevel.error, 'Contracts size ' + allLsIds.size());

            List<cllease__lease_Account__c> issueContracts = getIssueContracts(allLsIds);
            System.debug(loggingLevel.error, 'Issue Contracts size ' + issueContracts.size());
            
            updateIssueContractIncomeStreams(issueContracts);
        } catch(Exception e) {
            String error = 'Cause : ' + e.getCause() + '\n';
            error += 'Line No : ' + e.getLineNumber() + '\n';
            error += 'Message : ' + e.getMessage() + '\n';
            error += 'Stack Trace : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, '^^^^ ERROR : ' + error);
            logUtil.addError(bc.getJobId(), allContracts[0].Id, error, cllease.SystemDateUtil.getCurrentSystemDate());
            logUtil.commitErrors();
        }
    }
    
    public List<cllease__Lease_Account__c> getIssueContracts(Set<Id> lsIds) {
        List<cllease__lease_Account__c> lsContracts = [SELECT Id, Name, cllease__Contract_Date__c,
                                                        cllease__Payment_Method__c,
                                                        cllease__Financed_Amount__c,
                                                        cllease__Residual_Amount__c,
                                                       	cllease__Days_Convention__c,
                                                       (SELECT Id, cllease__Transaction_Type__c
                                                        FROM cllease__Other_Lease_Transactions__r
                                                        WHERE cllease__Transaction_Type__c in (:cllease.LendingConstants.TRANSACTION_ADDON,:cllease.LendingConstants.TXN_TERMINATION)),
                                                       (SELECT Id, cllease__Rental_Amount__c
                                                        FROM cllease__Payment_Streams__r
                                                        WHERE cllease__Active__c = true
                                                        AND cllease__Transaction_Sub_Type__c != null
                                                        AND cllease__Payment_Type__c IN ('RENT','ADVANCE RENT')),
                                                       (SELECT Id, Name, cllease__Date__c,
                                                        cllease__Beginning_Net_Book_Value__c,
                                                        cllease__Beginning_Net_Investment__c,
                                                        cllease__Payment_Amount__c,
                                                        cllease__Lease_Income__c,
                                                        cllease__Monthly_Income__c,
                                                        cllease__Pro_Rated_Income__c,
                                                        cllease__Ending_Net_Book_Value__c,
                                                        cllease__Ending_Net_Investment__c
                                                        FROM cllease__Rental_Streams__r 
                                                        WHERE cllease__Active__c = true ORDER BY cllease__Date__c)
                                                       FROM cllease__lease_Account__c 
                                                       WHERE Id in :lsIds ORDER BY NAME];
        List<cllease__lease_Account__c> issueContracts = new List<cllease__lease_Account__c>();
        for(cllease__lease_Account__c ls : lsContracts) {
            if(ls.cllease__Other_Lease_Transactions__r.size() > 0) {
                continue;
            }
            
            Decimal totalPaymentAmt = 0, incomeAccrAmt = 0;
            Decimal financedAmt = ls.cllease__Rental_Streams__r[0].cllease__Beginning_Net_Book_Value__c;
            //ls.cllease__Financed_Amount__c == null ? 0 : ls.cllease__Financed_Amount__c;                
            Decimal residualAmt = ls.cllease__Residual_Amount__c == null ? 0 : ls.cllease__Residual_Amount__c; 
            
            for(cllease__Payment_Stream__c pmntStream : ls.cllease__Payment_Streams__r) {
                totalPaymentAmt += pmntStream.cllease__Rental_Amount__c;
            }
            
            System.debug(LoggingLevel.ERROR, '^^^^ totalPaymentAmt : ' + totalPaymentAmt);
            
            for(cllease__Rental_Stream__c incomeStream : ls.cllease__Rental_Streams__r) {
                incomeAccrAmt += incomeStream.cllease__Lease_Income__c;
            }
            
            System.debug(LoggingLevel.ERROR, '^^^^ incomeAccrAmt : ' + incomeAccrAmt);
            
            Decimal incomeAmt = totalPaymentAmt - (financedAmt - residualAmt);
            
            System.debug(LoggingLevel.ERROR, '^^^^ incomeAmt : ' + incomeAmt);
            
            System.debug(LoggingLevel.ERROR, '^^^^ Diff : ' + (incomeAccrAmt.setScale(2) - incomeAmt.setScale(2)).abs());
            
            if((incomeAccrAmt.setScale(2) - incomeAmt.setScale(2)).abs() >= 0) {
                issueContracts.add(ls);
                lsIdsToFix.add(ls.Id);
                System.debug(loggingLevel.error, 'ls ' + ls.Name);
            } else {
                continue;
            }
        }
        
        System.debug(loggingLevel.error, 'issueContracts count ' + issueContracts.size());
        return issueContracts;
    }
    
    public void updateIssueContractIncomeStreams(List<cllease__Lease_Account__c> lsContracts) {
        Boolean first = true;
        System.debug(loggingLevel.error, 'Updating income streams');
        List<cllease__Rental_Stream__c> incomeStreamsToUpdate = new List<cllease__Rental_Stream__c>();
        for(cllease__Lease_Account__c ls : lsContracts) {
            List<cllease__Rental_Stream__c> incomeStreams = ls.cllease__Rental_Streams__r;
            Decimal income = 0, monthlyInc = 0, payment = 0, lastPRInc = 0, lastMonthyInc = 0;
            Decimal firstMonthIncome = incomeStreams[0].cllease__Monthly_Income__c;
            Decimal begNBI = incomeStreams[0].cllease__Beginning_Net_Investment__c , begNbV = incomeStreams[0].cllease__Beginning_Net_Book_Value__c;
            String paymentMethod = ls.cllease__Payment_Method__c == null ? cllease.LendingConstants.PAMENT_METHOD_ADVANCED : ls.cllease__Payment_Method__c;
            for(cllease__Rental_Stream__c str : incomeStreams) {
                str.cllease__Beginning_Net_Book_Value__c = begNBV;
                str.cllease__Beginning_Net_Investment__c = begNBI;
                income = str.cllease__Lease_Income__c;
                monthlyInc = str.cllease__Monthly_Income__c;
                payment = str.cllease__Payment_Amount__c; 
                begNBV = str.cllease__Ending_Net_Book_Value__c;
                begNBI = str.cllease__Ending_Net_Investment__c;
                if(paymentMethod.equalsIgnoreCase(cllease.LendingConstants.PAMENT_METHOD_ARREARS)) {
                    str.cllease__Pro_Rated_Income__c = lastPRInc;
                    lastPRInc = income - (monthlyInc - lastPRInc);
                } else {
                    System.debug(LoggingLevel.ERROR, '^^^^ firstMonthIncome : ' + firstMonthIncome);
                    if(firstMonthIncome == 0){
                        if(first){
                            monthlyInc = proRateIncome(income, ls.cllease__Contract_Date__c.day(), str.cllease__Date__c, ls.cllease__Days_Convention__c);
                            str.cllease__Pro_Rated_Income__c = income;
                            first = false;
                        } else{
                            System.debug(LoggingLevel.ERROR, '^^^^ else');
                            str.cllease__Pro_Rated_Income__c = income - (lastMonthyInc - lastPRInc);
                            monthlyInc = proRateIncome(str.cllease__Pro_Rated_Income__c, 
                                                           ls.cllease__Contract_Date__c.day(), 
                                                           str.cllease__Date__c, 
                                                           ls.cllease__Days_Convention__c);
                        }
                        System.debug(LoggingLevel.ERROR, '^^^^ monthlyInc : ' + monthlyInc);
                        lastPRInc = str.cllease__Pro_Rated_Income__c;
                        lastMonthyInc = monthlyInc;
                    } else{
                        str.cllease__Pro_Rated_Income__c = income - (lastMonthyInc - lastPRInc);
                        lastPRInc = str.cllease__Pro_Rated_Income__c;
                        lastMonthyInc = str.cllease__Monthly_Income__c;
                    }
                }
                str.cllease__Ending_Net_Book_Value__c = str.cllease__Beginning_Net_Book_Value__c - (payment - monthlyInc);
                str.cllease__Ending_Net_Investment__c = str.cllease__Beginning_Net_Investment__c - (payment - income);
                System.debug(LoggingLevel.ERROR, '^^^^ Prorated Income :  ' + str.cllease__Pro_Rated_Income__c);
                System.debug(LoggingLevel.ERROR, '^^^^ str :  ' + str);
                incomeStreamsToUpdate.add(str);
            }
        }
        //update incomeStreamsToUpdate;
    }
    
    public static Decimal proRateIncome(Decimal income, Integer amortDay, Date streamDate, String accrualType){
        Integer accrualBase = 360;
        income = income == null ? 0 : income;
        Integer daysInMonth = 30;
        if (accrualType.equalsIgnoreCase(cllease.LendingConstants.ACCRUAL_METHOD_Code_365_365)) {
            accrualBase = 365;
        } else if ((accrualType.equalsIgnoreCase(cllease.LendingConstants.ACCRUAL_METHOD_Code_366_366))
                   || (accrualType.equalsIgnoreCase(cllease.LendingConstants.ACCRUAL_METHOD_Code_ACTUAL_ACTUAL))) {
            accrualBase = 366;
        }
        if(accrualBase == 365 || accrualBase == 366){
            if(accrualBase == 365 && streamDate.month() == 2){
                daysInMonth = 28;
            }
            else{
                daysInMonth = Date.daysInMonth(streamDate.year() , streamDate.month());
            }
        }
        if(amortDay > daysInMonth){
            amortDay = 0;
        } else {
            amortDay = daysInMonth - amortDay + 1;
        }
        return ((income/amortDay)*daysInMonth);
    }
    
    global override void doFinish(Database.BatchableContext bc) {
        System.debug(LoggingLevel.ERROR, ' doFinish lsIdsToFix ' + this.lsIdsToFix.size());
        if(this.lsIdsToFix.size() > 0 && doRestructure) {
            Integer actionParam = 1; // create restructure contract and regenerate streams
            //RestructureAPIJob job = new RestructureAPIJob(this.lsIdsToFix, actionParam);
            //Database.executeBatch(job, 1);
        }
    }
}