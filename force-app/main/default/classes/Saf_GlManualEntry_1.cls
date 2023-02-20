/**
*
* @name                 : Saf_GlManualEntry_1 
* @author               : Happiest minds 
* @description          : This Batch class is used to create manual Gl entries
* @created date         : 18-02-2020
* @modified by / date   : 18-02-2020
*
**/


global class Saf_GlManualEntry_1 extends cllease.LeaseDynamicJob{

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
    
     global static String NAME = 'Saf_GlManualEntry_1';
     //global static String query; 
     global static Integer LimitQuery =2; 
     public class MyException extends Exception{} 
     global Integer recordsProcessed = 0;  
   
    global Saf_GlManualEntry_1()
    {   
       super(NAME,buildquery());
    }  
     global override void doInitialize()
    {}
    
     global override string getRuntimeQuery()
    { 
        
        string query = 'SELECT cllease__Accrual_Transaction__c,cllease__Billing_Transactions__c,' +
           'cllease__Cash_Receipt_Transaction__c,cllease__Cash_Receipt__c,cllease__Company__c,cllease__Contract__c,'+
           'cllease__Credit_Amount__c,cllease__Credit_GL_Account_Code__c,cllease__Credit_GL_Account__c,cllease__Debit_Amount__c,' +
           'cllease__Debit_GL_Account_Code__c,cllease__Debit_GL_Account__c,cllease__Debt_Schedule__c,cllease__Depreciation_Stream__c,' +
           'cllease__Disbursement_Transaction__c,cllease__Disbursement_Txn__c,cllease__Equipment_Transaction__c,cllease__Equipment__c,' +
           'cllease__Expense_Fee_Transaction__c,cllease__Exported_Date__c,cllease__Exported_Flag__c,cllease__Generation_Scheme__c,' +
           'cllease__GL_Batch_Post_Date__c,cllease__GL_Date__c,cllease__Item_Id__c,cllease__Item_Name__c,cllease__LeaseApplicationNumber__c,' +
           'cllease__Lease_Accrual_Transaction__c,cllease__Lease_Payment_Detail__c,cllease__Other_Transactions__c,' +
           'cllease__Payment_Transaction_Reversal__c,cllease__Payment_Transaction__c,cllease__Reversal_Processed__c,cllease__Transaction_Description__c,' +
           'cllease__Transaction_type1__c,cllease__Transaction_Type__c,CreatedById,CreatedDate,Id,LastModifiedDate,' +
           'cllease__Contract__r.Pre_Fund_Offer_Date__c,cllease__Contract__r.Funder_1_Acceptance_Date__c,cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c,cllease__Contract__r.X1_BBB_Enable_Repurchase_Date__c,' +
           'cllease__Contract__r.Funder_2_Acceptance_Date__c ,cllease__Contract__r.Funder_2__c,cllease__Contract__r.X2_BBB_Enable_Repurchase_Date__c,' +
           'Name,cllease__Contract__r.cllease__Lease_Product_Name__c,Saf_Manual_GL_Entry_created__c,cllease__Charge__c,cllease__Contract__r.Funder__c,' +
           'cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Payment_Transaction__r.cllease__Cheque_Number__c,' +
           'cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Cheque_Number__c,' +
            'cllease__Contract__r.X3_BBB_Enable_Repurchase_Date__c,cllease__Contract__r.Funder_3__c,cllease__Contract__r.Funder_3_Acceptance_Date__c,' +
           'Transaction_Date__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c WHERE Saf_Manual_GL_Entry_created__c = false';
           
           system.debug('========= query ========'+query); 
        return query;
    }
     global override void dostart(Database.BatchableContext BC){        
   }
    
      global override void doexecute(Database.BatchableContext BC, list<sobject>scope){
    
         system.debug('******query****'+scope.size());
          Map<string,string> mapproduct = new  Map<string,string>();
         try{
                  for(cllease__Lease_Product__c objprod :[select Id,Name,cllease__Status__c from cllease__Lease_Product__c where cllease__Status__c =: 'Active'])
                  {
                      mapproduct.put(objprod.Id,objprod.Name);
                  }
                  List<cllease__GL_Transaction_Detail__c> lstTxn = scope; 
              
                  List<Manual_GL__c> lst_ManualGLTxn = new  List<Manual_GL__c>();
                   for(cllease__GL_Transaction_Detail__c objhp :lstTxn)
                   {   
                       Manual_GL__c objmn = new Manual_GL__c();
                       objmn.GL_Account_Type__c = 'Credit';
                       objmn.MN_Accrual_Transaction__c = objhp.cllease__Accrual_Transaction__c;
                       objmn.MN_Lease_Accrual_Transaction__c = objhp.cllease__Lease_Accrual_Transaction__c; //Added by Sumit on 15/03/2020
                       objmn.MN_Amount__c= objhp.cllease__Credit_Amount__c *-1;
                       objmn.MN_Billing_Transaction__c = objhp.cllease__Billing_Transactions__c;
                       
                       objmn.MN_Generation_Scheme__c = objhp.cllease__Generation_Scheme__c;
                      
                       objmn.MN_Cash_Receipt_Transaction__c = objhp.cllease__Cash_Receipt_Transaction__c;
                       objmn.MN_Cash_Receipt__c = objhp.cllease__Cash_Receipt__c;
                       objmn.MN_Charge__c = objhp.cllease__Charge__c;
                       objmn.MN_Company__c = objhp.cllease__Company__c;
                       objmn.saf_Product__c = mapproduct.get(objhp.cllease__Contract__r.cllease__Lease_Product_Name__c); 
                       system.debug('========= saf_Product__c ========:' + objmn.saf_Product__c );
                       objmn.MN_Contract__c = objhp.cllease__Contract__c;
                       objmn.MN_Debt_Schedule__c = objhp.cllease__Debt_Schedule__c; 
                       
                       objmn.MN_Depreciation_Stream__c = objhp.cllease__Depreciation_Stream__c;
                       objmn.MN_Disbursement_Txn__c = objhp.cllease__Disbursement_Txn__c;
                       objmn.MN_Equipment__c = objhp.cllease__Equipment__c;
                       objmn.MN_Expense_Fee_Transaction__c= objhp.cllease__Expense_Fee_Transaction__c; 
                       objmn.MN_Equipment_Transaction__c = objhp.cllease__Equipment_Transaction__c;            
                       
                       objmn.MN_Exported_Date__c = objhp.cllease__Exported_Date__c;
                       objmn.MN_Exported_Flag__c = objhp.cllease__Exported_Flag__c;
                       objmn.MN_GL_Account__c = objhp.cllease__Credit_GL_Account__c;
                       objmn.MN_GL_Batch_Post_Date__c = objhp.cllease__GL_Batch_Post_Date__c;
                       objmn.MN_GL_Date__c=  objhp.cllease__GL_Date__c;      
                       
                       objmn.MN_Item_Id__c = objhp.cllease__Item_Id__c;
                       objmn.MN_Item_Name__c = objhp.cllease__Item_Name__c;
                       objmn.MN_Lease_Payment_Detail__c = objhp.cllease__Lease_Payment_Detail__c;
                       objmn.MN_Payment_Transaction__c = objhp.cllease__Payment_Transaction__c;
                        objmn.Saf_Payment_Mode__c = objhp.cllease__Payment_Transaction__r.cllease__Payment_Mode__c;
                       objmn.saf_Payment_Reference__c =   objhp.cllease__Payment_Transaction__r.cllease__Cheque_Number__c;
                       if(objhp.cllease__Payment_Transaction__c == null && objhp.cllease__Lease_Payment_Detail__c !=null)
                       {     
                             objmn.MN_Payment_Transaction__c = objhp.cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__c;
                             objmn.Saf_Payment_Mode__c = objhp.cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Payment_Mode__c;
                             objmn.saf_Payment_Reference__c =   objhp.cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Cheque_Number__c;
                       }
                       objmn.MN_Payment_Transaction_Reversal__c = objhp.cllease__Payment_Transaction_Reversal__c; //Added by Sumit on 15/03/2020
                     
                       objmn.MN_Transaction_Description__c =  objhp.cllease__Transaction_Description__c.substringAfter(' - ');      
                          system.debug('========= MN_Transaction_Description__c========:' + objmn.MN_Transaction_Description__c );     
                       
                       objmn.MN_Transaction_Type__c = objhp.cllease__Transaction_Type__c;
                       objmn.MN_Item_Name__c = objhp.cllease__Item_Name__c;
                       objmn.Reversal_Processed__c = objhp.cllease__Reversal_Processed__c;
                       objmn.Saf_GL_Accounting_Entries__c = objhp.Id;
                       objmn.saf_Reference__c =  'System Generated'; 
                      
                       objmn.MN_Other_Transactions__c =   objhp.cllease__Other_Transactions__c;
                        /*     when LEDGER_DATE < ISNULL(Agreement.Pre_Fund_Offer_Date__c, ISNULL(Agreement.Funder_1_Acceptance_Date__c, GETDATE() ) ) then ''
                   when LEDGER_DATE between Agreement.Pre_Fund_Offer_Date__c and ISNULL(Agreement.Pre_Fund_Ineligible_Repurchase_Date__c, ISNULL(Agreement.Funder_1_Acceptance_Date__c, GETDATE() ) ) then 'BBB (PreFund)'
                   when LEDGER_DATE between Agreement.Pre_Fund_Ineligible_Repurchase_Date__c and Agreement.Funder_1_Acceptance_Date__c then ''
                   when LEDGER_DATE between Agreement.Pre_Fund_Offer_Date__c and ISNULL(Agreement.Funder_1_Acceptance_Date__c, GETDATE() ) then 'BBB (PreFund)'
                   when LEDGER_DATE between Agreement.Funder_1_Acceptance_Date__c and ISNULL(Agreement.[X1_BBB_Enable_Repurchase_Date__c],GETDATE() ) then Agreement.[Funder__c]
                   when LEDGER_DATE between Agreement.Funder_2_Acceptance_Date__c and ISNULL(Agreement.[X2_BBB_Enable_Repurchase_Date__c],GETDATE() ) then Agreement.[Funder_2__c]
                   when LEDGER_DATE between Agreement.Funder_3_Acceptance_Date__c and ISNULL(Agreement.[X3_BBB_Enable_Repurchase_Date__c],GETDATE() ) then Agreement.[Funder_3__c]*/
                      date dt = (objhp.cllease__Contract__r.Pre_Fund_Offer_Date__c == null ? (objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c == null ? date.today() : objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c) : objhp.cllease__Contract__r.Pre_Fund_Offer_Date__c) ;
                      date dt1 = (objhp.cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c == null ? (objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c == null ? date.today() : objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c) : objhp.cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c) ;
                      date dt2 = (objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c == null ? date.today() : objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c) ;
                     date dt3 = (objhp.cllease__Contract__r.X1_BBB_Enable_Repurchase_Date__c == null ? date.today() : objhp.cllease__Contract__r.X1_BBB_Enable_Repurchase_Date__c) ;
                     date dt4 = (objhp.cllease__Contract__r.X2_BBB_Enable_Repurchase_Date__c== null ? date.today() : objhp.cllease__Contract__r.X2_BBB_Enable_Repurchase_Date__c) ;
                     date dt5 = (objhp.cllease__Contract__r.X3_BBB_Enable_Repurchase_Date__c== null ? date.today() : objhp.cllease__Contract__r.X3_BBB_Enable_Repurchase_Date__c) ;
                     date dttoday =  objhp.cllease__GL_Date__c ;
                     if(dttoday < dt) {objmn.saf_Funder1__c  = '';  system.debug( '********first if');}
                      else if (dttoday <= dt1 && dttoday  >= objhp.cllease__Contract__r.Pre_Fund_Offer_Date__c) {objmn.saf_Funder1__c  ='BBB (PreFund)';  system.debug( '********second if' );}
                      else if (dttoday >= objhp.cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c  && dttoday  <= objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c) {objmn.saf_Funder1__c  =''; system.debug( '********third if');}
                      else if (dttoday  >= objhp.cllease__Contract__r.Pre_Fund_Offer_Date__c && dttoday  <= dt2) {objmn.saf_Funder1__c  ='BBB (PreFund)'; system.debug( '********fourth if');}
                      else if (dttoday  >= objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c && dttoday  <= dt3) {objmn.saf_Funder1__c  = objhp.cllease__Contract__r.Funder__c;system.debug( '********fifth if');}
                      else if (dttoday  >= objhp.cllease__Contract__r.Funder_2_Acceptance_Date__c && dttoday  <= dt4) {objmn.saf_Funder1__c  =objhp.cllease__Contract__r.Funder_2__c;system.debug( '********sixth if');}
                      else if (dttoday  >= objhp.cllease__Contract__r.Funder_3_Acceptance_Date__c && dttoday  <= dt5) {objmn.saf_Funder1__c  =objhp.cllease__Contract__r.Funder_3__c;system.debug( '********seventh if');}
                      else {objmn.saf_Funder1__c  =  '';} 
                                       
                      system.debug( '*****dt: '+dt + 'dt1: '+dt1 +'dt2: '+dt2 + 'dt3: + '+dt3 +'dt4: '+dt4);
                      system.debug( '*****objmn.saf_Funder1__c:' + objmn.saf_Funder1__c + 'dttoday :' +dttoday ); 
                      system.debug( '*****Pre_Fund_Offer_Date__c :' + objhp.cllease__Contract__r.Pre_Fund_Offer_Date__c ); 
                      system.debug( '*****Funder_1_Acceptance_Date__c :' + objhp.cllease__Contract__r.Funder_1_Acceptance_Date__c );
                      system.debug( '*****Pre_Fund_Offer_Date__c :' + objhp.cllease__Contract__r.X1_BBB_Enable_Repurchase_Date__c);
                      system.debug( '*****Pre_Fund_Ineligible_Repurchase_Date__c  :' + objhp.cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c);
                      system.debug( '*****Funder_2_Acceptance_Date__c :' + objhp.cllease__Contract__r.Funder_2_Acceptance_Date__c );
                      if(objmn.Saf_GL_Accounting_Entries__c != null) lst_ManualGLTxn.add(objmn);  
                      
                        Manual_GL__c objDebit = new Manual_GL__c();
                       objDebit.GL_Account_Type__c = 'Debit';
                       objDebit.MN_Accrual_Transaction__c = objhp.cllease__Accrual_Transaction__c;
                       objDebit.MN_Lease_Accrual_Transaction__c = objhp.cllease__Lease_Accrual_Transaction__c; //Added by Sumit on 15/03/2020
                       objDebit.MN_Amount__c= objhp.cllease__Debit_Amount__c;
                       objDebit.MN_Billing_Transaction__c = objhp.cllease__Billing_Transactions__c;
                         objDebit.saf_Product__c = mapproduct.get(objhp.cllease__Contract__r.cllease__Lease_Product_Name__c);
                      
                       objDebit.MN_Cash_Receipt_Transaction__c = objhp.cllease__Cash_Receipt_Transaction__c;
                       objDebit.MN_Cash_Receipt__c = objhp.cllease__Cash_Receipt__c;
                       objDebit.MN_Charge__c = objhp.cllease__Charge__c;
                       objDebit.MN_Company__c = objhp.cllease__Company__c;
                       objDebit.MN_Contract__c = objhp.cllease__Contract__c;
                       objDebit.MN_Debt_Schedule__c = objhp.cllease__Debt_Schedule__c; 
                       
                       objDebit.MN_Generation_Scheme__c = objhp.cllease__Generation_Scheme__c;
                       
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
                       objDebit.MN_Payment_Transaction_Reversal__c = objhp.cllease__Payment_Transaction_Reversal__c; //Added by Sumit on 15/03/2020
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
                       objDebit.saf_Funder1__c  = objmn.saf_Funder1__c ;
                      
                       objDebit.MN_Other_Transactions__c =   objhp.cllease__Other_Transactions__c;
                      
                       if(objDebit.Saf_GL_Accounting_Entries__c != null) lst_ManualGLTxn.add(objDebit);                                                                                                     
                   }
                  
           //response = responseAdd;
            if(lst_ManualGLTxn.size() >0) 
            {             
                insert lst_ManualGLTxn;
                system.debug('========= scope ========:' + scope.size());
                system.debug('========= inserting manual gls ========:' + lst_ManualGLTxn.size()); 
              
            }  
        }
        catch(exception e)
        {
          system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
          String strErrordes= 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
          ErrorLogsUtils.createErrorLogs('Failure', 'Saf_GlManualEntry_1', 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, true, '', '');
        }
    }
      
          global override void dofinish(Database.BatchableContext BC){
            
            System.debug('Records processed ManualGl: ' + recordsProcessed);
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job ManualGL: ' + job);
           
            //Saf_CheckGlAccountingEntry job2 = new Saf_CheckGlAccountingEntry();
            //database.executebatch(job2,100);
            
        } 
   global static string buildquery(){
        //build query.
        
        string query = 'SELECT cllease__Accrual_Transaction__c,cllease__Billing_Transactions__c,' +
           'cllease__Cash_Receipt_Transaction__c,cllease__Cash_Receipt__c,cllease__Company__c,cllease__Contract__c,'+
           'cllease__Credit_Amount__c,cllease__Credit_GL_Account_Code__c,cllease__Credit_GL_Account__c,cllease__Debit_Amount__c,' +
           'cllease__Debit_GL_Account_Code__c,cllease__Debit_GL_Account__c,cllease__Debt_Schedule__c,cllease__Depreciation_Stream__c,' +
           'cllease__Disbursement_Transaction__c,cllease__Disbursement_Txn__c,cllease__Equipment_Transaction__c,cllease__Equipment__c,' +
           'cllease__Expense_Fee_Transaction__c,cllease__Exported_Date__c,cllease__Exported_Flag__c,cllease__Generation_Scheme__c,' +
           'cllease__GL_Batch_Post_Date__c,cllease__GL_Date__c,cllease__Item_Id__c,cllease__Item_Name__c,cllease__LeaseApplicationNumber__c,' +
           'cllease__Lease_Accrual_Transaction__c,cllease__Lease_Payment_Detail__c,cllease__Other_Transactions__c,' +
           'cllease__Payment_Transaction_Reversal__c,cllease__Payment_Transaction__c,cllease__Reversal_Processed__c,cllease__Transaction_Description__c,' +
           'cllease__Transaction_type1__c,cllease__Transaction_Type__c,CreatedById,CreatedDate,Id,LastModifiedDate,' +
           'cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Payment_Transaction__r.cllease__Cheque_Number__c,' +
           'cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Payment_Mode__c,cllease__Lease_Payment_Detail__r.cllease__Payment_Transaction__r.cllease__Cheque_Number__c,' +
           'cllease__Contract__r.Pre_Fund_Offer_Date__c,cllease__Contract__r.Funder_1_Acceptance_Date__c,cllease__Contract__r.Pre_Fund_Ineligible_Repurchase_Date__c,cllease__Contract__r.X1_BBB_Enable_Repurchase_Date__c,' +
           'cllease__Contract__r.Funder_2_Acceptance_Date__c ,cllease__Contract__r.Funder_2__c,cllease__Contract__r.X2_BBB_Enable_Repurchase_Date__c,' +
           'Name,cllease__Contract__r.cllease__Lease_Product_Name__c,Saf_Manual_GL_Entry_created__c,cllease__Charge__c,cllease__Contract__r.Funder__c,' +
           'Transaction_Date__c,Transaction_Sub_Type__c,Transaction_Type__c FROM cllease__GL_Transaction_Detail__c WHERE Saf_Manual_GL_Entry_created__c = false limit :LimitQuery';
      
         system.debug('--Query--'+ query);      
         return query;
    }

}