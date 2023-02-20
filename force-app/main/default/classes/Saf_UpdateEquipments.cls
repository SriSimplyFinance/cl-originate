/**
*
* @name                 : Saf_UpdateEquipments 
* @author               : Happiest minds 
* @description          : This Batch class is used to update equipments (Contract Equipment Invoice Price)
* @created date         : 03-01-2020
* @modified by / date   : 03-01-2020
*
**/


global class Saf_UpdateEquipments implements Database.Batchable<sObject>,Database.Stateful{

   /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/ 
    public class MyException extends Exception{} 
    global Integer recordsProcessed = 0;
    global Map<Id,Double> mapcon = new Map<Id,Double> ();
    global Map<Id,Double> mapconApp = new Map<Id,Double> ();
    global Set<Id> setTerminatedAgremment = new Set<Id> ();
    global Set<Id> setApplicationIds = new Set<Id> ();
    global Map<Id,Decimal> streamCapitalRecovery = new Map<Id,Decimal>();
    global Map<Id,Decimal> streamIncome = new Map<Id,Decimal>();
    global static date TodaysDate;
    global Database.QueryLocator start(Database.BatchableContext BC){
        /*   User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
        TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
        System.debug(LoggingLevel.ERROR, '###### TodaysDate : ' + TodaysDate); 
        Integer Intmonth =  TodaysDate.month();
        Integer Intyear =  TodaysDate.year();*/
        
        string[] id = new string[]{'a5h3O000000CeoR'};
        String query='SELECT cllease__Contract__r.cllease__Financed_Amount__c,cllease__Contract__r.Dummy_Financed_Amount__c,Advanced_Rental__c,Agent__c, Amount_Financed__c,Asset_Category__c,Asset_Description__c,Asset_Make__c,Asset_Manufacturer__c,Asset_Model__c,Breakdown_Per_Asset__c,cllease__Account__c,cllease__Billing_Group__c,cllease__Bill_Group__c,cllease__City_Surcharge__c,cllease__City_Tax_Rate__c,cllease__City__c,cllease__Contract__c,cllease__Country__c,cllease__County_Surcharge__c,cllease__County_Tax_Rate__c,cllease__County__c,cllease__Created_Through_Contract__c,cllease__Dealer_Contact_Email__c,cllease__Dealer_Contact_Name__c,cllease__Dealer_Fees__c,cllease__Dealer_Funded__c,cllease__Dealer_Name__c,cllease__Dealer_Party__c,cllease__Dealer_Phone_Number__c,cllease__Depreciation_Basis__c,cllease__Equipment_Book_Value__c,cllease__Equipment_Calculated_Cost__c,cllease__Equipment_Cost__c,cllease__Equipment_Description__c,cllease__Equipment_External_Id__c,cllease__Equipment_Id__c,cllease__Equipment_Net_Book_Value__c,cllease__Equipment_Serial_Number__c,cllease__Equipment_Type__c,cllease__Estimated_Selling_Price__c,cllease__Evergreen_Depreciation_Amount__c,cllease__Flag_To_Delete__c,cllease__Generate_Book_Depreciation__c,cllease__Item_Code__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,cllease__life_in_months__c,cllease__Make__c,cllease__Model__c,cllease__NBV_On_Restructure_Date__c,cllease__New_Invoice_Price__c,cllease__Next_Variable_Rent_Due_Date__c,cllease__Original_Equipment_Id__c,cllease__Other_Financed_Fees__c,cllease__Override_Tax_Flag__c,cllease__Override_Tax_Rate__c,cllease__Rent__c,cllease__Residual_Amount__c,cllease__return_status__c,cllease__Select_Equipment__c,cllease__State_Province__c,cllease__State_Surcharge__c,cllease__State_Tax_Rate__c,cllease__status1__c,cllease__Status__c,cllease__Street_Address__c,cllease__Subsidy__c,cllease__Subvention__c,cllease__Tax_Amount__c,cllease__Tax_Code__c,cllease__Tax_Depreciation_Method__c,cllease__Tax_exemption__c,cllease__tax_financed__c,cllease__Tax_Residual_Value__c,cllease__Total_Dealer_Charges__c,cllease__Total_Tax_Amount__c,cllease__Total_Tax_Rate_Derived__c,cllease__Total_Tax_Rate__c,cllease__Upfront_Tax_Basis__c,cllease__Upfront_Tax_Flag__c,cllease__Variable_Rent_Frequency__c,cllease__Variable_Rent_Start_Date__c,cllease__VIN__c,cllease__Warehouse_Equipment__c,cllease__Warranty_Amount__c,cllease__Year__c,cllease__Zip_Code__c,Contract_Equipment_Invoice_Amount__c,CreatedById,CreatedDate,Date_of_Manufacture__c,Deposit__c,Equipment_Deposit__c,Equipment_Sub_Status__c,Equipment_Type_Code__c,Gross_Asset_Cost__c,HPI_Code__c,HPI_Error_Message__c,HPI_Registration_Required__c,Id,Invoice_Due_Date__c,IsDeleted,IS_Registered__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Net_Asset_Cost__c,NewUsed__c,New_Used__c,Other_ID_Number__c,Paid_to_Supplier__c,Registration_Number__c,Repossession_Date__c,SAF_Paid__c,SAF_UREL__c,Serial_Number__c,Supplier_Paid__c,Supplier_Payable__c,SystemModstamp,Total_Cost__c,Total_VAT_OutPut_Cost__c,Valuation_Source__c,Valuation__c,VAT__c,Vehicle_Chassis_Number__c,Vehicle_or_General__c,Vehicle_Registration_Number__c,Year_of_Manufacture__c,Zoho_Equipment_ID__c FROM cllease__Contract_Equipment__c order by cllease__Contract__c';// where Id IN:id
        
        //CALENDAR_MONTH(cllease__Date__c) =:Intmonth and CALENDAR_YEAR(cllease__Date__c) =:Intyear //where cllease__Contract__r.cllease__Account__c IN: id 
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, list<cllease__Contract_Equipment__c>scope){
    
         system.debug('******query****'+scope);
         try{
         
            set<id>Conids=new set<id>();
            //List<cllease__Lease_Account__c> lstcon = new List<cllease__Lease_Account__c>();
            //List<cllease__Lease_Account__c> lstcon2 = new List<cllease__Lease_Account__c>();
            Map<Id,cllease__Lease_Account__c> mapContracts = new Map<Id,cllease__Lease_Account__c>();
            
            List<Account> lstAcc = new List<Account>();
            for(cllease__Contract_Equipment__c objacc: scope)
            {   
               objacc.cllease__Contract__r.Dummy_Financed_Amount__c =  objacc.cllease__Contract__r.cllease__Financed_Amount__c;
               mapContracts.put(objacc.cllease__Contract__c, objacc.cllease__Contract__r);
            }
 
        
            // update  mapContracts.values();
             cllease.EquipmentOperations.updateEquipment(scope);
            if(Test.isRunningTest()){throw new MyException();}
        }
        catch(exception e)
        {
            system.debug( 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString());
            //String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
            string strErrordes = 'Branch Date :' + date.today() + e.getMessage() + ', Line no: '+e.getLineNumber();
            //ErrorLogsUtils.createErrorLogs('Failure', description,'Batch',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'execute',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
      
        global void finish(Database.BatchableContext BC){
            
            System.debug('Records processed: ' + recordsProcessed);
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
            System.debug('job : ' + job);
        } 


}