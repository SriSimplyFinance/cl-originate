public class SAF_CompanyDetailService {

  static Saf_CompanyHouse__c settings = Saf_CompanyHouse__c.getOrgDefaults();
  public static boolean TokenExpired = false;
  public static List<Object> kycIndividualShareholders = new List<Object>();
  public static List<Object> kycCorporateShareholders = new List<Object>();
  public static List<Object> kycOfficersStringList = new List<Object>();
  public static List<Object> kycRelationshipList = new List<Object>();
  public Static String kycUniqueId;
  public static String contacts;


  public static String updateShareholderDetails(List<String> accountNumbers) {
    for (String accNumber : accountNumbers) {
      String[] accountArray;
      List<Account> newAccount = [select id, Name, AccountNumber, KYCDB_Unique_Key_Account__c, clcommon__Legal_Entity_Type__r.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, SIC_Code_Number__c, clcommon__Status__c, Ownership, clcommon__Legal_Entity_Type__c, LegalEntity_Zoho__c, Registered_Address_Road__c, Registered_Address_Premises__c from Account where AccountNumber = :accNumber and clcommon__Legal_Entity_Type__r.Name != null limit 1];
      if(newAccount==NULL){
        Logger.error('Account details are null');
      }
      List<KYCAccountDetails> objKycAccountDetails = mapAccountDetails(newAccount);
      for (Account a : newAccount) {
        calloutCompanyShareholder(a.AccountNumber);
        calloutCompanyOfficers(a.AccountNumber);
        kycUniqueId = a.KYCDB_Unique_Key_Account__c;
      }

    
      String crnDetails = JSON.serialize(objKycAccountDetails);
      String cIndividuals = JSON.serialize(kycIndividualShareholders);
      String cCorporate = JSON.serialize(kycCorporateShareholders);
      String cOfficers = JSON.serialize(kycOfficersStringList);

      Logger.debug('crnDetails:'+crnDetails);
      Logger.debug('cIndividuals:'+cIndividuals);
      Logger.debug('cCorporate:'+cCorporate);
      Logger.debug('cOfficers:'+cOfficers);

      contacts = SAF_ContactsUtils.CreateContacts(crnDetails, cIndividuals, cCorporate, cOfficers);

		System.debug('conatcts'+contacts);
      Logger.debug('Contacts Created:'+contacts);
      Logger.saveLog();

    }
    return contacts;
  }

  public static void calloutCompanyShareholder(String companyNumber) {

    String token = 'Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(true);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    String shareholderUrl = settings.Company_Shareholders__c + companyNumber;
    request.setEndpoint(shareholderUrl);
    request.setMethod('GET');
    request.setHeader('Authorization', token);
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() != 200) {
      Logger.error('The status code returned was not expected: ' +
              response.getStatusCode() + ' ' + response.getStatus());
    } else if ((response.getBody()).contains('data')) {

      Map < String, Object > objResponse = (Map < String, Object >) JSON.deserializeuntyped(response.getBody());
      List<Object> dataItems = (List<Object>) objResponse.get('data');
      

      for (Object dataItem : dataItems) {
        Map<String, Object> data = (Map<String, Object>) dataItem;
        String kindValue = String.valueOf(data.get('kind'));

        if (kindValue.contains('individual')) {
          kycIndividualShareholders.add(data);
          Logger.debug('kycIndividualShareholders::' + kycIndividualShareholders);
          

        } else if (kindValue.contains('corporate')) {
          kycCorporateShareholders.add(data);
          Logger.debug('kycCorporateShareholders::' +kycCorporateShareholders);
        }
      }
      if (objResponse != null) {
        Logger.debug('KYC Response :: ' + objResponse);
      } else {
        Logger.debug('Error while invoking KYC Shareholder API');
      }
    }
    Logger.saveLog();
  }


  public static void calloutCompanyOfficers(String companyNumber) {
    string token = 'Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(true);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    String officersUrl = settings.Company_Officers__c + companyNumber;
    request.setEndpoint(officersUrl);
    request.setMethod('GET');
    request.setHeader('Authorization', token);
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() != 200) {
      Logger.error('The status code returned was not expected: ' +
              response.getStatusCode() + ' ' + response.getStatus());
    } else if ((response.getBody()).contains('items')) {

      Map < String, Object > objOfficersResponse = (Map < String, Object >) JSON.deserializeuntyped(response.getBody());
      List<Object> dataItems = (List<Object>) objOfficersResponse.get('items');
      for (Object dataItem : dataItems) {
        kycOfficersStringList.add(dataItem);
      }
    }
    Logger.saveLog();
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


}