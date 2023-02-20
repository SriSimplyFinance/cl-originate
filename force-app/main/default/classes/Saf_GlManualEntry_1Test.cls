@isTest(SeeAllData=True)
private class Saf_GlManualEntry_1Test{
        static testmethod void test1() {        
        cllease.TestHelper.createSeedDataForTesting();
     
        test.startTest();
        
        testdata();

        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<cllease__GL_Transaction_Detail__c> lstTypes = new List<cllease__GL_Transaction_Detail__c>();
      
        //string query='select id,cllease__Contract__r.cllease__Excess__c,cllease__Lease_Account__c.cllease__Amount_to_Current__c,cllease__Lease_Income__c,cllease__Capital_Recovery__c,cllease__Contract__r.Future_Rentals__c,cllease__Contract__r.Unearned_Interest__c,cllease__Ending_Net_Investment__c,cllease__Contract__r.cllease__Account__r.SAF_Exposure_Agreements__c,cllease__Contract__r.cllease__Account__c,cllease__Contract__c,cllease__Contract__r.cllease__Delinquent_Amount__c, cllease__Contract__r.cllease__Lease_Status__c, cllease__Beginning_Net_Investment__c,cllease__Date__c from cllease__Rental_Stream__c where (cllease__Contract__c != null and (cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - GOOD STANDING\' or cllease__Contract__r.cllease__Lease_Status__c = \'ACTIVE - BAD STANDING\' ) and cllease__Date__c >=: mydate and cllease__Date__c <=: mydate1) order by cllease__Contract__c Limit 100';
         String query= 'SELECT cllease__Accrual_Transaction__c,cllease__Billing_Transactions__c,' +
           'cllease__Cash_Receipt_Transaction__c,cllease__Cash_Receipt__c,cllease__Company__c,cllease__Contract__c,'+
           'cllease__Credit_Amount__c,cllease__Credit_GL_Account_Code__c,cllease__Credit_GL_Account__c,cllease__Debit_Amount__c,' +
           'cllease__Debit_GL_Account_Code__c,cllease__Debit_GL_Account__c,cllease__Debt_Schedule__c,cllease__Depreciation_Stream__c,' +
           'cllease__Disbursement_Transaction__c,cllease__Disbursement_Txn__c,cllease__Equipment_Transaction__c,cllease__Equipment__c,' +
           'cllease__Expense_Fee_Transaction__c,cllease__Exported_Date__c,cllease__Exported_Flag__c,cllease__Generation_Scheme__c,' +
           'cllease__GL_Batch_Post_Date__c,cllease__GL_Date__c,cllease__Item_Id__c,cllease__Item_Name__c,cllease__LeaseApplicationNumber__c,' +
           'cllease__Lease_Accrual_Transaction__c,cllease__Lease_Payment_Detail__c,cllease__Other_Transactions__c,' +
           'cllease__Payment_Transaction_Reversal__c,cllease__Payment_Transaction__c,cllease__Reversal_Processed__c,cllease__Transaction_Description__c,' +
           'cllease__Transaction_type1__c,saf_Transaction_Type2__c,cllease__Transaction_Type__c,CreatedById,CreatedDate,Id,LastModifiedDate,' +
           'cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Payment_Transaction__r.cllease__Cheque_Number__c,' +
            'cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Cheque_Number__c,' +
           'cllease__Contract__r.Pre_Fund_Offer_Date__c,cllease__Contract__r.Funder_1_Acceptance_Date__c,cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c,cllease__Contract__r.X1_BBB_Enable_Repurchase_Date__c,' +
           'cllease__Contract__r.Funder_2_Acceptance_Date__c ,cllease__Contract__r.Funder_2__c,cllease__Contract__r.X2_BBB_Enable_Repurchase_Date__c,' +
           'Name,cllease__Contract__r.cllease__Lease_Product_Name__c,Saf_Manual_GL_Entry_created__c,cllease__Charge__c,cllease__Contract__r.Funder__c,' +
           'cllease__Contract__r.X3_BBB_Enable_Repurchase_Date__c,cllease__Contract__r.Funder_3__c,cllease__Contract__r.Funder_3_Acceptance_Date__c,' +
           'Transaction_Date__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c WHERE Saf_Manual_GL_Entry_created__c = false Limit 1';// where cllease__Lease_Status__c NOT IN :strStatus';
        
        Saf_GlManualEntry_1 ER = new  Saf_GlManualEntry_1();
        ER.getRuntimeQuery();
        ER.doInitialize();
        ER.doStart(bc);
        QL = Database.getQueryLocator(query);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            cllease__GL_Transaction_Detail__c objType = (cllease__GL_Transaction_Detail__c)QIT.next();           
            System.debug('cllease__GL_Transaction_Detail__c :'+objType);
            lstTypes.add(objType);
        }  
        
        system.debug('List of gl enetry'+lstTypes);     
        try{
            ER.doexecute(BC,lstTypes);
            ER.finish(BC); 
        }
        catch(Exception e){
        system.debug('Error: '  + e.getmessage());
        
        }
        //ER.finish(BC); 
        
        test.stopTest();
        
       
    }
       static testmethod void test2() {        
        cllease.TestHelper.createSeedDataForTesting();
         
        cllease__GL_Transaction_Detail__c  objgltxn = testdata();
        objGlTxn.saf_manualGl_Reversed__c  = false;
        objGlTxn.Saf_Manual_GL_Entry_created__c = false;
        cllease__Lease_Trx_Lines__c obj = new cllease__Lease_Trx_Lines__c();
        objGlTxn.cllease__Lease_Accrual_Transaction__c = obj.Id;
        update objGlTxn; 
        
        
        test.startTest();
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<cllease__GL_Transaction_Detail__c> lstTypes = new List<cllease__GL_Transaction_Detail__c>();
        String query= 'SELECT Id,Name,saf_manualGl_Reversed__c,saf_Transaction_Type2__c,Saf_Manual_GL_Entry_created__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c WHERE Saf_Manual_GL_Entry_created__c = false Limit 1';// where cllease__Lease_Status__c NOT IN :strStatus';
        
        Saf_GlManualEntry_1 ER = new  Saf_GlManualEntry_1();
        ER.getRuntimeQuery();
        ER.doInitialize();
        ER.doStart(bc);
        QL = Database.getQueryLocator(query);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        System.debug('Query Locator'+QIT);
        while (QIT.hasNext())
        {
            cllease__GL_Transaction_Detail__c objType = (cllease__GL_Transaction_Detail__c)QIT.next();           
            System.debug('cllease__GL_Transaction_Detail__c :'+objType);
            lstTypes.add(objType);
        }  
        
        system.debug('List of gl enetry'+lstTypes);     
        try{
            ER.doexecute(BC,lstTypes);
            ER.finish(BC); 
        }
        catch(Exception e){
        system.debug('Error: '  + e.getmessage());
        
        }
        //ER.finish(BC); 
     
        test.stopTest();
        
       
    }
    static testmethod cllease__GL_Transaction_Detail__c testdata() {  
    
           
           cllease__GL_Transaction_Detail__c objhp =  [SELECT cllease__Accrual_Transaction__c,cllease__Billing_Transactions__c,cllease__Cash_Receipt_Transaction__c,cllease__Cash_Receipt__c,cllease__Company__c,cllease__Contract__c,
           cllease__Credit_Amount__c,cllease__Credit_GL_Account_Code__c,cllease__Credit_GL_Account__c,cllease__Debit_Amount__c, 
           cllease__Debit_GL_Account_Code__c,cllease__Debit_GL_Account__c,cllease__Debt_Schedule__c,cllease__Depreciation_Stream__c, 
           cllease__Disbursement_Transaction__c,cllease__Disbursement_Txn__c,cllease__Equipment_Transaction__c,cllease__Equipment__c, 
           cllease__Expense_Fee_Transaction__c,cllease__Exported_Date__c,cllease__Exported_Flag__c,cllease__Generation_Scheme__c, 
           cllease__GL_Batch_Post_Date__c,cllease__GL_Date__c,cllease__Item_Id__c,cllease__Item_Name__c,cllease__LeaseApplicationNumber__c, 
           cllease__Lease_Accrual_Transaction__c,cllease__Lease_Payment_Detail__c,cllease__Other_Transactions__c, 
           cllease__Payment_Transaction_Reversal__c,cllease__Payment_Transaction__c,cllease__Reversal_Processed__c,cllease__Transaction_Description__c, 
           cllease__Transaction_type1__c,saf_Transaction_Type2__c,cllease__Transaction_Type__c,CreatedById,CreatedDate,Id,LastModifiedDate, 
           cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Payment_Transaction__r.cllease__Cheque_Number__c, 
            cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Cheque_Number__c, 
           cllease__Contract__r.Pre_Fund_Offer_Date__c,cllease__Contract__r.Funder_1_Acceptance_Date__c,cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c,cllease__Contract__r.X1_BBB_Enable_Repurchase_Date__c, 
           cllease__Contract__r.Funder_2_Acceptance_Date__c ,cllease__Contract__r.Funder_2__c,cllease__Contract__r.X2_BBB_Enable_Repurchase_Date__c, 
           Name,cllease__Contract__r.cllease__Lease_Product_Name__c,Saf_Manual_GL_Entry_created__c,cllease__Charge__c,cllease__Contract__r.Funder__c, 
           cllease__Contract__r.X3_BBB_Enable_Repurchase_Date__c,cllease__Contract__r.Funder_3__c,cllease__Contract__r.Funder_3_Acceptance_Date__c, 
           Transaction_Date__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c Limit 1];
       
    
         objhp.saf_manualGl_Reversed__c  = false;
         objhp.Saf_Manual_GL_Entry_created__c = false;
         cllease__Lease_Trx_Lines__c obj = new cllease__Lease_Trx_Lines__c();
        objhp.cllease__Lease_Accrual_Transaction__c = obj.Id;
        
         update objhp;
       Map<string,string> mapproduct = new  Map<string,string>();  
       for(cllease__Lease_Product__c objprod :[select Id,Name,cllease__Status__c from cllease__Lease_Product__c where cllease__Status__c =: 'Active'])
                  {
                      mapproduct.put(objprod.Id,objprod.Name);
                  }    
         
                        Manual_GL__c objDebit = new Manual_GL__c();
                        objDebit.GL_Account_Type__c = 'Debit';
                        objDebit.MN_Accrual_Transaction__c = objhp.cllease__Accrual_Transaction__c;
                       
                        objDebit.MN_Generation_Scheme__c = objhp.cllease__Generation_Scheme__c;
                         // negative for reversal
                       objDebit.MN_Amount__c= objhp.cllease__Debit_Amount__c * -1;
                       objDebit.MN_Billing_Transaction__c = objhp.cllease__Billing_Transactions__c;
                       objDebit.saf_Product__c = mapproduct.get(objhp.cllease__Contract__r.cllease__Lease_Product_Name__c); 
                      
                       objDebit.MN_Cash_Receipt_Transaction__c = objhp.cllease__Cash_Receipt_Transaction__c;
                       objDebit.MN_Cash_Receipt__c = objhp.cllease__Cash_Receipt__c;
                       objDebit.MN_Charge__c = objhp.cllease__Charge__c;
                       objDebit.MN_Company__c = objhp.cllease__Company__c;
                       objDebit.MN_Contract__c = objhp.cllease__Contract__c;
                       objDebit.MN_Debt_Schedule__c = objhp.cllease__Debt_Schedule__c; 
                       
                       objDebit.MN_Depreciation_Stream__c = objhp.cllease__Depreciation_Stream__c;
                       objDebit.MN_Disbursement_Txn__c = objhp.cllease__Disbursement_Txn__c;
                       objDebit.MN_Equipment__c = objhp.cllease__Equipment__c;
                       objDebit.MN_Expense_Fee_Transaction__c= objhp.cllease__Expense_Fee_Transaction__c;                
                         objDebit.MN_Equipment_Transaction__c = objhp.cllease__Equipment_Transaction__c; 
                         
                       objDebit.MN_Exported_Date__c = objhp.cllease__Exported_Date__c;
                       objDebit.MN_Exported_Flag__c = objhp.cllease__Exported_Flag__c;
                       objDebit.MN_GL_Account__c = objhp.cllease__Debit_GL_Account__c;
                       objDebit.MN_GL_Batch_Post_Date__c = objhp.cllease__GL_Batch_Post_Date__c;
                       objDebit.MN_GL_Date__c=  objhp.cllease__GL_Date__c;      
                       
                       objDebit.MN_Item_Id__c = objhp.cllease__Item_Id__c;
                       objDebit.MN_Item_Name__c = objhp.cllease__Item_Name__c;
                      
                       objDebit.MN_Transaction_Description__c = objhp.cllease__Transaction_Description__c.substringAfter(' - ');            
                        objDebit.MN_Lease_Payment_Detail__c = objhp.cllease__Lease_Payment_Detail__c;
                       objDebit.MN_Payment_Transaction__c = objhp.cllease__Payment_Transaction__c;
                       objDebit.Saf_Payment_Mode__c = objhp.cllease__Payment_Transaction__r.cllease__Payment_Mode__c;
                       objDebit.saf_Payment_Reference__c =   objhp.cllease__Payment_Transaction__r.cllease__Cheque_Number__c;
                      
                       if(objhp.cllease__Payment_Transaction__c == null && objhp.cllease__Lease_Payment_Detail__c !=null)
                       {     
                             objDebit.MN_Payment_Transaction__c = objhp.cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__c;
                             objDebit.Saf_Payment_Mode__c = objhp.cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Payment_Mode__c;
                             objDebit.saf_Payment_Reference__c =   objhp.cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Cheque_Number__c;
                       }
                       
                       objDebit.MN_Transaction_Type__c = objhp.cllease__Transaction_Type__c;
                       objDebit.MN_Item_Name__c = objhp.cllease__Item_Name__c;
                       objDebit.Reversal_Processed__c = objhp.cllease__Reversal_Processed__c;
                       objDebit.Saf_GL_Accounting_Entries__c = objhp.Id;
                       objDebit.saf_Reference__c =  'System Generated';      
                       //objDebit.saf_Funder1__c  = objmn.saf_Funder1__c ;
                      
                       objDebit.MN_Other_Transactions__c =   objhp.cllease__Other_Transactions__c;
                       insert objDebit;
    return objhp;
    }
}