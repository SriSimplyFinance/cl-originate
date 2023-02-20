public class SAF_CompanyRelationshipCallout {

  static Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
  public static boolean TokenExpired = false;
  public static List<Object> kycRelationshipList = new List<Object>();
  static String kycUniqueId;


  public static void updateRelationshipDetails(List<String> accountNumbers) {
    if (accountNumbers == NULL) {
      Logger.error('Account Number is Null');
      Logger.saveLog();
    }
    for (String accountNumber : accountNumbers) {
      List<Account> newAccount = [select id, Name, AccountNumber, KYCDB_Unique_Key_Account__c, clcommon__Legal_Entity_Type__r.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, SIC_Code_Number__c, clcommon__Status__c, Ownership, clcommon__Legal_Entity_Type__c, LegalEntity_Zoho__c, Registered_Address_Road__c, Registered_Address_Premises__c from Account where AccountNumber = :accountNumber and clcommon__Legal_Entity_Type__r.Name != null limit 1];

      List<KYCAccountDetails> objKycAccountDetails = mapAccountDetails(newAccount);

      for (Account a : newAccount) {
        calloutCompanyRelationship(a.KYCDB_Unique_Key_Account__c, a.AccountNumber);
        kycUniqueId = a.KYCDB_Unique_Key_Account__c;
      }

      if (kycUniqueId == NUll) {
        Logger.error('KYC Unique db id is null', kycUniqueId);
        Logger.saveLog();
      }

      String crnDetails = JSON.serialize(objKycAccountDetails);
      String cRelationships = JSON.serialize(kycRelationshipList);
      String relationships = saf_CreateRelationship.CreateRelationship(crnDetails, kycUniqueId, cRelationships);
      Logger.debug('Relationship created:'+ relationships);
      Logger.saveLog();

    }
  }


  static List<KYCAccountDetails> mapAccountDetails(List<Account> newAccounts) {
    List<KYCAccountDetails> objAccountDetails = new List<KYCAccountDetails>();
    Logger.debug('newAccounts:', newAccounts);
    for (Account acc : newAccounts) {
      KYCAccountDetails objAccountDetail = new KYCAccountDetails();
      objAccountDetail.accName = acc.Name;
      objAccountDetail.accNumber = acc.AccountNumber;
      objAccountDetail.kycId = acc.KYCDB_Unique_Key_Account__c;
      objAccountDetail.billingStreet = acc.BillingStreet;
      objAccountDetail.billingCity = acc.BillingCity;
      objAccountDetail.BillingState = acc.BillingState;
      objAccountDetail.billingPostalCode = acc.BillingPostalCode;
      objAccountDetail.billingCountry = acc.BillingCountry;
      objAccountDetail.sic_codes = acc.SIC_Code_Number__c;
      objAccountDetail.companyStatus = acc.clcommon__Status__c;
      objAccountDetail.ownership = acc.Ownership;
      Logger.debug('Legal name'+acc.clcommon__Legal_Entity_Type__r.Name);
      objAccountDetail.LegalEntity = acc.clcommon__Legal_Entity_Type__r.Name;
      objAccountDetail.LegalEntiyId = acc.clcommon__Legal_Entity_Type__c;
      objAccountDetail.RegAddressRoad = acc.Registered_Address_Road__c;
      objAccountDetail.RegAddressPremises = acc.Registered_Address_Premises__c;
      objAccountDetails.add(objAccountDetail);
    }
    if(objAccountDetails==NULL){
        Logger.error('KYC details are null');
    }
    Logger.saveLog();
    return objAccountDetails;

  }

  public static void calloutCompanyRelationship(String kycId, String accountNumber) {
    Logger.debug('inside callout method');
    String token = 'Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(true);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    String relationshipUrl = settings.UpdateRelationshiptoDB__c + '?kycNumber=' + kycId + '&companyNumber=' + accountNumber;
    Logger.debug('relationship URL:'+ relationshipUrl);
    request.setEndpoint(relationshipUrl);
    request.setMethod('GET');
    request.setHeader('Authorization', token);
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() != 200) {
      Logger.error('The status code returned was not expected: ' +
              response.getStatusCode() + ' ' + response.getStatus());

    } else {
      Map < String, Object > relationshipResponse = (Map < String, Object >) JSON.deserializeuntyped(response.getBody());
        system.debug('relationswhip response:'+relationshipResponse);
      List<Object> dataItems = (List<Object>) relationshipResponse.get('data');
      for (Object dataItem : dataItems) {
        kycRelationshipList.add(dataItem);

      }

    }
    Logger.saveLog();
  }
}