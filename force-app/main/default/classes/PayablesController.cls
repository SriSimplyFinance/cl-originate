global with Sharing class PayablesController
{
    public List<Dealer_Funding__c> DFRecords{get;set;}
    List<Dealer_Funding__c> selectedDealerFunding = new List<Dealer_Funding__c>();
    List<Saf_CommissionFunding__c> selectedFees = new List<Saf_CommissionFunding__c>();
    public List<dealerFundingwrapper> dealerFundingList {get; set;}
    public List<Saf_CommissionFunding__c> ExpenseFeeList{get; set;}
    public string returnURL = ApexPages.currentPage().getParameters().get('id'); //get the id of current record detail page
    public boolean required{get; set;} 
    public Id Id{get; set;} 
  
    public static Id AgreementId; 
    public Decimal TotalPayableAmnt{get; set;} 
    public Decimal TotalAmntPaid{get; set;} 
    public Decimal TotalAmntRemaining{get; set;} 
    public Decimal TotalPayableAmntComm{get; set;} 
    public Decimal TotalAmntPaidComm{get; set;} 
    public Decimal TotalAmntRemainingComm{get; set;}
    
    public String AgreementName{get; set;}
    public String cParam {get;set;}
    public Boolean DFTrx;
    User userRec = [Select Id,Name, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
    public Date TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
    public PayablesController()
    {
        Id= ApexPages.currentPage().getParameters().get('id');
        system.debug('Id'+Id);
        cllease__Lease_Account__c Agreement = [select id,name,cllease__Lease_Status__c,Total_Amount_Payable__c from cllease__Lease_Account__c  where id=:Id];
        String status = Agreement.cllease__Lease_Status__c;
        if (status =='Active - Good Standing' || status =='Active - Bad Standing' || status =='Active - Matured' || status =='TERMINATED')
            required = false;
        else
            required = true;
        AgreementName = Agreement.name;
       
        GetDealerFundingDet();
        getdealerFunding();
        GetCommissionDet();
        getCommissions();
        TotalPayableAmnt = Agreement.Total_Amount_Payable__c; 
        AggregateResult[] AggregateResult1 = [Select SUM(Dealer_Charges__c) TotalCharges From Dealer_Funding__c  where Contract__r.id=:Id ] ;
        Decimal TotalAmntPaidTmp = (Decimal)AggregateResult1[0].get('TotalCharges');
        if (TotalAmntPaidTmp ==null)
        {
            TotalAmntPaid= 0.0;
        }
        else
        {
            TotalAmntPaid=TotalAmntPaidTmp ;
        }
        TotalAmntRemaining = TotalPayableAmnt-TotalAmntPaid;
        
         AggregateResult[] AggregateResult3 = [Select SUM(cllease__Amount__c)Total From cllease__Contract_Fees__c where cllease__Contract__c =:Id and cllease__Fee_Definition__r.clcommon__Class__c = 'Expense'] ;
         TotalPayableAmntComm =  ((Decimal)AggregateResult3[0].get('Total')) == null ? 0 : (Decimal)AggregateResult3[0].get('Total');
        
         AggregateResult[] AggregateResult2 = [Select SUM(saf_Amount__c) Total From Saf_CommissionFunding__c where LS_Contract__c =:Id ] ;
        Decimal TotalAmntPaidTmp2 = (Decimal)AggregateResult2[0].get('Total');
        if (TotalAmntPaidTmp2 ==null)
        {
            TotalAmntPaidComm= 0.0;
        }
        else
        {
            TotalAmntPaidComm=TotalAmntPaidTmp2 ;
        }
        TotalAmntRemainingComm = TotalPayableAmntComm-TotalAmntPaidComm;
         
    }
    public List<Dealer_Funding__c> GetDealerFundingDet()
    { 
    DFRecords= [select id,Name,CreatedById,LastmodifiedbyId,Contract_Number__c,Contract__r.id,Dealer_Funded__c,Dealer_Charges__c,Bank_Account__r.id,Bank_Account_Reference__c,Account_Number__c,Sort_Code__c,Due_Date__c,Dealer__r.cllease__Party_Type__c,Dealer__r.cllease__Party_Name__r.name,Dealer__r.cllease__Party_Account_Name__r.name,Payment_Mode__r.name,Contract__r.cllease__Account__r.name,Contract__r.cllease__Account__c,Reference__c from Dealer_Funding__c where Contract__r.id=:id]; 
    return DFRecords;
    }
   
    public List<dealerFundingwrapper> getdealerFunding()
    {
       if(dealerFundingList == null) 
       {
       dealerFundingList = new List<dealerFundingwrapper>();
       for(Dealer_Funding__c d :DFRecords)
        {
        dealerFundingList.add(new dealerFundingwrapper(d));
        }
        
    }
    return dealerFundingList;
    }
    
    public List<Saf_CommissionFunding__c> GetCommissionDet()
    { 
        ExpenseFeeList= [select saf_Bank_Account__r.id,saf_Bank_Account_Reference__c,LastmodifiedbyId,saf_Account_Number__c,saf_Sort_Code__c,saf_Reference__c,saf_contractParty__r.cllease__Party_Type__c,saf_contractParty__r.cllease__Party_Account_Name__r.name,Fee_Schedule__r.cllease__Fee_Definition__r.Name,id,Name,CreatedById,saf_Fee_Funded__c,saf_Selected__c,Fee_Schedule__r.Name,saf_Amount__c,saf_Date__c,LS_Contract__c,Payment_Mode__r.Name from Saf_CommissionFunding__c where LS_Contract__c =:id]; 
        return ExpenseFeeList;
    }
   
    public List<Saf_CommissionFunding__c> getCommissions()
    {
       if(ExpenseFeeList == null) 
       {
           ExpenseFeeList= new List<Saf_CommissionFunding__c>();
           for(Saf_CommissionFunding__c d :ExpenseFeeList)
            {
             ExpenseFeeList.add(d);
            }
            
        }
    return ExpenseFeeList;
    }
    public PageReference getSelected()
    {
        for(dealerFundingwrapper dfwrapper : getdealerFunding())
        if(dfwrapper.selected == true)
        {
        selectedDealerFunding.add(dfwrapper.Df);
        }
        
     
        return null;
    }
      
   
      webservice static integer UpdateDealerFundingParty(string contractId,string AppId)
        {
              List<Dealer_Funding__c> lstdealerfund = new List<Dealer_Funding__c>();
            try
            {
            
              
                List<Saf_CommissionFunding__c> lstcomm = new List<Saf_CommissionFunding__c>();
                List<Dealer_Funding__c> lstexist = [select id,Name,CreatedById,Contract_Number__c,Contract__r.id,Dealer_Funded__c,Dealer_Charges__c,Bank_Account__r.id,Bank_Account_Reference__c,Account_Number__c,Sort_Code__c from Dealer_Funding__c where Contract__c =:contractId]; 
                List<cllease__Contract_Parties__c> lstparty = [select id,Name,CreatedById,cllease__Contract__c,cllease__LeaseApplicationNumber__c,cllease__Party_Account_Name__c,cllease__Party_Name__c,cllease__Party_Type__c,Broker_Flag__c,Supplier_Flag__c from cllease__Contract_Parties__c where cllease__Contract__c=:contractId]; // and cllease__Party_Type__c=: 'DEALER'
                List<Saf_CommissionFunding__c> lstexistcomm = [select saf_Bank_Account__r.id,saf_Bank_Account_Reference__c,saf_Account_Number__c,saf_Sort_Code__c,saf_Reference__c,saf_contractParty__r.cllease__Party_Type__c,saf_contractParty__r.cllease__Party_Account_Name__r.name,Fee_Schedule__r.cllease__Fee_Definition__r.Name,id,Name,CreatedById,saf_Fee_Funded__c,saf_Selected__c,Fee_Schedule__r.Name,saf_Amount__c,saf_Date__c,LS_Contract__c,Payment_Mode__r.Name from Saf_CommissionFunding__c where LS_Contract__c =:contractId]; 
                   
                   //Query added on 24/11/2020 for testing new fee
               // cllease__Contract_Fees__c fee = [select id,Name,Pay_To_Account_Id__c,cllease__start_date__c,cllease__Amount__c,cllease__Contract__r.Name,cllease__Fee_Definition__r.Name,cllease__Fee_Definition__r.clcommon__Class__c from cllease__Contract_Fees__c where cllease__Contract__c =:contractId and cllease__Fee_Definition__r.clcommon__Class__c =: 'Expense'];   
                
                  System.debug('lstexist'+lstexist.size()); 
               if(lstexist.size() ==0)
               {  System.debug('lstexist : ' + lstexist);
                 System.debug('AppId: ' + AppId);
                 System.debug('contractId: ' + contractId);
                  
                   for(Invoice__c objInv:[SELECT Total_Asset_Cost__c,Payable_Amount__c,VAT_Amount__c,Id,Name,Application__r.Name,Application__c,Supplier1__c,Supplier1__r.clcommon__Account__c,Deposit_Paid_To_Supplier__c,Invoice_Number__c,Invoice_Due_Date__c,Contract_Party__c,Payment_Mode__c,(Select Id,Name,Amount__c, Payment_Mode1__r.Payment_Mode_CL_Lease__c,Payment_Mode1__c,Supplier__c,Supplier__r.clcommon__Account__c,Reference__c from Application_Payables__r) from Invoice__c where Application__c=: AppId])
                    {   
                                   
                        for(cllease__Contract_Parties__c objparty:lstparty)
                        {
                              System.debug('objInv.Supplier1__c  : ' + objInv.Supplier1__r.clcommon__Account__c);  
                              System.debug('objparty.cllease__Party_Account_Name__c  : ' + objparty.cllease__Party_Account_Name__c);  
                             
                                   
                               for(Application_Payables__c objappPay:objInv.Application_Payables__r)
                                        {   
                                            System.debug('objappPay.Supplier__r.clcommon__Account__c:'+objappPay.Supplier__r.clcommon__Account__c);
                                               System.debug('objparty.cllease__Party_Account_Name__c:'+objparty.cllease__Party_Account_Name__c);
                                               System.debug('objparty.cllease__Party_Type__c:'+objparty.cllease__Party_Type__c);
                                      if(objappPay.Supplier__r.clcommon__Account__c == objparty.cllease__Party_Account_Name__c && objparty.cllease__Party_Type__c == 'DEALER')
                                           {
                                            
                                            Dealer_Funding__c obj = new Dealer_Funding__c();
                                            obj.Dealer__c = objparty.Id;
                                                               
                                            obj.Contract__c = contractId;
                                            //obj.Dealer_Charges__c =objInv.Payable_Amount__c; //Total_Asset_Cost__c + objInv.VAT_Amount__c - objInv.Deposit_Paid_To_Supplier__c;
                                            obj.Reference__c = objInv.Invoice_Number__c;
                                            obj.Due_Date__c = objInv.Invoice_Due_Date__c;
                                           // obj.Payment_Mode__c = (objInv.Payment_Mode__c == null) ? Label.PayablesPaymentMode: objInv.Payment_Mode__c;
                                           /******new changes from given by MN**********/
                                           // obj.Dealer__c = objappPay.Supplier__c;
                                            obj.Reference__c = objappPay.Reference__c;
                                            obj.Dealer_Charges__c =objappPay.Amount__c;
                                            
                                            //Added on 24/11/2020 for testing new fee
                                          /*  if(fee.cllease__Fee_Definition__r.Name != 'Incentive Award (VAT Exempt)')
                                            { }else
                                             obj.Payment_Mode__c = (objappPay.Payment_Mode1__c == null) ? Label.PayablesPaymentMode1: objappPay.Payment_Mode1__r.Payment_Mode_CL_Lease__c; */
                                              
                                              
                                                obj.Payment_Mode__c = (objappPay.Payment_Mode1__c == null) ? Label.PayablesPaymentMode: objappPay.Payment_Mode1__r.Payment_Mode_CL_Lease__c; 
                                           
                                           
                                            /*  (Dealer_Funding__c ).Dealer_Charges__c = Object is Application_Payables__c & the field is Amount__c;  
                                              (Dealer_Funding__c) .Reference__c = Object is Application_Payables__c & the field is Invoice__r.Invoice_Number__c;
                                              (Dealer_Funding__c) .Due_Date__c = Object is Application_Payables__c & the field is Invoice__r.Invoice_Due_Date__c;
                                              (Dealer_Funding__c) .Payment_Mode__c = Object is Application_Payables__c & the field is Payment_Mode1__r.Payment_Mode_CL_Lease__c*/
                                            
        
                                            System.debug('obj.Dealer__c : ' + obj.Dealer__c);  
                                            lstdealerfund.add(obj);
                                        }
                                   }            
                            }   
                         }
                       System.debug('lstdealerfund: ' + lstdealerfund);
                       insert lstdealerfund;
                   }
                   
               if(lstexistcomm.size() ==0)
               {  
                 System.debug('AppId: ' + AppId);
                 System.debug('contractId: ' + contractId);
                   for(cllease__Contract_Fees__c objfee:[select id,Name,Pay_To_Account_Id__c,cllease__start_date__c,cllease__Amount__c,cllease__Contract__r.Name,cllease__Fee_Definition__r.Name,cllease__Fee_Definition__r.clcommon__Class__c from cllease__Contract_Fees__c where cllease__Contract__c =:contractId and cllease__Fee_Definition__r.clcommon__Class__c =: 'Expense'])
                    {   
                                   
                        for(cllease__Contract_Parties__c objparty:lstparty)
                        {
                              System.debug('objparty.cllease__Party_Type__c : ' + objparty.cllease__Party_Type__c);  
                              System.debug('objparty.cllease__Party_Account_Name__c  : ' + objparty.cllease__Party_Account_Name__c);
                              System.debug('objfee.Pay_To_Account_Id__c : ' + objfee.Pay_To_Account_Id__c);    
                                 
                                 ////added condition "&& objfee.cllease__Fee_Definition__r.Name != 'Incentive Award (VAT Exempt)'" on 24/11/2020 for testing new fee  
                                  if(objparty.cllease__Party_Type__c == 'BROKER' && objfee.Pay_To_Account_Id__c == objparty.cllease__Party_Account_Name__c)
                                   {
                                   
                                       system.debug('inside if:' +objfee.Pay_To_Account_Id__c);
                                        Saf_CommissionFunding__c obj = new Saf_CommissionFunding__c();
                                        obj.LS_Contract__c = contractId;
                                        obj.saf_Amount__c = objfee.cllease__Amount__c;
                                        //obj.saf_Reference__c = objfee.Name;
                                        obj.saf_Date__c = objfee.cllease__start_date__c;
                                        obj.Fee_Schedule__c = objfee.Id;
                                        obj.saf_contractParty__c = objparty.Id;
                                        if(objfee.cllease__Fee_Definition__r.Name == 'Incentive Award (VAT Exempt)')
                                        {system.debug('objfee.cllease__Fee_Definition__r.Name:' +objfee.cllease__Fee_Definition__r.Name);
                                         obj.Payment_Mode__c = Label.PayablesPaymentMode1; }
                                        else {
                                        obj.Payment_Mode__c = Label.PayablesPaymentMode; } //'a6S0O0000005Vgg'; 
                                        
                                        System.debug('obj : ' + obj);  
                                        lstcomm.add(obj);   
                                    } 
                                    
                                    //added if loop 24/11/2020 for testing new fee  
                                   /* if(objparty.cllease__Party_Type__c == 'BROKER' && objfee.Pay_To_Account_Id__c == objparty.cllease__Party_Account_Name__c && objfee.cllease__Fee_Definition__r.Name != 'Incentive Award (VAT Exempt)')
                                   {
                                        Saf_CommissionFunding__c obj = new Saf_CommissionFunding__c();
                                        obj.LS_Contract__c = contractId;
                                        obj.saf_Amount__c = objfee.cllease__Amount__c;
                                        //obj.saf_Reference__c = objfee.Name;
                                        obj.saf_Date__c = objfee.cllease__start_date__c;
                                        obj.Fee_Schedule__c = objfee.Id;
                                        obj.Payment_Mode__c = Label.PayablesPaymentMode1; //new fee;
                                        obj.saf_contractParty__c = objparty.Id;
                                        System.debug('obj : ' + obj);  
                                        lstcomm.add(obj);   
                                   } */
                         }   
                      }
                       System.debug('lstcomm : ' + lstcomm );
                       insert lstcomm;
                    }
               
            
           
           }
                 catch(Exception e)
                {   
                   
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ ', Line no: '+e.getLineNumber()));
                    //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
                    //String Priority, Boolean sendEmail, String emailSubject, String emailBody )
                    string strDateFormat = 'ddMMyyyy';
                    string strErrordes = 'Branch Date :' + Date.today()+ e.getMessage() + ', Line no: '+e.getLineNumber();
                    ErrorLogsUtils.createErrorLogs('Failure', 'PayablesController', 
                        'UpdateDealerFundingParty',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
                }
              return lstdealerfund.size();
        }
      public PageReference getSelectedComm()
        {
          
            for(Saf_CommissionFunding__c d :getCommissions())
            if(d.saf_Selected__c== true)
            {
                selectedFees.add(d);
            }
            return null;
        }
    public PageReference redirect()
    {
        String FieldId= Label.ContractFieldId;
        String FieldId1= Label.TotalAmntPaid;
        String FieldId2= Label.TotalAmntRemaining;
        String FieldId3= Label.TotalPayableAmnt;
        String FieldId4= Label.DealerFundingEditUrl;
    
        if (FieldId!=null && FieldId1!=null && FieldId2!=null && FieldId3!=null && FieldId4!=null)
       {
          // PageReference pr = new PageReference('/a9C/e?retURL=/apex/payables?id='+Id+'&'+FieldId+'='+AgreementName  );
          // PageReference pr = new PageReference('/a9C/e?retURL=/apex/payables?id='+Id+'&'+FieldId+'='+AgreementName+'&' + FieldId1 +'='+TotalAmntPaid+'&' + FieldId2 +'='+TotalAmntRemaining+'&' + FieldId3 +'='+TotalPayableAmnt);
           PageReference pr = new PageReference('/'+FieldId4+'?retURL=/apex/payables?id='+Id+'&'+FieldId+'='+AgreementName+'&' + FieldId1 +'='+TotalAmntPaid+'&' + FieldId2 +'='+TotalAmntRemaining+'&' + FieldId3 +'='+TotalPayableAmnt);
           pr.setRedirect(true);
           return pr;
       }
       else
           return null;
    }
    
    public PageReference redirectComm()
    {
    String FieldId=  Label.ContractLookup; // 'CF00N3O000001G09U' ;
    String FieldId1= Label.TotalAmntPaid;
    String FieldId2= Label.TotalAmntRemaining;
    String FieldId3= Label.TotalPayableAmnt;
    String FieldId4= Label.PayablesEditUrl; //'aEH/e';
    
    if (FieldId!=null && FieldId1!=null && FieldId2!=null && FieldId3!=null && FieldId4!=null)
   {
  // PageReference pr = new PageReference('/a9C/e?retURL=/apex/payables?id='+Id+'&'+FieldId+'='+AgreementName  );
  // PageReference pr = new PageReference('/a9C/e?retURL=/apex/payables?id='+Id+'&'+FieldId+'='+AgreementName+'&' + FieldId1 +'='+TotalAmntPaid+'&' + FieldId2 +'='+TotalAmntRemaining+'&' + FieldId3 +'='+TotalPayableAmnt);
   PageReference pr = new PageReference('/'+FieldId4+'?retURL=/apex/payables?id='+Id+'&'+FieldId+'='+AgreementName+'&' + FieldId1 +'='+TotalAmntPaidComm+'&' + FieldId2 +'='+TotalAmntRemainingComm+'&' + FieldId3 +'='+TotalPayableAmntComm);
   pr.setRedirect(true);
   return pr;
   }
   else
   return null;
    }
   public void dealerFundingProcess()
    {   
        boolean checkuser = false;
        List<Dealer_Funding__c> selectedDF = new List<Dealer_Funding__c>();
        for(dealerFundingwrapper dealer: getdealerFunding())
        {
            system.debug('dealer.selected:'+dealer.selected);
          if(dealer.selected == true)                  
           {
               selectedDF.add(dealer.Df);
           }
        }
         if (selectedDF.size() > 0) 
        {
            System.debug('selected dealers are ' + selectedDF);
            List<cllease__Other_Transaction__c> ListOtherTrx = new List<cllease__Other_Transaction__c>();
            List<Dealer_Funding__c > UpdateDealerfunding= new List<Dealer_Funding__c >();
             //List<clcommon__Bank_Account__c>BaLst = new List<clcommon__Bank_Account__c>();
            for(Dealer_Funding__c d1:selectedDF)
            {
             if (d1.Dealer_Funded__c==false && dealerFundingList!=null && d1.LastmodifiedbyId != userRec.Id && d1.Dealer__c != null)
               {
                   cllease__Other_Transaction__c OtherTrx = new cllease__Other_Transaction__c();
                   OtherTrx.cllease__Lease_Account__c = d1.Contract__r.id;
                   OtherTrx.cllease__Transaction_Type__c = 'DEALER FUNDING';
                   OtherTrx.cllease__Dealer_Payable_Amount__c=d1.Dealer_Charges__c;
                   OtherTrx.cllease__Txn_Amt__c = d1.Dealer_Charges__c;
                //   OtherTrx.cllease__Dealer_Name__c = d1.Contract__r.cllease__Account__r.id;
                   OtherTrx.cllease__Dealer_Name__c = d1.Dealer__r.cllease__Party_Account_Name__c;
                   OtherTrx.cllease__Dealer__c =d1.Dealer__r.cllease__Party_Account_Name__c;
                   OtherTrx.cllease__Txn_Date__c= TodaysDate;
                   System.debug('Date entered is:'+TodaysDate);
                   OtherTrx.cllease__Payment_Mode__c = d1.Payment_Mode__c;
                   OtherTrx.cllease__GL_Transaction_Flag__c = true;
                   OtherTrx.Payable__c = d1.id;
                   
                   d1.Dealer_Funded__c=true;
                   //-----------New Rquirement by Edward
                    d1.Due_Date__c=TodaysDate;
                   d1.Date_Funded__c=System.now();
                   /*
                   if(d1.Bank_Account__r.id !=null)
                   {
                   clcommon__Bank_Account__c BA = [select id,Funded__c from clcommon__Bank_Account__c where id=:d1.Bank_Account__r.id];
                   BA.Funded__c =true;
                   BaLst.add(BA);
                   } */
                   System.debug('***dealer Funded value is ' + d1.Dealer_Funded__c);
                   System.debug('***dealer name is ' + d1.name);
                   ListOtherTrx.add(OtherTrx);
                   UpdateDealerfunding.add(d1);
                   DFTrx  =true;
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Dealer Funding records are processed successfully','');
                   ApexPages.addMessage(myMsg);
               }
                  if(d1.LastmodifiedbyId == userRec.Id) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, 'Same User cannot Fund the commission','');
                        ApexPages.addMessage(myMsg);
                        checkuser = true;
                   }              System.debug('Value is ' + d1.Dealer_Funded__c);
           }
       
       insert ListOtherTrx;
       update UpdateDealerfunding;
      // update BaLst;
       }
       Boolean DealerFundFlag =false;
        if (selectedDF.size() == 0) 
       {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Please select at least one Record to process',''));
       }
       else
       {
             for(Dealer_Funding__c d2:selectedDF)
           {
               System.debug('Dealer fund value is ' +d2.Dealer_Funded__c);
               if (d2.Dealer_Funded__c ==true)
               {
                   DealerFundFlag = true;
               }
           }
           if (DealerFundFlag == true && DFTrx==null  && !checkuser)
           {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Selected Records are already Funded','');
               ApexPages.addMessage(myMsg);
               System.debug('Message is ' + myMsg);
           }
       }
   
 }
  List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
  String MyProflieName = PROFILE[0].Name;
  String ProfileId= Label.ProfileId; 
public PageReference FundAll()
    {
    if(ProfileId.contains(MyProflieName))
    {
    dealerFundingProcess();
    PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
    System.debug('PageReference ' + pageRef);
    pageRef.setRedirect(false);
    dealerFundingList= null;
    DFTrx=null;
    ApexPages.getMessages().clear();
    return pageRef; 
    }
    else
    {
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Insufficient Privileges','');
   ApexPages.addMessage(myMsg);
   dealerFundingList= null;
    DFTrx=null;
   return null;
    } 
   
    }  
     public PageReference FundPart()
    {
        if(ProfileId.contains(MyProflieName))
        {
        dealerFundingProcess();
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        System.debug('PageReference ' + pageRef);
        dealerFundingList= null;
        pageRef.setRedirect(false);
        DFTrx=null;
        return pageRef;
         }
        else
        {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Insufficient Privileges','');
        ApexPages.addMessage(myMsg);
        dealerFundingList= null;
        DFTrx=null;
       return null;
        } 
  
    }
    public PageReference FundAllCom()
    {
        if(ProfileId.contains(MyProflieName))
        {
      
        CommissionProcess();
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        System.debug('PageReference ' + pageRef);
        // ExpenseFeeList= null;
        pageRef.setRedirect(false);      
        DFTrx=null;
        ApexPages.getMessages().clear();
        return pageRef; 
        }
        else
        {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Insufficient Privileges','');
           ApexPages.addMessage(myMsg);
           ExpenseFeeList= null;
            DFTrx=null;
       return null;
        } 
   
    }  
  
     public void CommissionProcess()
    {
            List<Saf_CommissionFunding__c> selectedDF = new List<Saf_CommissionFunding__c>();
            boolean checkuser = false;
            for(Saf_CommissionFunding__c obj: getCommissions())
            {
                System.debug('saf_Selected__c'+obj.saf_Selected__c);
              if(obj.saf_Selected__c== true)                  
               {
                   selectedDF.add(obj);
               }
            }
             if (selectedDF.size() > 0) 
            {
                System.debug(':::selected commissions are ' + selectedDF);
                List<cllease__Other_Transaction__c> ListOtherTrx = new List<cllease__Other_Transaction__c>();
                List<Saf_CommissionFunding__c> UpdateDealerfunding= new List<Saf_CommissionFunding__c>();
                 //List<clcommon__Bank_Account__c>BaLst = new List<clcommon__Bank_Account__c>();
            for(Saf_CommissionFunding__c d1:selectedDF)
            {
                   if (d1.saf_Fee_Funded__c == false && ExpenseFeeList!=null && d1.LastmodifiedbyId != userRec.Id && d1.saf_contractParty__c != null)
                   {
                       cllease__Other_Transaction__c OtherTrx = new cllease__Other_Transaction__c();
                       OtherTrx.cllease__Lease_Account__c = d1.LS_Contract__c;
                       OtherTrx.cllease__Transaction_Type__c = 'FUNDING';
                       OtherTrx.cllease__Dealer_Payable_Amount__c=d1.saf_Amount__c;
                       OtherTrx.cllease__Txn_Amt__c=d1.saf_Amount__c;
                       OtherTrx.saf_CommissionFunding__c = d1.Id;
                      // OtherTrx.cllease__Txn_Amt__c = d1.cllease__VAT__c;
                    //   OtherTrx.cllease__Dealer_Name__c = d1.Contract__r.cllease__Account__r.id;
                       OtherTrx.cllease__Dealer_Name__c = d1.saf_contractParty__r.cllease__Party_Account_Name__c;
                       OtherTrx.cllease__Dealer__c =d1.saf_contractParty__r.cllease__Party_Account_Name__c;
                       OtherTrx.cllease__Txn_Date__c= TodaysDate;
                       OtherTrx.cllease__Payment_Mode__c = d1.Payment_Mode__c;
                       OtherTrx.cllease__GL_Transaction_Flag__c = true;
                      // OtherTrx.Payable__c = d1.id;
                       d1.saf_Fee_Funded__c =true;
                       //New requirement by edward
                       d1.saf_Date__c=TodaysDate;
                       /*
                       if(d1.Bank_Account__r.id !=null)
                       {
                       clcommon__Bank_Account__c BA = [select id,Funded__c from clcommon__Bank_Account__c where id=:d1.Bank_Account__r.id];
                       BA.Funded__c =true;
                       BaLst.add(BA);
                       } */
                       System.debug(':::Funded value is ' + d1.saf_Fee_Funded__c );
                       System.debug(':::name is ' + d1.name);
                       ListOtherTrx.add(OtherTrx);
                       UpdateDealerfunding.add(d1);
                       DFTrx  =true;
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Commissions records are processed successfully','');
                       ApexPages.addMessage(myMsg);
                   }
                   if(d1.LastmodifiedbyId == userRec.Id) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, 'Same User cannot Fund the commission','');
                        ApexPages.addMessage(myMsg);
                        checkuser = true;
                   }
            System.debug('Value is ' + d1.saf_Fee_Funded__c + 'd1 :' + d1.CreatedById +'user : ' + userRec.Id);
           }
           
           insert ListOtherTrx;
           update UpdateDealerfunding;
          // update BaLst;
           }
           Boolean DealerFundFlag =false;
            if (selectedDF.size() == 0) 
           {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Please select at least one Record to process',''));
           }
           else
           {
                for(Saf_CommissionFunding__c d2:selectedDF)
               {
                   System.debug('fund value is ' +d2.saf_Fee_Funded__c);
                   if (d2.saf_Fee_Funded__c == true)
                   {
                       DealerFundFlag = true;
                   }
                }
                   if (DealerFundFlag == true && DFTrx==null && !checkuser)
                   {
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Selected Records are already Funded','');
                       ApexPages.addMessage(myMsg);
                       System.debug('Message is ' + myMsg);
                   }
           }
   
 }
    public PageReference deleteCommFunding()
    {
      System.debug('selected dealers are ' + getdealerFunding());
    if(ProfileId.contains(MyProflieName))
    {
      Saf_CommissionFunding__c dealerF= [select Id from Saf_CommissionFunding__c where id=:cParam];
      delete dealerF;
      PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
      System.debug('PageReference ' + pageRef);
      pageRef.setRedirect(true);
      return pageRef;
      }
      else
      {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Insufficient Privileges','');
       ApexPages.addMessage(myMsg);
       return null;
      }
     }
      public PageReference deleteDealerFunding()
    {
      System.debug('selected Comm are ' + getdealerFunding());
    if(ProfileId.contains(MyProflieName))
    {
      Dealer_Funding__c dealerF= [select Id from Dealer_Funding__c where id=:cParam];
      delete dealerF;
      PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
      System.debug('PageReference ' + pageRef);
      pageRef.setRedirect(true);
      return pageRef;
      }
      else
      {
       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Insufficient Privileges','');
       ApexPages.addMessage(myMsg);
       return null;
      }
     } 
    public PageReference Cancel() 
    {
     return new PageReference('/'+returnURL);
    }

    public class dealerFundingwrapper
    {
        public Dealer_Funding__c Df{get; set;}
        public Boolean selected {get; set;}
        
        public dealerFundingwrapper(Dealer_Funding__c d)
        {
            selected = false;
            Df= d;
            
        }
        
    }
}