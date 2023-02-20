global class SAF_UpdateFromCH{
    
    static Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
    public static boolean TokenExpired = false;
    Public static Boolean runTrigger=true;
    
    //Create customer, shareholder and officers
    webservice static String updateContactsfromDB(String CRNDetail, string cIndividual, string cCorporate, string cOfficers ) {
          
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
        string shippingPostalCode;
        string shippingCity;
        string shippingCountry;
        string shippingStreet;
        string kycId;
        string shippingState;
        string LegalEntity;
        String LegalEntityID;
        String tradAddressRoad;
        String tradAddressPremises;
        
        
        for (Object cDtl: crnDtl) {
            Map < String, Object > cData= (Map < String, Object > ) cDtl;  
            //system.debug(''+ cData.get('accNumber'));  
            kycId = String.valueof(cData.get('kycId'));
            accNumber = String.valueof(cData.get('accNumber'));
            accName = String.valueof(cData.get('accName'));
            ownership = String.valueof(cData.get('ownership'));
            companyStatus = String.valueof(cData.get('companyStatus'));
            system.debug('companystatus:'+ cData.get('companyStatus'));
            filingType = String.valueof(cData.get('filingType'));
            latestAccountsDate = String.valueof(cData.get('latestAccountsDate'));
            shippingPostalCode = String.valueof(cData.get('shippingPostalCode'));
            shippingCity = String.valueof(cData.get('shippingCity'));
            shippingCountry = String.valueof(cData.get('shippingCountry'));
            shippingStreet = String.valueof(cData.get('shippingStreet'));
            sic = String.valueof(cData.get('sic_codes'));
            shippingState = String.valueof(cData.get('shippingState'));
            LegalEntity = String.valueof(cData.get('LegalEntity'));
            LegalEntityID = String.valueof(cData.get('LegalEntiyId'));
            tradAddressRoad = String.valueof(cData.get('tradAddressRoad'));
            tradAddressPremises = String.valueof(cData.get('tradAddressPremises'));
            
            
            system.debug('tradAddressRoad:::' +tradAddressRoad);  
            system.debug('data from skuid:::' +cData); 
            
            //sic = String.valueof(data1.get('accName'));
            //accName = String.valueof(data1.get('accName'));
        }
        Id accid; 
        
        List < Account > acct = [SELECT Id, Name, AccountNumber,clcommon__Legal_Entity_Type__r.Name FROM Account WHERE AccountNumber =:accNumber ];
        system.debug('update list line 45 ' + acct);
        system.debug('update list line 45 ' + acct.size());
        List<Account> updateAccountList = new List<Account>();
        if(acct.size() > 0){
            for(Account acc: acct){
                accid = acc.Id;
                acc.Name = accName;
                acc.AccountNumber = accNumber;
                acc.Type = settings.Account_Type__c; //'Account';
                acc.Ownership =   ownership; //settings.Ownership__c; //'Private Limited Company';
                acc.clcommon__Legal_Entity_Type__r.Name = LegalEntity;  //settings.Legal_Entity_Type_Name__c; //'Limited Liability Company';
                acc.ShippingStreet = shippingStreet;
                acc.ShippingCity = shippingCity;
                acc.ShippingPostalCode = shippingPostalCode;
                acc.ShippingCountry = shippingCountry;
                acc.ShippingState = shippingState;
                acc.SAF_latestAccountsDate__c = latestAccountsDate;
                acc.SAF_filingType__c = filingType;
                acc.Sic = sic;
                acc.KYCDB_Unique_Key_Account__c = kycId;
                acc.cllease__Active__c = companyStatus; 
                acc.Trading_Address_Premises__c = tradAddressPremises;
                acc.Trading_Address_Road__c = tradAddressRoad;
                system.debug('acc.Trading_Address_Road__c:::' +acc.Trading_Address_Road__c);
                updateAccountList.add(acc);
                
            }
            
            system.debug('act list line 48 ' + acct);
            //update acct;
            update updateAccountList; //Anjana
        }
        
        // Checking Individuals/shareholder and upsert
        List < Object > individualList = null;
        
        if(cIndividual != null && cIndividual.trim().length()>0){
            individualList = (List < Object > ) JSON.deserializeuntyped(cIndividual);
        }
        //system.debug('individualList len: ' + individualList.size());
        system.debug('individualList len: ' + individualList);
        
        //Account acct = [SELECT Id FROM Account WHERE AccountNumber = :accNumber LIMIT 1];
        if (accid != null) {
            
            if(individualList != null && individualList.size() >0 ){        
                
                for (Object indLst: individualList) {
                    Map < String, Object > data = (Map < String, Object > ) indLst;
                    //Object contactId = data.get('id');
                    Object  IndName= data.get('name'); //corpName
                    Object IndAddress = data.get('address');
                    //Object company_status = data.get('company_status');
                    //Object latestAccountsDate = data.get('latestAccountsDate');
                    
                    Object  IndAccAddress = data.get('address'); //shareholder address
                    Map < String, Object > address = (Map < String, Object > ) IndAccAddress;
                    Object registered_address_line1 = address.get('trading_address_line1');
                    Object registered_city = address.get('trading_city');
                    Object registered_county = address.get('trading_county');
                    Object country = address.get('trading_country');
                    Object postal_code = address.get('trading_postcode');
                    Object Premises = address.get('trading_address_premises'); 
                    Object Road = address.get('trading_address_road'); 
                    
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
                List<Account> updateIndList = new List<Account>();
                for (Account acc: Ind) {
                    Updateset.add(acc.KYCDB_Unique_Key_Account__c);
                    system.debug('Ind name in line 169 ' + obj.get(acc.KYCDB_Unique_Key_Account__c)); 
                    List <Object> reqs = (List <Object>) obj.get(acc.KYCDB_Unique_Key_Account__c);
                    system.debug('name '+reqs[0]);
                    system.debug('conID '+reqs[1]); 
                    acc.ShippingStreet = string.valueof(reqs[2]);
                    acc.ShippingCity = string.valueof(reqs[3]);
                    acc.ShippingState = string.valueof(reqs[4]);
                    acc.ShippingPostalCode = string.valueof(reqs[5]);
                    acc.ShippingCountry = string.valueof(reqs[6]);
                    acc.Trading_Address_Premises__c = string.valueof(reqs[7]);
                    acc.Trading_Address_Road__c = string.valueof(reqs[8]);
                    acc.Saf_MiddleName__c = string.valueof(reqs[9]);
                    acc.Saf_Title__c = string.valueof(reqs[10]);
                    acc.Saf_LastName__c = string.valueof(reqs[11]);
                    acc.Saf_FIrstName__c = string.valueof(reqs[12]);
                    acc.Saf_Nationality__c = string.valueof(reqs[13]);
                    acc.Month_of_Birth__c = string.valueof(reqs[14]);
                    acc.Birth_Year__c = string.valueof(reqs[15]);
                    acc.Name = acc.Saf_FIrstName__c + (acc.Saf_MiddleName__c != null ? (' ' +  acc.Saf_MiddleName__c + ' '): ' ')  + acc.Saf_LastName__c;
                    updateIndList.add(acc);
                }
                system.debug('updatecorp list line 51 ' + Ind);
                //update Ind;
                update updateIndList;//Anjana
                system.debug('UpdateCorpset set line 58 ' + Updateset);
                
                for (String kyc: contactNum) {   
                    if (!Updateset.contains(kyc)) {
                        Createset.add(kyc);
                        system.debug('line 61' + kyc);
                        List <Object> createreqs = (List <Object>) obj.get(kyc);
                        Account indAcc  = new Account( //Name = string.valueof(createreqs[0]), 
                            KYCDB_Unique_Key_Account__c = string.valueof(createreqs[1]), 
                            Type= settings.Account_Type__c, //'Account'
                            Ownership= settings.Individual_Ownership__c,  //'Individual'
                            clcommon__Legal_Entity_Type__c = settings.Legal_Entity_Type_id_Individual__c,   //'a4s0O000000CyQCQA0'
                            ShippingStreet = string.valueof(createreqs[2]),
                            ShippingCity = string.valueof(createreqs[3]),
                            ShippingState = string.valueof(createreqs[4]),
                            ShippingPostalCode = string.valueof(createreqs[5]),
                            ShippingCountry = string.valueof(createreqs[6]),
                            Trading_Address_Premises__c = string.valueof(createreqs[7]),
                            Trading_Address_Road__c = string.valueof(createreqs[8]),
                            Saf_MiddleName__c = string.valueof(createreqs[9]),
                            Saf_Title__c = string.valueof(createreqs[10]),
                            Saf_LastName__c = string.valueof(createreqs[11]),
                            Saf_FIrstName__c = string.valueof(createreqs[12]),
                            Saf_Nationality__c = string.valueof(createreqs[13]),
                            Month_of_Birth__c = string.valueof(createreqs[14]),
                            Birth_Year__c = string.valueof(createreqs[15]),
                            Name = string.valueof(createreqs[10]) + (string.valueof(createreqs[7]) != null ? (' ' + string.valueof(createreqs[7]) + ' ') : ' ')  + string.valueof(createreqs[9])
                        );
                        // a.Id is null here
                        system.debug('Individual############aa'+indAcc);
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
                    //Object contactId = data.get('id');
                    Object corpName = data.get('name');
                    Object corpAddress = data.get('address');
                    //Object company_status = data.get('company_status');
                    //Object latestAccountsDate = data.get('latestAccountsDate');
                    Object corpAccaddress = data.get('address');
                    Map < String, Object > address = (Map < String, Object > ) corpAccaddress;
                    Object address_line_1 = address.get('trading_address_line1');
                    Object City = address.get('trading_city');
                    Object State = address.get('trading_county');
                    Object country = address.get('trading_country');
                    Object postal_code = address.get('trading_postcode');
                    Object Premises = address.get('trading_address_premises');
                    Object Road = address.get('trading_address_road');
                    
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
                    //system.debug(forename);
                    system.debug('corp id' +corpId);
                    obj.put(corpId, new List < Object > { corpName, corpId, address_line_1, City,postal_code,country,state, RegNumber,CorpOwnership ,CorpLegalEntity, CorpLegalEntityId,Premises,Road });
                }
                system.debug('set res ' + corporateNum);
                List < Account > corp = [SELECT Id, Name, KYCDB_Unique_Key_Account__c,clcommon__Legal_Entity_Type__r.Name FROM Account WHERE KYCDB_Unique_Key_Account__c  = :corporateNum];
                system.debug('update corp list line 163 ' + corp);
                List<Account> updateCordList = new List<Account>();
                for (Account acc: corp) {
                    UpdateCorpset.add(acc.KYCDB_Unique_Key_Account__c);
                    system.debug('corp name in line 169 ' + obj.get(acc.KYCDB_Unique_Key_Account__c)); 
                    List <Object> reqs = (List <Object>) obj.get(acc.KYCDB_Unique_Key_Account__c);
                    
                    system.debug('KYCDB_Unique_Key_Account__c' +acc.KYCDB_Unique_Key_Account__c);
                    system.debug('name '+reqs[0]);
                    system.debug('conID '+reqs[1]);
                    acc.Name = string.valueof(reqs[0]);
                    //acc.cllease__Active__c = string.valueof(reqs[2]);
                    acc.ShippingStreet = string.valueof(reqs[2]);
                    acc.ShippingCity = string.valueof(reqs[3]);
                    acc.ShippingPostalCode = string.valueof(reqs[4]);
                    acc.ShippingCountry = string.valueof(reqs[5]);
                    acc.ShippingState = string.valueof(reqs[6]);
                    acc.AccountNumber = string.valueof(reqs[7]);
                    acc.Ownership = string.valueof(reqs[8]);
                    acc.clcommon__Legal_Entity_Type__r.Name = string.valueof(reqs[9]);
                    acc.Trading_Address_Premises__c = string.valueof(reqs[11]);
                    acc.Trading_Address_Road__c = string.valueof(reqs[12]);
                    
                    system.debug('acc details::' +acc);
                    updateCordList.add(acc);
                    
                }
                system.debug('updatecorp list line 174 before update ' + corp);
                //update corp;
                update updateCordList;
                system.debug('UpdateCorpset set line 175 ' + UpdateCorpset);
                
                for (String kyc: corporateNum) {
                    if (!UpdateCorpset.contains(kyc)) {
                        CreateCorpset.add(kyc);
                        system.debug('line 183' + kyc);
                        List <Object> createreqs = (List <Object>) obj.get(kyc);
                        Account corpAcc  = new Account(Name = string.valueof(createreqs[0]), 
                                                       KYCDB_Unique_Key_Account__c = string.valueof(createreqs[1]), 
                                                       Type= settings.Account_Type__c, //'Account', 
                                                       // Ownership= settings.Ownership__c,  //'Private Limited Company',
                                                       // clcommon__Legal_Entity_Type__c = settings.Legal_Entity_Type_id__c, //'a4s0O000000CyQ9QAK',
                                                       //cllease__Active__c = string.valueof(createreqs[2]),
                                                       ShippingStreet = string.valueof(createreqs[2]),
                                                       ShippingCity = string.valueof(createreqs[3]),
                                                       ShippingPostalCode = string.valueof(createreqs[4]),
                                                       ShippingCountry = string.valueof(createreqs[5]),
                                                       ShippingState = string.valueof(createreqs[6]),
                                                       AccountNumber = string.valueof(createreqs[7]),
                                                       Ownership = string.valueof(createreqs[8]),
                                                       clcommon__Legal_Entity_Type__c = string.valueof(createreqs[10]),
                                                       Trading_Address_Premises__c = string.valueof(createreqs[11]),
                                                       Trading_Address_Road__c = string.valueof(createreqs[12])
                                                      );
                        // a.Id is null here
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
            //system.debug('officersList len: ' + officersList.size());
            system.debug('officersList len: ' + officersList);
            
            if(officersList != null &&  officersList.size() >0 ){        
                
                for (Object officer: officersList) {
                    Map < String, Object > data = (Map < String, Object > ) officer;
                    
                    
                    Object Name = data.get('name');
                    //Object contactName = data.get('name_elements');
                    Object contactAddress = data.get('address');
                    Map < String, Object > address = (Map < String, Object > ) contactAddress;
                    Object address_line_1 = address.get('trading_address_line1');
                    Object City = address.get('trading_city');
                    Object country = address.get('trading_country');
                    Object region = address.get('region');
                    Object postal_code = address.get('trading_postcode');
                    Object State = address.get('trading_county');
                    Object Road = address.get('trading_address_road');
                    Object Premises = address.get('trading_address_premises');
                    
                    
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
                    //Map < String, Object > data1 = (Map < String, Object > ) contactName;
                    
                    
                    //system.debug(forename);
                    system.debug('officerrole::'+officerrole);
                    obj2.put(officerId, new List < Object > { officerId, Name, address_line_1, City, country, postal_code, State,nationality,title,surname,forename,middlename, Occupation,month,year,Road,Premises});
                    //List
                }
                system.debug('obj2 map res ' + obj2);
                system.debug('officerNum set res ' + officerNum);
                
                List < Account > officersExistList = [SELECT Id, KYCDB_Unique_Key_Account__c, Name  FROM Account WHERE KYCDB_Unique_Key_Account__c IN :officerNum];
                system.debug('update officer list line 325 ' + officersExistList);
                List < Account > corOfficerList = new List<Account>();
                for (Account officerExist: officersExistList) {
                    UpdateOfficerset.add(officerExist.KYCDB_Unique_Key_Account__c);
                    system.debug('officerExist contact name in line 329 ' + obj2.get(officerExist.KYCDB_Unique_Key_Account__c)); 
                    
                    List <Object> reqs = (List <Object>) obj2.get(officerExist.KYCDB_Unique_Key_Account__c);
                    //system.debug('officerid '+reqs[1]);
                    //system.debug('forname '+reqs[1]);
                    // system.debug('conID '+reqs[2]);
                    officerExist.KYCDB_Unique_Key_Account__c = string.valueof(reqs[0]);
                    // officerExist.Name = string.valueof(reqs[1]);
                    officerExist.ShippingStreet = string.valueof(reqs[2]);
                    officerExist.ShippingCity = string.valueof(reqs[3]);
                    officerExist.ShippingCountry = string.valueof(reqs[4]);
                    officerExist.ShippingPostalCode = string.valueof(reqs[5]);
                    officerExist.ShippingState = string.valueof(reqs[6]);
                    officerExist.Saf_Nationality__c = string.valueof(reqs[7]);
                    officerExist.Saf_Title__c = string.valueof(reqs[8]);
                    officerExist.Saf_LastName__c = string.valueof(reqs[9]);
                    officerExist.Saf_FIrstName__c = string.valueof(reqs[10]);
                    officerExist.Saf_MiddleName__c = string.valueof(reqs[11]);
                    officerExist.Saf_Occupation__c = string.valueof(reqs[12]);
                    officerExist.Month_of_Birth__c = string.valueof(reqs[13]);
                    officerExist.Birth_Year__c = string.valueof(reqs[14]);
                    officerExist.Trading_Address_Premises__c = string.valueof(reqs[16]);
                    officerExist.Trading_Address_Road__c = string.valueof(reqs[15]);
                    
                    officerExist.Name = officerExist.Saf_FIrstName__c + (officerExist.Saf_MiddleName__c != null ? (' ' +  officerExist.Saf_MiddleName__c + ' '): ' ')  + officerExist.Saf_LastName__c;
                    corOfficerList.add(officerExist);
                    
                }
                system.debug('update list line 51 ' + officersExistList);
                //update officersExistList;
                update corOfficerList;
                system.debug('update set line 58 ' + UpdateOfficerset);
                
                for (String kyc: officerNum) {
                    if (!UpdateOfficerset.contains(kyc)) {
                        CreateOfficerset.add(kyc);
                        //system.debug('line 355' + kyc);
                        
                        List <Object> createreqs = (List <Object>) obj2.get(kyc);
                        Account OfficerAcc  = new Account( KYCDB_Unique_Key_Account__c = string.valueof(createreqs[0]),
                                                          //  Name = string.valueof(createreqs[1]), 
                                                          Type= settings.Account_Type__c, //'Account', 
                                                          Ownership= settings.Individual_Ownership__c,  //'Individual',
                                                          clcommon__Legal_Entity_Type__c = settings.Legal_Entity_Type_id_Individual__c, //'a4s0O000000CyQCQA0',
                                                          //cllease__Active__c = string.valueof(createreqs[2]),
                                                          ShippingStreet = string.valueof(createreqs[2]),
                                                          ShippingCity = string.valueof(createreqs[3]),
                                                          ShippingPostalCode = string.valueof(createreqs[5]),
                                                          ShippingCountry = string.valueof(createreqs[4]),
                                                          ShippingState = string.valueof(createreqs[6]),
                                                          Saf_Nationality__c = string.valueof(createreqs[7]),
                                                          Saf_Title__c = string.valueof(createreqs[8]),
                                                          Saf_LastName__c = string.valueof(createreqs[9]),
                                                          Saf_FIrstName__c = string.valueof(createreqs[10]),
                                                          Saf_MiddleName__c = string.valueof(createreqs[11]),
                                                          Saf_Occupation__c = string.valueof(createreqs[12]),
                                                          Month_of_Birth__c = string.valueof(createreqs[13]),
                                                          Birth_Year__c = string.valueof(createreqs[14]),
                                                          Trading_Address_Premises__c = string.valueof(createreqs[16]),
                                                          Trading_Address_Road__c = string.valueof(createreqs[15]),
                                                          Name = string.valueof(createreqs[10]) + (string.valueof(createreqs[11]) != null ? (' ' + string.valueof(createreqs[11]) + ' ') : ' ')  + string.valueof(createreqs[9])
                                                         );
                        //system.debug('line 370' + obj2.get(kyc));
                        // system.debug('line 371' + obj2.get(kyc));
                        // system.debug('officerID createreqs '+createreqs[0]);
                        newOfficer.add(OfficerAcc);
                    }
                }
                
                system.debug('ceate newOfficer set ' + Createset);
                system.debug('line 378 ' + newOfficer);
                insert newOfficer;
            }
            
            
            List<KYCResponse.cls_account> lstacc = new List<KYCResponse.cls_account>();
            
            for (account objacct: newcontact) {   
                KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                objacc.cls_account_id = objacct.Id;
                // objacc.zoho_account_id = objacct.Id;
                objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                lstacc.add(objacc);
                
                system.debug('shareholder ids:::' +objacc);
                system.debug('shareholder lst:::' +lstacc);
                
            }
            
            
            for (account objacct: newOfficer) {   
                KYCResponse.cls_account objacc = new KYCResponse.cls_account();
                objacc.cls_account_id = objacct.Id;
                // objacc.zoho_account_id = objacct.Id;
                objacc.id = objacct.KYCDB_Unique_Key_Account__c;
                lstacc.add(objacc);
                
                system.debug('officers ids:::' +objacc);
                system.debug('officers lst:::' +lstacc);
                
            }
            system.debug('lstacc : ' + lstacc);
            string jsonaccont = KYCResponse.parseAccount(lstacc);
            system.debug('jsonaccont : ' + jsonaccont );
            SAF_ContactsUtils.UpdateIndividualToDB(jsonaccont);
            
            
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
            SAF_ContactsUtils.UpdateCorpToDB(JsonCorpAcc);
            
        }
        
        
        /*
        //New customer create/update
        
        string jsonString = '[{"cls_account_id": "'+accid+'",  "company_number": "'+accNumber+'" , "legal_entity_type": "'+LegalEntity+'"}]'; 
        //string jsonString = '[{"cls_account_id": "'+accid+'",     "company_number": "'+accNumber+'"}]';       //'[{"cls_account_id": "'+accid+'",  "company_number": "'+accNumber+'"}]'; //"id": "'+kycId+'",
        system.debug('jsonString: L538:: '+jsonString);
        SAF_ContactsUtils.callout(jsonString);
        
        saf_CreateRelationship.CreateRelationship('','','');*/
        return 'Account updates successfully';
    }
}