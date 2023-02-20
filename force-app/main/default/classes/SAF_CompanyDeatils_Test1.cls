@isTest
public class SAF_CompanyDeatils_Test1
{   
    public class SAFDuedilMock_RelatedCompanies_CurTest implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "10588244",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 10,'
                                +'"total": 8'
                                +'},'
                                +'"relatedCompanies": ['
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "OC318397",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +'"name": "Cabot Square Capital LLP",'
                                +'"confidence": "low",'
                                +'"nameSimilarityScore": 0.3174603174603174426948726249975152313709259033203125,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 2'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "OC319988",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +'"name": "CS Capital Partners III (FP) LLP",'
                                +'"confidence": "low",'
                                +'"nameSimilarityScore": 0.309859154929577496062620411976240575313568115234375,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 2'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "OC369417",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +'"name": "CS Capital Partners Iv (FP) LLP",'
                                +'"confidence": "low",'
                                +'"nameSimilarityScore": 0.3142857142857142793701541449991054832935333251953125,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 2'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "OC398340",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +'"name": "CS Capital Partners V (FP) LLP",'
                                +'"confidence": "low",'
                                +'"nameSimilarityScore": 0.31884057971014490018291098749614320695400238037109375,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 2'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "00523804",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +'"name": "Kingston Asset Finance Limited",'
                                +'"confidence": "unlikely",'
                                +'"nameSimilarityScore": 0.6666666666666667406815349750104360282421112060546875,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 1'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "01565491",'
                                +'"officialStatus": "Dissolved",'
                                +'"simplifiedStatus": "Closed",'
                                +'"name": "Close Asset Finance (T&E) Limited",'
                                +'"confidence": "unlikely",'
                                +'"nameSimilarityScore": 0.6944444444444444197728216749965213239192962646484375,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 1'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "02053453",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +'"name": "Close Asset Finance Limited",'
                                +'"confidence": "unlikely",'
                                +'"nameSimilarityScore": 0.6969696969696970167973404386430047452449798583984375,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 1'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": "04953180",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +'"name": "Forest Asset Finance Limited",'
                                +'"confidence": "unlikely",'
                                +'"nameSimilarityScore": 0.6865671641791044610414473936543799936771392822265625,'
                                +'"mutualAddresses": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualMajorShareholders": {'
                                +'"count": 0'
                                +'},'
                                +'"mutualOfficers": {'
                                +'"count": 1'
                                +'},'
                                +'"mutualInvestments": {'
                                +'"count": 0'
                                +'}'
                                +'}'
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
    // start :Written :subrat  14 Jun
     public class SAFDuedilMock_GroupCompanies_Test1 implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "03977902",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 10,'
                                +'"total": 3'
                                +'},'
                                +'"groupParents": ['
                            
                                +'],'
                                +'"totalCompanyShares": 36031336,'
                                +'"shareholders": ['
                                +'{'
                                +'"sourceName": "Peter Damian Kimmelman",'
                                +'"totalShareholding": 9888495,'
                                +'"totalShareholdingPercentage": 27.444153056106497,'
                                +'"shareholdings": [],'
                                +'"exactMatches": ['
                                +'{' 
                                +'"type": "company",'
                                +'"person": null,'
                                +'"company": {'
                                +'"countryCode": "GB",'
                                +'"companyId": "00014259",'
                                +'"name": "HSBC Bank PLC",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +        '    "registeredAddress": {'+
        '        "fullAddress": "Swiss House Beckingham Street Tolleshunt Major Maldon Essex CM9 8LZ",'+
        '        "structuredAddress": {'+
        '            "premises": "Swiss House Beckingham Street",'+
        '            "thoroughfare": "Tolleshunt Major",'+
        '            "dependentLocality": null,'+
        '            "postTown": "Maldon",'+
        '            "county": "Essex",'+
        '            "postcode": "CM9 8LZ",'+
        '            "countryCode": "GB"'+
        '        },'+
        '        "geolocation": {'+
        '            "latitude": 51.7657,'+
        '            "longitude": 0.748981'+
        '        }'+
        '    }'+
                                +'        }'
                                +'    }'
                                +'],'
                                +'"possibleMatches": [ ],'
                                +'"notMatched": null'
                                +'},'  
                               + '        {'+
        '            "sourceName": "Daniel Phillips",'+
        '            "totalShareholding": 36,'+
        '            "totalShareholdingPercentage": 34.95145631067961,'+
        '            "shareholdings": ['+
        '                {'+
        '                    "class": "Ordinary",'+
        '                    "numberOfShares": 35,'+
        '                    "percentageOfShares": 35,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "class": "Ordinary B",'+
        '                    "numberOfShares": 1,'+
        '                    "percentageOfShares": 100,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                }'+
        '            ],'+
        '            "exactMatches": ['+
        '                {'+
        '                    "type": "person",'+
        '                    "person": {'+
        '                        "honorific": "Mr",'+
        '                        "firstName": "Daniel",'+
        '                        "middleName": null,'+
        '                        "lastName": "Phillips",'+
        '                        "nationalities": ['+
        '                            {'+
        '                                "demonym": "British",'+
        '                                "countryCode": "GB"'+
        '                            }'+
        '                        ],'+
        '                        "dateOfBirth": {'+
        '                            "year": 1990,'+
        '                            "month": 12'+
        '                        },'+
        '                        "officerId": "925035810"'+
        '                    },'+
        '                    "company": null'+
        '                }'+
        '            ],'+
        '            "possibleMatches": [],'+
        '            "notMatched": null'+
        '        },'+
        '        {'+
        '            "sourceName": "Paul Armstrong",'+
        '            "totalShareholding": 31,'+
        '            "totalShareholdingPercentage": 30.097087378640776,'+
        '            "shareholdings": ['+
        '                {'+
        '                    "class": "Ordinary",'+
        '                    "numberOfShares": 30,'+
        '                    "percentageOfShares": 30,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "class": "Ordinary C",'+
        '                    "numberOfShares": 1,'+
        '                    "percentageOfShares": 100,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                }'+
        '            ],'+
        '            "exactMatches": ['+
        '                {'+
        '                    "type": "person",'+
        '                    "person": {'+
        '                        "honorific": "Mr",'+
        '                        "firstName": "Paul",'+
        '                        "middleName": null,'+
        '                        "lastName": "Armstrong",'+
        '                        "nationalities": ['+
        '                            {'+
        '                                "demonym": "British",'+
        '                                "countryCode": "GB"'+
        '                            }'+
        '                        ],'+
        '                        "dateOfBirth": {'+
        '                            "year": 1967,'+
        '                            "month": 5'+
        '                        },'+
        '                        "officerId": "925035807"'+
        '                    },'+
        '                    "company": null'+
        '                }'+
        '            ],'+
        '            "possibleMatches": [],'+
        '            "notMatched": null'+
        '        }'+                            
                                +'],'
                                 +'"filters": null,'
                                +'"officers": ['
                                +'{'
                                +'"officerId": "924703112",'
                                +'"type": "person",'
                                +'"person": {'
                                +'"honorific": "Mr",'
                                +'"firstName": "Andrew",'
                                +'"middleName": "Merlay",'
                                +'"lastName": "Wright",'
                                +'"nationalities": ['
                                +'{'
                                 +'"demonym": "British",'
                                 +'"countryCode": "GB"'
                                 +'}'
                                 +'],'
                                +'"dateOfBirth": {'
                                 +'"year": 1960,'
                                +'"month": 5'
                                +'}'
                                  +'},'
                                +'"company": null,'
                                 +'"isShareholder": null,'
                                +'"disqualifications": [],'
                                +'"appointments": ['
                                 +'{'
                                 +'"status": "open",'
                                 +'"startDate": "2018-05-17",'
                                 +'"endDate": null,'
                                 +'"officialRole": "Director",'
                                 +'"selfDescribedPosition": "Treasurer",'
                                 +'"serviceAddress": {'
                                 +'"fullAddress": "8 Canada Square, London, United Kingdom, E14 5HQ",'
                                 +'"structuredAddress": {'
                                 +'"premises": "8 Canada Square",'
                                 +'"thoroughfare": null,'
                                 +'"dependentLocality": null,'
                                 +'"postTown": "London",'
                                 +'"county": null,'
                                 +'"postcode": "E14 5HQ",'
                                 +'"countryCode": "GB"'
                                 +'}'
                                 +'}'
                                 +'}'
                                 +']'
                                +'}'
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
     public class SAFDuedilMock_GroupCompanies_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "03977902",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 10,'
                                +'"total": 3'
                                +'},'
                                +'"groupParents": ['
                              +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": 10587968,'
                                +'"name": "Google International Llc",'
                                +'"degreeOfSeparation": 1,'
                                +'"ConnectionType"  :"Parent Company",'
                                +'"AccountId":12345,'
                                +'"isImmediateParent": true,'
                                +'"isUltimateParent": false'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": 10588139,'
                                +'"name": "Google Inc",'
                                +'"degreeOfSeparation": 2,'
                                +'"isImmediateParent": false,'
                                +'"isUltimateParent": false'
                                +'},'
                                +'{'
                                +'"countryCode": "GB",'
                                +'"companyId": 10567968,'
                                +'"name": "Alphabet Inc",'
                                +'"degreeOfSeparation": 3,'
                                +'"isImmediateParent": false,'
                                +'"isUltimateParent": true'
                                +'}'
                                +'],'
                                +'"totalCompanyShares": 36031336,'
                                +'"shareholders": ['
                                +'{'
                                +'"sourceName": "Peter Damian Kimmelman",'
                                +'"totalShareholding": 9888495,'
                                +'"totalShareholdingPercentage": 27.444153056106497,'
                                +'"shareholdings": [],'
                                +'"exactMatches": ['
                                +'{' 
                                +'"type": "company",'
                                +'"person": null,'
                                +'"company": {'
                                +'"countryCode": "GB",'
                                +'"companyId": "00014259",'
                                +'"name": "HSBC Bank PLC",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active",'
                                +        '    "registeredAddress": {'+
        '        "fullAddress": "Swiss House Beckingham Street Tolleshunt Major Maldon Essex CM9 8LZ",'+
        '        "structuredAddress": {'+
        '            "premises": "Swiss House Beckingham Street",'+
        '            "thoroughfare": "Tolleshunt Major",'+
        '            "dependentLocality": null,'+
        '            "postTown": "Maldon",'+
        '            "county": "Essex",'+
        '            "postcode": "CM9 8LZ",'+
        '            "countryCode": "GB"'+
        '        },'+
        '        "geolocation": {'+
        '            "latitude": 51.7657,'+
        '            "longitude": 0.748981'+
        '        }'+
        '    }'+
                                +'        }'
                                +'    }'
                                +'],'
                                +'"possibleMatches": [ ],'
                                +'"notMatched": null'
                                +'},'  
                               + '        {'+
        '            "sourceName": "Daniel Phillips",'+
        '            "totalShareholding": 36,'+
        '            "totalShareholdingPercentage": 34.95145631067961,'+
        '            "shareholdings": ['+
        '                {'+
        '                    "class": "Ordinary",'+
        '                    "numberOfShares": 35,'+
        '                    "percentageOfShares": 35,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "class": "Ordinary B",'+
        '                    "numberOfShares": 1,'+
        '                    "percentageOfShares": 100,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                }'+
        '            ],'+
        '            "exactMatches": ['+
        '                {'+
        '                    "type": "person",'+
        '                    "person": {'+
        '                        "honorific": "Mr",'+
        '                        "firstName": "Daniel",'+
        '                        "middleName": null,'+
        '                        "lastName": "Phillips",'+
        '                        "nationalities": ['+
        '                            {'+
        '                                "demonym": "British",'+
        '                                "countryCode": "GB"'+
        '                            }'+
        '                        ],'+
        '                        "dateOfBirth": {'+
        '                            "year": 1990,'+
        '                            "month": 12'+
        '                        },'+
        '                        "officerId": "925035810"'+
        '                    },'+
        '                    "company": null'+
        '                }'+
        '            ],'+
        '            "possibleMatches": [],'+
        '            "notMatched": null'+
        '        },'+
        '        {'+
        '            "sourceName": "Paul Armstrong",'+
        '            "totalShareholding": 31,'+
        '            "totalShareholdingPercentage": 30.097087378640776,'+
        '            "shareholdings": ['+
        '                {'+
        '                    "class": "Ordinary",'+
        '                    "numberOfShares": 30,'+
        '                    "percentageOfShares": 30,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                },'+
        '                {'+
        '                    "class": "Ordinary C",'+
        '                    "numberOfShares": 1,'+
        '                    "percentageOfShares": 100,'+
        '                    "nominalValue": {'+
        '                        "value": 1,'+
        '                        "currency": "GBP"'+
        '                    }'+
        '                }'+
        '            ],'+
        '            "exactMatches": ['+
        '                {'+
        '                    "type": "person",'+
        '                    "person": {'+
        '                        "honorific": "Mr",'+
        '                        "firstName": "Paul",'+
        '                        "middleName": null,'+
        '                        "lastName": "Armstrong",'+
        '                        "nationalities": ['+
        '                            {'+
        '                                "demonym": "British",'+
        '                                "countryCode": "GB"'+
        '                            }'+
        '                        ],'+
        '                        "dateOfBirth": {'+
        '                            "year": 1967,'+
        '                            "month": 5'+
        '                        },'+
        '                        "officerId": "925035807"'+
        '                    },'+
        '                    "company": null'+
        '                }'+
        '            ],'+
        '            "possibleMatches": [],'+
        '            "notMatched": null'+
        '        }'+                            
                                +'],'
                                 +'"filters": null,'
                                +'"officers": ['
                                +'{'
                                +'"officerId": "924703112",'
                                +'"type": "person",'
                                +'"person": {'
                                +'"honorific": "Mr",'
                                +'"firstName": "Andrew",'
                                +'"middleName": "Merlay",'
                                +'"lastName": "Wright",'
                                +'"nationalities": ['
                                +'{'
                                 +'"demonym": "British",'
                                 +'"countryCode": "GB"'
                                 +'}'
                                 +'],'
                                +'"dateOfBirth": {'
                                 +'"year": 1960,'
                                +'"month": 5'
                                +'}'
                                  +'},'
                                +'"company": null,'
                                 +'"isShareholder": null,'
                                +'"disqualifications": [],'
                                +'"appointments": ['
                                 +'{'
                                 +'"status": "open",'
                                 +'"startDate": "2018-05-17",'
                                 +'"endDate": null,'
                                 +'"officialRole": "Director",'
                                 +'"selfDescribedPosition": "Treasurer",'
                                 +'"serviceAddress": {'
                                 +'"fullAddress": "8 Canada Square, London, United Kingdom, E14 5HQ",'
                                 +'"structuredAddress": {'
                                 +'"premises": "8 Canada Square",'
                                 +'"thoroughfare": null,'
                                 +'"dependentLocality": null,'
                                 +'"postTown": "London",'
                                 +'"county": null,'
                                 +'"postcode": "E14 5HQ",'
                                 +'"countryCode": "GB"'
                                 +'}'
                                 +'}'
                                 +'}'
                                 +']'
                                +'}'
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
     public class SAFDuedilMock_Shareholders_Test implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) 
        {
            // Create a fake response
            HttpResponse response = new HttpResponse(); 
            response.setHeader('X-AUTH-TOKEN', 'a451717e064cd7394d3e9928c84f9d34');
            String responseStr = '{'
                                +'"countryCode": "GB",'
                                +'"companyId": "06999618",'
                                +'"pagination": {'
                                +'"offset": 0,'
                                +'"limit": 3,'
                                +'"total": 40'
                                +'},'
                                +'"totalCompanyShares": 36031336,'
                                +'"shareholders": ['
                                +'{'
                                +'"sourceName": "Peter Damian Kimmelman",'
                                +'"totalShareholding": 9888495,'
                                +'"totalShareholdingPercentage": 27.444153056106497,'
                                +'"shareholdings": [],'
                                +'"exactMatches": ['
                                +'{' 
                                +'"type": "company",'
                                +'"person": null,'
                                +'"company": {'
                                +'"countryCode": "GB",'
                                +'"companyId": "00014259",'
                                +'"name": "HSBC Bank PLC",'
                                +'"officialStatus": "Active",'
                                +'"simplifiedStatus": "Active"'
                                +'        }'
                                +'    }'
                                +'],'
                                +'"possibleMatches": [ ],'
                                +'"notMatched": null'
                                +'}'                              
                                +']'
                                +'}';
            response.setBody(responseStr);
            response.setStatusCode(200);
            response.setStatus('Ok');
            return response; 
        }
    }
    //finish :Written :subrat  14 Jun
    
 
public Static testmethod void parserTest()
    {     
        
        //Test.startTest();
        
        SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
        objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.lstAccounts = new List<Account>();
        //objCmp.lstcontact = new List<Contact>();
        objCmp.objAccountlst = new List<Account>();
        objCmp.objContactlst = new List<Contact>();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','03977902');
        System.currentPageReference().getParameters().put('companyname','Acme + Ltd');
        
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetShareholders__c='https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.GetRelatedCompanies__c ='https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
         objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
            objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
       // objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
       
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1;  
      /*  Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());   
         Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_RelatedCompanies_Test1());  
          Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Test()); 
           Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_IndustryInfo_Test()); 
            Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc()); //SAFDuedilMock_Shareholders_Test_Exc //SAFDuedilMock_Shareholders_Test
             Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test()); 
              Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test());*/
             
      //  SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('03977902','20','0');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/03977902/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        // Set mock callout class  // SAFDuedilMock_Shareholders_Test
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc());   
        SAF_Duedil.companyshareholders sh = SAF_Duedil.GetShareholders('03977902','gb');//03977902 // 10672557 // 06999618
        objCmp.shareholder = sh.shareholders;
        system.debug('###objCmp.shareholder :' + sh.shareholders[0].exactMatches);
        system.debug('###objCmp.shareholder1 :' + objCmp.shareholder[0].exactMatches);
         for(SAF_Duedil.shareholder objshare:objCmp.shareholder)    
                {
                     objshare.contactId= '';
                     objshare.ischecked = true;
                }
        //objCmp.CreateShareholderContacts();

            objCmp.RelConShow();
         
        req = new RestRequest();
        res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
        List<SAF_Duedil.groupParent> groupParents;
        
        req.requestURI = '/company/gb/03977902/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
       
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());  
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());  
        SAF_Duedil.GroupCompanies gc = SAF_Duedil.GetGroupCompanies('03977902','gb');
        objCmp.CompgroupParents = gc.groupParents;
        
        pagination      = gc.pagination;
        countryCode     = gc.countryCode;
        companyId       = gc.companyId;
        groupParents    = gc.groupParents;
        system.debug('###objCmp.CompgroupParents :' + objCmp.CompgroupParents);
        //SAF_Duedil.groupParent grp_parent = objCmp.CompgroupParents[0];
        if(objCmp.CompgroupParents!=null)
        {
        for(SAF_Duedil.groupParent grp_parent:objCmp.CompgroupParents)    
                {
                     grp_parent.AccountId = null;
                     grp_parent.ischecked = true;
                }
         }
        objCmp.RelConShow();
        objCmp.show();
        objCmp.SAF_CompanyDeatils();  
        /*objCmp.CreateShareholderContacts();
        objCmp.RelConcreateContacts();
        objCmp.RelConupdateContactIds();*/
     
        
        req = new RestRequest();
        res = new RestResponse();
        string  officialStatus, simplifiedStatus, name, confidence;
        decimal nameSimilarityScore;
        string AccountId;
        SAF_Duedil.mutualAddresses mutualAddresses;
        SAF_Duedil.mutualMajorShareholders mutualMajorShareholders;
        SAF_Duedil.mutualOfficers  mutualOfficers;
        SAF_Duedil.mutualInvestments mutualInvestments;
        boolean ischecked;
        
        req.requestURI = '/company/gb/10588244/related-companies';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
       Test.stopTest();
    
        // Set mock callout class 
     
      
    }
    public static testmethod void parsetest1()
    {
       
        
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetShareholders__c='https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.GetRelatedCompanies__c ='https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
        objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
        objSettings1.LegalEntity_Sole__c ='Sole Proprietorship';
        objSettings1.LegalEntity_Individual__c = 'Individual';
       // objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        
         Saf_setting__c objSettings2 = Saf_setting__c.getOrgDefaults();
        objSettings2.DisableCustomerTriggers__c = true;    
        UPSERT objSettings2; 
        
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1; 
        
           List<clcommon__Reciprocal_Role__c> lstrole = new List<clcommon__Reciprocal_Role__c>();
        clcommon__Reciprocal_Role__c objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'UBO';
        objrole.clcommon__Inverse_Role__c = 'Ultimate beneficiary'; 
        lstrole.add(objrole);   
        objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'Director';
        objrole.clcommon__Inverse_Role__c = 'Director';
        lstrole.add(objrole);  
        insert lstrole;
         
        Test.startTest();
         SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
        objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.lstAccounts = new List<Account>();
        //objCmp.lstcontact = new List<Contact>();
        objCmp.objAccountlst = new List<Account>();
        objCmp.objContactlst = new List<Contact>();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','10588244');//'03977902'
        System.currentPageReference().getParameters().put('companyname','Simply Asset Finance Operations Limited');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
        List<SAF_Duedil.groupParent> groupParents;
         string  officialStatus, simplifiedStatus, name, confidence;
        decimal nameSimilarityScore;
        string AccountId;
        SAF_Duedil.mutualAddresses mutualAddresses;
        SAF_Duedil.mutualMajorShareholders mutualMajorShareholders;
        SAF_Duedil.mutualOfficers  mutualOfficers;
        SAF_Duedil.mutualInvestments mutualInvestments;
        boolean ischecked;
      
         req.requestURI = '/company/gb/03977902/shareholders';//related-companies
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
     
        //Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_RelatedCompanies_Test1());  
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());    
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_RelatedCompanies_CurTest()); 
        SAF_Duedil.RelatedCompanies rc = SAF_Duedil.GetRelatedCompanies('10588244','gb');
        
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test1()); 
        SAF_Duedil.CustomerInfo csinfo = new SAF_Duedil.CustomerInfo();
        csinfo = SAF_Duedil.GetCompanyInfo('10588244','gb');
        system.debug('###rc :' + rc);
        SAF_CompanyDeatils.customerInit(csinfo);
        
         
         
        objCmp.comprelatedCompanies = rc.relatedCompanies;
        system.debug('###objCmp.comprelatedCompanies :' + objCmp.comprelatedCompanies);
        if(objCmp.comprelatedCompanies!=null)
        {
         for(SAF_Duedil.relatedCompany relc:objCmp.comprelatedCompanies)    
            {
                 relc.AccountId = null;
                 relc.ischecked = true;
                  countryCode = relc.countryCode; 
                    objCmp.companyId = relc.companyId; 
                    officialStatus = relc.officialStatus; 
                    simplifiedStatus = relc.simplifiedStatus; 
                    name = relc.name; 
                    confidence = relc.confidence;
                    AccountId = relc.AccountId;
                    mutualAddresses = relc.mutualAddresses;
                    mutualMajorShareholders = relc.mutualMajorShareholders;
                    mutualOfficers = relc.mutualOfficers;
                    mutualInvestments = relc.mutualInvestments;
                    relc.nameSimilarityScore = 26.00;
                    nameSimilarityScore = relc.nameSimilarityScore;
                    ischecked = relc.ischecked;
            }
        //SAF_Duedil.relatedCompany relc = objCmp.comprelatedCompanies[0];
        //relc.AccountId = null;
        //relc.ischecked = true;
       
        objCmp.createRelatedCustomers() ;
        }
        req = new RestRequest();
        res = new RestResponse();
        
        req.requestURI = '/company/gb/10588244/officers';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;

        //Test.startTest();
        // Set mock callout class 
        /*Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test());   // 
        SAF_Duedil.companyOfficers co = SAF_Duedil.GetcompanyOfficers('10588244','gb');             
        objCmp.officers = co.officers;
         for(SAF_Duedil.officer objofficer:objCmp.officers)    
                {
                     objofficer.contactId = '';
                     objofficer.ischecked = true;
                }
     
        // objCmp.createRelatedCustomers() ;*/
          objCmp.companyId = '10588244'; 
           for(SAF_Duedil.groupParent grp_parent:objCmp.CompgroupParents)    
                {
                     grp_parent.AccountId = null;
                     grp_parent.ischecked = true;
                }
        //objCmp.RelConcreateContacts();
        
        objCmp.CreateShareholderContacts();
        objCmp.RelConcreateContacts();
        objCmp.RelConupdateContactIds();
        objCmp.updateParentAccountIds();
        objCmp.createRelatedGroupCustomers();
         
         Test.stopTest();
       // objCmp.updateParentAccountIds();
            
    }
      public static testmethod void parsetest_RelConcreateContacts()
    {
       
        
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetShareholders__c='https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.GetRelatedCompanies__c ='https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
           objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
       // objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        
         Saf_setting__c objSettings2 = Saf_setting__c.getOrgDefaults();
        objSettings2.DisableCustomerTriggers__c = true;    
        UPSERT objSettings2; 
        
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1; 
        
           List<clcommon__Reciprocal_Role__c> lstrole = new List<clcommon__Reciprocal_Role__c>();
        clcommon__Reciprocal_Role__c objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'UBO';
        objrole.clcommon__Inverse_Role__c = 'Ultimate beneficiary'; 
        lstrole.add(objrole);   
        objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'Director';
        objrole.clcommon__Inverse_Role__c = 'Director';
        lstrole.add(objrole);  
        insert lstrole;
         
        Test.startTest();
         SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
        objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.lstAccounts = new List<Account>();
        //objCmp.lstcontact = new List<Contact>();
        objCmp.objAccountlst = new List<Account>();
        objCmp.objContactlst = new List<Contact>();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','10588244');//'03977902'
        System.currentPageReference().getParameters().put('companyname','Simply Asset Finance Operations Limited');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
        List<SAF_Duedil.groupParent> groupParents;
         string  officialStatus, simplifiedStatus, name, confidence;
        decimal nameSimilarityScore;
        string AccountId;
        SAF_Duedil.mutualAddresses mutualAddresses;
        SAF_Duedil.mutualMajorShareholders mutualMajorShareholders;
        SAF_Duedil.mutualOfficers  mutualOfficers;
        SAF_Duedil.mutualInvestments mutualInvestments;
        boolean ischecked;
      
         req.requestURI = '/company/gb/03977902/shareholders';//related-companies
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        req = new RestRequest();
        res = new RestResponse();
        
        req.requestURI = '/company/gb/10588244/officers';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;

        //Test.startTest();
        // Set mock callout class 
        objCmp.companyId= '10588244';
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test());   // 
        SAF_Duedil.companyOfficers co = SAF_Duedil.GetcompanyOfficers('10588244','gb');             
        objCmp.officers = co.officers;
         for(SAF_Duedil.officer objofficer:objCmp.officers)    
                {
                     objofficer.contactId = '';
                     objofficer.ischecked = true;
                }
     /*
        // objCmp.createRelatedCustomers() ;
          objCmp.companyId = '10588244'; */
           Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test());   //  SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test
          SAF_Duedil.GroupCompanies gc2 = SAF_Duedil.GetGroupCompanies('10672557','gb');
        objCmp.CompgroupParents = gc2.groupParents;
           for(SAF_Duedil.groupParent grp_parent:objCmp.CompgroupParents)    
                {
                     grp_parent.AccountId = null;
                     grp_parent.ischecked = true;
                }
        //objCmp.RelConcreateContacts();
        
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test1()); 
        objCmp.RelConcreateContacts();       
         Test.stopTest();
            
    }
    
    public static testmethod void parsetest_Shareholders()
    {
       
        
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetShareholders__c='https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.GetRelatedCompanies__c ='https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
           objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
       // objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        
         Saf_setting__c objSettings2 = Saf_setting__c.getOrgDefaults();
        objSettings2.DisableCustomerTriggers__c = true;    
        UPSERT objSettings2; 
        
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1; 
        
           List<clcommon__Reciprocal_Role__c> lstrole = new List<clcommon__Reciprocal_Role__c>();
        clcommon__Reciprocal_Role__c objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'UBO';
        objrole.clcommon__Inverse_Role__c = 'Ultimate beneficiary'; 
        lstrole.add(objrole);   
        objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'Director';
        objrole.clcommon__Inverse_Role__c = 'Director';
        lstrole.add(objrole);  
        insert lstrole;
         
        Test.startTest();
         SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
        objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.lstAccounts = new List<Account>();
        //objCmp.lstcontact = new List<Contact>();
        objCmp.objAccountlst = new List<Account>();
        objCmp.objContactlst = new List<Contact>();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','10588244');//'03977902'
        System.currentPageReference().getParameters().put('companyname','Simply Asset Finance Operations Limited');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
        List<SAF_Duedil.groupParent> groupParents;
         string  officialStatus, simplifiedStatus, name, confidence;
        decimal nameSimilarityScore;
        string AccountId;
        SAF_Duedil.mutualAddresses mutualAddresses;
        SAF_Duedil.mutualMajorShareholders mutualMajorShareholders;
        SAF_Duedil.mutualOfficers  mutualOfficers;
        SAF_Duedil.mutualInvestments mutualInvestments;
        boolean ischecked;
      
         req.requestURI = '/company/gb/03977902/shareholders';//related-companies
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        req = new RestRequest();
        res = new RestResponse();
        
        req.requestURI = '/company/gb/10588244/officers';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;

        //Test.startTest();
        // Set mock callout class 
        objCmp.companyId= '10588244';
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test());   // 
        SAF_Duedil.companyOfficers co = SAF_Duedil.GetcompanyOfficers('10588244','gb');             
        objCmp.officers = co.officers;
         for(SAF_Duedil.officer objofficer:objCmp.officers)    
                {
                     objofficer.contactId = '';
                     objofficer.ischecked = true;
                }
     /*
        // objCmp.createRelatedCustomers() ;
          objCmp.companyId = '10588244'; */
          Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test());   //  SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test
          SAF_Duedil.GroupCompanies gc2 = SAF_Duedil.GetGroupCompanies('10672557','gb');
          objCmp.CompgroupParents = gc2.groupParents;
          for(SAF_Duedil.groupParent grp_parent:objCmp.CompgroupParents)    
                {
                     grp_parent.AccountId = null;
                     grp_parent.ischecked = true;
                }
        //objCmp.RelConcreateContacts();
         Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc());   
         
        SAF_Duedil.companyshareholders sh = SAF_Duedil.GetShareholders('06999618','gb');//03977902 // 10672557 // 06999618
        objCmp.shareholder = sh.shareholders;
        system.debug('~###objCmp.shareholder :' + sh);
        system.debug('~###objCmp.shareholder1 :' + objCmp.shareholder[0].exactMatches);
         for(SAF_Duedil.shareholder objshare:objCmp.shareholder)    
                {
                     objshare.contactId= '';
                     objshare.ischecked = true;
                    system.debug('~###exactMatches:' + objshare.exactMatches.size());
                     for(SAF_Duedil.exactMatch objexact:objshare.exactMatches)    
                    {
                        objshare.exactMatchType = objexact.type;
                        system.debug('~###Type :' +  objshare.exactMatchType);
                    }
                }
     
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test1()); 
        objCmp.CreateShareholders();       
        Test.stopTest();
            
    }
       public static testmethod void parsetest_groupcust()
    {
       
        
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetShareholders__c='https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.GetRelatedCompanies__c ='https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
           objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
       // objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
        objSettings.client_id__c = 'Dummy client Id'; 
        objSettings.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSettings;
        
         Saf_setting__c objSettings2 = Saf_setting__c.getOrgDefaults();
        objSettings2.DisableCustomerTriggers__c = true;    
        UPSERT objSettings2; 
        
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1; 
        
           List<clcommon__Reciprocal_Role__c> lstrole = new List<clcommon__Reciprocal_Role__c>();
        clcommon__Reciprocal_Role__c objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'UBO';
        objrole.clcommon__Inverse_Role__c = 'Ultimate beneficiary'; 
        lstrole.add(objrole);   
        objrole = new clcommon__Reciprocal_Role__c();
        objrole.name = 'Director';
        objrole.clcommon__Inverse_Role__c = 'Director';
        lstrole.add(objrole);  
        insert lstrole;
         
        Test.startTest();
         SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
        objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.lstAccounts = new List<Account>();
        //objCmp.lstcontact = new List<Contact>();
        objCmp.objAccountlst = new List<Account>();
        objCmp.objContactlst = new List<Contact>();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','10588244');//'03977902'
        System.currentPageReference().getParameters().put('companyname','Simply Asset Finance Operations Limited');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        SAF_Duedil.pagination pagination;
        string countryCode;
        string  companyId;
        List<SAF_Duedil.groupParent> groupParents;
         string  officialStatus, simplifiedStatus, name, confidence;
        decimal nameSimilarityScore;
        string AccountId;
        SAF_Duedil.mutualAddresses mutualAddresses;
        SAF_Duedil.mutualMajorShareholders mutualMajorShareholders;
        SAF_Duedil.mutualOfficers  mutualOfficers;
        SAF_Duedil.mutualInvestments mutualInvestments;
        boolean ischecked;
      
         req.requestURI = '/company/gb/03977902/shareholders';//related-companies
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
      
        req = new RestRequest();
        res = new RestResponse();
        
        req.requestURI = '/company/gb/10588244/officers';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;

        //Test.startTest();
        // Set mock callout class 
        objCmp.companyId = '10672557'; 
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test());   //  SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test
          SAF_Duedil.GroupCompanies gc2 = SAF_Duedil.GetGroupCompanies('10672557','gb');
        objCmp.CompgroupParents = gc2.groupParents;
        
        SAF_Duedil.companyOfficers co = SAF_Duedil.GetcompanyOfficers('10588244','gb');             
        objCmp.officers = co.officers;
         for(SAF_Duedil.officer objofficer:objCmp.officers)    
                {
                     objofficer.contactId = '';
                     objofficer.ischecked = true;
                }
              
           for(SAF_Duedil.groupParent grp_parent:objCmp.CompgroupParents)    
                {
                     grp_parent.AccountId = null;
                     grp_parent.ischecked = true;
                }
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test1()); 
        objCmp.createRelatedGroupCustomers();
         
         Test.stopTest();
       // objCmp.updateParentAccountIds();
            
    }
    //start :Written :subrat  14 Jun
    
    public Static testmethod void show_relconshow_compdetl(){
        SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
         objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','10672557');
         System.currentPageReference().getParameters().put('companyname','Acme + Ltd');
        
        /*RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;*/
          Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
        objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
        objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test());
        //Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());
        //SAF_CompanyDeatils.createRelatedGroupCustomers2('10672557','Kier');      
        //  objCmp.RelConShow();
         Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Test()); 
           //  SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('03977902','20','0');
            objCmp.show();
            objCmp.SAF_CompanyDeatils(); 
            Test.stopTest();
        
    } 
    public Static testmethod void CRGC(){
        
        /*RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;*/
       
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        List<Account> lstacc = new List<Account>();
        RestContext.request=req;
        RestContext.response=res;
        
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
        objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
        objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.GetShareholders__c= 'https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1;
       Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test());
        //Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());
        string ContactId = '';
        SAF_CompanyDeatils.createRelatedGroupCustomers1('03977902','Google UK Limited');
        
        
        Test.stopTest();
        
    } 
     public Static testmethod void CRGC1(){
        
        /*RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;*/
       
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        List<Account> lstacc = new List<Account>();
        RestContext.request=req;
        RestContext.response=res;
      
         Saf_Duedil__c objSettings1 = Saf_Duedil__c.getOrgDefaults();
        objSettings1.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings1.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings1.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
        objSettings1.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
        objSettings1.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
        objSettings1.GetShareholders__c= 'https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings1.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings1.Customer_Type__c = 'Account';
        UPSERT objSettings1;
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAFDuedilMock_GroupCompanies_Test1());
        //Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());
        string ContactId = '';
        SAF_CompanyDeatils.createRelatedGroupCustomers1('03977902','Google UK Limited');
        
        
        Test.stopTest();
        
    } 
    //finish :Written :subrat  14 Jun
    
    public Static testmethod void parserTest2()
    {
         Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;
        
        SAF_CompanyDeatils objCmp2 = new SAF_CompanyDeatils();
        objCmp2.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp2.officers = new List<SAF_Duedil.officer>();
        objCmp2.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp2.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp2.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp2.CustAddress = '';
        objCmp2.ConnectionType = '';
        objCmp2.UBOCompanyId = '';
        objCmp2.UBOCompanyName = '';
        objCmp2.AccountId = '';
        objCmp2.shareholderUBO = new List<SAF_Duedil.shareholder> ();
         Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());  
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','10588244'); // 10588244 // 06999618
         System.currentPageReference().getParameters().put('companyname','Simply Asset Finance Operations Limited');
        
        Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
        settings.TotalShareholderPercentage__c = 25;
        settings.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        settings.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        settings.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
        settings.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
        settings.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0';
       
        settings.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        settings.Customer_Type__c = 'Account';
        upsert settings;
        
        Test.startTest(); 
       SAF_Duedil.GroupCompanies gc2 = SAF_Duedil.GetGroupCompanies('10672557','gb');
        objCmp2.CompgroupParents = gc2.groupParents;
        List<Account> lstacc = new List<Account>();    
        
        objCmp2.RelConShow();
        system.debug('###objCmp2.CompgroupParents :' + objCmp2.CompgroupParents);
        //SAF_Duedil.groupParent grp_parent = objCmp.CompgroupParents[0];
        for(SAF_Duedil.groupParent grp_parent:objCmp2.CompgroupParents)    
                {
                     grp_parent.AccountId = null;
                     grp_parent.ischecked = true;
                }
       
        objCmp2.createRelatedGroupCustomers();
        system.debug('test class shareholder: '+objCmp2.shareholder);
        system.debug('test class shareholderUBO: '+objCmp2.shareholderUBO);
        objCmp2.CreateShareholders();
        objCmp2.CreateUBOShareholders();
        objCmp2.RelCreateContactFromAccount(lstacc);
         Test.stopTest();
         
         }
       public Static testmethod void parserTest3()
    {     
         Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;
        
        Saf_Duedil__c objSettings = Saf_Duedil__c.getOrgDefaults();
        objSettings.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings.GetShareholders__c= 'https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
         objSettings.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
        objSettings.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0'; 
        objSettings.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings.Customer_Type__c = 'Account';
        UPSERT objSettings;
        Test.startTest();
        
        SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
        objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','06999618');
         System.currentPageReference().getParameters().put('companyname','Acme + Ltd');
        
           
      /*  Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());   
         Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_RelatedCompanies_Test1());  
          Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Test()); 
           Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_IndustryInfo_Test()); 
            Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc()); //SAFDuedilMock_Shareholders_Test_Exc //SAFDuedilMock_Shareholders_Test
             Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test()); 
              Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test());*/
             
        //SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('10588139','20','0');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        //Test.startTest();
        // Set mock callout class  // SAFDuedilMock_Shareholders_Test
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc());   
         
        SAF_Duedil.companyshareholders sh = SAF_Duedil.GetShareholders('06999618','gb');//03977902 // 10672557 // 06999618
        objCmp.shareholder = sh.shareholders;
        system.debug('~###objCmp.shareholder :' + sh);
        system.debug('~###objCmp.shareholder1 :' + objCmp.shareholder[0].exactMatches);
         for(SAF_Duedil.shareholder objshare:objCmp.shareholder)    
                {
                     objshare.contactId= '';
                     objshare.ischecked = true;
                    system.debug('~###exactMatches:' + objshare.exactMatches.size());
                     for(SAF_Duedil.exactMatch objexact:objshare.exactMatches)    
                    {
                        objshare.exactMatchType = objexact.type;
                        system.debug('~###Type :' +  objshare.exactMatchType);
                    }
                }
        objCmp.CreateShareholderContacts();
         
        objCmp.CreateShareholders();
              
      
        //Integer i = objCmp.createCompany(objCmp.shareholder[1]);
        //objCmp.CreateUBOShareholders();
          Test.stopTest();
          
          }
       public Static testmethod void parserTest4()
       {     
         Saf_setting__c objSettings1 = Saf_setting__c.getOrgDefaults();
        objSettings1.DisableCustomerTriggers__c = true;    
        UPSERT objSettings1;
        
          Saf_Duedil__c objSettings = Saf_Duedil__c.getOrgDefaults();
        objSettings.GetcompanyOfficers__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/officers.json?limit=10&offset=0';
        objSettings.GetGroupCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/group-parents.json?limit=10&offset=0';
        objSettings.GetShareholders__c= 'https://duedil.io/v4/company/Countrycode/CompanyId/shareholders.json?limit=10&offset=0';
        objSettings.GetCompanyInfo__c='https://duedil.io/v4/company/Countrycode/CompanyId.json?limit=10&offset=0';
        objSettings.getCustomers__c ='https://duedil.io/v4/search/companies.json?limit=strlimit&offset=stroffset';
        objSettings.GetRelatedCompanies__c = 'https://duedil.io/v4/company/Countrycode/CompanyId/related-companies.json?limit=10&offset=0'; 
        objSettings.Token__c  = 'a451717e064cd7394d3e9928c84f9d34';  
        objSettings.Customer_Type__c = 'Account';
        UPSERT objSettings;
        Test.startTest();
        
        SAF_CompanyDeatils objCmp = new SAF_CompanyDeatils();
        objCmp.shareholder = new List<SAF_Duedil.shareholder>();
        objCmp.officers = new List<SAF_Duedil.officer>();
        objCmp.comprelatedCompanies = new List<SAF_Duedil.relatedCompany>();
        objCmp.CompgroupParents = new List<SAF_Duedil.groupParent>();
        objCmp.CustInfo= new List<SAF_Duedil.CustomerInfo> ();
        objCmp.CustAddress = '';
        objCmp.ConnectionType = '';
        objCmp.UBOCompanyId = '';
        objCmp.UBOCompanyName = '';
        objCmp.AccountId = '';
        objCmp.shareholderUBO = new List<SAF_Duedil.shareholder> ();
        
        Test.setCurrentPageReference(new PageReference('Page.SAF_CompanyDeatils')); 
        System.currentPageReference().getParameters().put('companyid','06999618');
         System.currentPageReference().getParameters().put('companyname','Acme + Ltd');
        
           
      /*  Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_GroupCompanies_Test());   
         Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_RelatedCompanies_Test1());  
          Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Test()); 
           Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_IndustryInfo_Test()); 
            Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc()); //SAFDuedilMock_Shareholders_Test_Exc //SAFDuedilMock_Shareholders_Test
             Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_companyOfficersApp_Test()); 
              Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_CompanyInfo_Test());*/
             
        //SAF_Duedil.CustomersInfo cs = SAF_Duedil.getCustomers('10588139','20','0');
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/company/gb/10672557/shareholders';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        
        //Test.startTest();
        // Set mock callout class  // SAFDuedilMock_Shareholders_Test
        Test.setMock(HttpCalloutMock.class, new SAF_Duedil_Test.SAFDuedilMock_Shareholders_Test_Exc());   
         
        SAF_Duedil.companyshareholders sh = SAF_Duedil.GetShareholders('06999618','gb');//03977902 // 10672557 // 06999618
        objCmp.shareholder = sh.shareholders;
        system.debug('~###objCmp.shareholder :' + sh);
        system.debug('~###objCmp.shareholder1 :' + objCmp.shareholder[0].exactMatches);
         for(SAF_Duedil.shareholder objshare:objCmp.shareholder)    
                {
                     objshare.contactId= '';
                     objshare.ischecked = true;
                    //system.debug('~###Type :' + objshare.exactMatches.type);
                     for(SAF_Duedil.exactMatch objexact:objshare.exactMatches)    
                    {
                        objshare.exactMatchType = objexact.type;
                    }
                }
        //objCmp.CreateShareholderContacts();
         
        objCmp.CreateShareholders();
              
      
        //Integer i = objCmp.createCompany(objCmp.shareholder[1]);
        //objCmp.CreateUBOShareholders();
          Test.stopTest();
          
          }
}