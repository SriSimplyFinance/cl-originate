public with sharing  class SettlementQuoteCtrl {
    public cllease__Termination_Quote_Header__c termQuoteHeader {get; set;}
    public cllease__Termination_Quote_Header__c accTermQuote {get; set;}
    public  cllease__Lease_Account__c termContract{get; set;}
    //public cllease__Lease_Account__c contract;
    public Integer noOfEquipments {get; set;}
    public Decimal RebateRentalPercentage {get; set;}
    public Decimal RebateRentalAmount {get; set;}
    //public Decimal VATonRebateRentals {get;set;}
    public string disabled{get;set;}
    public string disableSetInfo{get;set;}
    public boolean disableAssetSaleButton{get;set;}
    public boolean disableSaleProceeds{get;set;}
    private Decimal SettlementFigureForNBV;
    public List<cllease__Contract_Fees__c> contractFee {get; set;}
    
    public List<TerminationQuoteAction.Equipment> equipmentDetails {get; set;}
    public List<TerminationQuoteAction.Equipment> SelectedequipmentDetails {get; set;}
    public List<TerminationQuoteAction.Equipment> AllequipmentDetails {get; set;}
    public List<Termination_Quote_Figures__c> QuoteFiguresToDelete;
    public List<Termination_Quote_Figures__c> QuoteFiguresToInsert {get; set;}
    public Termination_Quote_Figures_Header__c QuoteFiguresHeader {get; set;}
    public Integer termquoteheader_rec;
    
    public List<RowWrapper> rows {get;set;}
    Public List<RowWrapperLabels> rowLabelsList {get;set;}
    //public cllease__Office_Name__c Company = new cllease__Office_Name__c();
    public Decimal OtherDiscountRate {get; set;}
    public Decimal NetAssetCostSale {get; set;}
    // public Decimal NetAssetCostVAT {get; set;}
    //public Decimal GrossAssetCostSale {get; set;}
    public Decimal SaleAmount {get; set;}
    Public List<RowWrapperStandard> rowwrapperList{get;set;}
    //Public Boolean ErrorMsg{get; set;}
    Public String AcceptedTerminationQuote {get;set;}
    Public Boolean accepttermination {get;set;}
    Public Boolean terminationaccepted {get;set;}
    Public Boolean savetermination {get;set;}
    Public Decimal OtherSettlementAmount {get;set;}
    Public Boolean DateChange {get;set;}
    Public Boolean generateAssetSale {get;set;}
    Public Date dateOfQuote {get; set;}
    Public Date Expirydate {get; set;}
    Public Date AcceptanceDate{get; set;}
    
    public List<cllease__Contract_Equipment__c> equipments;
    //Pick List Vlaues 
    public list<selectoption> ThirdPartySaleOptions {get;set;}
    public string ThirdPartySelect{get;set;}
    public list<selectoption> QuoteTypeOptions {get;set;}
    public string QuteSelect{get;set;}
    public list<selectoption> QuoteReasonOptions {get;set;}
    public string QuoteReasonSelect{get;set;}
    public list<selectoption> FPOptions {get;set;}
    public string FPSelect{get;set;}
    Public Boolean SelectAll;  
    public list<selectoption> ProductTypeOptions {get;set;}
    
    public list<selectoption> NewBusIncentiveOptions {get;set;}
    public string NewBusIncentiveSelect{get;set;} 
    private Id otpFee;
    private String otpFeeName;
    private Decimal thirdPartySaleNetAmt;
    private Decimal thirdPartySaleVATAmt;
    
    public cllease__Termination_Quote_Header__c getLoadTermQuote(){
        cllease__Termination_Quote_Header__c[] TermQuote = [SELECT Id, Name FROM cllease__Termination_Quote_Header__c WHERE Name =: AcceptedTerminationQuote LIMIT 1];
        system.debug('accTermQuote:'+accTermQuote);
        if(TermQuote.size() > 0){
            accTermQuote = TermQuote[0];
        }
        return accTermQuote;
    }
    /*public boolean displayassetsale {
        get{
            if(ThirdPartySelect=='Yes'){
                RebateRentalPercentage = 95;
                return true;
            }    
            else{
                RebateRentalPercentage = 0;
                return false;
            }
        }    
        set;
    } */
    
     public boolean displayassetsale {
        get{
            if(ThirdPartySelect=='Yes') {
                if(RebateRentalPercentage == null){
                    RebateRentalPercentage = 95;
                }
                return true;
            }    
            else {
                if(RebateRentalPercentage == null){
                    RebateRentalPercentage = 0;
                }
                return false;
            }
        }    
        set;
    } 
    
    public boolean displayterminationdate {
        get{
            if(AcceptedTerminationQuote == 'NOT SAVED'){                
                return false;
            }    
            else{                
                return true;
            }
        }    
        set;
    }
    String Contract;
    Public Boolean calculatequote {get;set;}
    //Error Log Starts
    public string strDateFormat = 'ddMMyyyy';
    public User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
    public Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
    //Error Log Ends
    Id quoteheaderid;
    Decimal Selectedequipmentcost=0;
    Decimal Allequipmentcost=0;
    
    public SettlementQuotectrl(ApexPages.StandardController controller) {  
        try{  
            thirdPartySaleNetAmt = 0.00;
            thirdPartySaleVATAmt = 0.00;
            //ErrorMsg = False;
            //disabled = false; 
            SaleAmount = 0.00;
            NetAssetCostSale = 0.00;
            //NetAssetCostVAT = 0.00;
            //GrossAssetCostSale = 0.00;
            OtherDiscountRate = 0.0;     
            termQuoteHeader =new cllease__Termination_Quote_Header__c ();
            dateOfQuote= cllease.SystemDateUtil.getCurrentSystemDate();  
            //dateOfQuote = Date.valueOf(Date.today().format());
            //Expirydate= dateOfQuote.addDays(28);
            //AcceptanceDate = Expirydate;
            //RebateRentalPercentage = 95;
            ThirdPartySaleOptions = new List<SelectOption>();
            ThirdPartySaleOptions.add(new selectOption('--Please Select--','--Please Select--')); 
            ThirdPartySaleOptions.add(new selectOption('Yes','Yes')); 
            ThirdPartySaleOptions.add(new selectOption('No','No')); 
        
            QuoteTypeOptions = new List<SelectOption>();
            QuoteTypeOptions.add(new selectOption('--Please Select--','--Please Select--')); 
            QuoteTypeOptions.add(new selectOption('Standard','Standard')); 
            QuoteTypeOptions.add(new selectOption('New Business','New Business')); 
            QuoteTypeOptions.add(new selectOption('NBV','NBV')); 
            QuoteTypeOptions.add(new selectOption('Other','Other')); 
        
            QuoteReasonOptions = new List<SelectOption>();
            QuoteReasonOptions.add(new selectOption('--Please Select--','--Please Select--')); 
            QuoteReasonOptions.add(new selectOption('Early Settlement','Early Settlement')); 
            QuoteReasonOptions.add(new selectOption('Repossession','Repossession')); 
            //QuoteReasonOptions.add(new selectOption('etc','etc')); 
        
            FPOptions = new List<SelectOption>();
            FPOptions.add(new selectOption('--Please Select--','--Please Select--')); 
            FPOptions.add(new selectOption('Full','Full')); 
            FPOptions.add(new selectOption('Partial','Partial')); 
        
            ProductTypeOptions = new List<SelectOption>();
            ProductTypeOptions.add(new selectOption('--Please Select--','--Please Select--')); 
            ProductTypeOptions.add(new selectOption('Finance Lease','Finance Lease')); 
            ProductTypeOptions.add(new selectOption('Hire Purchase','Hire Purchase')); 
        
            NewBusIncentiveOptions = new List<SelectOption>();
            NewBusIncentiveOptions.add(new selectOption('--Please Select--','--Please Select--')); 
            NewBusIncentiveOptions.add(new selectOption('Yes','Yes')); 
            NewBusIncentiveOptions.add(new selectOption('No','No')); 
            NewBusIncentiveSelect = 'No';
            ThirdPartySelect = 'No';        
            accepttermination = true;
            savetermination = true;
            generateAssetSale = true;
            DateChange = false;
            RebateRentalAmount=0.00;
            //VATonRebateRentals=0.00; 
            termquoteheader_rec=0; 
            rows=new List<RowWrapper>();
            rowLabelsList = new List<RowWrapperLabels>();
            rowwrapperList = new List<RowWrapperStandard>(); 
            //AcceptedTerminationQuote = 'NOT ACCEPTED';
            AcceptedTerminationQuote = 'NOT SAVED';
            SelectedequipmentDetails = new List<TerminationQuoteAction.Equipment>(); 
            terminationaccepted = false;        
            Contract='';
            calculatequote = true;
       
            //Company = [SELECT name,cllease__Vat_Rate__c FROM cllease__Office_Name__c LIMIT 1];
            
            //this.termContract = (cllease__Lease_Account__c)controller.getRecord();
            quoteheaderid = controller.getId();
            if(quoteheaderid!=Null){
                Termination_Quote_Figures_Header__c quoteheader = [Select name, Agreement__c FROM Termination_Quote_Figures_Header__c where id = :quoteheaderid];
                Contract = quoteheader.Agreement__c;
                system.debug('***************Record ID found**********:' + quoteheaderid);
                system.debug('***************Record ID found**********:' + quoteheader.name);
            }
            Else{
                system.debug('***************Record Id not found************************');
            }        
            termContract = [SELECT Id,Name,cllease__Account__r.name,cllease__Lease_Product_Name__r.name,
                        Standard_Type_Termination_Discount_Rate__c,New_Business_Discount_Rate__c,EAR_of_XIRR3__c,
                        Other_Type_Termination_Discount_Rate__c,cllease__Lease_Product_Name__r.Option_To_Purchase__c,
                        cllease__Excess__c,Settlement_Date__c,cllease__Lease_Status__c,SAF_term_quote_arrears__c,
                        SAF_term_quote_balance_to_pay__c,SAF_term_quote_discount__c,SAF_term_quote_future_rentals__c,
                        SAF_term_quote_new_business_incentive__c,SAF_term_quote_option_to_purchase__c,SAF_term_quote_profit_loss__c,
                        SAF_term_quote_quote_type__c,SAF_term_quote_rebate_of_rentals__c,SAF_term_quote_settlement_figure__c,
                        SAF_term_quote_total_gross_settlement__c,SAF_term_quote_Total_Net_Settlement__c,
                        SAF_term_quote_VAT_on_rebate_of_rentals__c,SAF_term_quote_VAT_on_settlement__c,cllease__Maturity_Date__c,
                        cllease__Next_Due_Generation_Date__c                                                   
                        FROM cllease__Lease_Account__c 
                        WHERE name = :Contract];
            //Expirydate= dateOfQuote.addDays(28);
            if(termContract.cllease__Next_Due_Generation_Date__c != null){
                Expirydate= termContract.cllease__Next_Due_Generation_Date__c.addDays(-1);
            }
            AcceptanceDate = Expirydate;            
            if(termContract.cllease__Lease_Product_Name__r.Option_To_Purchase__c==NULL){
                termContract.cllease__Lease_Product_Name__r.Option_To_Purchase__c = 250; 
            }          
            if(equipmentDetails == null) {
                equipmentDetails = new List<TerminationQuoteAction.Equipment>();
                AllequipmentDetails = new List<TerminationQuoteAction.Equipment>();
                for(cllease__Contract_Equipment__c a: [select Id, Name,cllease__Equipment_Description__c,cllease__Equipment_Calculated_Cost__c,
                                                   cllease__Equipment_Serial_Number__c,Registration_Number__c,cllease__Residual_Amount__c,
                                                   Gross_Asset_Cost__c,VAT__c,Total_Cost__c,Net_Asset_Cost__c ,cllease__Status__c,cllease__Contract__r.cllease__Lease_Product_Name__c
                                                   from cllease__Contract_Equipment__c
                                                   WHERE cllease__Contract__c= :termContract.id]) {
                  if(a.cllease__Status__c!='TERMINATED'){                                      
                      equipmentDetails.add(new TerminationQuoteAction.Equipment(a));
                  }
                  AllequipmentDetails.add(new TerminationQuoteAction.Equipment(a));                                                                   
                }
            
                noOfEquipments=equipmentDetails.size();
            }    
            
            //***********************Populating saved header and quotes********************************.
            termquoteheader_rec = [SELECT count() FROM Termination_Quote_Figures_Header__c where Agreement__c = :termContract.name];
            //************Populating header*************
            if(termquoteheader_rec>0){
                   system.debug(termquoteheader_rec + '*********Termination Quote Figure Header record found for' + termContract.name);
                   QuoteFiguresHeader = [SELECT id,name,X3rd_Party_Sale__c,Acceptance_Date__c,Agreement__c,Date_of_Quote__c,Discount1__c,
                                  Expiry_Date__c,FPOptions__c,Asset_Sale_Process1__c,New_Business__c,Other_Settlement_Amount__c,Product_Type__c,Customer_Name__c,
                                  Quote_Reason__c,Quote_Type__c,Rebate_Rental_Amount__c,Rebate_Rental_Percentage__c,Sale_Amount__c,
                                  Selected_Equipments__c,Accepted_Termination_Quote__c
                                   FROM Termination_Quote_Figures_Header__c where Agreement__c = :termContract.name AND id = :quoteheaderid LIMIT 1];
                    
                
                  AcceptedTerminationQuote = QuoteFiguresHeader.Accepted_Termination_Quote__c!=Null?QuoteFiguresHeader.Accepted_Termination_Quote__c:'LOCKED';
                    dateOfQuote = QuoteFiguresHeader.Date_of_Quote__c!=Null?QuoteFiguresHeader.Date_of_Quote__c:dateOfQuote;
                    QuteSelect = QuoteFiguresHeader.Quote_Type__c!=Null?QuoteFiguresHeader.Quote_Type__c:QuteSelect;
                    QuoteReasonSelect = QuoteFiguresHeader.Quote_Reason__c!=Null?QuoteFiguresHeader.Quote_Reason__c:QuoteReasonSelect;
                    FPSelect = QuoteFiguresHeader.FPOptions__c!=Null?QuoteFiguresHeader.FPOptions__c:FPSelect;
                    Expirydate = QuoteFiguresHeader.Expiry_Date__c!=Null?QuoteFiguresHeader.Expiry_Date__c:Expirydate;
                    OtherDiscountRate = QuoteFiguresHeader.Discount1__c!=Null?QuoteFiguresHeader.Discount1__c:OtherDiscountRate;
                    NewBusIncentiveSelect = QuoteFiguresHeader.New_Business__c!=Null?QuoteFiguresHeader.New_Business__c:NewBusIncentiveSelect;
                    AcceptanceDate = QuoteFiguresHeader.Acceptance_Date__c!=Null?QuoteFiguresHeader.Acceptance_Date__c:AcceptanceDate;
                    OtherSettlementAmount = QuoteFiguresHeader.Other_Settlement_Amount__c!=Null?QuoteFiguresHeader.Other_Settlement_Amount__c:OtherSettlementAmount;                    
                    ThirdPartySelect = QuoteFiguresHeader.X3rd_Party_Sale__c!=Null?QuoteFiguresHeader.X3rd_Party_Sale__c:ThirdPartySelect;                                        
                    SaleAmount = QuoteFiguresHeader.Sale_Amount__c!=Null?QuoteFiguresHeader.Sale_Amount__c:SaleAmount;
                    NetAssetCostSale = SaleAmount;
                    //NetAssetCostVAT = termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c!=Null?(NetAssetCostSale*(termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c/100)).setScale(2):0.00;
                    //GrossAssetCostSale = (NetAssetCostSale + NetAssetCostVAT).setScale(2);
                    RebateRentalPercentage = QuoteFiguresHeader.Rebate_Rental_Percentage__c!=Null?QuoteFiguresHeader.Rebate_Rental_Percentage__c:RebateRentalPercentage;
                    RebateRentalAmount = QuoteFiguresHeader.Rebate_Rental_Amount__c!=Null?QuoteFiguresHeader.Rebate_Rental_Amount__c:RebateRentalAmount;
                    //Equipments = QuoteFiguresHeader.Selected_Equipments__c!=Null?QuoteFiguresHeader.Selected_Equipments__c:Equipments;
                    //***********Populating quotes************************ 
                
                system.debug('QuoteFiguresHeader.Asset_Sale_Process1__c:'+QuoteFiguresHeader.Asset_Sale_Process1__c);
                if(QuoteFiguresHeader.Asset_Sale_Process1__c == 'Initiated'){
                    disableSetInfo = 'true';
                   // disableAssetSaleButton = true;
                }else if(QuoteFiguresHeader.Asset_Sale_Process1__c == 'Completed'){
                    disableSetInfo = 'true';
                    //disableAssetSaleButton = true;
                    //disableSaleProceeds = true;
                }else{
                   // disableSaleProceeds = true;
                }
                disableAssetSaleButton(quoteheaderid);
                QuoteFiguresToInsert = [SELECT id FROM Termination_Quote_Figures__c where Agreement__c = :termContract.name];
                    if(QuoteFiguresToInsert.size()>0){
                        system.debug(QuoteFiguresToInsert.size() + '*********Termination Quote Figures records found for' + termContract.name);
                        displayquotefigures();
                        for(RowWrapperStandard quote : rowwrapperList){
                            if(QuteSelect == quote.terQuote.Quote_Type__c){
                                quote.isSelectedQuote=true;
                            }        
                        }
                    }
                    //**********Populating equipments*********************
                    if(equipmentDetails.size()>0){
                        for(TerminationQuoteAction.Equipment equipment : equipmentDetails){
                            if(QuoteFiguresHeader.Selected_Equipments__c.contains(equipment.eqp.name)){
                                equipment.isSelected = true;
                                SelectedequipmentDetails.add(equipment);    
                            }    
                        }
                    }
                    //**************Population complete*************  
                    if(QuoteFiguresHeader.Accepted_Termination_Quote__c.substring(0,3)=='QTE'){  
                        accepttermination = true;
                        calculatequote = true;
                    }
                    else{
                        accepttermination = false;
                        calculatequote = false;
                    }    
                    savetermination = true; 
            }         
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            system.debug('****strErrordes****' + strErrordes);
            system.debug('******Class Name****' + String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'Class Constructor',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
         }
    }
    
    public void equipmentSelection(){   
        try{     
            for(TerminationQuoteAction.Equipment te : equipmentDetails){
                if(FPSelect =='Full'){
                     te.isSelected=true;              
                }            
        
                else{            
                    te.isSelected=false;
                }
            }
         } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'equipmentSelection',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
         }   
    }
    
    //public Decimal FindSelectedEquipments(){ 
    public Decimal FindSelectedEquipments(List<TerminationQuoteAction.Equipment> equipments){    
       try{ 
           Decimal Totalequipmentcost = 0;
           Selectedequipmentcost = 0;
           SelectedequipmentDetails=new List<TerminationQuoteAction.Equipment>();
          
           for(TerminationQuoteAction.Equipment te : equipmentDetails){
               Totalequipmentcost += te.eqp.Net_Asset_Cost__c!=Null?te.eqp.Net_Asset_Cost__c:0;
                   if(te.isSelected==true){
                        SelectedequipmentDetails.add(te);
                        Selectedequipmentcost += te.eqp.Net_Asset_Cost__c!=Null?te.eqp.Net_Asset_Cost__c:0;
                   }
           }
          //return Totalequipmentcost!=0?(Selectedequipmentcost/Totalequipmentcost).setScale(2):1;
          return Totalequipmentcost!=0?(Selectedequipmentcost/Totalequipmentcost):1; 
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'FindSelectedEquipments',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            return null;
           }
       
       
    }
    
    public Decimal FindTotalEquipments(List<TerminationQuoteAction.Equipment> equipments){   
      
           Decimal Totalequipmentcost = 0;                      
           for(TerminationQuoteAction.Equipment te : equipments){
               Totalequipmentcost += te.eqp.Net_Asset_Cost__c!=Null?te.eqp.Net_Asset_Cost__c:0;                   
           }
          return Totalequipmentcost.setScale(2);                                  
    }
    
    public void datechange(){
        try{
            //Expirydate= dateOfQuote.addDays(28);
            DateChange = true;
            
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'datechange',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
         }    
        
    }
    /*
    public void expirydatechange(){  
        try{      
            DateChange = true;
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'expirydatechange',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
         }
    }
    */
     public void amountchange(){
         try{
            //NetAssetCostVAT = (NetAssetCostSale*(termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c/100)).setScale(2);
            //GrossAssetCostSale = (NetAssetCostSale + NetAssetCostVAT).setScale(2);
            RebateRentalAmount = (NetAssetCostSale*(RebateRentalPercentage/100)).setScale(2);        
            SaleAmount = NetAssetCostSale;  
         } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'amountchange',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
         }        
    }
    
    public void quotechange(){
        try{
            if(AcceptedTerminationQuote == 'LOCKED'){
                savetermination = false;
                generateAssetSale = true;
            }    
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'quotechange',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
         }    
        
    }
    /*
    public pagereference thirdpartychange(){
        try{
            if(ThirdPartySelect=='Yes'){
                displayassetsale=true;
            }
            else{
                displayassetsale=false;
            }
            system.debug('******************ThirdPartySelect************' + ThirdPartySelect);
            system.debug('******************displayassetsale************' + displayassetsale);
           return null; 
         } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'displayassetsale',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
             return null;
         }   
    }
    */
    
    //@Method It would generate Quote Figures for all 4 types of quotes and insert into object.
    public PageReference generateQuoteFigures(){  
        try{
            //Company = [SELECT name,cllease__Vat_Rate__c FROM cllease__Office_Name__c LIMIT 1];
            Decimal EquipProportion=0;
            //Decimal AllEquipProportion = 0;
            //ErrorMsg = False;
            Decimal Futurerentals=0;
            Decimal Arrears = 0;
            Decimal SettlementFigureStandard=0;
            Decimal SettlementFigureNewBusiness=0;
            Decimal SettlementFigureNBV=0;
            Decimal SettlementFigureOther=0;
            Decimal OptionToPurchase=0;
            Decimal RebateOfRentals=0;
            rowwrapperList = new List<RowWrapperStandard>();
            rowLabelsList = new List<RowWrapperLabels>();
            QuoteFiguresToInsert = new list<Termination_Quote_Figures__c>();
        
            //Delete existing quoteFigures for this contract.
            QuoteFiguresToDelete = [Select id from Termination_Quote_Figures__c where Agreement__c = :termContract.name];
            if(QuoteFiguresToDelete.size()>0){
                Delete QuoteFiguresToDelete;
            }
        
            //ValidateFields();
            
            if(QuoteReasonSelect=='--Please Select--'){

                //ErrorMsg = True;
                return null;
            }
            
            if(FPSelect=='--Please Select--'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'SETTLEMENT INFORMATION: Please select Full/Partial'));
                //ErrorMsg = True;
                return null;
            }
            
            if(ThirdPartySelect=='--Please Select--'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'SETTLEMENT INFORMATION: Please select 3rd Party(Yes/No)'));
                //ErrorMsg = True;
                return null;
            }
            
            if(NewBusIncentiveSelect=='--Please Select--'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'SETTLEMENT INFORMATION: Please select New Business(Yes/No)'));
                //ErrorMsg = True;
                return null;
            } 
            
            //if(Expirydate <= dateOfQuote){
            /*
            if(Expirydate < dateOfQuote){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Expiry Date must be greater than or equal to Date of Quote'));
                //ErrorMsg = True;
                return null;
            }
            */
            
             if(OtherSettlementAmount > 0 && OtherDiscountRate > 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not enter both Discount% and Amount'));
                return null;
            }   
            if(OtherSettlementAmount < 0 || OtherDiscountRate < 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not enter Negative value in Discount% or Amount'));
                return null;
            }   
                         
            //EquipProportion = FindSelectedEquipments();
            EquipProportion = FindSelectedEquipments(equipmentDetails);             
            Allequipmentcost = FindTotalEquipments(AllequipmentDetails);
            //AllEquipProportion = Allequipmentcost!=0?(Selectedequipmentcost/Allequipmentcost).setScale(2):0; 
            
            if(SelectedequipmentDetails.size()==0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ASSET INFORMATION: Please select equipments'));
                //ErrorMsg = True;
                return null;
            }
            
            termContract.Other_Type_Termination_Discount_Rate__c = OtherDiscountRate; 
            termContract.Settlement_Date__c =  Expirydate;
            update termContract;   
            
            List<cllease__Payment_Stream__c> FindAcceptanceDate = [Select name,cllease__Date__c,cllease__Payment_Type__c,cllease__Period_Start_Date__c,cllease__Period_End_Date__c FROM cllease__Payment_Stream__c where cllease__Contract__r.name = :termContract.name AND cllease__Payment_Type__c = 'RENT' AND cllease__Period_Start_Date__c <= :Expirydate AND cllease__Period_End_Date__c >= :Expirydate];
            If(FindAcceptanceDate.size()>0){
                AcceptanceDate = FindAcceptanceDate[0].cllease__Period_Start_Date__c!=Null?FindAcceptanceDate[0].cllease__Period_Start_Date__c:Expirydate;
                system.debug('*****************Acceptance Date******************:' + AcceptanceDate);
            }
                   
            //List<cllease__Payment_Stream__c> FuturePayments = [Select name,cllease__Date__c,cllease__Payment_Type__c,cllease__Rental_Amount__c,Standard_Quote_Stream_Amount__c,New_Business_Quote_Stream_Amount__c,NBV_Quote_Stream_Amount__c,Other_Quote_Stream_Amount__c FROM cllease__Payment_Stream__c where cllease__Contract__r.name = :termContract.name AND cllease__Payment_Type__c = 'RENT' AND cllease__Date__c > :Expirydate];
            List<cllease__Payment_Stream__c> FuturePayments = getFuturePayments();
            rows=new List<RowWrapper>();                                              
        
            //Insert 4 Quote Figures
            Futurerentals = ((EquipProportion)*CalculateFutureRentals(FuturePayments)).setScale(2);
            SettlementFigureStandard = ((EquipProportion)*CalculateSettlementFigure('Standard',FuturePayments)).setScale(2);            
            SettlementFigureNewBusiness = ((EquipProportion)*CalculateSettlementFigure('NewBusiness',FuturePayments)).setScale(2);
            SettlementFigureNBV = ((EquipProportion)*CalculateSettlementFigure('NBV',FuturePayments)).setScale(2);
            SettlementFigureForNBV = SettlementFigureNBV;
            if(OtherSettlementAmount>0){
               SettlementFigureOther = OtherSettlementAmount;
            }
            else{   
                SettlementFigureOther = ((EquipProportion)*CalculateSettlementFigure('Other',FuturePayments)).setScale(2);
            }
            //EMS-43 OTP Fee is defaulted to 300 under all cases
            contractFee = [SELECT Id, Name,cllease__Fee_Definition__c,cllease__Fee_Definition__r.name, cllease__Total_Payment_Amount__c FROM cllease__Contract_Fees__c WHERE cllease__Fee_Definition__r.Name Like 'OPTION TO PURCHASE%' AND cllease__Contract__c= :termContract.id];
            if(!contractFee.isEmpty()) {
                //OptionToPurchase = termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c!=Null?(contractFee.get(0).cllease__Total_Payment_Amount__c * (1+ termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c/100)*Selectedequipmentcost/Allequipmentcost):((contractFee.get(0).cllease__Total_Payment_Amount__c)*Selectedequipmentcost/Allequipmentcost);
                OptionToPurchase = (contractFee.get(0).cllease__Total_Payment_Amount__c)*Selectedequipmentcost/Allequipmentcost;  
                otpFee = contractFee[0].cllease__Fee_Definition__c;
                otpFeeName = contractFee[0].cllease__Fee_Definition__r.Name;
                system.debug('OptionToPurchaseIF:'+OptionToPurchase);
                system.debug('contractFee.get(0).cllease__Total_Payment_Amount__c:'+contractFee.get(0).cllease__Total_Payment_Amount__c);
                system.debug('Selectedequipmentcost:'+Selectedequipmentcost);
                system.debug('Allequipmentcost:'+Allequipmentcost);
                
            } /*else if(termContract.cllease__Lease_Product_Name__r.Option_To_Purchase__c!=Null && Allequipmentcost!=0) {
                //OptionToPurchase = termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c!=Null?(termContract.cllease__Lease_Product_Name__r.Option_To_Purchase__c*(1+ termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c/100)*Selectedequipmentcost/Allequipmentcost):((termContract.cllease__Lease_Product_Name__r.Option_To_Purchase__c)*Selectedequipmentcost/Allequipmentcost);
                OptionToPurchase = (termContract.cllease__Lease_Product_Name__r.Option_To_Purchase__c)*Selectedequipmentcost/Allequipmentcost;
                system.debug('OptionToPurchaseElse:'+OptionToPurchase);
            }*/
            //Arrears = (EquipProportion)*CalculateArrear();
            Arrears = CalculateArrear();
           //VATonRebateRentals = termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c!=Null?(RebateRentalAmount*EquipProportion*termContract.cllease__Lease_Product_Name__r.VAT_for_Settlement_Calculation__c/100).setScale(2):0.00;
            //system.debug('VATonRebateRentals == ' + VATonRebateRentals);
            // Jira EMS - 54
            //RebateOfRentals = (-RebateRentalAmount*EquipProportion).setScale(2);
            RebateOfRentals = ((NetAssetCostSale*(RebateRentalPercentage/100)).setScale(2));
            system.debug('RebateRentalAmount--->'+RebateRentalAmount);
            system.debug('EquipProportion--->'+EquipProportion);
            Termination_Quote_Figures__c StandardQuoteFigure = new Termination_Quote_Figures__c(
                             Agreement__c = termContract.name,Contract__c = termContract.id,Quote_Type__c = 'Standard',
                             Discount1__c = termContract.Standard_Type_Termination_Discount_Rate__c!=Null?termContract.Standard_Type_Termination_Discount_Rate__c:0.00,
                             Future_Rentals__c = Futurerentals,Settlement_Figure__c = SettlementFigureStandard,
                             Option_To_Purchase__c = OptionToPurchase,
                             //Rebate_of_Rentals__c = -RebateRentalAmount*EquipProportion,
                             Rebate_of_Rentals__c = -RebateOfRentals,
                             //VAT_on_Rebate_of_Rentals__c = -VATonRebateRentals,
                             Arrears__c= Arrears,
                             //Profit_Loss__c = (SettlementFigureStandard - SettlementFigureNBV + NetAssetCostSale - RebateRentalAmount),
                             // Jira EMS-54
                             Profit_Loss__c = (SettlementFigureStandard - SettlementFigureNBV + NetAssetCostSale - RebateOfRentals),
                             New_Business_Incentive__c = NewBusIncentiveSelect=='NO'?0:math.max((SettlementFigureStandard-SettlementFigureNewBusiness),0.00)
                             );
            Termination_Quote_Figures__c NewBusinessQuoteFigure = new Termination_Quote_Figures__c(
                            Agreement__c = termContract.name,Contract__c = termContract.id,Quote_Type__c = 'New Business',
                            Discount1__c = termContract.New_Business_Discount_Rate__c!=Null?termContract.New_Business_Discount_Rate__c:0.00,
                            Future_Rentals__c = Futurerentals,Settlement_Figure__c = SettlementFigureNewBusiness,
                            Option_To_Purchase__c = OptionToPurchase,
                            //Rebate_of_Rentals__c = -RebateRentalAmount*EquipProportion,
                            Rebate_of_Rentals__c = -RebateOfRentals, 
                            //VAT_on_Rebate_of_Rentals__c = -VATonRebateRentals,
                            Arrears__c= Arrears,
                            //Profit_Loss__c = (SettlementFigureNewBusiness - SettlementFigureNBV + NetAssetCostSale - RebateRentalAmount),
                            // Jira EMS-54
                            Profit_Loss__c = (SettlementFigureNewBusiness - SettlementFigureNBV + NetAssetCostSale - RebateOfRentals),
                            New_Business_Incentive__c = NewBusIncentiveSelect=='NO'?0:math.max((SettlementFigureNewBusiness-SettlementFigureNewBusiness),0.0)
                            );
            Termination_Quote_Figures__c OtherQuoteFigure = new Termination_Quote_Figures__c(
                            Agreement__c = termContract.name,Contract__c = termContract.id,Quote_Type__c = 'Other',
                            Discount1__c = OtherDiscountRate,
                            Future_Rentals__c = Futurerentals,Settlement_Figure__c = SettlementFigureOther,
                            Option_To_Purchase__c = OptionToPurchase,
                            //Rebate_of_Rentals__c = -RebateRentalAmount*EquipProportion,
                            Rebate_of_Rentals__c = -RebateOfRentals,
                            //VAT_on_Rebate_of_Rentals__c = -VATonRebateRentals,
                            Arrears__c= Arrears,
                            //Profit_Loss__c = (SettlementFigureOther - SettlementFigureNBV + NetAssetCostSale - RebateRentalAmount),
                            // Jira EMS-54
                            Profit_Loss__c = (SettlementFigureOther - SettlementFigureNBV + NetAssetCostSale - RebateOfRentals),
                            New_Business_Incentive__c = NewBusIncentiveSelect=='NO'?0:math.max((SettlementFigureOther-SettlementFigureNewBusiness),0.0)
                            );
            Termination_Quote_Figures__c NBVQuoteFigure = new Termination_Quote_Figures__c(
                            Agreement__c = termContract.name,Contract__c = termContract.id,Quote_Type__c = 'NBV',
                            Discount1__c = termContract.EAR_of_XIRR3__c!=Null?termContract.EAR_of_XIRR3__c:0.00,
                            Future_Rentals__c = Futurerentals,Settlement_Figure__c = SettlementFigureNBV,
                            Option_To_Purchase__c = OptionToPurchase,
                            //Rebate_of_Rentals__c = -RebateRentalAmount*EquipProportion,
                            Rebate_of_Rentals__c = -RebateOfRentals,
                            //VAT_on_Rebate_of_Rentals__c = -VATonRebateRentals,
                            Arrears__c= Arrears,
                            //Profit_Loss__c = (SettlementFigureNBV - SettlementFigureNBV + NetAssetCostSale - RebateRentalAmount),
                            // Jira EMS-54
                            Profit_Loss__c = (SettlementFigureNBV - SettlementFigureNBV + NetAssetCostSale - RebateOfRentals),
                            New_Business_Incentive__c = NewBusIncentiveSelect=='NO'?0:math.max((SettlementFigureNBV-SettlementFigureNewBusiness),0.0)
                            );
                            
            QuoteFiguresToInsert.add(StandardQuoteFigure);
            QuoteFiguresToInsert.add(NewBusinessQuoteFigure);
            QuoteFiguresToInsert.add(OtherQuoteFigure);
            QuoteFiguresToInsert.add(NBVQuoteFigure);
        
            insert QuoteFiguresToInsert;
            displayquotefigures();
            
            accepttermination = true;
            savetermination = false;
            AcceptedTerminationQuote = 'NOT SAVED';
            DateChange = false;
        return null;
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'generateQuoteFigures',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
         }
    }
    
    public void displayquotefigures() {
        if(QuoteFiguresToInsert.size() > 0){
                Set<id> QuoteIds = new Set<Id>();
                for(Termination_Quote_Figures__c TerQuote: QuoteFiguresToInsert){
                    QuoteIds.add(TerQuote.Id);
                }    
                for(Integer idx=0; idx<14; idx++){
                    rows.add(new RowWrapper());                  
                }
                rowLabelsList.add(new RowWrapperLabels('Discount %'));  
                rowLabelsList.add(new RowWrapperLabels('Future Rentals'));
                rowLabelsList.add(new RowWrapperLabels('Discount'));            
                rowLabelsList.add(new RowWrapperLabels('Net Settlement Figure'));
                rowLabelsList.add(new RowWrapperLabels('Net Option To Purchase'));
                rowLabelsList.add(new RowWrapperLabels('Net Rebate of Rentals'));
               // rowLabelsList.add(new RowWrapperLabels('VAT on Rebate of Rentals'));
                rowLabelsList.add(new RowWrapperLabels('Total Net Settlement'));
                rowLabelsList.add(new RowWrapperLabels('VAT On Settlement'));
                //rowLabelsList.add(new RowWrapperLabels('Balance to Pay'));
                rowLabelsList.add(new RowWrapperLabels('Total Gross Settlement'));
                rowLabelsList.add(new RowWrapperLabels('Gross Arrears'));
                rowLabelsList.add(new RowWrapperLabels('BALANCE TO PAY'));
                rowLabelsList.add(new RowWrapperLabels('Profit / Loss'));
                rowLabelsList.add(new RowWrapperLabels('New Business Incentive'));
                rows[0].addValue('Discount %');
                rows[1].addValue('Future Rentals');
                rows[2].addValue('Discount');
                rows[3].addValue('Net Settlement Figure');
                rows[4].addValue('Net Option To Purchase');
                rows[5].addValue('Net Rebate of Rentals');
                //rows[6].addValue('VAT on Rebate of Rentals');
                rows[6].addValue('Total Net Settlement');
                rows[7].addValue('VAT On Settlement');
                //rows[8].addValue('Balance to Pay');
                rows[8].addValue('Total Gross Settlement');
                rows[9].addValue('Gross Arrears');
                rows[10].addValue('BALANCE TO PAY');
                rows[11].addValue('Profit / Loss'); 
                rows[12].addValue('New Business Incentive');
                for(Termination_Quote_Figures__c terQuote : [Select Id,Name,Agreement__c,Discount1__c,Arrears__c,Balance_to_Pay__c,Discount__c,Future_Rentals__c,
                      New_Business_Incentive__c,Option_To_Purchase__c,Profit_Loss__c,Quote_Type__c,Rebate_of_Rentals__c,Settlement_Figure__c,
                      Total_Gross_Settlement__c, Total_Net_Settlement__c,VAT_On_Settlement__c    from Termination_Quote_Figures__c where Id IN: QuoteIds]){
                      //System.debug('terQuote.Future_Rentals__c'+terQuote.Future_Rentals__c);
                      rowwrapperList.add(new RowWrapperStandard(terQuote,false));                  
                      rows[0].addValue(String.valueof(terQuote.Discount1__c));  
                      rows[1].addValue(String.valueof(terQuote.Future_Rentals__c));
                      rows[2].addValue(String.valueof(terQuote.Discount__c));
                      rows[3].addValue(String.valueof(terQuote.Settlement_Figure__c));
                      rows[4].addValue(String.valueof(terQuote.Option_To_Purchase__c));
                      rows[5].addValue(String.valueof(terQuote.Rebate_of_Rentals__c));
                      //rows[6].addValue(String.valueof(terQuote.VAT_on_Rebate_of_Rentals__c));
                      rows[6].addValue(String.valueof(terQuote.Total_Net_Settlement__c));
                      rows[7].addValue(String.valueof(terQuote.VAT_On_Settlement__c));
                      //rows[8].addValue(String.valueof(terQuote.Balance_to_Pay__c));
                      rows[8].addValue(String.valueof(terQuote.Total_Gross_Settlement__c));
                      rows[9].addValue(String.valueof(terQuote.Arrears__c));
                      rows[10].addValue(String.valueof(terQuote.Balance_to_Pay__c));
                      rows[11].addValue(String.valueof(terQuote.Profit_Loss__c));
                      rows[12].addValue(String.valueof(terQuote.New_Business_Incentive__c)); 
                      settlementFigureForNBV = terQuote.Settlement_Figure__c; //This will be updated with NBV settlement figure.
                 }
            }   
        
    }
    
    
    //@@SUBMETHOD to calculate future rentals
    Public Decimal CalculateFutureRentals(List<cllease__Payment_Stream__c> ContractPayments){
        try{
            Decimal futurerentals=0;
            //List<cllease__Payment_Stream__c> ContractPayments = [Select name,cllease__Date__c,cllease__Payment_Type__c,cllease__Beginning_Receivable__c,cllease__Rental_Amount__c FROM cllease__Payment_Stream__c where cllease__Contract__r.name = :termContract.name AND cllease__Payment_Type__c = 'RENT' AND cllease__Date__c > :Expirydate];
            if(ContractPayments.size()>0){
                //system.debug('***Payment Stream total records****' + ContractPayments.size());
                //system.debug('***Payment Stream Details****' + ContractPayments);
                for(cllease__Payment_Stream__c cp: ContractPayments){
                    futurerentals += cp.cllease__Rental_Amount__c;
                }   
            }      
            return futurerentals; 
            } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'CalculateFutureRentals',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            return null;
            }      
    }
    //@@SUBMETHOD to calculate Arrear
    Public Decimal CalculateArrear(){
        try{
            Decimal arrear=0;
            AggregateResult[] bills = [SELECT sum(cllease__Balance_Amount__c) sum FROM cllease__Lease_account_Due_Details__c where cllease__Lease_Account__r.name = :termContract.name AND cllease__Due_Date__c < :Expirydate AND cllease__Status__c != 'Inactive'];
            AggregateResult[] charges = [SELECT sum(cllease__Total_Due_Amount__c) sum FROM cllease__Charge__c where cllease__Lease_Account__r.name = :termContract.name AND cllease__Date__c < :Expirydate];
            If(bills.size()>0){
                arrear = bills[0].get('sum')!=Null?(decimal)bills[0].get('sum'):0;
                //system.debug('****Arrear*****=' + arrear);
            } 
            If(charges.size()>0){
                arrear += charges[0].get('sum')!=Null?(decimal)charges[0].get('sum'):0;
                //system.debug('****Arrear*****=' + arrear);
            }   
            if(termContract.cllease__Excess__c!=Null){
                arrear -= termContract.cllease__Excess__c!=Null?termContract.cllease__Excess__c:0; 
                //system.debug('****Arrear*****=' + arrear);           
            } 
            
            return arrear;
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'CalculateArrear',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            return null;
          }  
    }    
    //@@SUBMETHOD to calculate Settlement figure
    Public Decimal CalculateSettlementFigure(String QuoteType, List<cllease__Payment_Stream__c> ContractPayments){
        try{
            Decimal settlementfigure=0.0;
            If(ContractPayments.size()>0){
                for(cllease__Payment_Stream__c ps: ContractPayments){
                    If(QuoteType == 'Standard'){
                        settlementfigure += ps.Standard_Quote_Stream_Amount__c!=Null?ps.Standard_Quote_Stream_Amount__c:0;
                    }          
                    Else If(QuoteType == 'NewBusiness'){            
                        settlementfigure += ps.New_Business_Quote_Stream_Amount__c!=Null?ps.New_Business_Quote_Stream_Amount__c:0;
                    }
                    Else If(QuoteType == 'NBV'){
                        settlementfigure += ps.NBV_Quote_Stream_Amount__c!=Null?ps.NBV_Quote_Stream_Amount__c:0;
                    }
                    Else If(QuoteType == 'Other'){
                        settlementfigure += ps.Other_Quote_Stream_Amount__c!=Null?ps.Other_Quote_Stream_Amount__c:0;
                    }
                 } 
            }      
        
        return settlementfigure.setScale(2);
        } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'CalculateSettlementFigure',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            return null;
          }
    }
    
    public class RowWrapper{
        // the values (cells) making up this row
         public List<String> values {get; set;}
         public List<Termination_Quote_Figures__c> valuesObj {get; set;}
      
         // constructor
         public RowWrapper(){
              values=new List<String>();
               valuesObj =new List<Termination_Quote_Figures__c>();
         }
      
         // append a value (cell) to the row
         public void addValue(String value){
              values.add(value);
         }
         //public void addValueobj(Termination_Quote_Figures__c value){
         //     valuesObj.add(value);
         //}
    }
    
    public class RowWrapperStandard{   
        public Termination_Quote_Figures__c terQuote {get; set;}
        Public boolean isSelectedQuote {get;set;} 
        public RowWrapperStandard(Termination_Quote_Figures__c terQuote,boolean isSelectedQuote){
           this.terQuote =terQuote;
           this.isSelectedQuote = isSelectedQuote;  
         } 
     }
    public class RowWrapperLabels{   
        Public String rowLabel {get;set;} 
        public RowWrapperLabels(String rowLabel){
           this.rowLabel =rowLabel;
         } 
     }
   
     
    //@Method - Accept Termination Quote
    public pagereference acceptTerminationQuote(){  
        try{          
            boolean quotenotSelected = true;
            pagereference pr;
            cllease__Termination_Quote_Header__c tquoteheader;
            List<cllease__Termination_Quote_Line__c> tquotelines = new List<cllease__Termination_Quote_Line__c>();
            List<cllease__Termination_Quote_Equipment__c> tquoteequipments = new List<cllease__Termination_Quote_Equipment__c>();
            terminationaccepted = false;
        
            //Validations
            for(RowWrapperStandard quote : rowwrapperList){
                if(quote.isSelectedQuote){
                    quotenotSelected = false;
                }        
            }
            if(quotenotSelected){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select the quote!'));
                return null;
            }
            /*    
            else if(AcceptanceDate > Expirydate){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Termination Date can not be after Expiry Date!'));
                return null;
            }
            else if(AcceptanceDate < dateOfQuote){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Termination Date can not be before Date of Quote!'));
                return null;
            }
            */
            else if(DateChange){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please recalculate the quotes, as either Date of Quote or Expiry Date has changed!'));
                return null;
            }
            else{        
                for(RowWrapperStandard quote : rowwrapperList){
                    if(quote.isSelectedQuote){
                        
                        if(ThirdPartySelect=='Yes'){
                            System.debug('Quote Rebate == ' + quote.terQuote.Rebate_of_Rentals__c);
                            System.debug('NetAssetCostSale == ' + NetAssetCostSale);
                            System.debug('RebateRentalPercentage == ' + RebateRentalPercentage);
                            System.debug('L.H.S. == ' + quote.terQuote.Rebate_of_Rentals__c);
                            System.debug('R.H.S. == ' + NetAssetCostSale*(RebateRentalPercentage/100).setScale(2));
                            if(-quote.terQuote.Rebate_of_Rentals__c != (NetAssetCostSale*(RebateRentalPercentage/100)).setScale(2)){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Asset Sale Price has been changed. Please recalculate the quotes'));
                                return null;
                            }
                        }
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Selected Quote is:' + quote.terQuote.Quote_Type__c));
                        quotenotSelected = false;
                        //Update selected quote in Termination Quote Figures Header
                        QuoteFiguresHeader.Quote_Type__c = quote.terQuote.Quote_Type__c;
                        QuoteFiguresHeader.Acceptance_Date__c = AcceptanceDate;
                        update QuoteFiguresHeader;
                        System.debug('QuoteFiguresHeader:'+QuoteFiguresHeader);
                        //Insert Termination Quote Header
                        //Nikhila : Create one field on cllease__Termination_Quote_Header__c to store tax amount, 
                        //Check for transaction amount
                        tquoteheader = new cllease__Termination_Quote_Header__c(
                        cllease__Contract__c = termContract.id,
                        Discount__c = OtherDiscountRate,
                        cllease__Early_Termination__c = true,
                        //cllease__Termination_Date__c = AcceptanceDate.adddays(4),
                        cllease__Termination_Date__c = getEffectiveTerminationDate(),
                        cllease__Full_Termination__c = (FPSelect =='Full')?true:false,
                        cllease__is_Equipment_Termination__c = true,
                        // Jira EMS - 54
                        cllease__Quote_Amount__c = quote.terQuote.Balance_to_Pay__c,
                        //cllease__Quote_Amount__c = quote.terQuote.Balance_to_Pay__c - quote.terQuote.Rebate_of_Rentals__c,
                        //cllease__Quote_Amount__c = quote.terQuote.Total_Net_Settlement__c - quote.terQuote.Rebate_of_Rentals__c,
                        cllease__Effective_From__c = dateOfQuote,
                        cllease__Effective_To__c = termContract.cllease__Next_Due_Generation_Date__c != null? termContract.cllease__Next_Due_Generation_Date__c.addDays(-1): Expirydate,
                        cllease__Quote_Reason__c = QuoteReasonSelect,
                        cllease__Quote_Type__c = quote.terQuote.Quote_Type__c,
                        cllease__Requested_Termination_Date__c = Expirydate,
                        cllease__Third_Party_Sale__c = (ThirdPartySelect=='Yes'),
                        //cllease__Status__c = 'GENERATED',
                        cllease__Rebate_Percentage__c = RebateRentalPercentage,
                        //cllease__Status__c = 'ACCEPTED',
                        cllease__Status__c = 'APPROVED',
                        ThirdPartySaleNetAmt__c = thirdPartySaleNetAmt,
                        ThirdPartySaleVATAmt__c = thirdPartySaleVATAmt,    
                        Termination_Quote_Figures__c=quote.terQuote.id);
                        if(tquoteheader!=null){
                            insert  tquoteheader;
                        }
                
                        //Insert Termination Quote Lines
                        //tquotelines.add(createTerminationQuoteLine(quote.terQuote.Arrears__c,'Arrears',quote.terQuote,tquoteheader,false));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Future_Rentals__c,'Future Rentals',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Discount__c,'Discount',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Settlement_Figure__c,'Net Settlement Figure',quote.terQuote,tquoteheader,true,'LINE',null));
                        if(otpFee != null){
                            tquotelines.add(createTerminationQuoteLine(quote.terQuote.Option_To_Purchase__c ,'Net Option To Purchase',quote.terQuote,tquoteheader,true,'FEE',otpFee));
                        }else{
                            tquotelines.add(createTerminationQuoteLine(quote.terQuote.Option_To_Purchase__c ,'Net Option To Purchase',quote.terQuote,tquoteheader,false,'LINE',null));
                        }
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Rebate_of_Rentals__c,'Net Rebate Amount - Third Party Sale',quote.terQuote,tquoteheader,true,'LINE',null));
                        //tquotelines.add(createTerminationQuoteLine(quote.terQuote.VAT_on_Rebate_of_Rentals__c,'VAT on Rebate of Rentals',quote.terQuote,tquoteheader));
                       // tquotelines.add(createTerminationQuoteLine(quote.terQuote.VAT_On_Settlement__c,'VAT On Settlement',quote.terQuote,tquoteheader,false));
                        //tquotelines.add(createTerminationQuoteLine(quote.terQuote.Balance_to_Pay__c,'Balance to Pay',quote.terQuote,tquoteheader,false));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Total_Net_Settlement__c,'Total Net Settlement',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.VAT_On_Settlement__c,'VAT On Settlement',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Total_Gross_Settlement__c,'Total Gross Settlement',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Arrears__c,'Gross Arrears',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Balance_to_Pay__c,'BALANCE TO PAY',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.Profit_Loss__c,'Profit / Loss',quote.terQuote,tquoteheader,false,'LINE',null));
                        tquotelines.add(createTerminationQuoteLine(quote.terQuote.New_Business_Incentive__c,'New Business Incentive',quote.terQuote,tquoteheader,false,'LINE',null));
                        //tquotelines.add(createTerminationQuoteLine(quote.terQuote.Profit_Loss__c,'Profit / Loss',quote.terQuote,tquoteheader,false));
                        
                        if(tquotelines.size()>0){
                            insert tquotelines;
                        }    
                
                        //Insert Termination Equipments
                        if(SelectedequipmentDetails.size()>0){
                            for(TerminationQuoteAction.Equipment te : SelectedequipmentDetails){
                                tquoteequipments.add(new cllease__Termination_Quote_Equipment__c(
                                cllease__Contract_Equipment__c = te.eqp.id,
                                cllease__Termination_Quote_Header__c = tquoteheader.id
                                ));                    
                            }
                        }        
                        if(tquoteequipments.size()>0){
                            insert tquoteequipments;
                        }  
                        
                        //Update accepted termination quote details in LS Contract
                        termContract.SAF_term_quote_arrears__c = quote.terQuote.Arrears__c;
                        termContract.SAF_term_quote_balance_to_pay__c = quote.terQuote.Balance_to_Pay__c;
                        termContract.SAF_term_quote_discount__c = quote.terQuote.Discount__c;
                        termContract.SAF_term_quote_future_rentals__c = quote.terQuote.Future_Rentals__c;
                        termContract.SAF_term_quote_new_business_incentive__c = quote.terQuote.New_Business_Incentive__c;
                        termContract.SAF_term_quote_option_to_purchase__c = quote.terQuote.Option_To_Purchase__c;
                        termContract.SAF_term_quote_profit_loss__c = quote.terQuote.Profit_Loss__c;
                        termContract.SAF_term_quote_quote_type__c = quote.terQuote.Quote_Type__c;
                        termContract.SAF_term_quote_rebate_of_rentals__c = quote.terQuote.Rebate_of_Rentals__c;
                        termContract.SAF_term_quote_settlement_figure__c = quote.terQuote.Settlement_Figure__c;
                        termContract.SAF_term_quote_total_gross_settlement__c = quote.terQuote.Total_Gross_Settlement__c;
                        termContract.SAF_term_quote_Total_Net_Settlement__c = quote.terQuote.Total_Net_Settlement__c;
                        //termContract.SAF_term_quote_VAT_on_rebate_of_rentals__c = quote.terQuote.VAT_on_Rebate_of_Rentals__c;
                        termContract.SAF_term_quote_VAT_on_settlement__c = quote.terQuote.VAT_On_Settlement__c;
                        update termContract;
                             
                    }                        
                }
                accepttermination = true;
                savetermination = true;
                tquoteheader = [SELECT id, name from cllease__Termination_Quote_Header__c where id=:tquoteheader.id];
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Termination quote('+tquoteheader.name+') has been created successfully.'));
              
                QuoteFiguresHeader.Accepted_Termination_Quote__c = tquoteheader.name;
                QuoteFiguresHeader.Acceptance_Date__c = AcceptanceDate;
                QuoteFiguresHeader.Asset_Sale_Process1__c = 'Completed';
                update QuoteFiguresHeader;
                terminationaccepted = true;
                AcceptedTerminationQuote = tquoteheader.name;
                calculatequote = true;
                /*
                String terminationURL = '/'+tquoteheader.Id;
                PageReference ref = new PageReference(terminationURL);
                ref.setRedirect(true);
                return ref;
                */
       } 
       /*
       if(terminationaccepted==false){
           PageReference pageRef = ApexPages.currentPage();
           return pageRef;
       }
       else {     
           return new PageReference('javascript:window.close()');           
       }  
       */
       return null;  
       } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'acceptTerminationQuote',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
          }
     }
     
     //@@Submethod to create termination quoteline
     public cllease__Termination_Quote_Line__c createTerminationQuoteLine(Decimal amount, String label, Termination_Quote_Figures__c quotefigure, cllease__Termination_Quote_Header__c quoteheader,
                                                                          Boolean billable, String amountType,
                                                                          Id feeId){
         Try{
             return(new cllease__Termination_Quote_Line__c(
                    //cllease__Account_Balance_Type__c = 'LEASE RECEIVABLE',
                    cllease__Add_To_Quote_Amount__c = true,
                    cllease__Amount__c = amount,
                    cllease__Amount_Type__c = amountType,
                    cllease__Billable__c = billable,
                    cllease__Is_Account_Balancable__c = false,
                    cllease__Line_Type__c = (feeId != null)? otpFeeName : label, 
                    Quote_App_Type__c = quotefigure.Quote_Type__c,
                    cllease__Quote_Header__c = quoteheader.id,
                    cllease__Fee_Definition__c = feeId
             ));
          } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'createTerminationQuoteLine',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            return null;
          }   
     
     }

     public Date getEffectiveTerminationDate(){
        List<cllease__Payment_Stream__c> paymentStream = [Select Id,
                                                                 cllease__Date__c
                                                          From cllease__Payment_Stream__c
                                                          Where cllease__Date__c >= :Expirydate
                                                                And cllease__Contract__c =: termCOntract.Id
                                                                And cllease__Payment_Type__c = 'RENT'
                                                          order by cllease__Date__c
                                                          limit 1];
        if(paymentStream.size() > 0){
            return paymentStream[0].cllease__Date__c;
        }else{
            return termContract.cllease__Maturity_Date__c;
        }
    }
     
     //@Method to Save Quote Details
     public pagereference saveQuoteDetails(){  
        try{
            boolean quotenotSelected = true;
            String contractid = String.valueOf(termContract.id).substring(0, 15);
            system.debug('*************Contract ID*****************' + contractid);
            termquoteheader_rec = [SELECT count() FROM Termination_Quote_Figures_Header__c where Agreement__c = :termContract.name];
            List<TerminationQuoteAction.Equipment> SelectedEquipmentLst = new List<TerminationQuoteAction.Equipment>();
            String Equipments='';            
            for(TerminationQuoteAction.Equipment te : equipmentDetails){               
                   if(te.isSelected==true){
                        SelectedEquipmentLst.add(te);
                        Equipments =  Equipments +  ',' + te.eqp.name;                      
                   }                                          
            }
            Equipments=Equipments.removeStart(',');
            system.debug('******List of Equipments*****:' + Equipments);
            for(RowWrapperStandard quote : rowwrapperList){
                if(quote.isSelectedQuote){
                    quotenotSelected = false;
                    QuteSelect = quote.terQuote.Quote_Type__c;
                }        
            }
            
            if(quotenotSelected){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select the quote!'));
            }  
            /* 
            else if(AcceptanceDate > Expirydate){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Acceptance Date can not be after Expiry Date!'));
            }
            else if(AcceptanceDate < dateOfQuote){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Acceptance Date can not be before Date of Quote!'));
            }
            */
            else if(DateChange){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please recalculate the quotes, as either Date of Quote or Expiry Date has changed!'));
            }
            else if((SelectedEquipmentLst.size()==0) || (!SelectedEquipmentLst.equals(SelectedequipmentDetails))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Equipment selection has changed, please re-calculate quotes!'));
            }  
            else{
                AcceptedTerminationQuote = 'LOCKED';                 
                if(termquoteheader_rec>0){                    
                   system.debug('*************No. of records in quote header*****:' + termquoteheader_rec);
                   QuoteFiguresHeader = [SELECT id,name,X3rd_Party_Sale__c,Acceptance_Date__c,Agreement__c,Date_of_Quote__c,Discount1__c,
                                  Expiry_Date__c,FPOptions__c,Asset_Sale_Process1__c,New_Business__c,Other_Settlement_Amount__c,Product_Type__c,Customer_Name__c,
                                  Quote_Reason__c,Quote_Type__c,Rebate_Rental_Amount__c,Rebate_Rental_Percentage__c,Sale_Amount__c,
                                  Selected_Equipments__c FROM Termination_Quote_Figures_Header__c where Agreement__c = :termContract.name AND id = :quoteheaderid LIMIT 1];
                    
                    //QuoteFiguresHeader.Contract__c = contractid;
                    QuoteFiguresHeader.Agreement__c = termContract.Name;
                    QuoteFiguresHeader.Customer_Name__c = termContract.cllease__Account__r.name;
                    QuoteFiguresHeader.Product_Type__c = termContract.cllease__Lease_Product_Name__r.name;
                    QuoteFiguresHeader.Date_of_Quote__c = dateOfQuote;
                    QuoteFiguresHeader.Quote_Type__c = QuteSelect;
                    QuoteFiguresHeader.Quote_Reason__c = QuoteReasonSelect;
                    QuoteFiguresHeader.FPOptions__c = FPSelect;
                    QuoteFiguresHeader.Expiry_Date__c = Expirydate;
                    QuoteFiguresHeader.Discount1__c = OtherDiscountRate;
                    QuoteFiguresHeader.New_Business__c = NewBusIncentiveSelect;
                    QuoteFiguresHeader.Acceptance_Date__c = AcceptanceDate;
                    QuoteFiguresHeader.Other_Settlement_Amount__c = OtherSettlementAmount;
                    QuoteFiguresHeader.X3rd_Party_Sale__c = ThirdPartySelect.capitalize();
                    QuoteFiguresHeader.Sale_Amount__c = SaleAmount;
                    QuoteFiguresHeader.Rebate_Rental_Percentage__c = RebateRentalPercentage;
                    QuoteFiguresHeader.Rebate_Rental_Amount__c = RebateRentalAmount;
                    QuoteFiguresHeader.Selected_Equipments__c = Equipments;
                    QuoteFiguresHeader.Accepted_Termination_Quote__c = AcceptedTerminationQuote;
                    update QuoteFiguresHeader;
                }
                else{
                    QuoteFiguresHeader = new Termination_Quote_Figures_Header__c();
                    //QuoteFiguresHeader.Contract__c = contractid;
                    QuoteFiguresHeader.Agreement__c = termContract.Name!=null?termContract.Name:'';
                    QuoteFiguresHeader.Customer_Name__c = termContract.cllease__Account__r.name!=null?termContract.cllease__Account__r.name:'';
                    QuoteFiguresHeader.Product_Type__c = termContract.cllease__Lease_Product_Name__r.name;
                    QuoteFiguresHeader.Date_of_Quote__c = dateOfQuote;
                    QuoteFiguresHeader.Quote_Type__c = QuteSelect;
                    QuoteFiguresHeader.Quote_Reason__c = QuoteReasonSelect;
                    QuoteFiguresHeader.FPOptions__c = FPSelect;
                    QuoteFiguresHeader.Expiry_Date__c = Expirydate;
                    QuoteFiguresHeader.Discount1__c = OtherDiscountRate;
                    QuoteFiguresHeader.New_Business__c = NewBusIncentiveSelect;
                    QuoteFiguresHeader.Acceptance_Date__c = AcceptanceDate;
                    QuoteFiguresHeader.Other_Settlement_Amount__c = OtherSettlementAmount;
                    QuoteFiguresHeader.X3rd_Party_Sale__c = ThirdPartySelect.capitalize();
                    QuoteFiguresHeader.Sale_Amount__c = SaleAmount;
                    QuoteFiguresHeader.Rebate_Rental_Percentage__c = RebateRentalPercentage;
                    QuoteFiguresHeader.Rebate_Rental_Amount__c = RebateRentalAmount;
                    QuoteFiguresHeader.Selected_Equipments__c = Equipments;
                    QuoteFiguresHeader.Accepted_Termination_Quote__c = AcceptedTerminationQuote;                                        
                    insert QuoteFiguresHeader;
                }        
                //Update id of quoteheader into quotefigures
                if(QuoteFiguresToInsert.size()>0){
                    for(Termination_Quote_Figures__c qf : QuoteFiguresToInsert){
                        qf.Termination_Quote_Header__c = QuoteFiguresHeader.id;
                    }
                    update QuoteFiguresToInsert;
                }        
                 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Record saved successfully!'));
                accepttermination = false;
                savetermination = true;                
            }    
            return null;
       } catch(Exception e){
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                'saveQuoteDetails',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
          }
     }

    // EMS - 54
    Public void InvoiceSaleAmount(){
        if(ThirdPartySelect=='Yes'){
            try{
            SelectedequipmentDetails = new List<TerminationQuoteAction.Equipment>();
            Map<Id,Decimal> saleAmount = new Map<Id,Decimal>();
            Set<id> epqid = new Set<id>();
            for(TerminationQuoteAction.Equipment te : equipmentDetails){
                system.debug('te--->'+te);
                if(te.isSelected==true){
                    SelectedequipmentDetails.add(te);
                    epqid.add(te.eqp.id);
                    system.debug('epqid--->'+epqid);
             }
            }
        
            cllease.TerminationQuoteAction terminationAction = new cllease.TerminationQuoteAction();
            List<clcommon__Equipment_Transaction__c> equipmentTxns = terminationAction.getThirdPartySaleDetails(epqid);
            System.debug(LoggingLevel.ERROR, 'Adw: equipmentTxns: '+equipmentTxns);
            Decimal totalTransactionAmout = 0;
                if(equipmentTxns.size()> 0){
                 if(ThirdPartySelect=='Yes') {
                system.debug('Insdie Thirdparty--->');
                 for(clcommon__Equipment_Transaction__c equipTxns : equipmentTxns){
                     totalTransactionAmout += equipTxns.clcommon__Transaction_Amount__c;     
                     //Nikhila: Requery it and fetch tax amount also in some class level variable  and in acceptTermiantionQuoteMethod store
                     //it in some field on Termination_Quote_header__c object (make default to 0) and then create a field on Other Transaction as a formula 
                     //field = Other Transaction's tax amount (sum of all)
                }
                //changes done by Nikhila - starts
                System.debug('equipmentTxns:::::::::::::'+equipmentTxns);
                List<clcommon__Equipment_Transaction__c> equipmentTxnList = [Select Id,clcommon__Transaction_Amount__c,clcommon__Tax_Amount__c
                                                                             from clcommon__Equipment_Transaction__c where 
                                                                             Id IN :equipmentTxns
                                                                             AND clcommon__Transaction_Type__c = 'EQUIPMENT SALE - BILL'];
                for(clcommon__Equipment_Transaction__c equipTxnList : equipmentTxnList){
                    thirdPartySaleVATAmt = thirdPartySaleVATAmt + equipTxnList.clcommon__Tax_Amount__c;
                    thirdPartySaleNetAmt = thirdPartySaleNetAmt + equipTxnList.clcommon__Transaction_Amount__c;
                    system.debug('thirdPartySaleNetAmt--->'+thirdPartySaleNetAmt);
                }
                //changes done by Nikhila - ends
                 NetAssetCostSale = totalTransactionAmout;
                 system.debug('NetAssetCostSale--->'+NetAssetCostSale);
                }   
              
              }
            
        }catch(Exception e){
            
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                                           'createTerminationQuoteLine',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            system.debug('###Error Message :' + new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Line no: '+e.getLineNumber()));
            
            
          }
          disabled = 'true';
        }
    }
    
    // EMS Jira 54/63 Asset Sale Functionality
    
     public Pagereference initiateAssetSale() {
        try{
            QuoteFiguresHeader.Asset_Sale_Process1__c = 'Initiated';
            update QuoteFiguresHeader;
            //disableAssetSaleButton = true;
            string contractName = termContract.name;
            system.debug('QuoteFiguresHeader--->'+QuoteFiguresHeader.Asset_Sale_Process1__c);
            //Id contractId = thirdParty;// TO BE DONE: Store the Contract Id here
            generateAssetSale = true;
            SelectedequipmentDetails = new List<TerminationQuoteAction.Equipment>();
            list<string> epqid = new list<string>();
            list<string> epqName = new list<string>();
            for(TerminationQuoteAction.Equipment te : equipmentDetails){
                if(te.isSelected==true){
                    SelectedequipmentDetails.add(te);
                    epqid.add(te.eqp.id);
                    epqName.add(te.eqp.name);
                    system.debug('epqid---->'+epqid);
                }
            }
            system.debug('SelectedequipmentDetails--->'+SelectedequipmentDetails);
            clcommon__Equipment_Sale_Quote__c saleQuote = new clcommon__Equipment_Sale_Quote__c();
            saleQuote.Name = 'New Asset Sale for '+contractName+'';//TO BE DONE: Add the Sale Quote name here - any text - For eg: Buyer Account Name
            saleQuote.clcommon__Status__c = clcommon.Constants.EQUIPMENT_SALE_QUOTE_STATUS_PENDING;
            saleQuote.clcommon__Sale_Date__c = system.today();// TO BE DONE: Add the Settlement Date here.
            //saleQuote.clcommon__Buyer__c = thirdParty;// TO BE DONE: Add the 'Buyer Account Id' here.
            saleQuote.clcommon__Third_Party_Sale__c = true;
            saleQuote.clcommon__NBV__c = 0;
            saleQuote.clcommon__Sale_Amount__c = 0;
            saleQuote.clcommon__Cost_of_Sale__c = 0;
            saleQuote.clcommon__Tax_Amount__c = 0;
            saleQuote.clcommon__Sale_Profit__c = 0;
            saleQuote.clcommon__Sale_Loss__c = 0;
            saleQuote.Termination_Quote_Figures_Header__c = QuoteFiguresHeader.Id;
            Insert saleQuote;
    
            // Collecting the list of Contract Equipments required for Asset Sale
            Map<Id,cllease__Contract_Equipment__c> ceps = new Map<Id,cllease__Contract_Equipment__c> ([SELECT Id, Name, 
                                                                                                       Net_Asset_Cost__c, //Added by Mohini
                                                                                        cllease__Contract__c, 
                                                                                        cllease__Warehouse_Equipment__c, 
                                                                                        cllease__Warehouse_Equipment__r.clcommon__Equipment_NBV__c, 
                                                                                        cllease__Warehouse_Equipment__r.clcommon__Company__c 
                                                                                        FROM cllease__Contract_Equipment__c 
                                                                                        WHERE id IN : epqid]);
            system.debug('ceps--->'+ceps);
            // TO BE DONE: If only selected Equipment are required to be sold thorugh 'Asset Sale', then please add the same instead of the above query.
            List<clcommon__Equipment_Sale_Quote_Line__c> saleQuoteLineList = new List<clcommon__Equipment_Sale_Quote_Line__c>();
            for(cllease__Contract_Equipment__c cep : ceps.values()) {
                clcommon__Equipment_Sale_Quote_Line__c saleQuoteLine = new clcommon__Equipment_Sale_Quote_Line__c();
                saleQuoteLine.clcommon__Equipment_Sale_Quote__c = saleQuote.Id;
                saleQuoteLine.clcommon__Collateral__c = cep.cllease__Warehouse_Equipment__c;
                saleQuoteLine.name = cep.Name; // added on 08/07/2020 by Nikhila
                saleQuoteLine.clcommon__Company__c = cep.cllease__Warehouse_Equipment__r.clcommon__Company__c;
                //saleQuoteLine.clcommon__Equipment_NBV__c = cep.cllease__Warehouse_Equipment__r.clcommon__Equipment_NBV__c;
                saleQuoteLine.clcommon__Equipment_NBV__c = findEquipmentNBV(cep);//Added by Mohini
               // saleQuoteLine.clcommon__Equipment_Sale_Amount__c = saleQuoteLine.clcommon__Equipment_NBV__c;
                saleQuoteLine.clcommon__Equipment_Sale_Amount__c = 0;
                saleQuoteLine.clcommon__Equipment_Tax_Amount__c = 0;
                saleQuoteLine.clcommon__Equipment_Cost_of_Sale__c = 0; 
                saleQuoteLine.clcommon__Equipment_Sale_Profit__c = 0;
                saleQuoteLine.clcommon__Equipment_Sale_Loss__c = 0;
                saleQuoteLineList.add(saleQuoteLine);
                // updating the Sale Quote Amounts
                saleQuote.clcommon__NBV__c += saleQuoteLine.clcommon__Equipment_NBV__c;
                saleQuote.clcommon__Sale_Amount__c += saleQuoteLine.clcommon__Equipment_Sale_Amount__c;               
                system.debug('saleQuote--->'+saleQuote);                
                System.debug(LoggingLevel.ERROR, 'Adw: saleQuoteLine: '+saleQuoteLine);
            }
            // Updating the rate factor for all the Equipment added
            for (clcommon__Equipment_Sale_Quote_Line__c tempSaleQuoteLine : saleQuoteLineList) {
                tempSaleQuoteLine.clcommon__Equipment_Rate_Factor__c = tempSaleQuoteLine.clcommon__Equipment_NBV__c / saleQuote.clcommon__NBV__c;
            }
            Insert saleQuoteLineList;
            Update saleQuote;
            
            System.debug(LoggingLevel.Error, 'saleQuote : ' + saleQuote);
            // Redirecting to the Asset Sale page in edit mode.        
            PageReference ref = new PageReference('/apex/clcommon__equipmentSale?retURL=true&id=' + saleQuote.id);
            if(ref != null){
                ref.setRedirect(true);
            }
            return ref;
        }catch(Exception e){
           System.debug('Exception : ' + e.getMessage() + 'StackTrace : ' + e.getStackTraceString() );
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Exception : ' + e.getMessage()));
           return null;
       }
    }
    
    public PageReference close(){
        return null;
    }
    
    //Added by Mohini
    private Decimal findEquipmentNBV(cllease__Contract_Equipment__c contractEquipment){
        Decimal totalSelectedEquipmentCost = 0;
        for(TerminationQuoteAction.Equipment te : equipmentDetails){
            if(te.isSelected==true){
                System.debug('Selected Equipment == ' + te.eqp.Net_Asset_Cost__c);
                if(te.eqp.Net_Asset_Cost__c != null){
                    totalSelectedEquipmentCost += te.eqp.Net_Asset_Cost__c;
                }
                System.debug(LoggingLevel.Error , 'totalSelectedEquipmentCost == ' + totalSelectedEquipmentCost);
            }
        }
        System.debug(LoggingLevel.Error , 'totalSelectedEquipmentCost == ' + totalSelectedEquipmentCost);
        Decimal equiProportion = contractEquipment.Net_Asset_Cost__c/totalSelectedEquipmentCost;
        System.debug(LoggingLevel.Error , 'equiProportion == ' + equiProportion);
        System.debug(LoggingLevel.Error,'Equipment Net Asset Cost == ' + contractEquipment.Net_Asset_Cost__c );
        //Decimal settlementFigure = (CalculateSettlementFigure('NBV',getFuturePayments())).setScale(2);
        //System.debug(LoggingLevel.Error, 'settlementFigure == ' + settlementFigure);
        Decimal equipmentNBV = equiProportion*SettlementFigureForNBV;
        System.debug(LoggingLevel.Error, equipmentNBV);
        return equipmentNBV;
    }
    
    private List<cllease__Payment_Stream__c> getFuturePayments(){
        List<cllease__Payment_Stream__c> futurePayments = [Select name,
                                                               cllease__Date__c,
                                                               cllease__Payment_Type__c,
                                                               cllease__Rental_Amount__c,
                                                               Standard_Quote_Stream_Amount__c,
                                                               New_Business_Quote_Stream_Amount__c,
                                                               NBV_Quote_Stream_Amount__c,
                                                               Other_Quote_Stream_Amount__c 
                                                           FROM cllease__Payment_Stream__c 
                                                               where cllease__Contract__r.name = :termContract.name 
                                                               AND (cllease__Payment_Type__c = 'RENT' OR
                                                                    cllease__Payment_Type__c = 'ADVANCE RENT' OR
                                                                    cllease__Payment_Type__c = 'EVERGREEN RENT')
                                                               AND cllease__Date__c >= :Expirydate];
        return futurePayments;
    }
    
    //Once invoice is generated for Equipment Sale Quote then Generate Asset Sale button should be disabled 
    //and Select Asset Sale proceeds button should be enabled  
    private void disableAssetSaleButton(Id quoteFigureHeaderId){
        List<clcommon__Equipment_Sale_Quote__c> saleQuotes = [Select Id 
                                                              from clcommon__Equipment_Sale_Quote__c 
                                                              Where Termination_Quote_Figures_Header__c = :quoteFigureHeaderId AND
                                                               (clcommon__Status__c = 'Invoice Generated' OR 
                                                                clcommon__Status__c = 'Equipment Sale - Processed')];
        if(saleQuotes.size() > 0){
            disableAssetSaleButton = true;
            disableSaleProceeds = false;
        }else{
            disableAssetSaleButton = false;
            disableSaleProceeds = true;
        }
    }
             
}