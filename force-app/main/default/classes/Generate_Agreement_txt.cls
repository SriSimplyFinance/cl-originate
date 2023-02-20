/**
        @ name                      :Phalguni
        @ author                    :Phalguni
        @ description               :Generating cais text file from agreements
        @ created date              :Phalguni Tandel ,  13/03/2018 06:01
        @ Modified by / Date        : Phalguni Tandel ,  10/04/2018 << Putting validation rules and following guidlines for Apex code>>
*/

public class Generate_Agreement_txt
{   
    public Datetime TodaysDate ;
    public Datetime SystemDate = Datetime.Now();
    public string linebreak = '\r\n';
    public String Month {get;set;}
    Public String DocumentName {get;set;}
    Public String strspace = ' ';
    Public String FolderId = '';
    Public Integer TotalContracts = 0;
    Public String strzero = '0';
    public String strHeader ;
    public Transient String strAccount ;
    public String strTrailer ;
    public Transient String strBody {get;set;}
      
    public List<CAIS_setting__c> lstHeader ;
    public Transient List<CAIS_setting__c> lstAccount ;
    public List<CAIS_setting__c> lstTrailer ;
    public List<Document> listdoc {get;set;}
    public ContractFile cFile ;
    public PaymentStreams pst;
    
    public string strDateFormat = 'ddMMyyyy';
    CAIS_settings__c CS = CAIS_settings__c.getOrgDefaults();
        
    public final string PROPRIETOR_PARTNER_DIRECTOR_NUMBER = 'Proprietor/Partner/Director Number';
    public final string COMPANY_REGISTERED_NUMBER_BUSINESS_NUMBER = 'Company Registered Number/Business Number';
    public final string ADDITIONAL_TRADING_STYLE = 'Additional Trading Style';
    public final string BUSINESS_COMPANY_TELEPHONE_NUMBER = 'Business/Company Telephone Number';
    public final string BUSINESS_COMPANY_WEBSITE = 'Business/Company Website';
    public final string POINT_OF_CONTACT_JOB_TITLE = 'Point of Contact Job Title';
    public final string PARENT_COMPANY_NAME_AND_ADDRESS_REGISTERED_OFFICE_TRADING_ADDRESS = 'Parent Company Name and Address/Registered Office/Trading Address';
    public final string PARENT_COMPANY_REGISTERED_NUMBER = 'Parent Company Registered Number';
    public final string PARENT_COMPANY_TELEPHONE_NUMBER = 'Parent Company Telephone Number';
    public final string PREVIOUS_NAME_AND_ADDRESS_REGISTERED_OFFICE_TRADING_ADDRESS = 'Previous Name and Address/Registered Office/Trading Address';
    public final string SIGNATORY_ON_THE_ACCOUNT_FLAG = 'Signatory on the Account Flag';
    public final string TRANSFERRED_TO_COLLECTION_ACCOUNT_FLAG = 'Transferred to Collection Account Flag';
    public final string BALANCE_TYPE = 'Balance Type';
    public final string CREDIT_TURNOVER = 'Credit Turnover';
    public final string BANKER_DETAILS_SORT_CODE = 'Banker Details – Sort Code';
    public final string NUMBER_OF_CREDIT_CARDS_ISSUED = 'Number of Credit Cards issued';
    public final string PAYMENT_AMOUNT = 'Payment Amount';
    public final string PAYMENT_CREDIT_INDICATOR = 'Payment Credit Indicator';
    public final string PRIMARY_ACCOUNT_INDICATOR = 'Primary Account Indicator';
    public final string DEFAULT_SATISFACTION_DATE = 'Default Satisfaction Date';
    public final string REJECTION_FLAG = 'Rejection Flag';
    public final string VALUE_OF_CASH_ADVANCES = 'Value of Cash Advances';
    public final string PAYMENT_CODE = 'Payment Code';
    public final string PROMOTION_ACTIVITY_FLAG = 'Promotion Activity Flag';
    public final string PREVIOUS_STATEMENT_BALANCE = 'Previous Statement Balance';
    public final string PREVIOUS_STATEMENT_BALANCE_INDICATOR = 'Previous Statement Balance Indicator';
    public final string NUMBER_OF_CASH_ADVANCES = 'Number of Cash Advances';
    public final string FILLER3 = 'Filler';
    public final string SIC_CODE = 'SIC Code';
    public final string VAT_NUMBER = 'VAT Number';
    public final string YEAR_BUSINESS_STARTED = 'Year Business Started';
    public final string POINT_OF_CONTACT_NAME = 'Point of Contact Name';
    public final string POINT_OF_CONTACT_EMAIL_ADDRESS = 'Point of Contact Email Address';
    public final string POINT_OF_CONTACT_TELEPHONE_NUMBER = 'Point of Contact Telephone Number (including mobile)';
    public final string COUNTRY_OF_REGISTRATION = 'Country of Registration';
    public final string DATE_OF_BIRTH = 'Date of Birth';
    public final string FILLER = 'Filler';
    public final string CREDIT_BALANCE_INDICATOR = 'Credit Balance Indicator';
    public final string SPECIAL_INSTRUCTION_INDICATOR = 'Special Instruction Indicator';
    public final string FLAG_SETTINGS1 = 'Flag Settings1';
    public final string DEBENTURE = 'Debenture';
    public final string AIRTIME_STATUS_FLAG = 'Airtime Status Flag';
    public final string NEW_PROPRIETOR_PARTNER_DIRECTOR_NUMBER = 'New Proprietor/Partner/Director Number';
    public final string PARENT_COMPANY_VAT_NUMBER = 'Parent Company VAT Number';
    public final string FILLER_EXPERIAN_EXPIN_CUSTOMER_PIN = 'Filler / Experian Expin Customer PIN';
    public final string PROPRIETORS_DIRECTORS_GUARANTEE = 'Proprietors/Directors Guarantee';
    public final string NEW_ACCOUNT_NUMBER = 'New Account Number';
    public final string PROPRIETOR_PARTNER_DIRECTOR_OR_OTHER_FLAG = 'Proprietor/Partner/Director or Other Flag';
    public final string SHAREHOLDERS_FLAG = 'Shareholders Flag';
    public final string PROPRIETORS_DIRECTORS_GUARANTEE_CANCELLED_DISCHARGED = 'Proprietors/Directors Guarantee cancelled/discharged';
    public final string MORTGAGE_FLAGS = 'Mortgage Flags';  

    /*Generate the cais file forcurrent month*/
    public void Generate_Agreement_txt()
    {
       try
       {
           strHeader = ''; 
           strAccount = ''; 
           strTrailer = ''; 
           strBody = '';
          
           cFile = new ContractFile();
           pst = new PaymentStreams();
          
           GetHeader();
           GetDocuments();
       }
        catch(Exception e)
        {         
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + 'Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'GetAccount',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
        }
    }
    
    
    /*Displays all cais file from documents*/
      public void GetDocuments()
    {    
 
        //Get the folder ID and all documents from cais file folder
        Folder[] folders  =[select id from Folder where name =: System.Label.Cais_FolderName];
        FolderId =  UserInfo.getUserId();
        if(folders.size() >0 ) {FolderId = folders[0].Id; } // '00l9E000000IHOp'
        //system.debug('folderid :' +FolderId + 'folders.size() :' +folders.size());
            
       listdoc = [Select Id,Name,BodyLength,AuthorId,LastModifiedDate,LastViewedDate from Document WHERE document.FolderId =: folderid order by LastModifiedDate desc Limit 50];
     
     //Get the Current date from CL which we would displaying in Page.
      User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
      TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
      Month = TodaysDate.format('MMMM') + strspace + TodaysDate.format('yyyy'); 
      string Company = userRec.cllease__Current_Branch__c;
    }
    
      /*Downloads the specfied cais file for the User*/
     public void DownloadDoc()
    {
         try 
         {
           string id = Apexpages.currentpage().getparameters().get('Id');
           // string id = '0159E0000007jpVQAQ';
            Document doc = [Select Id,Name,BodyLength,Body,AuthorId,LastModifiedDate,LastViewedDate from Document WHERE Id =: id];
            strbody = doc.body.tostring();
          }  
         catch(Exception e)
            {         
            string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + 'Line no: '+e.getLineNumber();
            ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'GetAccount',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
            }
    }
    
      /*Gets all details from agreements,payment,contacts,accounts and streams and poupate the account record in text file */
   
    public void GetAccount()
    {
       try
       {
        //Get the required Agreements
       
        String strType = 'Account record';
        List<String> strstatus = new String[]{'ACTIVE - GOOD STANDING','ACTIVE - BAD STANDING','TERMINATED','ACTIVE - MATURED'};//'EVERGREEN'
        // string ContId = 'a690O000000gC8k';//Apexpages.currentpage().getparameters().get('eid');
         
         //Get the month and year of Branch date
        Integer IntMon = TodaysDate.month(); 
        Integer Intyear = TodaysDate.year(); 
        
          Integer intLimit = Integer.valueof(System.Label.Cais_Limit); 
         Integer intOffset  = Integer.valueof(System.Label.Cais_offset); 
         
        string strquery = 'SELECT Name,Id,Cais_MonthlyPayment__c,cllease__Days_Past_Due__c,MaxFrequency__c,cllease__Term__c,cllease__Lease_Status__c,cllease__Delinquency_Grace_Days__c,' +
         'cllease__Grace_Period_for_Repayments__c,cllease__Next_Due_Date__c,cllease__Contact__r.Name, cllease__Last_Payment_Date__c,' +
         'cllease__Account__r.BillingStreet,cllease__Account__r.BillingCity ,cllease__Account__r.BillingState ,Current_Balance__c,' +
         'cllease__Account__r.BillingPostalCode ,cllease__Account__r.BillingCountry, cllease__Account__r.Ownership, cllease__Account__r.AccountNumber,' +
         'cllease__Account__r.Name,cllease__Amount_to_Current__c,cllease__Payment_Amount__c,cllease__Lease_Product_Name__r.Name,' +
         'cllease__Contract_Date__c,cllease__Maturity_Date__c,cllease__Account__r.LastModifiedDate, cllease__Account__r.OldAccountName__c,CAIS_TeminationDate__c ' +
         'FROM cllease__Lease_Account__c where cllease__Lease_Status__c =: strstatus LIMIT :intLimit offset :intOffset';
          
          
        List<cllease__Lease_Account__c> Lstcontract = Database.query(strquery);
                             
         TotalContracts = Lstcontract.size();
         system.debug('TotalContracts :'+ TotalContracts);
        
        //Get contacts for Related Agreements 
        /*Set<Id> AccountIds = new Set<Id>();
        for(cllease__Lease_Account__c objAgreement:Lstcontract) { AccountIds.add(objAgreement.cllease__Account__c); }      
        List<Contact> lstcontacts = [SELECT Name,Id,AccountId FROM Contact WHERE AccountId In : AccountIds];
        Map<Id,Contact> mapcontacts= new Map<Id,Contact>();
        for(Contact objc:lstcontacts)    { mapcontacts.put(objc.AccountId,objc);}  */ 
        
        //Get all Lpts for agreements          
        Map<Id,cllease__Lease_Account__c> mapContIds = new Map<Id,cllease__Lease_Account__c>(Lstcontract);
     
        List<cllease__Lease_Payment_Transaction__c> lstlpts = [SELECT id,Name,cllease__Contract__c,cllease__Transaction_Date__c,cllease__Transaction_Amount__c,
            cllease__Payment_Mode__c,cllease__Payment_Mode__r.Name from cllease__Lease_Payment_Transaction__c 
            where CALENDAR_MONTH(cllease__Transaction_Date__c) =:IntMon and CALENDAR_YEAR(cllease__Transaction_Date__c) =: Intyear and 
            cllease__Contract__c In : mapContIds.keyset() order by cllease__Transaction_Date__c desc];
        
         Map<Id,cllease__Lease_Payment_Transaction__c> mapLptIds = new Map<Id,cllease__Lease_Payment_Transaction__c>();
         //cllease__Lease_Payment_Transaction__c lpt = new cllease__Lease_Payment_Transaction__c();
        for(cllease__Lease_Payment_Transaction__c objlpt:lstlpts){ mapLptIds.put(objlpt.cllease__Contract__c,objlpt); } 
        //system.debug('mapLptIds:'+ mapLptIds);
        
        //Get all payment streams for the agreements*****************************************************************
      /*  string paymenttype = '%RENT%';
         List<cllease__Payment_Stream__c> lstpst = [SELECT id,Name,cllease__Active__c,cllease__Rental_Amount__c,cllease__Beginning_Receivable__c,cllease__Billed__c,
         cllease__Contract__c,cllease__Contract_Fee__c, cllease__Date__c ,cllease__Date_Billed__c,cllease__Ending_Receivable__c,  cllease__Frequency__c ,
         cllease__Payment_Date__c,cllease__Payment_Type__c,cllease__Period_End_Date__c,cllease__Period_Start_Date__c,cllease__Schedule_Sequence__c,
         cllease__Transaction_Sub_Type__c  from cllease__Payment_Stream__c 
         where CALENDAR_MONTH(cllease__Date__c) =:IntMon and CALENDAR_YEAR(cllease__Date__c) =: Intyear and 
         cllease__Contract__c In : mapContIds.keyset() and cllease__Active__c =: true and cllease__Payment_Type__c like: paymenttype];
         
          Map<Id,PaymentStreams> mapPstIds = new Map<Id,PaymentStreams>();
         
           
          // populate the streams in map related to the agreement.This calulates the monthly payment amount for the particular agreement
          for(cllease__Payment_Stream__c objpst:lstpst){ 
              pst = new PaymentStreams();
              pst.Monthlypayment = objpst.cllease__Rental_Amount__c ;
              pst.Frequency = objpst.cllease__Frequency__c;
                           
              if(mapPstIds.containskey(objpst.cllease__Contract__c)) {
               pst.monthlypayment =pst.Monthlypayment + mapPstIds.get(objpst.cllease__Contract__c).monthlypayment;
               }
               
              
              mapPstIds.put(objpst.cllease__Contract__c,pst); 
              
          } end of payment streams*********************************************************************************************************
       */
     
          //Get cais settings for Account 
          lstAccount = [SELECT Name,Id,Description__c,ISFixed__c,Data_Type__c,Starting_Byte__c,Value__c,Type__c,IsLeftAligned__c,Ending_Byte__c,Byte_Length__c, Contents_and_Format__c,ISMandatory__c FROM CAIS_setting__c WHERE  Type__c =: strType order by Sequence_Number__c];
          Map<string,CAIS_setting__c> mapCs = new Map<string,CAIS_setting__c>();
            for(CAIS_setting__c objcs:lstAccount){ 
                 mapCs.put(objcs.Name,objcs); 
              } 
          //system.debug('mapCs:'+ mapCs);
        for(cllease__Lease_Account__c contract:Lstcontract) {
  
                   // string contactname = '';
                   // if(mapcontacts.Containskey(contract.cllease__Account__c)) { contactname = mapcontacts.get(contract.cllease__Account__c).Name;}
                    
                    pst = new paymentstreams();
                  /*  if(mappstIds.Containskey(contract.ID)) { pst = mappstIds.get(contract.ID);
                     //system.debug('pst: '+ pst + 'contract.ID'+contract.ID);
                      }*/
                  
                     cllease__Lease_Payment_Transaction__c lpt1 = new cllease__Lease_Payment_Transaction__c();
                    if(mapLptIds.Containskey(contract.ID)) { lpt1 = mapLptIds.get(contract.ID);
                     //system.debug('lpt1 : '+ lpt1 + 'contract.ID'+contract.ID);
                      }
                      
                          
                   strAccount+= GetAccountDetails(contract,mapCs,lpt1,pst) +  '\n';
            }
        }
        catch(Exception e)
        {  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ 'Line no: '+e.getLineNumber()));
       //(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, 
       //String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
       string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + 'Line no: '+e.getLineNumber();
          ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
            'GetAccount',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', '');
   
        }

    } 
     public string GetContentsformat(CAIS_setting__c obhjCs)
     {
      string strContents  =  '';
      if(obhjCs.Contents_and_Format__c.contains(':')) {strContents = obhjCs.Contents_and_Format__c.substringAfter(':');}
      else {strContents = obhjCs.Contents_and_Format__c;}
        return  strContents;       
     }
     
    /*Populates all the details of account record for text file*/   
    public string GetAccountDetails(cllease__Lease_Account__c cl_lease, Map<string,CAIS_setting__c> mapCs ,cllease__Lease_Payment_Transaction__c lpt,Paymentstreams pst)
    { 
       
        String strreturn = '';
        string strchar = strspace;
       // system.debug('cl_lease.cllease__Account__c:'+cl_lease.cllease__Account__c); 
                  
        CAIS_setting__c obja = new CAIS_setting__c();
      
        if(mapCs.containskey(CS.Account_Number__c))
            {
             obja = mapCs.get(CS.Account_Number__c);
             cfile.AccountNumber = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(cl_lease.Name),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);
             //strreturn =  cfile.AccountNumber;             
              
            }
        if(mapCs.containskey(PROPRIETOR_PARTNER_DIRECTOR_NUMBER))
            {
             obja = mapCs.get(PROPRIETOR_PARTNER_DIRECTOR_NUMBER);
             cfile.ProprietorPartnerDirectorNumber =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);  
             //strreturn+=  cfile.ProprietorPartnerDirectorNumber;
               
            }      
        if(mapCs.containskey(CS.Limited_Non_limited_and_Other_Flag__c))
            {
                 obja = mapCs.get(CS.Limited_Non_limited_and_Other_Flag__c);
                 string strContents  =  GetContentsformat(mapCs.get(CS.Limited_Non_limited_and_Other_Flag__c));
                 string strobjValue =  mapCs.get(CS.Limited_Non_limited_and_Other_Flag__c).Value__c;
                  //string strOwner = strContents.substringAfter(':').trim();
                   
                  List<string>  lstOwner = strContents.substringbefore(':').split(',');
                  List<string> lstFlag = strContents.substringAfter(':').split(',');
                 system.debug('cl_lease.cllease__Account__r.Ownership :'+cl_lease.cllease__Account__r.Ownership);            
                 if(!string.IsBlank(cl_lease.cllease__Account__r.Ownership))
                 {
                      if(cl_lease.cllease__Account__r.Ownership.contains(lstOwner[0])) {strobjValue  = lstFlag[0]; } 
                      else if(cl_lease.cllease__Account__r.Ownership == lstOwner[1]) {strobjValue  = lstFlag[1];}
                      else if(cl_lease.cllease__Account__r.Ownership == lstOwner[2]) {strobjValue  = lstFlag[2];}
                      else if(cl_lease.cllease__Account__r.Ownership == lstOwner[3]) {strobjValue  = lstFlag[3];}
                      else {strobjValue  = lstFlag[2];}
                  } else {strobjValue  = lstFlag[2];}
                  
                  //system.debug('Limited_Non_limited_and_Other_Flag__c :'+ strobjValue);  
                  cfile.LimitedNonlimitedandOtherFlag =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                 //strreturn+= cfile.LimitedNonlimitedandOtherFlag;   
                                 

            }
        if(mapCs.containskey(CS.Name_and_Address_Registered_Trading__c))
                {
                  //string contactname =  CheckValue(39,ISBLANK(strContactName),strspace,true); not needed as suggested by Tim day
                   obja = mapCs.get(CS.Name_and_Address_Registered_Trading__c);
                  string strContents  =  GetContentsformat(mapCs.get(CS.Name_and_Address_Registered_Trading__c));
                  List<string> lstaddr = strContents.split(',');
                   //system.debug('lstaddr :'+ lstaddr);
                  string Accountname =  CheckValue(Integer.valueof(lstaddr[0]),ISBLANK(cl_lease.cllease__Account__r.Name),strspace,true,obja.Data_Type__c);
                  string BillingStreet = strspace;
                  if(!string.IsBLank(cl_lease.cllease__Account__r.BillingStreet))
                  { BillingStreet = CheckValue(Integer.valueof(lstaddr[1]),ISBLANK(cl_lease.cllease__Account__r.BillingStreet.replace(linebreak, '')),strspace,true,obja.Data_Type__c);}
                  else {
                  BillingStreet = CheckValue(Integer.valueof(lstaddr[1]),ISBLANK(BillingStreet),strspace,true,obja.Data_Type__c);
                  }
                  string BillingCity =  CheckValue(Integer.valueof(lstaddr[2]),ISBLANK(cl_lease.cllease__Account__r.BillingCity),strspace,true,obja.Data_Type__c);
                  string Billingstate =  CheckValue(Integer.valueof(lstaddr[3]),ISBLANK(cl_lease.cllease__Account__r.BillingState),strspace,true,obja.Data_Type__c);
                  string BillingCountry =  CheckValue(Integer.valueof(lstaddr[4]),ISBLANK(cl_lease.cllease__Account__r.BillingCountry),strspace,true,obja.Data_Type__c);
                  string BillingPostalcode = CheckValue(Integer.valueof(lstaddr[5]),ISBLANK(cl_lease.cllease__Account__r.BillingPostalcode),strspace,true,obja.Data_Type__c);
                   cfile.NameandAddressRegisteredOfficeTradingAddress = Accountname + BillingStreet +BillingCity+Billingstate +BillingCountry +BillingPostalcode;
                  strreturn+= cfile.NameandAddressRegisteredOfficeTradingAddress;

                  ////system.debug('Accountname :'+ Accountname +'Billingstate :' +Billingstate);
                  // //system.debug('strreturn:'+ strreturn +'len :' +strreturn.Length());    
                                                    
                }
          if(mapCs.containskey(CS.Address_Type__c))
                {
                     obja = mapCs.get(CS.Address_Type__c);
                    string strobjValue =  mapCs.get(CS.Address_Type__c).Value__c;
                    cfile.AddressType = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                    //strreturn+= cfile.AddressType; 
                    // //system.debug('strreturn:'+ strreturn +'len :' +strreturn.Length());                    
                }    
            if(mapCs.containskey(CS.Name_Change__c))
                {
                     obja = mapCs.get(CS.Name_Change__c);
                    Datetime dt_lastmonth = TodaysDate.addmonths(-1);
                    Datetime dt_lastmodifieddate = Datetime.valueof(cl_lease.cllease__Account__r.LastModifiedDate);
                     string strobjValue =  mapCs.get(CS.Name_Change__c).Value__c;
                   if(dt_lastmodifieddate  >= dt_lastmonth && !string.IsBlank(cl_lease.cllease__Account__r.OldAccountName__c))
                   {
                    strobjValue = cl_lease.cllease__Account__r.OldAccountName__c;
                   }
                   
                   cfile.NameChange = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                  //system.debug('strreturn:'+ strreturn +'len :' +strreturn.Length());    
                } 
            if(mapCs.containskey(CS.Company_Registered_Number_Business_No__c))
            {
                 obja = mapCs.get(CS.Company_Registered_Number_Business_No__c);
                 string strobjValue = cl_lease.cllease__Account__r.AccountNumber;
            /* if(String.isNotBlank(cl_lease.cllease__Account__r.AccountNumber))
             {
                 if(cl_lease.cllease__Account__r.AccountNumber.trim() == '1') {strobjValue = obja.Value__c;}
             }else {strobjValue = obja.Value__c;}*/
                 if(cfile.LimitedNonlimitedandOtherFlag == 'N')
                 {
                     strobjValue =strzero;
                 }
             
                 cfile.CompanyRegisteredNumberBusinessNumber =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strzero,obja.IsLeftAligned__c,obja.Data_Type__c);                
                system.debug('CompanyRegisteredNumberBusinessNumber :'+ cfile.CompanyRegisteredNumberBusinessNumber);    
            }
            if(mapCs.containskey(SIC_CODE))
            {
                 obja = mapCs.get(SIC_CODE);
                 cfile.SICCode =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(VAT_NUMBER))
            {
              obja = mapCs.get(VAT_NUMBER);
              cfile.VATNumber =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
             if(mapCs.containskey(YEAR_BUSINESS_STARTED))
            {
              obja = mapCs.get(YEAR_BUSINESS_STARTED);
              cfile.YearBusinessStarted =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
            if(mapCs.containskey(ADDITIONAL_TRADING_STYLE))
            {
               obja = mapCs.get(ADDITIONAL_TRADING_STYLE);
               cfile.AdditionalTradingStyle =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
           if(mapCs.containskey(BUSINESS_COMPANY_TELEPHONE_NUMBER))
            {
               obja = mapCs.get(BUSINESS_COMPANY_TELEPHONE_NUMBER);
               cfile.BusinessCompanyTelephoneNumber = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }           
            if(mapCs.containskey(BUSINESS_COMPANY_WEBSITE))
            {
               obja = mapCs.get(BUSINESS_COMPANY_WEBSITE);
               cfile.BusinessCompanyWebsite = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
            if(mapCs.containskey(POINT_OF_CONTACT_NAME))
            {
                  obja = mapCs.get(POINT_OF_CONTACT_NAME);
                 cfile.PointofContactName = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
              if(mapCs.containskey(POINT_OF_CONTACT_EMAIL_ADDRESS))
            {
                  obja = mapCs.get(POINT_OF_CONTACT_EMAIL_ADDRESS);
                  cfile.PointofContactEmailAddress = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
              if(mapCs.containskey(POINT_OF_CONTACT_TELEPHONE_NUMBER))
            {
                  obja = mapCs.get(POINT_OF_CONTACT_TELEPHONE_NUMBER);
                   cfile.PointofContactTelephoneNumber = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
              if(mapCs.containskey(POINT_OF_CONTACT_JOB_TITLE))
            {
                  obja = mapCs.get(POINT_OF_CONTACT_JOB_TITLE);
                     cfile.PointofContactJobTitle = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }   
             if(mapCs.containskey(PARENT_COMPANY_NAME_AND_ADDRESS_REGISTERED_OFFICE_TRADING_ADDRESS))
            {
                  obja = mapCs.get(PARENT_COMPANY_NAME_AND_ADDRESS_REGISTERED_OFFICE_TRADING_ADDRESS);
                   cfile.ParentCompanyNameandAddressRegisteredOfficeTradingAddress = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
            if(mapCs.containskey(PARENT_COMPANY_REGISTERED_NUMBER))
            {
                  obja = mapCs.get(PARENT_COMPANY_REGISTERED_NUMBER);
                  cfile.ParentCompanyRegisteredNumber = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
            if(mapCs.containskey(PARENT_COMPANY_TELEPHONE_NUMBER))
            {
                  obja = mapCs.get(PARENT_COMPANY_TELEPHONE_NUMBER);
                  cfile.ParentCompanyTelephoneNumber= CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
             if(mapCs.containskey(PARENT_COMPANY_VAT_NUMBER))
            {
                  obja = mapCs.get(PARENT_COMPANY_VAT_NUMBER);
                  cfile.ParentCompanyVATNumber = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(PREVIOUS_NAME_AND_ADDRESS_REGISTERED_OFFICE_TRADING_ADDRESS))
            {
                  obja = mapCs.get(PREVIOUS_NAME_AND_ADDRESS_REGISTERED_OFFICE_TRADING_ADDRESS);
                   cfile.PreviousNameandAddressRegisteredOfficeTradingAddress = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(FILLER_EXPERIAN_EXPIN_CUSTOMER_PIN))
            {
                  obja = mapCs.get(FILLER_EXPERIAN_EXPIN_CUSTOMER_PIN);
                   cfile.FillerExperianExpinCustomerPIN = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
             if(mapCs.containskey(PROPRIETOR_PARTNER_DIRECTOR_OR_OTHER_FLAG))
            {
                  obja = mapCs.get(PROPRIETOR_PARTNER_DIRECTOR_OR_OTHER_FLAG);
                  cfile.ProprietorPartnerDirectororOtherFlag = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
             if(mapCs.containskey(SIGNATORY_ON_THE_ACCOUNT_FLAG))
            {
                  obja = mapCs.get(SIGNATORY_ON_THE_ACCOUNT_FLAG);
                  cfile.SignatoryontheAccountFlag = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
             if(mapCs.containskey(SHAREHOLDERS_FLAG))
            {
                  obja = mapCs.get(SHAREHOLDERS_FLAG);
                   cfile.ShareholdersFlag = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(COUNTRY_OF_REGISTRATION))
            {
                  obja = mapCs.get(COUNTRY_OF_REGISTRATION);
                    cfile.CountryofRegistration = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
              if(mapCs.containskey(DATE_OF_BIRTH))
            {
                  obja = mapCs.get(DATE_OF_BIRTH);
                    cfile.DateofBirth = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
              if(mapCs.containskey(PROPRIETORS_DIRECTORS_GUARANTEE))
            {
                  obja = mapCs.get(PROPRIETORS_DIRECTORS_GUARANTEE);
                   cfile.ProprietorsDirectorsGuarantee = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(PROPRIETORS_DIRECTORS_GUARANTEE_CANCELLED_DISCHARGED))
            {
                  obja = mapCs.get(PROPRIETORS_DIRECTORS_GUARANTEE_CANCELLED_DISCHARGED);
                  cfile.ProprietorsDirectorsGuaranteecancelleddischarged = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
              if(mapCs.containskey(FILLER))
            {
                  obja = mapCs.get(FILLER);
                  cfile.Filler = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }   
                                                                             
            if(mapCs.containskey(CS.Account_Type__c))
                {
                    string strcode = '';
                     obja = mapCs.get(CS.Account_Type__c);
                      string strContents  =GetContentsformat(mapCs.get(CS.Account_Type__c));
                      List<string> lstProdType = (strContents.substringBefore(':')).split(',');
                      List<string> lstProdCode = (strContents.substringAfter(':')).split(',');
                      ////system.debug('lstProdType :'+ lstProdType +'lstProdCode :' +lstProdCode);
                        
                     if(cl_lease.cllease__Lease_Product_Name__r.Name == lstProdType[0]) {strcode = lstProdCode[0];} 
                     else if(cl_lease.cllease__Lease_Product_Name__r.Name == lstProdType[1])  {strcode = lstProdCode[1]; } 
                     else if(cl_lease.cllease__Lease_Product_Name__r.Name == lstProdType[2])  {strcode = lstProdCode[2]; } 
                     else if(cl_lease.cllease__Lease_Product_Name__r.Name == lstProdType[3])  {strcode = lstProdCode[3]; } 
                     else {strcode = strzero;}
                     cfile.AccountType =  CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strcode),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                      //system.debug('cfile.AccountType:'+ cfile.AccountType);
                }  
            if(mapCs.containskey(CS.Start_Date_of_Agreement__c))
                {
                      obja = mapCs.get(CS.Start_Date_of_Agreement__c);
                    dateTime dt = cl_lease.cllease__Contract_Date__c;
                    cfile.StartDateofAgreement = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(dt.format(strDateFormat)),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
 
                }
            if(mapCs.containskey(CS.Close_Date_of_Agreement__c))
                {
                    obja = mapCs.get(CS.Close_Date_of_Agreement__c);
                    //requirement change 1 October 2018
                    dateTime dt; //= cl_lease.cllease__Maturity_Date__c;
                    //requirement change -3 aug 2018
                    if(cl_lease.cllease__Lease_Status__c == 'TERMINATED')
                    { dt = cl_lease.CAIS_TeminationDate__c;}
                    else if(cl_lease.cllease__Lease_Status__c == 'ACTIVE - MATURED')
                    { dt = cl_lease.cllease__Maturity_Date__c;}
                    
                    String strdate = strzero;
                    if(dt != null) {strdate = dt.format(strDateFormat);}
                    cfile.CloseDateofAgreement =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strdate),strzero,obja.IsLeftAligned__c,obja.Data_Type__c); 
                    system.debug(' cfile.CloseDateofAgreement:'+  cfile.CloseDateofAgreement);
                }     
             if(mapCs.containskey(CS.Monthly_Payment__c))//clarify if we can take from streamscl_lease.cllease__Payment_Amount__c
                {
                     obja = mapCs.get(CS.Monthly_Payment__c);
                    //string strobjValue = string.valueof(pst.Monthlypayment).substringBefore('.');
                    if(cl_lease.Cais_MonthlyPayment__c ==null) {cl_lease.Cais_MonthlyPayment__c = 0;}
                    string strobjValue = string.valueof(cl_lease.Cais_MonthlyPayment__c).substringBefore('.');
                    cfile.MonthlyPayment = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                    //system.debug('MonthlyPayment:'+ strreturn);
                }
             if(mapCs.containskey(CS.Repayment_Period__c))
                {
                     obja = mapCs.get(CS.Repayment_Period__c);
                    string strobjValue = string.valueof(cl_lease.cllease__Term__c).substringBefore('.');
                    cfile.RepaymentPeriod = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                }     
            if(mapCs.containskey(CS.Current_Balance__c))
                {
                    obja = mapCs.get(CS.Current_Balance__c);
                    string strAmttocurrent = string.valueof(cl_lease.cllease__Amount_to_Current__c).substringBefore('.');
                    string strCurrentbalance = string.valueof(cl_lease.Current_Balance__c).substringBefore('.');
                    string strobjValue = strzero;
                    if(cl_lease.cllease__Lease_Status__c == 'TERMINATED')
                    { strobjValue = strzero;}
                    else
                    {
                        if(cfile.AccountType == '01') {strobjValue = strCurrentbalance;}
                        else {strobjValue = strAmttocurrent;}
                    }
                    cfile.CurrentBalance =  CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);
                    //system.debug('cfile.CurrentBalance :'+ cfile.CurrentBalance);
                }
            if(mapCs.containskey(CREDIT_BALANCE_INDICATOR))
            {
                  obja = mapCs.get(CREDIT_BALANCE_INDICATOR);
                   cfile.CreditBalanceIndicator = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }     
            if(mapCs.containskey(CS.Account_Status__c))
                {
                     obja = mapCs.get(CS.Account_Status__c);
                    string aStatus = strzero;
                   
                   if(cl_lease.cllease__Days_Past_Due__c> cl_lease.cllease__Delinquency_Grace_Days__c)
                    {
                       //Integer dayspastdue = Integer.valueof(cl_lease.cllease__Days_Past_Due__c - cl_lease.cllease__Delinquency_Grace_Days__c);
                       Integer dayspastdue = Integer.valueof(cl_lease.cllease__Days_Past_Due__c);
                       string strContents  = GetContentsformat(mapCs.get(CS.Account_Status__c));
                      List<string> lstdays = (strContents.substringBefore(':')).split(',');
                      List<string> lstStatus = (strContents.substringAfter(':')).split(',');
                       //system.debug('lstdays :'+ lstdays +'lstStatus :' +lstStatus );
                      /* if(dayspastdue > 30 && dayspastdue <= 60)  { aStatus = '1';}
                      else if(dayspastdue > 60 && dayspastdue <= 90)  { aStatus = '2';}
                      else if(dayspastdue > 90 && dayspastdue <= 120)  { aStatus = '3';}
                      else if(dayspastdue > 120 && dayspastdue <= 150)  { aStatus = '4';}
                      else if(dayspastdue > 150 && dayspastdue <= 180)  { aStatus = '5';}
                       else if(dayspastdue > 180 && dayspastdue <= 240)  { aStatus = '6';}
                      else if(dayspastdue > 240)  { aStatus = '8';}
                      */
                      if(dayspastdue > Integer.valueof(lstdays[0]) && dayspastdue <= Integer.valueof(lstdays[1]))  { aStatus = lstStatus[0];}
                      else if(dayspastdue > Integer.valueof(lstdays[1]) && dayspastdue <= Integer.valueof(lstdays[2]))  { aStatus =lstStatus[1];}
                      else if(dayspastdue > Integer.valueof(lstdays[2]) && dayspastdue <= Integer.valueof(lstdays[3]))  { aStatus = lstStatus[2];}
                      else if(dayspastdue > Integer.valueof(lstdays[3]) && dayspastdue <= Integer.valueof(lstdays[4]))  { aStatus = lstStatus[3];}
                      else if(dayspastdue > Integer.valueof(lstdays[4]) && dayspastdue <= Integer.valueof(lstdays[5]))  { aStatus = lstStatus[4];}
                      else if(dayspastdue > Integer.valueof(lstdays[5]) && dayspastdue <= Integer.valueof(lstdays[6]))  { aStatus = lstStatus[5];}
                      else if(dayspastdue >  Integer.valueof(lstdays[6]))  { aStatus = lstStatus[6];}
                      else { aStatus = strzero;}
                     }
                    cfile.AccountStatus = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(string.valueof(aStatus)),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                   //system.debug('cfile.AccountStatus :'+ cfile.AccountStatus);
                }
            if(mapCs.containskey(SPECIAL_INSTRUCTION_INDICATOR ))
                  {  obja = mapCs.get(SPECIAL_INSTRUCTION_INDICATOR);
                     cfile.SpecialInstructionIndicator = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);                     
                  }
           if(mapCs.containskey(CS.Credit_Limit__c))
                  {  obja = mapCs.get(CS.Credit_Limit__c);
                     cfile.CreditLimit = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strzero),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);                     
                  }
            if(mapCs.containskey(FLAG_SETTINGS1))
            {
                  obja = mapCs.get(FLAG_SETTINGS1);
                    cfile.FlagSettings1 = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }   
             if(mapCs.containskey(DEBENTURE))
            {
                  obja = mapCs.get(DEBENTURE);
                   cfile.Debenture = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(MORTGAGE_FLAGS))
            {
                  obja = mapCs.get(MORTGAGE_FLAGS);
                   cfile.MortgageFlags = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(AIRTIME_STATUS_FLAG))
            {
                  obja = mapCs.get(AIRTIME_STATUS_FLAG);
                   cfile.AirtimeStatusFlag = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(TRANSFERRED_TO_COLLECTION_ACCOUNT_FLAG))
            {
                  obja = mapCs.get(TRANSFERRED_TO_COLLECTION_ACCOUNT_FLAG);
                     cfile.TransferredtoCollectionAccountFlag = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
            if(mapCs.containskey(BALANCE_TYPE))
            {
                  obja = mapCs.get(BALANCE_TYPE);
                   cfile.BalanceType = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
            if(mapCs.containskey(CREDIT_TURNOVER))
            {
                  obja = mapCs.get(CREDIT_TURNOVER);
                  cfile.CreditTurnover= CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            } 
             if(mapCs.containskey(PRIMARY_ACCOUNT_INDICATOR))
            {
                  obja = mapCs.get(PRIMARY_ACCOUNT_INDICATOR);
                  cfile.PrimaryAccountIndicator = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }
             if(mapCs.containskey(DEFAULT_SATISFACTION_DATE))
            {
                  obja = mapCs.get(DEFAULT_SATISFACTION_DATE);
                  cfile.DefaultSatisfactionDate = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }   
             if(mapCs.containskey(REJECTION_FLAG))
            {
                  obja = mapCs.get(REJECTION_FLAG);
                  cfile.RejectionFlag = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }  
             if(mapCs.containskey(BANKER_DETAILS_SORT_CODE))
            {
                  obja = mapCs.get(BANKER_DETAILS_SORT_CODE);
                  cfile.BankerDetailsSortCode = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
            }                                                        
           if(mapCs.containskey(CS.Original_Default_Balance__c))
                  {  
                    string strobjValue = '';
                    obja = mapCs.get(CS.Original_Default_Balance__c);
                    if(cfile.AccountStatus == '8') { strobjValue  =string.valueof(Integer.valueof(cfile.CurrentBalance));}
                    else {strobjValue = strzero;}
                   cfile.OriginalDefaultBalance =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c); 
                   //system.debug('cfile.OriginalDefaultBalance :'+ cfile.OriginalDefaultBalance);
                  }
           if(mapCs.containskey(CS.Payment_Frequency_Indicator__c))
                  {  
                     string strfrequncy = '';
                     obja = mapCs.get(CS.Payment_Frequency_Indicator__c);
                       string strContents  = GetContentsformat(mapCs.get(CS.Payment_Frequency_Indicator__c));
                      List<string> lstfreq = (strContents.substringBefore(':')).split(',');
                      List<string> lstStatusfreq = (strContents.substringAfter(':')).split(',');
                      //system.debug('lstfreq :'+ lstfreq +'lstStatusfreq :' +lstStatusfreq );
                      /*
                        else if(pst.Frequency == 'WEEKLY') {strfrequncy = 'W'; }
                     else if(pst.Frequency == 'BI-WEEKLY') {strfrequncy = 'F'; }
                     else if(pst.Frequency == 'ANNUAL') {strfrequncy = 'A'; }
                     else if(pst.Frequency == 'MONTHLY') {strfrequncy = 'M'; }
                     else if(pst.Frequency == 'QUARTERLY') {strfrequncy = 'Q'; }
                     */
                     if(cl_lease.MaxFrequency__c == null) {strfrequncy = strspace; }
                     else if(cl_lease.MaxFrequency__c == lstfreq[0]) {strfrequncy = lstStatusfreq[0]; }
                     else if(cl_lease.MaxFrequency__c == lstfreq[1]) {strfrequncy = lstStatusfreq[1]; }
                     else if(cl_lease.MaxFrequency__c == lstfreq[2]) {strfrequncy = lstStatusfreq[2]; }
                     else if(cl_lease.MaxFrequency__c == lstfreq[3]) {strfrequncy = lstStatusfreq[3]; }
                     else if(cl_lease.MaxFrequency__c == lstfreq[4]) {strfrequncy = lstStatusfreq[4]; }
                     else {strfrequncy = strspace; }
                     system.debug('strfrequncy  :'+ strfrequncy);
                     cfile.PaymentFrequencyIndicator =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strfrequncy),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);  
                   
                  } 
                if(mapCs.containskey(NUMBER_OF_CREDIT_CARDS_ISSUED))
                {
                      obja = mapCs.get(NUMBER_OF_CREDIT_CARDS_ISSUED);
                      cfile.NumberofCreditCardsissued = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                } 
                if(mapCs.containskey(PAYMENT_AMOUNT))
                {
                      obja = mapCs.get(PAYMENT_AMOUNT);
                      cfile.PaymentAmount = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                } 
                if(mapCs.containskey(PAYMENT_CREDIT_INDICATOR))
                {
                      obja = mapCs.get(PAYMENT_CREDIT_INDICATOR);
                        cfile.PaymentCreditIndicator = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                } 
                if(mapCs.containskey(PREVIOUS_STATEMENT_BALANCE))
                {
                      obja = mapCs.get(PREVIOUS_STATEMENT_BALANCE);
                       cfile.PreviousStatementBalance= CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                }   
                if(mapCs.containskey(PREVIOUS_STATEMENT_BALANCE_INDICATOR))
                {
                      obja = mapCs.get(PREVIOUS_STATEMENT_BALANCE_INDICATOR);
                      cfile.PreviousStatementBalanceIndicator = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                }  
                 if(mapCs.containskey(NUMBER_OF_CASH_ADVANCES))
                {
                      obja = mapCs.get(NUMBER_OF_CASH_ADVANCES);
                      cfile.NumberofCashAdvances = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                }
                if(mapCs.containskey(VALUE_OF_CASH_ADVANCES))
                {
                      obja = mapCs.get(VALUE_OF_CASH_ADVANCES);
                       cfile.ValueofCashAdvances = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                }  
                if(mapCs.containskey(PAYMENT_CODE))
                {
                      obja = mapCs.get(PAYMENT_CODE);
                       cfile.PaymentCode = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                }
                 if(mapCs.containskey(PROMOTION_ACTIVITY_FLAG))
                {
                      obja = mapCs.get(PROMOTION_ACTIVITY_FLAG);
                         cfile.PromotionActivityFlag = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                }                 
              if(mapCs.containskey(CS.Payment_Type__c))
                  {  
                      string strname = '';
                      obja = mapCs.get(CS.Payment_Type__c);
                      string strobjValue =  mapCs.get(CS.Payment_Type__c).Value__c;
                      string strContents  = GetContentsformat(mapCs.get(CS.Payment_Type__c));
                      List<string> lstpayment = (strContents.substringBefore(':')).split(',');
                      List<string> lstPayfreq = (strContents.substringAfter(':')).split(',');
                      //system.debug('lstpayment :'+ lstpayment +'lstPayfreq :' +lstPayfreq );
                       
                     if(lpt == null) {strname = strobjValue; }
                     /*   else if(lpt.cllease__Payment_Mode__r.Name == 'Debit Card') {strname = 'B'; }
                     else if(lpt.cllease__Payment_Mode__r.Name == 'Cash') {strname = 'C'; }
                     else if(lpt.cllease__Payment_Mode__r.Name == 'Direct Debit') {strname = 'D'; }
                     else if(lpt.cllease__Payment_Mode__r.Name == 'Cheque') {strname = 'Q'; }
                     else if(lpt.cllease__Payment_Mode__r.Name == 'Standing Order') {strname = 'S'; }
                     else if(lpt.cllease__Payment_Mode__r.Name == 'Credit Card') {strname = 'T'; }
                     */
                                          
                     else if(lpt.cllease__Payment_Mode__r.Name == lstpayment[0]) {strname = lstPayfreq[0]; }
                     else if(lpt.cllease__Payment_Mode__r.Name == lstpayment[1]) {strname = lstPayfreq[1]; }
                     else if(lpt.cllease__Payment_Mode__r.Name == lstpayment[2]) {strname = lstPayfreq[2]; }
                     else if(lpt.cllease__Payment_Mode__r.Name == lstpayment[3]) {strname = lstPayfreq[3]; }
                     else if(lpt.cllease__Payment_Mode__r.Name == lstpayment[4]) {strname = lstPayfreq[4]; }
                     else if(lpt.cllease__Payment_Mode__r.Name == lstpayment[5]) {strname = lstPayfreq[5]; }
                     else {strname = strobjValue; }
                     cfile.PaymentType =CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(strobjValue),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);
                     //system.debug('strname :'+ strname); 
                     //system.debug('cfile.PaymentType :'+ cfile.PaymentType); 
                  }  
                    if(mapCs.containskey(NEW_ACCOUNT_NUMBER))
                {
                      obja = mapCs.get(NEW_ACCOUNT_NUMBER);
                         cfile.NewAccountNumber = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                } 
                  if(mapCs.containskey(NEW_PROPRIETOR_PARTNER_DIRECTOR_NUMBER))
                {
                      obja = mapCs.get(NEW_PROPRIETOR_PARTNER_DIRECTOR_NUMBER);
                       cfile.NewProprietorPartnerDirectorNumber = CheckValue(Integer.valueof(obja.Byte_Length__c),ISBLANK(obja.Value__c),strchar,obja.IsLeftAligned__c,obja.Data_Type__c);              
                }                                                      
                    strreturn = cfile.AccountNumber+
                                cfile.ProprietorPartnerDirectorNumber+
                                cfile.LimitedNonlimitedandOtherFlag+
                                cfile.NameandAddressRegisteredOfficeTradingAddress+
                                cfile.AddressType+
                                cfile.NameChange+
                                cfile.CompanyRegisteredNumberBusinessNumber+
                                cfile.SICCode+
                                cfile.VATNumber+
                                cfile.YearBusinessStarted+
                                cfile.AdditionalTradingStyle+
                                cfile.BusinessCompanyTelephoneNumber+
                                cfile.BusinessCompanyWebsite+
                                cfile.PointofContactName+
                                cfile.PointofContactEmailAddress+
                                cfile.PointofContactTelephoneNumber+
                                cfile.PointofContactJobTitle+
                                cfile.ParentCompanyNameandAddressRegisteredOfficeTradingAddress+
                                cfile.ParentCompanyRegisteredNumber+
                                cfile.ParentCompanyTelephoneNumber+
                                cfile.ParentCompanyVATNumber+
                                cfile.PreviousNameandAddressRegisteredOfficeTradingAddress+
                                cfile.FillerExperianExpinCustomerPIN+
                                cfile.ProprietorPartnerDirectororOtherFlag+
                                cfile.SignatoryontheAccountFlag+
                                cfile.ShareholdersFlag+
                                cfile.CountryofRegistration+
                                cfile.DateofBirth+
                                cfile.ProprietorsDirectorsGuarantee+
                                cfile.ProprietorsDirectorsGuaranteecancelleddischarged+
                                cfile.Filler+
                                cfile.AccountType+
                                cfile.StartDateofAgreement+
                                cfile.CloseDateofAgreement+
                                cfile.MonthlyPayment+
                                cfile.RepaymentPeriod+
                                cfile.CurrentBalance+
                                cfile.CreditBalanceIndicator+
                                cfile.AccountStatus+
                                cfile.SpecialInstructionIndicator+
                                cfile.CreditLimit+
                                cfile.FlagSettings1+
                                cfile.Debenture+
                                cfile.MortgageFlags+
                                cfile.AirtimeStatusFlag+
                                cfile.TransferredtoCollectionAccountFlag+
                                cfile.BalanceType+
                                cfile.CreditTurnover+
                                cfile.PrimaryAccountIndicator+
                                cfile.DefaultSatisfactionDate+
                                cfile.RejectionFlag+
                                cfile.BankerDetailsSortCode+
                                cfile.OriginalDefaultBalance+
                                cfile.PaymentFrequencyIndicator+
                                cfile.NumberofCreditCardsissued+
                                cfile.PaymentAmount+
                                cfile.PaymentCreditIndicator+
                                cfile.PreviousStatementBalance+
                                cfile.PreviousStatementBalanceIndicator+
                                cfile.NumberofCashAdvances+
                                cfile.ValueofCashAdvances+
                                cfile.PaymentCode+
                                cfile.PromotionActivityFlag+
                                cfile.PaymentType+
                                cfile.NewAccountNumber+
                                cfile.NewProprietorPartnerDirectorNumber;
        system.debug('strreturn :'+ strreturn);    
        return strreturn;
      
    }  
    
    /* gets the header record for the text file*/ 
    public void GetHeader()
    {    
      
        String strType = 'Header record';
       lstHeader = [SELECT Name,Id,Description__c,ISFixed__c,Data_Type__c,Starting_Byte__c,Value__c,Type__c,IsLeftAligned__c,Ending_Byte__c,Byte_Length__c, Contents_and_Format__c FROM CAIS_setting__c WHERE  Type__c =: strType order by Sequence_Number__c];
        for(CAIS_setting__c objh:lstHeader) {
            //system.debug('objh:'+ objh.Byte_Length__c+ 'end:'+ objh.Ending_Byte__c);
            
                 if(objh.Name == CS.Date_of_Creation__c)
                {
                  Datetime dt = Datetime.Now();
                 objh.Value__c = dt.format(strDateFormat);
                }
            strHeader +=  CheckValue(Integer.valueof(objh.Byte_Length__c),ISBLANK(objh.Value__c),strspace,objh.IsLeftAligned__c,objh.Data_Type__c);
          
            //system.debug('strHeader: '+ strHeader );
        }
        GetAccount();
        GetTrailer();
        upload();
    }    
    
    /* Validates the value is as per Xperian Format */ 
     public boolean ISValidateString(string strvalue,string Datatype)
    {
        Boolean bln = False;
        
        if(Datatype == 'Number')
        {
            if(strvalue.IsNumeric()) {bln = True;}
        }
        else if(Datatype == 'mAddress')
        { 
            String straddressChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789&@£$€¥*=#%+.,:;- '; 
             if(strvalue.toUpperCase().containsOnly(straddressChars)) {bln = True;}
             
        }
        else if(Datatype == 'Text' || Datatype == 'Address') {bln = True;}
        return bln;    
    }
    
      /* Gets the details of trailer record */ 
    public void GetTrailer()
    {
        String strType = 'Trailer record';
       lstTrailer = [SELECT Name,Id,Description__c,ISFixed__c,Data_Type__c,Starting_Byte__c,Value__c,Type__c,IsLeftAligned__c,Ending_Byte__c,Byte_Length__c, Contents_and_Format__c FROM CAIS_setting__c WHERE  Type__c =: strType order by Sequence_Number__c];
        for(CAIS_setting__c objt:lstTrailer) {
        string strchar = strspace;
        //system.debug('objt:'+ objt.Byte_Length__c+ 'end:'+ objt.Ending_Byte__c);
          if(objt.Name == CS.Total_number_of_records__c)
                {
                 objt.Value__c = String.valueOf(TotalContracts);
                }
        if(objt.Data_Type__c == 'Number') {strchar = strzero;}
        strTrailer +=  CheckValue(Integer.valueof(objt.Byte_Length__c),ISBLANK(objt.Value__c),strchar,objt.IsLeftAligned__c,objt.Data_Type__c);
      
        //system.debug('strTrailer : '+ strTrailer );
        }
      
    }   
    
       /* This methods truncates,rightpad and left pad of string */  
    public string CheckValue(Integer bytelen,string strvalue,string padchar,boolean IsLeftAligned,string strdataType)
    {
     string strgetValue = strvalue;
        if(strdataType == 'Number') {padchar = strzero; }
        if(strgetValue.length()<= bytelen)
        {
            if(IsLeftAligned) {strgetValue = strvalue.rightPad(bytelen,padchar);}
            else{ strgetValue = strvalue.leftPad(bytelen,padchar);}
        }
        else
        { 
        strgetValue = strvalue.substring(0, bytelen);
        }
        
         if(String.isNotBlank(strgetValue))
                  { 
                   if(!ISValidateString(strvalue,strdataType)){
                   string strErrorMsg = (string.valueof(System.Label.Cais_ErrorMessage).replace('objaName','')).replace('objaValue',strvalue);
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,strErrorMsg.replace('contractID','')));
                   //string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) +strErrorMsg;
                   //   ErrorLogsUtils.createErrorLogs('INFO', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 
                   //     'GetAccount',strErrordes, '', '', '', false, ErrorLogsUtils.INFO, false, '', '');
                   }
                   
                   }

      return  strgetValue; 
    }
    
     /* This methods checks for blanks values in string */  
    public string ISBLANK(string strvalue)
    {
      string strreturn;
      if(String.isBlank(strvalue)) {strreturn= strspace; }
      else {strreturn= strvalue; }
      return strreturn;
    }
    
      /* This methods uploads the document in documents folder */  
    public void upload() {
    Document document = new Document();
    document.AuthorId = UserInfo.getUserId();
    DocumentName = 'cais_'+ SystemDate.format('ddMMMyyyy_hhmmss') + '.txt';
    Document.name = DocumentName;
    document.FolderId = FolderId; //UserInfo.getUserId(); // put it in running user's folder
    document.body = blob.valueof(strHeader +'\n' +strAccount+strtrailer);
    //document.name = 'cais.txt';
    insert document;
   
    }
    
    /* Wrapper class for Agreement and Streams*/
 public Class PaymentStreams {
    public Decimal Monthlypayment{get; set;}
    public string Frequency{get; set;}
     public PaymentStreams () {
     
          Monthlypayment = 0;
          Frequency = ' ';
        }
    }
 
    public Class ContractFile {
    public string AccountNumber{get; set;}
    public string ProprietorPartnerDirectorNumber{get; set;}
    public string LimitedNonlimitedandOtherFlag{get; set;}
    public string NameandAddressRegisteredOfficeTradingAddress{get; set;}
    public string AddressType{get; set;}
    public string NameChange{get; set;}
    public string CompanyRegisteredNumberBusinessNumber{get; set;}
    public string SICCode{get; set;}
    public string VATNumber{get; set;}
    public string YearBusinessStarted{get; set;}
    public string AdditionalTradingStyle{get; set;}
    public string BusinessCompanyTelephoneNumber{get; set;}
    public string BusinessCompanyWebsite{get; set;}
    public string PointofContactName{get; set;}
    public string PointofContactEmailAddress{get; set;}
    public string PointofContactTelephoneNumber{get; set;}
    public string PointofContactJobTitle{get; set;}
    public string ParentCompanyNameandAddressRegisteredOfficeTradingAddress{get; set;}
    public string ParentCompanyRegisteredNumber{get; set;}
    public string ParentCompanyTelephoneNumber{get; set;}
    public string ParentCompanyVATNumber{get; set;}
    public string PreviousNameandAddressRegisteredOfficeTradingAddress{get; set;}
    public string FillerExperianExpinCustomerPIN{get; set;}
    public string ProprietorPartnerDirectororOtherFlag{get; set;}
    public string SignatoryontheAccountFlag{get; set;}
    public string ShareholdersFlag{get; set;}
    public string CountryofRegistration{get; set;}
    public string DateofBirth{get; set;}
    public string ProprietorsDirectorsGuarantee{get; set;}
    public string ProprietorsDirectorsGuaranteecancelleddischarged{get; set;}
    public string Filler{get; set;}
    public string AccountType{get; set;}
    public string StartDateofAgreement{get; set;}
    public string CloseDateofAgreement{get; set;}
    public string MonthlyPayment{get; set;}
    public string RepaymentPeriod{get; set;}
    public string CurrentBalance{get; set;}
    public string CreditBalanceIndicator{get; set;}
    public string AccountStatus{get; set;}
    public string SpecialInstructionIndicator{get; set;}
    public string CreditLimit{get; set;}
    public string FlagSettings1{get; set;}
    public string Debenture{get; set;}
    public string MortgageFlags{get; set;}
    public string AirtimeStatusFlag{get; set;}
    public string TransferredtoCollectionAccountFlag{get; set;}
    public string BalanceType{get; set;}
    public string CreditTurnover{get; set;}
    public string PrimaryAccountIndicator{get; set;}
    public string DefaultSatisfactionDate{get; set;}
    public string RejectionFlag{get; set;}
    public string BankerDetailsSortCode{get; set;}
    public string OriginalDefaultBalance{get; set;}
    public string PaymentFrequencyIndicator{get; set;}
    public string NumberofCreditCardsissued{get; set;}
    public string PaymentAmount{get; set;}
    public string PaymentCreditIndicator{get; set;}
    public string PreviousStatementBalance{get; set;}
    public string PreviousStatementBalanceIndicator{get; set;}
    public string NumberofCashAdvances{get; set;}
    public string ValueofCashAdvances{get; set;}
    public string PaymentCode{get; set;}
    public string PromotionActivityFlag{get; set;}
    public string PaymentType{get; set;}
    public string NewAccountNumber{get; set;}
    public string NewProprietorPartnerDirectorNumber{get; set;}
    public ContractFile () {
       //ContractFile cfile = new ContractFile();
          
        }
   
    }
    }