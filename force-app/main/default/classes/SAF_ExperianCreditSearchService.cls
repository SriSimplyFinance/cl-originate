public class SAF_ExperianCreditSearchService {
    static saf_kyc_Experian__c settings = saf_kyc_Experian__c.getOrgDefaults();
    
    public static void updateCompanyDetailsOnExperianSearch(String accountId,String companyType){
        Account newAccount = [select id,Name, AccountNumber,Current_Credit_Report__c, KYCDB_Unique_Key_Account__c,clcommon__Legal_Entity_Type__r.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, SIC_Code_Number__c, clcommon__Status__c, Ownership, clcommon__Legal_Entity_Type__c, LegalEntity_Zoho__c,Registered_Address_Road__c, Registered_Address_Premises__c  from Account where Id =:accountId and clcommon__Legal_Entity_Type__r.Name != null limit 1];
       
        if(newAccount.Current_Credit_Report__c == NULL){
            if(companyType.contains('Ind')){
        	calloutCompanyIndividuals(newAccount.KYCDB_Unique_Key_Account__c);    
        		}
        else if(companyType.contains('Reg') || companyType.contains('NonReg') ){
          	calloutCompanyRegOrNonreg(newAccount.KYCDB_Unique_Key_Account__c,companyType);  
        		}  
        }
        else {
            
            Experian_Report__c experianReport = [select id,Date_Of_Last_Credit_Report__c,Credit_Report_Link__c from Experian_Report__c where Account_Name__r.Id =: accountId order by Date_Of_Last_Credit_Report__c DESC limit 1];
            String experianDate = (experianReport.Date_Of_Last_Credit_Report__c).split(' ')[0];
            if(((system.today()).daysBetween(Date.valueOf(experianDate)))<=-90) {
               	if(companyType.contains('Ind')){
        	    calloutCompanyIndividuals(newAccount.KYCDB_Unique_Key_Account__c);    
        			}
        	else if(companyType.contains('Reg') || companyType.contains('NonReg') ) {
          		calloutCompanyRegOrNonreg(newAccount.KYCDB_Unique_Key_Account__c,companyType);  
        			}  
        		}
            else {
                Logger.warn('This credit search was run over 90 days ago. please run a new search');
            }
        	}
            Logger.saveLog();
    	}
    @future(callout=true)
    public static void calloutCompanyIndividuals(String kycNumber){
        Account newAccount = [select id,Name, AccountNumber, KYCDB_Unique_Key_Account__c,clcommon__Legal_Entity_Type__r.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, SIC_Code_Number__c, clcommon__Status__c, Ownership, clcommon__Legal_Entity_Type__c, LegalEntity_Zoho__c,Registered_Address_Road__c, Registered_Address_Premises__c  from Account where KYCDB_Unique_Key_Account__c =:kycNumber limit 1];
        String token = 'Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(true);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String individualUrl = settings.Individual__c+'?kycNumber='+kycNumber+'&forceRun=true';
		request.setEndpoint(individualUrl);
        request.setMethod('GET');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            Logger.error('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            
            Logger.debug('Response Body:'+response.getBody());
            Map < String, Object > objResponse= (Map < String, Object > ) JSON.deserializeuntyped(response.getBody());
            executeDml(objResponse,newAccount);   
        } 
        Logger.saveLog();
    }
    @future(callout=true)
	public static void calloutCompanyRegOrNonreg(String kycNumber,String companyType){
        Account newAccount = [select id,Name, AccountNumber, KYCDB_Unique_Key_Account__c,clcommon__Legal_Entity_Type__r.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, SIC_Code_Number__c, clcommon__Status__c, Ownership, clcommon__Legal_Entity_Type__c, LegalEntity_Zoho__c,Registered_Address_Road__c, Registered_Address_Premises__c  from Account where KYCDB_Unique_Key_Account__c =:kycNumber limit 1];
        String token = 'Bearer ' + SAF_CompanyHouse.fetchKycAccessToken(true);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String regOrNonRegComapnyUrl = settings.RegOrNonRegCompany_Url__c+'kycNumber='+kycNumber+'&type='+companyType+'&forceRun=true';
        Logger.debug('regOrNonRegComapnyUrl:'+regOrNonRegComapnyUrl);
		request.setEndpoint(regOrNonRegComapnyUrl);
        request.setMethod('GET');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            Logger.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            
            Logger.debug('Response Body:'+response.getBody());
            Map < String, Object > objResponse= (Map < String, Object > ) JSON.deserializeuntyped(response.getBody());
            Logger.debug('Response Body:'+objResponse);
          	executeDml(objResponse,newAccount);
        } 
        Logger.saveLog();
    }
    public static void executeDml(Map < String, Object > objResponse,Account newAccount){
        Experian_Report__c experianObj = new Experian_Report__c();
        	experianObj.Account_Name__c=newAccount.Id;
            experianObj.Credit_Report_Link__c=(String)objResponse.get('credit_report_link');
           	experianObj.Date_Of_Last_Credit_Report__c=(String)objResponse.get('date_of_last_credit_report');
            experianObj.KYC_Number__c=(String)objResponse.get('kyc_number');
            experianObj.Experain_Credit_Report_Id__c=String.ValueOf(objResponse.get('experain_credit_report_id'));
            Logger.debug('experianObj:'+experianObj);
            insert experianObj;
            Logger.saveLog();
        newAccount.Current_Credit_Report__c = experianObj.id;
        update newAccount;
    }
   
}