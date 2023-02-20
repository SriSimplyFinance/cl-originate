public class CashBalanceCorrector {
    
      public void execute(List<cllease__Lease_Account__c> contracts) {  
        System.debug(LoggingLevel.ERROR, '**** I AM INSIDE JOB RUN');
        List<cllease__Cash_Account_Balance__c> cashBalancesToUpdate = new List<cllease__Cash_Account_Balance__c>();
        List<cllease__Non_Cash_Account_Balance__c> nonCashBalancesToUpdate = new List<cllease__Non_Cash_Account_Balance__c>();      
        //List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
        Set<Id> contractIds = new Set<Id>();
        Map<Id, ContractDetail> contractDetails = new Map<Id, ContractDetail>();
        for(cllease__Lease_Account__c contract : contracts) {
            contractIds.add(contract.Id);
            ContractDetail detail = new ContractDetail();
            detail.contract = contract;
            detail.type = contract.cllease__Product_Sub_Type__c;
            detail.cashBalances = new Set<String>();
            detail.nonCashBalances = new Set<String>();
            if(contract.cllease__Lease_Product_Name__r.cllease__Track_Cash_Account_Balances__c != null) {
                List<String> cashBalances = contract.cllease__Lease_Product_Name__r.cllease__Track_Cash_Account_Balances__c.split(';');
                for(String cashBaltype : cashBalances) {
                    detail.cashBalances.add(cashBalType);
                }
            } 
            if(contract.cllease__Lease_Product_Name__r.cllease__Track_Non_Cash_Account_Balances__c != null) {
                List<String> nonCashBalances = contract.cllease__Lease_Product_Name__r.cllease__Track_Non_Cash_Account_Balances__c.split(';');
                for(String nonCashBaltype : nonCashBalances) {
                    detail.nonCashBalances.add(nonCashBaltype);
                }
            }
            contractDetails.put(contract.Id, detail);
        }
        System.debug(LoggingLevel.ERROR, '****ContractDetails : ' + contractDetails);
        System.debug(LoggingLevel.ERROR, '****query regular bills for rent');
        List<AggregateResult> bills = [SELECT cllease__Lease_Account__c, 
                                            sum(cllease__Rental_Due_Amount__c) totalRentalDue,
                                            sum(cllease__Rental_Paid_Amount__c) totalRentalPaid
                                        FROM cllease__Lease_Account_Due_Details__c
                                        WHERE cllease__Due_Type_Description__c = :cllease.LendingConstants.BILL_TYPE_RENTAL
                                            AND cllease__Lease_Account__c in :contractIds
                                        GROUP BY cllease__Lease_Account__c];
        System.debug(LoggingLevel.ERROR, '***Bills : ' + bills);
        for(AggregateResult rent : bills) {
            ContractDetail detail = contractDetails.get((Id)rent.get('cllease__Lease_Account__c'));
            detail.receivableBilled = (Decimal)rent.get('totalRentalDue');
            detail.receivablePaid = (Decimal)rent.get('totalRentalPaid');
            System.debug(LoggingLevel.ERROR, '***detail.receivableBilled : ' + detail.receivableBilled);
            System.debug(LoggingLevel.ERROR, '***detail.receivablePaid : ' + detail.receivablePaid);
        }
        System.debug(LoggingLevel.ERROR, '****query evergreen bills for rent');
        List<AggregateResult> evergreenBills = [SELECT cllease__Lease_Account__c, 
                                            sum(cllease__Rental_Due_Amount__c) totalRentalDue,
                                            sum(cllease__Rental_Paid_Amount__c) totalRentalPaid
                                        FROM cllease__Lease_Account_Due_Details__c
                                        WHERE cllease__Due_Type_Description__c =: cllease.LendingConstants.BILL_TYPE_EVG_RENTAL
                                            AND cllease__Lease_Account__c in :contractIds
                                        GROUP BY cllease__Lease_Account__c];
        System.debug(LoggingLevel.ERROR, '***evergreenbills : ' + evergreenbills);
        for(AggregateResult rent : evergreenbills) {
            ContractDetail detail = contractDetails.get((Id)rent.get('cllease__Lease_Account__c'));
            detail.evergreenReceivableBilled = (Decimal)rent.get('totalRentalDue');
            detail.evergreenReceivablePaid = (Decimal)rent.get('totalRentalPaid');
            System.debug(LoggingLevel.ERROR, '***detail.evergreenReceivableBilled : ' + detail.evergreenReceivableBilled);
            System.debug(LoggingLevel.ERROR, '***detail.evergreenReceivablePaid : ' + detail.evergreenReceivablePaid);
        }
        //query bills for tax
        List<AggregateResult> taxBills = [SELECT cllease__Lease_Account__c,
                                            sum(cllease__Tax_Due_Amount__c) totalTax,
                                            sum(cllease__Tax_Paid_Amount__c) totalTaxPaid
                                        FROM cllease__Lease_Account_Due_Details__c
                                        WHERE cllease__Status__c = 'Tax Calculated'
                                            AND cllease__Lease_Account__c in :contractIds 
                                        GROUP BY cllease__Lease_Account__c];
        System.debug(LoggingLevel.ERROR, '***taxBills : ' + taxBills);
        for(AggregateResult tax : taxBills) {
            ContractDetail detail = contractDetails.get((Id)tax.get('cllease__Lease_Account__c'));
            detail.taxBilled = (Decimal)tax.get('totalTax');
            detail.taxPaid = (Decimal)tax.get('totalTaxPaid');
            System.debug(LoggingLevel.ERROR, '***detail.taxBilled : ' + detail.taxBilled);
            System.debug(LoggingLevel.ERROR, '***detail.taxPaid : ' + detail.taxPaid);
        }
        //query charges
        List<AggregateResult> charges = [SELECT cllease__Lease_Account__c,
                                            sum(cllease__Paid_Amount__c) totalPaidAmount,
                                            sum(cllease__Principal_Due__c) totalDue,
                                            sum(cllease__Original_Amount__c) feeDue,
                                            sum(cllease__Tax_Due__c) taxDue
                                        FROM cllease__Charge__c
                                        WHERE cllease__Lease_Account__c in :contractIds
                                        GROUP BY cllease__Lease_Account__c];
        System.debug(LoggingLevel.ERROR, '***charges : ' + charges);
        Decimal feeAmount = 0;
        for(AggregateResult charge : charges) {
            ContractDetail detail = contractDetails.get((Id)charge.get('cllease__Lease_Account__c'));
            if((Decimal)charge.get('totalDue') == 0){
                feeAmount = (Decimal)charge.get('feeDue');
            }
            else{
                feeAmount = (Decimal)charge.get('totalDue');
            }
            detail.chargesBilled = feeAmount = (Decimal)charge.get('feeDue');
            detail.chargesPaid = (Decimal)charge.get('totalPaidAmount');
            System.debug(LoggingLevel.ERROR, '***detail.chargesBilled : ' + detail.chargesBilled);
            System.debug(LoggingLevel.ERROR, '***detail.chargesPaid : ' + detail.chargesPaid);
        }
        charges = [SELECT cllease__Lease_Account__c,
                        sum(cllease__Paid_Amount__c) totalPaidAmount,
                        sum(cllease__Principal_Due__c) totalDue,
                        sum(cllease__Original_Amount__c) feeDue,
                        sum(cllease__Tax_Due__c) taxDue
                   FROM cllease__Charge__c
                   WHERE cllease__Waive__c = True and cllease__Lease_Account__c in :contractIds
                   GROUP BY cllease__Lease_Account__c];
        for(AggregateResult charge : charges) {
            ContractDetail detail = contractDetails.get((Id)charge.get('cllease__Lease_Account__c'));
            detail.waviedCharge = (Decimal)charge.get('feeDue');
            System.debug(LoggingLevel.ERROR, '***detail.waviedCharge : ' + detail.waviedCharge);
        }
        
        System.debug(LoggingLevel.ERROR, '***charges : ' + charges);
        //query payment schedule for lease receivable
        List<cllease__Payment_Schedule__c> paymentSchedule = [SELECT Id, Name,
                                                        cllease__Contract__c,
                                                        cllease__Payment_Amount__c,
                                                        cllease__Number_Of_Payments__c,
                                                        cllease__Total_Payment__c
                                                FROM cllease__Payment_Schedule__c
                                                WHERE cllease__Primary_Flag__c = true
                                                    AND cllease__Contract__c in :contractIds];
        System.debug(LoggingLevel.ERROR, '***paymentSchedule : ' + paymentSchedule);
        for(cllease__Payment_Schedule__c schedule : paymentSchedule) {
            ContractDetail detail = contractDetails.get(schedule.cllease__Contract__c);
            detail.futureLeaseReceivable += (schedule.cllease__Payment_Amount__c * schedule.cllease__Number_Of_Payments__c);
            detail.totalRentReceivable += (schedule.cllease__Total_Payment__c * schedule.cllease__Number_Of_Payments__c);
            System.debug(LoggingLevel.ERROR, '***detail.futureLeaseReceivable : ' + detail.futureLeaseReceivable);
            System.debug(LoggingLevel.ERROR, '***detail.totalRentReceivable : ' + detail.totalRentReceivable);
        }                                            
        //query income stream
        List<AggregateResult> totalIncome = [SELECT cllease__Contract__c, 
                                            sum(cllease__Lease_Income__c) totalIncome
                                        FROM cllease__Rental_Stream__c
                                        WHERE cllease__Active__c = true
                                            AND cllease__Contract__c in :contractIds
                                        GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalIncome : ' + totalIncome);
        for(AggregateResult income : totalIncome) {
            ContractDetail detail = contractDetails.get((Id)income.get('cllease__Contract__c'));
            detail.totalUnearnedIncome = (Decimal)income.get('totalIncome');
            System.debug(LoggingLevel.ERROR, '***detail.totalUnearnedIncome : ' + detail.totalUnearnedIncome);
            //System.debug(LoggingLevel.ERROR, '***detail.receivablePaid : ' + detail.totalRentReceivable);
        }
        //query income stream for accrued income
        List<AggregateResult> totalAccruedIncome = [SELECT cllease__Contract__c, 
                                                        sum(cllease__Lease_Income__c) totalIncome
                                                    FROM cllease__Rental_Stream__c
                                                    WHERE cllease__Active__c = true
                                                        AND cllease__Accrued_Flag__c = true
                                                        AND cllease__Contract__c in :contractIds
                                                    GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalAccruedIncome : ' + totalAccruedIncome);
        for(AggregateResult income : totalAccruedIncome) {
            ContractDetail detail = contractDetails.get((Id)income.get('cllease__Contract__c'));
            detail.totalAccruedIncome = (Decimal)income.get('totalIncome');
            System.debug(LoggingLevel.ERROR, '***detail.totalAccruedIncome : ' + detail.totalAccruedIncome);
        }
        //query residual stream 
        List<AggregateResult> totalUnearnedResidual = [SELECT cllease__Contract__c, 
                                                        sum(cllease__Residual_Income__c) totalIncome
                                                    FROM cllease__Residual_Stream__c
                                                    WHERE cllease__Active__c = true
                                                        AND cllease__Contract__c in :contractIds
                                                    GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalUnearnedResidual : ' + totalUnearnedResidual);
        for(AggregateResult income : totalUnearnedResidual) {
            ContractDetail detail = contractDetails.get((Id)income.get('cllease__Contract__c'));
            detail.totalUnearnedResidual = (Decimal)income.get('totalIncome');
            System.debug(LoggingLevel.ERROR, '***detail.totalUnearnedResidual : ' + detail.totalUnearnedResidual);
        }
        //query residual stream for accrued income
        List<AggregateResult> totalAccruedResidual = [SELECT cllease__Contract__c, 
                                                        sum(cllease__Residual_Income__c) totalIncome
                                                    FROM cllease__Residual_Stream__c
                                                    WHERE cllease__Active__c = true
                                                        AND cllease__Accrued_Flag__c = true
                                                        AND cllease__Contract__c in :contractIds
                                                    GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalAccruedResidual : ' + totalAccruedResidual);
        for(AggregateResult income : totalAccruedResidual) {
            ContractDetail detail = contractDetails.get((Id)income.get('cllease__Contract__c'));
            detail.totalAccruedResidual = (Decimal)income.get('totalIncome');
            System.debug(LoggingLevel.ERROR, '***detail.totalAccruedResidual : ' + detail.totalAccruedResidual);
        }
        //query IDC Stream
        List<AggregateResult> totalIDCExpense = [SELECT cllease__Contract__c, 
                                                        sum(cllease__Expense_Initial_Direct_Cost__c) totalExpense
                                                    FROM cllease__Initial_Direct_Cost_Stream__c
                                                    WHERE cllease__Active__c = true
                                                        AND cllease__Contract__c in :contractIds
                                                    GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalIDCExpense : ' + totalIDCExpense);
        for(AggregateResult income : totalIDCExpense) {
            ContractDetail detail = contractDetails.get((Id)income.get('cllease__Contract__c'));
            detail.totalIDCExpense = (Decimal)income.get('totalExpense');
            System.debug(LoggingLevel.ERROR, '***detail.totalIDCExpense : ' + detail.totalIDCExpense);
        }
        //query residual stream for accrued income
        List<AggregateResult> totalAccruedIDC = [SELECT cllease__Contract__c, 
                                                        sum(cllease__Expense_Initial_Direct_Cost__c) totalExpense
                                                    FROM cllease__Initial_Direct_Cost_Stream__c
                                                    WHERE cllease__Active__c = true
                                                        AND cllease__Accrued_Flag__c = true
                                                        AND cllease__Contract__c in :contractIds
                                                    GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalAccruedIDC : ' + totalAccruedIDC);
        for(AggregateResult income : totalAccruedIDC) {
            ContractDetail detail = contractDetails.get((Id)income.get('cllease__Contract__c'));
            detail.totalAccruedIDC = (Decimal)income.get('totalExpense');
            System.debug(LoggingLevel.ERROR, '***detail.totalAccruedIDC : ' + detail.totalAccruedIDC);
        }
        //Query payment stream for evergreen rent receivable
        List<AggregateResult> totalEvergreenReceivable = [SELECT cllease__Contract__c, 
                                                            sum(cllease__Rental_Amount__c) totalRent
                                                        FROM cllease__Payment_Stream__c
                                                        WHERE cllease__Active__c = true
                                                            AND cllease__Payment_Type__c = 'EVERGREEN RENT'
                                                            AND cllease__Contract__c in :contractIds
                                                        GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalEvergreenReceivable : ' + totalEvergreenReceivable);
        for(AggregateResult rent : totalEvergreenReceivable) {
            ContractDetail detail = contractDetails.get((Id)rent.get('cllease__Contract__c'));
            detail.futureEvergreenLeaseReceivable = (Decimal)rent.get('totalRent');
            System.debug(LoggingLevel.ERROR, '***detail.futureEvergreenLeaseReceivable : ' + detail.futureEvergreenLeaseReceivable);
        }
        //query Rent Accrual stream for accrued rent 
        List<AggregateResult> totalAccruedRent = [SELECT cllease__Contract__c, 
                                                            sum(cllease__Rental_Accrual__c) totalRent
                                                        FROM cllease__Rental_Accrual_Stream1__c
                                                        WHERE cllease__Active__c = true
                                                            AND cllease__Accrued__c = true
                                                            AND cllease__Contract__c in :contractIds
                                                        GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalAccruedRent : ' + totalAccruedRent);
        for(AggregateResult rent : totalAccruedRent) {
            try{
                ContractDetail detail = contractDetails.get((Id)rent.get('cllease__Contract__c'));
                detail.totalAccruedRent = (Decimal)rent.get('totalRent');
                System.debug(LoggingLevel.ERROR, '***detail.totalAccruedRent : ' + detail.totalAccruedRent);
            }
            catch(Exception e){
                System.debug(LoggingLevel.ERROR, '***Exception : ' + e);
            }
        }
        //query dep stream for accrued amount
        List<AggregateResult> totalAccruedDep = [SELECT cllease__Contract__c, 
                                                            sum(cllease__Dep_Expense__c) totalDepExpense
                                                        FROM cllease__Dep_Streams__c
                                                        WHERE cllease__Active__c = true
                                                            AND cllease__Accrued__c = true
                                                            AND cllease__Contract__c in :contractIds
                                                        GROUP BY cllease__Contract__c];
        System.debug(LoggingLevel.ERROR, '***totalAccruedDep : ' + totalAccruedDep);
        for(AggregateResult rent : totalAccruedDep) {
            ContractDetail detail = contractDetails.get((Id)rent.get('cllease__Contract__c'));
            detail.totalAccruedDep = (Decimal)rent.get('totalDepExpense');
            System.debug(LoggingLevel.ERROR, '***detail.totalAccruedDep : ' + detail.totalAccruedDep);
        }
        List<cllease__Cash_Account_Balance__c> cashBalances = [SELECT Id, Name,
                                                            cllease__Opening_Balance_Amount__c,
                                                            cllease__Paid_Amount__c,
                                                            cllease__Posted_Amount__c,
                                                            cllease__Waived_Amount__c,
                                                            cllease__Contract__c,
                                                            cllease__Closing_Balance_Amount__c,
                                                            cllease__Balance_Type__c
                                                        FROM cllease__Cash_Account_Balance__c
                                                        WHERE cllease__Contract__c in :contractIds];
        //System.debug(LoggingLevel.ERROR, '***cashBal : ' + cashBalances);
        
        List<cllease__Non_Cash_Account_Balance__c> nonCashBalances = [SELECT Id, Name,
                                                                cllease__Balance_Type__c,
                                                                cllease__Closing_Balance_Amount__c,
                                                                cllease__Contract__c,
                                                                cllease__Transactions_Amount__c,
                                                                cllease__Opening_Balance_Amount__c
                                                            FROM cllease__Non_Cash_Account_Balance__c
                                                            WHERE cllease__Contract__c in :contractIds];
        //System.debug(LoggingLevel.ERROR, '***nonCashBalances : ' + nonCashBalances);
        for(cllease__Cash_Account_Balance__c cashBal : cashBalances) {        
            ContractDetail detail = contractDetails.get(cashBal.cllease__Contract__c);
            detail.cashBalancesByType.put(cashBal.cllease__Balance_Type__c.toUpperCase(), cashBal);
        }
        System.debug(LoggingLevel.ERROR, '***cashBalances : ' + cashBalances);
        for(cllease__Non_Cash_Account_Balance__c nonCashBal : nonCashBalances) {        
            ContractDetail detail = contractDetails.get(nonCashBal.cllease__Contract__c);
            detail.nonCashBalancesByType.put(nonCashBal.cllease__Balance_Type__c.toUpperCase(), nonCashBal);
        }
        System.debug(LoggingLevel.ERROR, '***nonCashBalances : ' + nonCashBalances);
        //process contracts
        for(Id contractId : contractDetails.keySet()) {
            ContractDetail detail = contractDetails.get(contractId);
            //for every account balance check if it is present in product and in contract
            //process lease receivable 
            if(detail.cashBalances.contains(cllease.LendingConstants.CASH_ACC_BAL_TYPE_LEASE_RECEIVABLE) 
                    && detail.cashBalancesByType.containsKey(cllease.LendingConstants.CASH_ACC_BAL_TYPE_LEASE_RECEIVABLE.toUpperCase())) {
                cllease__Cash_Account_Balance__c leaseRec = detail.cashBalancesByType.get(cllease.LendingConstants.CASH_ACC_BAL_TYPE_LEASE_RECEIVABLE.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = 0;
                leaseRec.cllease__Posted_Amount__c = detail.receivableBilled;
                leaseRec.cllease__Paid_Amount__c = detail.receivablePaid;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.receivableBilled - detail.receivablePaid;
                System.debug(LoggingLevel.ERROR, '***leaseRec lease receivable : ' + leaseRec);
                cashBalancesToUpdate.add(leaseRec);
            }
            //process tax
            if(detail.cashBalances.contains(cllease.LendingConstants.CASH_ACC_BAL_TYPE_TAX) 
                    && detail.cashBalancesByType.containsKey(cllease.LendingConstants.CASH_ACC_BAL_TYPE_TAX.toUpperCase())) {
                cllease__Cash_Account_Balance__c leaseRec = detail.cashBalancesByType.get(cllease.LendingConstants.CASH_ACC_BAL_TYPE_TAX.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = 0;
                leaseRec.cllease__Posted_Amount__c = detail.taxBilled;
                leaseRec.cllease__Paid_Amount__c = detail.taxPaid;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.taxBilled - detail.taxPaid;
                System.debug(LoggingLevel.ERROR, '***leaseRec Tax : ' + leaseRec);
                cashBalancesToUpdate.add(leaseRec);
            }
            /*else if(detail.cashBalances.contains(cllease.LendingConstants.CASH_ACC_BAL_TYPE_TAX) && detail.taxBilled == 0){
                cllease__Cash_Account_Balance__c leaseRec = detail.cashBalancesByType.get(cllease.LendingConstants.CASH_ACC_BAL_TYPE_TAX.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = 0;
                leaseRec.cllease__Posted_Amount__c = 0;
                leaseRec.cllease__Paid_Amount__c = 0;
                leaseRec.cllease__Closing_Balance_Amount__c = 0;
                System.debug(LoggingLevel.ERROR, '***leaseRec Tax : ' + leaseRec);
                cashBalancesToUpdate.add(leaseRec);
            }*/
            //process evergreen lease receivable 
            if(detail.cashBalances.contains(cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE) 
                    && detail.cashBalancesByType.containsKey(cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE.toUpperCase())) {
                cllease__Cash_Account_Balance__c leaseRec = detail.cashBalancesByType.get(cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = 0;
                leaseRec.cllease__Posted_Amount__c = detail.evergreenReceivableBilled;
                leaseRec.cllease__Paid_Amount__c = detail.evergreenReceivablePaid;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.evergreenReceivableBilled - detail.evergreenReceivablePaid;
                System.debug(LoggingLevel.ERROR, '***leaseRec evergreen lease receivable : ' + leaseRec);
                cashBalancesToUpdate.add(leaseRec);
            }
            //process fees
            if(detail.cashBalances.contains(cllease.LendingConstants.CASH_ACC_BAL_TYPE_FEES) 
                    && detail.cashBalancesByType.containsKey(cllease.LendingConstants.CASH_ACC_BAL_TYPE_FEES.toUpperCase())) {
                cllease__Cash_Account_Balance__c leaseRec = detail.cashBalancesByType.get(cllease.LendingConstants.CASH_ACC_BAL_TYPE_FEES.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = 0;
                leaseRec.cllease__Posted_Amount__c = detail.chargesBilled;
                leaseRec.cllease__Paid_Amount__c = detail.chargesPaid;
                leaseRec.cllease__Waived_Amount__c = detail.waviedCharge;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.chargesBilled - detail.chargesPaid - detail.waviedCharge;
                System.debug(LoggingLevel.ERROR, '***leaseRec fees : ' + leaseRec);
                cashBalancesToUpdate.add(leaseRec);
            }
            //non cash balances
            //future lease receivable
            if(detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = detail.futureLeaseReceivable;
                leaseRec.cllease__Transactions_Amount__c = detail.receivableBilled;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.futureLeaseReceivable - detail.receivableBilled;
                System.debug(LoggingLevel.ERROR, '***leaseRec future lease receivable : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            
            //unearned income
            if(detail.type == cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE
                    && detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = detail.totalUnearnedIncome;
                leaseRec.cllease__Transactions_Amount__c = detail.totalAccruedIncome;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.totalUnearnedIncome - detail.totalAccruedIncome;
                System.debug(LoggingLevel.ERROR, '***leaseRec unearned income : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            //unearned residual
            if(detail.type == cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE
                    && detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL.toUpperCase());
                leaseRec.cllease__Opening_Balance_Amount__c = detail.totalUnearnedResidual;
                leaseRec.cllease__Transactions_Amount__c = detail.totalAccruedResidual;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.totalUnearnedResidual - detail.totalAccruedResidual;
                System.debug(LoggingLevel.ERROR, '***leaseRec unearned residual : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            //residual receivable
            if(detail.type == cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE
                    && detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE.toUpperCase());
                if(detail.contract.cllease__Residual_Amount__c == null) {
                    detail.contract.cllease__Residual_Amount__c = 0;
                }
                leaseRec.cllease__Opening_Balance_Amount__c = detail.contract.cllease__Residual_Amount__c;
                leaseRec.cllease__Transactions_Amount__c = 0;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.contract.cllease__Residual_Amount__c;
                System.debug(LoggingLevel.ERROR, '***leaseRec residual receivable : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            //IDC accrual 
            if(detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL.toUpperCase());                
                leaseRec.cllease__Opening_Balance_Amount__c = detail.totalIDCExpense;
                leaseRec.cllease__Transactions_Amount__c = detail.totalAccruedIDC;
                detail.contract.cllease__Initial_Direct_Cost_Amount1__c = detail.contract.cllease__Initial_Direct_Cost_Amount1__c == null ? 0 : detail.contract.cllease__Initial_Direct_Cost_Amount1__c;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.contract.cllease__Initial_Direct_Cost_Amount1__c; 
                System.debug(LoggingLevel.ERROR, '***leaseRec IDC accrual : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            
            //IDC 
            if(detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_IDC) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_IDC.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_IDC.toUpperCase());
                detail.contract.cllease__Initial_Direct_Cost_Amount1__c = detail.contract.cllease__Initial_Direct_Cost_Amount1__c == null ? 0 : detail.contract.cllease__Initial_Direct_Cost_Amount1__c;
                leaseRec.cllease__Opening_Balance_Amount__c = detail.contract.cllease__Initial_Direct_Cost_Amount1__c;
                leaseRec.cllease__Transactions_Amount__c = 0;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.contract.cllease__Initial_Direct_Cost_Amount1__c;
                System.debug(LoggingLevel.ERROR, '***leaseRec IDC : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            //evergreen receivable
            if(detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE.toUpperCase());                
                leaseRec.cllease__Opening_Balance_Amount__c = detail.futureEvergreenLeaseReceivable;
                leaseRec.cllease__Transactions_Amount__c = detail.evergreenReceivableBilled;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.futureEvergreenLeaseReceivable - detail.evergreenReceivableBilled;
                System.debug(LoggingLevel.ERROR, '***leaseRec evergreen receivable : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            //Rental Accrual (operating lease)
            if(detail.type == cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE
                    && detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_RENTAL_ACCRUAL) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_RENTAL_ACCRUAL.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_RENTAL_ACCRUAL.toUpperCase());                
                leaseRec.cllease__Opening_Balance_Amount__c = detail.totalRentReceivable;
                leaseRec.cllease__Transactions_Amount__c = detail.totalAccruedRent;
                leaseRec.cllease__Closing_Balance_Amount__c = detail.totalRentReceivable - detail.totalAccruedRent;
                System.debug(LoggingLevel.ERROR, '***leaseRec Rental Accrual : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
            //Dep Accrual (operating lease)
            if(detail.type == cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE
                    && detail.nonCashBalances.contains(cllease.LendingConstants.LEASE_NONCASHBAL_DEPR_ACCRUAL) 
                    && detail.nonCashBalancesByType.containsKey(cllease.LendingConstants.LEASE_NONCASHBAL_DEPR_ACCRUAL.toUpperCase())) {
                cllease__Non_Cash_Account_Balance__c leaseRec = detail.nonCashBalancesByType.get(cllease.LendingConstants.LEASE_NONCASHBAL_DEPR_ACCRUAL.toUpperCase());                
                if(detail.contract.cllease__Residual_Amount__c == null) {
                    detail.contract.cllease__Residual_Amount__c = 0;
                }
                leaseRec.cllease__Opening_Balance_Amount__c = detail.contract.cllease__Financed_Amount__c - detail.contract.cllease__Residual_Amount__c;
                leaseRec.cllease__Transactions_Amount__c = detail.totalAccruedDep;
                leaseRec.cllease__Closing_Balance_Amount__c = leaseRec.cllease__Opening_Balance_Amount__c - leaseRec.cllease__Transactions_Amount__c;
                System.debug(LoggingLevel.ERROR, '***leaseRec Dep Accrual : ' + leaseRec);
                nonCashBalancesToUpdate.add(leaseRec);
            }
        }
        System.debug(LoggingLevel.ERROR, '*** nonCashBalancesToUpdate : ' + nonCashBalancesToUpdate);
        System.debug(LoggingLevel.ERROR, '*** cashBalancesToUpdate : ' + cashBalancesToUpdate);
        if(nonCashBalancesToUpdate.size() > 0) {
            System.debug(LoggingLevel.ERROR, '*** nonCashBalancesToUpdate : ' + nonCashBalancesToUpdate);
            update nonCashBalancesToUpdate;
        }
        if(cashBalancesToUpdate.size() > 0) {
            update cashBalancesToUpdate;
            System.debug(LoggingLevel.ERROR, '*** cashBalancesToUpdate : ' + cashBalancesToUpdate);
        }
    }    
    
    private class ContractDetail {
        cllease__Lease_Account__c contract;
        Set<String> cashBalances = new Set<String>();
        Set<String> nonCashBalances = new Set<String>();
        //Operating or finance lease
        String type;
        Map<String, cllease__Cash_Account_Balance__c> cashBalancesByType = new Map<String, cllease__Cash_Account_Balance__c>();
        Map<String, cllease__Non_Cash_Account_Balance__c> nonCashBalancesByType = new Map<String, cllease__Non_Cash_Account_Balance__c>();
        //List<cllease__Cash_Account_Balance__c> cashBalancesToUpdate = new List<cllease__Cash_Account_Balance__c>();
        //List<cllease__Non_Cash_Account_Balance__c> nonCashBalancesToUpdate = new List<cllease__Non_Cash_Account_Balance__c>();
        Decimal receivableBilled = 0;
        Decimal receivablePaid = 0;
        Decimal evergreenReceivableBilled = 0;
        Decimal evergreenReceivablePaid = 0;
        Decimal taxBilled = 0;
        Decimal taxPaid = 0;
        Decimal chargesBilled = 0;
        Decimal chargesPaid = 0;
        Decimal waviedCharge = 0;
        Decimal futureLeaseReceivable = 0;
        Decimal futureEvergreenLeaseReceivable = 0;
        Decimal totalUnearnedIncome = 0;
        Decimal totalAccruedIncome = 0;
        Decimal totalUnearnedResidual = 0;
        Decimal totalAccruedResidual = 0;
        Decimal totalIDCExpense = 0;
        Decimal totalAccruedIDC = 0;
        Decimal totalRentReceivable = 0;
        Decimal totalAccruedRent = 0; 
        Decimal totalAccruedDep = 0;
    }

}