public class Saf_CompanyDetailsAPIController {
  @invocablemethod(Label='Shareholders and Officers APL' Description='Make a shareholder and officers call API')
  public static void verifyAPICalls(List<string> accountNumbers) {
    //SAF_CompanyDetailService.updateShareholderDetails(accountNumbers);
    if (accountNumbers == NULL) {
      Logger.error('Account Number is null');
    }
    SAF_CompanyDetailsQueueable qClass = new SAF_CompanyDetailsQueueable(accountNumbers);
    Id batchId = System.enqueueJob(qClass);
    AsyncApexJob jobInfo = [SELECT Id, ApexClassId, JobType, Status FROM AsyncApexJob where Id = :batchId];
    Logger.debug('Job Info:', jobInfo);
    Logger.saveLog();
  }

}