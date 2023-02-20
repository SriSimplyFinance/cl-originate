global class SAF_ContactsUtils {

    static Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
    public static boolean TokenExpired = false;
    Public static Boolean runTrigger=true;

    webservice static void UpdateContactToDB(List<string> contkycid){
        //create contact in db when created in cl
        system.debug('contkycid:::'+contkycid);
        List < Contact > cont = [SELECT AccountId,CreatedDate,FirstName,Id,KYCDB_Unique_Key_Contact__c,LastName,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,
                                 SAF_DOB_Month__c,SAF_DOB_Year__c,SAF_Nationalities__c,Salutation,OtherStreet,OtherCity,OtherPostalCode,OtherCountry,OtherState,MobilePhone,HomePhone,Email FROM Contact WHERE Id =:contkycid];

        system.debug('UpdateContactToDB cont::::' + cont);
        system.debug('cont.size():' + cont.size());

        if(cont.size() > 0){
            system.debug('Inside if condition' + cont.size());
            for(Contact con: cont){
                String conatctjson;

                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartArray();
                gen.writeStartObject();
                gen.writeStringField('cls_account_id', con.Id);

                if(String.isNotBlank(con.KYCDB_Unique_Key_Contact__c)){
                    gen.writeStringField('id', con.KYCDB_Unique_Key_Contact__c);
                }
                if(String.isNotBlank(con.MailingStreet)){
                    gen.writeStringField('registered_address_line1', con.MailingStreet);
                }
                if(String.isNotBlank(con.MailingCity)){
                    gen.writeStringField('registered_city', con.MailingCity);
                }
                if(String.isNotBlank(con.MailingPostalCode)){
                    gen.writeStringField('registered_postcode', con.MailingPostalCode);
                }
                if(String.isNotBlank(con.MailingCountry)){
                    gen.writeStringField('registered_country', con.MailingCountry);
                }
                if(String.isNotBlank(con.MailingState)){
                    gen.writeStringField('registered_county', con.MailingState);
                }
                if(String.isNotBlank(con.OtherStreet)){
                    gen.writeStringField('trading_address_line1', con.OtherStreet);
                }
                if(String.isNotBlank(con.OtherCity)){
                    gen.writeStringField('trading_city', con.OtherCity);
                }
                if(String.isNotBlank(con.OtherPostalCode)){
                    gen.writeStringField('trading_postcode', con.OtherPostalCode);
                }
                if(String.isNotBlank(con.OtherCountry)){
                    gen.writeStringField('trading_country', con.OtherCountry);
                }
                if(String.isNotBlank(con.OtherState)){
                    gen.writeStringField('trading_county', con.OtherState);
                }
                if(String.isNotBlank(con.Salutation)){
                    gen.writeStringField('title', con.Salutation);
                }
                if(String.isNotBlank(con.LastName)){
                    gen.writeStringField('surname', con.LastName);
                }
                if(String.isNotBlank(con.FirstName)){
                    gen.writeStringField('forename', con.FirstName);
                }
                if(String.isNotBlank(con.MobilePhone)){
                    gen.writeStringField('mobile_phone', con.MobilePhone);
                }
                if(String.isNotBlank(con.HomePhone)){
                    gen.writeStringField('landline', con.HomePhone);
                }
                if(String.isNotBlank(con.Email)){
                    gen.writeStringField('email', con.Email);
                }
                if(String.isNotBlank(con.SAF_DOB_Month__c)){
                    gen.writeStringField('date_of_birth_month', con.SAF_DOB_Month__c);
                }
                if(String.isNotBlank(con.SAF_DOB_Year__c)){
                    gen.writeStringField('date_of_birth_year', con.SAF_DOB_Year__c);
                }

                gen.writeEndObject();
                gen.writeEndArray();
                conatctjson = gen.getAsString();

                System.debug('conatctjson-' + conatctjson);
                if(String.isNotBlank(conatctjson)){
                    calloutContact(conatctjson);
                }
            }
        }
    }

    //Update customer details to kycDB
    webservice static String UpdateContacts(List<String> updateAccountsList) {
       
         Account  acc = [SELECT Id, Name, AccountNumber, KYCDB_Unique_Key_Account__c,BillingStreet,BillingCity,BillingPostalCode, BillingCountry,BillingState,SAF_latestAccountsDate__c, SAF_filingType__c, Sic, cllease__Active__c,
                                 ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Zoho_Customer_Id__c,UK_Region__c,Phone,Landline__c,clcommon__Email__c,Ownership,Registered_Address_Premises__c, Registered_Address_Road__c, Trading_Address_Premises__c, Trading_Address_Road__c,clcommon__Legal_Entity_Type__c,clcommon__Legal_Entity_Type__r.name,Watchlist_Active__c,Aggregate__c,SSID__c,Saf_Title__c FROM Account WHERE id =:updateAccountsList limit 1 ];
            String jsonData;
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('cls_account_id', acc.Id);
            if(String.isNotBlank(acc.name)){
                    gen.writeStringField('company_name', acc.name);
            }
           if(String.isNotBlank(acc.AccountNumber)){
                    gen.writeStringField('company_number', acc.AccountNumber); }else{  gen.writeStringField('company_number', '');
                }
            if(String.isNotBlank(acc.KYCDB_Unique_Key_Account__c)){
                    gen.writeStringField('id', acc.KYCDB_Unique_Key_Account__c);
            }
            if(acc.cllease__Active__c=='Yes'){
                        gen.writeStringField('company_status', 'active');
                    }else{
                        gen.writeStringField('company_status', '');
                    }
                    
            if(String.isNotBlank(acc.BillingStreet)){
                        gen.writeStringField('registered_address_line1', acc.BillingStreet);}else{  gen.writeStringField('registered_address_line1', '');
                    }
            if(String.isNotBlank(acc.BillingCity)){
                        gen.writeStringField('registered_city', acc.BillingCity);   }else{  gen.writeStringField('registered_city', '');
                    }
                    if(String.isNotBlank(acc.BillingState)){
                        gen.writeStringField('registered_county', acc.BillingState);
                    }else{
                        gen.writeStringField('registered_county', '');
                    }
            if(String.isNotBlank(acc.BillingPostalCode)){
                        gen.writeStringField('registered_postcode', acc.BillingPostalCode);}else{   gen.writeStringField('registered_postcode', '');
                    }
            if(String.isNotBlank(acc.BillingCountry)){
                        gen.writeStringField('registered_country', acc.BillingCountry);}else{ gen.writeStringField('registered_country', '');
                    }
            if(String.isNotBlank(acc.Registered_Address_Premises__c)){  gen.writeStringField('registered_address_premises', acc.Registered_Address_Premises__c);
                    }else{
                        gen.writeStringField('registered_address_premises', '');
                    }
            if(String.isNotBlank(acc.Registered_Address_Road__c)){gen.writeStringField('registered_address_road', acc.Registered_Address_Road__c);
                    }else{
                        gen.writeStringField('registered_address_road', '');
                    }
            if(String.isNotBlank(acc.ShippingStreet)){
                        gen.writeStringField('trading_address_line1', acc.ShippingStreet);
                    }else{
                        gen.writeStringField('trading_address_line1', '');
                    }
            if(String.isNotBlank(acc.ShippingCity)){
                        gen.writeStringField('trading_city', acc.ShippingCity);
                    }else{
                        gen.writeStringField('trading_city', '');
                    }
            if(String.isNotBlank(acc.ShippingState)){
                        gen.writeStringField('trading_county', acc.ShippingState);
                    }else{
                        gen.writeStringField('trading_county', '');
                    }
            if(String.isNotBlank(acc.ShippingPostalCode)){
                        gen.writeStringField('trading_postcode', acc.ShippingPostalCode);
                    }else{
                        gen.writeStringField('trading_postcode', '');
                    }
            if(String.isNotBlank(acc.ShippingCountry)){
                        gen.writeStringField('trading_country', acc.ShippingCountry);
                    }else{
                        gen.writeStringField('trading_country', '');
                    }
            if(String.isNotBlank(acc.Trading_Address_Premises__c)){  gen.writeStringField('trading_address_premises', acc.Trading_Address_Premises__c);
                    }else{
                        gen.writeStringField('trading_address_premises', '');
                    }
            if(String.isNotBlank(acc.Trading_Address_Road__c)){ gen.writeStringField('trading_address_road', acc.Trading_Address_Road__c);
                    }else{
                        gen.writeStringField('trading_address_road', '');
                    }
            if(String.isNotBlank(acc.Sic)){
                        gen.writeStringField('sic_code', acc.Sic); }else{gen.writeStringField('sic_code', '');
                    }
            if(String.isNotBlank(acc.Zoho_Customer_Id__c)){
                        gen.writeStringField('zoho_account_id', acc.Zoho_Customer_Id__c);
                    }else{
                        gen.writeStringField('zoho_account_id', '');
                    }
            if(String.isNotBlank(acc.UK_Region__c)){
                        gen.writeStringField('nuts_code', acc.UK_Region__c);
                    }else{
                        gen.writeStringField('nuts_code', '');
                    }
            if(String.isNotBlank(acc.Phone)){
                        gen.writeStringField('mobile_phone', acc.Phone);
                    }else{
                        gen.writeStringField('mobile_phone', '');
                    }
            if(String.isNotBlank(acc.Landline__c)){
                        gen.writeStringField('landline', acc.Landline__c);
                    }else{
                        gen.writeStringField('landline', '');
                    }
            if(String.isNotBlank(acc.clcommon__Email__c)){
                        gen.writeStringField('email', acc.clcommon__Email__c);
                    }else{
                        gen.writeStringField('email', '');
                    }
            if(String.isNotBlank(acc.Ownership)){
                        gen.writeStringField('ownership', acc.Ownership);
                    }else{
                        gen.writeStringField('ownership', '');
                    }
            if(String.isNotBlank(acc.clcommon__Legal_Entity_Type__r.name)){
                        gen.writeStringField('legal_entity_type', acc.clcommon__Legal_Entity_Type__r.name);
                    }else{
                        gen.writeStringField('legal_entity_type', '');
                    }
            if(String.isNotBlank(acc.SSID__c)){
                        gen.writeStringField('ssid', acc.SSID__c);
                    }else{
                        gen.writeStringField('ssid', '');
                    }
            if(String.isNotBlank(acc.Saf_Title__c)){
                        gen.writeStringField('title', acc.Saf_Title__c);
                    }else{
                        gen.writeStringField('title', '');
                    }
            if(String.isNotBlank(String.valueOf(acc.Watchlist_Active__c))){
                        gen.writeStringField('watch_list', String.valueOf(acc.Watchlist_Active__c));
                    }else{
                        gen.writeStringField('watch_list', '');
                    }
            gen.writeEndObject();
            gen.writeEndArray();
            jsonData = gen.getAsString();
            if(String.isNotBlank(jsonData)){
                calloutExistingCustomer(jsonData);
            }
        
        return 'Success';
    }

    //Create customer, shareholder and officers
    webservice static String CreateContacts(String CRNDetail, string cIndividual, string cCorporate, string cOfficers ) {

        string returnmsg = 'Success';

        // pass relationship API response into above method and pass the same to class called at end of method,String CRN, string kycid, string Relationresp
        Contact cont;
        Account accnt;
        Map < String, Object > obj = new Map < String, Object > ();
        Set < String > contactNum = new Set < String > ();
        Set < String > Updateset = new Set < String > ();
        Set < String > Createset = new Set < String > ();
        List < Account > newcontact = new List < Account > ();

        Map < String, Object > obj2 = new Map < String, Object > ();
        Set < String > officerNum = new Set < String > ();
        Set < String > UpdateOfficerset = new Set < String > ();
        Set < String > CreateOfficerset = new Set < String > ();
        List < Account > newOfficer = new List < Account > ();

        Set < String > corporateNum = new Set < String > ();
        Set < String > UpdateCorpset = new Set < String > ();
        Set < String > CreateCorpset = new Set < String > ();
        List < Account > newCorpAcc = new List < Account > ();

        System.debug('CRN:' + CRNDetail + 'cIndividual:' + cIndividual + 'cCorporate:' + cCorporate+ 'cOfficers:'+cOfficers);

        // Checking CRN and upsert Account 
        List < Object > crnDtl = (List < Object > ) JSON.deserializeuntyped(CRNDetail);
        system.debug('crnDtl::'+crnDtl[0]);
        string accNumber;
        string accName; 
        string ownership; 
        string companyStatus; 
        string filingType; 
        string latestAccountsDate; 
        string sic; 
        string billingPostalCode; 
        string billingCity; 
        string billingCountry; 
        string billingStreet; 
        string kycId; 
        string BillingState;
        string LegalEntity;
        String LegalEntityID;
        String RegAddressRoad;
        String RegAddressPremises;

        for (Object cDtl: crnDtl) {
            Map < String, Object > cData= (Map < String, Object > ) cDtl;
            kycId = String.valueof(cData.get('kycId'));
            accNumber = String.valueof(cData.get('accNumber'));
            accName = String.valueof(cData.get('accName'));
            ownership = String.valueof(cData.get('ownership'));
            companyStatus = String.valueof(cData.get('companyStatus'));
            system.debug('companystatus:'+ cData.get('companyStatus'));
            filingType = String.valueof(cData.get('filingType'));
            latestAccountsDate = String.valueof(cData.get('latestAccountsDate'));
            billingPostalCode = String.valueof(cData.get('billingPostalCode'));
            billingCity = String.valueof(cData.get('billingCity'));
            billingCountry = String.valueof(cData.get('billingCountry'));
            billingStreet = String.valueof(cData.get('billingStreet'));
            sic = String.valueof(cData.get('sic_codes'));
            BillingState = String.valueof(cData.get('BillingState'));
            LegalEntity = String.valueof(cData.get('LegalEntity'));
            LegalEntityID = String.valueof(cData.get('LegalEntiyId'));
            RegAddressRoad = String.valueof(cData.get('RegAddressRoad'));
            RegAddressPremises = String.valueof(cData.get('RegAddressPremises'));

            system.debug('RegAddressRoad :::' +RegAddressRoad );
            system.debug('data from skuid:::' +cData);

        }
        Id accid;

        List < Account > acct = [SELECT Id, Name, AccountNumber,clcommon__Legal_Entity_Type__r.Name FROM Account WHERE AccountNumber =:accNumber ];
        system.debug('update list line 45 ' + acct);
        system.debug('update list line 45 ' + acct.size());
        if(acct.size() > 0){
            for(Account acc: acct){
                accid = acc.Id;
                acc.Name = accName;
                acc.AccountNumber = accNumber;
                acc.Type = settings.Account_Type__c;
                acc.Ownership =   ownership;
                acc.clcommon__Legal_Entity_Type__r.Name = LegalEntity;
                acc.BillingStreet = billingStreet;
                acc.BillingCity = billingCity;
                acc.BillingPostalCode = billingPostalCode;
                acc.BillingCountry = billingCountry;
                acc.BillingState = BillingState;
                acc.SAF_latestAccountsDate__c = latestAccountsDate;
                acc.SAF_filingType__c = filingType;
                acc.Sic = sic;
                acc.KYCDB_Unique_Key_Account__c = kycId;
                acc.cllease__Active__c = companyStatus;
                acc.Registered_Address_Premises__c = RegAddressPremises;
                acc.Registered_Address_Road__c = RegAddressRoad;
                system.debug('acc.Registered_Address_Road__c:::' +acc.Registered_Address_Road__c);
            }

            system.debug('act list line 48 ' + acct);
            update acct;
        }else{
            Account acct2  = new Account(Name = accName,
                                         AccountNumber = accNumber,
                                         Type= settings.Account_Type__c,
                                         Ownership= ownership,
                                         clcommon__Legal_Entity_Type__c = LegalEntityID,
                                         cllease__Active__c=companyStatus,
                                         Sic = sic,
                                         SAF_filingType__c = filingType,
                                         SAF_latestAccountsDate__c = latestAccountsDate,
                                         BillingStreet = billingStreet,
                                         BillingCity = billingCity,
                                         BillingState= BillingState,
                                         BillingPostalCode = billingPostalCode,
                                         BillingCountry = billingCountry,
                                         KYCDB_Unique_Key_Account__c = kycId,
                                         Registered_Address_Premises__c = RegAddressPremises,
                                         Registered_Address_Road__c = RegAddressRoad
                                        );

            system.debug('aa before insert===='+acct2);
            insert acct2;
            accid = acct2.Id;
            system.debug('aa after insert======='+acct2);
            system.debug('aa acc2 id variable======='+acct2.id);
        }


        List < Object > individualList = null;
        if(cIndividual != null && cIndividual.trim().length()>0){
            individualList = (List < Object > ) JSON.deserializeuntyped(cIndividual);
        }

        system.debug('individualList len: ' + individualList.size());

        if (accid != null) {

            if(individualList != null && individualList.size() >0 ){
                for (Object indLst: individualList) {
                    system.debug('list value:::: '+indLst);
                    Map < String, Object > data = (Map < String, Object > ) indLst;
                    Object IndName= data.get('name');
                    Object IndAddress = data.get('address');
                    Object  IndAccAddress = data.get('address');
                    Map < String, Object > address = (Map < String, Object > ) IndAccAddress;
                    Object registered_address_line1 = address.get('registered_address_line1');
                    Object registered_city = address.get('registered_city');
                    Object registered_county = address.get('registered_county');
                    Object country = address.get('registered_country');
                    Object postal_code = address.get('registered_postcode');
                    Object Premises = address.get('registered_address_premises');
                    Object Road = address.get('registered_address_road');

                    //DOB Details
                    Object DOB = data.get('date_of_birth');
                    Map<String,object> DOBDetails= (Map <String,Object>) DOB ;
                    object DOBMonth = DOBDetails.get('month');
                    object DOBYear = DOBDetails.get('year');

                    //name elements
                    Object NameElements = data.get('name_elements');
                    Map<String,object> name_elements = (Map <String,Object>) NameElements;
                    Object middle_name = name_elements.get('middle_name');
                    Object title = name_elements.get('title');
                    Object surname = name_elements.get('surname');
                    Object forename = name_elements.get('forename');

                    Object Nationality = data.get('nationality');

                    String IndId = String.valueof(data.get('id'));
                    contactNum.add(IndId);

                    obj.put(IndId, new List < Object > { IndName, IndId, registered_address_line1, registered_city,registered_county,postal_code,country,Premises,Road,middle_name,title,surname,forename,Nationality,DOBMonth,DOBYear});
                }
                system.debug('set res ' + contactNum);
                List < Account > Ind = [SELECT Id, Name, KYCDB_Unique_Key_Account__c FROM Account WHERE KYCDB_Unique_Key_Account__c  IN :contactNum];
                system.debug('update Ind list line 163 ' + Ind);

                for (Account acc: Ind) {
                    Updateset.add(acc.KYCDB_Unique_Key_Account__c);
                    system.debug('Ind name in line 169 ' + obj.get(acc.KYCDB_Unique_Key_Account__c));
                    List <Object> reqs = (List <Object>) obj.get(acc.KYCDB_Unique_Key_Account__c);
                    system.debug('name '+reqs[0]);
                    system.debug('conID '+reqs[1]);

                    acc.BillingStreet = string.valueof(reqs[2]);
                    acc.BillingCity = string.valueof(reqs[3]);
                    acc.BillingState = string.valueof(reqs[4]);
                    acc.BillingPostalCode = string.valueof(reqs[5]);
                    acc.BillingCountry = string.valueof(reqs[6]);
                    acc.Registered_Address_Premises__c = string.valueof(reqs[7]);
                    acc.Registered_Address_Road__c = string.valueof(reqs[8]);
                    acc.Saf_MiddleName__c = string.valueof(reqs[9]);
                    acc.Saf_Title__c = string.valueof(reqs[10]);
                    acc.Saf_LastName__c = string.valueof(reqs[11]);
                    acc.Saf_FIrstName__c = string.valueof(reqs[12]);
                    acc.Saf_Nationality__c = string.valueof(reqs[13]);
                    acc.Month_of_Birth__c = string.valueof(reqs[14]);
                    acc.Birth_Year__c = string.valueof(reqs[15]);
                    acc.Name = acc.Saf_FIrstName__c + (acc.Saf_MiddleName__c != null ? (' ' +  acc.Saf_MiddleName__c + ' '): ' ')  + acc.Saf_LastName__c;
                }
                system.debug('updatecorp list line 51 ' + Ind);
                update Ind;
                system.debug('UpdateCorpset set line 58 ' + Updateset);

                for (String kyc: contactNum) {
                    if (!Updateset.contains(kyc)) {
                        Createset.add(kyc);
                        system.debug('line 61' + kyc);
                        List <Object> createreqs = (List <Object>) obj.get(kyc);



                        Account indAcc  = new Account(
                            //Name = string.valueof(createreqs[0]),
                            KYCDB_Unique_Key_Account__c = string.valueof(createreqs[1]),
                            Type= settings.Account_Type__c,
                            Ownership= settings.Individual_Ownership__c,
                            clcommon__Legal_Entity_Type__c = settings.Legal_Entity_Type_id_Individual__c,
                            BillingStreet = string.valueof(createreqs[2]),
                            BillingCity = string.valueof(createreqs[3]),
                            BillingState = string.valueof(createreqs[4]),
                            BillingPostalCode = string.valueof(createreqs[5]),
                            BillingCountry = string.valueof(createreqs[6]),
                            Registered_Address_Premises__c = string.valueof(createreqs[7]),
                            Registered_Address_Road__c = string.valueof(createreqs[8]),
                            Saf_MiddleName__c = string.valueof(createreqs[9]),
                            Saf_Title__c = string.valueof(createreqs[10]),
                            Saf_LastName__c = string.valueof(createreqs[11]),
                            Saf_FIrstName__c = string.valueof(createreqs[12]),
                            Saf_Nationality__c = string.valueof(createreqs[13]),
                            Month_of_Birth__c = string.valueof(createreqs[14]),
                            Birth_Year__c = string.valueof(createreqs[15]),
                            Name = string.valueof(createreqs[12]) + (string.valueof(createreqs[9]) != null ? (' ' + string.valueof(createreqs[9]) + ' ') : ' ')  + string.valueof(createreqs[11])
                        );

                        system.debug('Individual############'+indAcc);
                        newcontact.add(indAcc);
                    }
                }

                system.debug('ceate Ind set ' + Createset);
                system.debug('line 378 newcontact ' + newcontact);
                insert newcontact;
            }

            // Checking corporates and upsert
            List < Object > corporateList = null;
            if(cCorporate != null && cCorporate.trim().length()>0){
                corporateList = (List < Object > ) JSON.deserializeuntyped(cCorporate);
            }

            system.debug('corporateList len: ' + corporateList);

            if(corporateList != null && corporateList.size() >0 ){
                for (Object corpLst: corporateList) {
                    System.debug('inside corporate loop'+corpLst);
                    Map < String, Object > data = (Map < String, Object > ) corpLst;
                    System.debug('First Map');
                    //Object contactId = data.get('id');
                    Object corpName = data.get('name');
                    Object corpAddress = data.get('address');
                    Object corpAccaddress = data.get('address');
                    Map < String, Object > address = (Map < String, Object > ) corpAccaddress;
                    System.debug('Second Map');
                    Object address_line_1 = address.get('registered_address_line1');
                    Object City = address.get('registered_city');
                    Object State = address.get('registered_county');
                    Object country = address.get('registered_country');
                    Object postal_code = address.get('registered_postcode');
                    Object Premises = address.get('registered_address_premises');
                    Object Road = address.get('registered_address_road');

                    Object CorpOwnership = data.get('ownership');
                    Object CorpLegalEntity = data.get('legal_entity_type');
                    Object CorpLegalEntityId = data.get('legal_entity_type_id');

                    system.debug('CorpOwnership && CorpLegalEntity && CorpLegalEntityId::::' +CorpOwnership +CorpLegalEntity +CorpLegalEntityId);
                    //crn for corporate entity

                    object Identifications = data.get('identification');
                    Map < String, Object > identity = (Map < String, Object > ) Identifications;
                    Object RegNumber = identity.get('registration_number');

                    String corpId = String.valueof(data.get('id'));
                    corporateNum.add(corpId);

                    system.debug('corp id' +corpId);
                    obj.put(corpId, new List < Object > { corpName, corpId, address_line_1, City,postal_code,country,state, RegNumber,CorpOwnership ,CorpLegalEntity, CorpLegalEntityId,Premises,Road });
                }
                system.debug('set res ' + corporateNum);
                List < Account > corp = [SELECT Id, Name, KYCDB_Unique_Key_Account__c,clcommon__Legal_Entity_Type__r.Name FROM Account WHERE KYCDB_Unique_Key_Account__c  = :corporateNum];
                system.debug('corp::::' + corp);
                for (Account acc: corp) {
                    UpdateCorpset.add(acc.KYCDB_Unique_Key_Account__c);
                    system.debug('obj.get(acc.KYCDB_Unique_Key_Account__c ' + obj.get(acc.KYCDB_Unique_Key_Account__c)); 
                    List <Object> reqs = (List <Object>) obj.get(acc.KYCDB_Unique_Key_Account__c);

                    system.debug('KYCDB_Unique_Key_Account__c' +acc.KYCDB_Unique_Key_Account__c);
                    system.debug('name '+reqs[0]);
                    system.debug('conID '+reqs[1]);
                    acc.Name = string.valueof(reqs[0]);
                    acc.BillingStreet = string.valueof(reqs[2]);
                    acc.BillingCity = string.valueof(reqs[3]);
                    acc.BillingPostalCode = string.valueof(reqs[4]);
                    acc.BillingCountry = string.valueof(reqs[5]);
                    acc.BillingState = string.valueof(reqs[6]);
                    acc.AccountNumber = string.valueof(reqs[7]);
                    acc.Ownership = string.valueof(reqs[8]);
                    acc.clcommon__Legal_Entity_Type__r.Name = string.valueof(reqs[9]);
                    acc.Registered_Address_Premises__c = string.valueof(reqs[11]);
                    acc.Registered_Address_Road__c = string.valueof(reqs[12]);
                    system.debug('acc details::' +acc);
                }
                system.debug('updatecorp list line 174 before update ' + corp);
                update corp;
                system.debug('UpdateCorpset set line 175 ' + UpdateCorpset);

                for (String kyc: corporateNum) {
                    if (!UpdateCorpset.contains(kyc)) {
                        CreateCorpset.add(kyc);
                        system.debug('line 183' + kyc);
                        List <Object> createreqs = (List <Object>) obj.get(kyc);
                        Account corpAcc  = new Account(Name = string.valueof(createreqs[0]),
                                                       KYCDB_Unique_Key_Account__c = string.valueof(createreqs[1]),
                                                       Type= settings.Account_Type__c,
                                                       BillingStreet = string.valueof(createreqs[2]),
                                                       BillingCity = string.valueof(createreqs[3]),
                                                       BillingPostalCode = string.valueof(createreqs[4]),
                                                       BillingCountry = string.valueof(createreqs[5]),
                                                       BillingState = string.valueof(createreqs[6]),
                                                       AccountNumber = string.valueof(createreqs[7]),
                                                       Ownership = string.valueof(createreqs[8]),
                                                       clcommon__Legal_Entity_Type__c = string.valueof(createreqs[10]),
                                                       Registered_Address_Premises__c = string.valueof(createreqs[11]),
                                                       Registered_Address_Road__c = string.valueof(createreqs[12])
                                                      );
                        system.debug('corpAcc========'+corpAcc);
                        newCorpAcc.add(corpAcc);
                    }
                }
                system.debug('CreateCorpset>> ' + CreateCorpset);
                system.debug('newCorpAcc:: ' + newCorpAcc);
                insert newCorpAcc;
                system.debug('corp after insert::' +newCorpAcc);
            }

            // Checking officers and upsert
            List < Object > officersList = null;
            if(cOfficers != null && cOfficers.trim().length()>0){
                officersList = (List < Object > ) JSON.deserializeuntyped(cOfficers);
            }

            system.debug('officersList len: ' + officersList);

            if(officersList != null &&  officersList.size() >0 ){
                for (Object officer: officersList) {
                    Map < String, Object > data = (Map < String, Object > ) officer;
                    Object Name = data.get('name');
                    Object contactAddress = data.get('address');
                    Map < String, Object > address = (Map < String, Object > ) contactAddress;
                    Object address_line_1 = address.get('registered_address_line1');
                    Object City = address.get('registered_city');
                    Object country = address.get('registered_country');
                    Object region = address.get('region');
                    Object postal_code = address.get('registered_postcode');
                    Object State = address.get('registered_county');
                    Object Road = address.get('registered_address_road');
                    Object Premises = address.get('registered_address_premises');

                    Object nationality = data.get('nationality');
                    Object officerrole = data.get('officer_role');
                    Object date_of_birth = data.get('date_of_birth');
                    Map < String, Object > DOB = (Map < String, Object > ) date_of_birth;
                    Object month = DOB.get('month');
                    Object year = DOB.get('year');
                    object title = data.get('title');
                    object surname = data.get('surname');
                    object forename = data.get('forename');
                    object middlename = data.get('middle_name');
                    object Occupation= data.get('occupation');

                    String officerId = String.valueof(data.get('id'));

                    officerNum.add(officerId);

                    system.debug('officerrole::'+officerrole);
                    obj2.put(officerId, new List < Object > { officerId, Name, address_line_1, City, country, postal_code, State,nationality,title,surname,forename,middlename, Occupation,month,year,Road,Premises});
                }
                system.debug('obj2 map res ' + obj2);
                system.debug('officerNum set res ' + officerNum);

                List < Account > officersExistList = [SELECT Id, KYCDB_Unique_Key_Account__c, Name  FROM Account WHERE KYCDB_Unique_Key_Account__c IN :officerNum];
                system.debug('officersExistList:: ' + officersExistList);

                for (Account officerExist: officersExistList) {
                    UpdateOfficerset.add(officerExist.KYCDB_Unique_Key_Account__c);
                    system.debug('obj2.get(officerExist.KYCDB_Unique_Key_Account__c)::: ' + obj2.get(officerExist.KYCDB_Unique_Key_Account__c));

                    List <Object> reqs = (List <Object>) obj2.get(officerExist.KYCDB_Unique_Key_Account__c);

                    officerExist.KYCDB_Unique_Key_Account__c = string.valueof(reqs[0]);
                    officerExist.BillingStreet = string.valueof(reqs[2]);
                    officerExist.BillingCity = string.valueof(reqs[3]);
                    officerExist.BillingCountry = string.valueof(reqs[4]);
                    officerExist.BillingPostalCode = string.valueof(reqs[5]);
                    officerExist.BillingState = string.valueof(reqs[6]);
                    officerExist.Saf_Nationality__c = string.valueof(reqs[7]);
                    officerExist.Saf_Title__c = string.valueof(reqs[8]);
                    officerExist.Saf_LastName__c = string.valueof(reqs[9]);
                    officerExist.Saf_FIrstName__c = string.valueof(reqs[10]);
                    officerExist.Saf_MiddleName__c = string.valueof(reqs[11]);
                    officerExist.Saf_Occupation__c = string.valueof(reqs[12]);
                    officerExist.Month_of_Birth__c = string.valueof(reqs[13]);
                    officerExist.Birth_Year__c = string.valueof(reqs[14]);
                    officerExist.Registered_Address_Premises__c = string.valueof(reqs[16]);
                    officerExist.Registered_Address_Road__c = string.valueof(reqs[15]);
                    officerExist.Name = officerExist.Saf_FIrstName__c + (officerExist.Saf_MiddleName__c != null ? (' ' +  officerExist.Saf_MiddleName__c + ' '): ' ')  + officerExist.Saf_LastName__c;
                }
                system.debug('officersExistList:: ' + officersExistList);
                update officersExistList;
                system.debug('UpdateOfficerset:: ' + UpdateOfficerset);

                for (String kyc: officerNum) {
                    if (!UpdateOfficerset.contains(kyc)) {
                        CreateOfficerset.add(kyc);

                        List <Object> createreqs = (List <Object>) obj2.get(kyc);
                        Account OfficerAcc  = new Account( KYCDB_Unique_Key_Account__c = string.valueof(createreqs[0]),
                                                          Type= settings.Account_Type__c,
                                                          Ownership= settings.Individual_Ownership__c,
                                                          clcommon__Legal_Entity_Type__c = settings.Legal_Entity_Type_id_Individual__c,
                                                          BillingStreet = string.valueof(createreqs[2]),
                                                          BillingCity = string.valueof(createreqs[3]),
                                                          BillingPostalCode = string.valueof(createreqs[5]),
                                                          BillingCountry = string.valueof(createreqs[4]),
                                                          BillingState = string.valueof(createreqs[6]),
                                                          Saf_Nationality__c = string.valueof(createreqs[7]),
                                                          Saf_Title__c = string.valueof(createreqs[8]),
                                                          Saf_LastName__c = string.valueof(createreqs[9]),
                                                          Saf_FIrstName__c = string.valueof(createreqs[10]),
                                                          Saf_MiddleName__c = string.valueof(createreqs[11]),
                                                          Saf_Occupation__c = string.valueof(createreqs[12]),
                                                          Month_of_Birth__c = string.valueof(createreqs[13]),
                                                          Birth_Year__c = string.valueof(createreqs[14]),
                                                          Registered_Address_Premises__c = string.valueof(createreqs[16]),
                                                          Registered_Address_Road__c = string.valueof(createreqs[15]),
                                                          Name = string.valueof(createreqs[10]) + (string.valueof(createreqs[11]) != null ? (' ' + string.valueof(createreqs[11]) + ' ') : ' ')  + string.valueof(createreqs[9])
                                                         );
                        newOfficer.add(OfficerAcc);
                    }
                }
                system.debug('create newOfficer set ' + Createset);
                system.debug('line 378 ' + newOfficer);
                insert newOfficer;
            }

            List<KYCResponse.cls_account> lstacc = new List<KYCResponse.cls_account>();
            for (account objacct: newcontact) {
                KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                objacc.cls_account_id = objacct.Id;
                objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                lstacc.add(objacc);

                system.debug('shareholder ids:::' +objacc);
                system.debug('shareholder lst:::' +lstacc);
            }
            for (account objacct: newOfficer) {
                KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                objacc.cls_account_id = objacct.Id;
                objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                lstacc.add(objacc);

                system.debug('officers ids:::' +objacc);
                system.debug('officers lst:::' +lstacc);

            }
            system.debug('lstacc : ' + lstacc);
            string jsonaccont = KYCResponse.parseAccount(lstacc);
            system.debug('jsonaccont : ' + jsonaccont );
            UpdateIndividualToDB(jsonaccont);

            List<KYCResponse.cls_account> lstaccCorp = new List<KYCResponse.cls_account>();

            for (account objacct: newCorpAcc) {
                KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                objacc.cls_account_id = objacct.Id;
                // objacc.zoho_account_id = objacct.Id;
                objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                lstaccCorp.add(objacc);
            }
            system.debug('lstaccCorp : ' + lstaccCorp);
            string JsonCorpAcc = KYCResponse.parseAccount(lstaccCorp);
            system.debug('JsonCorpAcc : ' + JsonCorpAcc );
            UpdateCorpToDB(JsonCorpAcc);
        }

        //New customer create/update
        string jsonString = '[{"cls_account_id": "'+accid+'",  "company_number": "'+accNumber+'" , "legal_entity_type": "'+LegalEntity+'"}]';
        //string jsonString = '[{"cls_account_id": "'+accid+'",     "company_number": "'+accNumber+'"}]';       //'[{"cls_account_id": "'+accid+'",  "company_number": "'+accNumber+'"}]'; //"id": "'+kycId+'",
        system.debug('jsonString: L538:: '+jsonString);
        callout(jsonString);
        //saf_CreateRelationship.CreateRelationship('','','');
        return 'Account Created/updated successfully';
    }

    //Update cl customer id details to DB
    @future(callout = true)
    public static void callout(string jsonString){
        //do callout here rest or soap
        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);
        
        System.debug('jsonString::'+jsonString);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string CustURL = settings.UpdateCustomerToDB__c;
        request.setEndpoint(CustURL);  //http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/company/updateClsAccountId
        request.setMethod('POST');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonString);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('Updated..in CLS ');
            System.debug(response.getBody());
        }
        if(response.getStatusCode() == 401)
        {

            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) callout(jsonString);
        }
    }

    //update Corp account id to DB
    @future(callout = true)
    public static void UpdateCorpToDB(string JsonCorpAcc){
        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);

        System.debug('JsonCorpAcc::'+JsonCorpAcc);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string CustURL = settings.UpdateCustomerToDB__c;
        request.setEndpoint(CustURL);  //http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/company/updateClsAccountId
        request.setMethod('POST');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JsonCorpAcc);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('Updated..in CLS ');
            System.debug(response.getBody());
        }
        if(response.getStatusCode() == 401)
        {
            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) UpdateCorpToDB(JsonCorpAcc);
        }
    }

    //Contact update to DB
    @future(callout = true)
    public static void calloutContact(string conatctjson){
        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);
        System.debug('conatctjson::'+conatctjson);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string contURL = settings.UpdateContactToDB__c;
        request.setEndpoint(contURL); //http://51.140.35.4:9091/api/kyc/v1/system/integration/individual
        request.setMethod('POST');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(conatctjson);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('Updated contact..in CLS ');
            System.debug(response.getBody());
        }

        if(response.getStatusCode() == 401)
        {
            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) calloutContact(conatctjson);
        }
    }

    //Create new customer in DB when created in CL
    webservice static void UpdateNewCustomerToDB(List<string> compNumber)
    {
        List <Account> NewAcc = [SELECT Id, Name, Type,AccountNumber,Ownership, KYCDB_Unique_Key_Account__c,BillingStreet,BillingState,BillingCity,BillingPostalCode, BillingCountry,SAF_latestAccountsDate__c, SAF_filingType__c, Sic, cllease__Active__c,UK_Region__c,Phone,Landline__c, clcommon__Legal_Entity_Type__r.name, Zoho_Customer_Id__c,clcommon__Email__c,ShippingStreet,ShippingCity,ShippingPostalCode,ShippingCountry,ShippingState,Registered_Address_Premises__c, Registered_Address_Road__c, Trading_Address_Premises__c, Trading_Address_Road__c,Saf_Title__c,Watchlist_Active__c,Aggregate__c,SSID__c FROM Account WHERE id =:compNumber];
        system.debug('acc for new customer:' +NewAcc);
        system.debug('new account size:' +NewAcc.size());
 
        if(NewAcc.size() > 0){
            for(account Newacct: NewAcc){
                String NewAccjson;
                JSONGenerator genn = JSON.createGenerator(true);
                genn.writeStartArray();
                genn.writeStartObject();

                genn.writeStringField('cls_account_id', Newacct.Id);
                if(String.isNotBlank(Newacct.Name)){
                    genn.writeStringField('company_name', Newacct.Name);
                }
                if(String.isNotBlank(Newacct.AccountNumber)){
                    genn.writeStringField('company_number', Newacct.AccountNumber);
                }
                if(String.isNotBlank(Newacct.Sic)){
                    genn.writeStringField('sic_code', Newacct.Sic);
                }
                if(String.isNotBlank(Newacct.Type)){
                    genn.writeStringField('type', Newacct.Type);
                }
                if(String.isNotBlank(Newacct.UK_Region__c)){
                    genn.writeStringField('nuts_code', Newacct.UK_Region__c);
                }
                if(String.isNotBlank(Newacct.Phone)){
                    genn.writeStringField('mobile_phone', Newacct.Phone);
                }
                if(String.isNotBlank(Newacct.Landline__c)){
                    genn.writeStringField('landline', Newacct.Landline__c);
                }
                if(String.isNotBlank(Newacct.clcommon__Email__c)){
                    genn.writeStringField('email', Newacct.clcommon__Email__c);
                }
                if(String.isNotBlank(Newacct.clcommon__Legal_Entity_Type__r.name)){
                    genn.writeStringField('legal_entity_type', Newacct.clcommon__Legal_Entity_Type__r.name);
                }
                if(String.isNotBlank(Newacct.Ownership)){
                    genn.writeStringField('ownership', Newacct.Ownership);
                }
                if(String.isNotBlank(Newacct.BillingStreet)){
                    genn.writeStringField('registered_address_line1', Newacct.BillingStreet);
                }
                if(String.isNotBlank(Newacct.BillingCity)){
                    genn.writeStringField('registered_city', Newacct.BillingCity);
                }
                if(String.isNotBlank(Newacct.BillingPostalCode)){
                    genn.writeStringField('registered_postcode', Newacct.BillingPostalCode);
                }
                if(String.isNotBlank(Newacct.BillingCountry)){
                    genn.writeStringField('registered_country', Newacct.BillingCountry);
                }
                if(String.isNotBlank(Newacct.BillingState)){
                    genn.writeStringField('registered_county', Newacct.BillingState);
                }
                if(String.isNotBlank(Newacct.Registered_Address_Premises__c)){
                    genn.writeStringField('registered_address_premises', Newacct.Registered_Address_Premises__c);
                }
                if(String.isNotBlank(Newacct.Registered_Address_Road__c)){
                    genn.writeStringField('registered_address_road', Newacct.Registered_Address_Road__c);
                }
                if(String.isNotBlank(Newacct.ShippingStreet)){
                    genn.writeStringField('trading_address_line1', Newacct.ShippingStreet);
                }
                if(String.isNotBlank(Newacct.ShippingCity)){
                    genn.writeStringField('trading_city', Newacct.ShippingCity);
                }
                if(String.isNotBlank(Newacct.ShippingPostalCode)){
                    genn.writeStringField('trading_postcode', Newacct.ShippingPostalCode);
                }
                if(String.isNotBlank(Newacct.ShippingCountry)){
                    genn.writeStringField('trading_country', Newacct.ShippingCountry);
                }
                if(String.isNotBlank(Newacct.ShippingState)){
                    genn.writeStringField('trading_county', Newacct.ShippingState);
                }
                if(String.isNotBlank(Newacct.Trading_Address_Premises__c)){
                    genn.writeStringField('trading_address_premises', Newacct.Trading_Address_Premises__c);
                }
                if(String.isNotBlank(Newacct.Trading_Address_Road__c)){
                    genn.writeStringField('trading_address_road', Newacct.Trading_Address_Road__c);
                }
                if(String.isNotBlank(Newacct.Zoho_Customer_Id__c)){
                    genn.writeStringField('zoho_account_id', Newacct.Zoho_Customer_Id__c);
                }
                if(String.isNotBlank(Newacct.Saf_Title__c)){
                    genn.writeStringField('title', Newacct.Saf_Title__c);
                }
                if(String.isNotBlank(Newacct.SSID__c)){
                    genn.writeStringField('ssid', Newacct.SSID__c);
                }
                if(String.isNotBlank(String.valueOf(Newacct.Watchlist_Active__c))){
                    genn.writeStringField('watch_list', String.valueOf(Newacct.Watchlist_Active__c));
                }
                genn.writeEndObject();
                genn.writeEndArray();

                NewAccjson = genn.getAsString();
                system.debug('NewAccjson :::'+NewAccjson);
                if(String.isNotBlank(NewAccjson)){
                    calloutNewCustomer(NewAccjson,Newacct.Id);
                }
            }
        }
    }

    //Create new customer in DB
    @future(callout = true)
    public static void calloutNewCustomer(string NewAccjson,string accountId){

        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);
        System.debug('NewAccjson::'+NewAccjson);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string newCustURL = settings.EditCustomerUpdateToDB__c;
        request.setEndpoint(newCustURL); //http://51.140.35.4:9091/api/kyc/v1/system/integration/account
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', token);
        request.setBody(NewAccjson);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('customer created in DB ');
            string res = response.getbody();
            KYCResponse.CalloutNewCustomer objcall =  KYCResponse.parseNewCust(res);
            System.debug('new customer creation in DB:' + res);
            Account objacc = [Select Id,KYCDB_Unique_Key_Account__c from account where Id =: accountId];
            objacc.KYCDB_Unique_Key_Account__c = string.valueof(objcall.id);
            System.debug('objacc:' + objacc);
            update objacc;
        }
        if(response.getStatusCode() == 401){
            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) calloutNewCustomer(NewAccjson,accountId);
        }
    }

    //Update customer details to DB when Edited in CL
    @future(callout = true)
    public static void calloutExistingCustomer(string jsonData){

        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);
        System.debug('jsonData::'+jsonData);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        system.debug('display settings :: '+settings.EditCustomerUpdateToDB__c);
        string newCustURL = settings.EditCustomerUpdateToDB__c ;     //UpdateCustomerToDB__c
        system.debug('newCustURL'+newCustURL);
        request.setEndpoint(newCustURL); //http://51.140.35.4:9091/api/kyc/v1/system/integration/account
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', token);
        request.setBody(jsonData);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('customer created in DB ');
            System.debug('new customer creation in DB' +response.getBody());
        }

        if(response.getStatusCode() == 401){

            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) calloutExistingCustomer(jsonData);
        }
    }

    @future(callout = true)
    public static void UpdateIndividualToDB(string jsonaccont ){
        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);
        System.debug('UpdateIndividualToDB jsonaccont::'+jsonaccont);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string newCustURL = settings.UpdateIndividualIdToDB__c; //'http://kycapiuat.simply.finance:9091/api/kyc/v1/system/integration/individual/updateClsAccountId';     //UpdateCustomerToDB__c
        request.setEndpoint(newCustURL); 
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', token);
        request.setBody(jsonaccont);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('****The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('*** account ind update in DB**');
            System.debug('*** account update in DB ' +response.getBody());
        }
        if(response.getStatusCode() == 401){
            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) UpdateIndividualToDB(jsonaccont);
        }
    }

    //updating Individual table in DB when Individual account is updated in CL
    webservice static String UpdateIndividual(List<String> updateIndAccountList) {
        string returnmsg = 'Success';
        try{
                
                List < Account > acct = [SELECT Id, Name, AccountNumber, KYCDB_Unique_Key_Account__c,BillingStreet,BillingCity,BillingPostalCode, BillingCountry,BillingState,SAF_latestAccountsDate__c, SAF_filingType__c, Sic, cllease__Active__c,
                                     ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Zoho_Customer_Id__c,UK_Region__c,Phone,Landline__c,clcommon__Email__c,Ownership,Registered_Address_Premises__c, Registered_Address_Road__c, Trading_Address_Premises__c, Trading_Address_Road__c,
                                     Saf_LastName__c,Saf_FIrstName__c,Saf_MiddleName__c,Saf_Title__c,Saf_Nationality__c,Saf_Occupation__c,Day_of_Birth__c,Birth_Year__c,Month_of_Birth__c,Date_Of_Birth__c,clcommon__Legal_Entity_Type__c,clcommon__Legal_Entity_Type__r.name,Watchlist_Active__c,Aggregate__c,SSID__c FROM Account WHERE id =:updateIndAccountList];
                    
                if(acct.size() > 0){
                String jsonDat;
                List<KYCResponse.Ind_accUpdate> lstIndacc = new List<KYCResponse.Ind_accUpdate>();
                for(account Indacc: acct){
                    KYCResponse.Ind_accUpdate objacc = new KYCResponse.Ind_accUpdate();
                    objacc.cls_account_id = Indacc.Id;
                    objacc.id = Indacc.KYCDB_Unique_Key_Account__c;
                        if(String.isNotBlank(Indacc.name)){
                            objacc.name= Indacc.name;
                        }else{
                           objacc.name= '';
                        }
                   
                    if(String.isNotBlank(Indacc.AccountNumber)){
                        objacc.company_number = Indacc.AccountNumber;}else{objacc.company_number= '';}
                        
                    if(String.isNotBlank(Indacc.BillingStreet)){
                        objacc.registered_address_line1 = Indacc.BillingStreet;}else{ objacc.registered_address_line1 = '';
                        }
                    if(String.isNotBlank(Indacc.BillingCity)){objacc.registered_city = Indacc.BillingCity;}else{ objacc.registered_city = '';
                        }
                     if(String.isNotBlank(Indacc.BillingPostalCode)){objacc.registered_postcode = Indacc.BillingPostalCode;}else{ objacc.registered_postcode = '';
                        }
                     if(String.isNotBlank(Indacc.BillingState)){ objacc.registered_county = Indacc.BillingState;}else  {objacc.registered_county = '';
                        }
                    if(String.isNotBlank(Indacc.BillingCountry)){objacc.registered_country = Indacc.BillingCountry;    }else{ objacc.registered_country = '';
                        }
                    if(String.isNotBlank(Indacc.Registered_Address_Premises__c)){objacc.registered_address_premises = Indacc.Registered_Address_Premises__c; }else{ objacc.registered_address_premises = '';
                        }
                    if(String.isNotBlank(Indacc.Registered_Address_Road__c)){objacc.registered_address_road = Indacc.Registered_Address_Road__c; }else{objacc.registered_address_road = '';
                        }
                    if(String.isNotBlank(Indacc.ShippingStreet)){objacc.trading_address_line1 = Indacc.ShippingStreet; }else{ objacc.trading_address_line1 = '';
                        }
                    if(String.isNotBlank(Indacc.ShippingCity)){objacc.trading_city = Indacc.ShippingCity;}else{objacc.trading_city = '';
                        }
                    if(String.isNotBlank(Indacc.ShippingState)){objacc.trading_county = Indacc.ShippingState;}else{ objacc.trading_county = '';
                        }
                    if(String.isNotBlank(Indacc.ShippingCountry)){ objacc.trading_country = Indacc.ShippingCountry; }else{ objacc.trading_country = '';
                        }
                    if(String.isNotBlank(Indacc.ShippingPostalCode)){objacc.trading_postcode = Indacc.ShippingPostalCode;}else{objacc.trading_postcode = '';
                        }
                    if(String.isNotBlank(Indacc.Trading_Address_Premises__c)  || (String.isNotEmpty(Indacc.Trading_Address_Premises__c))){
                            objacc.trading_address_premises = Indacc.Trading_Address_Premises__c; 
                        }else{
                            objacc.trading_address_premises = '';
                        }
                    if(String.isNotBlank(Indacc.Trading_Address_Road__c)){ objacc.trading_address_road = Indacc.Trading_Address_Road__c;}else{objacc.trading_address_road = '';
                        }
                     objacc.sic_code = Indacc.Sic;
                    objacc.nuts_code = Indacc.UK_Region__c;
                    if(String.isNotBlank(Indacc.Phone)){objacc.mobile_phone = Indacc.Phone;}else{objacc.mobile_phone = '';
                        }
                    if(String.isNotBlank(Indacc.Landline__c)){ objacc.landline = Indacc.Landline__c;}else{objacc.landline = '';
                        }         
                    if(String.isNotBlank(Indacc.clcommon__Email__c)){objacc.email = Indacc.clcommon__Email__c; }else{ objacc.email = '';
                        }
                    if(String.isNotBlank(Indacc.Saf_LastName__c)){ objacc.surname = Indacc.Saf_LastName__c;}else{ objacc.surname = '';
                        }
                    if(String.isNotBlank(Indacc.Saf_FIrstName__c)){objacc.forename = Indacc.Saf_FIrstName__c; }else{ objacc.forename = '';
                        }
                    if(String.isNotBlank(Indacc.Saf_MiddleName__c)){objacc.middle_name = Indacc.Saf_MiddleName__c; }else{ objacc.middle_name = '';
                        }
                    objacc.title = Indacc.Saf_Title__c;
                    objacc.date_of_birth_month = Indacc.Month_of_Birth__c;
                    objacc.date_of_birth_day = Indacc.Day_of_Birth__c;
                    objacc.date_of_birth_year= Indacc.Birth_Year__c;
                    objacc.date_of_birth = Indacc.Date_Of_Birth__c;
                    if(String.isNotBlank(Indacc.Saf_Occupation__c)){objacc.occupation = Indacc.Saf_Occupation__c; }else{objacc.occupation = '';
                        }
                    if(String.isNotBlank(Indacc.Saf_Nationality__c)){ objacc.nationality = Indacc.Saf_Nationality__c;   }else{   objacc.nationality = '';
                        }
                    if(String.isNotBlank(Indacc.Ownership)){ objacc.ownership= Indacc.Ownership; }else{objacc.ownership= '';
                        }
                     if(String.isNotBlank(Indacc.clcommon__Legal_Entity_Type__r.name)){ objacc.legal_entity_type= Indacc.clcommon__Legal_Entity_Type__r.name;}else{ objacc.legal_entity_type= '';
                        }
                  
                    objacc.watch_list_active= String.valueOf(Indacc.Watchlist_Active__c); 

                    if(String.isNotBlank(String.valueOf(Indacc.Watchlist_Active__c))){  objacc.watch_list=String.valueOf(Indacc.Watchlist_Active__c);  objacc.watch_list= String.valueOf(Indacc.Watchlist_Active__c);  }  else{objacc.watch_list= '';
                    }

                    if(String.isNotBlank(Indacc.Aggregate__c)){  objacc.Aggregate= Indacc.Aggregate__c; }else{ objacc.Aggregate= '';
                    }

                    if(String.isNotBlank(Indacc.SSID__c)){objacc.ssid= Indacc.SSID__c; }else{  objacc.ssid= '';
                    }

                    if(String.isNotBlank(Indacc.Zoho_Customer_Id__c)){ objacc.zoho_account_id= Indacc.Zoho_Customer_Id__c;   }else{  objacc.zoho_account_id= '';
                    }

                    lstIndacc.add(objacc);
                }
                jsonDat  = KYCResponse.parseIndAccount(lstIndacc);
                if(String.isNotBlank(jsonDat)){
                    calloutIndividual(jsonDat);
                }
                   
                                
            }           
        }

        catch(Exception ex)
        {
            returnmsg = 'Error';
            System.debug('error ::'+ex.getmessage());
        }
        return returnmsg;
    }
    //updating Individual table in DB when Individual account is updated in CL
    @future(callout = true)
    public static void calloutIndividual(string jsonDat){
        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);

        System.debug('jsonData::'+jsonDat);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string contURL = settings.UpdateContactToDB__c;
        request.setEndpoint(contURL); //http://51.140.35.4:9091/api/kyc/v1/system/integration/individual
        request.setMethod('POST');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonDat);
        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('Updated contact..in CLS ');
            System.debug(response.getBody());
        }

        if(response.getStatusCode() == 401){
            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) calloutIndividual(jsonDat);

        }
    }


    webservice static String insertIndividualinDB(List<String> CRNumber) {
        string returnmsg = 'Success';
        try{
            System.debug('CRN:'+CRNumber);
            List < Account > acct = [SELECT Id, Name, AccountNumber, KYCDB_Unique_Key_Account__c,BillingStreet,BillingCity,BillingPostalCode, BillingCountry,BillingState,SAF_latestAccountsDate__c, SAF_filingType__c, Sic, cllease__Active__c,
                                     ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Zoho_Customer_Id__c,UK_Region__c,Phone,Landline__c,clcommon__Email__c,Ownership,Registered_Address_Premises__c, Registered_Address_Road__c, Trading_Address_Premises__c, Trading_Address_Road__c,
                                     Saf_LastName__c,Saf_FIrstName__c,Saf_MiddleName__c,Saf_Title__c,Saf_Nationality__c,Saf_Occupation__c,Day_of_Birth__c,Birth_Year__c,Month_of_Birth__c,Date_Of_Birth__c,clcommon__Legal_Entity_Type__r.name,Watchlist_Active__c,Aggregate__c,SSID__c FROM Account WHERE id =:CRNumber];

            system.debug('update line 1166:' + acct);
            system.debug('update size line 1167:' + acct.size());
            if(acct.size() > 0){
                String jsonDat;
                List<KYCResponse.Ind_accUpdate> lstIndacc = new List<KYCResponse.Ind_accUpdate>();
                for(account Indacc: acct){
                    KYCResponse.Ind_accUpdate objacc = new KYCResponse.Ind_accUpdate();
                    objacc.cls_account_id = Indacc.Id;
                    objacc.id = Indacc.KYCDB_Unique_Key_Account__c;
                    objacc.name= Indacc.name;
                    objacc.company_number = Indacc.AccountNumber;
                    objacc.registered_address_line1 = Indacc.BillingStreet;
                    objacc.registered_city = Indacc.BillingCity;
                    objacc.registered_postcode = Indacc.BillingPostalCode;
                    objacc.registered_county = Indacc.BillingState;
                    objacc.registered_country = Indacc.BillingCountry;
                    objacc.registered_address_premises = Indacc.Registered_Address_Premises__c;
                    objacc.registered_address_road = Indacc.Registered_Address_Road__c;
                    objacc.trading_address_line1 = Indacc.ShippingStreet;
                    objacc.trading_city = Indacc.ShippingCity;
                    objacc.trading_county = Indacc.ShippingState;
                    objacc.trading_country = Indacc.ShippingCountry;
                    objacc.trading_postcode = Indacc.ShippingPostalCode;
                    objacc.trading_address_premises = Indacc.Trading_Address_Premises__c;
                    objacc.trading_address_road = Indacc.Trading_Address_Road__c;
                    objacc.sic_code = Indacc.Sic;
                    objacc.nuts_code = Indacc.UK_Region__c;
                    objacc.mobile_phone = Indacc.Phone;
                    objacc.landline = Indacc.Landline__c;
                    objacc.email = Indacc.clcommon__Email__c;
                    objacc.surname = Indacc.Saf_LastName__c;
                    objacc.forename = Indacc.Saf_FIrstName__c;
                    objacc.middle_name = Indacc.Saf_MiddleName__c;
                    objacc.title = Indacc.Saf_Title__c;
                    objacc.date_of_birth_month = Indacc.Month_of_Birth__c;
                    objacc.date_of_birth_day = Indacc.Day_of_Birth__c;
                    objacc.date_of_birth_year = Indacc.Birth_Year__c;
                    objacc.date_of_birth = Indacc.Date_Of_Birth__c;
                    objacc.occupation = Indacc.Saf_Occupation__c;
                    objacc.nationality = Indacc.Saf_Nationality__c;
                    objacc.ownership = Indacc.Ownership;
                    objacc.legal_entity_type = Indacc.clcommon__Legal_Entity_Type__r.name;
                    objacc.watch_list_active = String.valueOf(Indacc.Watchlist_Active__c);
                    objacc.ssid = Indacc.SSID__c;
                    objacc.zoho_account_id = Indacc.Zoho_Customer_Id__c;
                    lstIndacc.add(objacc);
                    system.debug('Ind acc details:::' +objacc);
                }
                system.debug('lstIndacc : ' + lstIndacc);
                jsonDat  = KYCResponse.parseIndAccount(lstIndacc);
                system.debug('jsonDat  : ' + jsonDat  );
                if(String.isNotBlank(jsonDat)){
                    for(account Newacct: acct){
                        calloutIndividualWithAccount(jsonDat ,Newacct.Id);
                    }
                }
                System.debug('jsonDat-' + jsonDat);
            }
        }

        catch(Exception ex)
        {
            returnmsg = 'Error';
            System.debug('error ::'+ex.getmessage());
        }
        return returnmsg;
    }

    @future(callout = true)
    public static void calloutIndividualWithAccount(string jsonDat, String accountId){

        string token ='Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);
        System.debug('jsonData!!::'+jsonDat);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string contURL = settings.UpdateContactToDB__c;
        request.setEndpoint(contURL); //http://51.140.35.4:9091/api/kyc/v1/system/integration/individual
        request.setMethod('POST');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonDat);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected:!! ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('Updated contact..in CLS !! ');
            System.debug(response.getBody());
            string res = response.getbody();
            if(res.substring(0,1) == '['){
                res = res.substring( 1, res.length() - 1 );
            }

            System.debug('res::::' + res);
            KYCResponse.CalloutNewCustomer objcall =  KYCResponse.parseNewCust(res);
            System.debug('new customer creation in DB calloutIndividualWithAccount:' + res);
            Account objacc = [Select Id,KYCDB_Unique_Key_Account__c from account where Id =: accountId];
            System.debug('objcall.id:' + objcall.id);
            objacc.KYCDB_Unique_Key_Account__c = string.valueof(objcall.id);
            System.debug('objacc:' + objacc);
            update objacc;
        }

        if(response.getStatusCode() == 401){
            TokenExpired = true;
            system.debug('SAF_CompanyHouse.RetryToken :' +SAF_CompanyHouse.RetryToken);
            if(SAF_CompanyHouse.RetryToken <= 3) calloutIndividual(jsonDat);
        }
    }


    webservice static String updateContactsfromDB(String CRNDetail, string cIndividual, string cCorporate, string cOfficers ) {
            string returnmsg = 'Success';
            Contact cont;
            Account accnt;
            Map < String, Object > obj = new Map < String, Object > ();
            Set < String > contactNum = new Set < String > ();
            Set < String > Updateset = new Set < String > ();
            Set < String > Createset = new Set < String > ();
            List < Account > newcontact = new List < Account > ();

            Map < String, Object > obj2 = new Map < String, Object > ();
            Set < String > officerNum = new Set < String > ();
            Set < String > UpdateOfficerset = new Set < String > ();
            Set < String > CreateOfficerset = new Set < String > ();
            List < Account > newOfficer = new List < Account > ();

            Set < String > corporateNum = new Set < String > ();
            Set < String > UpdateCorpset = new Set < String > ();
            Set < String > CreateCorpset = new Set < String > ();
            List < Account > newCorpAcc = new List < Account > ();

            System.debug('CRN:' + CRNDetail + 'cIndividual:' + cIndividual + 'cCorporate:' + cCorporate+ 'cOfficers:'+cOfficers);

            List < Object > crnDtl = (List < Object > ) JSON.deserializeuntyped(CRNDetail);
            system.debug('crnDtl::'+crnDtl[0]);
            string accNumber;
            string accName;
            string ownership;
            string companyStatus;
            string filingType;
            string latestAccountsDate;
            string sic;
            string billingPostalCode;
            string billingCity;
            string billingCountry;
            string billingStreet;
            string kycId;
            string billingState;
            string LegalEntity;
            String LegalEntityID;
            String regAddressRoad;
            String regAddressPremises;

            for (Object cDtl: crnDtl) {
                Map < String, Object > cData= (Map < String, Object > ) cDtl;
                kycId = String.valueof(cData.get('kycId'));
                accNumber = String.valueof(cData.get('accNumber'));
                accName = String.valueof(cData.get('accName'));
                ownership = String.valueof(cData.get('ownership'));
                companyStatus = String.valueof(cData.get('companyStatus'));
                system.debug('companystatus:'+ cData.get('companyStatus'));
                filingType = String.valueof(cData.get('filingType'));
                latestAccountsDate = String.valueof(cData.get('latestAccountsDate'));
                billingPostalCode = String.valueof(cData.get('billingPostalCode'));
                billingCity = String.valueof(cData.get('billingCity'));
                billingCountry = String.valueof(cData.get('billingCountry'));
                billingStreet = String.valueof(cData.get('billingStreet'));
                sic = String.valueof(cData.get('sic_codes'));
                billingState = String.valueof(cData.get('billingState'));
                LegalEntity = String.valueof(cData.get('LegalEntity'));
                LegalEntityID = String.valueof(cData.get('LegalEntiyId'));
                regAddressRoad = String.valueof(cData.get('regAddressRoad'));
                regAddressRoad = String.valueof(cData.get('regAddressRoad'));

                system.debug('regAddressRoad :::' +regAddressRoad );
            }
            Id accid;

            List < Account > acct = [SELECT Id, Name, AccountNumber,clcommon__Legal_Entity_Type__r.Name FROM Account WHERE AccountNumber =:accNumber ];
            system.debug('update list line 45 ' + acct);
            system.debug('update list line 45 ' + acct.size());
            if(acct.size() > 0){
                for(Account acc: acct){
                    accid = acc.Id;
                    acc.Name = accName;
                    acc.AccountNumber = accNumber;
                    acc.Type = settings.Account_Type__c;
                    acc.Ownership =   ownership;
                    acc.clcommon__Legal_Entity_Type__r.Name = LegalEntity;
                    acc.BillingStreet = billingStreet;
                    acc.BillingCity = billingCity;
                    acc.BillingPostalCode = billingPostalCode;
                    acc.BillingCountry = billingCountry;
                    acc.BillingState = billingState;
                    acc.SAF_latestAccountsDate__c = latestAccountsDate;
                    acc.SAF_filingType__c = filingType;
                    acc.Sic = sic;
                    acc.KYCDB_Unique_Key_Account__c = kycId;
                    acc.cllease__Active__c = companyStatus;
                    acc.Registered_Address_Premises__c = regAddressPremises;
                    acc.Registered_Address_Road__c = regAddressRoad;
                    system.debug('acc.Registered_Address_Road__c:::' +acc.Registered_Address_Road__c);
                }

                system.debug('acct ::::::::::::: ' + acct);
                update acct;
            }
            List < Object > individualList = null;

            if(cIndividual != null && cIndividual.trim().length()>0){
                individualList = (List < Object > ) JSON.deserializeuntyped(cIndividual);
            }

            system.debug('individualList :::::::::::::::' + individualList);

            if (accid != null) {
                if(individualList != null && individualList.size() >0 ){

                    for (Object indLst: individualList) {
                        Map < String, Object > data = (Map < String, Object > ) indLst;
                        Object  IndName= data.get('name');
                        Object IndAddress = data.get('address');
                        Object  IndAccAddress = data.get('address');
                        system.debug('IndAccAddress :::::::::::::::' + IndAccAddress);
                        Map < String, Object > address = (Map < String, Object > ) IndAccAddress;
                        system.debug('address :::'+address );
                        Object registered_address_line1 = address.get('registered_address_line1');
                        Object registered_city = address.get('registered_city');
                        Object registered_county = address.get('registered_county');
                        Object country = address.get('registered_country');
                        Object postal_code = address.get('registered_postcode');
                        Object Premises = address.get('registered_address_premises');
                        Object Road = address.get('registered_address_road');

                        //DOB Details
                        Object DOB = data.get('date_of_birth');
                        Map<String,object> DOBDetails= (Map <String,Object>) DOB ;
                        object DOBMonth = DOBDetails.get('month');
                        object DOBYear = DOBDetails.get('year');

                        //name elements
                        Object NameElements = data.get('name_elements');
                        Map<String,object> name_elements = (Map <String,Object>) NameElements;
                        Object middle_name = name_elements.get('middle_name');
                        Object title = name_elements.get('title');
                        Object surname = name_elements.get('surname');
                        Object forename = name_elements.get('forename');

                        Object Nationality = data.get('nationality');

                        String IndId = String.valueof(data.get('id')); 
                        contactNum.add(IndId);

                        obj.put(IndId, new List < Object > { IndName, IndId, registered_address_line1, registered_city,registered_county,postal_code,country,Premises,Road,middle_name,title,surname,forename,Nationality,DOBMonth,DOBYear});
                    }
                    system.debug('set res ' + contactNum);
                    List < Account > Ind = [SELECT Id, Name, KYCDB_Unique_Key_Account__c FROM Account WHERE KYCDB_Unique_Key_Account__c  IN :contactNum];
                    system.debug('update Ind list line 163 ' + Ind);
                    for (Account acc: Ind) {
                        Updateset.add(acc.KYCDB_Unique_Key_Account__c);
                        system.debug('Ind name in line 169 ' + obj.get(acc.KYCDB_Unique_Key_Account__c)); 
                        List <Object> reqs = (List <Object>) obj.get(acc.KYCDB_Unique_Key_Account__c);
                        system.debug('name '+reqs[0]);
                        system.debug('conID '+reqs[1]);
                        acc.BillingStreet = string.valueof(reqs[2]);
                        acc.BillingCity = string.valueof(reqs[3]);
                        acc.BillingState = string.valueof(reqs[4]);
                        acc.BillingPostalCode = string.valueof(reqs[5]);
                        acc.BillingCountry = string.valueof(reqs[6]);
                        acc.Registered_Address_Premises__c = string.valueof(reqs[7]);
                        acc.Registered_Address_Road__c= string.valueof(reqs[8]);
                        acc.Saf_MiddleName__c = string.valueof(reqs[9]);
                        acc.Saf_Title__c = string.valueof(reqs[10]);
                        acc.Saf_LastName__c = string.valueof(reqs[11]);
                        acc.Saf_FIrstName__c = string.valueof(reqs[12]);
                        acc.Saf_Nationality__c = string.valueof(reqs[13]);
                        acc.Month_of_Birth__c = string.valueof(reqs[14]);
                        acc.Birth_Year__c = string.valueof(reqs[15]);
                        acc.Name = acc.Saf_FIrstName__c + (acc.Saf_MiddleName__c != null ? (' ' +  acc.Saf_MiddleName__c + ' '): ' ')  + acc.Saf_LastName__c;
                    }
                    system.debug('Ind :::::::::: ' + Ind);
                    update Ind;
                    system.debug('Updateset ' + Updateset);

                    for (String kyc: contactNum) {
                        if (!Updateset.contains(kyc)) {
                            Createset.add(kyc);
                            system.debug('line 61' + kyc);
                            List <Object> createreqs = (List <Object>) obj.get(kyc);
                            Account indAcc  = new Account(
                                KYCDB_Unique_Key_Account__c = string.valueof(createreqs[1]),
                                Type= settings.Account_Type__c,
                                Ownership= settings.Individual_Ownership__c,
                                clcommon__Legal_Entity_Type__c = settings.Legal_Entity_Type_id_Individual__c,
                                BillingStreet = string.valueof(createreqs[2]),
                                BillingCity = string.valueof(createreqs[3]),
                                BillingState = string.valueof(createreqs[4]),
                                BillingPostalCode = string.valueof(createreqs[5]),
                                BillingCountry = string.valueof(createreqs[6]),
                                Registered_Address_Premises__c = string.valueof(createreqs[7]),
                                Registered_Address_Road__c = string.valueof(createreqs[8]),
                                Saf_MiddleName__c = string.valueof(createreqs[9]),
                                Saf_Title__c = string.valueof(createreqs[10]),
                                Saf_LastName__c = string.valueof(createreqs[11]),
                                Saf_FIrstName__c = string.valueof(createreqs[12]),
                                Saf_Nationality__c = string.valueof(createreqs[13]),
                                Month_of_Birth__c = string.valueof(createreqs[14]),
                                Birth_Year__c = string.valueof(createreqs[15]),
                                Name = string.valueof(createreqs[12]) + (string.valueof(createreqs[9]) != null ? (' ' + string.valueof(createreqs[9]) + ' ') : ' ')  + string.valueof(createreqs[11])
                            );
                            system.debug('Individual############'+indAcc);
                            newcontact.add(indAcc);
                        }
                    }
                    system.debug('ceate Ind set ' + Createset);
                    system.debug('line 378 newcontact ' + newcontact);
                    insert newcontact;
                }

                // Checking corporates and upsert
                List < Object > corporateList = null;
                if(cCorporate != null && cCorporate.trim().length()>0){
                    corporateList = (List < Object > ) JSON.deserializeuntyped(cCorporate);
                }
                //system.debug('corporateList len: ' + corporateList.size());
                system.debug('corporateList len: ' + corporateList);
                if(corporateList != null && corporateList.size() >0 ){
                    for (Object corpLst: corporateList) {
                        Map < String, Object > data = (Map < String, Object > ) corpLst;
                        Object corpName = data.get('name');
                        Object corpAddress = data.get('address');
                        Object corpAccaddress = data.get('address');
                        system.debug('corpAccaddress  :::'+corpAccaddress );
                        Map < String, Object > address = (Map < String, Object > ) corpAccaddress;
                        system.debug('corpAccaddress  address :::'+address );
                        Object address_line_1 = address.get('registered_address_line1');
                        Object City = address.get('registered_city');
                        Object State = address.get('registered_county');
                        Object country = address.get('registered_country');
                        Object postal_code = address.get('registered_postcode');
                        Object Premises = address.get('registered_address_premises');
                        Object Road = address.get('registered_address_road');
                        Object CorpOwnership = data.get('ownership');
                        Object CorpLegalEntity = data.get('legal_entity_type');
                        Object CorpLegalEntityId = data.get('legal_entity_type_id');
                        system.debug('CorpOwnership && CorpLegalEntity && CorpLegalEntityId::::' +CorpOwnership +CorpLegalEntity +CorpLegalEntityId);
                        object Identifications = data.get('identification');
                        Map < String, Object > identity = (Map < String, Object > ) Identifications;
                        Object RegNumber = identity.get('registration_number');

                        String corpId = String.valueof(data.get('id'));
                        corporateNum.add(corpId);
                        system.debug('corp id' +corpId);
                        obj.put(corpId, new List < Object > { corpName, corpId, address_line_1, City,postal_code,country,state, RegNumber,CorpOwnership ,CorpLegalEntity, CorpLegalEntityId,Premises,Road });
                    }
                    system.debug('set res ' + corporateNum);
                    List < Account > corp = [SELECT Id, Name, KYCDB_Unique_Key_Account__c,clcommon__Legal_Entity_Type__r.Name FROM Account WHERE KYCDB_Unique_Key_Account__c  = :corporateNum];
                    system.debug('update corp list line 163 ' + corp);

                    for (Account acc: corp) {
                        UpdateCorpset.add(acc.KYCDB_Unique_Key_Account__c);
                        system.debug('corp name in line 169 ' + obj.get(acc.KYCDB_Unique_Key_Account__c));
                        List <Object> reqs = (List <Object>) obj.get(acc.KYCDB_Unique_Key_Account__c);

                        system.debug('KYCDB_Unique_Key_Account__c' +acc.KYCDB_Unique_Key_Account__c);
                        system.debug('name '+reqs[0]);
                        system.debug('conID '+reqs[1]);
                        acc.Name = string.valueof(reqs[0]);

                        acc.BillingStreet = string.valueof(reqs[2]);
                        acc.BillingCity = string.valueof(reqs[3]);
                        acc.BillingPostalCode = string.valueof(reqs[4]);
                        acc.BillingCountry = string.valueof(reqs[5]);
                        acc.BillingState = string.valueof(reqs[6]);
                        acc.AccountNumber = string.valueof(reqs[7]);
                        acc.Ownership = string.valueof(reqs[8]);
                        system.debug('string.valueof(reqs[9]::' +string.valueof(reqs[9]));
                        acc.clcommon__Legal_Entity_Type__r.Name = string.valueof(reqs[9]);
                        acc.Registered_Address_Premises__c = string.valueof(reqs[11]);
                        acc.Registered_Address_Road__c = string.valueof(reqs[12]);
                        system.debug('acc details::' +acc);
                    }
                    system.debug('updatecorp list line 174 before update ' + corp);
                    update corp;
                    system.debug('UpdateCorpset set line 175 ' + UpdateCorpset);
                    for (String kyc: corporateNum) {
                        if (!UpdateCorpset.contains(kyc)) {
                            CreateCorpset.add(kyc);
                            system.debug('line 183' + kyc);
                            List <Object> createreqs = (List <Object>) obj.get(kyc);
                            Account corpAcc  = new Account(Name = string.valueof(createreqs[0]),
                                                           KYCDB_Unique_Key_Account__c = string.valueof(createreqs[1]),
                                                           Type= settings.Account_Type__c,
                                                           BillingStreet = string.valueof(createreqs[2]),
                                                           BillingCity = string.valueof(createreqs[3]),
                                                           BillingPostalCode = string.valueof(createreqs[4]),
                                                           BillingCountry = string.valueof(createreqs[5]),
                                                           BillingState = string.valueof(createreqs[6]),
                                                           AccountNumber = string.valueof(createreqs[7]),
                                                           Ownership = string.valueof(createreqs[8]),
                                                           clcommon__Legal_Entity_Type__c = string.valueof(createreqs[10]),
                                                           Registered_Address_Premises__c = string.valueof(createreqs[11]),
                                                           Registered_Address_Road__c = string.valueof(createreqs[12])
                                                          );
                            system.debug('aa corp========'+corpAcc);
                            newCorpAcc.add(corpAcc);
                        }
                    }

                    system.debug('ceate corp set ' + CreateCorpset);
                    system.debug('line 194 newCorpAcc before insert ' + newCorpAcc);
                    insert newCorpAcc;
                    system.debug('corp after insert::' +newCorpAcc);
                }

                // Checking officers and upsert
                List < Object > officersList = null;
                if(cOfficers != null && cOfficers.trim().length()>0){
                    officersList = (List < Object > ) JSON.deserializeuntyped(cOfficers);
                }
                system.debug('officersList len: ' + officersList);

                if(officersList != null &&  officersList.size() >0 ){
                    for (Object officer: officersList) {
                        Map < String, Object > data = (Map < String, Object > ) officer;
                        Object Name = data.get('name');
                        Object contactAddress = data.get('address');
                        Map < String, Object > address = (Map < String, Object > ) contactAddress;
                        Object address_line_1 = address.get('registered_address_line1');
                        Object City = address.get('registered_city');
                        Object country = address.get('registered_country');
                        Object region = address.get('region');
                        Object postal_code = address.get('registered_postcode');
                        Object State = address.get('registered_county');
                        Object Road = address.get('registered_address_road');
                        Object Premises = address.get('registered_address_premises');

                        Object nationality = data.get('nationality');
                        Object officerrole = data.get('officer_role');
                        Object date_of_birth = data.get('date_of_birth');
                        Map < String, Object > DOB = (Map < String, Object > ) date_of_birth;
                        Object month = DOB.get('month');
                        Object year = DOB.get('year');
                        object title = data.get('title');
                        object surname = data.get('surname');
                        object forename = data.get('forename');
                        object middlename = data.get('middle_name');
                        object Occupation= data.get('occupation');

                        String officerId = String.valueof(data.get('id'));

                        officerNum.add(officerId);
                        system.debug('officerrole::'+officerrole);
                        obj2.put(officerId, new List < Object > { officerId, Name, address_line_1, City, country, postal_code, State,nationality,title,surname,forename,middlename, Occupation,month,year,Road,Premises});
                    }
                    system.debug('obj2 map res ' + obj2);
                    system.debug('officerNum set res ' + officerNum);

                    List < Account > officersExistList = [SELECT Id, KYCDB_Unique_Key_Account__c, Name  FROM Account WHERE KYCDB_Unique_Key_Account__c IN :officerNum];
                    system.debug('officersExistList:::: ' + officersExistList);

                    for (Account officerExist: officersExistList) {
                        UpdateOfficerset.add(officerExist.KYCDB_Unique_Key_Account__c);
                        system.debug('officerExist contact name in line 329 ' + obj2.get(officerExist.KYCDB_Unique_Key_Account__c));
                        List <Object> reqs = (List <Object>) obj2.get(officerExist.KYCDB_Unique_Key_Account__c);
                        officerExist.KYCDB_Unique_Key_Account__c = string.valueof(reqs[0]);
                        officerExist.BillingStreet = string.valueof(reqs[2]);
                        officerExist.BillingCity = string.valueof(reqs[3]);
                        officerExist.BillingCountry = string.valueof(reqs[4]);
                        officerExist.BillingPostalCode = string.valueof(reqs[5]);
                        officerExist.BillingState = string.valueof(reqs[6]);
                        officerExist.Saf_Nationality__c = string.valueof(reqs[7]);
                        officerExist.Saf_Title__c = string.valueof(reqs[8]);
                        officerExist.Saf_LastName__c = string.valueof(reqs[9]);
                        officerExist.Saf_FIrstName__c = string.valueof(reqs[10]);
                        officerExist.Saf_MiddleName__c = string.valueof(reqs[11]);
                        officerExist.Saf_Occupation__c = string.valueof(reqs[12]);
                        officerExist.Month_of_Birth__c = string.valueof(reqs[13]);
                        officerExist.Birth_Year__c = string.valueof(reqs[14]);
                        officerExist.Registered_Address_Premises__c= string.valueof(reqs[16]);
                        officerExist.Registered_Address_Road__c = string.valueof(reqs[15]);
                        officerExist.Name = officerExist.Saf_FIrstName__c + (officerExist.Saf_MiddleName__c != null ? (' ' +  officerExist.Saf_MiddleName__c + ' '): ' ')  + officerExist.Saf_LastName__c;
                    }
                    system.debug('officersExistList:: ' + officersExistList);
                    update officersExistList;
                    system.debug('UpdateOfficerset:: ' + UpdateOfficerset);
                    for (String kyc: officerNum) {
                        if (!UpdateOfficerset.contains(kyc)) {
                            CreateOfficerset.add(kyc);
                            List <Object> createreqs = (List <Object>) obj2.get(kyc);
                            Account OfficerAcc  = new Account( KYCDB_Unique_Key_Account__c = string.valueof(createreqs[0]),
                                                              //  Name = string.valueof(createreqs[1]),
                                                              Type= settings.Account_Type__c,
                                                              Ownership= settings.Individual_Ownership__c,
                                                              clcommon__Legal_Entity_Type__c = settings.Legal_Entity_Type_id_Individual__c,
                                                              BillingStreet = string.valueof(createreqs[2]),
                                                              BillingCity = string.valueof(createreqs[3]),
                                                              BillingPostalCode = string.valueof(createreqs[5]),
                                                              BillingCountry = string.valueof(createreqs[4]),
                                                              BillingState = string.valueof(createreqs[6]),
                                                              Saf_Nationality__c = string.valueof(createreqs[7]),
                                                              Saf_Title__c = string.valueof(createreqs[8]),
                                                              Saf_LastName__c = string.valueof(createreqs[9]),
                                                              Saf_FIrstName__c = string.valueof(createreqs[10]),
                                                              Saf_MiddleName__c = string.valueof(createreqs[11]),
                                                              Saf_Occupation__c = string.valueof(createreqs[12]),
                                                              Month_of_Birth__c = string.valueof(createreqs[13]),
                                                              Birth_Year__c = string.valueof(createreqs[14]),
                                                              Registered_Address_Premises__c = string.valueof(createreqs[16]),
                                                              Registered_Address_Road__c = string.valueof(createreqs[15]),
                                                              Name = string.valueof(createreqs[10]) + (string.valueof(createreqs[11]) != null ? (' ' + string.valueof(createreqs[11]) + ' ') : ' ')  + string.valueof(createreqs[9])
                                                             );
                            newOfficer.add(OfficerAcc);
                        }
                    }

                    system.debug('ceate newOfficer set ' + Createset);
                    system.debug('newOfficer:: ' + newOfficer);
                    insert newOfficer;
                }

                List<KYCResponse.cls_account> lstacc = new List<KYCResponse.cls_account>();

                for (account objacct: newcontact) {
                    KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                    objacc.cls_account_id = objacct.Id;
                    objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                    lstacc.add(objacc);

                    system.debug('shareholder ids:::' +objacc);
                    system.debug('shareholder lst:::' +lstacc);

                }

                for (account objacct: newOfficer) {
                    KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                    objacc.cls_account_id = objacct.Id;
                    objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                    lstacc.add(objacc);
                    system.debug('officers ids:::' +objacc);
                    system.debug('officers lst:::' +lstacc);
                }
                system.debug('lstacc : ' + lstacc);
                string jsonaccont = KYCResponse.parseAccount(lstacc);
                system.debug('jsonaccont : ' + jsonaccont );
                UpdateIndividualToDB(jsonaccont);

                List<KYCResponse.cls_account> lstaccCorp = new List<KYCResponse.cls_account>();

                for (account objacct: newCorpAcc) {
                    KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                    objacc.cls_account_id = objacct.Id;
                    objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                    lstaccCorp.add(objacc);
                }
                system.debug('lstaccCorp : ' + lstaccCorp);
                string JsonCorpAcc = KYCResponse.parseAccount(lstaccCorp);
                system.debug('JsonCorpAcc : ' + JsonCorpAcc );
                UpdateCorpToDB(JsonCorpAcc);

            }

            //New customer create/update
            string jsonString = '[{"cls_account_id": "'+accid+'",  "company_number": "'+accNumber+'" , "legal_entity_type": "'+LegalEntity+'"}]';
            system.debug('jsonString: L538:: '+jsonString);
            callout(jsonString);

            saf_CreateRelationship.CreateRelationship('','','');
            return 'Account Created/updated successfully';
    }
}