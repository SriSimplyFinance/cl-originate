Global class saf_CreateRelationship {
  static Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();

  public static boolean TokenExpired = false;
  public static boolean runTrigger = true;

  webservice static String CreateRelationship(String CRN, string kycid, string Relationresp) {
    string returnmsg = 'Company Structure created Successfully';
    try {
      string s = '{' +
              '"data": ';
      Relationresp = s + Relationresp + ' }';
      Logger.debug('Relationresp rel: ', Relationresp);
      KYCResponse objkycdata = KYCResponse.parse(Relationresp);
      Map<string, string> mapaccountIDs = new Map<string, string>();
      List <clcommon__Relationship__c> newRecord = new List <clcommon__Relationship__c>();
      

      for (KYCResponse.data objdata : objkycdata.data) {
        mapaccountIDs.put(objdata.kyc_party1_regNumber, '');
        string strparty2Id = (objdata.kyc_party2_id != null ? string.valueof(objdata.kyc_party2_id) : null);
        if (!mapaccountIDs.containskey(strparty2Id)) {
          mapaccountIDs.put(strparty2Id, '');
        }
      }
      List<Account> lstAccntIds = [select id, KYCDB_Unique_Key_Account__c, AccountNumber from Account where KYCDB_Unique_Key_Account__c IN :mapaccountIDs.keyset() or AccountNumber IN :mapaccountIDs.keyset()];
      Logger.debug('lstAccntIds : ', lstAccntIds);
      for (Account objacc : lstAccntIds) {
        mapaccountIDs.put(objacc.AccountNumber, objacc.Id);
        mapaccountIDs.put(objacc.KYCDB_Unique_Key_Account__c, objacc.Id);
      }
      for (KYCResponse.data objdata : objkycdata.data) {
        string Rolefield;
        String ShareholderBracket;
        String shareholderType;
        string offRole;
        String kycRelationshipId;
        String OfficerRole;
        String SharePerc;

        kycRelationshipId = string.valueof(objdata.kyc_relationship_id);
        ShareholderBracket = objdata.shareholder_bracket;
        OfficerRole = objdata.officer_role;

        Logger.debug('kycRelationshipId &&& ShareholderBracket &&& OfficerRole :::' + kycRelationshipId + ShareholderBracket + OfficerRole);

        List<Role_setting__mdt> lstSeting = [select Id, DB_Role__c, CL_Role_ID__c from Role_setting__mdt where DB_Role__c = :objdata.officer_role limit 1];
        Logger.debug('lstSeting  role:::', lstSeting);
        Logger.debug('objdata.parent_company.......' + objdata.parent_company);

        if (objdata.parent_company == 1) {
          lstSeting = [select Id, DB_Role__c, CL_Role_ID__c from Role_setting__mdt where DB_Role__c = 'parent_company' limit 1];
          Logger.debug('lstSeting  role2:::', lstSeting);
        }

        Logger.debug('objdata.kyc_party1_regNumberr.......', objdata.kyc_party1_regNumber);
        List<clcommon__Relationship__c> relationshipList = [select id, clcommon__Entity__c from clcommon__Relationship__c where clcommon__Entity__c = :mapaccountIDs.get(objdata.kyc_party1_regNumber) and clcommon__Related_Entity__c = :mapaccountIDs.get(string.valueof(objdata.kyc_party2_id))];
        Logger.debug('rel::::', relationshipList);

        if (relationshipList .size() == 0) {
          clcommon__Relationship__c rel = new clcommon__Relationship__c();
          Logger.debug('objdata.kyc_party1_regNumberr.......', objdata.kyc_party1_regNumber);
          rel.clcommon__Entity__c = mapaccountIDs.get(objdata.kyc_party1_regNumber);
          Logger.debug('objdata.kyc_party2_id............', mapaccountIDs.get(string.valueof(objdata.kyc_party2_id)));
          rel.clcommon__Related_Entity__c = mapaccountIDs.get(string.valueof(objdata.kyc_party2_id));
          rel.Saf_Shareholder_Bracket__c = ShareholderBracket;
          rel.KYC_DB_Relationship_Id__c = kycRelationshipId;

          if (lstSeting.size() > 0) {
            rel.clcommon__Relationship__c = lstSeting[0].CL_Role_ID__c;
            Logger.debug('Rolefield value:::', rel.clcommon__Relationship__c);
          }
          Logger.debug('rel: ', rel);
          newRecord.add(rel);
        }
      }

      Logger.debug('new relationship record:::', newRecord);
      insert newRecord;
      List<KYCResponse.data> lstdata = new List<KYCResponse.data>();
      for (clcommon__Relationship__c objrel : newRecord) {
        KYCResponse.data objdata = new KYCResponse.data();
        objdata.kyc_relationship_id = objrel.KYC_DB_Relationship_Id__c != null ? Integer.valueof(objrel.KYC_DB_Relationship_Id__c) : null;
        objdata.kyc_party2_id = (objrel.clcommon__Entity__r.KYCDB_Unique_Key_Account__c != null ? objrel.clcommon__Entity__r.KYCDB_Unique_Key_Account__c : null);
        Logger.debug('clcommon__Entity__r.Id !!!!!' + objrel.clcommon__Entity__r.Id);
        objdata.kyc_party1_regNumber = objrel.clcommon__Entity__r.accountnumber;
        objdata.shareholder_bracket = objrel.Saf_Shareholder_Bracket__c;
        objdata.officer_role = objrel.clcommon__Relationship__r.Name;
        objdata.cls_relationship_id = objrel.Id;
        lstdata.add(objdata);
      }
      string strReqbody = JSON.serialize(lstdata);
      Logger.debug('strReqbody ::', strReqbody);

      string endPointURL = settings.UpdateRelIdtoDB__c;
      Logger.debug('check the url value', settings.UpdateRelIdtoDB__c);
      UpdateRelationshipTODB(strReqbody, endPointURL);
    } catch (Exception ex) {
      returnmsg = 'Error, some companies are not available to create structure';
      Logger.error('error ::' + ex.getmessage());
    }
    Logger.saveLog();
    return returnmsg;

  }

  public static void updateRelationship(clcommon__Relationship__c relationship) {
    system.debug('relationship::::::::::::::::' + relationship);
    List<KYCResponse.data> lstdata = new List<KYCResponse.data>();

    system.debug('relationship.clcommon__Entity__c:::::::::::::::' + relationship.clcommon__Entity__c);
    system.debug('relationship.clcommon__Related_Entity__c:::::::::::::::' + relationship.clcommon__Related_Entity__c);

    Account getParty1 = [SELECT id, accountnumber, KYCDB_Unique_Key_Account__c from Account where Id = :relationship.clcommon__Entity__c];
    Account getParty2 = [SELECT id, KYCDB_Unique_Key_Account__c from Account where Id = :relationship.clcommon__Related_Entity__c];

    KYCResponse.data objdata = new KYCResponse.data();
    objdata.kyc_party1_id = getParty1.KYCDB_Unique_Key_Account__c;
    objdata.kyc_party2_id = getParty2.KYCDB_Unique_Key_Account__c;
    objdata.kyc_party1_regNumber = getParty1.accountnumber;
    objdata.cls_relationship_id = relationship.Id;
    objdata.kyc_relationship_id = Integer.valueOf(relationship.KYC_DB_Relationship_Id__c);
    objdata.shareholder_type = relationship.clcommon__Relationship__r.name;
    if (String.isNotBlank(relationship.Saf_Shareholder_Bracket__c)) {
      objdata.shareholder_bracket = relationship.Saf_Shareholder_Bracket__c;
    } else {
      objdata.shareholder_bracket = '';
    }
    if (String.isNotBlank(relationship.clcommon__Entity_Role__c)) {
      objdata.officer_role = relationship.clcommon__Entity_Role__c;
    } else {
      objdata.officer_role = '';
    }

    lstdata.add(objdata);
    system.debug('lstdata::::::::::::::::' + lstdata);
    string strReqbody = JSON.serialize(lstdata);
    System.debug('strReqbody ::' + strReqbody);
    string endPointURL = settings.UpdateRelationshiptoDB__c;
    UpdateRelationshipTODB(strReqbody, endPointURL);
  }

  @future(callout=true)
  public static void UpdateRelationshipTODB(string jsonData, String endPointURL) {
    string token = 'Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(TokenExpired);

    System.debug('jsonData::' + jsonData + ' :: ' + endPointURL);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(endPointURL); //http://51.140.35.4:9091/api/kyc/v1/system/integration/account
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setHeader('Authorization', token);
    // Set the body as a JSON object
    request.setBody(jsonData);
    HttpResponse response = http.send(request);
    // Parse the JSON response

    system.debug('response:::::::;  :' + response);
    if (response.getStatusCode() != 200) {
      System.debug('****The status code returned was not expected: ' +
              response.getStatusCode() + ' ' + response.getStatus());
    } else {
      System.debug('*** new relationship record in DB ');
      System.debug('*** new relationship record in DB ' + response.getBody());
    }
    if (response.getStatusCode() == 401) {
      //SAF_ClsToZoho.ZohoAccessToken ='';
      TokenExpired = true;
      system.debug('SAF_CompanyHouse.RetryToken :' + SAF_CompanyHouse.RetryToken);
      if (SAF_CompanyHouse.RetryToken <= 3) UpdateRelationshipTODB(jsonData, endPointURL);
    }
  }

  webservice static String updateRelationshipfromDB(String relationship) {
    string returnmsg = 'Success';
    System.debug('relationship:::::::::::' + relationship);
    List < Object > relationshipDeserialize = (List < Object >) JSON.deserializeuntyped(relationship);
    system.debug('relationshipDeserialize::' + relationshipDeserialize[0]);

    string shareholder_bracket;
    string shareholder_perc;
    string shareholder_type;
    string cls_relationship_id;
    string officer_role;
    Map < String, Object > relationMap = new Map < String, Object > ();
    Set < String > clsRelationshipSet = new Set < String > ();

    for (Object relationshipItr : relationshipDeserialize) {
      Map < String, Object > relationshipDataMap = (Map < String, Object >) relationshipItr;
      System.debug('relationshipDataMap:::::::::::' + relationshipDataMap);

      shareholder_bracket = String.valueof(relationshipDataMap.get('shareholder_bracket'));
      shareholder_perc = String.valueof(relationshipDataMap.get('shareholder_perc'));
      shareholder_type = String.valueof(relationshipDataMap.get('shareholder_type'));
      cls_relationship_id = String.valueof(relationshipDataMap.get('cls_relationship_id'));
      officer_role = String.valueof(relationshipDataMap.get('officer_role'));
      clsRelationshipSet.add(cls_relationship_id);

      System.debug('shareholder_bracket:::::::::::' + shareholder_bracket);
      System.debug('cls_relationship_id:::::::::::' + cls_relationship_id);
      System.debug('clsRelationshipSet:::::::::::' + clsRelationshipSet);
      System.debug('officer_role in map:::::::::::' + relationshipDataMap.get('officer_role'));
      System.debug('officer_role:::::::::::' + officer_role);

      relationMap.put(cls_relationship_id, new List < Object >{
              shareholder_bracket, shareholder_perc, shareholder_type, cls_relationship_id, officer_role
      });
      System.debug('relationMap:::::::::::' + relationMap);
    }

    List < clcommon__Relationship__c> relationshipList = [
            SELECT Id, Saf_Shareholder_Bracket__c, clcommon__Relationship__r.Id
            FROM clcommon__Relationship__c
            WHERE Id IN :clsRelationshipSet
    ];
    System.debug('relationshipList:::::::::::' + relationshipList);
    for (clcommon__Relationship__c relData : relationshipList) {
      List <Object> reqs = (List <Object>) relationMap.get(relData.Id);
      System.debug('reqs:::::::::::' + reqs);
      relData.Saf_Shareholder_Bracket__c = string.valueof(reqs[0]);
      System.debug('string.valueof(reqs[4]):::::::::::' + string.valueof(reqs[4]));
      clcommon__Reciprocal_Role__c role = [SELECT Id, Name FROM clcommon__Reciprocal_Role__c WHERE Name = :string.valueof(reqs[4]) LIMIT 1];
      //relData.clcommon__Relationship__r.Id = role.Id;
      relData.clcommon__Relationship__c = role.Id;
      //relData.clcommon__Ownership_Percentage__c = Decimal.valueOf(String.valueOf((reqs[1])));
    }
    runTrigger = false;
    update relationshipList;
    System.debug('relationshipList:::::::::::' + relationshipList);

    return 'Relationship updates successfully';
  }
}