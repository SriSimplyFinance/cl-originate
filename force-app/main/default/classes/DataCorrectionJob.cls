global class DataCorrectionJob implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {   
        String query = 'Select Id From cllease__Lease_Account__c';
        query += ' Where faulty_Data_Contract__c = true and Expected_Monthly_Income__c = true';
        //query += ' and Id = \'a690O000000Xyc3QAC\'';
        //query += ' and Id = \'a693Y000000TQY7QAO\'';
        return Database.getQueryLocator(query);
    }
    
    public class streamAndTxn{
        List<cllease__Rental_Stream__c> streams;
        List<cllease__Lease_Trx_Header__c> headerTxns;
        
        streamAndTxn(List<cllease__Rental_Stream__c> incomeStreams, List<cllease__Lease_Trx_Header__c> accrualTxns){
            this.streams = incomeStreams;
            this.headerTxns = accrualTxns;
        }
    }
    
    global void execute(Database.BatchableContext BC, List<cllease__Lease_Account__c> contracts) {
        Set<Id> contractIds = new Set<Id>();
        List<cllease__Rental_Stream__c> incomeStreamsToUpdate = new List<cllease__Rental_Stream__c>();
        List<cllease__Lease_Trx_Header__c> headerTxns = new List<cllease__Lease_Trx_Header__c>();
        List<cllease__Lease_Account__c> advanceContractList = new List<cllease__Lease_Account__c>();
        List<cllease__Lease_Account__c> arrearsContractList = new list<cllease__Lease_Account__c>();
        for(cllease__Lease_Account__c contract : contracts){
            contractIds.add(contract.Id);
        }
        List<cllease__Lease_Account__c> contractList = [Select Id, 
                                                            cllease__Payment_Method__c,
                                                            cllease__Amort_Start_Date__c,
                                                            cllease__Days_Convention__c,
                                                        	cllease__Financed_Amount__c,
                                                            (Select Id,
                                                                cllease__Date__c,
                                                                cllease__Beginning_Net_Book_Value__c,
                                                                cllease__Beginning_Net_Investment__c,
                                                                cllease__Payment_Amount__c,
                                                                cllease__Monthly_Income__c,
                                                                cllease__Lease_Income__c,
                                                                cllease__Pro_Rated_Income__c,
                                                                cllease__Capital_Recovery__c,
                                                                cllease__Ending_Net_Book_Value__c,
                                                                cllease__Ending_Net_Investment__c,
                                                                cllease__Accrued_Flag__c
                                                                From cllease__Rental_Streams__r
                                                            	order by cllease__Date__c asc)
                                                        From cllease__Lease_Account__c
                                                        WHERE Id IN : contractIds
                                                        AND faulty_Data_Contract__c = true];
        for(cllease__Lease_Account__c contract : contractList){
            if(contract.cllease__Payment_Method__c == 'Advance'){
                advanceContractList.add(contract);
            } else{
                arrearsContractList.add(contract);
            }
        }
        // Advance contract data correction module
        if(advanceContractList.size() > 0){
            streamAndTxn advanceContractTxns = modifyAdvanceContractStreams(advanceContractList);
            incomeStreamsToUpdate.addAll(advanceContractTxns.streams);
            headerTxns.addAll(advanceContractTxns.headerTxns);
        }
        
        // Arrears contract data correction module
        if(arrearsContractList.size() > 0){
            streamAndTxn advanceContractTxns = modifyArrearsContractStreams(arrearsContractList);
            incomeStreamsToUpdate.addAll(advanceContractTxns.streams);
            headerTxns.addAll(advanceContractTxns.headerTxns);
        }

        System.debug(LoggingLevel.ERROR, 'Accrual Header : ' + headerTxns);
        if(incomeStreamsToUpdate.size() > 0){
        	update incomeStreamsToUpdate;
        }
        if(headerTxns.size() > 0){
            insert headerTxns;
            processAccrualTxnLineAndOtherTxn(headerTxns);
        }
    }
    
    public streamAndTxn modifyAdvanceContractStreams(List<cllease__Lease_Account__c> contracts){
        List<cllease__Rental_Stream__c> streamsToUpdate = new List<cllease__Rental_Stream__c>();
        List<cllease__Lease_Trx_Header__c> txnHeader = new List<cllease__Lease_Trx_Header__c>();
        for(cllease__Lease_Account__c contract : contracts){
            Decimal balIncome = 0;
            Decimal proRatedIncome = 0;
            Decimal previousBalIncome = 0;
            Decimal beginningBalance = contract.cllease__Rental_Streams__r[0].cllease__Beginning_Net_Investment__c;
            Decimal beginningBookValue = beginningBalance;
            Decimal oldAccruedIncome = 0;
            Decimal newAccruedIncome = 0;
            Decimal totalPayment = 0;
            Decimal adjustmentIncome = 0;
            Decimal totalMonthlyIncome = 0;
            Boolean incomeAdjusted = false;
            Date accrualDate;
            cllease__Lease_Trx_Header__c header = new cllease__Lease_Trx_Header__c();
            header.cllease__Contract__c = contract.Id;
            header.cllease__GL_Transaction_Flag__c = true;
            header.cllease__Transaction_Type__c = 'ACCRUAL';
            for(cllease__Rental_Stream__c stream : contract.cllease__Rental_Streams__r){
                totalPayment += stream.cllease__Payment_Amount__c;
                totalMonthlyIncome += stream.cllease__Monthly_Income__c;
            }
            adjustmentIncome = totalPayment - contract.cllease__Financed_Amount__c - cllease.ValueUtil.round(totalMonthlyIncome);
            for(cllease__Rental_Stream__c stream : contract.cllease__Rental_Streams__r){
                stream.Old_Beginning_Net_Book_Value__c = stream.cllease__Beginning_Net_Book_Value__c;
                stream.Old_Beginning_Net_Investment__c = stream.cllease__Beginning_Net_Investment__c;
                stream.Old_Ending_Net_Book_Value__c = stream.cllease__Ending_Net_Book_Value__c;
                stream.Old_Ending_Net_Investment__c = stream.cllease__Ending_Net_Investment__c;
                stream.Old_Lease_Income__c = stream.cllease__Lease_Income__c;
                stream.Old_Pro_Rated_Income__c = stream.cllease__Pro_Rated_Income__c;
                stream.Old_Capital_Recovery__c = stream.cllease__Capital_Recovery__c;
                if(!incomeAdjusted && stream.cllease__Monthly_Income__c > 0){
                    System.debug(LoggingLevel.ERROR, 'Adj Income : ' + adjustmentIncome);
                    System.debug(LoggingLevel.ERROR, 'Monthly Income : ' + stream.cllease__Monthly_Income__c);
                    balIncome = proRateIncome(cllease.ValueUtil.round(stream.cllease__Monthly_Income__c + adjustmentIncome),
                                                  contract.cllease__Amort_Start_Date__c.day(),
                                                  stream.cllease__Date__c,
                                                  contract.cllease__Days_Convention__c);
                    incomeAdjusted = true;
                } else{
                    balIncome = proRateIncome(cllease.ValueUtil.round(stream.cllease__Monthly_Income__c),
                                                  contract.cllease__Amort_Start_Date__c.day(),
                                                  stream.cllease__Date__c,
                                                  contract.cllease__Days_Convention__c);
                }
                balIncome = cllease.ValueUtil.round(balIncome);
                stream.cllease__Beginning_Net_Investment__c = beginningBalance;
                stream.cllease__Beginning_Net_Book_Value__c = beginningBookValue;
                stream.cllease__Pro_Rated_Income__c = balIncome;
                stream.cllease__Lease_Income__c = balIncome + previousBalIncome;
                stream.cllease__Capital_Recovery__c = cllease.ValueUtil.round(stream.cllease__Payment_Amount__c - stream.cllease__Lease_Income__c);
                stream.cllease__Ending_Net_Investment__c = cllease.ValueUtil.round(stream.cllease__Beginning_Net_Investment__c)
                    											- cllease.ValueUtil.round(stream.cllease__Capital_Recovery__c)
                    											+ adjustmentIncome;
                stream.cllease__Ending_Net_Book_Value__c = cllease.ValueUtil.round(stream.cllease__Beginning_Net_Book_Value__c)
                                                                      - (stream.cllease__Payment_Amount__c - cllease.ValueUtil.round(stream.cllease__Monthly_Income__c))
                                                                      + adjustmentIncome;
                previousBalIncome = cllease.ValueUtil.round(stream.cllease__Monthly_Income__c - balIncome);
                beginningBalance = stream.cllease__Ending_Net_Investment__c;
                beginningBookValue = stream.cllease__Ending_Net_Book_Value__c;
                adjustmentIncome = 0;
                System.debug(LoggingLevel.ERROR, 'FS : ' + stream);
                
                if(stream.cllease__Accrued_Flag__c){
                    oldAccruedIncome += stream.Old_Lease_Income__c;
                    newAccruedincome += stream.cllease__Lease_Income__c;
                    accrualDate = stream.cllease__Date__c;
                }
                streamsToUpdate.add(stream);
            }
            System.debug(LoggingLevel.ERROR, 'Adjustment Income : ' + (newAccruedIncome - oldAccruedIncome));
            header.cllease__Transaction_Date__c = accrualDate;
            header.cllease__Amount__c = cllease.ValueUtil.round(newAccruedIncome - oldAccruedIncome);
            txnHeader.add(header);
        }
        streamAndTxn updatedTxns = new streamAndTxn(streamsToUpdate, txnHeader);
        return updatedTxns;
    }
    
    public streamAndTxn modifyArrearsContractStreams(List<cllease__Lease_Account__c> contracts){
        List<cllease__Rental_Stream__c> streamsToUpdate = new List<cllease__Rental_Stream__c>();
        List<cllease__Lease_Trx_Header__c> txnHeader = new List<cllease__Lease_Trx_Header__c>();
        for(cllease__Lease_Account__c contract : contracts){
            Decimal balIncome = 0;
            Decimal proRatedIncome = 0;
            Decimal previousBalIncome = 0;
            Decimal beginningBalance = contract.cllease__Rental_Streams__r[0].cllease__Beginning_Net_Investment__c;
            Decimal beginningBookValue = beginningBalance;
            Decimal oldAccruedIncome = 0;
            Decimal newAccruedIncome = 0;
            Decimal totalPayment = 0;
            Decimal adjustmentIncome = 0;
            Decimal totalMonthlyIncome = 0;
            Boolean incomeAdjusted = false;
            Date accrualDate;
            cllease__Lease_Trx_Header__c header = new cllease__Lease_Trx_Header__c();
            header.cllease__Contract__c = contract.Id;
            header.cllease__GL_Transaction_Flag__c = true;
            header.cllease__Transaction_Type__c = 'ACCRUAL';
            for(cllease__Rental_Stream__c stream : contract.cllease__Rental_Streams__r){
                totalPayment += stream.cllease__Payment_Amount__c;
                totalMonthlyIncome += stream.cllease__Monthly_Income__c;
            }
            adjustmentIncome = totalPayment - contract.cllease__Financed_Amount__c - cllease.ValueUtil.round(totalMonthlyIncome);
            adjustmentIncome = cllease.ValueUtil.round(adjustmentIncome);
            List<cllease__Rental_Stream__c> streams = contract.cllease__Rental_Streams__r;
            for(Integer i = 1 ; i < streams.size(); i++){
                if(!incomeAdjusted && streams[i].cllease__Monthly_Income__c > 0){
                    System.debug(LoggingLevel.ERROR, 'Adj Income : ' + adjustmentIncome);
                    System.debug(LoggingLevel.ERROR, 'Monthly Income : ' + streams[i].cllease__Monthly_Income__c);
                    proRatedIncome = proRateIncome((streams[i].cllease__Monthly_Income__c + adjustmentIncome),
                                                      contract.cllease__Amort_Start_Date__c.day(),
                                                      streams[i].cllease__Date__c,
                                                      contract.cllease__Days_Convention__c);
                    incomeAdjusted = true;
                } else{
                    proRatedIncome = proRateIncome(streams[i].cllease__Monthly_Income__c,
                                                      contract.cllease__Amort_Start_Date__c.day(),
                                                      streams[i].cllease__Date__c,
                                                      contract.cllease__Days_Convention__c);
                }
                proRatedIncome = cllease.ValueUtil.round(proRatedIncome);
                streams[i].Old_Pro_Rated_Income__c = streams[i].cllease__Pro_Rated_Income__c;
                streams[i].cllease__Pro_Rated_Income__c = proRatedIncome;
                streams[i-1].Old_Lease_Income__c = streams[i-1].cllease__Lease_Income__c;
                streams[i-1].cllease__Lease_Income__c = proRatedIncome + balIncome;
                balIncome = streams[i].cllease__Monthly_Income__c - proRatedIncome;
                if(i == streams.size() - 1){
                    streams[i].Old_Pro_Rated_Income__c = streams[i].cllease__Pro_Rated_Income__c;
                	streams[i].Old_Lease_Income__c = streams[i].cllease__Lease_Income__c;
                    streams[i].cllease__Lease_Income__c = balIncome;
                    streams[i].cllease__Pro_Rated_Income__c = proRatedIncome;
                }
                System.debug(LoggingLevel.ERROR, 'check : ' + proRatedIncome + ' : ' + balIncome);
            } 
            for(cllease__Rental_Stream__c stream : contract.cllease__Rental_Streams__r){
                stream.Old_Beginning_Net_Book_Value__c = stream.cllease__Beginning_Net_Book_Value__c;
                stream.Old_Beginning_Net_Investment__c = stream.cllease__Beginning_Net_Investment__c;
                stream.Old_Ending_Net_Book_Value__c = stream.cllease__Ending_Net_Book_Value__c;
                stream.Old_Ending_Net_Investment__c = stream.cllease__Ending_Net_Investment__c;
                stream.Old_Capital_Recovery__c = stream.cllease__Capital_Recovery__c;
                stream.cllease__Beginning_Net_Investment__c = beginningBalance;
                stream.cllease__Beginning_Net_Book_Value__c = beginningBookValue;
                stream.cllease__Capital_Recovery__c = cllease.ValueUtil.round(stream.cllease__Payment_Amount__c - stream.cllease__Lease_Income__c);
                stream.cllease__Ending_Net_Investment__c = cllease.ValueUtil.round(stream.cllease__Beginning_Net_Investment__c)
                    											- cllease.ValueUtil.round(stream.cllease__Capital_Recovery__c)
                    											+ adjustmentIncome;
                stream.cllease__Ending_Net_Book_Value__c = cllease.ValueUtil.round(stream.cllease__Beginning_Net_Book_Value__c)
                                                                      - (stream.cllease__Payment_Amount__c - cllease.ValueUtil.round(stream.cllease__Monthly_Income__c))
                                                                      + adjustmentIncome;
                beginningBalance = stream.cllease__Ending_Net_Investment__c;
                beginningBookValue = stream.cllease__Ending_Net_Book_Value__c;
                adjustmentIncome = 0;
                System.debug(LoggingLevel.ERROR, 'FS : ' + stream);
                
                if(stream.cllease__Accrued_Flag__c){
                    oldAccruedIncome += stream.Old_Lease_Income__c;
                    newAccruedincome += stream.cllease__Lease_Income__c;
                    accrualDate = stream.cllease__Date__c;
                }
                streamsToUpdate.add(stream);
            }
            System.debug(LoggingLevel.ERROR, 'Adjustment Income : ' + (newAccruedIncome - oldAccruedIncome));
            header.cllease__Transaction_Date__c = accrualDate;
            header.cllease__Amount__c = newAccruedIncome - oldAccruedIncome;
            txnHeader.add(header);
        }
        streamAndTxn updatedTxns = new streamAndTxn(streamsToUpdate, txnHeader);
        return updatedTxns;
    }
    
    public void processAccrualTxnLineAndOtherTxn(List<cllease__Lease_Trx_Header__c> txnHeaders){
        List<cllease__Lease_Trx_Lines__c> txnLines = new List<cllease__Lease_Trx_Lines__c>();
        list<cllease__Other_Transaction__c> restTxns = new List<cllease__Other_Transaction__c>();
        cllease__Transaction_Sub_Type__c txnSubType = [Select Id From cllease__Transaction_Sub_Type__c Where name = 'LEASE INCOME ACCRUAL' Limit 1];
        List<cllease__Lease_Account__c> correctedContract = new List<cllease__Lease_Account__c>();
        for(cllease__Lease_Trx_Header__c header : txnHeaders){
            cllease__Lease_Trx_Lines__c txnLine = new cllease__Lease_Trx_Lines__c();
            txnLine.cllease__Contract__c = header.cllease__Contract__c;
            txnLine.cllease__Trx_Header__c = header.Id;
            txnLine.cllease__Amount__c = header.cllease__Amount__c;
            txnLine.cllease__Transaction_Date__c = header.cllease__Transaction_Date__c;
            txnLine.cllease__Accounted_YN__c = true;
            txnLine.cllease__Transaction_Sub_Type__c = txnSubType.Id;
            txnLines.add(txnLine);
            
            cllease__Other_Transaction__c restTxn = new cllease__Other_Transaction__c();
            restTxn.cllease__Lease_Account__c = header.cllease__Contract__c;
            restTxn.cllease__Transaction_Type__c = 'RESTRUCTURE';
            restTxn.cllease__Description__c = 'Created as part of stream data fix';
            restTxn.cllease__Txn_Date__c  = header.cllease__Transaction_Date__c == null ? cllease.SystemDateUtil.getCurrentSystemDate() : header.cllease__Transaction_Date__c;
            restTxn.cllease__Repayment_Start_Date__c = restTxn.cllease__Txn_Date__c;
            restTxns.add(restTxn);
            
            cllease__Lease_Account__c contract = new cllease__Lease_Account__c();
            contract.Id = header.cllease__Contract__c;
            contract.faulty_Data_Contract__c = false;
            correctedContract.add(contract);
        }
        Insert txnLines;
        Insert restTxns;
        //update correctedContract;
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
        return ((income*amortDay)/daysInMonth);
    }
    
    global void finish(Database.BatchableContext BC) {}
}