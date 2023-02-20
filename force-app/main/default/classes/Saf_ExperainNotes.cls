Public  class Saf_ExperainNotes{
   
     
    public String RegNumber;    //SC123456
    public String CommercialName;   //CROAN SEAFOODS LIMITED
    public cls_Identification Identification;
    public cls_CorporateStructure CorporateStructure;
    public cls_ManagementInfo ManagementInfo;
    public cls_LimitedCompanyCIFAS LimitedCompanyCIFAS;
    public cls_LimitedCompanyDelphiDirector[] LimitedCompanyDelphiDirector;
    public cls_Shareholders Shareholders;
    public cls_CommercialDelphi CommercialDelphi;
    public cls_PaymentPerformance PaymentPerformance;
    public cls_Financials Financials;
    public cls_CCJs CCJs;
    public cls_Mortgages Mortgages;
    public cls_LegalNotices LegalNotices;
    public cls_CommercialDelphiHistory CommercialDelphiHistory;
    public cls_ScoringData ScoringData;
    public cls_Alerts[] Alerts;
    public cls_NoticeOfCorrection NoticeOfCorrection;
    public cls_DirectorExpandedSummary[] DirectorExpandedSummary;
    public cls_LtdCompanyCAIS LtdCompanyCAIS;
      public Integer ResponeCode;
    public Saf_Experain objExp;
    //public string ResponeMessage; 
  Public class cls_Error {
        public String Code;    
        public String Message;    
        public String MoreInfo;    
        public String InternalError; 
    }
    
    Public class cls_Identification {
        public String LegalStatus;  //2
        public String IncorporationDate;    //1990-03-02
        public String DissolutionDate;  //2016-08-24
        public cls_RegisteredOffice RegisteredOffice;
        public String Currencyiso; //GBP
        public String IssuedCapital;    //3830934
        public String AsRegisteredOffice;   //Y
        public String TradingTelephoneNum;
        public cls_TradingLocation TradingLocation;
        public String PrincipalActivities;  //FISH MERCHANTS.
        public List<cls_SICInformation1980> SICInformation1980;
        public List<cls_SICInformation1992> SICInformation1992;
        //added by phalguni 13 march 2019
        public cls_PreviousNames PreviousNames;
        public cls_PreviousAddresses PreviousAddresses;
        public cls_ThomsonData ThomsonData;
               
        public cls_FilingDetails FilingDetails;
        public cls_Auditor Auditor;
        public cls_Bank Bank;
        public cls_CROChanges CROChanges;
        public cls_PrevSearches PrevSearches;
        public cls_CCLs CCLs;
    }
    Public class cls_RegisteredOffice {
        public String LocationLine1;    //CLARENDON HOUSE
        public String LocationLine2;    //116 GEORGE STREET
        public String LocationLine3;    //EDINBURGH
        public String LocationLine4;    //EDINBURGH
        public String Postcode; //EH2 4LH
    }
    Public class cls_TradingLocation {
        public String LocationLine1;    //UNIT 1A 3 MICHAELSON SQUARE
        public String LocationLine2;    //LIVINGSTON
        public String LocationLine3;    //LIVINGSTON
         public String LocationLine4;
        public String Postcode; //EH54 7DP
    }
    Public class cls_SICInformation1980 {
        public String Code; //6170
        public String Description; //5138
    }
    Public class cls_SICInformation1992 {
        public String Code; //5138
        public String Description; //5138
    }
    Public class cls_PreviousAddresses {
        public String NumPrevAddresses; //3
        public List<cls_PreviousCRO> PreviousCRO;
    }
    Public class cls_PreviousCRO {
        public String DateChanged;  //2014-02-26
        public cls_RegisteredOffice RegisteredOffice;
    }
   Public class cls_ThomsonData {
        public String ThomsonCustNumber;    //3335279
        public String LastUpdatedDate;  //2016-09-16
        public String ThomsonPremiseCode;   //05
        public String URL;  //www.forkliftsolutions.info
    }
    // Added by Deepak 19-FEB-2019 - Starts
    Public class cls_PreviousNames {
        public String NumPrevNames; //1
        public List<cls_PreviousName> PreviousName;
    }
    Public class cls_PreviousName {
        public String DateChanged;  //2014-02-26
        public String Name;
    }
    // Added by Deepak 19-FEB-2019 - Ends
    
    Public class cls_FilingDetails {
        public String DatabaseAccountsOutOfDate;    //N
        public String FiledAccountsOutOfDate;   //N
        public String LatestAccounts;   //2012-03-31
        public String LatestReturns;    //2013-02-12
        public String LatestReturnsDatabase;    //2013-02-12
        public String LatestAccountsDatabase;   //2012-03-31
        public String NumAccountsOnFile;    //13
        public String LatestAccountType;    //9
        public cls_AccountsRefDate AccountsRefDate;
        public String NumberDaysToFileAccounts; //268
    }
    Public class cls_AccountsRefDate {
        public String MM;   //09
        public String DD;   //30
    }
    Public class cls_Auditor {
        public String Currencyiso; //GBP
        public String AuditType;    //D
        public String AuditQual;    //0
        public String Auditors; //WHITELAW WELLS
    }
    Public class cls_Bank {
        public String BankName; //THE ROYAL BANK OF SCOTLAND PLC
        public cls_BankLocation BankLocation;
    }
    Public class cls_BankLocation {
        public String LocationLine1;    //31 NORTH BRIDGE
        public String LocationLine2;    //EDINBURGH
        public String LocationLine3;    //MIDLOTHIAN
        public String Postcode; //EH1 1SF
    }
    Public class cls_CROChanges {
        public String NumCROChanges;    //8
        public List<cls_CROChangeDetail> CROChangeDetail;
    }
    Public class cls_CROChangeDetail {
        public String DocumentType; //R
        public String DocumentDate; //2016-05-21
    }
    Public class cls_PrevSearches {
        public String NumPrevSearch;    //13
        public String NumPrevSearch3Mth;    //5
        public String NumPrevSearch6Mth;    //9
        public String NumPrevSearch12Mth;   //13
        public List<cls_PreviousSearchDetail> PreviousSearchDetail;
    }
    Public class cls_PreviousSearchDetail {
        public String SearchDate;   //2019-01-10
        public String EnquiryType;  //C
        public String OwnEnquiryFlag;   //N
        public cls_SICInformation SICInformation;
    }
    Public class cls_SICInformation {
        public String Type; //MISC
        public String Description;  //MISCELLANEOUS
        public String Code; //MISC
    }
    Public class cls_CCLs {
        public String TotalNumberCCL;   //0
    }
    Public class cls_CorporateStructure {
        public cls_CompanyOwnership CompanyOwnership;
        public cls_Subsidiaries Subsidiaries;
    }
    Public class cls_CompanyOwnership {
        public String BulkShareHolders; //N
        public String BulkTelephone;    //0115 9016000 *2
        public String NumPrincShareHldrs;   //4
        public String ParRegNumber;
        public String UltParRegNumber;
        public cls_ParentDetail ParentDetail;
        public cls_UltParentDetail UltParentDetail;
        public List<cls_CorporateShareholder> CorporateShareholder;
    }
    Public class cls_ParentDetail {
    public String CommercialName;
    public cls_BusinessLocation BusinessLocation;
    }
    Public class cls_UltParentDetail {
    public String CommercialName;
    public cls_BusinessLocation1 BusinessLocation;
    }
    Public class cls_BusinessLocation{
        public String LocationLine1;
        public String LocationLine2;
        public String LocationLine3;
        public String LocationLine4;
        public String Postcode;
    }
    Public class cls_BusinessLocation1{
        public String LocationLine1;
        public String LocationLine2;
        public String LocationLine3;
        public String LocationLine4;
        public String Postcode;
    }
    Public class cls_CorporateShareholder {
        public String Name; //PATRICK M CROAN
        public String Holding;  //961,938 ORD £1
        public String Country;
    }
    Public class cls_Subsidiaries {
        public String TreePosition; //1
        public String TotalElements;    //1
        public String TotalSubs;    //0
        public String TotalNumImmediateSubs;    //0
        public String TotalNumLiveImmediateSubs;    //0
        public String TotalNumDormantImmediateSubs; //0
        public String TotalNumDissolvedLiquidatedImmediateSubs; //0
        public String TotalNumNestedSubs;   //0
        public String TotalNumSubs; //0
        public String TotalNumUKSubs;   //0
        public String TotalNumOverseasSubs; //0
        public List<cls_UKSubsidiaries> UKSubsidiaries; //0
    }
    Public class cls_UKSubsidiaries {
       public String SubRegNumber;//": "03457731",
       public String SubStatus;//": "D",
       public String SubLegalStatus;//": "2",
       public String SubName;//": "BOSTOCK'S COACHES LIMITED"
      }
    Public class cls_ManagementInfo {
        public String LatestReturns;    //2013-02-12
        public String NumDirs;  //4
        public String NumSecs;  //2
        public String NumCurrDirs;  //3
        public String NumPrevDirs;  //1
        public String DirectorAvgAge;   //61
        public String DirectorAvgLength;    //277
        public String NumCurrDirectorLast12;    //0
        public String NumAppointmentsLast12;    //0
        public String NumResignationsLast12;    //0
        public String NumDisqualifications; //0
        public cls_Directors Directors;
        //public cls_Secretaries Secretaries;
    }
    Public class cls_Directors {
        public List<cls_CurrentDirector> CurrentDirector;
        public List<cls_PreviousDirector> PreviousDirector;
        public List<cls_Secretaries> secretaries;
    }
    Public class cls_CurrentDirector {
        public String ForeignAddressFlag;   //N
        public String DirectorCompanyFlag;  //N
        public String DirectorNumber;   //D01366864
        public String AppointmentDate;  //1992-02-18
        public String AppointmentIndicator; //P
        public String LatestReturns;    //2013-02-12
        public String NumberConvictions;    //0
        public cls_DirectorDetails DirectorDetails;
        public String DirectorshipLength;

    }
    Public class cls_DirectorDetails {
        public cls_Name Name;
        public String DateOfBirth;  //1922-07-02
        public String DirectorAge;  //96
        public cls_CommercialDetail CommercialDetail;
        public cls_Location Location;
        public String Occupation;   //COMPANY DIRECTOR
        public String Nationality;  //BRITISH
        public String Position;
        public String ShareInformation; //961,938 ORD £1
    }
    Public class cls_Name {
        public String FirstName;  
        public String Prefix;  //ELAINE
        public String Forename;  
        public String MiddleNames;  //TERESA
        public String SurName;  //CROAN
        
    }
    Public class cls_CommercialDetail {
        public String KGENName; //CRN  E
        public String Name;
        public String RegNumber;
    }
    Public class cls_Location {
        public String HouseNumber;  //55/56
        public String HouseName;
        public String Street;   //QUEEN STREET
        public String PostTown; //EDINBURGH
        public String Postcode; //EH2 3PA
        public String County;
        public String RMC;  //3386000        
        public String District;
    }
    Public class cls_PreviousDirector {
        public String ForeignAddressFlag;   //N
        public String DirectorCompanyFlag;  //N
        public String DirectorNumber;   //D01365645
        public String AppointmentDate;  //1992-02-18
        public String AppointmentIndicator; //P
        public String DirectorshipLength;
        public String ResignationDate;  //2007-03-02
        public String ResignationIndicator; //E
        public String LatestReturns;    //2013-02-12
        public String NumberConvictions;    //0
        public cls_DirectorDetails DirectorDetails;
    }
    Public class cls_Secretaries {
        public List<cls_CurrentSecretary> CurrentSecretary;
        public List<cls_PreviousSecretary> PreviousSecretary;
    }
    Public class cls_CurrentSecretary {
        public String ForeignAddressFlag;   //N
        public String SecretaryCompanyFlag; //Y
        public String AppointmentDate;  //2004-11-01
        public String AppointmentIndicator; //E
        public cls_SecretaryDetails SecretaryDetails;
    }
    Public class cls_SecretaryDetails {
        public cls_Name Name;
        public cls_CommercialDetail CommercialDetail;
        public cls_Location Location;
    }
    Public class cls_PreviousSecretary {
        public String ForeignAddressFlag;   //N
        public String SecretaryCompanyFlag; //Y
        public String AppointmentDate;  //1992-02-18
        public String AppointmentIndicator; //P
        public String ResignationDate;  //2004-11-01
        public String ResignationIndicator; //E
        public cls_SecretaryDetails SecretaryDetails;
    }
    Public class cls_LimitedCompanyCIFAS {
        public cls_LimitedCompanyCIFASSummary LimitedCompanyCIFASSummary;
        public List<cls_LimitedCompanyCIFASDetails> LimitedCompanyCIFASDetails;
    }
    Public class cls_LimitedCompanyCIFASDetails {
        public String Reference;
        public String FraudCategory;
        public String SupplierName;

        public String OtherAddressFlag;
        public String Name;
        public String Address1;
        public String Address2;
        public String Address3;
        public String Postcode;
        public cls_Date Date1;

     }
     Public class cls_Date {
        public string DateSuppliedYyyy;
        public string DateSuppliedMm;
        public string DateSuppliedDd;
        public string ExpiryDateYyyy;
        public string ExpirydateMm;
        public string ExpiryDateDd;
    }
    Public class cls_LimitedCompanyCIFASSummary {
        public String NumCIFASRecords;  //0
    }
    Public class cls_LimitedCompanyDelphiDirector {
        public String MaxOtherDirectorships;    //0004
        public String NumCreditorsWindDown; //0
        public String NumConvictions;   //0
        public String NumCCJLast12month;    //0
        public String ValueCCJLast12month;  //000000
        public String PercentageFailures;   //000000
        public String NumFailures;  //0
        public String DirectorhsipsCreditorWindDown;    //000000
    }
    Public  class cls_Shareholders {
        public List<cls_HeaderInfo> HeaderInfo;
        public List<cls_ShareCapital> ShareCapital;
        public List<cls_Shareholdings> Shareholdings;
        public List<cls_Shareholder> Shareholder;
    }
    Public  class cls_HeaderInfo {
        public String RecordType;   //H
        public String IssuingCompany;   //SC123456
        public String CurrentPreviousFlag;  //C
        public String EffectiveDate;    //2013-02-12
        public String IssuedCapital;    //1
        public String LegalStatus;  //0
        public String DocumentType; //R
        public String LatestCurrent;  
        public String LatestUpdate;  //2013-02-21
        public String DateLoaded;   //2013-02-21
    }
    Public class cls_ShareCapital {
        public String RecordType;   //I
        public String IssuingCompany;   //SC123456
        public String CurrentPreviousFlag;  //C
        public String EffectiveDate;    //2013-02-12
        public String ShareClassNo; //000001
        public String Currencyiso; //GBP
        public String ShareClassCode;   //1
        public String ShareClassDesc;   //ORD
        public String VotingRights; //1
        public String TotalNominalCapital;  //3830934
        public String NumShares;    //3830934
        public String NominalValue; //1.00
        public String Percentage;   //100.00
        public String LatestUpdate;
    }
    Public class cls_Shareholdings {
        public String RecordType;   //S
        public String IssuingCompany;   //SC123456
        public String CurrentPreviousFlag;  //C
        public String EffectiveDate;    //2013-02-12
        public String ShareClassNo; //000001
        public String ShareholdingNo;   //000001
        public String NumShares;    //945221
        public String TotalNominalCapital;  //945221
        public String Percentage;   //24.67
        public String PercentageTotalCapital;   //24.67
        public String Approximation;    //0
    }
    Public class cls_Shareholder {
        public String RecordType;   //U
        public String IssuingCompany;   //SC123456
        public String CurrentPreviousFlag;  //C
        public String EffectiveDate;    //2013-02-12
        public String ShareClassNo; //000001
        public String ShareholdingNo;   //000001
        public String ShareholderNo;    //000001
        public cls_ShareholderDetails ShareholderDetails;
    }
    Public class cls_ShareholderDetails {
        public String ShareholderType;  //I
        public cls_Name Name;
        public cls_CommercialDetail CommercialDetail;
    }
    Public  class cls_CommercialDelphi {
        public String CommDelphiScore;  //0
        public String CommDelphiBand;   //7
        public String StabilityOdds;   //7
        public String OverrideIndicator;    //N
        public String CommDelphiBandText;   //Dissolved
        public String CreditRating; //0
        public String CreditRatingOverrideIndicator;    //N
        public String CreditLimit;  //0
        public String CreditLimitOverrideIndicator; //N
        public String ParentIndicator;  //N
        public String ConclusionText; 
        public String CreditTextLine1;  //A Liquidator has been appointed.
        public String CreditTextOverrideIndicator;  //N
    }
    Public class cls_Financials {
        public List<cls_Accounts> Accounts;
        public List<cls_Cashflow> Cashflow;
        public List<cls_Ratios> Ratios;
        public cls_PercentageChange PercentageChange;
        public cls_Quartiles Quartiles;
    }
    Public class cls_Accounts {
        public String DateOfAccounts;   //2012-03-31
        public String AccountingPeriod; //52
        public String Currencyiso; //GBP
        public String CurrencyisoMultiplier;   //N
        public String CompanyClass; //S
        public String ConsolidatedAccounts; //N
        public String DormancyFlag; //N
        public String LatestAccountsType;   //G
        public String RestatedAccounts; //N
        public cls_BalanceSheet BalanceSheet;
        public cls_ProfitLoss ProfitLoss;
        public cls_DiscontinuedOperations DiscontinuedOperations;
        public cls_DisclosureItems DisclosureItems;
        public String ContingentLiability;  //N
        public String PostBalanceSheetEvents;   //N
        public String CharitableGivingIndicator;    //N
    }
    Public class cls_BalanceSheet {
        public cls_TangibleAssetsDetails TangibleAssetsDetails;
        public String IntangibleAssets; //0
        public cls_OtherNonCurrentAssetsDetails OtherNonCurrentAssetsDetails;
        public String TotalFixedNonCurrentAssets;   //157500
        public cls_InventoriesDetails InventoriesDetails;
        public cls_DebtorsDetails DebtorsDetails;
        public cls_TotalCashDetails TotalCashDetails;
        public cls_OtherCurrentAssetsDetails OtherCurrentAssetsDetails;
        public String TotalCurrentAssets;   //1269007
        public cls_CreditorsDetails CreditorsDetails;
        public cls_FinancialLiabilitiesDetails FinancialLiabilitiesDetails;
        public cls_OtherCurrentLiabilitiesDetails OtherCurrentLiabilitiesDetails;
        public String TotalCurrentLiabilities;  //78012
        public String WorkingCapital;   //1190995
        public String CapitalEmployed;  //1348495
        public cls_LongTermFinancialLiabilitiesDetails LongTermFinancialLiabilitiesDetails;
        public cls_OtherNonCurrentLiabilitiesDetails OtherNonCurrentLiabilitiesDetails;
        public String TotalNonCurrentLiabilities;   //0
        public cls_ProvisionsDetails ProvisionsDetails;
        public String MinorityInterestsUKGAAP;  //0
        public String NetAssets;    //1348495
        public cls_IssuedCapitalDetails IssuedCapitalDetails;
        public String SharePremium; //0
        public String RetainedEarnings; //-2482439
        public String RevaluationReserve;   //0
        public String Other;    //0
        public String TotalShareholdersFunds;   //1348495
        public String NetWorth; //1348495
    }
    Public class cls_TangibleAssetsDetails {
        public String TangibleAssets;   //157500
        public String LandBuildings;
        public String  Freehold;
        public String  Leasehold;
        public String  FixturesFittings;
       public String   PlantVehicles;
       public String   Plant;
       public String   Vehicles;
       public String   OtherTangibleAssets;
    }
    Public class cls_OtherNonCurrentAssetsDetails {
        public String OtherNonCurrentAssets;    //0
    }
    Public class cls_InventoriesDetails {
        public String Inventories;  //16466
        public String  RawMaterialStock;
        public String   WorkInProgress;
        public String  FinishedGoods;
    }
    Public class cls_DebtorsDetails {
        public String Debtors;  //161049
        public String AccountsReceivableTradeDebtors;//": "251858",
        public String OtherDebtors;//": "1000"
    }
    Public class cls_TotalCashDetails {
        public String TotalCash;    //1091492
    }
    Public class cls_OtherCurrentAssetsDetails {
        public String OtherCurrentAssets;   //0
    }
    Public class cls_CreditorsDetails {
    
        public String AccountsPayableTradeCreditors; //": "6929",
        public String SocialSecurityVAT; //": "49341"
        public String TaxationPayable; //": "973"
    }
    Public class cls_FinancialLiabilitiesDetails {
         public String BankOverdraft;   //0
    }
    Public class cls_OtherCurrentLiabilitiesDetails {
        public String OtherCurrentLiabilities;  //78012
    }
    Public class cls_LongTermFinancialLiabilitiesDetails {
        public String FinanceLeasesHirePurchase;    //0
        public String FinanceLease; //0
        public String HirePurchase; //0
        public String OtherLongTermLoans;   //0
    }
    Public class cls_OtherNonCurrentLiabilitiesDetails {
        public String OtherNonCurrentLiabilities;   //0
        public String GroupLoans;   //0
        public String DirectorLoans;    //0
        public String Accruals; //0
    }
    Public class cls_ProvisionsDetails {
        public String Provisions;   //0
        public String DeferredTaxation; //0
        public String Pension;  //0
        public String OtherProvision;   //0
    }
    Public class cls_IssuedCapitalDetails {
        public String IssuedCapital;    //3830934
        public String OrdinaryShares;   //3830934
        public String PreferenceShares; //0
        public String Other;    //0
    }
   public class cls_ProfitLoss {
        public cls_TurnoverSalesDetails TurnoverSalesDetails;
        public String CostOfSales;  //8566580
        public String ExceptionalItemsPreGP;    //0
        public String OtherDirectItems; //0
        public String GrossProfit;  //3150686
        public String OperatingExpenses;    //2186855
        public String OperatingIncome;  //0
        public String ExceptionalItemsPreOP;    //0
        public String OperatingProfit;  //963831
        public String OtherIncome;  //0
        public String InterestReceivable;   //0
        public cls_InterestPayableDetails InterestPayableDetails;
        public String ExceptionalItemsPreEBT;   //0
        public String PreTaxProfitLoss; //348924
        public String Taxation; //-3651
        public String ExtraordinaryItems;   //0
        public String MinorityInterestsUKGAAP;  //0
        public String Dividends;    //91278
        public String NetProfitLoss;    //261297
    }
  public class cls_TurnoverSalesDetails {
        public String TurnoverSales;    //11717266
        public String HomeNation;   //11717266
        public String Export_saf;   //0
    }
   public class cls_InterestPayableDetails {
        public String InterestPayable;  //614907
        public String ToBank;   //27027
        public String Other;    //587880
    }
    Public class cls_DiscontinuedOperations {
    }
    Public class cls_DisclosureItems {
        public cls_EmployeeRemunerationDetails EmployeeRemunerationDetails;
        public cls_DirectorRemunerationDetails DirectorRemunerationDetails;
        public String DepreciationCharges;  //3245
        public String NumberEmployees;
    }
    Public class cls_EmployeeRemunerationDetails {
    }
    Public class cls_DirectorRemunerationDetails {
    }
    Public class cls_Cashflow {
        public String DateOfAccounts;   //2012-03-31
        public String AccountingPeriod; //52
        public String Currencyiso; //GBP
        public String CurrencyMultiplier;   //N
        public String CompanyClass; //S
        public String ConsAccounts; //N
        public String DormancyIndicator;    //N
        public String LatestAccountsType;   //G
        public String RestatedAccounts; //N
    }
    Public class cls_Ratios {
       Public string DateOfAccounts;
        Public string Currencyiso;
        Public string CompanyClass;
        Public string ConsAccounts;
        Public string CurrentRatio;
        Public string AcidTest;
        Public string TradeCredrsDebtrs;
        Public string BorrowingRatio;
        Public string EquityGearing;
        Public string DebtGearing;
        Public string CapEmployedPerEmp;
        Public string TangAssetsPerEmp;
        Public string TotAssetsPerEmp;
        Public string NumEmployees;

    }
    Public class cls_PercentageChange {
        public String DateOfAccounts;   //2012-03-31
        public String AccountingPeriod; //52
        public String Currencyiso; //GBP
        public String CompanyClass; //S
        public String ConsAccounts; //N
        public String PercentChangeGrossAsset;  //1.77
        public String PercentChangeNetWorth;    //3.79
        public String PercentChangeFixedAssets; //-80.41
        public String PercentChangeCurrentAssets;   //112.35
        public String PercentChangeCurrentLiabilities;  //-23.86
        public String PercentChangeWorkingCapital;  //140.54
        public String PercentChangeCapitalEmployed; //3.79
        public String PercentChangeNetAssets;   //3.79
        public String PercentChangeIssuedCapital;   //0
        public String PercentChangeRetainedEarnings;    //1.95
        public String PercentChangeShareholdersFunds;   //3.79
        public String PercentChangeCurrentRatio;    //178.88
        public String PercentChangeEquityGearing;   //1.99
        
        //Public string PercentChangeCurrentRatio;
        Public string PercentChangeBorrowingRatio;
        Public string PercentChangeDebtGearing;

    }
    Public class cls_Quartiles {
       public cls_FullQuartiles FullQuartiles;
       public cls_FullQuartiles MedianQuartiles;
    }
     Public class cls_FullQuartiles {
       public String YearEnd;
       public String DateOfAccounts;
        public String NumCompanies;
        public String CurrentRatioLower;
        public String CurrentRatioMedian;
        public String CurrentRatioUpper;
        public String AcidTestLower;
        public String AcidTestMedian;
        public String AcidTestUpper;
        public String StockTurnoverLower;
        public String StockTurnoverMedian;
        public String StockTurnoverUpper;
        public String CreditPeriodLower;
        public String CreditPeriodMedian;
        public String CreditPeriodUpper;
        public String WorkingCapLower;
        public String WorkingCapMedian;
        public String WorkingCapUpper;
        public String TradeCredrsDebtrsLower;
        public String TradeCredrsDebtrsMedian;
        public String TradeCredrsDebtrsUpper;
        public String ReturnOnCapitalLower;
        public String ReturnOnCapitalMedian;
        public String ReturnOnCapitalUpper;
        public String ReturnOnAssetsLower;
        public String ReturnOnAssetsMedian;
        public String ReturnOnAssetsUpper;
        public String PreTaxMarginLower;
        public String PreTaxMarginMedian;
        public String PreTaxMarginUpper;
        public String ReturnOnShareholdersFundsLower;
        public String ReturnOnShareholdersFundsMedian;
        public String ReturnOnShareholdersFundsUpper;
        public String BorrowingRatioLower;
        public String BorrowingRatioMedian;
        public String BorrowingRatioUpper;
        public String EquityGearingLower;
        public String EquityGearingMedian;
        public String EquityGearingUpper;
        public String DebtGearingLower;
        public String DebtGearingMedian;
        public String DebtGearingUpper;
        public String InterestCoverLower;
        public String InterestCoverMedian;
        public String InterestCoverUpper;
        public String SalesTangAssetsLower;
        public String SalesTangAssetsMedian;
        public String SalesTangAssetsUpper;
        public String AvgRemPerEmpLower;
        public String AvgRemPerEmpMedian;
        public String AvgRemPerEmpUpper;
        public String ProfitPerEmpLower;
        public String ProfitPerEmpMedian;
        public String ProfitPerEmpUpper;
        public String TurnoverPerEmpLower;
        public String TurnoverPerEmpMedian;
        public String TurnoverPerEmpUpper;
        public String CapEmployedPerEmpLower;
        public String CapEmployedPerEmpMedian;
        public String CapEmployedPerEmpUpper;
        public String TangAssetsPerEmpLower;
        public String TangAssetsPerEmpMedian;
        public String TangAssetsPerEmpUpper;
        public String TotAssetsPerEmpLower;
        public String TotAssetsPerEmpMedian;
        public String TotAssetsPerEmpUpper;
        public String EmpRemunerationSalesLower;
        public String EmpRemunerationSalesMedian;
        public String EmpRemunerationSalesUpper;
        public cls_SICInformation1980 SICInformation1980;
        public cls_SICInformation1992 SICInformation1992;

    }
  
    Public class cls_CCJs {
        public String NumberCCJs0To72;  //0
        public String ValueCCJs0To72;   //0
        public String NumberCCJsLast12Months;   //0
        public String ValueCCJsLast12Months;    //0
        public String NumberCCJs13To24; //0
        public String ValueCCJs13To24;  //0
        public String NumberCCJs25To36; //0
        public String ValueCCJs25To36;  //0
        public String NumberCCJs37To48; //0
        public String ValueCCJs37To48;  //0
        public String NumberCCJs49To60; //0
        public String ValueCCJs49To60;  //0
        public String NumberCCJs61To72; //0
        public String ValueCCJs61To72;  //0
        public cls_CCJDetail[] CCJDetail;
        //Public List<cls_CCJDetail> CCJDetail;
    }
    Public class cls_CCJDetail{
        Public String JudgmentType;//JG
        Public String JudgmentSource;
        Public String JudgmentDate;
        Public String SatisfactionDate;
        Public String JudgmentAmount;
        Public String CaseNumber;
        Public String JudgmentAgainst;
        public cls_TradingNameDetails[] TradingNameDetails;
        public cls_TradingLocation1 TradingLocation;
        public String CourtName;
    }
    Public class cls_TradingNameDetails{
        //Public String 
    }
    Public class cls_TradingLocation1{
        public String LocationLine1;
        public String LocationLine2;
        public String LocationLine3;
        public String LocationLine4;
        public String LocationLine5;
    }
    Public class cls_Mortgages {
        public String NumMortgages; //1
        public String NumSatMortgages;  //1
        public String NumUnsatMortgages;    //0
        public String DateMostRecentMort;   //1990-03-23
        public String RecMortDateFlag;  //C
        public String DateMostRecentSat;    //2013-10-31
        public List<cls_MortgageDetail> MortgageDetail;
    }
    Public class cls_MortgageDetail {
        public String ChargeNumber; //1
        public String FormType; //33
        public String RegistrationDate; //1990-04-02
        public String CreationDate; //1990-03-23
        public String Currencyiso; //£
        public String TotalDebenture;   //0
        public String AmountLatestIssue;    //0
        public String DateFullySatisfied;   //2013-10-31
        public String FullySatisfiedIndicator;  //F
        public String NumberPartialSatisfactionDates;   //0
        public String NumberPartialSatisfactionDataItems;   //0
        public String NumberTrustees;   //0
        public String NumberLenders;    //1
        public String NumberCommissionElements; //0
        public String NumberExecutors;  //0
        public String NumberExecutionDates; //0
        public String NumberReceiverAppointmentDates;   //0
        public String NumberReceiverCessationDates; //0
        public String ChargeType;   //BOND & FLOATING CHARGE
        public String AmountSecured;    //ALL SUMS DUE, OR TO BECOME DUE
        public String PropertyDetails;  //UNDERTAKING AND ALL PROPERTY AND ASSETS PRESENT AND FUTURE OF THE COMPANY INCLUDING UNCALLED CAPITAL
        public List<cls_LenderDetails> LenderDetails;
    }
    Public class cls_LenderDetails {
        public String LenderName;   //THE ROYAL BANK OF SCOTLAND plc
    }
    Public class cls_LegalNotices {
        public String SummaryCount; //3
        public List<cls_SummaryLine> SummaryLine;
        public List<cls_Notice6253> Notice6253;
        public cls_WindUp WindUp;
        public List<cls_Liquidators> Liquidators;
    }
    Public class cls_SummaryLine {
        public String EventType;    //L
        public String EventCount;   //1
        public String EventDate;    //2016-08-24
    }
    Public class cls_Notice6253 {
        public String RecordType;   //L
        public String DateOfNotice; //2016-08-24
    }
    Public class cls_WindUp {
        public List<cls_Resolution> Resolution;
    }
    Public class cls_Resolution {
        public String PublicationDate;  //2014-03-04
        public String ResolutionDate;   //2014-02-21
    }
    Public class cls_Liquidators {
        public String PublicationDate;  //2014-03-04
        public String AppointmentDate;  //2014-02-21
        public String LiquidationType;  //V
        public String AppointedBy;  //M
        public String NumberLiquidators;    //1
        public String NatureOfBusiness; //FISH MERCHANTS
        public List<cls_Liquidator> Liquidator;
    }
    Public class cls_Liquidator {
        public String Name; //ANTONIA MCINTYRE
        public String FirmName; //MLM SOLUTIONS
        public cls_LiquidatorLocation LiquidatorLocation;
    }
    Public class cls_LiquidatorLocation {
        public String LocationLine1;    //23 NELSON MANDELA PLACE
        public String LocationLine2;    //GLASGOW
        public String Postcode; //G2 1QY
    }
    Public class cls_CommercialDelphiHistory {
        public cls_CompanyHistory CompanyHistory;
        public cls_SectorScore SectorScore;
        public cls_SectorRanking SectorRanking;
        public cls_Sectors Sectors;
    }
    Public class cls_CompanyHistory {
        public String CommDelphiScore;  //000
        public String CommDelphiBand;   //7
        public String StabilityOdds;  //32:1
        public String OverrideIndicator;    //N
        public String TextCount;    //10
        public String ScoreHistoryCount;    //12
        public String CommDelphiBandText;   //Dissolved
        public List<cls_ScoreHistory> ScoreHistory;
    }
    Public class cls_ScoreHistory {
        public String ScoreHistoryDate; //2015-04-30
        public String OverrideIndicator;    //N
        public String CommDelphiScore;  //0
        public String CreditRatingOverrideIndicator;    //N
        public String CreditRating; //000000000000000
        public String CreditLimitOverrideIndicator; //N
        public String CreditLimit;  //000000000000000
    }
    Public class cls_SectorScore {
        public String RecentSnapshotDate;   //2019-01-06
        public list<string> ScoreHistoryDate;
        public String AllCompGroup; //1
        public String AllAverageDelphiScore;    //045
        public String AllAverageStabilityOdds;  //17:1
        public cls_AllHistoricalScore AllHistoricalScore;
        public String IndCompGroup; //2
        public String IndCompSector;    //51
        public String IndAverageDelphiScore;    //048
        public String IndAverageStabilityOdds;  //20:1
        public cls_IndHistoricalScore IndHistoricalScore;
        public String AgeCompGroup; //4
        public String AgeCompSector;    //09
        public String AgeAverageDelphiScore;    //070
        public String AgeAverageStabilityOdds;  //32:1
        public cls_AgeHistoricalScore AgeHistoricalScore;
    }
    Public class cls_ScoreHistoryDate {
        public String zero;    //2
        public String one;    //0
        public String two;    //1
        public String three;    //8
        public String four;    //-
        public String five;    //0
        public String six;    //1
        public String seven;    //-
        public String Eight;    //3
        public String nine;    //1
    }
    Public class cls_AllHistoricalScore {
        public List<string> AllHistoricalAverageDelphiScore;
    }
    Public class cls_AllHistoricalAverageDelphiScore {
        public String zero;    //0
        public String one;    //4
        public String two;   //4
    }
    Public class cls_IndHistoricalScore {
        public List<string> IndHistoricalAverageDelphiScore;
    }
    Public class cls_IndHistoricalAverageDelphiScore {
        public String zero;    //0
        public String one;    //4
        public String two; //9
    }
    Public class cls_AgeHistoricalScore {
        public List<string>  AgeHistoricalAverageDelphiScore;
    }
    Public class cls_AgeHistoricalAverageDelphiScore {
        public String zero;    //0
        public String one;    //6
        public String two; //9
    }
    Public class cls_SectorRanking {
        public String AllCompGroup; //1
        public String AllNumberSector;  //3359040
        public String AllPercentSector; //100
        public String AllNumberLowerScore; //"0331707",
        public String AllNumberSameScore; //"0082053",
        public String AllNumberHigherScore; //"2938207",
        public String AllPercentile;    //000
        public String IndCompGroup; //2
        public String IndCompSector;    //51
        public String IndNumberSector;  //0101475
        public String IndPercentSector; //003
        public String IndPercentile;    //000
        public String IndNumberLowerScore;// "0000465",
        public String IndNumberSameScore; //"0000123",
        public String IndNumberHigherScore; //"0006470",
        public String SizeCompGroup;    //3
        public String AgeCompGroup; //4
        public String AgeCompSector;    //09
        public String AgeNumberSector;  //0156033
        public String AgePercentSector; //005
        public String AgeNumberLowerScore;// "0071929",
        public String AgeNumberSameScore; //"0061460",
        public String AgeNumberHigherScore;// "0488772",
        public String AgePercentile;    //000
    }
    Public class cls_Sectors {
        public String AllCompGroup; //1
        public String AllCompGroupName; //All Scored Companies
        public String IndCompGroup; //2
        public String IndCompGroupName; //Industry
        public String IndCompGroupSector;   //51
        public String IndCompGroupSectorName;   //Wholesale Trade and Commission Trade, Except of Motor Vehicles and Motorcycles
        public String SizeCompGroup;    //3
        public String SizeCompGroupName;    //Company Size
        public String SizeCompGroupSector;//"05",
        public String SizeCompGroupSectorLowerBound;// "000000000150000",
        public String SizeCompGroupSectorUpperBound;// "000000000300000",
        public String AgeCompGroup; //4
        public String AgeCompGroupName; //Company Age
        public String AgeCompGroupSector;   //09
        public String AgeCompGroupSectorStartDate;  //January 1988
        public String AgeCompGroupSectorEndDate;    //January 1999
    }
    Public class cls_ScoringData {
        public String LegalStatus;  //2
        public String CompanyAge;   //000346
        public cls_SICInformation1980 SICInformation1980;
        public cls_SICInformation1992 SICInformation1992;
        public String Region;   //EH
        public String NumRegOfficeChangesLast12Months;  //0
        public String NumMemArtsChangesLast12Months;    //0
        public String HasSubsidiaries;  //N
        public String IsSubsidiary; //1
        public String NumEmployees; //-9999999999999
        public String RegOfficeCIFASIndicator;  //N
        public String TimeSinceLastRegOfficeChange; //59
        public String NumCurrDirs;  //3
        public String IncompleteDirsFlag;   //N
        public String TimeSinceLastDirAppt; //221
        public String OldestCurrDirAge; //-999
        public String NumDirsHoldingShares; //3
        public String NumDisqCurrDirs;  //0
        public String NumAppointmentsLast12;    //0
        public String ProportionCurrDirsToPrevDirLast12;    //-9999.9
        public String PercentageDirsResidentUK; //100
        public String NumDirsIncorpAgents;  //0
        public String NumWindUpOrders;  //0
        public String TimeSinceLastWindUpOrder; //-99999
        public String NumApptVolLiquidator; //1
        public String TimeSinceLastApptVolLiquidator;   //59
        public String NumMeetingsCreditors; //0
        public String TimeSinceLastMeetingCreditors;    //-99999
        public String NumResolutionWindUp;  //2
        public String TimeSinceLastResolutionWindUp;    //59
        public String NumApptCompLiquidator;    //0
        public String TimeSinceLastApptCompLiquidator;  //-99999
        public String NumApptReceiver;  //0
        public String TimeSinceLastApptReceiver;    //-99999
        public String NumReceiverCeasing;   //0
        public String TimeSinceLastReceiverCeasing; //-99999
        public String NumPetitionCompWindUp;    //0
        public String TimeSinceLastPetitionCompWindUp;  //-99999
        public String NumDismissedPetition; //0
        public String TimeSinceLastDismissedPetition;   //-99999
        public String NumApptAdministrator; //0
        public String TimeSinceLastApptAdministrator;   //-99999
        public String NumDischargeAdministrator;    //0
        public String TimeSinceLastDischargeAdministrator;  //-99999
        public String NumApprovalVolArrangement;    //0
        public String TimeSinceLastApprovalVolArrangement;  //-99999
        public String NumRevocationVoluntaryArrangement;    //0
        public String TimeSinceLastRevocationVolArrangement;    //-99999
        public String NumSuspensionVolArrangement;  //0
        public String TimeSinceLastSuspensionVolArrangement;    //-99999
        public String NumCompletionsVolArrangement; //0
        public String TimeSinceLastCompletionVolArrangement;    //-99999
        public String NumIntentionToDissolve;   //0
        public String TimeSinceLastIntentionToDissolve; //-99999
        public String NumCompanyDissolved;  //1
        public String TimeSinceLastCompanyDissolved;    //29
        public String NumCompanyReinstated; //0
        public String TimeSinceLastCompanyReinstated;   //-99999
        public String LastDerogatoryItem;   //H
        public String TimeSinceLastDerogatoryItem;  //59
        public String TimeSinceLastWindUpHearing;   //-99999
        public String AgeMostRecentCCJ; //-999
        public String ValueMostRecentCCJ;   //0
        public String HighestValueCCJ;  //0
        public String NumberCCJs0To72;  //0
        public String ValueCCJs0To72;   //0
        public String NumberCCJsLast12Months;   //0
        public String ValueCCJsLast12Months;    //0
        public String NumberCCJs13To24; //0
        public String ValueCCJs13To24;  //0
        public String NumberCCJs25To36; //0
        public String ValueCCJs25To36;  //0
        public String NumberCCJs37To48; //0
        public String ValueCCJs37To48;  //0
        public String NumberCCJs49To60; //0
        public String ValueCCJs49To60;  //0
        public String NumberCCJs61To72; //0
        public String ValueCCJs61To72;  //0
        public String TotValCCJsPropShareFunds; //0
        public String ValCCJsLast24MonthsPropShareFunds;    //0
        public String NumUnsatPartSatMortgages; //0
        public String NumSatMortgages;  //1
        public String NumUnsatMortgages;    //0
        public String CurrAccsAvailabe; //Y
        public String PrevAccsAvailabile;   //Y
        public String OutOfDateFlag;    //N
        public String CompanyClass; //S
        public String DormancyFlag; //N
        public String PrevAccountsDormancyFlag; //N
        public String AuditType;    //D
        public String AuditorsQualifications;   //0
        public String LatenessAccounts; //0054
        public String FicheDate;    //2012-12-27
        public String NumberDaysToFile; //268
        public String NumYearsAccosAvailable;   //10
        public String TimeSinceLastAccsSubmitted;   //81
        public String TimeSinceLastRetsSubmitted;   //71
        public String LatestAccountsType;   //9
        public String DateOfAccounts;   //2012-03-31
        public String AccountingPeriod; //52
        public String Currencyiso; //GBP
        public String PrevAccsCurrencyiso; //GBP
        public String ConsAccounts; //N
        public String PrevAccsConsAccounts; //N
        public String NetWorth; //1348495
        public String IntangibleAssets; //0
        public String FixedAssets;  //157500
        public String TotalCurrentAssets;   //1269007
        public String ShortLoans;   //0
        public String TotalCurrentLiabilities;  //78012
        public String WorkingCapital;   //1190995
        public String CapitalEmployed;  //1348495
        public String TotalLongTermLiabilities; //0
        public String IssuedCapital;    //3830934
        public String RevaluationReserves;  //0
        public String RetainedEarnings; //-2482439
        public String ShareholdersFunds;    //1348495
        public String TotalAssets;  //1426507
        public String GrossAssets;  //1426507
        public String TotalTurnover;    //-999999999999999
        public String PreTaxProfitLoss; //-999999999999999
        public String Dividends;    //-999999999999999
        public String RetainedProfit;   //-999999999999999
        public String CreditPeriod; //-9999999
        public String LiquidityStandardRatio;   //16.3
        public String Currentratio; //16.3
        public String AcidTest; //16.1
        public String ReturnOnCapital;  //-999999.9
        public String ReturnOnAssets;   //-999999.9
        public String PreTaxProfitMargin;   //-999999.9
        public String BorrowingRatio;   //-999999.9
        public String EquityGearing;    //94.5
        public String DebtGearing;  //-999999.9
        public String TurnoverPerEmp;   //-999999.9
        public String TotAssetsEmp; //-999999.9
        public String TotalFixedAssetsPercentTotalAssets;   //11
        public String CurrentLiabilitiesPercentTotalAssets; //5.5
        public String CapitalEmployedPercentTotalAssets;    //94.5
        public String StocksWorkInProgressPercentCurrentAssets; //1.3
        public String WorkingCapitalPercentCurrentPlusFixedAssets;  //83.5
        public String BaseTrendShareholdersFunds;   //3
        public String PercentChangeShareholdersFunds;   //3.8
        public String PercentChangeCapitalEmployed; //3.8
        public String PercentChangeTotalAssets; //1.8
        public String PercentChangeCurrentRatio;    //178.8
        public String PercentChangePreTaxProfitLoss;    //-999999.9
        public String NumYearsPreTaxProfitLessThan0Last4Years;  //0
        public String ReturnOnAssetsQuartile;   //9
        public String PreTaxMarginQuartile; //9
        public String FiledAccsType;    //G
        public cls_LimitedCompanyDelphiCAIS LimitedCompanyDelphiCAIS;
        public List<cls_LimitedCompanyDelphiRisk> LimitedCompanyDelphiRisk;
        public cls_LimitedCompanyDelphiPayment[] LimitedCompanyDelphiPayment;
        public String ReportUpdateFlag; //0
    }
    Public class cls_LimitedCompanyDelphiCAIS {
        public String NumDefaults;  //-999
        public String ValueDefaults;    //-999999999
        public String AgeMostRecent;    //-999
        public String NumSettled;   //-999
        public String NumOwnAccounts;   //000000
        public String TotalBalanceOwnAccounts;  //-0999999999
        public String AvgBalanceOwnAccounts;    //-0999999999
        public String WorstStatusOld;   //X
        public String WorstStatusActive;    //X
        public String NumActiveAccounts;    //-999
        public String BalanceActiveAccounts;    //-999999999
    }
    Public class cls_LimitedCompanyDelphiRisk {
        public String CommercialDelphiScore;    //000
        public String CreditRating; //000000000000000
        public String CreditLimit;  //000000000000000
        public String CreditCode;   //G0
        public String CommercialDelphiOverRideFlag; //N
        public String CreditRatingOverRideflag; //N
        public String CredLimitOverRideFlag;    //N
        public String CreditCodeOverRideFlag;   //N
    }
    Public class cls_LimitedCompanyDelphiPayment {
        public String AverageCurrentDaysBeyondTerm; //-9999999
        public String AverageNumberExperiencesLast3month;   //-9999999
        public String NumberOfAccountsCollectionLast12Months;   //-99999
        public String NumberUnpaidAccountsLastMonth;    //-99999
        public String PercentChangeLast3Months; //-9999999
    }
    Public class cls_Alerts {
        public String NotesCount;   //0
        public String NotesLength;  //0
        //public List<cls_Notes> Notes;
        public cls_Notes Notes;
    }
    Public class cls_Notes {
          public String AlertCode; //"A09",
          public String AlertHeader; // "CIFAS Warning",
          public String AlertNote; //Attention is drawn to the CIFAS data held at the Registered Office address. This should be investigated further."
    }
    Public class cls_NoticeOfCorrection {
        public String NumCorrections;   //0
    }
    Public class cls_DirectorExpandedSummary {
        public String NumDirectorsFound;    //3
        public String NumDirectorsNotFound; //0
        public String Nolag;  //N
        public String NocFlag;
        public String NumDisqualifications; //0
        public String NumConvictions;   //0
        public String NumCIFAS; //0
        public String NumDirectorships; //13
        public String NumCurrrentDirships;  //6
        public String NumCurrentDissolvedDirships;  //3
        public String NumPreviousDirectorships; //4
        public String NumDirectorshipsFailed;   //0
        public String NumDirectorshipsNotFailed;    //13
        public String NumDirectorshipsCompulsoryLiquidator; //0
        public String NumDirectorshipsCreditorLiquidator;   //0
        public String NumDirectorshipsMemberLiqidator;  //3
        public String NumDirectorshipsUnknownLiquidator;    //0
        public String NumDirectorshipsWindUpOrder;  //0
        public String NumDirectorshipsAdministratorAppointed;   //0
        public String NumDirectorshipsAdministratorDischarge;   //0
        public String NumDirectorshipsAppointmentAdministrativeReceiver;    //0
        public String NumDirectorshipsReceiverAppointed;    //0
        public String NumDirectorshipsAdministrativeReceiverCessation;  //0
        public String NumDirectorshipsReceiverCessation;    //0
        public String NumDirectorshipsApprovalVoluntaryArrangements;    //0
        public String NumDirectorshipsCompletionVoluntaryArrangements;  //0
        public String NumDirectorshipsRevocationVoluntaryArrangements;  //0
        public String NumDirectorshipsSuspensionVoluntaryArrangements;  //0
        public String NumDirectorshipsReinstated;   //0
        public String NumDirectorshipsDissolved;    //3
        public cls_DirectorNumbers DirectorNumbers;
    }
    Public class cls_DirectorNumbers {
        //public String[] DirectorNumbers;
       // public string DirectorNumber;
    }
  
    Public class cls_PaymentPerformance {
        public cls_PaymentFull PaymentFull;
    }
    Public class cls_PaymentFull {
        public String AvgDBT3Mnths; //0
        public String AvgDBT6Mnths; //0
        public String AvgDBT12Mnths;    //0
        public String NumberDBT1K;  //0
        public String NumberDBT10K; //0
        public String NumberDBT100K; //0
        public String NumberDBT100KPlus; //0
        public String NumberCashFirst;  //0
        public String NumberCollection; //0
        public String ValCollection;    //0
        public cls_UnpaidAccountsDetails[] UnpaidAccountsDetails;
        public String IndAvgDBT3Mnths;  //22
        public String IndAvgDBT6Mnths;  //23
        public String IndAvgDBT12Mnths; //25
        public String IndNumberDBT1K;   //19
        public String IndNumberDBT10K;  //38
        public String IndNumberDBT100K; //30
        public String IndNumberDBT100KPlus; //16
        public String PaymentPattern;   //C
        public String IndPaymentPattern;    //F
        public String PaymentToTerms;   //W
        public String FastestPayment;   //0
        public String FastestMonth; //2018-02
        public String SlowestPayment;   //0
        public String SlowestMonth; //2018-10
        public String NumCommonTerms;   //1
        public String CompanyNumMnths;  //13
        public String IndustryNumMnths; //12
        public cls_CompanyDBTMonthly[] CompanyDBTMonthly;
        public cls_IndDBTMonthly[] IndDBTMonthly;
        public cls_CommonTerms[] CommonTerms;
        public String IndustrySICDesc;  //Business Services
    }
    public class cls_UnpaidAccountsDetails {
        public String UnpaidAccounts;   //0
    }
    public class cls_CompanyDBTMonthly {
        public String CompanyExpMonth;  //2018-02
        public String CompanyDBT;   //0
        public String CompanyNumExp;    //3
    }
    public class cls_IndDBTMonthly {
        public String IndExpMonth;  //2018-02
        public String IndustryDBT;  //27
    }
    public class cls_CommonTerms {
        public String CommonTermsDBT; 
        public String CommonTermsNumExp;    //2
        public String CommonTermsCode;  //OTHER
        public String CommonTermsText;  //Others/Unknown
    }
    public class cls_LtdCompanyCAIS {
        public cls_LtdCompanyCAISSummary LtdCompanyCAISSummary;
        public cls_LtdCompanyCAISDetails[] LtdCompanyCAISDetails;
    }
    public class cls_LtdCompanyCAISSummary {
        public String AgeSinceLast89;   //0
        public String MonthCount;   //12
        public cls_MonthlyData[] MonthlyData;
    }
    public class cls_MonthlyData {
        public String MonthYyyy;   //2019
        public String MonthMm; //04
        public String Status0;  //0
        public String Status1;  //0
        public String Status2;  //0
        public String Status3;  //0
        public String Status4;  //0
        public String Status5;  //0
        public String Status6;  //0
        public String StatusU;  //0
        public String Status89; //0
        public String CurrentBalance;   //0
        public String NumActiveAccounts;    //0
        public String DefaultBalance;   //0
    }
   public class cls_LtdCompanyCAISDetails {
        public String AccountState; //D
        public String CompanyType;  //31
        public String AccountType;  //27
        public String DefaultDate;  //2014-06-30
        public String DefaultBalance;   //0000536707
        public String CurrentBalance;   //0000462619
        public String Status1To2;   //0
        public String Status3To9;   //0
        public String CaisLastUpdate;   //2014-07-01
        public String AccountStatus12;  //800000000000
        public String MonthsData;   //13
    }
    
    public static Saf_ExperainNotes parseNotes(String json){
        system.debug('***JSON for Experian*****'+json);
         json = json.replace('\"Date":','\"Date1":'); 
        return (Saf_ExperainNotes) System.JSON.deserialize(json, Saf_ExperainNotes.class);
    }
   public static Saf_ExperainNotes.cls_CorporateStructure parse2(String json){
        return (Saf_ExperainNotes.cls_CorporateStructure) System.JSON.deserialize(json, Saf_ExperainNotes.cls_CorporateStructure.class);
    }
   
}