/**
*
* @name                 : ErrorLogsUtils
* @author               : Happiest minds 
* @description          : This is the utility class to handle the error log across the customization
* @created date         : 18/05/2017
* @modified by / date   : 18/05/2017
*
* Ticket No             : Feature #161706
* @modified by / date   : Deepak M / 30-JAN-2019
* Description           : Added Email alert functinality only to Happiestminds Admin
**/

public class ErrorLogsUtils{
    
    /*****************************************************************************************************************************
     *
     * Gloabl Constants & Variables
     *
     *****************************************************************************************************************************/    
    public static String INFO = 'INFO';
    public static String WARNING = 'WARNING';
    public static String ERROR = 'ERROR';
    public static String FATAL = 'FATAL';
    
    
    /**
     * @description : Used to check the logger service is Active or not 
     
    @TestVisible private static Boolean isEnabled(){
        //get email service flag from custom settings
        Bankeroo_Inc_Utility_Settings__c enableCustomLogging = Bankeroo_Inc_Utility_Settings__c.getOrgDefaults();
        System.debug('IsEnabled: ' + enableCustomLogging.EnableCustomLogging__c);
        return enableCustomLogging.EnableCustomLogging__c;
    }
    
    /**
     * @description : Used to create the error logs 
     * @param       : status            Error log status
     * @param       : className         Name of the class error was created 
     * @param       : methodName        Name of the method error was created 
     * @param       : errorMessage      Message about the error
     * @param       : errorDescription  Description about the error
     * @param       : recordID          Record ID fro which the error created
     * @param       : reqBody           HTTP request body or initial content for any request
     * @param       : resBody           HTTP response body or any content for any response
     * @param       : doNotDelete       Whether this record can be deleted or not
     * @param       : Priority          Error log record priority
     * @param       : sendEmail         Whether this record can be sent to email
     * @param       : emailSubject      Email subject
     * @param       : emailBody         Email content
     */
    public static void createErrorLogs(String status, String className, String methodName, String errorDescription,String recordID, String reqBody, String resBody, Boolean doNotDelete, String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
       //check the error log service is enabled or not 
      //  if(isEnabled()){
            
            try{
                //instantiating the error log object
                Error_Logs__c errorlog = new Error_Logs__c();
                //errorlog.Status__c = status;
                errorlog.Class_Name__c = className;
                errorlog.Method_Name__c = methodName;
                //errorlog.ErrorMessage__c = errorMessage;
                errorlog.Error_Description__c = errorDescription;
                errorlog.Record_ID__c = recordID;
                errorlog.Request_Body__c = reqBody;
                //errorlog.Response_Body__c = resBody;
                errorlog.Logged_in_User__c = UserInfo.getName();
                errorlog.Do_Not_Delete__c = doNotDelete;
                errorlog.Priority__c = Priority;
                errorlog.Requested_Time__c = system.now();
                errorlog.Send_Mail__c = sendEmail;
                errorlog.Email_Subject__c = emailSubject;
                errorlog.Email_Body__c = emailBody;
                insert errorlog;
                if(errorlog.Send_Mail__c){ErrorLogsUtils.sendEmail(errorDescription, errorlog.id);} // #Feature #161706: Added by Deepak M on 30JAN2019
                System.debug('***Error Log Record Id :'+ errorlog.id);
            }catch(Exception e){
                System.debug('****Failed to INSERT the [Apex Debug Log] Custom Logging record. ' +
                'Error: ' + e.getMessage());
                System.debug('****For the Class: ' + className + ' method: ' + methodName + 
                ' and the error is: ' + errorDescription);
            }
       // }else{
            
       //     System.debug('Custom Error Logging option is disabled in Custom settings');
       // }
        
    }  
    
    //*******************************************************************************//
    //****** Send Email When ever the Send Email check box is marked ****************//
    //*******************************************************************************//
    
    public static void sendEmail(string error,string Name)
    {
        Saf_setting__c mailIds = [select Admin_Email_Ids__c from Saf_setting__c];
        //if(Label.admin_email != null)
        {       
            // Step 1: Create a master list to hold the emails we'll send
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            
            // Step 2: Create a new Email
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            
            
            // Step 3: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            Profile p  = [Select id from Profile where name = 'System Administrator'];
            /*for ( User u : [Select id,Name,Email from User Where profileID =: p.id and Email like '%@happiestminds.com'])
            {
                sendTo.add(u.email);
                system.debug('Email Id: '+ u.Email);
            }*/
            
            List<String> mailId = mailIds.Admin_Email_Ids__c.split(',');
            integer m;
            for(m = 0; m < mailId.size(); m++)
            {
                system.debug('Mail Ids: '+ mailId[m]);
                sendTo.add(mailId[m]);
            }
            
            system.debug('Send To: '+sendTo);
            mail.setToAddresses(sendTo);
            
            // Step 4: Set who the email is sent from
            mail.setReplyTo(Label.admin_email);
            mail.setSenderDisplayName('Admin Alerts: Development Team');
            
            
            // Step 5. Set email contents - you can use variables!
            mail.setSubject('Admin Alerts: Error Logs has been logged');
            String body = '<html><head></head><body>Hi Admin,<br><br> Please check the Errorlogs of  '+ UserInfo.getName()+' is failed due to the following reason(s): <br><br>  Error Message: ' + error;
            body += '<br><br>ErrorLog ID : '+Name+' <br><br> Regards,<br>Admin</body></html> <br><br>';
            
            mail.setHtmlBody(body);
            
            
            // Step 6. Add your email to the master list
            mails.add(mail);
            
            
            // Step 7: Send all emails in the master list
            Messaging.sendEmail(mails);
        }
    
    }

/*   sample code to create logs

ErrorLogsUtils.createErrorLogs(String status, String className, String methodName, String errorMessage, String errorDescription, String recordID, String reqBody, String resBody, Boolean doNotDelete, ErrorLogsUtils.ERROR, Boolean sendEmail, String emailSubject, String emailBody);
        
Ex:
String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
        ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 'generateNewOAuthToken', e.getTypeName(), description, '', req.toString(), '', false, ErrorLogsUtils.ERROR, true, 'Subject', 'EmailBody');
    
Object Detials
    label: Error Logs
    name: Error_Logs__c
    keyPrefix: a85
    
*/


}