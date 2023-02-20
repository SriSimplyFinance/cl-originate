public class Saf_AccountZohoController {
	 @invocablemethod(Label='Zoho API' Description='Make Zoho Account Create Call')
  public static void verifyAPICalls(List<string> accountId) {
    //SAF_CompanyDetailService.updateShareholderDetails(accountNumbers);
    if (accountId == NULL) {
      Logger.error('Account Number is null');
    }
   Saf_ZohoAccounts.CreateInZoho(accountId,true);
  }
}