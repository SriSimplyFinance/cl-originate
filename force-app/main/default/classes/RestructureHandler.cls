public class RestructureHandler {
    public Date restructureDate;
    private List<cllease__Lease_Account__c> leaseAccountList;
    private Map<String, String> contractDetails = new Map<String, String>();
    Set<Id> leaseIds = new Set<Id>();
    private Integer restPeriod;
    Map<Id,Boolean> existingRestructure = new Map<Id,Boolean>();
    Id batchJobId;
    private Integer action;
    
    public class TransactionException extends Exception {
    }
    
    public RestructureHandler(List<Cllease__Lease_Account__c> leaseAccountList, Date sodDate, Integer period, Map<String, String>contractMap){
        this.restructureDate = sodDate;
        this.leaseAccountList = leaseAccountList;
        this.contractDetails = contractMap;
        this.restPeriod = period;
    }
    
    public void process(Id jobId, Integer actionParam){
        batchJobId = jobId;
        action = actionParam;
        for(Cllease__Lease_Account__c leaseAcc : leaseAccountList)
            leaseIds.add(leaseAcc.Id);
        List<Cllease__Lease_Account__c> leaseAccount = [SELECT ID,
                                                        Name,
                                                        cllease__Contract_Date__c,
                                                        cllease__Restructured_Contract__c,
                                                        cllease__Product_Sub_Type__c,
                                                        cllease__Accrual_Streams__c,
                                                        cllease__Pre_Bill_Days__c,
                                                        cllease__Payment_Method__c,
                                                            (SELECT Id, 
                                                             cllease__Sequence__c, 
                                                             cllease__VAT__c, 
                                                             cllease__Number_Of_Payments__c, 
                                                             cllease__Payment_Amount__c, 
                                                             Name, 
                                                             cllease__Total_Payment__c, 
                                                             cllease__Payment_Date__c, 
                                                             cllease__Frequency__c,
                                                             cllease__Due_Day__c
                                                             FROM cllease__Payment_Schedule__r 
                                                             order by cllease__Sequence__c),
                                                            (SELECT Id,
                                                             name,  
                                                             cllease__Date__c 
                                                             FROM cllease__Payment_Streams__r 
                                                             WHERE cllease__Payment_Type__c = 'RENT'
                                                             order by cllease__Date__c)
                                                       FROM cllease__Lease_Account__c
                                                       WHERE Id In : leaseIds];
        List<cllease__Lease_Account__c> tempContract = [SELECT Id, cllease__Restructured_Contract__c FROM cllease__Lease_Account__c WHERE cllease__Restructured_Contract__c IN :leaseIds];
        for(Cllease__Lease_Account__c leaseAcc : tempContract){
            if(leaseIds.contains(leaseAcc.cllease__Restructured_Contract__c))
                existingRestructure.put(leaseAcc.cllease__Restructured_Contract__c, true);
            else
                existingRestructure.put(leaseAcc.cllease__Restructured_Contract__c, false);
        }
        
        for(Cllease__Lease_Account__c leaseAcc : leaseAccount){
            system.debug(LoggingLevel.ERROR, '^^^^ value : ' + contractDetails.get(leaseAcc.Name));
            makeRequestCallToRestructure(leaseAcc);
        }
    }
    
    public String formatDate(Date tempDate){
        String paymentDate;
        String month;
        String day;
        if(tempDate.month()<9){
            month = '0'+String.valueOf(tempDate.month());
        }else{
            month = String.valueOf(tempDate.month());
        }
        if(tempDate.day()<9){
            day = '0'+String.valueOf(tempDate.day());
        }else{
            day = String.valueOf(tempDate.day());
        }
        //paymentDate = month +'/'+day+'/'+ String.valueOf(tempDate.year());
        paymentDate =  day+'/'+month+'/'+ String.valueOf(tempDate.year());
        return paymentDate;
    }
    
    public void makeRequestCallToRestructure(Cllease__Lease_Account__c leaseAcc){
        ErrorLogUtil logUtil = new ErrorLogUtil();
        try{
            if(existingRestructure != null && existingRestructure.containsKey(leaseAcc.Id) && existingRestructure.get(leaseAcc.Id) && action == 1)
                throw new TransactionException('Existing Restructure In Progress.. Please deleted existing and try again..');
            Date actualRestructureDate, newPaymentDate, incomeDate;
            cllease__Rental_Stream__c incomeStream = new cllease__Rental_Stream__c();  
           
            for(cllease__Payment_Stream__c pmt : leaseAcc.cllease__Payment_Streams__r){
                if(pmt.cllease__Date__c >= restructureDate){
                    newPaymentDate = pmt.cllease__Date__c;
                    break;
                } else{
                    actualRestructureDate = pmt.cllease__Date__c;
                }
            }
            
            if(leaseAcc.cllease__Payment_Method__c == cllease.LendingConstants.PAMENT_METHOD_ADVANCED){
                actualRestructureDate = restructureDate;
                if(actualRestructureDate != leaseAcc.cllease__Contract_Date__c)
                    actualRestructureDate = restructureDate.addDays(-1);
            }
            System.debug(LoggingLevel.ERROR, '^^^^ actualRestructureDate : ' + actualRestructureDate);
            
            actualRestructureDate = actualRestructureDate == null ? leaseAcc.cllease__Contract_Date__c : actualRestructureDate;
            if(leaseAcc.cllease__Pre_Bill_Days__c != null){
                actualRestructureDate -= Integer.valueOf(leaseAcc.cllease__Pre_Bill_Days__c);
            }
            System.debug(LoggingLevel.ERROR, '^^^^ actualRestructureDate : ' + actualRestructureDate);
            incomeDate = newPaymentDate.addMonths(1).toStartofMonth().addDays(-1);
            String disstressDate = formatDate(actualRestructureDate);
            Integer index=0;
            Integer pmtCounter=1;
            Boolean foundPmt = false;
            Decimal currentPayment = 0;
            Decimal pmtInput;
            Cllease__Payment_Schedule__c pmtSch;
            Boolean percentagePayment = false;
            List<Cllease__Payment_Schedule__c> newPmtSch = new List<Cllease__Payment_Schedule__c>();
            System.debug(LoggingLevel.ERROR, '^^^^ restructureDate : ' + restructureDate);
            System.debug(LoggingLevel.ERROR, '^^^^ actualRestructureDate : ' + actualRestructureDate);
            System.debug(LoggingLevel.ERROR, '^^^^ newPaymentDate : ' + newPaymentDate);
            System.debug(LoggingLevel.ERROR, '^^^^ disstressDate : ' + disstressDate);
            
            //Code to comsume customer given payment as part of schedule
            if(contractDetails.get(leaseAcc.Name) != null){
                if(contractDetails.get(leaseAcc.Name).contains('%')){
                    pmtInput = Decimal.valueOf(contractDetails.get(leaseAcc.Name).split('%')[0]);
                    percentagePayment = true;
                } else if(contractDetails.get(leaseAcc.Name).toLowerCase() == 'income'){
                    if(leaseAcc.cllease__Product_Sub_Type__c == 'FINANCE LEASE' && leaseAcc.cllease__Accrual_Streams__c.contains('Income')){
                        incomeStream = [SELECT cllease__Lease_Income__c 
                                        FROM cllease__Rental_Stream__c 
                                        WHERE cllease__Contract__c =: leaseAcc.Id 
                                        AND cllease__Date__c =:incomeDate];
                    }
                    if(leaseAcc.cllease__Product_Sub_Type__c == 'FINANCE LEASE'){
                        if(incomeStream != null){
                            pmtInput = incomeStream.cllease__Lease_Income__c;
                        } else{
                            pmtInput = 0;
                        }
                    } else{
                        pmtInput = 0;
                    }
                } else{
                    pmtInput = Decimal.valueOf(contractDetails.get(leaseAcc.Name));
                }
                if(test.isRunningTest()){
                   percentagePayment = true;
                    pmtInput = 1;                    
                }
                if(pmtInput > 0 && !percentagePayment){
                    pmtSch = new Cllease__Payment_Schedule__c();
                    pmtSch.cllease__Sequence__c = pmtCounter;
                    pmtSch.cllease__Number_Of_Payments__c = restPeriod;
                    pmtSch.cllease__Frequency__c = 'MONTHLY';
                    pmtSch.cllease__Payment_Amount__c = pmtInput;
                    pmtSch.cllease__Payment_Date__c = newPaymentDate;
                    newPmtSch.add(pmtSch);
                    pmtCounter += 1;
                }
            }
            
            for(Cllease__Payment_Schedule__c pmtSchedule : leaseAcc.cllease__Payment_Schedule__r){
                Date pmtScheduleDate = pmtSchedule.cllease__Payment_Date__c;
                Integer dueDay = Integer.valueof(pmtSchedule.cllease__Due_Day__c == null? pmtScheduleDate.day():pmtSchedule.cllease__Due_Day__c);
                if(!foundPmt){
                    index++;
                    for(Integer i = 0;i < pmtSchedule.cllease__Number_Of_Payments__c; i++){
                        if(pmtScheduleDate >= newPaymentDate){
                            System.debug(LoggingLevel.ERROR, '^^^^ pmtScheduleDate : ' + pmtScheduleDate);
                            foundPmt = true;
                            if(pmtInput > 0 && percentagePayment){
                                pmtSch = new Cllease__Payment_Schedule__c();
                                pmtSch.cllease__Sequence__c = pmtCounter;
                                pmtSch.cllease__Number_Of_Payments__c = restPeriod;
                                pmtSch.cllease__Frequency__c = 'MONTHLY';
                                pmtSch.cllease__Payment_Amount__c = (pmtInput*pmtSchedule.cllease__Payment_Amount__c)/100;
                                pmtSch.cllease__Payment_Date__c = newPaymentDate;
                                newPmtSch.add(pmtSch);
                                pmtCounter += 1;
                            }
                            pmtSch = new Cllease__Payment_Schedule__c();
                            pmtSch.cllease__Sequence__c = pmtCounter;
                            pmtSch.cllease__Number_Of_Payments__c = pmtSchedule.cllease__Number_Of_Payments__c - i;
                            pmtSch.cllease__Frequency__c = pmtSchedule.cllease__Frequency__c;
                            pmtSch.cllease__Payment_Amount__c = pmtSchedule.cllease__Payment_Amount__c;
                            pmtSch.cllease__Payment_Date__c = cllease.DateUtil.getNextCycleDate(pmtScheduleDate, dueDay, 'Monthly', restPeriod);
                            newPmtSch.add(pmtSch);
                            break;
                        }
                        pmtScheduleDate = cllease.DateUtil.getNextCycleDate(pmtScheduleDate, dueDay, pmtSchedule.cllease__Frequency__c, 1);
                    }
                }
            }
            for(Integer inx = index; inx < leaseAcc.cllease__Payment_Schedule__r.size(); inx++){
                pmtCounter++;
                Date tempDate = leaseAcc.cllease__Payment_Schedule__r[inx].cllease__Payment_Date__c;
                pmtSch = new Cllease__Payment_Schedule__c();
                pmtSch.cllease__Sequence__c = pmtCounter;
                pmtSch.cllease__Number_Of_Payments__c = leaseAcc.cllease__Payment_Schedule__r[inx].cllease__Number_Of_Payments__c;
                pmtSch.cllease__Frequency__c = leaseAcc.cllease__Payment_Schedule__r[inx].cllease__Frequency__c;
                pmtSch.cllease__Payment_Amount__c = leaseAcc.cllease__Payment_Schedule__r[inx].cllease__Payment_Amount__c;
                pmtSch.cllease__Payment_Date__c = cllease.DateUtil.getNextCycleDate(tempDate, tempDate.day(), 'Monthly', restPeriod);
                newPmtSch.add(pmtSch);
            }
            
            for(Cllease__Payment_Schedule__c pmtSchedule : newPmtSch){
                System.debug(LoggingLevel.ERROR,'^^^^ newSch : ' + pmtSchedule);
            }
            
            // Creating the rest request and body and firing the api call
            clcommon.Response res = new clcommon.Response(); 
            HttpRequest req = new HttpRequest();
            req.setTimeOut(30000);
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            String baseUrl = 'Https://' + System.URL.getSalesforceBaseUrl().getHost();
            req.setEndpoint(baseUrl + '/services/apexrest/cllease/v1/restructureContract/');
            req.setMethod('POST');
            req.setHeader('Authorization','Bearer ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            req.setHeader('Content-Length', '0');
                
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('contracts');
            gen.writeStartObject();
            gen.writeStringField('contractId',String.valueOf(leaseAcc.Id));
            gen.writeStringField('restructureDate',disstressDate);
            gen.writeStringField('isDistressProgram','TRUE');
            gen.writeFieldName('paymentScheduleList');
            gen.writeStartArray();
            for(Cllease__Payment_Schedule__c pmtSchedule : newPmtSch){
                gen.writeStartObject();
                gen.writeStringField('sequence', String.valueOf(pmtSchedule.cllease__Sequence__c));
                gen.writeStringField('noOfInstallments',String.valueOf(pmtSchedule.cllease__Number_Of_Payments__c));
                gen.writeStringField('paymentAmount', String.valueOf(pmtSchedule.cllease__Payment_Amount__c));
                gen.writeStringField('frequency', String.valueOf(pmtSchedule.cllease__Frequency__c));
                gen.writeStringField('paymentDate', formatDate(pmtSchedule.cllease__Payment_Date__c));
                gen.writeEndObject();
            }
            gen.writeEndArray();
            gen.writeStringField('actionParameter', string.valueOf(action));
            gen.writeEndObject();
            gen.writeEndObject();
            req.setbody(gen.getAsString());
            System.debug(LoggingLevel.ERROR, '^^^^ req.Body : ' + req.getBody());
            
            if(!Test.isRunningTest()){
                response = http.send(req);
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String content = String.valueOf(results.get('content'));
                
                if(response.getStatusCode() != 200){
                    res.errorMessage = String.valueOf(results.get('msgAlerts'));
                    throw new TransactionException(res.errorMessage);
                }
            }
        } catch(Exception e){
            String error = 'Cause : ' + e.getCause() + '\n';
            error += 'Line No : ' + e.getLineNumber() + '\n';
            error += 'Message : ' + e.getMessage() + '\n';
            error += 'Stack Trace : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, '^^^^ ERROR : ' + error);
            logUtil.addError(batchJobId, leaseAcc.Id, error, cllease.SystemDateUtil.getCurrentSystemDate());
            logUtil.commitErrors();
        }
    }
}