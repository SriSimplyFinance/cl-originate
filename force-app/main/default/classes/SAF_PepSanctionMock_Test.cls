/**
    @ name                      : SAF_PepSanctionMock
    @ author                    : Happiest Minds/Phalguni
    @ description               : test class for pep and sanction
    @ created date              : 12/06/2019    
    @ Modified by / Date        : 16/06/2019 
*/
public class SAF_PepSanctionMock_Test{
    
      public class  PepSanctioncompany2_Test implements HttpCalloutMock 
    {    
         public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
           String json=     '{'+
            '    "criteria": {'+
            '        "duedilCompany": {'+
            '            "countryCode": "gb",'+
            '            "companyId": "07917648"'+
            '        }'+
            '    },'+
            '    "totalMatches": 0,'+
            '    "possibleMatches": []'+
            '}';
  
            response.setBody(json);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        //fromJSON obj = parse(json);
       // System.assert(obj != null);
    }
   }
    public class  PepSanctioncompany_Test implements HttpCalloutMock 
    {    
         public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
        String json=        '{'+
        '    "criteria": {'+
        '        "duedilCompany": {'+
        '            "countryCode": "gb",'+
        '            "companyId": "10588244"'+
        '        }'+
        '    },'+
        '    "totalMatches": 5,'+
        '    "possibleMatches": ['+
        '        {'+
        '            "matchScore": 90,'+
        '            "type": "business",'+
        '            "business": {'+
        '                "lookupId": "DD-647b7f07005b",'+
        '                "name": "Saxo Bank Finance & Co-Operation PLC",'+
        '                "website": "www.saxosecured.com",'+
        '                "telephone": null,'+
        '                "fax": null,'+
        '                "addresses": ['+
        '                    {'+
        '                        "fullAddress": "530-532 Elder Gate, Elder House, Milton Keynes, United Kingdom",'+
        '                        "countryCode": "GB",'+
        '                        "sourceAddress": {'+
        '                            "address1": "530-532 Elder Gate",'+
        '                            "address2": "Elder House",'+
        '                            "address3": "",'+
        '                            "address4": "",'+
        '                            "city": "Milton Keynes",'+
        '                            "county": "",'+
        '                            "postcode": "",'+
        '                            "country": "United Kingdom"'+
        '                        }'+
        '                    }'+
        '                ],'+
        '                "globalDatasets": {'+
        '                    "peps": false,'+
        '                    "sanctionsCurrent": false,'+
        '                    "sanctionsPrevious": false,'+
        '                    "lawEnforcement": false,'+
        '                    "financialRegulatorPenalties": true,'+
        '                    "disqualifiedDirectors": false,'+
        '                    "insolvencies": false,'+
        '                    "adverseMedia": false'+
        '                },'+
        '                "documents": ['+
        '                    {'+
        '                        "documentId": "383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d3816644541614501726861024a6f4808777d085e467468603f565f",'+
        '                        "originalUrl": "http://www.bankrupt.com/TCR_Public/050527.mbx",'+
        '                        "dateCollected": "2005-11-29",'+
        '                        "documentUrl": "https://duedil.io/documents/peps-and-sanctions/383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d3816644541614501726861024a6f4808777d085e467468603f565f",'+
        '                        "categories": ['+
        '                            {'+
        '                                "name": "Insolvent"'+
        '                            },'+
        '                            {'+
        '                                "name": "Corporate Business"'+
        '                            }'+
        '                        ]'+
        '                    }'+
        '                ],'+
        '                "sanctions": ['+
        '                    {'+
        '                        "type": {'+
        '                            "description": "HMT"'+
        '                        },'+
        '                        "isCurrent": true'+
        '                    },'+
        '                    {'+
        '                        "type": {'+
        '                            "description": "EU"'+
        '                        },'+
        '                        "isCurrent": true'+
        '                    }'+
        '                ],'+
        '                "notes": ['+
        '                    {'+
        '                        "text": "Listed by Artists Against 419 as a fake bank",'+
        '                        "source": "Artists Against 419"'+
        '                    }'+
        '                ],'+
        '                "linkedBusinesses": ['+
        '                    {'+
        '                        "lookupId": "DD-647b7f070058",'+
        '                        "name": "Saxo Financial Securities",'+
        '                        "association": ""'+
        '                    }'+
        '                ],'+
        '                "linkedIndividuals": [],'+
        '                "relatedNames": ['+
        '                    {'+
        '                        "name": "Saxo Bank Finance and Co-Operation PLC"'+
        '                    }'+
        '                ]'+
        '            }'+
        '        },'+
        '        {'+
        '            "matchScore": 65,'+
        '            "type": "business",'+
        '            "business": {'+
        '                "lookupId": "DD-627b7d0b0859",'+
        '                "name": "Broad Finance Corporation ",'+
        '                "website": "http://www.b-fc.com/ ",'+
        '                "telephone": null,'+
        '                "fax": null,'+
        '                "addresses": [],'+
        '                "globalDatasets": {'+
        '                    "peps": false,'+
        '                    "sanctionsCurrent": false,'+
        '                    "sanctionsPrevious": false,'+
        '                    "lawEnforcement": false,'+
        '                    "financialRegulatorPenalties": false,'+
        '                    "disqualifiedDirectors": false,'+
        '                    "insolvencies": false,'+
        '                    "adverseMedia": true'+
        '                },'+
        '                "documents": [],'+
        '                "sanctions": [],'+
        '                "notes": ['+
        '                    {'+
        '                        "text": "Listed by Artists Against 419 as a fake bank",'+
        '                        "source": "Artists Against 419"'+
        '                    }'+
        '                ],'+
        '                "linkedBusinesses": [],'+
        '                "linkedIndividuals": [],'+
        '                "relatedNames": []'+
        '            }'+
        '        },'+
        '        {'+
        '            "matchScore": 65,'+
        '            "type": "business",'+
        '            "business": {'+
        '                "lookupId": "DD-66787b000e5d",'+
        '                "name": "Kaiser Finance Corporation.",'+
        '                "website": null,'+
        '                "telephone": null,'+
        '                "fax": null,'+
        '                "addresses": [],'+
        '                "globalDatasets": {'+
        '                    "peps": false,'+
        '                    "sanctionsCurrent": false,'+
        '                    "sanctionsPrevious": false,'+
        '                    "lawEnforcement": false,'+
        '                    "financialRegulatorPenalties": false,'+
        '                    "disqualifiedDirectors": false,'+
        '                    "insolvencies": true,'+
        '                    "adverseMedia": false'+
        '                },'+
        '                "documents": ['+
        '                    {'+
        '                        "documentId": "383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d3816644541614501726861024a6f4808777d085e467468603f565f",'+
        '                        "originalUrl": "http://www.bankrupt.com/TCR_Public/050527.mbx",'+
        '                        "dateCollected": "2005-11-29",'+
        '                        "documentUrl": "https://duedil.io/documents/peps-and-sanctions/383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d3816644541614501726861024a6f4808777d085e467468603f565f",'+
        '                        "categories": ['+
        '                            {'+
        '                                "name": "Insolvent"'+
        '                            },'+
        '                            {'+
        '                                "name": "Corporate Business"'+
        '                            }'+
        '                        ]'+
        '                    }'+
        '                ],'+
        '                "sanctions": [],'+
        '                "notes": [],'+
        '                "linkedBusinesses": [],'+
        '                "linkedIndividuals": [],'+
        '                "relatedNames": []'+
        '            }'+
        '        },'+
        '        {'+
        '            "matchScore": 65,'+
        '            "type": "business",'+
        '            "business": {'+
        '                "lookupId": "DD-627b7a0b0f59",'+
        '                "name": "Trust Finance Corporation ",'+
        '                "website": "http://www.trustfinancecorporation.com ",'+
        '                "telephone": null,'+
        '                "fax": null,'+
        '                "addresses": [],'+
        '                "globalDatasets": {'+
        '                    "peps": false,'+
        '                    "sanctionsCurrent": false,'+
        '                    "sanctionsPrevious": false,'+
        '                    "lawEnforcement": false,'+
        '                    "financialRegulatorPenalties": false,'+
        '                    "disqualifiedDirectors": false,'+
        '                    "insolvencies": false,'+
        '                    "adverseMedia": true'+
        '                },'+
        '                "documents": [],'+
        '                "sanctions": [],'+
        '                "notes": ['+
        '                    {'+
        '                        "text": "Listed by Artists Against 419 as a fake bank",'+
        '                        "source": "Artists Against 419"'+
        '                    }'+
        '                ],'+
        '                "linkedBusinesses": [],'+
        '                "linkedIndividuals": [],'+
        '                "relatedNames": []'+
        '            }'+
        '        },'+
        '        {'+
        '            "matchScore": 55,'+
        '            "type": "business",'+
        '            "business": {'+
        '                "lookupId": "DD-627b7a060b5e",'+
        '                "name": "Union Trust Banking & Finance Co",'+
        '                "website": "http://www.uniontrustbanking.com ",'+
        '                "telephone": null,'+
        '                "fax": null,'+
        '                "addresses": [],'+
        '                "globalDatasets": {'+
        '                    "peps": false,'+
        '                    "sanctionsCurrent": false,'+
        '                    "sanctionsPrevious": false,'+
        '                    "lawEnforcement": false,'+
        '                    "financialRegulatorPenalties": false,'+
        '                    "disqualifiedDirectors": false,'+
        '                    "insolvencies": false,'+
        '                    "adverseMedia": true'+
        '                },'+
        '                "documents": [],'+
        '                "sanctions": [],'+
        '                "notes": ['+
        '                    {'+
        '                        "text": "Listed by Artists Against 419 as a fake bank",'+
        '                        "source": "Artists Against 419"'+
        '                    }'+
        '                ],'+
        '                "linkedBusinesses": [],'+
        '                "linkedIndividuals": [],'+
        '                "relatedNames": ['+
        '                    {'+
        '                        "name": "Foreign Payment Commission"'+
        '                    },'+
        '                    {'+
        '                        "name": "UniTrust Finance Corporation "'+
        '                    }'+
        '                ]'+
        '            }'+
        '        }'+
        '    ]'+
        '}';
            response.setBody(json);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        //fromJSON obj = parse(json);
       // System.assert(obj != null);
    }
   }
   public class  PepSanctioncontact_Test implements HttpCalloutMock 
    {      
      public HTTPResponse respond(HTTPRequest request) 
       {
          HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
        String json=        '{'+
        '    "criteria": {'+
        '        "anyIndividual": {'+
        '            "postcode": "SE1 0LN",'+
        '            "middleName": "",'+
        '            "lastName": "Dhenin",'+
        '            "firstName": "Brian",'+
        '            "dateOfBirth": {'+
        '                "year": 1956'+
        '            },'+
        '            "countryCode": "gb",'+
        '            "city": "London",'+
        '            "address": "The Embassy Tea House 195-205 Union Street"'+
        '        }'+
        '    },'+
        '    "totalMatches": 1,'+
        '    "possibleMatches": ['+
        '        {'+
        '            "matchScore": 90,'+
        '            "type": "individual",'+
        '            "individual": {'+
        '                "lookupId": "DD-677876040c5865",'+
        '                "honorific": "None",'+
        '                "alternativeHonorific": "",'+
        '                "firstName": "Dheni",'+
        '                "middleName": "Faizal Makhfud",'+
        '                "lastName": "Rival",'+
        '                "nationalities": ['+
        '                    {'+
        '                        "demonym": "Indonesian"'+
        '                    }'+
        '                ],'+
        '                "gender": "Male",'+
        '                "imageUrl": null,'+
        '                "pepLevel": null,'+
        '                "dateOfBirth": {'+
        '                    "year": 1981,'+
        '                    "month": 3,'+
        '                    "day": 2'+
        '                },'+
        '                "isDeceased": false,'+
        '                "dateOfDeath": null,'+
        '                "aliases": ['+
        '                    {'+
        '                        "honorific": null,'+
        '                        "alternativeHonorific": "",'+
        '                        "firstName": "Dheni Faizal",'+
        '                        "middleName": null,'+
        '                        "lastName": "Makhfud Rival"'+
        '                    },'+
        '                    {'+
        '                        "honorific": null,'+
        '                        "alternativeHonorific": "",'+
        '                        "firstName": null,'+
        '                        "middleName": null,'+
        '                        "lastName": "Dheni"'+
        '                    }'+
        '                ],'+
        '                "telephone": "",'+
        '                "fax": "",'+
        '                "mobile": "",'+
        '                "email": "",'+
        '                "addresses": ['+
        '                    {'+
        '                        "fullAddress": "Dusun Gelanggang RT 001001, Kelurahan Kadirejo, Kecamatan Pabelan, Semarang, Central Java, Indonesia",'+
        '                        "countryCode": "ID",'+
        '                        "sourceAddress": {'+
        '                            "address1": "Dusun Gelanggang RT 001001",'+
        '                            "address2": "Kelurahan Kadirejo",'+
        '                            "address3": "Kecamatan Pabelan",'+
        '                            "address4": "",'+
        '                            "city": "Semarang",'+
        '                            "county": "Central Java",'+
        '                            "postcode": "",'+
        '                            "country": "Indonesia"'+
        '                        }'+
        '                    },'+
        '                    {'+
        '                        "fullAddress": "Perum Pesona Anggrek Harapan, Blok E 11RT 07021, Kelurahan Harapan Jaya, Bekasi Utara, West Java, Indonesia",'+
        '                        "countryCode": "ID",'+
        '                        "sourceAddress": {'+
        '                            "address1": "Perum Pesona Anggrek Harapan",'+
        '                            "address2": "Blok E 11RT 07021",'+
        '                            "address3": "Kelurahan Harapan Jaya",'+
        '                            "address4": "",'+
        '                            "city": "Bekasi Utara",'+
        '                            "county": "West Java",'+
        '                            "postcode": "",'+
        '                            "country": "Indonesia"'+
        '                        }'+
        '                    },'+
        '                    {'+
        '                        "fullAddress": "Semarang, Central Java, Indonesia",'+
        '                        "countryCode": "ID",'+
        '                        "sourceAddress": {'+
        '                            "address1": "",'+
        '                            "address2": "",'+
        '                            "address3": "",'+
        '                            "address4": "",'+
        '                            "city": "Semarang",'+
        '                            "county": "Central Java",'+
        '                            "postcode": "",'+
        '                            "country": "Indonesia"'+
        '                        }'+
        '                    }'+
        '                ],'+
        '                "globalDatasets": {'+
        '                    "peps": false,'+
        '                    "sanctionsCurrent": false,'+
        '                    "sanctionsPrevious": false,'+
        '                    "lawEnforcement": true,'+
        '                    "financialRegulatorPenalties": false,'+
        '                    "disqualifiedDirectors": false,'+
        '                    "insolvencies": false,'+
        '                    "adverseMedia": false'+
        '                },'+
        '                "documents": ['+
        '                    {'+
        '                        "documentId": "383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d38163507186344087661600a4a1100562c387f2713037e3e2b54",'+
        '                        "originalUrl": "kejati-dki.go.id/index.php/perkaraPidsus/Detil/id/11763",'+
        '                        "dateCollected": "2019-05-02",'+
        '                        "documentUrl": "https://duedil.io/documents/peps-and-sanctions/383a3b424a507c67101d284c26105f3040152e3625570933115f2020520f5a223f2360510f033e29041d38163507186344087661600a4a1100562c387f2713037e3e2b54",'+
        '                        "categories": ['+
        '                            {'+
        '                                "name": "Law Enforcement"'+
        '                            }'+
        '                        ]'+
        '                    }'+
        '                ],'+
        '                "sanctions": ['+
        '                    {'+
        '                        "type": {'+
        '                            "description": "HMT"'+
        '                        },'+
        '                        "isCurrent": true'+
        '                    },'+
        '                    {'+
        '                        "type": {'+
        '                            "description": "EU"'+
        '                        },'+
        '                        "isCurrent": true'+
        '                    }'+
        '                ],'+
        '                "notes": ['+
        '                    {'+
        '                        "text": "This Individual Was Prosecuted by the North Jakarta Public Prosecution Office related to Custom Offences.  His case had been tried by North Jakarta Court of First Instance.",'+
        '                        "source": null'+
        '                    },'+
        '                    {'+
        '                        "text": "Regulatory Enforcement Lists",'+
        '                        "source": null'+
        '                    }'+
        '                ],'+
        '               "linkedBusinesses": ['+
        '                    {'+
        '                        "lookupId": "DD-657a7e030e5e",'+
        '                        "name": "Libyan Investment Authority",'+
        '                        "association": "Sabtina Ltd is an UK-incorporated subsidiary of the Libyan Investment Authority"'+
        '                    }'+
        '                ],'+
        '                "linkedIndividuals": ['+
        '                    {'+
        '                        "lookupId": "DD-789",'+
        '                        "name": "Alistair Benjamin",'+
        '                        "position": "Trustee"'+
        '                    }'+
        '                ],'+
        '                "politicalPositions": ['+
        '                    {'+
        '                        "description": "Member of the Republican Party",'+
        '                        "startDate": null,'+
        '                        "endDate": null,'+
        '                        "country": {'+
        '                            "name": "United States of America"'+
        '                        }'+
        '                    },'+
        '                    {'+
        '                        "description": "Member of the Senate (Upper Chamber of Parliament) of the State of Oklahoma for District 36",'+
        '                        "startDate": "2006",'+
        '                        "endDate": null,'+
        '                        "country": {'+
        '                            "name": "United States of America"'+
        '                        }'+
        '                    }'+
        '                ]'+
        '            }'+
        '        }'+
        '    ]'+
        '}';
         response.setBody(json);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
    }
    }
 }