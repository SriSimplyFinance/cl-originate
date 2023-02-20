@isTest
public class SafExperain_Mock implements HttpCalloutMock
{
    public HTTPResponse respond(HTTPRequest request)
    {
        HttpResponse response=new HttpResponse();
        response.setStatus('success');
        response.setStatusCode(200);
        response.setHeader('Content-Type','application/json');
        String json= '{'+
        '    "RegNumber": "11209193",'+
        '    "CommercialName": "VATA ENVIRONMENTAL LTD",'+
        '    "Identification": {'+
        '        "LegalStatus": "2",'+
        '        "IncorporationDate": "2018-02-16",'+
        '        "RegisteredOffice": {'+
        '            "LocationLine1": "22 WELLINGTON GARDENS",'+
        '            "LocationLine2": "CHARLTON",'+
        '            "LocationLine3": "LONDON",'+
        '            "LocationLine4": "ENGLAND",'+
        '            "Postcode": "SE7 7PH"'+
        '        },'+
        '        "Currency": "GBP",'+
        '        "IssuedCapital": "1",'+
        '        "AsRegisteredOffice": "Y",'+
        '        "TradingLocation": {'+
        '            "LocationLine1": "22 WELLINGTON GARDENS",'+
        '            "LocationLine2": "CHARLTON",'+
        '            "LocationLine3": "LONDON",'+
        '            "LocationLine4": "ENGLAND",'+
        '            "Postcode": "SE7 7PH"'+
        '        },'+
        '        "SICInformation1992": ['+
        '            {'+
        '                "Code": "9000",'+
        '                "Description": "REFUSE DISPOSAL, SANITATION, ETC"'+
        '            }'+
        '        ],'+
        '      "SICInformation1980":[{' +
        '      "Code":"6170",'+
        '      "Description":"5138"'+
        '   }],'+
        '        "FilingDetails": {'+
        '            "DatabaseAccountsOutOfDate": "N",'+
        '            "FiledAccountsOutOfDate": "N",'+
        '            "NumAccountsOnFile": "0",'+
        '            "AccountsRefDate": {'+
        '                "MM": "02",'+
        '                "DD": "28"'+
        '            }'+
        '        },'+           
        '    "Auditor":{'+
                '"Currencyiso":"GBP",'+
                '"AuditType":"D",'+
                '"AuditQual":"0",'+ 
                '"Auditors":"WHITELAW WELLS"'+
            '},'+
        '        "Bank": null,'+
        '        "PrevSearches": {'+
        '            "NumPrevSearch": "5",'+
        '            "NumPrevSearch3Mth": "3",'+
        '            "NumPrevSearch6Mth": "5",'+
        '            "NumPrevSearch12Mth": "5",'+
        '            "PreviousSearchDetail": ['+
        '                {'+
        '                    "SearchDate": "2018-12-19",'+
        '                    "EnquiryType": "0",'+
        '                    "OwnEnquiryFlag": "N",'+
        '                    "SICInformation": {'+
        '                        "Code": "8150",'+
        '                        "Type": "FINL",'+
        '                        "Description": "FINANCE/CREDIT"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "SearchDate": "2018-12-14",'+
        '                    "EnquiryType": "C",'+
        '                    "OwnEnquiryFlag": "N",'+
        '                    "SICInformation": {'+
        '                        "Code": "8150",'+
        '                        "Type": "FINL",'+
        '                        "Description": "FINANCE/CREDIT"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "SearchDate": "2018-12-13",'+
        '                    "EnquiryType": "C",'+
        '                    "OwnEnquiryFlag": "N",'+
        '                    "SICInformation": {'+
        '                        "Type": "MISC",'+
        '                        "Description": "MISCELLANEOUS"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "SearchDate": "2018-08-14",'+
        '                    "EnquiryType": "C",'+
        '                    "OwnEnquiryFlag": "N",'+
        '                    "SICInformation": {'+
        '                        "Type": "MISC",'+
        '                        "Description": "MISCELLANEOUS"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "SearchDate": "2018-08-13",'+
        '                    "EnquiryType": "C",'+
        '                    "OwnEnquiryFlag": "N",'+
        '                    "SICInformation": {'+
        '                        "Type": "MISC",'+
        '                        "Description": "MISCELLANEOUS"'+
        '                    }'+
        '                }'+
        '            ]'+
        '        },'+
        '        "CCLs": {'+
        '            "TotalNumberCCL": "0"'+
        '        }'+
        '    },'+
        '   "CorporateStructure":'+
                                    '{'+
					                '"CompanyOwnership": {'+
					                                   '"BulkShareHolders":"N",'+
                                                       '"BulkTelephone":"01159016000",'+
                                                       '"NumPrincShareHldrs":"4",'+
                                                       '"ParentDetail": {} ,'+
                                                       '"UltParentDetail":{ },'+
                                                       '"CorporateShareholder": [{}]'+                   					   
						                               '},'+
						              '"Subsidiaries":{'+
                                                      '"TreePosition":"1",'+
                                                      '"TotalElements":"1",'+
                                                       '"TotalSubs":"0",'+
                                                       '"TotalNumImmediateSubs":"0",'+
                                                       '"TotalNumLiveImmediateSubs":"0",'+  //0
                                                      '"TotalNumDormantImmediateSubs":"0",'+
                                                      '"TotalNumDissolvedLiquidatedImmediateSubs":"0",'+
                                                      '"TotalNumNestedSubs":"0",' +
                                                      '"TotalNumSubs":"0",'+
                                                       '"TotalNumUKSubs":"0",'+
                                                       '"TotalNumOverseasSubs":"0",' +     
							                           '"UKSubsidiaries":[{'+
								                                         '"SubRegNumber":"03457731",'+
                                                                         '"SubStatus":"D",'+
                                                                         '"SubLegalStatus":"2",'+
                                                                         '"SubName":"BOSTOCKSCOACHESLIMITED"'+
							                                              '}]'+
									                 '}'+
								'},'+
        '    "ManagementInfo": {'+
                     '        "NumDirs": "1",'+
                     '        "NumSecs": "0",'+
                     '        "NumCurrDirs": "1",'+
                     '        "NumPrevDirs": "0",'+
                     '        "DirectorAvgAge": "0",'+
                     '        "DirectorAvgLength": "11",'+
                     '        "NumCurrDirectorLast12": "1",'+
                      '        "NumAppointmentsLast12": "1",'+
        '        "NumResignationsLast12": "0",'+
        '        "NumDisqualifications": "0",'+
        '        "Directors": {'+
        '            "CurrentDirector": ['+
        '                {'+
        '                    "ForeignAddressFlag": "N",'+
        '                    "DirectorCompanyFlag": "N",'+
        '                    "DirectorNumber": "D18101794",'+
        '                    "AppointmentDate": "2018-02-16",'+
        '                    "AppointmentIndicator": "E",'+
        '                    "DirectorshipLength": "0011",'+
        '                    "NumberConvictions": "0",'+
        '                    "DirectorDetails": {'+
        '                        "Name": {'+
        '                            "Prefix": "MR",'+
        '                            "Forename": "MARUF",'+
        '                            "SurName": "TOPALLI"'+
        '                        },'+
        '                        "CommercialDetail": null,'+
        '                        "Location": {'+
        '                            "HouseNumber": "22",'+
        '                            "Street": "WELLINGTON GARDENS",'+
        '                            "District": "CHARLTON",'+
        '                            "PostTown": "LONDON",'+
        '                            "Postcode": "SE7 7PH",'+
        '                            "RMC": "0000614"'+
        '                        },'+
        '                        "Occupation": "COMPANY DIRECTOR",'+
        '                        "Nationality": "ROMANIAN",'+
        '                        "ShareInformation": "1 ORD £1"'+
        '                    }'+
        '                }'+
        '            ],'+           
        '            "PreviousDirector":['+
	    '                {'+
        '                    "ForeignAddressFlag": "N",'+
        '                    "DirectorCompanyFlag": "N",'+
        '                    "DirectorNumber": "D18101794",'+
        '                    "AppointmentDate": "2018-02-16",'+
         '                   "ResignationIndicator":"E",'+
        '                    "AppointmentIndicator": "E",'+
        '                    "ResignationDate":"2018-10-16",'+
        '                    "DirectorshipLength": "0011",'+
        '                    "NumberConvictions": "0",'+
        '                    "DirectorDetails": {'+
        '                        "Name": {'+
        '                            "Prefix": "MR",'+
        '                            "Forename": "MARUF",'+
        '                            "SurName": "TOPALLI"'+
        '                        },'+
        '                        "CommercialDetail": null,'+
        '                        "Location": {'+
        '                            "HouseNumber": "22",'+
        '                            "Street": "WELLINGTON GARDENS",'+
        '                            "District": "CHARLTON",'+
        '                            "PostTown": "LONDON",'+
        '                            "Postcode": "SE7 7PH",'+
        '                            "RMC": "0000614"'+
        '                        },'+
        '                        "Occupation": "COMPANY DIRECTOR",'+
        '                        "Nationality": "ROMANIAN",'+
        '                        "ShareInformation": "1 ORD £1"'+
        '                    }'+
        '                }'+
        '            ]'+           
        '       }'+
        '    },'+
        '    "LimitedCompanyCIFAS": {'+
        '        "LimitedCompanyCIFASDetails": ['+
        '            {'+
        '                "Reference": "03768805B",'+
        '                "FraudCategory": "03",'+
        '                "SupplierName": "SANTANDER",'+
        '                "Date": {'+
        '                    "DateSuppliedYyyy": "2018",'+
        '                    "DateSuppliedMm": "03",'+
        '                    "DateSuppliedDd": "28",'+
        '                    "ExpiryDateYyyy": "2024",'+
        '                    "ExpirydateMm": "03",'+
        '                    "ExpiryDateDd": "28"'+
        '                },'+
        '                "OtherAddressFlag": "N",'+
        '                "Name": "MR BLERIM SHERIFI",'+
        '                "Address1": "22",'+
        '                "Address2": "WELLINGTON GARDENS",'+
        '                "Address3": "LONDON",'+
        '                "Postcode": "SE7 7PH"'+
        '            },'+
        '            {'+
        '                "Reference": "03770841A",'+
        '                "FraudCategory": "01",'+
        '                "SupplierName": "SANTANDER",'+
        '                "Date": {'+
        '                    "DateSuppliedYyyy": "2018",'+
        '                    "DateSuppliedMm": "05",'+
        '                    "DateSuppliedDd": "16",'+
        '                    "ExpiryDateYyyy": "2024",'+
        '                    "ExpirydateMm": "05",'+
        '                    "ExpiryDateDd": "16"'+
        '                },'+
        '                "OtherAddressFlag": "N",'+
        '                "Name": "MR DANIELE CAROLLO",'+
        '                "Address1": "22",'+
        '                "Address2": "WELLINGTON GARDENS",'+
        '                "Address3": "LONDON",'+
        '                "Postcode": "SE7 7PH"'+
        '            },'+
        '            {'+
        '                "Reference": "063E2348A",'+
        '                "FraudCategory": "01",'+
        '                "SupplierName": "LLOYDS BANK",'+
        '                "Date": {'+
        '                    "DateSuppliedYyyy": "2017",'+
        '                    "DateSuppliedMm": "08",'+
        '                    "DateSuppliedDd": "1",'+
        '                    "ExpiryDateYyyy": "2023",'+
        '                    "ExpirydateMm": "08",'+
        '                    "ExpiryDateDd": "1"'+
        '                },'+
        '                "OtherAddressFlag": "N",'+
        '                "Name": "MR DANIELE CAROLLO",'+
        '                "Address1": "22",'+
        '                "Address2": "WELLINGTON GARDENS",'+
        '                "Address3": "LONDON",'+
        '                "Postcode": "SE7 7PH"'+
        '            },'+
        '            {'+
        '                "Reference": "153G2629A",'+
        '                "FraudCategory": "01",'+
        '                "SupplierName": "CAPITAL ONE",'+
        '                "Date": {'+
        '                    "DateSuppliedYyyy": "2019",'+
        '                    "DateSuppliedMm": "01",'+
        '                    "DateSuppliedDd": "11",'+
        '                    "ExpiryDateYyyy": "2025",'+
        '                    "ExpirydateMm": "01",'+
        '                    "ExpiryDateDd": "11"'+
        '                },'+
        '                "OtherAddressFlag": "N",'+
        '                "Name": "MR SHOUOUDADEMOLLA BILEKANLELIADY",'+
        '                "Address1": "FLAT A, 22",'+
        '                "Address2": "WELLINGTON GARDENS",'+
        '                "Address3": "LONDON",'+
        '                "Postcode": "SE7 7PH"'+
        '            },'+
        '            {'+
        '                "Reference": "57550413A",'+
        '                "FraudCategory": "01",'+
        '                "SupplierName": "LAW ENFOR AGENCY",'+
        '                "Date": {'+
        '                    "DateSuppliedYyyy": "2018",'+
        '                    "DateSuppliedMm": "05",'+
        '                    "DateSuppliedDd": "31",'+
        '                    "ExpiryDateYyyy": "2024",'+
        '                    "ExpirydateMm": "05",'+
        '                    "ExpiryDateDd": "31"'+
        '                },'+
        '                "OtherAddressFlag": "N",'+
        '                "Name": "OVIDIU CEZAR BRACAU",'+
        '                "Address1": "22",'+
        '                "Address2": "WELLINGTON GARDENS",'+
        '                "Address3": "LONDON",'+
        '                "Postcode": "SE77PH"'+
        '            },'+
        '            {'+
        '                "Reference": "57550629A",'+
        '                "FraudCategory": "01",'+
        '                "SupplierName": "LAW ENFOR AGENCY",'+
        '                "Date": {'+
        '                    "DateSuppliedYyyy": "2018",'+
        '                    "DateSuppliedMm": "05",'+
        '                    "DateSuppliedDd": "31",'+
        '                    "ExpiryDateYyyy": "2024",'+
        '                    "ExpirydateMm": "05",'+
        '                    "ExpiryDateDd": "31"'+
        '                },'+
        '                "OtherAddressFlag": "N",'+
        '                "Name": "LORENZO INVERNIZZI",'+
        '                "Address1": "22",'+
        '                "Address2": "WELLINGTON GARDENS",'+
        '                "Address3": "LONDON",'+
        '                "Postcode": "SE77PH"'+
        '            }'+
        '        ],'+
        '        "LimitedCompanyCIFASSummary": {'+
        '            "NumCIFASRecords": "6"'+
        '        }'+
        '    },'+
        '    "LimitedCompanyDelphiDirector": ['+
        '        {'+
        '            "MaxOtherDirectorships": "0000",'+
        '            "NumCreditorsWindDown": "0",'+
        '            "NumConvictions": "0",'+
        '            "NumCCJLast12month": "0",'+
        '            "ValueCCJLast12month": "000000",'+
        '            "PercentageFailures": "000000",'+
        '            "NumFailures": "0",'+
        '            "DirectorhsipsCreditorWindDown": "000000"'+
        '        }'+
        '    ],'+
        '    "Shareholders": {'+
        '        "HeaderInfo": ['+
        '            {'+
        '                "RecordType": "H",'+
        '                "IssuingCompany": "11209193",'+
        '                "CurrentPreviousFlag": "C",'+
        '                "EffectiveDate": "2018-02-16",'+
        '                "IssuedCapital": "1",'+
        '                "LegalStatus": "0",'+
        '                "DocumentType": "C",'+
        '                "LatestCurrent": "2018-02-20",'+
        '                "LatestUpdate": "2018-02-20",'+
        '                "DateLoaded": "2018-02-20"'+
        '            }'+
        '        ],'+
        '        "ShareCapital": ['+
        '            {'+
        '                "RecordType": "I",'+
        '                "IssuingCompany": "11209193",'+
        '                "CurrentPreviousFlag": "C",'+
        '                "EffectiveDate": "2018-02-16",'+
        '                "ShareClassNo": "000001",'+
        '                "Currency": "GBP",'+
        '                "ShareClassCode": "1",'+
        '                "ShareClassDesc": "ORD",'+
        '                "VotingRights": "1",'+
        '                "TotalNominalCapital": "1",'+
        '                "NumShares": "1",'+
        '                "NominalValue": "1.00",'+
        '                "Percentage": "100.00",'+
        '                "LatestUpdate": "2018-02-20"'+
        '            }'+
        '        ],'+
        '        "Shareholdings": ['+
        '            {'+
        '                "RecordType": "S",'+
        '                "IssuingCompany": "11209193",'+
        '                "CurrentPreviousFlag": "C",'+
        '                "EffectiveDate": "2018-02-16",'+
        '                "ShareClassNo": "000001",'+
        '                "ShareholdingNo": "000001",'+
        '                "NumShares": "1",'+
        '                "TotalNominalCapital": "1",'+
        '                "Percentage": "100.00",'+
        '                "PercentageTotalCapital": "100",'+
        '                "Approximation": "0",'+
        '                "LatestUpdate": "2018-02-20"'+
        '            }'+
        '        ],'+
        '        "Shareholder": ['+
        '            {'+
        '                "RecordType": "U",'+
        '                "IssuingCompany": "11209193",'+
        '                "CurrentPreviousFlag": "C",'+
        '                "EffectiveDate": "2018-02-16",'+
        '                "ShareClassNo": "000001",'+
        '                "ShareholdingNo": "000001",'+
        '                "ShareholderNo": "000001",'+
        '                "ShareholderDetails": {'+
        '                    "ShareholderType": "I",'+
        '                    "Name": {'+
        '                        "FirstName": "MARUF",'+
        '                        "Surname": "TOPALLI"'+
        '                    },'+
        '                    "CommercialDetail": {'+
        '                        "KGENName": "TPL  M"'+
        '                    }'+
        '                },'+
        '                "LatestUpdate": "2018-02-20"'+
        '            }'+
        '        ]'+
        '    },'+
        '    "CommercialDelphi": {'+
        '        "CommDelphiScore": "11",'+
        '        "CommDelphiBand": "6",'+
        '        "StabilityOdds": "6:1",'+
        '        "OverrideIndicator": "N",'+
        '        "CommDelphiBandText": "Maximum risk",'+
        '        "CreditRating": "0",'+
        '        "CreditRatingOverrideIndicator": "N",'+
        '        "CreditLimit": "0",'+
        '        "CreditLimitOverrideIndicator": "N",'+
        '        "ParentIndicator": "N",'+
        '        "ConclusionText": "A maximum risk company; all credit transactions should be supported by a directors guarantee.",'+
        '        "CreditTextOverrideIndicator": "N"'+
        '    },'+
        ' "Financials": {'+
                                '"Accounts": ['+
                                '{'+
                                '"DateOfAccounts": "2012-03-31",'+
                                '"AccountingPeriod": "52",'+
                                '"Currency": "GBP",'+
                                '"CurrencyMultiplier": "N",'+
                                '"CompanyClass": "S",'+
                                '"ConsolidatedAccounts": "N",'+
                                '"DormancyFlag": "N",'+
                                '"LatestAccountsType": "G",'+
                                '"RestatedAccounts": "N",'+
                                '"BalanceSheet": {'+
                                '"TangibleAssetsDetails": {'+
                                '"TangibleAssets": "157500"'+
                                '},'+
                                '"IntangibleAssets": "0",'+
                                '"OtherNonCurrentAssetsDetails": {'+
                                '"OtherNonCurrentAssets": "0"'+
                                '},'+
                                '"TotalFixedNonCurrentAssets": "157500",'+
                                '"InventoriesDetails": {'+
                                '"Inventories": "16466"'+
                                '},'+
                                '"DebtorsDetails": {'+
                                '"Debtors": "161049"'+
                                '},'+
                                '"TotalCashDetails": {'+
                                '"TotalCash": "1091492"'+
                                '},'+
                                '"OtherCurrentAssetsDetails": {'+
                                '"OtherCurrentAssets": "0"'+
                                '},'+
                                '"TotalCurrentAssets": "1269007",'+
                                '"CreditorsDetails": null,'+
                                '"FinancialLiabilitiesDetails": null,'+
                                '"OtherCurrentLiabilitiesDetails": {'+
                                '"OtherCurrentLiabilities": "78012"'+
                                '},'+
                                '"TotalCurrentLiabilities": "78012",'+
                                '"WorkingCapital": "1190995",'+
                                '"CapitalEmployed": "1348495",'+
                                '"LongTermFinancialLiabilitiesDetails": {'+
                                '"FinanceLeasesHirePurchase": "0",'+
                                '"FinanceLease": "0",'+
                                '"HirePurchase": "0",'+
                                '"OtherLongTermLoans": "0"'+
                                '},'+
                                '"OtherNonCurrentLiabilitiesDetails": {'+
                                '"OtherNonCurrentLiabilities": "0",'+
                                '"GroupLoans": "0",'+
                                '"DirectorLoans": "0",'+
                                '"Accruals": "0"'+
                                '},'+
                                '"TotalNonCurrentLiabilities": "0",'+
                                '"ProvisionsDetails": {'+
                                '"Provisions": "0",'+
                                '"DeferredTaxation": "0",'+
                                '"Pension": "0",'+
                                '"OtherProvision": "0"'+
                                '},'+
                                '"MinorityInterestsUKGAAP": "0",'+
                                '"NetAssets": "1348495",'+
                                '"IssuedCapitalDetails": {'+
                                '"IssuedCapital": "3830934",'+
                                '"OrdinaryShares": "3830934",'+
                                '"PreferenceShares": "0",'+
                                '"Other": "0"'+
                                '},'+
                                '"SharePremium": "0",'+
                                '"RetainedEarnings": "-2482439",'+
                                '"RevaluationReserve": "0",'+
                                '"Other": "0",'+
                                '"TotalShareholdersFunds": "1348495",'+
                                '"NetWorth": "1348495"'+
                                '},'+
                                '"ProfitLoss": {'+
                                '"InterestPayableDetails": null'+
                                '},'+
                                '"DiscontinuedOperations": null,'+
                                '"DisclosureItems": {'+
                                '"EmployeeRemunerationDetails": null,'+
                                '"DirectorRemunerationDetails": null,'+
                                '"DepreciationCharges": "3245"'+
                                '},'+
                                '"ContingentLiability": "N",'+
                                '"PostBalanceSheetEvents": "N",'+
                                '"CharitableGivingIndicator": "N"'+
        '    }],'+
        '"Cashflow":[{'  +
        '"DateOfAccounts":"2012-03-31",'+
        '" AccountingPeriod":"52",'+
        '" Currencyiso":"GBP",'+
        '" CurrencyMultiplier":"N",'+
        '" CompanyClass":"S",'+
        '" ConsAccounts":"N",'+
        '" DormancyIndicator":"N",'+
        '" LatestAccountsType":"G",'+
        '" RestatedAccounts":"N"'+
        '}],'+
        '"Ratios":[{'+
        '"DateOfAccounts":"2012-03-31",'+
        '"CompanyClass":"A",'+
        '"ConsAccounts":"seven",'+
        '"CurrentRatio":"4:1",'+
        '"AcidTest":"pass",'+
        '"EquityGearing":"pass"'+
            '}],'+
        '"PercentageChange":{'+
        '"DateOfAccounts":"2012-03-31",'+
        '"AccountingPeriod":"52",'+
        '"Currencyiso":"GBP",'+
        '"CompanyClass":"S",'+
        '"ConsAccounts":"N",'+
        '"PercentChangeGrossAsset":"1.77",'+
        '"PercentChangeNetWorth":"3.79",'+
        '"PercentChangeFixedAssets":"-80.41",'+
        '"PercentChangeCurrentAssets":"112.35",'+
        '"PercentChangeCurrentLiabilities":"-23.86",'+
        '"PercentChangeWorkingCapital":"140.54",'+
        '"PercentChangeCapitalEmployed":"3.79",'+
        '"PercentChangeNetAssets":"3.79",'+
        '"PercentChangeIssuedCapital":"0",'+
        '"PercentChangeRetainedEarnings":"1.95",'+
        '"PercentChangeShareholdersFunds":"3.79",'+
        '"PercentChangeCurrentRatio":"178.88",'+
        '"PercentChangeEquityGearing":"1.99"'+
		'},'+
       '"Quartiles":{'+
       '"FullQuartiles":{'+
	   '"YearEnd":"2012-08-31",'+
       '"DateOfAccounts":"2012-03-31",'+
        '"NumCompanies;":"12",'+
        '"CurrentRatioLower":"12:1",'+
        '"CurrentRatioMedian":"12:4",'+
        '"CurrentRatioUpper":"12:4",'+
        '"AcidTestLower":"r",'+
        '"AcidTestMedian":"e",'+
        '"AcidTestUpper":"t",'+
        '"StockTurnoverLower":"6",'+
        '"StockTurnoverMedian":"8",'+
        '"StockTurnoverUpper":"8",'+
        '"CreditPeriodLower":"9",'+
        '"CreditPeriodMedian":"9",'+
        '"CreditPeriodUpper":"8",'+
        '"WorkingCapLower":"7",'+
        '"WorkingCapMedian":"7",'+
        '"WorkingCapUpper":"6",'+
        '"TradeCredrsDebtrsLower":"7",'+
        '"TradeCredrsDebtrsMedian":"7",'+
        '"TradeCredrsDebtrsUpper":"7",'+
        '"ReturnOnCapitalLower":"7",'+
        '"ReturnOnCapitalMedian":"7",'+
        '"ReturnOnCapitalUpper":"7",'+
        '"ReturnOnAssetsLower":"5",'+
        '"ReturnOnAssetsMedian":"5",'+
        '"ReturnOnAssetsUpper":"6",'+
        '"PreTaxMarginLower":"5",'+
        '"PreTaxMarginMedian":"y",'+
        '"PreTaxMarginUpper":"y",'+
        '"ReturnOnShareholdersFundsLower":"u",'+
        '"ReturnOnShareholdersFundsMedian":"y",'+
        '"ReturnOnShareholdersFundsUpper":"y",'+
        '"BorrowingRatioLower":"yy",'+
        '"BorrowingRatioMedian":"yy",'+
        '"SICInformation1980":{'+
		                  '"Code":"6170","Description":"5138"},'+
        '"SICInformation1992":{'+
                          '"Code":"6170","Description":"5138"}'+
        '},'+
        '"MedianQuartiles":{'+
	    '"YearEnd":"2012-08-31",'+
        '"DateOfAccounts":"2012-03-31",'+
        '"NumCompanies;":"12",'+
        '"CurrentRatioLower":"12:1",'+
        '"CurrentRatioMedian":"12:4",'+
        '"CurrentRatioUpper":"12:4",'+
        '"AcidTestLower":"r",'+
        '"AcidTestMedian":"e",'+
        '"AcidTestUpper":"t",'+
        '"StockTurnoverLower":"6",'+
        '"StockTurnoverMedian":"8",'+
        '"StockTurnoverUpper":"8",'+
        '"CreditPeriodLower":"9",'+
        '"CreditPeriodMedian":"9",'+
        '"CreditPeriodUpper":"8",'+
        '"WorkingCapLower":"7",'+
        '"WorkingCapMedian":"7",'+
        '"WorkingCapUpper":"6",'+
        '"TradeCredrsDebtrsLower":"7",'+
        '"TradeCredrsDebtrsMedian":"7",'+
        '"TradeCredrsDebtrsUpper":"7",'+
        '"ReturnOnCapitalLower":"7",'+
        '"ReturnOnCapitalMedian":"7",'+
        '"ReturnOnCapitalUpper":"7",'+
        '"ReturnOnAssetsLower":"5",'+
        '"ReturnOnAssetsMedian":"5",'+
        '"ReturnOnAssetsUpper":"6",'+
        '"PreTaxMarginLower":"5",'+
        '"PreTaxMarginMedian":"y",'+
        '"PreTaxMarginUpper":"y",'+
        '"ReturnOnShareholdersFundsLower":"u",'+
        '"ReturnOnShareholdersFundsMedian":"y",'+
        '"ReturnOnShareholdersFundsUpper":"y",'+
        '"BorrowingRatioLower":"yy",'+
        '"BorrowingRatioMedian":"yy",'+
        '"SICInformation1980":{'+
		                  '"Code":"6170","Description":"5138"},'+
        '"SICInformation1992":{'+
                          '"Code":"6170","Description":"5138"}'+
        '}'+         
           '}'+
            '},'+            
        '    "CCJs": {'+
        '        "NumberCCJs0To72": "0",'+
        '        "ValueCCJs0To72": "0",'+
        '        "NumberCCJsLast12Months": "0",'+
        '        "ValueCCJsLast12Months": "0",'+
        '        "NumberCCJs13To24": "0",'+
        '        "ValueCCJs13To24": "0",'+
        '        "NumberCCJs25To36": "0",'+
        '        "ValueCCJs25To36": "0",'+
        '        "NumberCCJs37To48": "0",'+
        '        "ValueCCJs37To48": "0",'+
        '        "NumberCCJs49To60": "0",'+
        '        "ValueCCJs49To60": "0",'+
        '        "NumberCCJs61To72": "0",'+
        '        "ValueCCJs61To72": "0"'+
        '    },'+
        ' "LegalNotices":{'+
				 '"SummaryCount":"3",'+
				 '"SummaryLine":[{'+
				       '"EventType":"L",'+
                                       '"EventCount":"1",'+
                                       '"EventDate":"2016-08-24"'+
				                 '}],'+
                       '"Notice6253":[{'+
				                   '"RecordType":"L",'+
                                   '"DateOfNotice":"2016-08-24"'+
				                    '}]'+
        '},'+
        '    "CommercialDelphiHistory": {'+
        '        "CompanyHistory": {'+
        '            "CommDelphiScore": "011",'+
        '            "CommDelphiBand": "6",'+
        '            "StabilityOdds": "6:1",'+
        '            "OverrideIndicator": "N",'+
        '            "TextCount": "13",'+
        '            "ScoreHistoryCount": "0",'+
        '            "CommDelphiBandText": "Maximum risk",'+
        '            "ScoreHistory":[{'+
                          '"ScoreHistoryDate":"2015-04-30",'+
                          '"OverrideIndicator":"N",'+
                           '"CommDelphiScore":"0",'+
                           '"CreditRatingOverrideIndicator":"N",'+
                           '" CreditRating":"000000000000000",'+
                           '"CreditLimitOverrideIndicator":"N",'+
                           '"CreditLimit":"000000000000000"'+
        '                            }]'+
        '        },'+
        '        "SectorScore": {'+
        '            "RecentSnapshotDate": "2019-01-20",'+
        '            "ScoreHistoryDate": ['+
        '                "2018-01-31",'+
        '                "2018-02-28",'+
        '                "2018-03-31",'+
        '                "2018-04-30",'+
        '                "2018-05-31",'+
        '                "2018-06-30",'+
        '                "2018-07-31",'+
        '                "2018-08-31",'+
        '                "2018-09-29",'+
        '                "2018-10-31",'+
        '                "2018-11-30",'+
        '                "2018-12-31"'+
        '            ],'+
        '            "AllCompGroup": "1",'+
        '            "AllAverageDelphiScore": "045",'+
        '            "AllAverageStabilityOdds": "17:1",'+
        '            "AllHistoricalScore": {'+
        '                "AllHistoricalAverageDelphiScore": ['+
        '                    "044",'+
        '                    "045",'+
        '                    "045",'+
        '                    "046",'+
        '                    "046",'+
        '                    "046",'+
        '                    "047",'+
        '                    "047",'+
        '                    "047",'+
        '                    "048",'+
        '                    "045",'+
        '                    "045"'+
        '                ]'+
        '            },'+
        '            "IndCompGroup": "2",'+
        '            "IndCompSector": "90",'+
        '            "IndAverageDelphiScore": "053",'+
        '            "IndAverageStabilityOdds": "21:1",'+
        '            "IndHistoricalScore": {'+
        '                "IndHistoricalAverageDelphiScore": ['+
        '                    "051",'+
        '                    "052",'+
        '                    "052",'+
        '                    "053",'+
        '                    "053",'+
        '                    "053",'+
        '                    "054",'+
        '                    "054",'+
        '                    "055",'+
        '                    "055",'+
        '                    "053",'+
        '                    "053"'+
        '                ]'+
        '            },'+
        '            "AgeCompGroup": "4",'+
        '            "AgeCompSector": "01",'+
        '            "AgeAverageDelphiScore": "020",'+
        '            "AgeAverageStabilityOdds": "10:1",'+
        '            "AgeHistoricalScore": {'+
        '                "AgeHistoricalAverageDelphiScore": ['+
        '                    "019",'+
        '                    "019",'+
        '                    "020",'+
        '                    "020",'+
        '                    "021",'+
        '                    "023",'+
        '                    "026",'+
        '                    "028",'+
        '                    "031",'+
        '                    "033",'+
        '                    "020",'+
        '                    "020"'+
        '                ]'+
        '            }'+
        '        },'+
        '        "SectorRanking": {'+
        '            "AllCompGroup": "1",'+
        '            "AllNumberSector": "3351967",'+
        '            "AllPercentSector": "100",'+
        '            "AllNumberLowerScore": "0331707",'+
        '            "AllNumberSameScore": "0082053",'+
        '            "AllNumberHigherScore": "2938207",'+
        '            "AllPercentile": "012",'+
        '            "IndCompGroup": "2",'+
        '            "IndCompSector": "90",'+
        '            "IndNumberSector": "0007058",'+
        '            "IndPercentSector": "LT1",'+
        '            "IndNumberLowerScore": "0000465",'+
        '            "IndNumberSameScore": "0000123",'+
        '            "IndNumberHigherScore": "0006470",'+
        '            "IndPercentile": "008",'+
        '            "SizeCompGroup": "3",'+
        '            "AgeCompGroup": "4",'+
        '            "AgeCompSector": "01",'+
        '            "AgeNumberSector": "0622161",'+
        '            "AgePercentSector": "019",'+
        '            "AgeNumberLowerScore": "0071929",'+
        '            "AgeNumberSameScore": "0061460",'+
        '            "AgeNumberHigherScore": "0488772",'+
        '            "AgePercentile": "021"'+
        '        },'+
        '        "Sectors": {'+
        '            "AllCompGroup": "1",'+
        '            "AllCompGroupName": "All Scored Companies",'+
        '            "IndCompGroup": "2",'+
        '            "IndCompGroupName": "Industry",'+
        '            "IndCompGroupSector": "90",'+
        '            "IndCompGroupSectorName": "Sewage and Refuse Disposal, Sanitation and Similar Services",'+
        '            "SizeCompGroup": "3",'+
        '            "SizeCompGroupName": "Company Size",'+
        '            "AgeCompGroup": "4",'+
        '            "AgeCompGroupName": "Company Age",'+
        '            "AgeCompGroupSector": "01",'+
        '            "AgeCompGroupSectorStartDate": "February 2018",'+
        '            "AgeCompGroupSectorEndDate": "January 2019"'+
        '        }'+
        '    },'+
        '    "ScoringData": {'+
        '        "LegalStatus": "2",'+
        '        "CompanyAge": "000011",'+
        '        "SICInformation1980": null,'+
        '        "SICInformation1992": {'+
        '            "Code": "9000"'+
        '        },'+
        '        "Region": "SE",'+
        '        "NumRegOfficeChangesLast12Months": "0",'+
        '        "NumMemArtsChangesLast12Months": "0",'+
        '        "HasSubsidiaries": "N",'+
        '        "IsSubsidiary": "1",'+
        '        "NumEmployees": "-9999999999999",'+
        '        "RegOfficeCIFASIndicator": "Y",'+
        '        "TimeSinceLastRegOfficeChange": "999",'+
        '        "NumCurrDirs": "1",'+
        '        "IncompleteDirsFlag": "Y",'+
        '        "TimeSinceLastDirAppt": "11",'+
        '        "OldestCurrDirAge": "-999",'+
        '        "NumDirsHoldingShares": "1",'+
        '        "NumDisqCurrDirs": "0",'+
        '        "NumAppointmentsLast12": "100",'+
        '        "ProportionCurrDirsToPrevDirLast12": "-9999.9",'+
        '        "PercentageDirsResidentUK": "100",'+
        '        "NumDirsIncorpAgents": "0",'+
        '        "NumWindUpOrders": "0",'+
        '        "TimeSinceLastWindUpOrder": "-99999",'+
        '        "NumApptVolLiquidator": "0",'+
        '        "TimeSinceLastApptVolLiquidator": "-99999",'+
        '        "NumMeetingsCreditors": "0",'+
        '        "TimeSinceLastMeetingCreditors": "-99999",'+
        '        "NumResolutionWindUp": "0",'+
        '        "TimeSinceLastResolutionWindUp": "-99999",'+
        '        "NumApptCompLiquidator": "0",'+
        '        "TimeSinceLastApptCompLiquidator": "-99999",'+
        '        "NumApptReceiver": "0",'+
        '        "TimeSinceLastApptReceiver": "-99999",'+
        '        "NumReceiverCeasing": "0",'+
        '        "TimeSinceLastReceiverCeasing": "-99999",'+
        '        "NumPetitionCompWindUp": "0",'+
        '        "TimeSinceLastPetitionCompWindUp": "-99999",'+
        '        "NumDismissedPetition": "0",'+
        '        "TimeSinceLastDismissedPetition": "-99999",'+
        '        "NumApptAdministrator": "0",'+
        '        "TimeSinceLastApptAdministrator": "-99999",'+
        '        "NumDischargeAdministrator": "0",'+
        '        "TimeSinceLastDischargeAdministrator": "-99999",'+
        '        "NumApprovalVolArrangement": "0",'+
        '        "TimeSinceLastApprovalVolArrangement": "-99999",'+
        '        "NumRevocationVoluntaryArrangement": "0",'+
        '        "TimeSinceLastRevocationVolArrangement": "-99999",'+
        '        "NumSuspensionVolArrangement": "0",'+
        '        "TimeSinceLastSuspensionVolArrangement": "-99999",'+
        '        "NumCompletionsVolArrangement": "0",'+
        '        "TimeSinceLastCompletionVolArrangement": "-99999",'+
        '        "NumIntentionToDissolve": "0",'+
        '        "TimeSinceLastIntentionToDissolve": "-99999",'+
        '        "NumCompanyDissolved": "0",'+
        '        "TimeSinceLastCompanyDissolved": "-99999",'+
        '        "NumCompanyReinstated": "0",'+
        '        "TimeSinceLastCompanyReinstated": "-99999",'+
        '        "TimeSinceLastDerogatoryItem": "-99999",'+
        '        "TimeSinceLastWindUpHearing": "-99999",'+
        '        "AgeMostRecentCCJ": "-999",'+
        '        "ValueMostRecentCCJ": "0",'+
        '        "HighestValueCCJ": "0",'+
        '        "NumberCCJs0To72": "0",'+
        '        "ValueCCJs0To72": "0",'+
        '        "NumberCCJsLast12Months": "0",'+
        '        "ValueCCJsLast12Months": "0",'+
        '        "NumberCCJs13To24": "0",'+
        '        "ValueCCJs13To24": "0",'+
        '        "NumberCCJs25To36": "0",'+
        '        "ValueCCJs25To36": "0",'+
        '        "NumberCCJs37To48": "0",'+
        '        "ValueCCJs37To48": "0",'+
        '        "NumberCCJs49To60": "0",'+
        '        "ValueCCJs49To60": "0",'+
        '        "NumberCCJs61To72": "0",'+
        '        "ValueCCJs61To72": "0",'+
        '        "TotValCCJsPropShareFunds": "0",'+
        '        "ValCCJsLast24MonthsPropShareFunds": "0",'+
        '        "NumUnsatPartSatMortgages": "0",'+
        '        "NumSatMortgages": "0",'+
        '        "NumUnsatMortgages": "0",'+
        '        "CurrAccsAvailabe": "Y",'+
        '        "PrevAccsAvailabile": "Y",'+
        '        "OutOfDateFlag": "N",'+
        '        "DormancyFlag": "N",'+
        '        "PrevAccountsDormancyFlag": "N",'+
        '        "AuditType": "N",'+
        '        "AuditorsQualifications": "X",'+
        '        "LatenessAccounts": "-010",'+
        '        "NumberDaysToFile": "-999",'+
        '        "NumYearsAccosAvailable": "0",'+
        '        "TimeSinceLastAccsSubmitted": "-99999",'+
        '        "TimeSinceLastRetsSubmitted": "-99999",'+
        '        "AccountingPeriod": "-999",'+
        '        "NetWorth": "-999999999999999",'+
        '        "IntangibleAssets": "-999999999999999",'+
        '        "FixedAssets": "-999999999999999",'+
        '        "TotalCurrentAssets": "-999999999999999",'+
        '        "ShortLoans": "-999999999999999",'+
        '        "TotalCurrentLiabilities": "-999999999999999",'+
        '        "WorkingCapital": "-999999999999999",'+
        '        "CapitalEmployed": "-999999999999999",'+
        '        "TotalLongTermLiabilities": "-999999999999999",'+
        '        "IssuedCapital": "-999999999999999",'+
        '        "RevaluationReserves": "-999999999999999",'+
        '        "RetainedEarnings": "-999999999999999",'+
        '        "ShareholdersFunds": "-999999999999999",'+
        '        "TotalAssets": "-999999999999999",'+
        '        "GrossAssets": "-999999999999999",'+
        '        "TotalTurnover": "-999999999999999",'+
        '        "PreTaxProfitLoss": "-999999999999999",'+
        '        "Dividends": "-999999999999999",'+
        '        "RetainedProfit": "-999999999999999",'+
        '        "CreditPeriod": "-9999999",'+
        '        "LiquidityStandardRatio": "-999999.9",'+
        '        "Currentratio": "-999999.9",'+
        '        "AcidTest": "-999999.9",'+
        '        "ReturnOnCapital": "-999999.9",'+
        '        "ReturnOnAssets": "-999999.9",'+
        '        "PreTaxProfitMargin": "-999999.9",'+
        '        "BorrowingRatio": "-999999.9",'+
        '        "EquityGearing": "-999999.9",'+
        '        "DebtGearing": "-999999.9",'+
        '        "TurnoverPerEmp": "-999999.9",'+
        '        "TotAssetsEmp": "-999999.9",'+
        '        "TotalFixedAssetsPercentTotalAssets": "-99999999.9",'+
        '        "CurrentLiabilitiesPercentTotalAssets": "-99999999.9",'+
        '        "CapitalEmployedPercentTotalAssets": "-99999999.9",'+
        '        "StocksWorkInProgressPercentCurrentAssets": "-999999.9",'+
        '        "WorkingCapitalPercentCurrentPlusFixedAssets": "-999999.9",'+
        '        "BaseTrendShareholdersFunds": "9",'+
        '        "PercentChangeShareholdersFunds": "-999999.9",'+
        '        "PercentChangeCapitalEmployed": "-999999.9",'+
        '        "PercentChangeTotalAssets": "-999999.9",'+
        '        "PercentChangeCurrentRatio": "-999999.9",'+
        '        "PercentChangePreTaxProfitLoss": "-999999.9",'+
        '        "NumYearsPreTaxProfitLessThan0Last4Years": "9",'+
        '        "ReturnOnAssetsQuartile": "9",'+
        '        "PreTaxMarginQuartile": "9",'+
        '        "LimitedCompanyDelphiCAIS": {'+
        '            "NumDefaults": "-999",'+
        '            "ValueDefaults": "-999999999",'+
        '            "AgeMostRecent": "-999",'+
        '            "NumSettled": "-999",'+
        '            "NumOwnAccounts": "000000",'+
        '            "TotalBalanceOwnAccounts": "-0999999999",'+
        '            "AvgBalanceOwnAccounts": "-0999999999",'+
        '            "WorstStatusOld": "X",'+
        '            "WorstStatusActive": "X",'+
        '            "NumActiveAccounts": "-999",'+
        '            "BalanceActiveAccounts": "-999999999"'+
        '        },'+
        '        "LimitedCompanyDelphiRisk": ['+
        '            {'+
        '                "CommercialDelphiScore": "011",'+
        '                "CreditRating": "000000000000000",'+
        '                "CreditLimit": "000000000000000",'+
        '                "CreditCode": "G0",'+
        '                "CommercialDelphiOverRideFlag": "N",'+
        '                "CreditRatingOverRideflag": "N",'+
        '                "CredLimitOverRideFlag": "N",'+
        '                "CreditCodeOverRideFlag": "N"'+
        '            }'+
        '        ],'+
        '        "LimitedCompanyDelphiPayment": ['+
        '            {'+
        '                "AverageCurrentDaysBeyondTerm": "-9999999",'+
        '                "AverageNumberExperiencesLast3month": "-9999999",'+
        '                "NumberOfAccountsCollectionLast12Months": "-99999",'+
        '                "NumberUnpaidAccountsLastMonth": "-99999",'+
        '                "PercentChangeLast3Months": "-9999999"'+
        '            }'+
        '        ],'+
        '        "ReportUpdateFlag": "0"'+
        '    },'+
        '    "Alerts": ['+
        '        {'+
        '            "NotesCount": "1",'+
        '            "NotesLength": "131",'+
        '            "Notes": {'+
        '                "AlertCode": "A09",'+
        '                "AlertHeader": "CIFAS Warning",'+
        '                "AlertNote": "Attention is drawn to the CIFAS data held at the Registered Office address. This should be investigated further."'+
        '            }'+
        '        }'+
        '    ],'+
        '    "NoticeOfCorrection": {'+
        '        "NumCorrections": "0"'+
        '    },'+
        '    "DirectorExpandedSummary": ['+
        '        {'+
        '            "NumDirectorsFound": "1",'+
        '            "NumDirectorsNotFound": "0",'+
        '            "Nolag": "N",'+
        '            "NumDisqualifications": "0",'+
        '            "NumConvictions": "0",'+
        '            "NumCIFAS": "6",'+
        '            "NumDirectorships": "1",'+
        '            "NumCurrrentDirships": "1",'+
        '            "NumCurrentDissolvedDirships": "0",'+
        '            "NumPreviousDirectorships": "0",'+
        '            "NumDirectorshipsFailed": "0",'+
        '            "NumDirectorshipsNotFailed": "1",'+
        '            "NumDirectorshipsCompulsoryLiquidator": "0",'+
        '            "NumDirectorshipsCreditorLiquidator": "0",'+
        '            "NumDirectorshipsMemberLiqidator": "0",'+
        '            "NumDirectorshipsUnknownLiquidator": "0",'+
        '            "NumDirectorshipsWindUpOrder": "0",'+
        '            "NumDirectorshipsAdministratorAppointed": "0",'+
        '            "NumDirectorshipsAdministratorDischarge": "0",'+
        '            "NumDirectorshipsAppointmentAdministrativeReceiver": "0",'+
        '            "NumDirectorshipsReceiverAppointed": "0",'+
        '            "NumDirectorshipsAdministrativeReceiverCessation": "0",'+
        '            "NumDirectorshipsReceiverCessation": "0",'+
        '            "NumDirectorshipsApprovalVoluntaryArrangements": "0",'+
        '            "NumDirectorshipsCompletionVoluntaryArrangements": "0",'+
        '            "NumDirectorshipsRevocationVoluntaryArrangements": "0",'+
        '            "NumDirectorshipsSuspensionVoluntaryArrangements": "0",'+
        '            "NumDirectorshipsReinstated": "0",'+
        '            "NumDirectorshipsDissolved": "0",'+
        '            "DirectorNumbers": {'+
        '            "DirectorNumber":['+   
        '                            "D01366864",'+
        '                            "D08816337",'+
        '                            "D07148910"'+    
        '                             ]'+ 
        '            }'+
        '        }'+
        '    ],'+
        '"PaymentPerformance":{'+
			            '"PaymentFull":{'+
					         '"AvgDBT3Mnths":"0",'+
                             '"AvgDBT6Mnths":"0",'+
                             '"AvgDBT12Mnths":"0",'+   
                             '"NumberDBT1K":"0",'+  
                             '"NumberDBT10K":"0",'+ 
                             '"NumberCashFirst":"0",'+  
                             '"NumberCollection":"0",'+ 
                             '"ValCollection":"0",'+   
                             '"UnpaidAccountsDetails":[{}],'+
                             '"IndAvgDBT3Mnths":"22",'+  
                             '"IndAvgDBT6Mnths":"23",'+  
                             '"IndAvgDBT12Mnths":"25",'+
                             '"IndNumberDBT1K":"19",'+   
                             '"IndNumberDBT10K":"38",'+  
                             '" IndNumberDBT100K":"30",'+ 
                             '" IndNumberDBT100KPlus":"16",'+
                             '"PaymentPattern":"C",'+   
                             '"IndPaymentPattern":"F",'+    
                             '"PaymentToTerms":"W",'+   
                             '"FastestPayment":"0",'+   
                             '"FastestMonth":"2018-02",'+
                             '"SlowestPayment":"0",'+   
                             '"SlowestMonth":"2018-10",'+ 
                             '"NumCommonTerms":"1",'+   
                             '"CompanyNumMnths":"13",'+  
                             '"IndustryNumMnths":"12",'+ 
                             '"CompanyDBTMonthly":[{}],'+
                             '"IndDBTMonthly":[{}],'+
                             '"CommonTerms":[{}],'+
                             '"IndustrySICDesc":"Business Services"'+
                      '}'+
    '},'+
            '"LtdCompanyCAIS":{'+
	                   '"LtdCompanyCAISSummary":{'+
					            ' "AgeSinceLast89":"0",'+
                                '  "MonthCount":"12",'+
                                '  "MonthlyData":[{'+
							                '"MonthYyyy":"2019",'+
                                            '"MonthMm":"04",'+
                                            '"Status0":"0",'+
                                            '"Status1":"0",'+  
                                            '"Status2":"0",'+   
                                            '"Status3":"0",'+   
                                            '"Status4":"0",'+   
                                            '"Status5":"0",'+   
                                            '"Status6":"0",'+   
                                            '"StatusU":"0",'+   
                                            '"Status89":"0",'+
                                            '"CurrentBalance":"0",'+    
                                            '"NumActiveAccounts":"0",'+     
                                            '"DefaultBalance":"0"'+
                                            '}]'+
                                            '},'+	
                         '"LtdCompanyCAISDetails":[{'+
						                      '"AccountState":"D",'+
                                              '"CompanyType":"31",'+
                                              '"AccountType":"27",'+
                                              '"DefaultDate":"2014-06-30",'+
                                              '"DefaultBalance":"0000536707",'+
                                              '"CurrentBalance":"0000462619",'+
                                              '"Status1To2":"0",'+
                                              '"Status3To9":"0",'+
                                              '"CaisLastUpdate":"2014-07-01",'+
                                              '"AccountStatus12":"800",'+
                                              '"MonthsData":"8"'+
                                              '}]'+						
	                                      '},'+
            '"Mortgages":{'+
				           '"NumMortgages":"1",'+       
						   '"NumSatMortgages":"1",'+ 
                           '"NumUnsatMortgages":"0",'+   
                           '"DateMostRecentMort":"1990-03-23",'+ 
                           '"DateMostRecentSat":"2013-10-31",'+   
                           '"MortgageDetail":[{'+
                                   '"ChargeNumber":"1",'+
                                   '"FormType":"33",'+
                                   '"RegistrationDate":"1990-04-02",'+
                                   '"CreationDate":"1990-03-23",'+
                                   '"Currencyiso":"£",'+
                                   '"TotalDebenture":"0",'+   
                                   '"AmountLatestIssue":"0",'+   
                                   '"DateFullySatisfied":"2013-10-31",'+
                                   '"FullySatisfiedIndicator":"F",'+ 
                                   '"NumberPartialSatisfactionDates":"0",'+ 
                                   '"NumberPartialSatisfactionDataItems":"0",'+
                                   '"NumberTrustees":"0",'+   
                                   '"NumberLenders":"1",'+    
                                   '"NumberCommissionElements":"0",'+
                                   '"NumberExecutors":"0",'+ 
                                   '"NumberExecutionDates":"0",'+
                                   '"NumberReceiverAppointmentDates":"0",'+   
                                   '"NumberReceiverCessationDates":"0",'+
                                   '"ChargeType":"BOND & FLOATING CHARGE",'+
                                   '"AmountSecured":"ALL SUMS DUE, OR TO BECOME DUE",'+
                                   '"PropertyDetails":"UNDERTAKING AND ALL PROPERTY AND ASSETS PRESENT AND FUTURE OF THE COMPANY INCLUDING UNCALLED CAPITAL",'+
                                   '"LenderDetails":[{'+
								           '"LenderName":"sahgar"'+
										   '}]'+
								    '}]'+
								'}'+
        '}';
        response.setBody(json);
        return response;  
        
    }
}