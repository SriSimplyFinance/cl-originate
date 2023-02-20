@isTest
private class TestErrorLogsUtils {
    static testMethod void validateError() {
                
                Saf_setting__c setup = new Saf_setting__c();
                setup.Admin_Email_Ids__c = 'deepak.moorthy@happiestminds.com, phalguni.tandel@happiestminds.com, kavya.s@happiestminds.com, megha.bc@happiestminds.com';
                insert setup;
      
                String Status = 'Teststatus';
                String ClassName = 'TestClass';
                String MethodName = 'Testmethod';
                
                String ErrorDescription = 'TesterrorDescription';
                String RecordID = '1234567890AAABB';
                String RequestBody = 'This is a test error request body';
                String ResponseBody = 'This is a test response Body';
                //String LoggedinUser = UserInfo.getName();
                Boolean DoNotDelete = True;
                String Priority = 'Error';
                //String RequestedTime = system.now();
                Boolean SendEMail = True;
                String EmailSubject = 'TestingEmail';
                String EmailBody = 'This is test emailBody';
                Test.StartTest();
                ErrorLogsUtils.createErrorLogs(status,className,methodName,errorDescription,recordID,requestBody,responseBody,doNotDelete,Priority,sendEmail,emailSubject,emailBody );
                Error_Logs__c errorlog = new Error_Logs__c();
                errorLog =[Select Id,Method_Name__c ,Class_Name__c from Error_Logs__c];
                System.Assert(String.isNotEmpty(errorlog.id),'NewErrorDidNotGenerateSuccesfully');
                System.assertEquals(className, errorlog.Class_Name__c,'descrepancy in error created');
                Test.stopTest();
            
            
            }
  }