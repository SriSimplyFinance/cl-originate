@isTest//(seeAllData=true)
public class SAF_ContactsUtilsTest {
  public static testmethod void UpdateContactToDBtest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        RestContext.request=req;
        RestContext.response=res;
        Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateContactToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/individual'; 
            upsert objSettings;
            
            saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
            objSetting.client_id__c = 'Dummy client Id'; 
            objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
            UPSERT objSetting;
            Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
            zohomapping.Salesforce_Field__c='rrrrr';
            zohomapping.Zoho_Fields__c='sss';
            zohomapping.Name='duplicateName';
            UPSERT zohomapping;   
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());  
            
        // Set mock callout class 
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
         clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
         insert legal;
         Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='269';
        acc.AccountNumber='06625914';
        acc.Sic ='0000';
        acc.Type = 'Account';
        acc.UK_Region__c ='0000';
        acc.Phone='9898787656';
        acc.clcommon__Email__c ='test@example.com';
        acc.Ownership='Private Limited Company';
        acc.BillingStreet ='test Street';
        acc.BillingState ='UK';
        acc.BillingCountry = 'UK';
        acc.ShippingStreet ='test Street';
        acc.ShippingCountry='UK';
        acc.ShippingState ='UK';
        acc.Zoho_Customer_Id__c = '10777000005023458';
        insert acc;
        Contact contact = new Contact();
        contact.FirstName = 'Alan';
        contact.LastName = 'MILLER';
        contact.Salutation = 'Mr';
        contact.Title = 'Director/Officer';
        contact.AccountId = acc.id;
        contact.KYCDB_Unique_Key_Contact__c = '';
        contact.MailingCity ='Corby';
        contact.MailingStreet = '22 The Avenue';
        contact.MailingState ='Northamptonshire';
        contact.MailingPostalCode = 'NN17 5EE';
        contact.MailingCountry = 'UK';
        contact.OtherCity = 'Corby';
        contact.OtherCountry = 'UK';
        contact.OtherState = 'Northamptonshire';
        contact.OtherStreet = '22 The Avenue';
        contact.Email = 'test@example.com';
        contact.SAF_DOB_Month__c ='8';
        contact.SAF_DOB_Year__c ='1997';
        contact.SAF_Nationalities__c ='Indian';
        contact.OtherPostalCode ='NN17 5EE';
        contact.MobilePhone ='989786677';
        contact.HomePhone='7676564587';
        insert contact; 
         system.debug('contact id::::'+contact.Id);
        List<string> lst = new List<string>();
        lst.add(acc.Id); //'0011x00001ByXxJ'
        lst.add(contact.Id); //'0011x00001ByXxJ'
        SAF_ContactsUtils.UpdateContactToDB(lst);
        Test.stopTest();
    }
     public static testmethod void UpdateContactstest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        RestContext.request=req;
        RestContext.response=res;
        Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            upsert objSettings;
        
            saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
            objSetting.client_id__c = 'Dummy client Id'; 
            objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
            UPSERT objSetting;
        
            Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
            zohomapping.Salesforce_Field__c='rrrrr';
            zohomapping.Zoho_Fields__c='sss';
            zohomapping.Name='duplicateName';
            UPSERT zohomapping;   
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
            insert legal;
            Account acc = new Account();
            acc.clcommon__Legal_Entity_Type__c = legal.id;
            acc.Name = 'TestAccount';
        	acc.cllease__Active__c ='No';
            acc.BillingPostalCode = 'BD1 1HA';
            acc.BillingCity = 'London';
            acc.ShippingPostalCode = 'BD1 1HA';
            acc.ShippingCity = 'London';
            acc.Landline__c='12345 123456';
            acc.KYCDB_Unique_Key_Account__c='192,193';
            acc.AccountNumber='06625914';
            acc.Sic ='0000';
            acc.Type = 'Account';
            acc.UK_Region__c ='0000';
            acc.Phone='9898787656';
            acc.clcommon__Email__c ='test@example.com';
            acc.Ownership='Private Limited Company';
            acc.BillingStreet ='test Street';
            acc.BillingState ='UK';
            acc.BillingCountry = 'UK';
            acc.ShippingStreet ='test Street';
            acc.ShippingCountry='UK';
            acc.ShippingState ='UK';
            acc.Zoho_Customer_Id__c = '10777000005023458';
            insert acc;
            Account  updateAcc = [SELECT Id,Name,cllease__Active__c,BillingStreet FROM Account LIMIT 1];
            updateAcc.cllease__Active__c = 'Yes';
        	updateAcc.BillingStreet = 'test';
        	updateAcc.Name = 'Test';
            updateAcc.BillingPostalCode = 'BD1 1CA';
            updateAcc.BillingCity = 'UK';
        	updateAcc.BillingStreet ='test';
            updateAcc.BillingCountry = 'US';
            updateAcc.BillingState='london';
            updateAcc.Landline__c='12345 123466';
            updateAcc.KYCDB_Unique_Key_Account__c='192';
            updateAcc.AccountNumber='06625915';
            updateAcc.Sic ='0001';
            updateAcc.Type = 'Acc';
            updateAcc.UK_Region__c ='0001';
            updateAcc.Phone='9898787655';
            updateAcc.clcommon__Email__c ='testnew@example.com';
            updateAcc.Ownership='Private Limited';
            updateAcc.ShippingPostalCode = 'BD1 1CA';
            updateAcc.ShippingCity = 'UK';
            updateAcc.ShippingStreet ='test Strett';
            updateAcc.ShippingCountry='US';
            updateAcc.ShippingState ='US';
            updateAcc.Zoho_Customer_Id__c = '10777000005023888';
        	updateAcc.Watchlist_Active__c =true;
            updateAcc.Saf_Title__c ='Mr';
            updateAcc.SSID__c='123';
            updateAcc.Trading_Address_Premises__c='abc';
            updateAcc.Trading_Address_Road__c='Street';
            updateAcc.Registered_Address_Premises__c='New Street';
            updateAcc.Registered_Address_Road__c ='Street';
            update updateAcc;

     		List<string> updatedAccList = new List<string>();
            updatedAccList.add(acc.Id);
            SAF_ContactsUtils.UpdateContacts(updatedAccList);
            Test.stopTest();
    }
      public static testmethod void UpdateNewCustomerToDBtest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        RestContext.request=req;
        RestContext.response=res;
        Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        upsert objSettings;
            Test.startTest();           
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            List<string> lst = new List<string>();
            lst.add('0011x00001ByXxJ');
            SAF_ContactsUtils.UpdateNewCustomerToDB(lst);
            Test.stopTest();
    }
    public static testmethod void createcontactstest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String json=        '['+
        '   {'+
        '      "id":192,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/vsM9MY8wksGP68hwNcYJoM-3sjk/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/_qas6k84dBcmaAN_odCLgr4Wx7A"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":null,'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Olive",'+
        '      "name":"PLATT, Olive",'+
        '      "officer_role":"director",'+
        '      "occupation":"Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/5I-_UOv_VCtza0PiCIPOKkY1Opo/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tzwLgAr5NJXkbrHONUSSPEIxnME"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":"Thomas",'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Raymond",'+
        '      "name":"PLATT, Raymond Thomas",'+
        '      "officer_role":"director",'+
        '      "occupation":"Managing Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '  {'+
        '      "id":196,'+
        '      "address":{'+
        '         "address_line_1":"6-8 Underwood Street",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":null,'+
        '         "postal_code":"N1 7JQ",'+
        '         "premises":null,'+
        '         "locality":"London",'+
        '         "registered_address_line1":"6-8 Underwood Street",'+
        '         "registered_city":"London",'+
        '         "registered_county":null,'+
        '         "registered_country":null,'+
        '         "registered_postcode":"N1 7JQ",'+
        '         "registered_address_premises":null,'+
        '         "registered_address_road":"6-8 Underwood Street"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":null,'+
        '         "year":null'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/kAoVxKbM1PDaLnVG72rJtSFL_ss/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tScRXPuSoQXO0vYUNH1gXx7UJys"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":"1993-04-20",'+
        '      "middle_name":"LIMITED",'+
        '      "title":null,'+
        '      "surname":"WATERLOW",'+
        '      "forename":"NOMINEES",'+
        '      "name":"WATERLOW NOMINEES LIMITED",'+
        '      "officer_role":"corporate-nominee-director",'+
        '      "occupation":null,'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":null,'+
        '      "nationality":null'+
        '   }'+
        ']';
        
        String json2=        '['+
        '        {'+
        '            "id": 86,'+
        '            "name": "Assetree Group 2 Ltd",'+
        '            "legal_entity_type": "Other",'+
        '            "legal_entity_type_id": "a4s3Y000000UBERQA4",'+
        '            "ownership": "Other",'+
        '            "parentCompany": 0,'+
        '            "bracket": null,'+
        '            "shareholder_perc": null,'+
        '            "nationality": null,'+
        '            "country_of_residence": null,'+
        '            "identification": {'+
        '                "country_registered": "England & Wales",'+
        '                "place_registered": "Companies House",'+
        '                "legal_authority": "Companies Act 2006",'+
        '                "legal_form": "Limited By Shares",'+
        '                "registration_number": "12659980"'+
        '            },'+
        '            "notified_on": "2020-08-07",'+
        '            "links": {'+
        '                "self": "/company/12741804/persons-with-significant-control/corporate-entity/UNFc68Hc2BmrzzkIdzw5wM75y4c",'+
        '                "officers": null,'+
        '                "charges": null,'+
        '                "filing_history": null'+
        '            },'+
        '            "kind": "corporate-entity-person-with-significant-control",'+
        '            "etag": "bc4eac59d722fd62f38225495f736f9a67451ed1",'+
        '            "address": {'+
        '                "address_line_1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "address_line_2": "Tavistock Square",'+
        '                "locality": "London",'+
        '                "country": "United Kingdom",'+
        '                "postal_code": "WC1H 9LG",'+
        '                "premises": "C/O Rayner Essex Llp",'+
        '                "region": null,'+
        '                "registered_address_line1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "registered_city": "London",'+
        '                "registered_county": null,'+
        '                "registered_country": "United Kingdom",'+
        '                "registered_postcode": "WC1H 9LG",'+
        '                "registered_address_premises": "C/O Rayner Essex Llp",'+
        '                "registered_address_road": "Tavistock House South"'+
        '            },'+
        '            "name_elements": null,'+
        '            "natures_of_control": ['+
        '                "ownership-of-shares-75-to-100-percent",'+
        '                "voting-rights-75-to-100-percent",'+
        '                "right-to-appoint-and-remove-directors"'+
        '            ],'+
        '            "date_of_birth": null,'+
        '            "cls_account_id": "0011x00001ByXSaAAN"'+
        '        }'+
        '        '+
        ']';
        String json3=        '['+
        '   {'+
        '      "id":192,'+
        '      "name":"Mrs Olive Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/n1AE6lXjNg5RTdLifzw_jZ8PUho",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"9d44dd70af8d68f2491b938d9cc8704da36101d6",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":null,'+
        '         "title":"Mrs",'+
        '         "surname":"Platt",'+
        '         "forename":"Olive"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "cls_account_id":null'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "name":"Mr Raymond Thomas Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/wR1rR3GR8v_XguVCvH7hlhMLaMA",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"5dd541c232cfb21c81e96dcf03480e5f6fba566a",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":"Thomas",'+
        '         "title":"Mr",'+
        '         "surname":"Platt",'+
        '         "forename":"Raymond"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "cls_account_id":null'+
        '   }'+
        ']';
        
      String json1=      '['+
        '   {'+
        '      "accName":"CORPORATE & PROFESSIONAL PENSIONS LIMITED",'+
        '      "accNumber":"02810635",'+
        '      "kycId":116,'+
        '      "billingStreet":"Unit 23 15 Jubilee Close",'+
        '      "billingCity":"Weymouth",'+
        '      "BillingState":null,'+
        '      "billingPostalCode":"DT4 7BS",'+
        '      "billingCountry":"United Kingdom",'+
        '      "sic_codes":"66290",'+
        '      "companyStatus":"Yes",'+
        '      "ownership":"Private Limited Company",'+
        '      "LegalEntity":"Limited Liability Company",'+
        '      "LegalEntiyId":"a4s0O000000CyQ9QAK"'+
        '   }'+
        ']';
  
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account'; 
            objSettings.UpdateContactToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual';
            upsert objSettings;
            
            saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
            objSetting.client_id__c = 'Dummy client Id'; 
            objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
            UPSERT objSetting;
            Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
            zohomapping.Salesforce_Field__c='rrrrr';
            zohomapping.Zoho_Fields__c='sss';
            zohomapping.Name='duplicateName';
            UPSERT zohomapping;      
        
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock()); 
        //New 
            clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
            insert legal;
            Account acc = new Account();
            acc.clcommon__Legal_Entity_Type__c = legal.id;
            acc.Name = 'TestAccount';
            acc.BillingPostalCode = 'BD1 1HA';
            acc.BillingCity = 'London';
            acc.ShippingPostalCode = 'BD1 1HA';
            acc.ShippingCity = 'London';
            acc.Landline__c='12345 123456';
            acc.KYCDB_Unique_Key_Account__c='';
            acc.AccountNumber='06625914';
            acc.Sic ='0000';
            acc.Type = 'Account';
            acc.UK_Region__c ='0000';
            acc.Phone='9898787656';
            acc.clcommon__Email__c ='test@example.com';
            acc.Ownership='Private Limited Company';
            acc.BillingStreet ='test Street';
            acc.BillingState ='UK';
            acc.BillingCountry = 'UK';
            acc.ShippingStreet ='test Street';
            acc.ShippingCountry='UK';
            acc.ShippingState ='UK';
            acc.Zoho_Customer_Id__c = '10777000005023458';
            insert acc;
             Contact contact = new Contact();
            contact.Id =String.valueof(contact.id);
            contact.FirstName = 'Alan';
            contact.LastName = 'MILLER';
            contact.Salutation = 'Mr';
            contact.Title = 'Director/Officer';
            contact.AccountId = acc.id;
            contact.KYCDB_Unique_Key_Contact__c = '192,193';
            contact.MailingCity ='Corby';
            contact.MailingStreet = '22 The Avenue';
            contact.MailingState ='Northamptonshire';
            contact.MailingPostalCode = 'NN17 5EE';
            contact.MailingCountry = 'UK';
            contact.OtherCity = 'Corby';
            contact.OtherCountry = 'UK';
            contact.OtherState = 'Northamptonshire';
            contact.OtherStreet = '22 The Avenue';
            contact.Email = 'test@example.com';
            contact.SAF_DOB_Month__c ='8';
            contact.SAF_DOB_Year__c ='1997';
            contact.SAF_Nationalities__c ='Indian';
            contact.OtherPostalCode ='NN17 5EE';
            contact.MobilePhone ='989786677';
            contact.HomePhone='7676564587';
            insert contact; 
            List<string> lst = new List<string>();
            lst.add('0011x00001ByXxJ');
            //lst.add('0011x00001ByXxJ');
            SAF_ContactsUtils.CreateContacts(json1, json3, json2, json);
            Test.stopTest();
    }
    
       public static testmethod void createContactPositivetest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        String json=        '['+
        '   {'+
        '      "id":192,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/vsM9MY8wksGP68hwNcYJoM-3sjk/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/_qas6k84dBcmaAN_odCLgr4Wx7A"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":null,'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Olive",'+
        '      "name":"PLATT, Olive",'+
        '      "officer_role":"director",'+
        '      "occupation":"Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/5I-_UOv_VCtza0PiCIPOKkY1Opo/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tzwLgAr5NJXkbrHONUSSPEIxnME"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":"Thomas",'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Raymond",'+
        '      "name":"PLATT, Raymond Thomas",'+
        '      "officer_role":"director",'+
        '      "occupation":"Managing Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '  {'+
        '      "id":196,'+
        '      "address":{'+
        '         "address_line_1":"6-8 Underwood Street",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":null,'+
        '         "postal_code":"N1 7JQ",'+
        '         "premises":null,'+
        '         "locality":"London",'+
        '         "registered_address_line1":"6-8 Underwood Street",'+
        '         "registered_city":"London",'+
        '         "registered_county":null,'+
        '         "registered_country":null,'+
        '         "registered_postcode":"N1 7JQ",'+
        '         "registered_address_premises":null,'+
        '         "registered_address_road":"6-8 Underwood Street"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":null,'+
        '         "year":null'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/kAoVxKbM1PDaLnVG72rJtSFL_ss/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tScRXPuSoQXO0vYUNH1gXx7UJys"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":"1993-04-20",'+
        '      "middle_name":"LIMITED",'+
        '      "title":null,'+
        '      "surname":"WATERLOW",'+
        '      "forename":"NOMINEES",'+
        '      "name":"WATERLOW NOMINEES LIMITED",'+
        '      "officer_role":"corporate-nominee-director",'+
        '      "occupation":null,'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":null,'+
        '      "nationality":null'+
        '   }'+
        ']';
        
        String json2=        '['+
        '        {'+
        '            "id": 86,'+
        '            "name": "Assetree Group 2 Ltd",'+
        '            "legal_entity_type": "Other",'+
        '            "legal_entity_type_id": "a4s3Y000000UBERQA4",'+
        '            "ownership": "Other",'+
        '            "parentCompany": 0,'+
        '            "bracket": null,'+
        '            "shareholder_perc": null,'+
        '            "nationality": null,'+
        '            "country_of_residence": null,'+
        '            "identification": {'+
        '                "country_registered": "England & Wales",'+
        '                "place_registered": "Companies House",'+
        '                "legal_authority": "Companies Act 2006",'+
        '                "legal_form": "Limited By Shares",'+
        '                "registration_number": "12659980"'+
        '            },'+
        '            "notified_on": "2020-08-07",'+
        '            "links": {'+
        '                "self": "/company/12741804/persons-with-significant-control/corporate-entity/UNFc68Hc2BmrzzkIdzw5wM75y4c",'+
        '                "officers": null,'+
        '                "charges": null,'+
        '                "filing_history": null'+
        '            },'+
        '            "kind": "corporate-entity-person-with-significant-control",'+
        '            "etag": "bc4eac59d722fd62f38225495f736f9a67451ed1",'+
        '            "address": {'+
        '                "address_line_1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "address_line_2": "Tavistock Square",'+
        '                "locality": "London",'+
        '                "country": "United Kingdom",'+
        '                "postal_code": "WC1H 9LG",'+
        '                "premises": "C/O Rayner Essex Llp",'+
        '                "region": null,'+
        '                "registered_address_line1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "registered_city": "London",'+
        '                "registered_county": null,'+
        '                "registered_country": "United Kingdom",'+
        '                "registered_postcode": "WC1H 9LG",'+
        '                "registered_address_premises": "C/O Rayner Essex Llp",'+
        '                "registered_address_road": "Tavistock House South"'+
        '            },'+
        '            "name_elements": null,'+
        '            "natures_of_control": ['+
        '                "ownership-of-shares-75-to-100-percent",'+
        '                "voting-rights-75-to-100-percent",'+
        '                "right-to-appoint-and-remove-directors"'+
        '            ],'+
        '            "date_of_birth": null,'+
        '            "cls_account_id": "0011x00001ByXSaAAN"'+
        '        }'+
        '        '+
        ']';
        String json3=        '['+
        '   {'+
        '      "id":192,'+
        '      "name":"Mrs Olive Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/n1AE6lXjNg5RTdLifzw_jZ8PUho",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"9d44dd70af8d68f2491b938d9cc8704da36101d6",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":null,'+
        '         "title":"Mrs",'+
        '         "surname":"Platt",'+
        '         "forename":"Olive"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "cls_account_id":null'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "name":"Mr Raymond Thomas Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/wR1rR3GR8v_XguVCvH7hlhMLaMA",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"5dd541c232cfb21c81e96dcf03480e5f6fba566a",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":"Thomas",'+
        '         "title":"Mr",'+
        '         "surname":"Platt",'+
        '         "forename":"Raymond"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "cls_account_id":null'+
        '   }'+
        ']';
        
      String json1=      '['+
        '   {'+
        '      "accName":"CORPORATE & PROFESSIONAL PENSIONS LIMITED",'+
        '      "accNumber":"02810635",'+
        '      "kycId":116,'+
        '      "billingStreet":"Unit 23 15 Jubilee Close",'+
        '      "billingCity":"Weymouth",'+
        '      "BillingState":null,'+
        '      "billingPostalCode":"DT4 7BS",'+
        '      "billingCountry":"United Kingdom",'+
        '      "sic_codes":"66290",'+
        '      "companyStatus":"Yes",'+
        '      "ownership":"Private Limited Company",'+
        '      "LegalEntity":"Limited Liability Company",'+
        '      "LegalEntiyId":"a4s0O000000CyQ9QAK"'+
        '   }'+
        ']';
  
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
        objSettings.AccessToken__c =null;
        objSettings.Username__c = 'Phalguni@hm.com';
        objSettings.Password__c = 'phalguni@123';
        objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
        objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account'; 
        objSettings.UpdateContactToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual';
        upsert objSettings;
            
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
        objSetting.client_id__c = 'Dummy client Id'; 
        objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSetting;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;      
             
        //Saf_ZohoAccounts.CreateInZoho(accountIdList, true);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='';
        acc.AccountNumber ='02810635';
        insert acc;
        Contact contact = new Contact();
        contact.Id =String.valueof(contact.id);
        contact.FirstName = 'Alan';
        contact.LastName = 'MILLER';
        contact.Salutation = 'Mr';
        contact.Title = 'Director/Officer';
        contact.AccountId = acc.id;
        contact.KYCDB_Unique_Key_Contact__c = '192';
        contact.MailingCity ='Corby';
        contact.MailingStreet = '22 The Avenue';
        contact.MailingState ='Northamptonshire';
        contact.MailingPostalCode = 'NN17 5EE';
        contact.MailingCountry = 'UK';
        contact.OtherCity = 'Corby';
        contact.OtherCountry = 'UK';
        contact.OtherState = 'Northamptonshire';
        contact.OtherStreet = '22 The Avenue';
        contact.Email = 'test@example.com';
        contact.SAF_DOB_Month__c ='8';
        contact.SAF_DOB_Year__c ='1997';
        contact.SAF_Nationalities__c ='Indian';
        contact.OtherPostalCode ='NN17 5EE';
        contact.MobilePhone ='989786677';
        contact.HomePhone='7676564587';
        insert contact; 
     
        List<string> lst = new List<string>();
        lst.add(acc.Id); //'0011x00001ByXxJ'
        lst.add(contact.Id); //'0011x00001ByXxJ'
        SAF_ContactsUtils.CreateContacts(json1, json3, json2, json);
        Test.stopTest();
    }
    
    public static testmethod void UpdateIndividualtest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateContactToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/individual';
            upsert objSettings;
            
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
        objSetting.client_id__c = 'Dummy client Id'; 
        objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSetting;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;   
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='';
        acc.AccountNumber='06625914';
        acc.Sic ='0000';
        acc.Type = 'Account';
        acc.UK_Region__c ='0000';
        acc.Phone='9898787656';
        acc.clcommon__Email__c ='test@example.com';
        acc.Ownership='Private Limited Company';
        acc.BillingStreet ='test Street';
        acc.BillingState ='UK';
        acc.BillingCountry = 'UK';
        acc.ShippingStreet ='test Street';
        acc.ShippingCountry='UK';
        acc.ShippingState ='UK';
        acc.Zoho_Customer_Id__c = '10777000005023458';
        acc.Registered_Address_Premises__c = 'test';
        acc.Registered_Address_Road__c = 'test';
        acc.Trading_Address_Premises__c = 'test';
        acc.Trading_Address_Road__c = 'test';
        acc.Saf_LastName__c = 'Mitchelmore';
        acc.Saf_FIrstName__c ='Shrew test';
        acc.Saf_MiddleName__c = 'Danielle';
        acc.Saf_Title__c = 'Mr';
        acc.Month_of_Birth__c = '11';
        acc.Birth_Year__c = '1974';
        acc.Saf_Occupation__c = 'testOccupation';
        acc.Saf_Nationality__c = 'British';
        insert acc;
        Account  updateAcc = [SELECT Id,Name,cllease__Active__c,BillingStreet FROM Account LIMIT 1];
            updateAcc.cllease__Active__c = 'Yes';
        	updateAcc.BillingStreet = 'test';
        	updateAcc.Name = 'Test';
            updateAcc.BillingPostalCode = 'BD1 1CA';
            updateAcc.BillingCity = 'UK';
        	updateAcc.BillingStreet ='test';
            updateAcc.BillingCountry = 'US';
            updateAcc.BillingState='london';
            updateAcc.Landline__c='12345 123466';
            updateAcc.KYCDB_Unique_Key_Account__c='192';
            updateAcc.AccountNumber='06625915';
            updateAcc.Sic ='0001';
            updateAcc.Type = 'Acc';
            updateAcc.UK_Region__c ='0001';
            updateAcc.Phone='9898787655';
            updateAcc.clcommon__Email__c ='testnew@example.com';
            updateAcc.Ownership='Private Limited';
            updateAcc.ShippingPostalCode = 'BD1 1CA';
            updateAcc.ShippingCity = 'UK';
            updateAcc.ShippingStreet ='test Strett';
            updateAcc.ShippingCountry='US';
            updateAcc.ShippingState ='US';
            updateAcc.Zoho_Customer_Id__c = '10777000005023888';
        	updateAcc.Watchlist_Active__c =true;
            updateAcc.Saf_Title__c ='Mrss';
            updateAcc.SSID__c='123';
            updateAcc.Trading_Address_Premises__c='abc';
            updateAcc.Trading_Address_Road__c='Street';
            updateAcc.Registered_Address_Premises__c='New Street';
            updateAcc.Registered_Address_Road__c ='Street';
            updateAcc.Saf_LastName__c='test';
            updateAcc.Saf_FIrstName__c='testNew';
            updateAcc.Saf_MiddleName__c='New';
            updateAcc.Month_of_Birth__c='10';
            updateAcc.Birth_Year__c='1999';
            //updateAcc.Date_Of_Birth__c='';
            updateAcc.Saf_Occupation__c='Accountant';
            updateAcc.Saf_Nationality__c='India';
            update updateAcc;
     
        List<string> updateAccList = new List<string>();
        updateAccList.add(acc.Id); //'0011x00001ByXxJ'
        SAF_ContactsUtils.UpdateIndividual(updateAccList);
        Test.stopTest();
    }
    
     /* public static testmethod void createcontactstest2()
    {
    //give existing account in salesforce
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        String json=        '['+
        '   {'+
        '      "id":192,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/vsM9MY8wksGP68hwNcYJoM-3sjk/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/_qas6k84dBcmaAN_odCLgr4Wx7A"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":null,'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Olive",'+
        '      "name":"PLATT, Olive",'+
        '      "officer_role":"director",'+
        '      "occupation":"Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/5I-_UOv_VCtza0PiCIPOKkY1Opo/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tzwLgAr5NJXkbrHONUSSPEIxnME"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":"Thomas",'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Raymond",'+
        '      "name":"PLATT, Raymond Thomas",'+
        '      "officer_role":"director",'+
        '      "occupation":"Managing Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '  {'+
        '      "id":196,'+
        '      "address":{'+
        '         "address_line_1":"6-8 Underwood Street",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":null,'+
        '         "postal_code":"N1 7JQ",'+
        '         "premises":null,'+
        '         "locality":"London",'+
        '         "registered_address_line1":"6-8 Underwood Street",'+
        '         "registered_city":"London",'+
        '         "registered_county":null,'+
        '         "registered_country":null,'+
        '         "registered_postcode":"N1 7JQ",'+
        '         "registered_address_premises":null,'+
        '         "registered_address_road":"6-8 Underwood Street"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":null,'+
        '         "year":null'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/kAoVxKbM1PDaLnVG72rJtSFL_ss/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tScRXPuSoQXO0vYUNH1gXx7UJys"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":"1993-04-20",'+
        '      "middle_name":"LIMITED",'+
        '      "title":null,'+
        '      "surname":"WATERLOW",'+
        '      "forename":"NOMINEES",'+
        '      "name":"WATERLOW NOMINEES LIMITED",'+
        '      "officer_role":"corporate-nominee-director",'+
        '      "occupation":null,'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":null,'+
        '      "nationality":null'+
        '   }'+
        ']';
        
        String json2= '['+
        '        {'+
        '            "id": 86,'+
        '            "name": "Assetree Group 2 Ltd",'+
        '            "legal_entity_type": "Other",'+
        '            "legal_entity_type_id": "a4s3Y000000UBERQA4",'+
        '            "ownership": "Other",'+
        '            "parentCompany": 0,'+
        '            "bracket": null,'+
        '            "shareholder_perc": null,'+
        '            "nationality": null,'+
        '            "country_of_residence": null,'+
        '            "identification": {'+
        '                "country_registered": "England & Wales",'+
        '                "place_registered": "Companies House",'+
        '                "legal_authority": "Companies Act 2006",'+
        '                "legal_form": "Limited By Shares",'+
        '                "registration_number": "12659980"'+
        '            },'+
        '            "notified_on": "2020-08-07",'+
        '            "links": {'+
        '                "self": "/company/12741804/persons-with-significant-control/corporate-entity/UNFc68Hc2BmrzzkIdzw5wM75y4c",'+
        '                "officers": null,'+
        '                "charges": null,'+
        '                "filing_history": null'+
        '            },'+
        '            "kind": "corporate-entity-person-with-significant-control",'+
        '            "etag": "bc4eac59d722fd62f38225495f736f9a67451ed1",'+
        '            "address": {'+
        '                "address_line_1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "address_line_2": "Tavistock Square",'+
        '                "locality": "London",'+
        '                "country": "United Kingdom",'+
        '                "postal_code": "WC1H 9LG",'+
        '                "premises": "C/O Rayner Essex Llp",'+
        '                "region": null,'+
        '                "registered_address_line1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "registered_city": "London",'+
        '                "registered_county": null,'+
        '                "registered_country": "United Kingdom",'+
        '                "registered_postcode": "WC1H 9LG",'+
        '                "registered_address_premises": "C/O Rayner Essex Llp",'+
        '                "registered_address_road": "Tavistock House South"'+
        '            },'+
        '            "name_elements": null,'+
        '            "natures_of_control": ['+
        '                "ownership-of-shares-75-to-100-percent",'+
        '                "voting-rights-75-to-100-percent",'+
        '                "right-to-appoint-and-remove-directors"'+
        '            ],'+
        '            "date_of_birth": null,'+
        '            "cls_account_id": "0011x00001ByXSaAAN"'+
        '        }'+
        '        '+
        ']';
        
        
        String json3=        '['+
        '   {'+
        '      "id":192,'+
        '      "name":"Mrs Olive Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/n1AE6lXjNg5RTdLifzw_jZ8PUho",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"9d44dd70af8d68f2491b938d9cc8704da36101d6",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":null,'+
        '         "title":"Mrs",'+
        '         "surname":"Platt",'+
        '         "forename":"Olive"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "cls_account_id":null'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "name":"Mr Raymond Thomas Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/wR1rR3GR8v_XguVCvH7hlhMLaMA",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"5dd541c232cfb21c81e96dcf03480e5f6fba566a",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":"Thomas",'+
        '         "title":"Mr",'+
        '         "surname":"Platt",'+
        '         "forename":"Raymond"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "cls_account_id":null'+
        '   }'+
        ']';
        
      String json1=      '['+
        '   {'+
        '      "accName":"CORPORATE00000",'+
        '      "accNumber":"000001",'+
        '      "kycId":116,'+
        '      "billingStreet":"Unit 23 15 Jubilee Close",'+
        '      "billingCity":"Weymouth",'+
        '      "BillingState":null,'+
        '      "billingPostalCode":"DT4 7BS",'+
        '      "billingCountry":"United Kingdom",'+
        '      "sic_codes":"66290",'+
        '      "companyStatus":"Yes",'+
        '      "ownership":"Private Limited Company",'+
        '      "LegalEntity":"Limited Liability Company",'+
        '      "LegalEntiyId":"a4s0O000000CyQ9QAK"'+
        '   }'+
        ']';
  
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
           objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account'; 
        upsert objSettings;
            
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
        objSetting.client_id__c = 'Dummy client Id'; 
        objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSetting;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;      
          
        //Saf_ZohoAccounts.CreateInZoho(accountIdList, true);
          
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());  
        // Set mock callout class 
       // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
            insert legal;
         Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='151';
        //acc.AccountNumber='06625914';
        //acc.ky
        insert acc;
        List<string> lst = new List<string>();
        lst.add(acc.Id);//0011x00001ByXxJ
        SAF_ContactsUtils.CreateContacts(json1, json3,json2 , json);
        //CreateContacts(String CRNDetail, string cIndividual, string cCorporate, string cOfficers )
        Test.stopTest();
    } */
 /*   public static testmethod void parseAccountUpdateDb()
    {
       RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
         req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        String json= '['+
   '{'+
        '"id":11738,'+
      '"cls_account_id":"0011x00001CIKDrAAP"'+
  ' },'+
   '{'+
        '"id":11739,'+
      '"cls_account_id":"0011x00001CIKDsAAPP"'+
   '}'+
            ']';
             
             
         req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
        objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
        objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
           objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account'; 
        upsert objSettings;
            
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
        objSetting.client_id__c = 'Dummy client Id'; 
        objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSetting;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;      
          
        //Saf_ZohoAccounts.CreateInZoho(accountIdList, true);
          
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());  
       
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
            insert legal;
         Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='151';
        //acc.AccountNumber='06625914';
        //acc.ky
        insert acc;

        KYCResponse.parseAccountUpdate(json);
        
        Test.stopTest();
    
    }*/
    
       public static testmethod void updateContactsfromDBtest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        String json=        '['+
        '   {'+
        '      "id":192,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/vsM9MY8wksGP68hwNcYJoM-3sjk/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/_qas6k84dBcmaAN_odCLgr4Wx7A"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":null,'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Olive",'+
        '      "name":"PLATT, Olive",'+
        '      "officer_role":"director",'+
        '      "occupation":"Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "locality":"Weymouth",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/5I-_UOv_VCtza0PiCIPOKkY1Opo/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tzwLgAr5NJXkbrHONUSSPEIxnME"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":null,'+
        '      "middle_name":"Thomas",'+
        '      "title":null,'+
        '      "surname":"PLATT",'+
        '      "forename":"Raymond",'+
        '      "name":"PLATT, Raymond Thomas",'+
        '      "officer_role":"director",'+
        '      "occupation":"Managing Director",'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "nationality":"British"'+
        '   },'+
        '  {'+
        '      "id":196,'+
        '      "address":{'+
        '         "address_line_1":"6-8 Underwood Street",'+
        '         "address_line_2":null,'+
        '         "region":null,'+
        '         "country":null,'+
        '         "postal_code":"N1 7JQ",'+
        '         "premises":null,'+
        '         "locality":"London",'+
        '         "registered_address_line1":"6-8 Underwood Street",'+
        '         "registered_city":"London",'+
        '         "registered_county":null,'+
        '         "registered_country":null,'+
        '         "registered_postcode":"N1 7JQ",'+
        '         "registered_address_premises":null,'+
        '         "registered_address_road":"6-8 Underwood Street"'+
        '      },'+
        '      "date_of_birth":{'+
        '         "month":null,'+
        '         "year":null'+
        '      },'+
        '      "links":{'+
        '         "officer":{'+
        '            "appointments":"/officers/kAoVxKbM1PDaLnVG72rJtSFL_ss/appointments"'+
        '         },'+
        '         "self":"/company/02810635/appointments/tScRXPuSoQXO0vYUNH1gXx7UJys"'+
        '      },'+
        '      "appointed_on":"1993-04-20",'+
        '      "resigned_on":"1993-04-20",'+
        '      "middle_name":"LIMITED",'+
        '      "title":null,'+
        '      "surname":"WATERLOW",'+
        '      "forename":"NOMINEES",'+
        '      "name":"WATERLOW NOMINEES LIMITED",'+
        '      "officer_role":"corporate-nominee-director",'+
        '      "occupation":null,'+
        '      "source_data_system":"Company House",'+
        '      "created_on":"2021-02-11",'+
        '      "country_of_residence":null,'+
        '      "nationality":null'+
        '   }'+
        ']';
        
        String json2=        '['+
        '        {'+
        '            "id": 86,'+
        '            "name": "Assetree Group 2 Ltd",'+
        '            "legal_entity_type": "Other",'+
        '            "legal_entity_type_id": "a4s3Y000000UBERQA4",'+
        '            "ownership": "Other",'+
        '            "parentCompany": 0,'+
        '            "bracket": null,'+
        '            "shareholder_perc": null,'+
        '            "nationality": null,'+
        '            "country_of_residence": null,'+
        '            "identification": {'+
        '                "country_registered": "England & Wales",'+
        '                "place_registered": "Companies House",'+
        '                "legal_authority": "Companies Act 2006",'+
        '                "legal_form": "Limited By Shares",'+
        '                "registration_number": "12659980"'+
        '            },'+
        '            "notified_on": "2020-08-07",'+
        '            "links": {'+
        '                "self": "/company/12741804/persons-with-significant-control/corporate-entity/UNFc68Hc2BmrzzkIdzw5wM75y4c",'+
        '                "officers": null,'+
        '                "charges": null,'+
        '                "filing_history": null'+
        '            },'+
        '            "kind": "corporate-entity-person-with-significant-control",'+
        '            "etag": "bc4eac59d722fd62f38225495f736f9a67451ed1",'+
        '            "address": {'+
        '                "address_line_1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "address_line_2": "Tavistock Square",'+
        '                "locality": "London",'+
        '                "country": "United Kingdom",'+
        '                "postal_code": "WC1H 9LG",'+
        '                "premises": "C/O Rayner Essex Llp",'+
        '                "region": null,'+
        '                "registered_address_line1": "C/O Rayner Essex Llp,Tavistock House South",'+
        '                "registered_city": "London",'+
        '                "registered_county": null,'+
        '                "registered_country": "United Kingdom",'+
        '                "registered_postcode": "WC1H 9LG",'+
        '                "registered_address_premises": "C/O Rayner Essex Llp",'+
        '                "registered_address_road": "Tavistock House South"'+
        '            },'+
        '            "name_elements": null,'+
        '            "natures_of_control": ['+
        '                "ownership-of-shares-75-to-100-percent",'+
        '                "voting-rights-75-to-100-percent",'+
        '                "right-to-appoint-and-remove-directors"'+
        '            ],'+
        '            "date_of_birth": null,'+
        '            "cls_account_id": "0011x00001ByXSaAAN"'+
        '        }'+
        '        '+
        ']';
        String json3=        '['+
        '   {'+
        '      "id":192,'+
        '      "name":"Mrs Olive Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/n1AE6lXjNg5RTdLifzw_jZ8PUho",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"9d44dd70af8d68f2491b938d9cc8704da36101d6",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":null,'+
        '         "title":"Mrs",'+
        '         "surname":"Platt",'+
        '         "forename":"Olive"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"8",'+
        '         "year":"1953"'+
        '      },'+
        '      "cls_account_id":null'+
        '   },'+
        '   {'+
        '      "id":193,'+
        '      "name":"Mr Raymond Thomas Platt",'+
        '      "legal_entity_type":null,'+
        '      "legal_entity_type_id":null,'+
        '      "ownership":null,'+
        '      "parentCompany":0,'+
        '      "bracket":null,'+
        '      "shareholder_perc":null,'+
        '      "nationality":"British",'+
        '      "country_of_residence":"United Kingdom",'+
        '      "identification":null,'+
        '      "notified_on":"2016-04-06",'+
        '      "links":{'+
        '         "self":"/company/02810635/persons-with-significant-control/individual/wR1rR3GR8v_XguVCvH7hlhMLaMA",'+
        '         "officers":null,'+
        '         "charges":null,'+
        '         "filing_history":null'+
        '      },'+
        '      "kind":"individual-person-with-significant-control",'+
        '      "etag":"5dd541c232cfb21c81e96dcf03480e5f6fba566a",'+
        '      "address":{'+
        '         "address_line_1":"Flat 2 Garden Court,Greenhill",'+
        '         "address_line_2":null,'+
        '         "locality":"Weymouth",'+
        '         "country":"England",'+
        '         "postal_code":"DT4 7SW",'+
        '         "premises":"Flat 2 Garden Court",'+
        '         "region":"Dorset",'+
        '         "registered_address_line1":"Flat 2 Garden Court,Greenhill",'+
        '         "registered_city":"Weymouth",'+
        '         "registered_county":null,'+
        '         "registered_country":"England",'+
        '         "registered_postcode":"DT4 7SW",'+
        '         "registered_address_premises":"Flat 2 Garden Court",'+
        '         "registered_address_road":"Greenhill"'+
        '      },'+
        '      "name_elements":{'+
        '         "middle_name":"Thomas",'+
        '         "title":"Mr",'+
        '         "surname":"Platt",'+
        '         "forename":"Raymond"'+
        '      },'+
        '      "natures_of_control":['+
        '         "ownership-of-shares-25-to-50-percent",'+
        '         "voting-rights-25-to-50-percent"'+
        '      ],'+
        '      "date_of_birth":{'+
        '         "month":"2",'+
        '         "year":"1947"'+
        '      },'+
        '      "cls_account_id":null'+
        '   }'+
        ']';
        
      String json1=      '['+
        '   {'+
        '      "accName":"CORPORATE & PROFESSIONAL PENSIONS LIMITED",'+
        '      "accNumber":"02810635",'+
        '      "kycId":116,'+
        '      "billingStreet":"Unit 23 15 Jubilee Close",'+
        '      "billingCity":"Weymouth",'+
        '      "BillingState":null,'+
        '      "billingPostalCode":"DT4 7BS",'+
        '      "billingCountry":"United Kingdom",'+
        '      "sic_codes":"66290",'+
        '      "companyStatus":"Yes",'+
        '      "ownership":"Private Limited Company",'+
        '      "LegalEntity":"Limited Liability Company",'+
        '      "LegalEntiyId":"a4s0O000000CyQ9QAK"'+
        '   }'+
        ']';
  
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
        Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account'; 
            objSettings.UpdateContactToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual';
        upsert objSettings;
            
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
        objSetting.client_id__c = 'Dummy client Id'; 
        objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSetting;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;      
             
        //Saf_ZohoAccounts.CreateInZoho(accountIdList, true);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Saf_ZohoAccounts_Mock());
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
        insert legal;
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'London';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'London';
        acc.Landline__c='12345 123456';
        acc.KYCDB_Unique_Key_Account__c='{192,193,196}';
        acc.AccountNumber ='02810635';
        insert acc;
        Contact contact = new Contact();

        contact.FirstName = 'Alan';
        contact.LastName = 'MILLER';
        contact.Salutation = 'Mr';
        contact.Title = 'Director/Officer';
        contact.AccountId = acc.id;
        contact.KYCDB_Unique_Key_Contact__c = '{192,193,196}';
        contact.MailingCity ='Corby';
        contact.MailingStreet = '22 The Avenue';
        contact.MailingState ='Northamptonshire';
        contact.MailingPostalCode = 'NN17 5EE';
        contact.MailingCountry = 'UK';
        contact.OtherCity = 'Corby';
        contact.OtherCountry = 'UK';
        contact.OtherState = 'Northamptonshire';
        contact.OtherStreet = '22 The Avenue';
        contact.Email = 'test@example.com';
        contact.SAF_DOB_Month__c ='8';
        contact.SAF_DOB_Year__c ='1997';
        contact.SAF_Nationalities__c ='Indian';
        contact.OtherPostalCode ='NN17 5EE';
        contact.MobilePhone ='989786677';
        contact.HomePhone='7676564587';
        insert contact; 
        system.debug('contact id::::'+contact.Id);
        List<string> lst = new List<string>();
        lst.add(acc.Id); //'0011x00001ByXxJ'
        lst.add(contact.Id); //'0011x00001ByXxJ'
        SAF_ContactsUtils.updateContactsfromDB(json1, json3, json2, json);
        Test.stopTest();
    }

     public static testmethod void insertIndividualinDBTest()
    {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/company/gb/10672557/group-parents';
        req.httpMethod = 'GET';
        
        RestContext.request=req;
        RestContext.response=res;
         Saf_CompanyHouse__c objSettings =  Saf_CompanyHouse__c.getOrgDefaults();
            objSettings.AccessToken__c =null;
            objSettings.Username__c = 'Phalguni@hm.com';
            objSettings.Password__c = 'phalguni@123';
            objSettings.LoginURL__c = 'http://kycapiprod.simply.finance:9090/api/kyc/login';
            objSettings.EditCustomerUpdateToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateIndividualIdToDB__c = 'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';
            objSettings.UpdateCustomerToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/account';
            objSettings.UpdateContactToDB__c = 'http://51.140.35.4:9091/api/kyc/v1/system/integration/individual';
            upsert objSettings;
            
        saf_zoho__c objSetting = saf_zoho__c.getOrgDefaults();
        objSetting.client_id__c = 'Dummy client Id'; 
        objSetting.zoho_CretaAccEndpoint__c = 'dummy_Access_Endpoint';
        UPSERT objSetting;
        Saf_ZohoFieldMapping__c zohomapping =Saf_ZohoFieldMapping__c.getOrgDefaults(); 
        zohomapping.Salesforce_Field__c='rrrrr';
        zohomapping.Zoho_Fields__c='sss';
        zohomapping.Name='duplicateName';
        UPSERT zohomapping;   
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Individual');
        insert legal;
  
        Account acc = new Account();
        acc.clcommon__Legal_Entity_Type__c = legal.id;
        acc.Name = 'TestAccount';
        acc.Type = 'Account';
        acc.UK_Region__c ='0000';
        acc.Phone='9898787656';
        acc.clcommon__Email__c ='test@example.com';
        acc.Ownership='Individual';
        acc.KYCDB_Unique_Key_Account__c='{192,193}';
        acc.Sic = '100';
        insert acc;
        
      List<string> lst = new List<string>();
        lst.add(acc.Id); //'0011x00001ByXxJ'
        //lst.add(contact.Id); //'0011x00001ByXxJ'
        SAF_ContactsUtils.insertIndividualinDB(lst);
        Test.stopTest();
    }
    
      private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'your Json Response';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
}