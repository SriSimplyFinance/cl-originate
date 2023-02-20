/**
    @ name                      : Saf_Experian_data_processing
    @ author                    : Happiest Minds/Deepak
    @ description               : To process the experian data into salesforce
    @ created date              : 07-FEB-2019  
*/

global class Saf_Experian_data_processing
{
    public Saf_Experain experian   = new Saf_Experain();
    
    List<SObject> multiObject      = new List<SObject>();
    public Map<String,string> mapcodevalues;
    public String CurrentAccountId;
    
    webservice static String isExperianExists(string CompRegNo, string Accountid)//SAF_Duedil.CustomerInfo csinfo
    {
        //Saf_Experian_data_processing dataProcessing = new Saf_Experian_data_processing();
        //string result = dataProcessing.loadAndProcessExperian(CompRegNo, Accountid);
        List<SAF_Experian_Info__c> exp = [SELECT Id, Name, Account__c, createdDate from SAF_Experian_Info__c where Account__c =: Accountid Order by createdDate DESC Limit 1];
        
        if(CompRegNo == null)
        {
            return 'Experian External Id is blank for this account';
        }
        
        if(exp.size() > 0)
        {
            Date creD = Date.ValueOf(exp[0].createdDate), lastD = Date.ValueOf(System.now());
            
            if(creD.addMonths(3) <= lastD)
            {
                return 'false';
            }
            else
            {
                return 'true';
            }
        }
        else
        {
            return 'false';
        }
        //return result;
    }
    
     webservice static String ExperianUpdate(string CompRegNo, string Accountid,string Ownership)//SAF_Duedil.CustomerInfo csinfo
    {
        Saf_Experian_data_processing dataProcessing = new Saf_Experian_data_processing();
        string result = dataProcessing.loadAndProcessExperian(CompRegNo, Accountid,Ownership);
        return result;
    }
     public String GetExperianCodeValue(string strFieldName, string strCode)
    {
        string strValue = '';
        
        if(mapcodevalues.containskey(strFieldName +strCode))
        {
            strValue = mapcodevalues.get(strFieldName +strCode);
        } 
        
        return strValue;// + ' ' + experian.ResponeMessage; }
    }
     public void StoreExperianCodeValue()
    {
        Saf_Experian_settings__c objsettings = Saf_Experian_settings__c.getOrgDefaults();
        List<Saf_Experian_settings__c> mcs = [select Saf_Code__c, Saf_FieldName__c, Saf_Value__c from Saf_Experian_settings__c];// where Saf_FieldName__c =: strFieldName and Saf_Code__c =:strCode];
      
        mapcodevalues = new Map<String,string>();
         for(Saf_Experian_settings__c obj:mcs)
         {
             mapcodevalues.put(obj.Saf_FieldName__c + obj.Saf_Code__c,obj.Saf_Value__c);
         }
                  
      
    }
    public String loadAndProcessExperian(string CompRegNo, string Accountid,string Ownership)
    {
        String ExperianId;
        try{
            if(Ownership.contains('Limited'))
            {
                experian = Saf_Experain.GetCreditReport(CompRegNo);
                
                system.debug('Experian Master data Limited: '+ experian);
            }
            else{
                experian = Saf_Experain.GetNLCreditReport(CompRegNo);
                system.debug('Experian Master data NL: '+ experian);
            } 
           
            if(experian.ResponeCode == 200)
            {
                CurrentAccountId = Accountid;
                StoreExperianCodeValue();
                ExperianId = this.generateExperianData();
                //return  ExperianId;
            }//'Experian data generated :' +
            else
            {
           
                system.debug('No data '+ experian.ResponeCode);//+ ' ' + experian.ResponeMessage);
                //return 'No data found: '+ experian.ResponeCode;
            }// + ' ' + experian.ResponeMessage; 
        }
        catch(Exception e)
        {   
                             
              system.debug('Experian Master data Limited notes: '+ experian);
              string strDateFormat = 'ddMMyyyy';  
              User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c,cllease__Current_Branch__c from user WHERE id =: UserInfo.getUserId()];
              Datetime TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c; 
              string strErrordes = 'Branch Date :' + TodaysDate.format(strdateformat) + e.getMessage() + ', Line no: '+e.getLineNumber();
              ErrorLogsUtils.createErrorLogs('Experian Data Processing ', 'Saf_Experian_data_processing', 
                'loadAndProcessExperian(Experian)',strErrordes, '', '', '', false, ErrorLogsUtils.ERROR, false, '', ''); 
        }
        if(ExperianId != NULL)
        { return ExperianId;}
        else{
                   Saf_ExperainNotes experianNotes = Saf_Experain.GetAlerts(Saf_Experain.JsonString);
                
                    
                    Saf_Experian_data_processingNotes objData = new Saf_Experian_data_processingNotes();
                    objData.experian = experianNotes;
                    objData.CurrentAccountId = Accountid;
                    
                    ExperianId = objData.generateExperianData(); 
                     if(ExperianId != NULL)
                    { return ExperianId;}
                     else{ return 'No data found: '+ experian.ResponeCode;}
        }
    }
    
    public string generateExperianData()
    {
        //CompRegNo = '11209193';
        
        // Generating Master Experian data 
        SAF_Experian_Info__c experianInfo     = new SAF_Experian_Info__c();
        
        experianInfo.Saf_CommercialName__c    = experian.CommercialName;
        experianInfo.Saf_RegNumber__c         = experian.RegNumber;
        experianInfo.Account__c               = CurrentAccountId;
        
        insert experianInfo;
        this.generateNoticeOfCorrection(experianInfo);
        this.generateDirectorExpandedSummary(experianInfo);
        
        this.generateIdentification(experianInfo);
        this.generateCorporateStructure(experianInfo);
        this.generateManagementInfo(experianInfo);
        this.generateLimitedCompanyCIFAS(experianInfo);
        this.generateLimitedCompanyDelphiDirector(experianInfo);
        this.generateShareholders(experianInfo);
        this.generateCommercialDelphi(experianInfo);
        this.generateFinancialAccounts(experianInfo);
        this.generatecashflows(experianInfo);
        this.generateRatios(experianInfo);
        this.generatePercentageChange(experianInfo);
        this.generateFullQuartiles(experianInfo);
        this.generateMedianQuartiles(experianInfo);
           
        this.GenerateCCJs(experianInfo);
        this.generateCCJDetails(experianInfo);
        this.GenerateMortgages(experianInfo);
        this.generateScoringData(experianInfo);
       
        //LegalNotices
        this.generateAlerts(experianInfo);
        this.GenerateCommercialDelphiHistory(experianInfo);
        this.generateLegalNotices(experianInfo);
        this.generatePaymentPerformance(experianInfo);
        // Information
        this.generateCAISSummary(experianInfo);
        this.generateCAISDetails(experianInfo);
       
              list<sObject> Tenbjects = new list<sObject>();
              list<sObject> Twentyobjects = new list<sObject>();
              list<sObject> Thirtyobjects = new list<sObject>();
              list<sObject> Fortyobjects = new list<sObject>();
              list<sObject> Fiftyobjects = new list<sObject>();  
              list<sObject> sixtyobjects = new list<sObject>();
              list<sObject> seventyobjects = new list<sObject>();
              list<sObject> Eightobjects = new list<sObject>();
              list<sObject> Nintyobjects = new list<sObject>();
              list<sObject> hundredobjects = new list<sObject>();  
              
              list<sObject> hundredTenobjects = new list<sObject>();  
              list<sObject> hundredTwentyobjects = new list<sObject>();  
              list<sObject> hundredThirtyobjects = new list<sObject>();  
              list<sObject> hundredFortyobjects = new list<sObject>();  
              list<sObject> hundredFiftyobjects = new list<sObject>();
              list<sObject> hundredSixtyobjects = new list<sObject>();
              list<sObject> hundredSeventyobjects = new list<sObject>();
              list<sObject> hundredEighthyobjects = new list<sObject>();
              list<sObject> hundredNintyobjects = new list<sObject>();
              list<sObject> TwooHundredobjects = new list<sObject>();
              list<sObject> TwooHundredTenobjects = new list<sObject>();
              list<sObject> TwooHundredTwentyobjects = new list<sObject>();
              list<sObject> TwooHundredThirtyobjects = new list<sObject>();
              list<sObject> TwooHundredFortyobjects = new list<sObject>();
              list<sObject> TwooHundredFiftyobjects = new list<sObject>();
              list<sObject> TwooHundredSixtyobjects = new list<sObject>();
              list<sObject> TwooHundredSeventyobjects = new list<sObject>();
              list<sObject> TwooHundredEightyobjects = new list<sObject>();
              list<sObject> TwooHundredNintyobjects = new list<sObject>();
              list<sObject> ThreeHundredobjects = new list<sObject>();
              list<sObject> ThreeHundredTenobjects = new list<sObject>();
              list<sObject> ThreeHundredTwentyobjects = new list<sObject>();
              list<sObject> ThreeHundredThirtyobjects = new list<sObject>();            
              list<sObject> ThreeHundredFortyobjects = new list<sObject>();
              list<sObject> ThreeHundredFiftyobjects = new list<sObject>();
              list<sObject> ThreeHundredSixtyobjects = new list<sObject>();
              list<sObject> ThreeHundredSeventyobjects = new list<sObject>();
              list<sObject> ThreeHundredEightyobjects = new list<sObject>();
              list<sObject> ThreeHundredNintyobjects = new list<sObject>();
              list<sObject> FourHundredobjects = new list<sObject>();
              system.debug('multiObject.size() :' + multiObject.size());
             if(multiObject.size()>0)
                {
                    integer size = 0 ;
                    for(sObject sob:multiObject)
                    {
                        sObject sObjval = sob ;
                        size++ ;
                        
                        if(size < 11) 
                          { Tenbjects.add(sObjval) ; system.debug('Tenbjects :' + Tenbjects);   
                          }
                        else if(size >= 11 && size < 21)
                          { Twentyobjects.add(sObjval);   //system.debug('Twentyobjects :' + Twentyobjects);  
                            }
                        else if( size >= 21 && size < 31)
                           { Thirtyobjects.add(sObjval);   // system.debug('Thirtyobjects:' + Thirtyobjects);  
                             }
                        else if(size >= 31 && size < 41)
                           { Fortyobjects.add(sObjval);   // system.debug('Fortyobjects:' + Fortyobjects);
                               }
                        else if(size >= 41 && size < 51)
                           { Fiftyobjects.add(sObjval);   // system.debug('Fiftyobjects:' + Fiftyobjects);   
                            }
                         else if(size >= 51 && size < 61)
                           { sixtyobjects.add(sObjval);   // system.debug('sixtyobjects :' + sixtyobjects);  
                             }
                        else if(size >= 61 && size < 71)
                           { seventyobjects.add(sObjval);   //system.debug('seventyobjects:' + seventyobjects); 
                              }
                         else if(size >= 71 && size < 81)
                           { Eightobjects.add(sObjval);   // system.debug('Eightobjects:' + Eightobjects);  
                             }
                         else if(size >= 81 && size < 91)
                           { Nintyobjects.add(sObjval);  // system.debug('Nintyobjects:' + Nintyobjects);  
                             }
                          else if(size >= 91 && size < 101)
                           { hundredobjects.add(sObjval);   // system.debug('hundredobjects:' + hundredobjects);   
                            }
                         else if(size >= 101 && size < 111)
                           { hundredTenobjects.add(sObjval);   //system.debug('hundredTenobjects :' + hundredTenobjects);    
                           }
                          else if(size >= 111 && size < 121)
                           { hundredTwentyobjects.add(sObjval);  //system.debug('hundredTwentyobjects :' + hundredTwentyobjects);    
                           }
                           else if(size >= 121 && size < 131)
                           { hundredThirtyobjects.add(sObjval);  // system.debug('hundredThirtyobjects :' + hundredThirtyobjects);  
                             }
                           else if(size >= 131 && size < 141)
                           { hundredfortyobjects.add(sObjval);  // system.debug('hundredfortyobjects :' + hundredfortyobjects);    
                           }
                           else if(size >= 141 && size < 151)
                           { hundredfiftyobjects.add(sObjval);   // system.debug('hundredfiftyobjects :' + hundredfiftyobjects);  
                             }   
                           else if(size >= 151 && size < 161)
                           { hundredSixtyobjects.add(sObjval);   // system.debug('hundredfiftyobjects :' + hundredfiftyobjects);  
                             }  
                           else if(size >= 161 && size < 171)
                           { hundredSeventyobjects.add(sObjval);   // system.debug('hundredfiftyobjects :' + hundredfiftyobjects);  
                             } 
                           else if(size >= 171 && size < 181)
                           { hundredEighthyobjects.add(sObjval);   // system.debug('hundredfiftyobjects :' + hundredfiftyobjects);  
                            } 
                           else if(size >= 181 && size < 191)
                           { hundredNintyobjects.add(sObjval);   // system.debug('hundredfiftyobjects :' + hundredfiftyobjects);  
                           }
                           else if(size >= 191 && size < 201)
                           { TwooHundredobjects.add(sObjval);   // system.debug('hundredfiftyobjects :' + hundredfiftyobjects);  
                           }
                            else if(size >= 201 && size < 211)
                           { TwooHundredTenobjects.add(sObjval);   // system.debug('TwooHundredTenobjects:' + TwooHundredTenobjects);  
                           }
                           else if(size >= 211 && size < 221)
                           { TwooHundredTwentyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           } 
                           else if(size >= 221 && size < 231)
                           { TwooHundredThirtyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 231 && size < 241)
                           { TwooHundredFortyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           } 
                           else if(size >= 241 && size < 251)
                           { TwooHundredFiftyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 251 && size < 261)
                           { TwooHundredSixtyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 261 && size < 271)
                           { TwooHundredSeventyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 271 && size < 281)
                           { TwooHundredEightyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 281 && size < 291)
                           { TwooHundredNintyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           } 
                           else if(size >= 291 && size < 301)
                           { ThreeHundredobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 301 && size < 311)
                           { ThreeHundredTenobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           } 
                           else if(size >= 311 && size < 321)
                           { ThreeHundredTwentyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           } 
                           else if(size >= 321 && size < 331)
                           { ThreeHundredThirtyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 331 && size < 341)
                           { ThreeHundredFortyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 341 && size < 351)
                           { ThreeHundredFiftyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 351 && size < 361)
                           { ThreeHundredSixtyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 361 && size < 371)
                           { ThreeHundredSeventyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 371 && size < 381)
                           { ThreeHundredEightyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           } 
                           else if(size >= 381 && size < 391)
                           { ThreeHundredNintyobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }
                           else if(size >= 391 && size < 401)
                           { FourHundredobjects.add(sObjval);   // system.debug('TwooHundredTwentyobjects:' + TwooHundredTwentyobjects);  
                           }                                                                         
                    }
                }
               
                 
                  SaveandLogErrors(Tenbjects);
                
                  SaveandLogErrors(Twentyobjects);
                  SaveandLogErrors(Thirtyobjects);
                  SaveandLogErrors(Fortyobjects);
                  SaveandLogErrors(Fiftyobjects); 
                  
                  SaveandLogErrors(sixtyobjects);
                  SaveandLogErrors(seventyobjects );
                  SaveandLogErrors(Eightobjects );
                  SaveandLogErrors(Nintyobjects );
                  SaveandLogErrors(hundredobjects ); 
                  
                  SaveandLogErrors(hundredTenobjects);
                  SaveandLogErrors(hundredTwentyobjects);
                  SaveandLogErrors(hundredThirtyobjects);
                  SaveandLogErrors(hundredfortyobjects);
                  SaveandLogErrors(hundredfiftyobjects); 
                  
                  SaveandLogErrors(hundredSixtyobjects);
                  SaveandLogErrors(hundredSeventyobjects);
                  SaveandLogErrors(hundredEighthyobjects);
                  SaveandLogErrors(hundredNintyobjects);
                  SaveandLogErrors(TwooHundredobjects);
                  SaveandLogErrors(TwooHundredTenobjects);
                  SaveandLogErrors(TwooHundredTwentyobjects);
                  SaveandLogErrors(TwooHundredThirtyobjects);
                  SaveandLogErrors(TwooHundredFortyobjects);
                  SaveandLogErrors(TwooHundredFiftyobjects); 
                  
                  SaveandLogErrors(TwooHundredSixtyobjects);
                  SaveandLogErrors(TwooHundredSeventyobjects);
                  SaveandLogErrors(TwooHundredEightyobjects);
                  SaveandLogErrors(TwooHundredNintyobjects);
                  SaveandLogErrors(ThreeHundredobjects);
                  SaveandLogErrors(ThreeHundredTenobjects);
                  SaveandLogErrors(ThreeHundredTwentyobjects);
                  SaveandLogErrors(ThreeHundredThirtyobjects);
                  SaveandLogErrors(ThreeHundredFortyobjects);
                  SaveandLogErrors(ThreeHundredFiftyobjects);
                  SaveandLogErrors(ThreeHundredSixtyobjects);
                  SaveandLogErrors(ThreeHundredSeventyobjects);
                  SaveandLogErrors(ThreeHundredEightyobjects);
                  SaveandLogErrors(ThreeHundredNintyobjects);
                  SaveandLogErrors(FourHundredobjects);
                // insert multiObject;
              List<Account> lstaccId = [select Id,Name,SAF_Experian_Id__c from Account where Id = : CurrentAccountId limit 1];
              for(Account objacc:lstaccId)
              {
                  objacc.SAF_Experian_Id__c = experianInfo.Id;
                  system.debug('Experian ID'+objacc.SAF_Experian_Id__c);
                  system.debug('Experianfo ID'+experianInfo.Id);
              }
              update lstaccId;
              
              return experianInfo.id;  
    }
     public void SaveandLogErrors(list<sObject> objlist)
    { // Iterate through each returned result
        for (Database.SaveResult sr :  Database.insert(objlist, true)) {
                    if (!sr.isSuccess()) {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('***** The following error has occurred.' +err.getStatusCode() + ': ' + err.getMessage());                    
                            System.debug('*****Fields that affected this error: ' + err.getFields());
                        }
                    }
                }
    }
   
    public void generatePaymentPerformance(SAF_Experian_Info__c experianInfo) 
    { 
 
        Saf_PaymentPerformance__c objPayPer       = new Saf_PaymentPerformance__c(); 
        objPayPer.SAF_Experian_Info__c           = experianInfo.id; 
        if(experian.PaymentPerformance !=null && experian.PaymentPerformance.PaymentFull !=null)
        {
            objPayPer.SafSDAvgDBT3Mnths__c            = experian.PaymentPerformance.PaymentFull.AvgDBT3Mnths; 
            objPayPer.SafSDAvgDBT6Mnths__c            = experian.PaymentPerformance.PaymentFull.AvgDBT6Mnths;
            objPayPer.SafSDAvgDBT12Mnths__c           = experian.PaymentPerformance.PaymentFull.AvgDBT12Mnths;
            objPayPer.SafSDNumberDBT10K__c            = experian.PaymentPerformance.PaymentFull.NumberDBT10K;
            objPayPer.SafSDNumberDBT1K__c             = experian.PaymentPerformance.PaymentFull.NumberDBT1K;
            objPayPer.SafSDNumberDBT100K__c           = experian.PaymentPerformance.PaymentFull.NumberDBT100K;
            objPayPer.SafSDNumberDBT100KPlus__c       = experian.PaymentPerformance.PaymentFull.NumberDBT100KPlus;
            objPayPer.SafSDNumberCashFirst__c         = experian.PaymentPerformance.PaymentFull.NumberCashFirst;
            objPayPer.SafSDNumberCollection__c        = experian.PaymentPerformance.PaymentFull.NumberCollection;
            objPayPer.SafSDValCollection__c           = experian.PaymentPerformance.PaymentFull.ValCollection;
            objPayPer.SafSDIndAvgDBT3Mnths__c         = experian.PaymentPerformance.PaymentFull.IndAvgDBT3Mnths;
            objPayPer.SafSDIndAvgDBT6Mnths__c         = experian.PaymentPerformance.PaymentFull.IndAvgDBT6Mnths;
            objPayPer.SafSDIndAvgDBT12Mnths__c        = experian.PaymentPerformance.PaymentFull.IndAvgDBT12Mnths;
            objPayPer.SafSDIndNumberDBT1K__c          = experian.PaymentPerformance.PaymentFull.IndNumberDBT1K;
            objPayPer.SafSDIndNumberDBT10K__c         = experian.PaymentPerformance.PaymentFull.IndNumberDBT10K;
            objPayPer.SafSDIndNumberDBT100K__c        = experian.PaymentPerformance.PaymentFull.IndNumberDBT100K;
            objPayPer.SafSDIndNumberDBT100KPlus__c    = experian.PaymentPerformance.PaymentFull.IndNumberDBT100KPlus;
            objPayPer.SafSDPaymentPattern__c          = GetExperianCodeValue('PaymentPattern',experian.PaymentPerformance.PaymentFull.PaymentPattern);
            objPayPer.SafSDIndPaymentPattern__c       = GetExperianCodeValue('IndPaymentPattern',experian.PaymentPerformance.PaymentFull.IndPaymentPattern);
            objPayPer.SafSDPaymentToTerms__c          = GetExperianCodeValue('PaymentToTerms',experian.PaymentPerformance.PaymentFull.PaymentToTerms);
            objPayPer.SafSDFastestPayment__c          = experian.PaymentPerformance.PaymentFull.FastestPayment;
            objPayPer.SafSDFastestMonth__c            = experian.PaymentPerformance.PaymentFull.FastestMonth;
            objPayPer.SafSDSlowestPayment__c          = experian.PaymentPerformance.PaymentFull.SlowestPayment;
            objPayPer.SafSDSlowestMonth__c            = experian.PaymentPerformance.PaymentFull.SlowestMonth;
            objPayPer.SafSDNumCommonTerms__c          = experian.PaymentPerformance.PaymentFull.NumCommonTerms;
            objPayPer.SafSDCompanyNumMnths__c         = experian.PaymentPerformance.PaymentFull.CompanyNumMnths;
            objPayPer.SafSDIndustryNumMnths__c        = experian.PaymentPerformance.PaymentFull.IndustryNumMnths;
            objPayPer.SafSDIndustrySICDesc__c         = experian.PaymentPerformance.PaymentFull.IndustrySICDesc;
             
           if( experian.PaymentPerformance.PaymentFull.UnpaidAccountsDetails!= null)
           {     
            for(Saf_Experain.cls_UnpaidAccountsDetails objuad:experian.PaymentPerformance.PaymentFull.UnpaidAccountsDetails)        
            {
                Saf_UnpaidAccountsDetails__c objUnAcDe           = new Saf_UnpaidAccountsDetails__c();
                objUnAcDe.SAF_Experian_Info__c           = experianInfo.id; 
                objUnAcDe.SafSDUnpaidAccounts__c                = objuad.UnpaidAccounts;
                multiObject.add(objUnAcDe);
            }        
           }
           if( experian.PaymentPerformance.PaymentFull.CompanyDBTMonthly!= null)
           {        
                for(Saf_Experain.cls_CompanyDBTMonthly objdbt:experian.PaymentPerformance.PaymentFull.CompanyDBTMonthly)        
                {
                    Saf_CompanyDBTMonthly__c objCoDBT                  = new Saf_CompanyDBTMonthly__c();
                    objCoDBT.SAF_Experian_Info__c           = experianInfo.id; 
                    objCoDBT.SafSDCompanyExpMonth__c                 = objdbt.CompanyExpMonth;
                    objCoDBT.SafSDCompanyDBT__c                      = objdbt.CompanyDBT;
                    objCoDBT.SafSDCompanyNumExp__c                   = objdbt.CompanyNumExp;
                    multiObject.add(objCoDBT);
                }
           }
            if( experian.PaymentPerformance.PaymentFull.IndDBTMonthly!= null)
           {  
            for(Saf_Experain.cls_IndDBTMonthly objidbt:experian.PaymentPerformance.PaymentFull.IndDBTMonthly)        
            {
                Saf_IndDBTMonthly__c objInDBT     = new Saf_IndDBTMonthly__c();
                objInDBT.SAF_Experian_Info__c     = experianInfo.id;       
                objInDBT.SafSDIndExpMonth__c                    = objidbt.IndExpMonth;
                objInDBT.SafSDIndustryDBT__c                    = objidbt.IndustryDBT;
                multiObject.add(objInDBT);
            }
          }   
           if( experian.PaymentPerformance.PaymentFull.CommonTerms!= null)
           {      
            for(Saf_Experain.cls_CommonTerms objct:experian.PaymentPerformance.PaymentFull.CommonTerms)       
            {
                 Saf_CommonTerms__c objComTer       = new Saf_CommonTerms__c(); 
                 objComTer.SAF_Experian_Info__c     = experianInfo.id;       
                 objComTer.SafSDCommonTermsDBT__c      = objct.CommonTermsDBT;
                 objComTer.SafSDCommonTermsNumExp__c   = objct.CommonTermsNumExp;
                 objComTer.SafSDCommonTermsCode__c     = objct.CommonTermsCode;
                 objComTer.SafSDCommonTermsText__c     = objct.CommonTermsText;
                 multiObject.add(objComTer);
            }
          }
            multiObject.add(objPayPer); 
        }
        system.debug('Payment Performance generated successfully');    
    }

    public void generateShareholders(SAF_Experian_Info__c experianInfo)
    {
        if(experian.Shareholders!= null)
        {
        for(Saf_Experain.cls_HeaderInfo objsh:experian.Shareholders.HeaderInfo)
        {
            Saf_Shareholders__c objshareholders = new Saf_Shareholders__c();
            objshareholders.Saf_SH_Name__c = 'HeaderInfo';
            objshareholders.SAF_Experian_Info__c        = experianInfo.id;
            objshareholders.SafSHRecordType__c          = objsh.RecordType;
            objshareholders.SafSHIssuingCompany__c      = objsh.IssuingCompany;
            objshareholders.SafSHCurrentPreviousFlag__c = objsh.CurrentPreviousFlag;
            objshareholders.SafSHEffectiveDate__c       = (objsh.EffectiveDate != null) ? Date.valueof(objsh.EffectiveDate) : null;//Date.ValueOf(objsh.EffectiveDate);
            objshareholders.SafSHIssuedCapital__c       = objsh.IssuedCapital;
            objshareholders.SafSHLegalStatus__c         = GetExperianCodeValue('LegalStatus',objsh.LegalStatus);
            objshareholders.SafSHDocumentType__c        = objsh.DocumentType;
            objshareholders.SafSHLatestCurrent__c       = (objsh.LatestCurrent != null) ? Date.valueof(objsh.LatestCurrent) : null;//Date.ValueOf(objsh.LatestCurrent);
            objshareholders.SafSHLatestUpdate__c        = objsh.LatestUpdate!=null ? Date.ValueOf(objsh.LatestUpdate) : null;
            objshareholders.SafSHDateLoaded__c          = (objsh.DateLoaded != null) ? Date.valueof(objsh.DateLoaded) : null;//Date.Valueof(objsh.DateLoaded);
            multiObject.add(objshareholders);
        }
        
        if(experian.Shareholders.ShareCapital != null)
        {
            for(Saf_Experain.cls_ShareCapital objsh:experian.Shareholders.ShareCapital)
            {    
                Saf_Shareholders__c objshareholders = new Saf_Shareholders__c();
                objshareholders.Saf_SH_Name__c = 'ShareCapital';
                objshareholders.SAF_Experian_Info__c        = experianInfo.id;
                objshareholders.SafSHRecordType__c          = objsh.RecordType;
                objshareholders.SafSHIssuingCompany__c      = objsh.IssuingCompany;
                objshareholders.SafSHCurrentPreviousFlag__c = objsh.CurrentPreviousFlag;
                objshareholders.SafSHEffectiveDate__c       = (objsh.EffectiveDate != null) ? Date.valueof(objsh.EffectiveDate) : null;//Date.ValueOf(objsh.EffectiveDate);
                objshareholders.SafSHShareClassNo__c        = objsh.ShareClassNo;
                objshareholders.SafSHNominalValue__c        = Decimal.valueof(objsh.NominalValue);
                objshareholders.SafSHCurrency__c            = objsh.Currencyiso;
                objshareholders.SafSHShareClassCode__c      = objsh.ShareClassCode;
                objshareholders.SafSHVotingRights__c        = objsh.VotingRights;
                objshareholders.SafSHTotalNominalCapital__c = objsh.TotalNominalCapital;                       
                objshareholders.SafSHShareClassDesc__c       = objsh.ShareClassDesc;
                objshareholders.SafSHNumShares__c            = objsh.NumShares;
                objshareholders.SafSHPercentage__c           = Decimal.valueof(objsh.Percentage);
                objshareholders.SafSHLatestUpdate__c         = objsh.LatestUpdate!=null ? Date.valueof(objsh.LatestUpdate) : null; 
                multiObject.add(objshareholders);
            }
        }
         if(experian.Shareholders.Shareholdings != null)
        {
             for(Saf_Experain.cls_Shareholdings objsh:experian.Shareholders.Shareholdings)
            {
                Saf_Shareholders__c objshareholders = new Saf_Shareholders__c();
                objshareholders.Saf_SH_Name__c = 'Shareholdings';
                objshareholders.SAF_Experian_Info__c        = experianInfo.id;
                objshareholders.SafSHRecordType__c          = objsh.RecordType;
                objshareholders.SafSHIssuingCompany__c      = objsh.IssuingCompany;
                objshareholders.SafSHCurrentPreviousFlag__c = objsh.CurrentPreviousFlag;
                objshareholders.SafSHEffectiveDate__c       = (objsh.EffectiveDate != null) ? Date.valueof(objsh.EffectiveDate) : null;//Date.ValueOf(objsh.EffectiveDate);
                objshareholders.SafSHShareClassNo__c        = objsh.ShareClassNo;
                //objshareholders.SafSHCurrency__c            = objsh.Currencyiso;
                //objshareholders.SafSHShareClassCode__c      = objsh.ShareClassCode;
                objshareholders.SafSHApproximation__c        = objsh.Approximation;
                objshareholders.SafSHTotalNominalCapital__c = objsh.TotalNominalCapital;                       
                objshareholders.SafSHPercentageTotalCapital__c =Decimal.valueof(objsh.PercentageTotalCapital);
                objshareholders.SafSHNumShares__c            = objsh.NumShares;
                objshareholders.SafSHPercentage__c           = Decimal.valueof(objsh.Percentage);
                //objshareholders.SafSHLatestUpdate__c         = Date.valueof(objsh.LatestUpdate);
                multiObject.add(objshareholders);
            }
        }
         if(experian.Shareholders.Shareholder != null)
        {
        
         for(Saf_Experain.cls_Shareholder objsh:experian.Shareholders.Shareholder)
        {    
            Saf_Shareholders__c objshareholders = new Saf_Shareholders__c();
            objshareholders.Saf_SH_Name__c = 'Shareholder';
            objshareholders.SAF_Experian_Info__c        = experianInfo.id;
            objshareholders.SafSHRecordType__c          = objsh.RecordType;
            objshareholders.SafSHIssuingCompany__c      = objsh.IssuingCompany;
            objshareholders.SafSHCurrentPreviousFlag__c = objsh.CurrentPreviousFlag;
            objshareholders.SafSHEffectiveDate__c       = (objsh.EffectiveDate != null) ? Date.valueof(objsh.EffectiveDate) : null;//Date.ValueOf(objsh.EffectiveDate);
            objshareholders.SafSHShareClassNo__c        = objsh.ShareClassNo;
            objshareholders.SafSHShareholdingNo__c      = objsh.ShareholdingNo;
            objshareholders.SafSHShareholderNo__c      = objsh.ShareholderNo;
            //objshareholders.SafSHApproximation__c        = objsh.Approximation;
             multiObject.add(objshareholders);
           
            Saf_ShareholderType__c objsharholderType = new Saf_ShareholderType__c ();
             objsharholderType.SAF_Experian_Info__c        = experianInfo.id;
            objsharholderType.Saf_ShareholderType__c = objshareholders.Id;                      
           
           if(objsh.ShareholderDetails != null && objsh.ShareholderDetails.Name!= null)
           {
            objsharholderType.SafSHTFirstName__c =objsh.ShareholderDetails.Name.FirstName;
            objsharholderType.SafSHTSurname__c =objsh.ShareholderDetails.Name.Surname;
           }  objsharholderType.SafSHTName__c = objsh.ShareholderDetails.ShareholderType;
           if(objsh.ShareholderDetails.CommercialDetail != null && objsh.ShareholderDetails.CommercialDetail.Name!= null)
           {
            objsharholderType.SAF_Commercial_details_Name__c =objsh.ShareholderDetails.CommercialDetail.Name;
            objsharholderType.SAF_Commercial_Details_Regno__c =objsh.ShareholderDetails.CommercialDetail.RegNumber;
           }
            //objshareholders.SafSHNumShares__c            = objsh.NumShares;
            //objshareholders.SafSHPercentage__c           = Decimal.valueof(objsh.Percentage);
            //objshareholders.SafSHLatestUpdate__c         = Date.valueof(objsh.LatestUpdate);
            multiObject.add(objsharholderType);
        }
       }
        system.debug('Shareholders Generated Successfully');
      }
    }
    
    public void generateCommercialDelphi(SAF_Experian_Info__c experianInfo)
    {
        Saf_CommercialDelphi__c commercialDelphi = new Saf_CommercialDelphi__c();
        
        commercialDelphi.SAF_Experian_Info__c                     = experianInfo.id;
        commercialDelphi.SafCDCommDelphiBand__c                   = experian.CommercialDelphi.CommDelphiBand;
        commercialDelphi.SafCDCommDelphiBandText__c               = experian.CommercialDelphi.CommDelphiBandText;
        commercialDelphi.SafCDCommDelphiScore__c                  = experian.CommercialDelphi.CommDelphiScore;
        commercialDelphi.SafCDConclusionText__c                   = experian.CommercialDelphi.ConclusionText;
        commercialDelphi.SafCDCreditLimit__c                      = experian.CommercialDelphi.CreditLimit;
        commercialDelphi.SafCDCreditLimitOverrideIndicator__c     = experian.CommercialDelphi.CreditLimitOverrideIndicator;
        commercialDelphi.SafCDCreditRating__c                     = experian.CommercialDelphi.CreditRating;  
        commercialDelphi.SafCDCreditRatingOverrideIndicator__c    = experian.CommercialDelphi.CreditRatingOverrideIndicator;
        commercialDelphi.SafCDCreditTextOverrideIndicator__c      = experian.CommercialDelphi.CreditTextOverrideIndicator;
        //commercialDelphi.SafCDdicator__c                          = ;
        //commercialDelphi.SafCDhiBand__c                           = ;
        //commercialDelphi.SafCDhiBandText__c                       = ;
        //commercialDelphi.SafCDhiScore__c                          = ;
        //commercialDelphi.SafCDIndicator__c                        = ;
        //commercialDelphi.SafCDmit__c                              = ;
        //commercialDelphi.SafCDmitOverrideIndicator__c             = ;
        //commercialDelphi.SafCDonText__c                           = ;
        commercialDelphi.SafCDOverrideIndicator__c                = experian.CommercialDelphi.OverrideIndicator;
        commercialDelphi.SafCDParentIndicator__c                  = experian.CommercialDelphi.ParentIndicator;
        //commercialDelphi.SafCDting__c                             = ;
        //commercialDelphi.SafCDtingOverrideIndicator__c            = ;
        //commercialDelphi.SafCDxtOverrideIndicator__c              = ;
        commercialDelphi.SafCDStabilityOdds__c = experian.CommercialDelphi.StabilityOdds;
        
        multiObject.add(commercialDelphi);
        system.debug('Commercial Delphi generated successfully');
    }
    
    public void generateCAISSummary(SAF_Experian_Info__c experianInfo)
    {
    if(experian.LtdCompanyCAIS != null && experian.LtdCompanyCAIS.LtdCompanyCAISSummary != null && experian.LtdCompanyCAIS.LtdCompanyCAISSummary.MonthlyData != null)
    {
            for(Saf_Experain.cls_MonthlyData objmd:experian.LtdCompanyCAIS.LtdCompanyCAISSummary.MonthlyData)
            {
                saf_Experian_CAIS_Summary__c CAISSummary = new saf_Experian_CAIS_Summary__c();
                CAISSummary.SAF_Experian_Info__c            = experianInfo.id;
                CAISSummary.SAF_AgeSinceLast89__c            = experian.LtdCompanyCAIS.LtdCompanyCAISSummary.AgeSinceLast89;
                CAISSummary.SAF_MonthCount__c                = experian.LtdCompanyCAIS.LtdCompanyCAISSummary.MonthCount;
                CAISSummary.SAF_Date_Year__c                  = objmd.MonthYyyy;
                CAISSummary.SAF_Date_Month__c                 = objmd.MonthMm;
                CAISSummary.SAF_Status_0__c                     = objmd.Status0;
                CAISSummary.SAF_Status_1__c                     = objmd.Status1;
                CAISSummary.SAF_Status_2__c                     = objmd.Status2;
                CAISSummary.SAF_Status_3__c                     = objmd.Status3;
                CAISSummary.SAF_Status_4__c                     = objmd.Status4;  
                CAISSummary.SAF_Status_5__c                     = objmd.Status5;
                CAISSummary.SAF_Status_6__c                     = objmd.Status6;
                CAISSummary.SAF_Status_U__c                     = objmd.StatusU;
                CAISSummary.SAF_Status_89__c                    = objmd.Status89;
                CAISSummary.SAF_Active_Balance__c             = objmd.CurrentBalance;
                CAISSummary.SAF_Number_of_Accounts__c         = decimal.valueOf(objmd.NumActiveAccounts);
                CAISSummary.SAF_Default_Balance__c            = objmd.DefaultBalance;
                multiObject.add(CAISSummary);
            }
        }       
        system.debug('CAISSummary generated successfully');
    }
       public void generateCAISDetails(SAF_Experian_Info__c experianInfo)
    {
       integer intcais = 0;
       if(experian.LtdCompanyCAIS != null && experian.LtdCompanyCAIS.LtdCompanyCAISDetails != null )
       {
            for(Saf_Experain.cls_LtdCompanyCAISDetails objcaisdetails:experian.LtdCompanyCAIS.LtdCompanyCAISDetails)
            {
                saf_Experian_CAIS_Details__c CAISDetails= new saf_Experian_CAIS_Details__c();
                CAISDetails.SAF_Experian_Info__c              = experianInfo.id;
                CAISDetails.SAF_Account_State__c              = GetExperianCodeValue('AccountState',objcaisdetails.AccountState);
                CAISDetails.SAF_Company_Type__c               = GetExperianCodeValue('CompanyType',objcaisdetails.CompanyType);
                CAISDetails.SAF_Account_Type__c               = GetExperianCodeValue('AccountType',objcaisdetails.AccountType);
                CAISDetails.SAF_Default_Date__c               = objcaisdetails.DefaultDate!=Null ? date.valueOf(objcaisdetails.DefaultDate): null;
                CAISDetails.SAF_Default_Balance__c            = objcaisdetails.DefaultBalance;
                CAISDetails.SAF_Current_Balance__c            = objcaisdetails.CurrentBalance;
                CAISDetails.SAF_Total_Status_1_2__c           = decimal.valueOf(objcaisdetails.Status1To2);  
                CAISDetails.SAF_Total_Status_3__c             = decimal.valueOf(objcaisdetails.Status3To9);
                CAISDetails.SAF_CAIS_Last_Update__c           = (objcaisdetails.CaisLastUpdate != null) ? Date.valueof(objcaisdetails.CaisLastUpdate) : null;//date.valueOf(objcaisdetails.CaisLastUpdate);
                CAISDetails.SAF_Account_Status__c             = objcaisdetails.AccountStatus12;
                CAISDetails.SAF_Months_Data__c                = decimal.valueOf(objcaisdetails.MonthsData);
                intcais = intcais+1;
                if(intcais<=25){multiObject.add(CAISDetails);}
            }
        }
        
        system.debug('CAISDetails generated successfully');
    }
    
    public void generateCorporateStructure(SAF_Experian_Info__c experianInfo)
    {
        Saf_CorporateStructure__c objCorStruct = new Saf_CorporateStructure__c();
        objCorStruct.SAF_Experian_Info__c                     = experianInfo.id;
        if(experian.CorporateStructure!= null)
        {
        objCorStruct.SafCSCOBulkShareHolders__c                   = experian.CorporateStructure.CompanyOwnership.BulkShareHolders;
        objCorStruct.SafCSCOBulkTelephone__c                   = experian.CorporateStructure.CompanyOwnership.BulkTelephone;
        objCorStruct.SafCSCONumPrincShareHldrs__c                   = experian.CorporateStructure.CompanyOwnership.NumPrincShareHldrs;
        objCorStruct.SafCSCOParentDetail__c                          = experian.CorporateStructure.CompanyOwnership.ParRegNumber;
        objCorStruct.SafCSCOParentDetail__c                          = experian.CorporateStructure.CompanyOwnership.UltParRegNumber;
        if(experian.CorporateStructure.Subsidiaries !=null)
        {
            objCorStruct.SafCSSubTreePosition__c                   = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TreePosition);
            objCorStruct.SafCSSubTotalElements__c                   =Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalElements);
            objCorStruct.SafCSSubTotalSubs__c                    = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalSubs);
            objCorStruct.SafCSSubTotalNumImmediateSubs__c        = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumImmediateSubs);
            objCorStruct.SafCSSubTotalNumLiveImmediateSubs__c    = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumLiveImmediateSubs);
            objCorStruct.SafCSSubTotalNumDormantImmediateSubs__c = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumDormantImmediateSubs);
            objCorStruct.SafCSSubTotNumDislvdLiquidatdImmSubs__c = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumDissolvedLiquidatedImmediateSubs);
            objCorStruct.SafCSSubTotalNumNestedSubs__c           = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumNestedSubs);
            objCorStruct.SafCSSubTotalNumSubs__c                   = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumSubs);
            objCorStruct.SafCSSubTotalNumUKSubs__c                 = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumUKSubs);
            objCorStruct.SafCSSubTotalNumOverseasSubs__c           = Decimal.valueof(experian.CorporateStructure.Subsidiaries.TotalNumOverseasSubs);
            multiObject.add(objCorStruct);
            
            if(experian.CorporateStructure.Subsidiaries.UKSubsidiaries !=null)
            {
                 for(Saf_Experain.cls_UKSubsidiaries objsub:experian.CorporateStructure.Subsidiaries.UKSubsidiaries)
                {
                     Saf_UKSubsidiaries__c objuksub = new Saf_UKSubsidiaries__c();
                     objuksub.SAF_Experian_Info__c = experianInfo.id;
                     objuksub.Saf_UKSub_SubLegalStatus__c =  GetExperianCodeValue('SubLegalStatus',objsub.SubLegalStatus);
                     objuksub.Saf_UKSub_SubRegNumber__c = objsub.SubRegNumber;
                     objuksub.Saf_UKSub_SubStatus__c = GetExperianCodeValue('SubStatus',objsub.SubStatus);
                     objuksub.Saf_UKSub_SubName__c = objsub.SubName;
                      multiObject.add(objuksub);
                }
            
            }
       }
       if(experian.CorporateStructure.CompanyOwnership.CorporateShareholder != null)
       {
            for(Saf_Experain.cls_CorporateShareholder objsh:experian.CorporateStructure.CompanyOwnership.CorporateShareholder)
            {
                Saf_CorporateShareholder__c objCorSh = new Saf_CorporateShareholder__c();
                objCorSh.SAF_Experian_Info__c        = experianInfo.id;
                objCorSh.SafCSholderName__c          = objsh.Name;
                objCorSh.SafCSholderHolding__c = objsh.Holding;
                if(objsh.Country != null) {objCorSh.SafCSholderCountry__c = objsh.Country;}
                multiObject.add(objCorSh);
            }
       }
        
        if(experian.CorporateStructure.CompanyOwnership.ParentDetail!= null)
       {
           // for(Saf_Experain.cls_ParentDetail  objPr:experian.CorporateStructure.CompanyOwnership.ParentDetail)
           // {
                SAF_Experian_ParentDetail__c objParent = new SAF_Experian_ParentDetail__c();
                objParent.SAF_Experian_Info__c        = experianInfo.id;
                objParent.SAF_Parent_CommercialName__c = experian.CorporateStructure.CompanyOwnership.ParentDetail.CommercialName;
                if(experian.CorporateStructure.CompanyOwnership.ParentDetail.BusinessLocation != null)
                {
                    objParent.SAF_Parent_LocationLine1__c = experian.CorporateStructure.CompanyOwnership.ParentDetail.BusinessLocation.LocationLine1;
                    objParent.SAF_Parent_LocationLine2__c = experian.CorporateStructure.CompanyOwnership.ParentDetail.BusinessLocation.LocationLine2;
                    objParent.SAF_Parent_LocationLine3__c = experian.CorporateStructure.CompanyOwnership.ParentDetail.BusinessLocation.LocationLine3;
                    objParent.SAF_Parent_LocationLine4__c = experian.CorporateStructure.CompanyOwnership.ParentDetail.BusinessLocation.LocationLine4;
                    objParent.SAF_Parent_Postcode__c  = experian.CorporateStructure.CompanyOwnership.ParentDetail.BusinessLocation.Postcode;
                }
                multiObject.add(objParent);
           // }
       }
       
       if(experian.CorporateStructure.CompanyOwnership.UltParentDetail!= null)
       {
           // for(Saf_Experain.cls_ParentDetail  objPr:experian.CorporateStructure.CompanyOwnership.ParentDetail)
           // {
                SAF_Experian_UltParent__c objultParent = new SAF_Experian_UltParent__c();
                objultParent.SAF_Experian_Info__c        = experianInfo.id;
                objultParent.SAF_UltParent_CommercialName__c = experian.CorporateStructure.CompanyOwnership.UltParentDetail.CommercialName;
                if(experian.CorporateStructure.CompanyOwnership.UltParentDetail.BusinessLocation != null)
                {
                    objultParent.SAF_UltParent_LocationLine1__c = experian.CorporateStructure.CompanyOwnership.UltParentDetail.BusinessLocation.LocationLine1;
                    objultParent.SAF_UltParent_LocationLine2__c = experian.CorporateStructure.CompanyOwnership.UltParentDetail.BusinessLocation.LocationLine2;
                    objultParent.SAF_UltParent_LocationLine3__c = experian.CorporateStructure.CompanyOwnership.UltParentDetail.BusinessLocation.LocationLine3;
                    objultParent.SAF_UltParent_LocationLine4__c = experian.CorporateStructure.CompanyOwnership.UltParentDetail.BusinessLocation.LocationLine4;
                    objultParent.SAF_UltParent_Postcode__c  = experian.CorporateStructure.CompanyOwnership.UltParentDetail.BusinessLocation.Postcode;
                }
                multiObject.add(objultParent);
           // }
       }
        system.debug('generateCorporateStructure successfully');
      }
    }
    
    public void GenerateCommercialDelphiHistory(SAF_Experian_Info__c experianInfo)
    {
         if(experian.CommercialDelphiHistory.CompanyHistory != null)
        { 
            Saf_CommercialDelphiHistory__c objCdh     = new Saf_CommercialDelphiHistory__c();
           
            objCdh.SafCDHCHCommDelphiScore__c      = experian.CommercialDelphiHistory.CompanyHistory.CommDelphiScore;
            objCdh.SafCDHCHCommDelphiBand__c       = experian.CommercialDelphiHistory.CompanyHistory.CommDelphiBand;
            objCdh.SafCDHCHStabilityOdds__c        = experian.CommercialDelphiHistory.CompanyHistory.StabilityOdds;
            objCdh.SafCDHCHOverrideIndicator__c    = experian.CommercialDelphiHistory.CompanyHistory.OverrideIndicator;
            objCdh.SafCDHCHTextCount__c            = experian.CommercialDelphiHistory.CompanyHistory.TextCount;
            objCdh.SafCDHCHScoreHistoryCount__c    = experian.CommercialDelphiHistory.CompanyHistory.ScoreHistoryCount;
            objCdh.SafCDHCHCommDelphiBandText__c   = experian.CommercialDelphiHistory.CompanyHistory.CommDelphiBandText;        
            objCdh.SAF_Experian_Info__c =  experianInfo.id;
             multiObject.add(objCdh);
        
            if(experian.CommercialDelphiHistory.CompanyHistory.ScoreHistory != null)
            { 
                for(Saf_Experain.cls_ScoreHistory objSh:experian.CommercialDelphiHistory.CompanyHistory.ScoreHistory)
                {
                    Saf_ScoreHistoryDate__c objSHD = new Saf_ScoreHistoryDate__c();
                     objSHD.Saf_ScoreHistoryType__c         = 'ScoreHistory';
                    objSHD.Saf_CDH_ScoreHistoryDate__c  = (objSh.ScoreHistoryDate != null) ? Date.valueof(objSh.ScoreHistoryDate) : null;//Date.valueof(objSh.ScoreHistoryDate);
                    objSHD.Saf_CDH_OverrideIndicator__c = objSh.OverrideIndicator;
                    objSHD.Saf_CDH_CreditRatingOverrideIndicator__c = objSh.CreditRatingOverrideIndicator;
                    objSHD.Saf_CDH_CreditRating__c = objSh.CreditRating;
                    objSHD.Saf_CDH_CreditLimitOverrideIndicator__c = objSh.CreditLimitOverrideIndicator;
                    objSHD.Saf_CDH_CreditLimit__c = objSh.CreditLimit;
                    objSHD.Saf_CDH_CommDelphiScore__c = objSh.CommDelphiScore;
                    objSHD.SAF_Experian_Info__c =  experianInfo.id;
                      multiObject.add(objSHD);
                }
            }
        }
        
         if(experian.CommercialDelphiHistory.SectorScore != null)
        { 
            Saf_SectorScore__c objSS = new Saf_SectorScore__c();
            objSS.SAF_Experian_Info__c =  experianInfo.id;
          
            objSS.SafSSRecentSnapshotDate__c = (experian.CommercialDelphiHistory.SectorScore.RecentSnapshotDate != null) ? Date.valueof(experian.CommercialDelphiHistory.SectorScore.RecentSnapshotDate) : null;
            objSS.SafSSAgeAverageDelphiScore__c = experian.CommercialDelphiHistory.SectorScore.AgeAverageDelphiScore;
            objSS.SafSSAgeAverageStabilityOdds__c = experian.CommercialDelphiHistory.SectorScore.AgeAverageStabilityOdds;       
            objSS.SafSSAgeCompGroup__c = experian.CommercialDelphiHistory.SectorScore.AgeCompGroup;
            objSS.SafSSAgeCompSector__c = experian.CommercialDelphiHistory.SectorScore.AgeCompSector;
          
            objSS.SafSSAllAverageDelphiScore__c = experian.CommercialDelphiHistory.SectorScore.AllAverageDelphiScore;
            objSS.SafSSAllAverageStabilityOdds__c = experian.CommercialDelphiHistory.SectorScore.AllAverageStabilityOdds;
            objSS.SafSSAllCompGroup__c = experian.CommercialDelphiHistory.SectorScore.AllCompGroup;
            
            objSS.SafSSIndAverageDelphiScore__c = experian.CommercialDelphiHistory.SectorScore.IndAverageDelphiScore;
            objSS.SafSSIndAverageStabilityOdds__c = experian.CommercialDelphiHistory.SectorScore.IndAverageStabilityOdds;
            objSS.SafSSIndCompGroup__c = experian.CommercialDelphiHistory.SectorScore.IndCompGroup;
            objSS.SafSSIndCompSector__c = experian.CommercialDelphiHistory.SectorScore.IndCompSector;
           // objSS.SafSSRecentSnapshotDate__c = Date.valueof(experian.CommercialDelphiHistory.SectorScore.RecentSnapshotDate);
            multiObject.add(objSS);
              
            for(string strDate:experian.CommercialDelphiHistory.SectorScore.ScoreHistoryDate)
            {
                Saf_ScoreHistoryDate__c objSHD = new Saf_ScoreHistoryDate__c();
                 objSHD.Saf_ScoreHistoryType__c         = 'ScoreHistoryDate';
                objSHD.Saf_CDH_ScoreHistoryDate__c  = Date.valueof(strDate);
                objSHD.SAF_Experian_Info__c =  experianInfo.id;
                   multiObject.add(objSHD);
            }
            //AllHistoricalScore.AllHistoricalAverageDelphiScore
             for(string strValue:experian.CommercialDelphiHistory.SectorScore.AllHistoricalScore.AllHistoricalAverageDelphiScore)
            {
                Saf_SS_HistoricalScore__c objSHD = new Saf_SS_HistoricalScore__c();
                objSHD.Saf_SS_HistoricalScoreName__c = 'AllHistoricalScore.AllHistoricalAverageDelphiScore';
                objSHD.Saf_SS_HistoricalScore__c = Decimal.valueof(strValue);
                objSHD.SAF_Experian_Info__c =  experianInfo.id;
                  multiObject.add(objSHD);
            }  
             //IndHistoricalScore.IndHistoricalAverageDelphiScore
             if(experian.CommercialDelphiHistory.SectorScore.IndHistoricalScore != null)
             {
                 for(string strValue:experian.CommercialDelphiHistory.SectorScore.IndHistoricalScore.IndHistoricalAverageDelphiScore)
                {
                    Saf_SS_HistoricalScore__c objSHD = new Saf_SS_HistoricalScore__c();
                    objSHD.Saf_SS_HistoricalScoreName__c = 'IndHistoricalScore.IndHistoricalAverageDelphiScore';
                    objSHD.Saf_SS_HistoricalScore__c = Decimal.valueof(strValue);
                    objSHD.SAF_Experian_Info__c =  experianInfo.id;
                    multiObject.add(objSHD);
                } 
            } 
              //AgeHistoricalScore.AgeHistoricalAverageDelphiScore
             for(string strValue:experian.CommercialDelphiHistory.SectorScore.AgeHistoricalScore.AgeHistoricalAverageDelphiScore)
            {
                Saf_SS_HistoricalScore__c objSHD = new Saf_SS_HistoricalScore__c();
                objSHD.Saf_SS_HistoricalScoreName__c = 'AgeHistoricalScore.AgeHistoricalAverageDelphiScore';
                objSHD.Saf_SS_HistoricalScore__c = Decimal.valueof(strValue);
                objSHD.SAF_Experian_Info__c =  experianInfo.id;
                multiObject.add(objSHD);
            }  
        }
        
        if(experian.CommercialDelphiHistory.SectorRanking != null)
        { 
            Saf_SectorRanking__c objSR = new Saf_SectorRanking__c();
            objSR.SAF_Experian_Info__c =  experianInfo.id;
            objSR.SafSRAllCompGroup__c             = experian.CommercialDelphiHistory.SectorRanking.AllCompGroup; 
            objSR.SafSRAllNumberSector__c          = experian.CommercialDelphiHistory.SectorRanking.AllNumberSector;
            objSR.SafSRAllPercentSector__c         = experian.CommercialDelphiHistory.SectorRanking.AllPercentSector;
            objSR.SafSRAllNumberLowerScore__c      = experian.CommercialDelphiHistory.SectorRanking.AllNumberLowerScore;
            objSR.SafSRAllNumberSameScore__c       = experian.CommercialDelphiHistory.SectorRanking.AllNumberSameScore;
            objSR.SafSRAllNumberHigherScore__c     = experian.CommercialDelphiHistory.SectorRanking.AllNumberHigherScore;
            objSR.SafSRAllPercentile__c            = experian.CommercialDelphiHistory.SectorRanking.AllPercentile;
            objSR.SafSRIndCompGroup__c             = experian.CommercialDelphiHistory.SectorRanking.IndCompGroup;
            objSR.SafSRIndCompSector__c            = experian.CommercialDelphiHistory.SectorRanking.IndCompSector;
            objSR.SafSRIndNumberSector__c          = experian.CommercialDelphiHistory.SectorRanking.IndNumberSector;
            objSR.SafSRIndPercentSector__c         = experian.CommercialDelphiHistory.SectorRanking.IndPercentSector;
            objSR.SafSRIndNumberLowerScore__c      = experian.CommercialDelphiHistory.SectorRanking.IndNumberLowerScore;
            objSR.SafSRIndNumberSameScore__c       = experian.CommercialDelphiHistory.SectorRanking.IndNumberSameScore;
            objSR.SafSRIndNumberHigherScore__c     = experian.CommercialDelphiHistory.SectorRanking.IndNumberHigherScore;
            objSR.SafSRIndPercentile__c            = experian.CommercialDelphiHistory.SectorRanking.IndPercentile;
            objSR.SafSRSizeCompGroup__c            = experian.CommercialDelphiHistory.SectorRanking.SizeCompGroup;
            objSR.SafSRAgeCompGroup__c             = experian.CommercialDelphiHistory.SectorRanking.AgeCompGroup;
            objSR.SafSRAgeCompSector__c            = experian.CommercialDelphiHistory.SectorRanking.AgeCompSector;
            objSR.SafSRAgeNumberSector__c          = experian.CommercialDelphiHistory.SectorRanking.AgeNumberSector;
            objSR.SafSRAgePercentSector__c         = experian.CommercialDelphiHistory.SectorRanking.AgePercentSector;
            objSR.SafSRAgeNumberLowerScore__c      = experian.CommercialDelphiHistory.SectorRanking.AgeNumberLowerScore;
            objSR.SafSRAgeNumberSameScore__c       = experian.CommercialDelphiHistory.SectorRanking.AgeNumberSameScore;
            objSR.SafSRAgeNumberHigherScore__c     = experian.CommercialDelphiHistory.SectorRanking.AgeNumberHigherScore;
            objSR.SafSRAgePercentile__c            = experian.CommercialDelphiHistory.SectorRanking.AgePercentile;
              multiObject.add(objSR);
        }
        
        if(experian.CommercialDelphiHistory.Sectors != null)
        { 
            Saf_Sectors__c objSector = new Saf_Sectors__c();
            objSector.SAF_Experian_Info__c =  experianInfo.id;
            objSector.SafSecAllCompGroup__c                    = experian.CommercialDelphiHistory.Sectors.AllCompGroup;
            objSector.SafSecAllCompGroupName__c                = experian.CommercialDelphiHistory.Sectors.AllCompGroupName;
            objSector.SafSecIndCompGroup__c                    = experian.CommercialDelphiHistory.Sectors.IndCompGroup;
            objSector.SafSecIndCompGroupName__c                = experian.CommercialDelphiHistory.Sectors.IndCompGroupName;
            objSector.SafSecIndCompGroupSector__c              = experian.CommercialDelphiHistory.Sectors.IndCompGroupSector;
            objSector.SafSecIndCompGroupSectorName__c          = experian.CommercialDelphiHistory.Sectors.IndCompGroupSectorName;
            objSector.SafSecSizeCompGroup__c                   = experian.CommercialDelphiHistory.Sectors.SizeCompGroup;
            objSector.SafSecSizeCompGroupName__c               = experian.CommercialDelphiHistory.Sectors.SizeCompGroupName;
           
            objSector.SafSecSizeCompGroupSector__c            = experian.CommercialDelphiHistory.Sectors.SizeCompGroupSector;
            objSector.SafSecSizeCompGroupSectorLowerBound__c  = experian.CommercialDelphiHistory.Sectors.SizeCompGroupSectorLowerBound;
            objSector.SafSecSizeCompGroupSectorUpperBound__c  = experian.CommercialDelphiHistory.Sectors.SizeCompGroupSectorUpperBound;
            objSector.SafSecAgeCompGroup__c                    = experian.CommercialDelphiHistory.Sectors.AgeCompGroup;
            objSector.SafSecAgeCompGroupName__c                = experian.CommercialDelphiHistory.Sectors.AgeCompGroupName;
            objSector.SafSecAgeCompGroupSector__c              = experian.CommercialDelphiHistory.Sectors.AgeCompGroupSector;
            objSector.SafSecAgeCompGroupSectorStartDate__c     = experian.CommercialDelphiHistory.Sectors.AgeCompGroupSectorStartDate;
            objSector.SafSecAgeCompGroupSectorEndDate__c       = experian.CommercialDelphiHistory.Sectors.AgeCompGroupSectorEndDate;
            multiObject.add(objSector);
          }
    }
     public void generateLegalNotices(SAF_Experian_Info__c experianInfo)
    {
         if(experian.LegalNotices != null)
        {
            Saf_LegalNotices__c objLN = new Saf_LegalNotices__c();
            objLN.SAF_Experian_Info__c    = experianInfo.id;
            objLN.SafLNSummaryCount__c = experian.LegalNotices.SummaryCount;            
            multiObject.add(objLN);    
            
            if(experian.LegalNotices.SummaryLine !=null)
            {
            for(Saf_Experain.cls_SummaryLine objSL:experian.LegalNotices.SummaryLine)
                {
                Saf_SummaryLine__c objSLN = new Saf_SummaryLine__c();
                objSLN.SAF_Experian_Info__c    = experianInfo.id;
                objSLN.Saf_SL_EventCount__c = objSL.EventCount;  
                objSLN.Saf_SL_EventDate__c = (objSL.EventDate != null) ? Date.valueof(objSL.EventDate) : null;//Date.valueof(objSL.EventDate);
                objSLN.Saf_SL_EventType__c = GetExperianCodeValue('EventType',objSL.EventType);          
                multiObject.add(objSLN);    
                }
            }
            if(experian.LegalNotices.Notice6253 !=null)
            {
              for(Saf_Experain.cls_Notice6253 obj6253:experian.LegalNotices.Notice6253)
                {
                Saf_Notice6253__c objNot = new Saf_Notice6253__c();
                objNot.SAF_Experian_Info__c    = experianInfo.id;
                objNot.Saf_LN_DateOfNotice__c= (obj6253.DateOfNotice != null) ? Date.valueof(obj6253.DateOfNotice) : null;//Date.valueof(obj6253.DateOfNotice);
                objNot.Saf_LN_RecordType__c = GetExperianCodeValue('RecordType',obj6253.RecordType);
                     
                multiObject.add(objNot);    
                }                
            }
            system.debug('LegalNotices generated successfully');
         }
    }
    public void generateManagementInfo(SAF_Experian_Info__c experianInfo)
    {
         if(experian.ManagementInfo != null)
        {
            Saf_ManagementInfo__c objMI = new Saf_ManagementInfo__c();
            objMI.SAF_Experian_Info__c              = experianInfo.id;
            objMI.SafMINumDirs__c                   =  Decimal.valueof(experian.ManagementInfo.NumDirs);
            objMI.SafMINumSecs__c                   =  Decimal.valueof(experian.ManagementInfo.NumSecs);
            objMI.SafMINumCurrDirs__c=  Decimal.valueof(experian.ManagementInfo.NumCurrDirs);
            objMI.SafMINumPrevDirs__c =  Decimal.valueof(experian.ManagementInfo.NumPrevDirs);
            objMI.SafMIDirectorAvgAge__c =  Decimal.valueof(experian.ManagementInfo.DirectorAvgAge);
            objMI.SafMIDirectorAvgLength__c =  Decimal.valueof(experian.ManagementInfo.DirectorAvgLength);
            objMI.SafMINumCurrDirectorLast12__c =  Decimal.valueof(experian.ManagementInfo.NumCurrDirectorLast12);
            objMI.SafMINumAppointmentsLast12__c =  Decimal.valueof(experian.ManagementInfo.NumAppointmentsLast12);
            objMI.SafMINumResignationsLast12__c =  Decimal.valueof(experian.ManagementInfo.NumResignationsLast12);
            objMI.SafMINumDisqualifications__c =  Decimal.valueof(experian.ManagementInfo.NumDisqualifications);
             multiObject.add(objMI);
        
       
            for(Saf_Experain.cls_CurrentDirector objCd:experian.ManagementInfo.Directors.CurrentDirector)
            {
                 Saf_CurrentDirector__c objCurDir = new Saf_CurrentDirector__c();
                  objCurDir.Saf_DirectorType__c = 'CurrentDirector';
                objCurDir.SafCDForeignAddressFlag__c  = GetExperianCodeValue('ForeignAddress',objCd.ForeignAddressFlag);
                objCurDir.SafCDDirectorCompanyFlag__c = objCd.DirectorCompanyFlag;
                objCurDir.SafCDDirectorNumber__c      = objCd.DirectorNumber;
                objCurDir.SafCDAppointmentDate__c     = (objCd.AppointmentDate != null) ? Date.valueof(objCd.AppointmentDate) : null;//Date.valueof(objCd.AppointmentDate);
                objCurDir.SafCDAppointmentIndicator__c= objCd.AppointmentIndicator;
                objCurDir.SafCDDirectorshipLength__c= objCd.DirectorshipLength;
                objCurDir.SafCDNumberConvictions__c  = Decimal.valueof(objCd.NumberConvictions);
                             
               objCurDir.SafCDDDDateOfBirth__c =            (objCd.DirectorDetails.DateOfBirth != null) ? Date.valueof(objCd.DirectorDetails.DateOfBirth) : null;
               if(objCd.DirectorDetails.Name != null)
               {
                objCurDir.SafCDDDNamePrefix__c               =      objCd.DirectorDetails.Name.Prefix;
                objCurDir.SafCDDDNameForename__c                = (objCd.DirectorDetails.Name.Forename ==null) ? objCd.DirectorDetails.Name.FirstName: objCd.DirectorDetails.Name.Forename;
                objCurDir.SafCDDDNameSurName__c                 = objCd.DirectorDetails.Name.SurName;
                objCurDir.SafCDDDNameMiddlename__c            = objCd.DirectorDetails.Name.MiddleNames;               
               }
                objCurDir.SafCDDDLocationHouseNumber__c       = objCd.DirectorDetails.Location.HouseNumber;
                objCurDir.SafCDDDLocationHouseName__c       = objCd.DirectorDetails.Location.HouseName;
                objCurDir.SafCDDDLocationStreet__c            = objCd.DirectorDetails.Location.Street;
                objCurDir.SafCDDDLocationDistrict__c            = objCd.DirectorDetails.Location.County;
               
                objCurDir.SafCDDDLocationPostTown__c           = objCd.DirectorDetails.Location.PostTown;
                objCurDir.SafCDDDLocationPostcode__c           = objCd.DirectorDetails.Location.Postcode;
                objCurDir.SafCDDDLocationRMC__c                = objCd.DirectorDetails.Location.RMC;
               
                objCurDir.SafCDOccupation__c                   = objCd.DirectorDetails.Occupation;
                objCurDir.SafCDNationality__c                  = objCd.DirectorDetails.Nationality;
                objCurDir.SafCDShareInformation__c             = objCd.DirectorDetails.ShareInformation;
                 objCurDir.SAF_Experian_Info__c              = experianInfo.id;
                 multiObject.add(objCurDir);
           }
            if(experian.ManagementInfo.Directors.PreviousDirector != null)
            {
            for(Saf_Experain.cls_PreviousDirector objPd:experian.ManagementInfo.Directors.PreviousDirector)
                {
                     Saf_CurrentDirector__c objCurDir = new Saf_CurrentDirector__c();
                    objCurDir.Saf_DirectorType__c = 'PreviousDirector';
                    objCurDir.SafCDForeignAddressFlag__c  = objPd.ForeignAddressFlag;
                    objCurDir.SafCDDirectorCompanyFlag__c = objPd.DirectorCompanyFlag;
                    objCurDir.SafCDDirectorNumber__c      = objPd.DirectorNumber;
                    objCurDir.SafCDAppointmentDate__c     =  (objPd.AppointmentDate != null) ? Date.valueof(objPd.AppointmentDate) : null;//Date.valueof(objPd.AppointmentDate);
                    objCurDir.SafCDAppointmentIndicator__c= objPd.AppointmentIndicator;
                    objCurDir.Saf_PD_ResignationDate__c     = (objPd.ResignationDate != null) ? Date.valueof(objPd.ResignationDate) : null;//Date.valueof(objPd.ResignationDate);
                    objCurDir.Saf_PD_ResignationIndicator__c = objPd.ResignationIndicator;
                    objCurDir.SafCDDirectorshipLength__c= objPd.DirectorshipLength;
                    objCurDir.SafCDNumberConvictions__c  = Decimal.valueof(objPd.NumberConvictions);
                    
                    objCurDir.SafCDDDDateOfBirth__c =            (objPd.DirectorDetails.DateOfBirth != null) ? Date.valueof(objPd.DirectorDetails.DateOfBirth) : null;            
                    if(objPd.DirectorDetails.Name != null)
                    {  
                        objCurDir.SafCDDDNameForename__c                = (objPd.DirectorDetails.Name.Forename ==null) ? objPd.DirectorDetails.Name.FirstName: objPd.DirectorDetails.Name.Forename;
                        objCurDir.SafCDDDNameSurName__c                 = objPd.DirectorDetails.Name.SurName;
                        objCurDir.SafCDDDNameMiddlename__c            = objPd.DirectorDetails.Name.MiddleNames;               
                    }
                    objCurDir.SafCDDDLocationHouseNumber__c       = objPd.DirectorDetails.Location.HouseNumber;
                    objCurDir.SafCDDDLocationHouseName__c       = objPd.DirectorDetails.Location.HouseName;
                    objCurDir.SafCDDDLocationStreet__c            = objPd.DirectorDetails.Location.Street;
                    objCurDir.SafCDDDLocationDistrict__c            = objPd.DirectorDetails.Location.District;
                   
                    objCurDir.SafCDDDLocationPostTown__c           = objPd.DirectorDetails.Location.PostTown;
                    objCurDir.SafCDDDLocationPostcode__c           = objPd.DirectorDetails.Location.Postcode;
                    objCurDir.SafCDDDLocationRMC__c                = objPd.DirectorDetails.Location.RMC;
                   
                    objCurDir.SafCDOccupation__c                   = objPd.DirectorDetails.Occupation;
                    objCurDir.SafCDNationality__c                  = objPd.DirectorDetails.Nationality;
                    objCurDir.SafCDShareInformation__c             = objPd.DirectorDetails.ShareInformation;
                     objCurDir.SAF_Experian_Info__c              = experianInfo.id;
                     multiObject.add(objCurDir);
               }
            system.debug('generateManagementInfo successfully');
            }
       }
    }
    
        public void generateLimitedCompanyCIFAS(SAF_Experian_Info__c experianInfo)
    {
        if(experian.LimitedCompanyCIFAS != null)
        {
            if(experian.LimitedCompanyCIFAS.LimitedCompanyCIFASDetails != null)
            {
                 for(Saf_Experain.cls_LimitedCompanyCIFASDetails objCIFAS:experian.LimitedCompanyCIFAS.LimitedCompanyCIFASDetails)
                {
                    Saf_LimitedCompanyCIFAS__c objLCCIFASDet = new Saf_LimitedCompanyCIFAS__c();
                    objLCCIFASDet.SafCIFASReference__c                = objCIFAS.Reference;
                    objLCCIFASDet.SafCIFASFraudCategory__c            = objCIFAS.FraudCategory;
                    objLCCIFASDet.Saf_CIFAS_FraudCategoryDesc__c      = GetExperianCodeValue('FraudCategory',objCIFAS.FraudCategory); 
                    objLCCIFASDet.SafCIFASSupplierName__c             = objCIFAS.SupplierName;   
                    objLCCIFASDet.SafCIFASOtherAddressFlag__c         = objCIFAS.OtherAddressFlag;
                    objLCCIFASDet.SafCIFASName__c                     = objCIFAS.Name;
                    objLCCIFASDet.SafCIFASAddress1__c                   = objCIFAS.Address1;
                    objLCCIFASDet.SafCIFASAddress2__c                   = objCIFAS.Address2;
                    objLCCIFASDet.SafCIFASAddress3__c                   = objCIFAS.Address3;
                    objLCCIFASDet.SafCIFASPostcode__c                   = objCIFAS.Postcode;
                     if(objCIFAS.Date1 != null)
                    {
                    
                    objLCCIFASDet.SafCIFASDateSupplied__c = date.valueOf(objCIFAS.Date1.DateSuppliedYyyy +'-'+ objCIFAS.Date1.DateSuppliedMm +'-'+ objCIFAS.Date1.DateSuppliedDd);
                    objLCCIFASDet.SafCIFASExpiryDate__c = date.valueOf(objCIFAS.Date1.ExpiryDateYyyy +'-'+ objCIFAS.Date1.ExpiryDateMm +'-'+objCIFAS.Date1.ExpiryDateDd);
                    system.debug('**************CIFASDateSuppliedValue*****'+objLCCIFASDet.SafCIFASDateSupplied__c);
                    } 
                    //objLCCIFASDet.SafCIFASDateSupplied__c = Date.newInstance(Integer.valueof(objCIFAS.Date1.DateSuppliedYyyy), Integer.valueof(objCIFAS.Date1.DateSuppliedMm), Integer.valueof(objCIFAS.Date1.DateSuppliedDd));
                    //objLCCIFASDet.SafCIFASExpiryDate__c = Date.newInstance(Integer.valueof(objCIFAS.Date1.ExpiryDateYyyy), Integer.valueof(objCIFAS.Date1.ExpiryDateMm), Integer.valueof(objCIFAS.Date1.ExpiryDateDd));
                    objLCCIFASDet.SAF_Experian_Info__c              = experianInfo.id;
                     multiObject.add(objLCCIFASDet);
                }
            }
             if(experian.LimitedCompanyCIFAS.LimitedCompanyCIFASSummary != null)
            {
                 Saf_LimitedCompanyCIFASSummary__c objCifasSum = new Saf_LimitedCompanyCIFASSummary__c();
                 objCifasSum.SAF_Experian_Info__c              = experianInfo.id;
                 objCifasSum.SafCIFASNumCIFASRecords__c = Decimal.valueof(experian.LimitedCompanyCIFAS.LimitedCompanyCIFASSummary.NumCIFASRecords);
                 multiObject.add(objCifasSum );
                system.debug('generateLimitedCompanyCIFAS successfully');
             }
       }
    }
    public void generateLimitedCompanyDelphiDirector(SAF_Experian_Info__c experianInfo)
    {
        if(experian.LimitedCompanyDelphiDirector != null)
        {
             for(Saf_Experain.cls_LimitedCompanyDelphiDirector objLCDD:experian.LimitedCompanyDelphiDirector)
            {
                Saf_LimitedCompanyDelphiDirector__c objDD = new Saf_LimitedCompanyDelphiDirector__c();
                 objDD.SAF_Experian_Info__c = experianInfo.id;
                objDD.SafDDMaxOtherDirectorships__c          = objLCDD.MaxOtherDirectorships;
                objDD.SafDDNumCreditorsWindDown__c           = objLCDD.NumCreditorsWindDown;
                objDD.SafDDNumConvictions__c                 = objLCDD.NumConvictions;
                objDD.SafDDNumCCJLast12month__c              = objLCDD.NumCCJLast12month;
                objDD.SafDDValueCCJLast12month__c            = objLCDD.ValueCCJLast12month;
                objDD.SafDDPercentageFailures__c             = objLCDD.PercentageFailures;
                objDD.SafDDNumFailures__c                    = objLCDD.NumFailures;
                objDD.SafDDDirectorhsipsCreditorWindDown__c  = objLCDD.DirectorhsipsCreditorWindDown;
    
                 multiObject.add(objDD);
            }
             
        }
        system.debug('generateLimitedCompanyDelphiDirector successfully');
    }
    public void generateIdentification(SAF_Experian_Info__c experianInfo) 
    { 
        Saf_Identification__c objIde = new Saf_Identification__c(); 
 
        objIde.SAF_Experian_Info__c = experianInfo.id;
        System.debug('==='+experian.Identification.LegalStatus);
        
        objIde.SafIDLegalStatus__c       = GetExperianCodeValue('LegalStatus',experian.Identification.LegalStatus);
        objIde.SafIDIncorporationDate__c = (experian.Identification.IncorporationDate != null) ? Date.valueof(experian.Identification.IncorporationDate) : null;
        
        if(experian.Identification.RegisteredOffice != null)
        {
        objIde.SafIDROLocationLine1__c  = experian.Identification.RegisteredOffice.LocationLine1;
        objIde.SafIDROLocationLine2__c  = experian.Identification.RegisteredOffice.LocationLine2;
        objIde.SafIDROLocationLine3__c  = experian.Identification.RegisteredOffice.LocationLine3;
        objIde.SafIDROLocationLine4__c  = experian.Identification.RegisteredOffice.LocationLine4;
        objIde.SafIDROPostcode__c       = experian.Identification.RegisteredOffice.Postcode;
        }    
        objIde.SafIDCurrency__c           = experian.Identification.Currencyiso;
        objIde.SafIDIssuedCapital__c      = experian.Identification.IssuedCapital;
        objIde.SafIDAsRegisteredOffice__c = GetExperianCodeValue('AsRegisteredOffice',experian.Identification.AsRegisteredOffice);
        objIde.SAF_TradingTelephoneNum__c = experian.Identification.TradingTelephoneNum;
        objIde.SAF_PrincipalActivities__c= experian.Identification.PrincipalActivities;  
        if(experian.Identification.TradingLocation != null)
        {   
        objIde.SafIDTLLocationLine1__c  = experian.Identification.TradingLocation.LocationLine1;
        objIde.SafIDTLLocationLine2__c  = experian.Identification.TradingLocation.LocationLine2;
        objIde.SafIDTLLocationLine3__c  = experian.Identification.TradingLocation.LocationLine3;
        objIde.SafIDTLLocationLine4__c  = experian.Identification.TradingLocation.LocationLine4;
        objIde.SafIDTLPostcode__c       = experian.Identification.TradingLocation.Postcode;
        }
        if(experian.Identification.ThomsonData != null)
        {   
        objIde.SAF_TD_URL__c  = experian.Identification.ThomsonData.URL;
        //objIde.SAF_TD_LastUpdatedDate__c  = experian.Identification.ThomsonData.LastUpdatedDate;
        objIde.SAF_TD_ThomsonPremiseCode__c = experian.Identification.ThomsonData.ThomsonPremiseCode;
        objIde.SAF_TD_ThomsonCustNumber__c = experian.Identification.ThomsonData.ThomsonCustNumber;
        //objIde.SafIDTLPostcode__c       = experian.Identification.TradingLocation.Postcode;
        }
        if(experian.Identification.Auditor !=null)
        {
        //objIde.Saf_ID_AD_Currency__c       = experian.Identification.Auditor.Currencyiso;
        objIde.Saf_ID_AD_AuditType__c      = experian.Identification.Auditor.AuditType;
        objIde.Saf_ID_AD_AuditQual__c      = experian.Identification.Auditor.AuditQual;
        objIde.Saf_ID_AD_Auditors__c       = experian.Identification.Auditor.Auditors;          
        }
       
        if(experian.Identification.FilingDetails !=null)
        {                 
        Saf_Identification_FillingDetails__c objFD  = new Saf_Identification_FillingDetails__c();
        objFD.SafIDFDDatabaseAccountsOutOfDate__c  = GetExperianCodeValue('DatabaseAccount',experian.Identification.FilingDetails.DatabaseAccountsOutOfDate);
        objFD.SafIDFDFiledAccountsOutOfDate__c     = experian.Identification.FilingDetails.FiledAccountsOutOfDate;
        objFD.SafIDFDLatestAccounts__c     = experian.Identification.FilingDetails.LatestAccounts;
        objFD.SafIDFDLatestReturns__c     = experian.Identification.FilingDetails.LatestReturns;
        objFD.SafIDFDLatestReturnsDatabase__c     = experian.Identification.FilingDetails.LatestReturnsDatabase;
        objFD.SafIDFDLatestAccountsDatabase__c     = experian.Identification.FilingDetails.LatestAccountsDatabase;        
        objFD.SafIDFDNumAccountsOnFile__c          = experian.Identification.FilingDetails.NumAccountsOnFile;
        objFD.SafIDFDLatestAccountType__c          = GetExperianCodeValue('LatestAccount',experian.Identification.FilingDetails.LatestAccountType);
        objFD.SafIDFDAccountsRefDate__c           = Date.newInstance(2000, Integer.valueof(experian.Identification.FilingDetails.AccountsRefDate.MM), Integer.valueof(experian.Identification.FilingDetails.AccountsRefDate.MM));
        objFD.SAF_Experian_Info__c = experianInfo.id;
        multiObject.add(objFD);
        }       
        //Saf_PreviousSearchDetail__c objPSD      = Saf_PreviousSearchDetail__c();
         if(experian.Identification.PrevSearches !=null)
        { 
        objIde.SafIDPVNumPrevSearch__c              = (experian.Identification.PrevSearches.NumPrevSearch!=null) ? Decimal.valueof(experian.Identification.PrevSearches.NumPrevSearch) : null;
        objIde.SafIDPVNumPrevSearch3Mth__c          = (experian.Identification.PrevSearches.NumPrevSearch3Mth!=null) ?  Decimal.valueof(experian.Identification.PrevSearches.NumPrevSearch3Mth) :null;
        objIde.SafIDPVNumPrevSearch6Mth__c          =  (experian.Identification.PrevSearches.NumPrevSearch6Mth!=null) ? Decimal.valueof(experian.Identification.PrevSearches.NumPrevSearch6Mth) :null;
        objIde.SafIDPVNumPrevSearch12Mth__c         = (experian.Identification.PrevSearches.NumPrevSearch12Mth!=null) ?  Decimal.valueof(experian.Identification.PrevSearches.NumPrevSearch12Mth) :null;
        
        
         if(experian.Identification.SICInformation1992 != null)
        {       
            for(Saf_Experain.cls_SICInformation1992 obj1992:experian.Identification.SICInformation1992)
            {
                Saf_SICInformation__c objsic = new Saf_SICInformation__c();
                objsic.SAF_Experian_Info__c   = experianInfo.id;
                objsic.Saf_SIC_Code__c = obj1992.Code;
                objsic.Saf_SIC_Description__c = obj1992.Description;
                objsic.Saf_SIC_SicYear__c = '1992';
                multiObject.add(objsic);    
            }
        }
        if(experian.Identification.SICInformation1980 != null)
        {
            for(Saf_Experain.cls_SICInformation1980 obj1980:experian.Identification.SICInformation1980)
            {
                Saf_SICInformation__c objsic = new Saf_SICInformation__c();
                objsic.SAF_Experian_Info__c   = experianInfo.id;
                objsic.Saf_SIC_Code__c = obj1980.Code;
                objsic.Saf_SIC_Description__c = obj1980.Description;
                objsic.Saf_SIC_SicYear__c = '1980';
                multiObject.add(objsic);    
            }
        }
         if(experian.Identification.PrevSearches.PreviousSearchDetail !=null)
         {
            for(Saf_Experain.cls_PreviousSearchDetail objpsd:experian.Identification.PrevSearches.PreviousSearchDetail)
            {
                
                Saf_PreviousSearchDetail__c objPreSD  = new Saf_PreviousSearchDetail__c();
                objPreSD.SAF_Experian_Info__c      = experianInfo.id;
                objPreSD.SafPSDSearchDate__c        = (objpsd.SearchDate != null) ? Date.valueof(objpsd.SearchDate) : null;//Date.valueof(objpsd.SearchDate);
                objPreSD.SafPSDEnquiryType__c       = GetExperianCodeValue('EnquiryType',objpsd.EnquiryType);
                objPreSD.SafPSDOwnEnquiryFlag__c    = GetExperianCodeValue('OwnEnquiryFlag',objpsd.OwnEnquiryFlag);
                
                Saf_SICInformation__c objsic = new Saf_SICInformation__c();
                objsic.SAF_Experian_Info__c   = experianInfo.id;
                objsic.Saf_SIC_Code__c = objpsd.SICInformation.Code;
                objsic.Saf_SIC_Description__c = objpsd.SICInformation.Description;
                objsic.Saf_SIC_Type__c = objpsd.SICInformation.Type;
                
                multiObject.add(objsic);    
                multiObject.add(objPreSD);  
             }  
            } 
       }   multiObject.add(objIde);
        Saf_CCLs__c  objCCLs = new Saf_CCLs__c();
         if(experian.Identification.CCLs !=null)
         {
        objCCLs.SafCCLsTotalNumberCCL__c = Decimal.valueof(experian.Identification.CCLs.TotalNumberCCL);
        objCCLs.SAF_Experian_Info__c   = experianInfo.id;
        multiObject.add(objCCLs); 
        } system.debug('generateIdentification successfully'); 
    }
    
    public void GenerateMortgages(SAF_Experian_Info__c experianInfo) 
    { 
       if(experian.Mortgages !=null)
         {
            Saf_Mortgages__c objMor = new Saf_Mortgages__c();   
            
            objMor.SAF_Experian_Info__c = experianInfo.id;  
            
            objMor.SafMNumMortgages__c      = Decimal.valueof(experian.Mortgages.NumMortgages);
            objMor.SafMNumSatMortgages__c   = Decimal.valueof(experian.Mortgages.NumSatMortgages);
            objMor.SafMNumUnsatMortgages__c = Decimal.valueof(experian.Mortgages.NumUnsatMortgages);
             multiObject.add(objMor); 
             
             if(experian.Mortgages.MortgageDetail != null)
             { 
                 for(Saf_Experain.cls_MortgageDetail objmd:experian.Mortgages.MortgageDetail)
                {
                    Saf_MortgageDetail__c objMorDetail = new Saf_MortgageDetail__c();
                    objMorDetail.SAF_Experian_Info__c  = experianInfo.id;
                    objMorDetail.SafMDAmountLatestIssue__c= objmd.AmountLatestIssue;
                    objMorDetail.SafMDChargeNumber__c= objmd.ChargeNumber;
                    objMorDetail.SafMDChargeType__c= objmd.ChargeType;
                    objMorDetail.SafMDCreationDate__c= objmd.CreationDate;
                    objMorDetail.SafMDCurrency__c= objmd.Currencyiso;
                    objMorDetail.SafMDFormType__c= GetExperianCodeValue('MotagesFormType',objmd.FormType);//objmd.FormType;
                    objMorDetail.SafMDFullySatisfiedIndicator__c= objmd.FullySatisfiedIndicator;
                    objMorDetail.SafMDNumberCommissionElements__c= objmd.NumberCommissionElements;
                    objMorDetail.SafMDNumberExecutionDates__c= objmd.NumberExecutionDates;
                    objMorDetail.SafMDNumberExecutors__c= objmd.NumberExecutors;
                    objMorDetail.SafMDNumberLenders__c= objmd.NumberLenders;
                    objMorDetail.SafMDNumberReceiverAppointmentDates__c= objmd.NumberReceiverAppointmentDates;
                    objMorDetail.SafMDNumberReceiverCessationDates__c= objmd.NumberReceiverCessationDates;
                    objMorDetail.SafMDNumberTrustees__c= objmd.NumberTrustees;
                    objMorDetail.SafMDNumberPartialSatisfactionDates__c= objmd.NumberPartialSatisfactionDates;
                    objMorDetail.Saf_MD_NumPartialSatDataItems__c= objmd.NumberPartialSatisfactionDataItems;
                    objMorDetail.SafMDPropertyDetails__c= objmd.PropertyDetails;
                    objMorDetail.SafMDRegistrationDate__c= objmd.RegistrationDate;
                    objMorDetail.SafMDTotalDebenture__c= objmd.TotalDebenture;
                    objMorDetail.Saf_MD_FullySatisfiedDate__c= objmd.DateFullySatisfied;
                    string strlenderNames = '';
                    if(objmd.LenderDetails !=null)
                    {
                   
                    for(Saf_Experain.cls_LenderDetails objld:objmd.LenderDetails)
                      {
                          /*Saf_MD_LenderDetails__c objLdetails = new Saf_MD_LenderDetails__c();
                          objLdetails.Saf_MD_LenderName__c = objld.LenderName;
                          objLdetails.SAF_Experian_Info__c  = experianInfo.id;
                          multiObject.add(objLdetails);*/
                          strlenderNames = strlenderNames + ','+ objld.LenderName;
                      }
                     
                    } 
                    objMorDetail.saf_LenderDetails__c = strlenderNames; 
                    multiObject.add(objMorDetail);
                  /*  multiObject.add(objMorDetail);
                    if(objmd.LenderDetails !=null)
                    {
                    for(Saf_Experain.cls_LenderDetails objld:objmd.LenderDetails)
                      {
                          Saf_MD_LenderDetails__c objLdetails = new Saf_MD_LenderDetails__c();
                          objLdetails.Saf_MD_LenderName__c = objld.LenderName;
                          objLdetails.SAF_Experian_Info__c  = experianInfo.id;
                          multiObject.add(objLdetails);
                      }
                     
                    } */
                }
             }
           system.debug('GenerateMortgages successfully'); 
        }
    }
    
    public void GenerateCCJs(SAF_Experian_Info__c experianInfo) 
    { 
        if(experian.CCJs !=null)
         {
        Saf_CCJ__c objCcj = new Saf_CCJ__c(); 
 
        objCcj.SAF_Experian_Info__c = experianInfo.id;                                  
       
        objCcj.SafCCJNumberCCJs0To72__c =  String.IsBlank(experian.CCJs.NumberCCJs0To72) ? null: Decimal.valueof(experian.CCJs.NumberCCJs0To72); 
        objCcj.SafCCJNumberCCJs13To24__c =  String.IsBlank(experian.CCJs.NumberCCJs13To24) ? null: Decimal.valueof(experian.CCJs.NumberCCJs13To24); 
        objCcj.SafCCJNumberCCJs25To36__c =  String.IsBlank(experian.CCJs.NumberCCJs25To36) ? null: Decimal.valueof(experian.CCJs.NumberCCJs25To36); 
        objCcj.SafCCJNumberCCJs37To48__c =  String.IsBlank(experian.CCJs.NumberCCJs37To48) ? null: Decimal.valueof(experian.CCJs.NumberCCJs37To48); 
        objCcj.SafCCJNumberCCJs49To60__c =  String.IsBlank(experian.CCJs.NumberCCJs49To60) ? null: Decimal.valueof(experian.CCJs.NumberCCJs49To60); 
        objCcj.SafCCJNumberCCJs61To72__c =  String.IsBlank(experian.CCJs.NumberCCJs61To72) ? null: Decimal.valueof(experian.CCJs.NumberCCJs61To72); 
        objCcj.SafCCJNumberCCJsLast12Months__c =  String.IsBlank(experian.CCJs.NumberCCJsLast12Months) ? null: Decimal.valueof(experian.CCJs.NumberCCJsLast12Months); 
        objCcj.SafCCJValueCCJs0To72__c =  String.IsBlank(experian.CCJs.ValueCCJs0To72) ? null: Decimal.valueof(experian.CCJs.ValueCCJs0To72); 
        objCcj.SafCCJValueCCJs13To24__c =  String.IsBlank(experian.CCJs.ValueCCJs13To24) ? null: Decimal.valueof(experian.CCJs.ValueCCJs13To24); 
        objCcj.SafCCJValueCCJs25To36__c =  String.IsBlank(experian.CCJs.ValueCCJs25To36) ? null: Decimal.valueof(experian.CCJs.ValueCCJs25To36); 
        objCcj.SafCCJValueCCJs37To48__c =  String.IsBlank(experian.CCJs.ValueCCJs37To48) ? null: Decimal.valueof(experian.CCJs.ValueCCJs37To48); 
        objCcj.SafCCJValueCCJs49To60__c =  String.IsBlank(experian.CCJs.ValueCCJs49To60) ? null: Decimal.valueof(experian.CCJs.ValueCCJs49To60); 
        objCcj.SafCCJValueCCJs61To72__c =  String.IsBlank(experian.CCJs.ValueCCJs61To72) ? null: Decimal.valueof(experian.CCJs.ValueCCJs61To72); 
        objCcj.SafCCJValueCCJsLast12Months__c =  String.IsBlank(experian.CCJs.ValueCCJsLast12Months) ? null: Decimal.valueof(experian.CCJs.ValueCCJsLast12Months); 

         multiObject.add(objCcj); 
         system.debug('GenerateCCJs successfully');   
        }
    }
       public void generateCCJDetails(SAF_Experian_Info__c experianInfo)
    {
       integer intccj = 0;
       if(experian.CCJs != null && experian.CCJs.CCJDetail != null )
       {
            for(Saf_Experain.cls_CCJDetail objccjdetails:experian.CCJs.CCJDetail)
            {
                SAF_Experian_CCJDetail__c CCJDetails= new SAF_Experian_CCJDetail__c();
                CCJDetails.SAF_Experian_Info__c              = experianInfo.id;
                CCJDetails.SAF_JudgmentType__c              = GetExperianCodeValue('JudgmentType',objccjdetails.JudgmentType);
                CCJDetails.SAF_JudgmentSource__c               = GetExperianCodeValue('JudgmentSource',objccjdetails.JudgmentSource);
                CCJDetails.SAF_JudgmentDate__c               = objccjdetails.JudgmentDate;//!=Null ? date.valueOf(objccjdetails.JudgmentDate): null;
                CCJDetails.SAF_SatisfactionDate__c             = objccjdetails.SatisfactionDate;
                CCJDetails.SAF_JudgmentAmount__c               = objccjdetails.JudgmentAmount;
                CCJDetails.SAF_CaseNumber__c            = objccjdetails.CaseNumber;
                CCJDetails.SAF_JudgmentAgainst__c            = objccjdetails.JudgmentAgainst;
                CCJDetails.SAF_CourtName__c            = objccjdetails.CourtName;
               if(objccjdetails.TradingLocation != null)
                {
                CCJDetails.SAF_LocationLine1__c           = objccjdetails.TradingLocation.LocationLine1;  
                CCJDetails.SAF_LocationLine2__c           = objccjdetails.TradingLocation.LocationLine2;
                CCJDetails.SAF_LocationLine3__c           = objccjdetails.TradingLocation.LocationLine3;
                CCJDetails.SAF_LocationLine4__c           = objccjdetails.TradingLocation.LocationLine4;
                CCJDetails.SAF_LocationLine5__c           = objccjdetails.TradingLocation.LocationLine5;
                }
                intccj = intccj+1;
                if(intccj<=25){multiObject.add(CCJDetails);}
            }
        }
        
        system.debug('CCJDetails generated successfully');
    }
    public void generateFinancialAccounts(SAF_Experian_Info__c experianInfo)
    {
       if(experian.Financials != null && experian.Financials.Accounts != null)
       {
        for(Saf_Experain.cls_Accounts objFA:experian.Financials.Accounts)
        {
            Saf_FinancialsAccounts__c objFAccnts      = new Saf_FinancialsAccounts__c();
            objFAccnts.Saf_FA_DateOfAccounts__c       = (objFA.DateOfAccounts != null) ? Date.valueof(objFA.DateOfAccounts) : null;//Date.valueof(objFA.DateOfAccounts);
            objFAccnts.SafFAAccountingPeriod__c       = objFA.AccountingPeriod;
            //objFAccnts.Saf_FA_Currency__c           = objFA.Currencyiso;
            objFAccnts.Saf_FA_CurrencyMultiplier__c   = objFA.CurrencyisoMultiplier;
            objFAccnts.Saf_FA_CompanyClass__c         = objFA.CompanyClass;
            objFAccnts.Saf_FA_ConsolidatedAccounts__c = objFA.ConsolidatedAccounts;
            objFAccnts.Saf_FA_DormancyFlag__c         = objFA.DormancyFlag;
            objFAccnts.Saf_FA_LatestAccountsType__c   = objFA.LatestAccountsType;

            objFAccnts.SAF_Experian_Info__c           = experianInfo.id;
            
            if(objFa.BalanceSheet != null)
            {
                if(objFa.BalanceSheet.TangibleAssetsDetails != null) 
                {
                    objFAccnts.SafFABSTangibleAssets__c   = objFa.BalanceSheet.TangibleAssetsDetails.TangibleAssets;
                    objFAccnts.SafFABSFreehold__c         = objFa.BalanceSheet.TangibleAssetsDetails.Freehold;
                    objFAccnts.SafFABSLeasehold__c        = objFa.BalanceSheet.TangibleAssetsDetails.Leasehold;
                    objFAccnts.SafFABSFixturesFittings__c = objFa.BalanceSheet.TangibleAssetsDetails.FixturesFittings;
                    objFAccnts.SafFABSPlantVehicles__c    = objFa.BalanceSheet.TangibleAssetsDetails.PlantVehicles;
                    objFAccnts.SafFABSPlant__c            = objFa.BalanceSheet.TangibleAssetsDetails.Plant;
                    objFAccnts.SafFABSVehicles__c         = objFa.BalanceSheet.TangibleAssetsDetails.Vehicles;
                }
            
                objFAccnts.SafFABSIntangibleAssets__c  = objFa.BalanceSheet.IntangibleAssets;
                if(objFa.BalanceSheet.OtherNonCurrentAssetsDetails != null)
                {objFAccnts.SafFABSOtherNonCurrentAssets__c = objFa.BalanceSheet.OtherNonCurrentAssetsDetails.OtherNonCurrentAssets;}           
                objFAccnts.Saf_FA_BS_TotalFixedNCAssets__c  = objFa.BalanceSheet.TotalFixedNonCurrentAssets;
                
                if(objFa.BalanceSheet.InventoriesDetails != null)
                {
                    objFAccnts.SafFABSInventories__c      = objFa.BalanceSheet.InventoriesDetails.Inventories;
                    objFAccnts.SafFABSRawMaterialStock__c = objFa.BalanceSheet.InventoriesDetails.RawMaterialStock;
                    objFAccnts.SafFABSWorkInProgress__c   = objFa.BalanceSheet.InventoriesDetails.WorkInProgress;
                    objFAccnts.SafFABSFinishedGoods__c    = objFa.BalanceSheet.InventoriesDetails.FinishedGoods;
                }                
                
                if(objFa.BalanceSheet.DebtorsDetails != null)
                {objFAccnts.SafFABSDebtors__c = objFa.BalanceSheet.DebtorsDetails.Debtors;}
                // objFAccnts.SafFABSAccountsReceivableTradeDebtors__c = objFa.BalanceSheet.DebtorsDetails.AccountsReceivableTradeDebtors;
                // objFAccnts.SafFABSOtherDebtors__c                   = objFa.BalanceSheet.DebtorsDetails.OtherDebtors;
                
                if(objFa.BalanceSheet.TotalCashDetails != null)
                {objFAccnts.SafFABSTotalCash__c = objFa.BalanceSheet.TotalCashDetails.TotalCash;}
                
                if(objFa.BalanceSheet.OtherCurrentAssetsDetails != null)
                {objFAccnts.SafFABSOtherCurrentAssets__c = objFa.BalanceSheet.OtherCurrentAssetsDetails.OtherCurrentAssets;}
                
                objFAccnts.SafFABSTotalCurrentAssets__c = objFa.BalanceSheet.TotalCurrentAssets;
                
                //objFAccnts.SafFABSAccountsPayableTradeCreditors__c = objFa.BalanceSheet.CreditorsDetails.AccountsPayableTradeCreditors;
                //objFAccnts.SafFABSSocialSecurityVAT__c             = objFa.BalanceSheet.CreditorsDetails.SocialSecurityVAT;
                //objFAccnts.SafFABSTaxationPayable__c               = objFa.BalanceSheet.CreditorsDetails.TaxationPayable;
                
                if(objFa.BalanceSheet.FinancialLiabilitiesDetails !=null)
                {
                    objFAccnts.SafFABSBankOverdraft__c = objFa.BalanceSheet.FinancialLiabilitiesDetails.BankOverdraft;
                }
                
                if(objFa.BalanceSheet.OtherCurrentLiabilitiesDetails != null)
                {objFAccnts.SafFABSOtherCurrentLiabilities__c = objFa.BalanceSheet.OtherCurrentLiabilitiesDetails.OtherCurrentLiabilities;}
                
                objFAccnts.SafFABSTotalCurrentLiabilities__c = objFa.BalanceSheet.TotalCurrentLiabilities;
                objFAccnts.SafFABSWorkingCapital__c          = objFa.BalanceSheet.WorkingCapital;
                objFAccnts.SafFABSCapitalEmployed__c         = objFa.BalanceSheet.CapitalEmployed;
                
                 if(objFa.BalanceSheet.LongTermFinancialLiabilitiesDetails !=null)
                {
                objFAccnts.SafFABSOtherLongTermLoans__c   = objFa.BalanceSheet.LongTermFinancialLiabilitiesDetails.OtherLongTermLoans;
                }
                
                if(objFa.BalanceSheet.OtherNonCurrentLiabilitiesDetails != null)
                {objFAccnts.SafFABSOtherNonCurrentLiabilities__c  = objFa.BalanceSheet.OtherNonCurrentLiabilitiesDetails.OtherNonCurrentLiabilities;}
                
                objFAccnts.SafFABSTotalNonCurrentLiabilities__c   = objFa.BalanceSheet.TotalNonCurrentLiabilities;
                
                if(objFa.BalanceSheet.ProvisionsDetails != null)
                {
                    objFAccnts.SafFABSProvisions__c          = objFa.BalanceSheet.ProvisionsDetails.Provisions;
                    objFAccnts.SafFABSDeferredTaxation__c    = objFa.BalanceSheet.ProvisionsDetails.DeferredTaxation;
                    objFAccnts.SafFABSPension__c             = objFa.BalanceSheet.ProvisionsDetails.Pension;
                    objFAccnts.SafFABSOtherProvision__c      = objFa.BalanceSheet.ProvisionsDetails.OtherProvision;
                }
                objFAccnts.SafFABSMinorityInterestsUKGAAP__c = objFa.BalanceSheet.MinorityInterestsUKGAAP;
                objFAccnts.SafFABSNetAssets__c               = objFa.BalanceSheet.NetAssets;
                
                if(objFa.BalanceSheet.IssuedCapitalDetails != null)
                {
                    objFAccnts.SafFABSIssuedCapital__c       = objFa.BalanceSheet.IssuedCapitalDetails.IssuedCapital;
                    objFAccnts.SafFABSOrdinaryShares__c      = objFa.BalanceSheet.IssuedCapitalDetails.OrdinaryShares;
                    objFAccnts.SafFABSPreferenceShares__c    = objFa.BalanceSheet.IssuedCapitalDetails.PreferenceShares;
                    objFAccnts.SafFABSOther__c               = objFa.BalanceSheet.IssuedCapitalDetails.Other;
                }
                objFAccnts.SafFABSSharePremium__c            = objFa.BalanceSheet.SharePremium;
                objFAccnts.SafFABSRetainedEarnings__c        = objFa.BalanceSheet.RetainedEarnings;
                objFAccnts.SafFABSRevaluationReserve__c      = objFa.BalanceSheet.RevaluationReserve;
                objFAccnts.SafFABSOther__c                   = objFa.BalanceSheet.Other;
                objFAccnts.SafFABSTotalShareholdersFunds__c  = objFa.BalanceSheet.TotalShareholdersFunds;
                objFAccnts.SafFABSNetWorth__c                = objFa.BalanceSheet.NetWorth;
                    
               // objFAccnts.SafFAPLInterestPayableDetails__c       = objFa.ProfitLoss.InterestPayableDetails;
               // objFAccnts.SafFADiscontinuedOperations__c         = objFa.BalanceSheet.DiscontinuedOperations;
               // objFAccnts.SafFADI_EmployeeRemunerationDetails__c = objFa.BalanceSheet.DisclosureItems.EmployeeRemunerationDetails;
               // objFAccnts.SafFADI_DirectorRemunerationDetails__c = objFa.BalanceSheet.DisclosureItems.DirectorRemunerationDetails;
                
            }
            
            if(objFa.DisclosureItems != null)
            {
                objFAccnts.SafFADINumberEmployees__c       = objFa.DisclosureItems.NumberEmployees;
                objFAccnts.SafFADIDepreciationCharges__c   = objFa.DisclosureItems.DepreciationCharges;
            }
            objFAccnts.SafFAContingentLiability__c         = objFa.ContingentLiability;
            objFAccnts.SafFAPostBalanceSheetEvents__c      = objFa.PostBalanceSheetEvents;
            objFAccnts.SafFACharitableGivingIndicator__c   = objFa.CharitableGivingIndicator;
            multiObject.add(objFAccnts);
        }
     
       } 

        system.debug('generateFinancialAccounts successfully');
    }
    
    public void generateAlerts(SAF_Experian_Info__c experianInfo)
    {
         if(experian.Alerts != null)
       {
            //Saf_Alerts__c alerts= new Saf_Alerts__c();
            
            for(Saf_Experain.cls_Alerts objalt:experian.Alerts)
            {
                Saf_Alerts__c alerts= new Saf_Alerts__c();
                alerts.SAF_Experian_Info__c    = experianInfo.id;
                alerts.SafAlertsNotesCount__c  = Decimal.ValueOf(objalt.NotesCount);
                alerts.SafAlertsNotesLength__c = Decimal.ValueOf(objalt.NotesLength);
                multiObject.add(alerts);

                if(objalt.Notes != null)
                {   
                for(Saf_Experain.cls_Notes objnote:objalt.Notes)
                  {
                    Saf_Notes__c objnotes = new Saf_Notes__c();
                    
                    objnotes.SAF_Experian_Info__c    = experianInfo.id;
                    objnotes.SafNotesAlertCode__c= objnote.AlertCode;
                    objnotes.SafNotesAlertHeader__c = objnote.AlertHeader;
                    objnotes.SafNotesAlertNote__c = objnote.AlertNote;
                    multiObject.add(objnotes);
                    }
                }
            }
            
            system.debug('Alerts generated successfully');
         }
    }
    
     public void generateCashflows(SAF_Experian_Info__c experianInfo)
    {
       if(experian.Financials != null && experian.Financials.Cashflow != null)
       {
            for(Saf_Experain.cls_Cashflow objCA:experian.Financials.Cashflow)
            {
                Saf_Cashflow__c objCFlows              = new Saf_Cashflow__c();
                objCFlows.SAF_Experian_Info__c         = experianInfo.id;
                objCFlows.SafCFDateOfAccounts__c       = (objCA.DateOfAccounts != null) ? Date.valueof(objCA.DateOfAccounts) : null;//Date.valueof(objCA.DateOfAccounts);
                objCFlows.SafCFAccountingPeriod__c     = objCA.AccountingPeriod;
                objCFlows.SafCFCurrency__c           = objCA.Currencyiso;
                objCFlows.SafCFCurrencyMultiplier__c = objCA.CurrencyMultiplier;
                objCFlows.SafCFCompanyClass__c         = objCA.CompanyClass;
                objCFlows.SafCFConsAccounts__c         = objCA.ConsAccounts;
                objCFlows.SafCFDormancyIndicator__c    = objCA.DormancyIndicator;
                objCFlows.SafCFLatestAccountsType__c   = objCA.LatestAccountsType;
                objCFlows.SafCFRestatedAccounts__c     = objCA.RestatedAccounts;
                multiObject.add(objCFlows);
            }
        
        system.debug('generateCashflows successfully');
      }
    }
    
     public void generateRatios(SAF_Experian_Info__c experianInfo)
    {
     if(experian.Financials !=null && experian.Financials.Ratios!= null)
       {
        for(Saf_Experain.cls_Ratios objRat:experian.Financials.Ratios)
        {
            Saf_Ratios__c objRatios = new Saf_Ratios__c();
            objRatios.SAF_Experian_Info__c             = experianInfo.id;
            objRatios.SafRatioDateOfAccounts__c        = (objRat.DateOfAccounts != null) ? Date.valueof(objRat.DateOfAccounts) : null;//Date.valueof(objRat.DateOfAccounts);
            //objRatios.SafRatioCurrency__c            = objRat.Currencyiso;
            objRatios.SafRatioCompanyClass__c          = objRat.CompanyClass;
            objRatios.SafRatioConsAccounts__c          = objRat.ConsAccounts;
            objRatios.SafRatioCurrentRatio__c          = objRat.CurrentRatio;
            objRatios.SafRatioAcidTest__c              = objRat.AcidTest;
            //objRatios.SafRatioTradeCredrsDebtrs__c   = objRat.TradeCredrsDebtrs;
            //objRatios.SafRatioBorrowingRatio__c      = objRat.BorrowingRatio;
            objRatios.SafRatioEquityGearing__c         = objRat.EquityGearing;
            // objRatios.SafRatioDebtGearing__c        = objRat.DebtGearing;
            // objRatios.SafRatioCapEmployedPerEmp__c  = objRat.CapEmployedPerEmp;
            // objRatios.SafRatioTangAssetsPerEmp__c   = objRat.TangAssetsPerEmp;
            // objRatios.SafRatioTotAssetsPerEmp__c    = objRat.TotAssetsPerEmp;
            // objRatios.SafRatioNumEmployees__c       = objRat.NumEmployees;
            multiObject.add(objRatios);
        }
        
        system.debug('Ratios successfully');
      }
    }
    
    public void generatePercentageChange(SAF_Experian_Info__c experianInfo)
    {
       if(experian.Financials != null && experian.Financials.PercentageChange!= null)
       {
            Saf_PercentageChange__c  objPChange = new Saf_PercentageChange__c();
            objPChange.SAF_Experian_Info__c                    = experianInfo.id;
            objPChange.SafPCDateOfAccounts__c                  = (experian.Financials.PercentageChange.DateOfAccounts != null) ? Date.valueof(experian.Financials.PercentageChange.DateOfAccounts) : null;
            //objPChange.SafPCCurrency__c                      = experian.Financials.PercentageChange.Currencyiso;
            objPChange.SafPCCompanyClass__c                    = experian.Financials.PercentageChange.CompanyClass;
            objPChange.SafPCConsAccounts__c                    = experian.Financials.PercentageChange.ConsAccounts;
            objPChange.SafPCPercentChangeGrossAsset__c         = experian.Financials.PercentageChange.PercentChangeGrossAsset;
            objPChange.SafPCPercentChangeNetWorth__c           = experian.Financials.PercentageChange.PercentChangeNetWorth;
            objPChange.SafPCPercentChangeFixedAssets__c        = experian.Financials.PercentageChange.PercentChangeFixedAssets;
            objPChange.SafPCPercentChangeCurrentAssets__c      = experian.Financials.PercentageChange.PercentChangeCurrentAssets;
            objPChange.SafPCPercentChangeCurrentLiabilities__c = experian.Financials.PercentageChange.PercentChangeCurrentLiabilities;
            objPChange.SafPCPercentChangeWorkingCapital__c     = experian.Financials.PercentageChange.PercentChangeWorkingCapital;
            objPChange.SafPCPercentChangeCapitalEmployed__c    = experian.Financials.PercentageChange.PercentChangeCapitalEmployed;
            objPChange.SafPCPercentChangeNetAssets__c          = experian.Financials.PercentageChange.PercentChangeNetAssets;
            objPChange.SafPCPercentChangeIssuedCapital__c      = experian.Financials.PercentageChange.PercentChangeIssuedCapital;
            objPChange.SafPCPercentChangeRetainedEarnings__c   = experian.Financials.PercentageChange.PercentChangeRetainedEarnings;
            objPChange.SafPCPercentChangeShareholdersFunds__c  = experian.Financials.PercentageChange.PercentChangeShareholdersFunds;
            objPChange.SafPCPercentChangeCurrentRatio__c       = experian.Financials.PercentageChange.PercentChangeCurrentRatio;
            objPChange.SafPCPercentChangeEquityGearing__c      = experian.Financials.PercentageChange.PercentChangeEquityGearing;
            
            multiObject.add(objPChange);
            system.debug('generatePercentageChange successfully');
       }
    }
    
    public void generateFullQuartiles(SAF_Experian_Info__c experianInfo)
    {
        if(experian.Financials != null && experian.Financials.Quartiles != null && experian.Financials.Quartiles.FullQuartiles != null)
        {
            Saf_Quartiles__c objQuat = new Saf_Quartiles__c();
            objQuat.SAF_Experian_Info__c = experianInfo.id;
            
            objQuat.SafFQYearEnd__c= (experian.Financials.Quartiles.FullQuartiles.YearEnd != null) ? Date.valueof(experian.Financials.Quartiles.FullQuartiles.YearEnd) : null;
            objQuat.SafFQNumCompanies__c                    = experian.Financials.Quartiles.FullQuartiles.NumCompanies;
            objQuat.SafFQCurrentRatioLower__c               = experian.Financials.Quartiles.FullQuartiles.CurrentRatioLower;
            objQuat.SafFQCurrentRatioMedian__c              = experian.Financials.Quartiles.FullQuartiles.CurrentRatioMedian;
            objQuat.SafFQCurrentRatioUpper__c               = experian.Financials.Quartiles.FullQuartiles.CurrentRatioUpper;
            objQuat.SafFQAcidTestLower__c                   = experian.Financials.Quartiles.FullQuartiles.AcidTestLower;
            objQuat.SafFQAcidTestMedian__c                  = experian.Financials.Quartiles.FullQuartiles.AcidTestMedian;
            objQuat.SafFQAcidTestUpper__c                   = experian.Financials.Quartiles.FullQuartiles.AcidTestUpper;
            objQuat.SafFQStockTurnoverLower__c              = experian.Financials.Quartiles.FullQuartiles.StockTurnoverLower;
            objQuat.SafFQStockTurnoverMedian__c             = experian.Financials.Quartiles.FullQuartiles.StockTurnoverMedian;
            objQuat.SafFQStockTurnoverUpper__c              = experian.Financials.Quartiles.FullQuartiles.StockTurnoverUpper;
            objQuat.SafFQCreditPeriodLower__c               = experian.Financials.Quartiles.FullQuartiles.CreditPeriodLower;
            objQuat.SafFQCreditPeriodMedian__c              = experian.Financials.Quartiles.FullQuartiles.CreditPeriodMedian;
            objQuat.SafFQCreditPeriodUpper__c               = experian.Financials.Quartiles.FullQuartiles.CreditPeriodUpper;
            objQuat.SafFQWorkingCapLower__c                 = experian.Financials.Quartiles.FullQuartiles.WorkingCapLower;
            objQuat.SafFQWorkingCapMedian__c                = experian.Financials.Quartiles.FullQuartiles.WorkingCapMedian;
            objQuat.SafFQWorkingCapUpper__c                 = experian.Financials.Quartiles.FullQuartiles.WorkingCapUpper;
            objQuat.SafFQTradeCredrsDebtrsLower__c          = experian.Financials.Quartiles.FullQuartiles.TradeCredrsDebtrsLower;
            objQuat.SafFQTradeCredrsDebtrsMedian__c         = experian.Financials.Quartiles.FullQuartiles.TradeCredrsDebtrsMedian;
            objQuat.SafFQTradeCredrsDebtrsUpper__c          = experian.Financials.Quartiles.FullQuartiles.TradeCredrsDebtrsUpper;
            objQuat.SafFQReturnOnCapitalLower__c            = experian.Financials.Quartiles.FullQuartiles.ReturnOnCapitalLower;
            objQuat.SafFQReturnOnCapitalMedian__c           = experian.Financials.Quartiles.FullQuartiles.ReturnOnCapitalMedian;
            objQuat.SafFQReturnOnCapitalUpper__c            = experian.Financials.Quartiles.FullQuartiles.ReturnOnCapitalUpper;
            objQuat.SafFQReturnOnAssetsLower__c             = experian.Financials.Quartiles.FullQuartiles.ReturnOnAssetsLower;
            objQuat.SafFQReturnOnAssetsMedian__c            = experian.Financials.Quartiles.FullQuartiles.ReturnOnAssetsMedian;
            objQuat.SafFQReturnOnAssetsUpper__c             = experian.Financials.Quartiles.FullQuartiles.ReturnOnAssetsUpper;
            objQuat.SafFQPreTaxMarginLower__c               = experian.Financials.Quartiles.FullQuartiles.PreTaxMarginLower;
            objQuat.SafFQPreTaxMarginMedian__c              = experian.Financials.Quartiles.FullQuartiles.PreTaxMarginMedian;
            objQuat.SafFQPreTaxMarginUpper__c               = experian.Financials.Quartiles.FullQuartiles.PreTaxMarginUpper;
            objQuat.SafFQReturnOnShareholdersFundsLower__c  = experian.Financials.Quartiles.FullQuartiles.ReturnOnShareholdersFundsLower;
            objQuat.SafFQReturnOnShareholdersFundsMedian__c = experian.Financials.Quartiles.FullQuartiles.ReturnOnShareholdersFundsMedian;
            objQuat.SafFQReturnOnShareholdersFundsUpper__c  = experian.Financials.Quartiles.FullQuartiles.ReturnOnShareholdersFundsUpper;
            objQuat.SafFQBorrowingRatioLower__c             = experian.Financials.Quartiles.FullQuartiles.BorrowingRatioLower;
            objQuat.SafFQBorrowingRatioMedian__c            = experian.Financials.Quartiles.FullQuartiles.BorrowingRatioMedian;
            objQuat.SafFQBorrowingRatioUpper__c             = experian.Financials.Quartiles.FullQuartiles.BorrowingRatioUpper;
            objQuat.SafFQEquityGearingLower__c              = experian.Financials.Quartiles.FullQuartiles.EquityGearingLower;
            objQuat.SafFQEquityGearingMedian__c             = experian.Financials.Quartiles.FullQuartiles.EquityGearingMedian;
            objQuat.SafFQEquityGearingUpper__c              = experian.Financials.Quartiles.FullQuartiles.EquityGearingUpper;
            objQuat.SafFQDebtGearingLower__c                = experian.Financials.Quartiles.FullQuartiles.DebtGearingLower;
            objQuat.SafFQDebtGearingMedian__c               = experian.Financials.Quartiles.FullQuartiles.DebtGearingMedian;
            objQuat.SafFQDebtGearingUpper__c                = experian.Financials.Quartiles.FullQuartiles.DebtGearingUpper;
            objQuat.SafFQInterestCoverLower__c              = experian.Financials.Quartiles.FullQuartiles.InterestCoverLower;
            objQuat.SafFQInterestCoverMedian__c             = experian.Financials.Quartiles.FullQuartiles.InterestCoverMedian;
            objQuat.SafFQInterestCoverUpper__c              = experian.Financials.Quartiles.FullQuartiles.InterestCoverUpper;
            objQuat.SafFQSalesTangAssetsLower__c            = experian.Financials.Quartiles.FullQuartiles.SalesTangAssetsLower;
            objQuat.SafFQSalesTangAssetsMedian__c           = experian.Financials.Quartiles.FullQuartiles.SalesTangAssetsMedian;
            objQuat.SafFQSalesTangAssetsUpper__c            = experian.Financials.Quartiles.FullQuartiles.SalesTangAssetsUpper;
            objQuat.SafFQAvgRemPerEmpLower__c               = experian.Financials.Quartiles.FullQuartiles.AvgRemPerEmpLower;
            objQuat.SafFQAvgRemPerEmpMedian__c              = experian.Financials.Quartiles.FullQuartiles.AvgRemPerEmpMedian;
            objQuat.SafFQAvgRemPerEmpUpper__c               = experian.Financials.Quartiles.FullQuartiles.AvgRemPerEmpUpper;
            objQuat.SafFQProfitPerEmpLower__c               = experian.Financials.Quartiles.FullQuartiles.ProfitPerEmpLower;
            objQuat.SafFQProfitPerEmpMedian__c              = experian.Financials.Quartiles.FullQuartiles.ProfitPerEmpMedian;
            objQuat.SafFQProfitPerEmpUpper__c               = experian.Financials.Quartiles.FullQuartiles.ProfitPerEmpUpper;
            objQuat.SafFQTurnoverPerEmpLower__c             = experian.Financials.Quartiles.FullQuartiles.TurnoverPerEmpLower;
            objQuat.SafFQTurnoverPerEmpMedian__c            = experian.Financials.Quartiles.FullQuartiles.TurnoverPerEmpMedian;
            objQuat.SafFQTurnoverPerEmpUpper__c             = experian.Financials.Quartiles.FullQuartiles.TurnoverPerEmpUpper;
            objQuat.SafFQCapEmployedPerEmpLower__c          = experian.Financials.Quartiles.FullQuartiles.CapEmployedPerEmpLower;
            objQuat.SafFQCapEmployedPerEmpMedian__c         = experian.Financials.Quartiles.FullQuartiles.CapEmployedPerEmpMedian;
            objQuat.SafFQCapEmployedPerEmpUpper__c          = experian.Financials.Quartiles.FullQuartiles.CapEmployedPerEmpUpper;
            objQuat.SafFQTangAssetsPerEmpLower__c           = experian.Financials.Quartiles.FullQuartiles.TangAssetsPerEmpLower;
            objQuat.SafFQTangAssetsPerEmpMedian__c          = experian.Financials.Quartiles.FullQuartiles.TangAssetsPerEmpMedian;
            objQuat.SafFQTangAssetsPerEmpUpper__c           = experian.Financials.Quartiles.FullQuartiles.TangAssetsPerEmpUpper;
            objQuat.SafFQTotAssetsPerEmpLower__c            = experian.Financials.Quartiles.FullQuartiles.TotAssetsPerEmpLower;
            objQuat.SafFQTotAssetsPerEmpMedian__c           = experian.Financials.Quartiles.FullQuartiles.TotAssetsPerEmpMedian;
            objQuat.SafFQTotAssetsPerEmpUpper__c            = experian.Financials.Quartiles.FullQuartiles.TotAssetsPerEmpUpper;
            objQuat.SafFQEmpRemunerationSalesLower__c       = experian.Financials.Quartiles.FullQuartiles.EmpRemunerationSalesLower;
            objQuat.SafFQEmpRemunerationSalesMedian__c      = experian.Financials.Quartiles.FullQuartiles.EmpRemunerationSalesMedian;
            //objQuat.SafFQEmpRemunerationSalesUpper__c     = experian.Financials.Quartiles.FullQuartiles.EmpRemunerationSalesUpper;
            
            Saf_SICInformation__c objsic    = new Saf_SICInformation__c();
            if(experian.Financials.Quartiles.FullQuartiles.SICInformation1980 != null)
            {
                objsic.SAF_Experian_Info__c     = experianInfo.id;
                objsic.Saf_SIC_Code__c          = experian.Financials.Quartiles.FullQuartiles.SICInformation1980.Code;
                objsic.Saf_SIC_Description__c   = experian.Financials.Quartiles.FullQuartiles.SICInformation1980.Description;
                objsic.Saf_SIC_SicYear__c       = '1980';
                multiObject.add(objsic);    
            }
            
            if(experian.Financials.Quartiles.FullQuartiles.SICInformation1992 != null)
            {
                objsic = new Saf_SICInformation__c();
                objsic.SAF_Experian_Info__c     = experianInfo.id;
                objsic.Saf_SIC_Code__c          = experian.Financials.Quartiles.FullQuartiles.SICInformation1992.Code;
                objsic.Saf_SIC_Description__c   = experian.Financials.Quartiles.FullQuartiles.SICInformation1992.Description;
                objsic.Saf_SIC_SicYear__c       = '1992';
                multiObject.add(objsic);
            }
    
            multiObject.add(objQuat);
            system.debug('generateFullQuartiles successfully');
        }
    }
    
    public void generateMedianQuartiles(SAF_Experian_Info__c experianInfo)
    {
        
        if(experian.Financials != null && experian.Financials.Quartiles != null && experian.Financials.Quartiles.MedianQuartiles != null)
        {
            Saf_Quartiles__c objQuat                         = new Saf_Quartiles__c();
            objQuat.SAF_Experian_Info__c                     = experianInfo.id;
            objQuat.SafFQYearEnd__c                          = (experian.Financials.Quartiles.MedianQuartiles.YearEnd != null) ? Date.valueof(experian.Financials.Quartiles.MedianQuartiles.YearEnd) : null;
            objQuat.SafFQDateOfAccounts__c                   = (experian.Financials.Quartiles.MedianQuartiles.DateOfAccounts != null) ? Date.valueof(experian.Financials.Quartiles.MedianQuartiles.DateOfAccounts) : null;
            objQuat.SafFQNumCompanies__c                     =experian.Financials.Quartiles.MedianQuartiles.NumCompanies;
            objQuat.SafFQCurrentRatioLower__c                =experian.Financials.Quartiles.MedianQuartiles.CurrentRatioLower;
            objQuat.SafFQCurrentRatioMedian__c               =experian.Financials.Quartiles.MedianQuartiles.CurrentRatioMedian;
            objQuat.SafFQCurrentRatioUpper__c                =experian.Financials.Quartiles.MedianQuartiles.CurrentRatioUpper;
            objQuat.SafFQAcidTestLower__c                    =experian.Financials.Quartiles.MedianQuartiles.AcidTestLower;
            objQuat.SafFQAcidTestMedian__c                   =experian.Financials.Quartiles.MedianQuartiles.AcidTestMedian;
            objQuat.SafFQAcidTestUpper__c                    =experian.Financials.Quartiles.MedianQuartiles.AcidTestUpper;
            objQuat.SafFQStockTurnoverLower__c               =experian.Financials.Quartiles.MedianQuartiles.StockTurnoverLower;
            objQuat.SafFQStockTurnoverMedian__c              =experian.Financials.Quartiles.MedianQuartiles.StockTurnoverMedian;
            objQuat.SafFQStockTurnoverUpper__c               =experian.Financials.Quartiles.MedianQuartiles.StockTurnoverUpper;
            objQuat.SafFQCreditPeriodLower__c                =experian.Financials.Quartiles.MedianQuartiles.CreditPeriodLower;
            objQuat.SafFQCreditPeriodMedian__c               =experian.Financials.Quartiles.MedianQuartiles.CreditPeriodMedian;
            objQuat.SafFQCreditPeriodUpper__c                =experian.Financials.Quartiles.MedianQuartiles.CreditPeriodUpper;
            objQuat.SafFQWorkingCapLower__c                  =experian.Financials.Quartiles.MedianQuartiles.WorkingCapLower;
            objQuat.SafFQWorkingCapMedian__c                 =experian.Financials.Quartiles.MedianQuartiles.WorkingCapMedian;
            objQuat.SafFQWorkingCapUpper__c                  =experian.Financials.Quartiles.MedianQuartiles.WorkingCapUpper;
            objQuat.SafFQTradeCredrsDebtrsLower__c           =experian.Financials.Quartiles.MedianQuartiles.TradeCredrsDebtrsLower;
            objQuat.SafFQTradeCredrsDebtrsMedian__c          =experian.Financials.Quartiles.MedianQuartiles.TradeCredrsDebtrsMedian;
            objQuat.SafFQTradeCredrsDebtrsUpper__c           =experian.Financials.Quartiles.MedianQuartiles.TradeCredrsDebtrsUpper;
            objQuat.SafFQReturnOnCapitalLower__c             =experian.Financials.Quartiles.MedianQuartiles.ReturnOnCapitalLower;
            objQuat.SafFQReturnOnCapitalMedian__c            =experian.Financials.Quartiles.MedianQuartiles.ReturnOnCapitalMedian;
            objQuat.SafFQReturnOnCapitalUpper__c             =experian.Financials.Quartiles.MedianQuartiles.ReturnOnCapitalUpper;
            objQuat.SafFQReturnOnAssetsLower__c              =experian.Financials.Quartiles.MedianQuartiles.ReturnOnAssetsLower;
            objQuat.SafFQReturnOnAssetsMedian__c             =experian.Financials.Quartiles.MedianQuartiles.ReturnOnAssetsMedian;
            objQuat.SafFQReturnOnAssetsUpper__c              =experian.Financials.Quartiles.MedianQuartiles.ReturnOnAssetsUpper;
            objQuat.SafFQPreTaxMarginLower__c                =experian.Financials.Quartiles.MedianQuartiles.PreTaxMarginLower;
            objQuat.SafFQPreTaxMarginMedian__c               =experian.Financials.Quartiles.MedianQuartiles.PreTaxMarginMedian;
            objQuat.SafFQPreTaxMarginUpper__c                =experian.Financials.Quartiles.MedianQuartiles.PreTaxMarginUpper;
            objQuat.SafFQReturnOnShareholdersFundsLower__c   =experian.Financials.Quartiles.MedianQuartiles.ReturnOnShareholdersFundsLower;
            objQuat.SafFQReturnOnShareholdersFundsMedian__c  =experian.Financials.Quartiles.MedianQuartiles.ReturnOnShareholdersFundsMedian;
            objQuat.SafFQReturnOnShareholdersFundsUpper__c   =experian.Financials.Quartiles.MedianQuartiles.ReturnOnShareholdersFundsUpper;
            objQuat.SafFQBorrowingRatioLower__c              =experian.Financials.Quartiles.MedianQuartiles.BorrowingRatioLower;
            objQuat.SafFQBorrowingRatioMedian__c             =experian.Financials.Quartiles.MedianQuartiles.BorrowingRatioMedian;
            objQuat.SafFQBorrowingRatioUpper__c              =experian.Financials.Quartiles.MedianQuartiles.BorrowingRatioUpper;
            objQuat.SafFQEquityGearingLower__c               =experian.Financials.Quartiles.MedianQuartiles.EquityGearingLower;
            objQuat.SafFQEquityGearingMedian__c              =experian.Financials.Quartiles.MedianQuartiles.EquityGearingMedian;
            objQuat.SafFQEquityGearingUpper__c               =experian.Financials.Quartiles.MedianQuartiles.EquityGearingUpper;
            objQuat.SafFQDebtGearingLower__c                 =experian.Financials.Quartiles.MedianQuartiles.DebtGearingLower;
            objQuat.SafFQDebtGearingMedian__c                =experian.Financials.Quartiles.MedianQuartiles.DebtGearingMedian;
            objQuat.SafFQDebtGearingUpper__c                 =experian.Financials.Quartiles.MedianQuartiles.DebtGearingUpper;
            objQuat.SafFQInterestCoverLower__c               =experian.Financials.Quartiles.MedianQuartiles.InterestCoverLower;
            objQuat.SafFQInterestCoverMedian__c              =experian.Financials.Quartiles.MedianQuartiles.InterestCoverMedian;
            objQuat.SafFQInterestCoverUpper__c               =experian.Financials.Quartiles.MedianQuartiles.InterestCoverUpper;
            objQuat.SafFQSalesTangAssetsLower__c             =experian.Financials.Quartiles.MedianQuartiles.SalesTangAssetsLower;
            objQuat.SafFQSalesTangAssetsMedian__c            =experian.Financials.Quartiles.MedianQuartiles.SalesTangAssetsMedian;
            objQuat.SafFQSalesTangAssetsUpper__c             =experian.Financials.Quartiles.MedianQuartiles.SalesTangAssetsUpper;
            objQuat.SafFQAvgRemPerEmpLower__c                =experian.Financials.Quartiles.MedianQuartiles.AvgRemPerEmpLower;
            objQuat.SafFQAvgRemPerEmpMedian__c               =experian.Financials.Quartiles.MedianQuartiles.AvgRemPerEmpMedian;
            objQuat.SafFQAvgRemPerEmpUpper__c                =experian.Financials.Quartiles.MedianQuartiles.AvgRemPerEmpUpper;
            objQuat.SafFQProfitPerEmpLower__c                =experian.Financials.Quartiles.MedianQuartiles.ProfitPerEmpLower;
            objQuat.SafFQProfitPerEmpMedian__c               =experian.Financials.Quartiles.MedianQuartiles.ProfitPerEmpMedian;
            objQuat.SafFQProfitPerEmpUpper__c                =experian.Financials.Quartiles.MedianQuartiles.ProfitPerEmpUpper;
            objQuat.SafFQTurnoverPerEmpLower__c              =experian.Financials.Quartiles.MedianQuartiles.TurnoverPerEmpLower;
            objQuat.SafFQTurnoverPerEmpMedian__c             =experian.Financials.Quartiles.MedianQuartiles.TurnoverPerEmpMedian;
            objQuat.SafFQTurnoverPerEmpUpper__c              =experian.Financials.Quartiles.MedianQuartiles.TurnoverPerEmpUpper;
            objQuat.SafFQCapEmployedPerEmpLower__c           =experian.Financials.Quartiles.MedianQuartiles.CapEmployedPerEmpLower;
            objQuat.SafFQCapEmployedPerEmpMedian__c          =experian.Financials.Quartiles.MedianQuartiles.CapEmployedPerEmpMedian;
            objQuat.SafFQCapEmployedPerEmpUpper__c           =experian.Financials.Quartiles.MedianQuartiles.CapEmployedPerEmpUpper;
            objQuat.SafFQTangAssetsPerEmpLower__c            =experian.Financials.Quartiles.MedianQuartiles.TangAssetsPerEmpLower;
            objQuat.SafFQTangAssetsPerEmpMedian__c           =experian.Financials.Quartiles.MedianQuartiles.TangAssetsPerEmpMedian;
            objQuat.SafFQTangAssetsPerEmpUpper__c            =experian.Financials.Quartiles.MedianQuartiles.TangAssetsPerEmpUpper;
            objQuat.SafFQTotAssetsPerEmpLower__c             =experian.Financials.Quartiles.MedianQuartiles.TotAssetsPerEmpLower;
            objQuat.SafFQTotAssetsPerEmpMedian__c            =experian.Financials.Quartiles.MedianQuartiles.TotAssetsPerEmpMedian;
            objQuat.SafFQTotAssetsPerEmpUpper__c             =experian.Financials.Quartiles.MedianQuartiles.TotAssetsPerEmpUpper;
            objQuat.SafFQEmpRemunerationSalesLower__c        =experian.Financials.Quartiles.MedianQuartiles.EmpRemunerationSalesLower;
            objQuat.SafFQEmpRemunerationSalesMedian__c       =experian.Financials.Quartiles.MedianQuartiles.EmpRemunerationSalesMedian;
            //objQuat.SafFQEmpRemunerationSalesUpper__c      =experian.Financials.Quartiles.MedianQuartiles.EmpRemunerationSalesUpper;
            
            Saf_SICInformation__c objsic     = new Saf_SICInformation__c();
            
            if(experian.Financials.Quartiles.MedianQuartiles.SICInformation1980 != null)
            {
                objsic.SAF_Experian_Info__c      = experianInfo.id;
                objsic.Saf_SIC_Code__c           = experian.Financials.Quartiles.MedianQuartiles.SICInformation1980.Code;
                objsic.Saf_SIC_Description__c    = experian.Financials.Quartiles.MedianQuartiles.SICInformation1980.Description;
                objsic.Saf_SIC_SicYear__c        = '1980';
                multiObject.add(objsic);    
            }
            
            if(experian.Financials.Quartiles.MedianQuartiles.SICInformation1992 != null)
            {
                objsic = new Saf_SICInformation__c();
                objsic.SAF_Experian_Info__c      = experianInfo.id;
                objsic.Saf_SIC_Code__c           = experian.Financials.Quartiles.MedianQuartiles.SICInformation1992.Code;
                objsic.Saf_SIC_Description__c    = experian.Financials.Quartiles.MedianQuartiles.SICInformation1992.Description;
                objsic.Saf_SIC_SicYear__c        = '1992';
                multiObject.add(objsic);
            }

            multiObject.add(objQuat);
            system.debug('generateMedianQuartiles successfully');
       }
    }
    
    public void generateNoticeOfCorrection(SAF_Experian_Info__c experianInfo) 
    {
        Saf_NoticeOfCorrection__c noc= new Saf_NoticeOfCorrection__c();
        
        if(experian.NoticeOfCorrection != null)
        {
            noc.SAF_Experian_Info__c       = experianInfo.id;
            noc.SafSDNumCorrections__c     = Decimal.ValueOf(experian.NoticeOfCorrection.NumCorrections);
            //noc.SafSDReportUpdateFlag__c = experian.;
            //noc.CurrencyIsoCode            = 'GBP';
            multiObject.add(noc);
            
            system.debug('Notice Of Correction generated successfully');
        }
    }
     
    public void generateDirectorExpandedSummary(SAF_Experian_Info__c experianInfo)
    {
        
        if(experian.DirectorExpandedSummary != null)
        {
        for(Saf_Experain.cls_DirectorExpandedSummary objdes:experian.DirectorExpandedSummary)
        {
            Saf_DirectorExpandedSummary__c des               = new Saf_DirectorExpandedSummary__c();
            des.SAF_Experian_Info__c                         = experianInfo.id;
            des.SafDESNocFlag__c                           =  (objdes.NocFlag == null) ? objdes.Nolag : objdes.NocFlag;
           // des.CurrencyIsoCode                              = 'GBP';
            des.SafDESNumCIFAS__c                            = Decimal.ValueOf(objdes.NumCIFAS);
            des.SafDESNumConvictions__c                      = Decimal.ValueOf(objdes.NumConvictions);
            des.SafDESNumCurrentDissolvedDirships__c         = Decimal.ValueOf(objdes.NumCurrentDissolvedDirships);
            des.SafDESNumCurrrentDirships__c                 = Decimal.ValueOf(objdes.NumCurrrentDirships);
            des.SafDESNumDirAdmnstrtivRecevrCesstn__c        = Decimal.ValueOf(objdes.NumDirectorshipsAdministrativeReceiverCessation);
            des.SafDESNumDirAppntmntAdmnstrtvRecvr__c        = Decimal.ValueOf(objdes.NumDirectorshipsAppointmentAdministrativeReceiver);
            des.SafDESNumDirApprvlVolntryArngmnt__c          = Decimal.ValueOf(objdes.NumDirectorshipsApprovalVoluntaryArrangements);
            des.SafDESNumDirCompltnVolntryArngmnt__c         = Decimal.ValueOf(objdes.NumDirectorshipsCompletionVoluntaryArrangements);
            des.SafDESNumDirectorshipAdmnstrtrAppointd__c    = Decimal.ValueOf(objdes.NumDirectorshipsAdministratorAppointed);
            des.SafDESNumDirectorshipCrditrLiquidtr__c       = Decimal.ValueOf(objdes.NumDirectorshipsCreditorLiquidator);
            des.SafDESNumDirectorships__c                    = Decimal.ValueOf(objdes.NumDirectorships);
            des.SafDESNumDirectorshipsCmplsryLiquidtr__c     = Decimal.ValueOf(objdes.NumDirectorshipsCompulsoryLiquidator);
            des.SafDESNumDirectorshipsDissolved__c           = Decimal.ValueOf(objdes.NumDirectorshipsDissolved);
            des.SafDESNumDirectorshipsFailed__c              = Decimal.ValueOf(objdes.NumDirectorshipsFailed);
            des.SafDESNumDirectorshipsMemberLiqidator__c     = Decimal.ValueOf(objdes.NumDirectorshipsMemberLiqidator);
            des.SafDESNumDirectorshipsNotFailed__c           = Decimal.ValueOf(objdes.NumDirectorshipsNotFailed);
            des.SafDESNumDirectorshipsReinstated__c          = Decimal.ValueOf(objdes.NumDirectorshipsReinstated);
            des.SafDESNumDirectorshipsWindUpOrder__c         = Decimal.ValueOf(objdes.NumDirectorshipsWindUpOrder);
            des.SafDESNumDirectorshipUnknwnLiquidtr__c       = Decimal.ValueOf(objdes.NumDirectorshipsUnknownLiquidator);
            des.SafDESNumDirectorsNotFound__c                = Decimal.ValueOf(objdes.NumDirectorsNotFound);
            des.SafDESNumDirectrshpRecevrAppntd__c           = Decimal.ValueOf(objdes.NumDirectorshipsReceiverAppointed);
            des.SafDESNumDirectrshpRecevrCesstn__c           = Decimal.ValueOf(objdes.NumDirectorshipsReceiverCessation);
            des.SafDESNumDirFound__c                         = Decimal.ValueOf(objdes.NumDirectorsFound);
            des.SafDESNumDirRevocatnVolntryArngmnt__c        = Decimal.ValueOf(objdes.NumDirectorshipsRevocationVoluntaryArrangements);
            des.SafDESNumDirSuspnsnVolntryArngmnt__c         = Decimal.ValueOf(objdes.NumDirectorshipsSuspensionVoluntaryArrangements);
            des.SafDESNumDisqualifications__c                = Decimal.ValueOf(objdes.NumDisqualifications);
            des.SafDESNumDrctrshpAdmnstrtrDschrge__c         = Decimal.ValueOf(objdes.NumDirectorshipsAdministratorDischarge);
            des.SafDESNumPreviousDirectorships__c            = Decimal.ValueOf(objdes.NumPreviousDirectorships);
            
            multiObject.add(des);
         /* if(objdes.DirectorNumbers != null)
          {  
             if(objdes.DirectorNumbers.DirectorNumber != null)
            { 
                
                // for(string objnum:objdes.DirectorNumbers.DirectorNumber)
                       
                //    {
                        Saf_DirectorNumbers__c objDN                     = new Saf_DirectorNumbers__c();
                        objDN.SafDNDirectorNumber__c                     = objdes.DirectorNumbers.DirectorNumber;
                        objDN.SAF_Experian_Info__c                       = experianInfo.id;
                        multiObject.add(objDN);
                //    }
                system.debug('DirectorNumbers generated successfully');
               }
           }*/
        }
        system.debug('Director Expanded Summary generated successfully');
       }
    }
    
    public void generateScoringData(SAF_Experian_Info__c experianInfo) 
    {
        if(experian.ScoringData != null)
        {
            Saf_ScoringData__c sd                            = new Saf_ScoringData__c();
            sd.SAF_Experian__c                               = experianInfo.id;
            sd.Saf_SD_CompanyAge__c                          = experian.ScoringData.CompanyAge;
            sd.SafSDAccountingPeriod__c                      = experian.ScoringData.AccountingPeriod;
            sd.SafSDAcidTest__c                              = experian.ScoringData.AcidTest;
           
            sd.SafSDAgeMostRecentCCJ__c                      = experian.ScoringData.AgeMostRecentCCJ;
            sd.SafSDAuditorsQualifications__c                = experian.ScoringData.AuditorsQualifications;
            sd.SafSDAuditType__c                             = experian.ScoringData.AuditType;
            
            if(experian.ScoringData.LimitedCompanyDelphiCAIS != null)
           { sd.SafSDAgeMostRecent__c                         = experian.ScoringData.LimitedCompanyDelphiCAIS.AgeMostRecent;
            sd.SafSDAvgBalanceOwnAccounts__c                 = experian.ScoringData.LimitedCompanyDelphiCAIS.AvgBalanceOwnAccounts;
            sd.SafSDBalanceActiveAccounts__c                 = experian.ScoringData.LimitedCompanyDelphiCAIS.BalanceActiveAccounts;
            sd.SafSDNumActiveAccounts__c                     = experian.ScoringData.LimitedCompanyDelphiCAIS.NumActiveAccounts;
            sd.SafSDNumDefaults__c                           = experian.ScoringData.LimitedCompanyDelphiCAIS.NumDefaults;
            sd.SafSDNumOwnAccounts__c                        = experian.ScoringData.LimitedCompanyDelphiCAIS.NumOwnAccounts;
            sd.SafSDTotalBalanceOwnAccounts__c               = experian.ScoringData.LimitedCompanyDelphiCAIS.TotalBalanceOwnAccounts;
            sd.SafSDValueDefaults__c                         = experian.ScoringData.LimitedCompanyDelphiCAIS.ValueDefaults;
            sd.SafSDWorstStatusActive__c                     = experian.ScoringData.LimitedCompanyDelphiCAIS.WorstStatusActive;
            sd.SafSDWorstStatusOld__c                        = experian.ScoringData.LimitedCompanyDelphiCAIS.WorstStatusOld;
              sd.SafSDNumSettled__c                            = experian.ScoringData.LimitedCompanyDelphiCAIS.NumSettled;
            }   
            sd.SafSDBaseTrendShareholdersFunds__c            = experian.ScoringData.BaseTrendShareholdersFunds;
            sd.SafSDBorrowingRatio__c                        = experian.ScoringData.BorrowingRatio;
            sd.SafSDCapitalEmployed__c                       = experian.ScoringData.CapitalEmployed;
            sd.SafSDCapitalEmployedPercentTotalAssets__c     = experian.ScoringData.CapitalEmployedPercentTotalAssets;
            sd.SafSDCreditPeriod__c                          = experian.ScoringData.CreditPeriod;
            sd.SafSDCrntLibltsPrcntTtlAst__c                 = experian.ScoringData.CurrentLiabilitiesPercentTotalAssets;
            sd.SafSDCurrAccsAvailabe__c                      = experian.ScoringData.CurrAccsAvailabe;
            sd.SafSDCurrentratio__c                          = experian.ScoringData.Currentratio;
            sd.SafSDDebtGearing__c                           = experian.ScoringData.DebtGearing;
            sd.SafSDDividends__c                             = experian.ScoringData.Dividends;
            sd.SafSDDormancyFlag__c                          = experian.ScoringData.DormancyFlag;
            sd.SafSDEquityGearing__c                         = experian.ScoringData.EquityGearing;
            sd.SafSDFixedAssets__c                           = experian.ScoringData.FixedAssets;
            sd.SafSDGrossAssets__c                           = experian.ScoringData.GrossAssets;
            sd.SafSDHasSubsidiaries__c                       = experian.ScoringData.HasSubsidiaries;
            sd.SafSDHighestValueCCJ__c                       = experian.ScoringData.HighestValueCCJ;
            sd.SafSDIncompleteDirsFlag__c                    = experian.ScoringData.IncompleteDirsFlag;
            sd.SafSDIntangibleAssets__c                      = experian.ScoringData.IntangibleAssets;
            sd.SafSDIsSubsidiary__c                          = experian.ScoringData.IsSubsidiary;
            sd.SafSDIssuedCapital__c                         = experian.ScoringData.IssuedCapital;
            sd.SafSDLatenessAccounts__c                      = experian.ScoringData.LatenessAccounts;
            //sd.SafSDLimitedCompanyDelphiCAIS__c            = experian.ScoringData.LimitedCompanyDelphiCAIS;
            sd.SafSDLiquidityStandardRatio__c                = experian.ScoringData.LiquidityStandardRatio;
            sd.SafSDNetWorth__c                              = experian.ScoringData.NetWorth;
          
            sd.SafSDNumAppointmentsLast12__c                 = experian.ScoringData.NumAppointmentsLast12;
            sd.SafSDNumApprovalVolArrangement__c             = experian.ScoringData.NumApprovalVolArrangement;
            sd.SafSDNumApptAdministrator__c                  = experian.ScoringData.NumApptAdministrator;
            sd.SafSDNumApptCompLiquidator__c                 = experian.ScoringData.NumApptCompLiquidator;
            sd.SafSDNumApptReceiver__c                       = experian.ScoringData.NumApptReceiver;
            sd.SafSDNumApptVolLiquidator__c                  = experian.ScoringData.NumApptVolLiquidator;
            sd.SafSDNumberCCJs0To72__c                       = experian.ScoringData.NumberCCJs0To72;
            sd.SafSDNumberCCJs13To24__c                      = experian.ScoringData.NumberCCJs13To24;
            sd.SafSDNumberCCJs25To36__c                      = experian.ScoringData.NumberCCJs25To36;
            sd.SafSDNumberCCJs37To48__c                      = experian.ScoringData.NumberCCJs37To48;
            sd.SafSDNumberCCJs49To60__c                      = experian.ScoringData.NumberCCJs49To60;
            sd.SafSDNumberCCJs61To72__c                      = experian.ScoringData.NumberCCJs61To72;
            sd.SafSDNumberCCJsLast12Months__c                = experian.ScoringData.NumberCCJsLast12Months;
            sd.SafSDNumberDaysToFile__c                      = experian.ScoringData.NumberDaysToFile;
            sd.SafSDNumCompanyDissolved__c                   = experian.ScoringData.NumCompanyDissolved;
            sd.SafSDNumCompanyReinstated__c                  = experian.ScoringData.NumCompanyReinstated;
            sd.SafSDNumCompletionsVolArrangement__c          = experian.ScoringData.NumCompletionsVolArrangement;
            sd.SafSDNumCurrDirs__c                           = experian.ScoringData.NumCurrDirs;
           
            sd.SafSDNumDirsHoldingShares__c                  = experian.ScoringData.NumDirsHoldingShares;
            sd.SafSDNumDirsIncorpAgents__c                   = experian.ScoringData.NumDirsIncorpAgents;
            sd.SafSDNumDischargeAdministrator__c             = experian.ScoringData.NumDischargeAdministrator;
            sd.SafSDNumDismissedPetition__c                  = experian.ScoringData.NumDismissedPetition;
            sd.SafSDNumDisqCurrDirs__c                       = experian.ScoringData.NumDisqCurrDirs;
            sd.SafSDNumEmployees__c                          = experian.ScoringData.NumEmployees;
            sd.SafSDNumIntentionToDissolve__c                = experian.ScoringData.NumIntentionToDissolve;
            sd.SafSDNumMeetingsCreditors__c                  = experian.ScoringData.NumMeetingsCreditors;
            sd.SafSDNumMemArtsChangesLast12Months__c         = string.IsBlank(experian.ScoringData.NumMemArtsChangesLast12Months) ? null : Decimal.ValueOf(experian.ScoringData.NumMemArtsChangesLast12Months);
          
            sd.SafSDNumPetitionCompWindUp__c                 = experian.ScoringData.NumPetitionCompWindUp;
            sd.SafSDNumReceiverCeasing__c                    = experian.ScoringData.NumReceiverCeasing;
            sd.SafSDNumRegOfficeChangesLast12Months__c       = string.IsBlank(experian.ScoringData.NumRegOfficeChangesLast12Months) ? null : Decimal.ValueOf(experian.ScoringData.NumRegOfficeChangesLast12Months);
            sd.SafSDNumResolutionWindUp__c                   = experian.ScoringData.NumResolutionWindUp;
            sd.SafSDNumRevocationVoluntaryArrangement__c     = experian.ScoringData.NumRevocationVoluntaryArrangement;
            sd.SafSDNumSatMortgages__c                       = experian.ScoringData.NumSatMortgages;
          
            sd.SafSDNumSuspensionVolArrangement__c           = experian.ScoringData.NumSuspensionVolArrangement;
            sd.SafSDNumUnsatMortgages__c                     = experian.ScoringData.NumUnsatMortgages;
            sd.SafSDNumUnsatPartSatMortgages__c              = experian.ScoringData.NumUnsatPartSatMortgages;
            sd.SafSDNumWindUpOrders__c                       = experian.ScoringData.NumWindUpOrders;
            sd.SafSDNumYearsAccosAvailable__c                = experian.ScoringData.NumYearsAccosAvailable;
            sd.SafSDNumYrsPreTaxPrftLesThn0Lst4Yr__c         = experian.ScoringData.NumYearsPreTaxProfitLessThan0Last4Years;
            sd.SafSDOldestCurrDirAge__c                      = experian.ScoringData.OldestCurrDirAge;
            sd.SafSDOutOfDateFlag__c                         = experian.ScoringData.OutOfDateFlag;
            sd.SafSDPercentageDirsResidentUK__c              = experian.ScoringData.PercentageDirsResidentUK;
            sd.SafSDPercentChangeCapitalEmployed__c          = experian.ScoringData.PercentChangeCapitalEmployed;
            sd.SafSDPercentChangeCurrentRatio__c             = experian.ScoringData.PercentChangeCurrentRatio;
            sd.SafSDPercentChangePreTaxProfitLoss__c         = experian.ScoringData.PercentChangePreTaxProfitLoss;
            sd.SafSDPercentChangeShareholdersFunds__c        = experian.ScoringData.PercentChangeShareholdersFunds;
            sd.SafSDPercentChangeTotalAssets__c              = experian.ScoringData.PercentChangeTotalAssets;
            sd.SafSDPreTaxMarginQuartile__c                  = experian.ScoringData.PreTaxMarginQuartile;
            sd.SafSDPreTaxProfitLoss__c                      = experian.ScoringData.PreTaxProfitLoss;
            sd.SafSDPreTaxProfitMargin__c                    = experian.ScoringData.PreTaxProfitMargin;
            sd.SafSDPrevAccountsDormancyFlag__c              = experian.ScoringData.PrevAccountsDormancyFlag;
            sd.SafSDPrevAccsAvailabile__c                    = experian.ScoringData.PrevAccsAvailabile;
            sd.SafSDProportionCurrDirsToPrevDirLast12__c     = experian.ScoringData.ProportionCurrDirsToPrevDirLast12;
            sd.SafSDRegion__c                                = experian.ScoringData.Region;
            sd.SafSDRegOfficeCIFASIndicator__c               = experian.ScoringData.RegOfficeCIFASIndicator;
            sd.SafSDRetainedEarnings__c                      = experian.ScoringData.RetainedEarnings;
            sd.SafSDRetainedProfit__c                        = experian.ScoringData.RetainedProfit;
            sd.SafSDReturnOnAssets__c                        = experian.ScoringData.ReturnOnAssets;
            sd.SafSDReturnOnAssetsQuartile__c                = experian.ScoringData.ReturnOnAssetsQuartile;
            sd.SafSDReturnOnCapital__c                       = experian.ScoringData.ReturnOnCapital;
            sd.SafSDRevaluationReserves__c                   = experian.ScoringData.RevaluationReserves;
            sd.SafSDShareholdersFunds__c                     = experian.ScoringData.ShareholdersFunds;
            sd.SafSDShortLoans__c                            = experian.ScoringData.ShortLoans;
            sd.SafSDStckWrkInPrgrsPrcntCrntAst__c            = experian.ScoringData.StocksWorkInProgressPercentCurrentAssets;
            sd.SafSDTimeSinceLastAccsSubmitted__c            = experian.ScoringData.TimeSinceLastAccsSubmitted;
            sd.SafSDTimeSinceLastApptAdministrator__c        = experian.ScoringData.TimeSinceLastApptAdministrator;
            sd.SafSDTimeSinceLastApptCompLiquidator__c       = experian.ScoringData.TimeSinceLastApptCompLiquidator;
            sd.SafSDTimeSinceLastApptReceiver__c             = experian.ScoringData.TimeSinceLastApptReceiver;
            sd.SafSDTimeSinceLastApptVolLiquidator__c        = experian.ScoringData.TimeSinceLastApptVolLiquidator;
            sd.SafSDTimeSinceLastCompanyDissolved__c         = experian.ScoringData.TimeSinceLastCompanyDissolved;
            sd.SafSDTimeSinceLastCompanyReinstated__c        = experian.ScoringData.TimeSinceLastCompanyReinstated;
            sd.SafSDTimeSinceLastDerogatoryItem__c           = experian.ScoringData.TimeSinceLastDerogatoryItem;
            sd.SafSDTimeSinceLastDirAppt__c                  = experian.ScoringData.TimeSinceLastDirAppt;
            sd.SafSDTimeSinceLastDismissedPetition__c        = experian.ScoringData.TimeSinceLastDismissedPetition;
            sd.SafSDTimeSinceLastIntentionToDissolve__c      = experian.ScoringData.TimeSinceLastIntentionToDissolve;
            sd.SafSDTimeSinceLastMeetingCreditors__c         = experian.ScoringData.TimeSinceLastMeetingCreditors;
            sd.SafSDTimeSinceLastPetitionCompWindUp__c       = experian.ScoringData.TimeSinceLastPetitionCompWindUp;
            sd.SafSDTimeSinceLastReceiverCeasing__c          = experian.ScoringData.TimeSinceLastReceiverCeasing;
            sd.SafSDTimeSinceLastRegOfficeChange__c          = experian.ScoringData.TimeSinceLastRegOfficeChange;
            sd.SafSDTimeSinceLastResolutionWindUp__c         = experian.ScoringData.TimeSinceLastResolutionWindUp;
            sd.SafSDTimeSinceLastRetsSubmitted__c            = experian.ScoringData.TimeSinceLastRetsSubmitted;
            sd.SafSDTimeSinceLastWindUpHearing__c            = experian.ScoringData.TimeSinceLastWindUpHearing;
            sd.SafSDTimeSinceLastWindUpOrder__c              = experian.ScoringData.TimeSinceLastWindUpOrder;
            sd.SafSDTimeSinceLastApprovalVolArrangement__c   = experian.ScoringData.TimeSinceLastApprovalVolArrangement;
            sd.SafSDTimeSinceLastDischargeAdministrator__c   = experian.ScoringData.TimeSinceLastDischargeAdministrator;
            sd.SafSDTmeSnceLstCmpltnVolArngmnt__c            = experian.ScoringData.TimeSinceLastCompletionVolArrangement;
            sd.SafSDTmeSnceLstRevctnVolArngmnt__c            = experian.ScoringData.TimeSinceLastRevocationVolArrangement;
            sd.SafSDTmeSnceLstSuspnsnVolArngmnt__c           = experian.ScoringData.TimeSinceLastSuspensionVolArrangement;
            sd.SafSDTotalAssets__c                           = experian.ScoringData.TotalAssets;
           
            sd.SafSDTotalCurrentAssets__c                    = experian.ScoringData.TotalCurrentAssets;
            sd.SafSDTotalCurrentLiabilities__c               = experian.ScoringData.TotalCurrentLiabilities;
            sd.SafSDTotalFixedAssetsPercentTotalAssets__c    = experian.ScoringData.TotalFixedAssetsPercentTotalAssets;
            sd.SafSDTotalLongTermLiabilities__c              = experian.ScoringData.TotalLongTermLiabilities;
            sd.SafSDTotalTurnover__c                         = experian.ScoringData.TotalTurnover;
            sd.SafSDTotAssetsEmp__c                          = experian.ScoringData.TotAssetsEmp;
            sd.SafSDTotValCCJsPropShareFunds__c              = experian.ScoringData.TotValCCJsPropShareFunds;
            sd.SafSDTurnoverPerEmp__c                        = experian.ScoringData.TurnoverPerEmp;
            sd.SafSDValCCJsLast24MonthsPropShareFunds__c     = experian.ScoringData.ValCCJsLast24MonthsPropShareFunds;
            sd.SafSDValueCCJs0To72__c                        = experian.ScoringData.ValueCCJs0To72;
            sd.SafSDValueCCJs13To24__c                       = experian.ScoringData.ValueCCJs13To24;
            sd.SafSDValueCCJs25To36__c                       = experian.ScoringData.ValueCCJs25To36;
            sd.SafSDValueCCJs37To48__c                       = experian.ScoringData.ValueCCJs37To48;
            sd.SafSDValueCCJs49To60__c                       = experian.ScoringData.ValueCCJs49To60;
            sd.SafSDValueCCJs61To72__c                       = experian.ScoringData.ValueCCJs61To72;
            sd.SafSDValueCCJsLast12Months__c                 = experian.ScoringData.ValueCCJsLast12Months;
           
            sd.SafSDValueMostRecentCCJ__c                    = experian.ScoringData.ValueMostRecentCCJ;
            sd.SafSDWorkingCapital__c                        = experian.ScoringData.WorkingCapital;
            sd.SafSDReportUpdateFlag__c                      = experian.ScoringData.ReportUpdateFlag;
           
            sd.SafSDWrkngCptlPrcntCurntPlsFxdAst__c          = experian.ScoringData.WorkingCapitalPercentCurrentPlusFixedAssets;
            multiObject.add(sd);
            
            system.debug('Scoring data generated successfully');
       
            
            if(experian.ScoringData.LimitedCompanyDelphiRisk != null)
            {
                for(Saf_Experain.cls_LimitedCompanyDelphiRisk objDRisk:experian.ScoringData.LimitedCompanyDelphiRisk)
                {
                    
                    Saf_LimitedCompanyDelphiRisk__c objDR      = new Saf_LimitedCompanyDelphiRisk__c();
                    objDR.SafDRCommercialDelphiScore__c        = objDRisk.CommercialDelphiScore;
                    objDR.SafDRCreditRating__c                 = objDRisk.CreditRating;
                    objDR.SafDRCreditLimit__c                  = objDRisk.CreditLimit;
                    objDR.SafDRCreditCode__c                   = objDRisk.CreditCode;
                    objDR.SafDRCommercialDelphiOverRideFlag__c = objDRisk.CommercialDelphiOverRideFlag;
                    objDR.SafDRCreditRatingOverRideflag__c     = objDRisk.CreditRatingOverRideflag;
                    objDR.SafDRCredLimitOverRideFlag__c        = objDRisk.CredLimitOverRideFlag;
                    objDR.SafDRCreditCodeOverRideFlag__c       = objDRisk.CreditCodeOverRideFlag;
                    objDR.SAF_Experian_Info__c                 = experianInfo.id;
                       
                    multiObject.add(objDR);
                }
                
                system.debug('LimitedCompanyDelphiRisk successfully');
            }
          
            if(experian.ScoringData.LimitedCompanyDelphiPayment != null)
            {
                for(Saf_Experain.cls_LimitedCompanyDelphiPayment objDPay:experian.ScoringData.LimitedCompanyDelphiPayment)
                {
                    Saf_LimitedCompanyDelphiPayment__c objDP  = new Saf_LimitedCompanyDelphiPayment__c();
                    objDP.SafDPAverageCurrentDaysBeyondTerm__c   =objDPay.AverageCurrentDaysBeyondTerm; //-9999999
                    objDP.SafDPAvgNmbrExprnceLst3mnth__c           =objDPay.AverageNumberExperiencesLast3month;   //-9999999
                    objDP.SafDPNumberOfAccntCollctnLst12Mnth__c    =  objDPay.NumberOfAccountsCollectionLast12Months;   //-99999
                    objDP.SafDPNumberUnpaidAccountsLastMonth__c    = objDPay.NumberUnpaidAccountsLastMonth;    //-99999
                    objDP.SafDPPercentChangeLast3Months__c         =  objDPay.PercentChangeLast3Months; 
                    objDP.SAF_Experian_Info__c  = experianInfo.id; 
                       
                    multiObject.add(objDP);
                }
                
                system.debug('LimitedCompanyDelphiPayment successfully');
            }
        }
    }
}