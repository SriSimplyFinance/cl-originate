public class Saf_ZohoAPIController {
    
     @invocablemethod(Label='Zoho API' Description='Make Zoho API call to create Opportunity')
    public static void verifyZohoAPICalls(List<Zoho_Details> zohoDetails){
         Saf_ZohoApplications.CreateInZoho(zohoDetails[0].appId,zohoDetails[0].iscreate);
    }
    public class Zoho_Details{
    @InvocableVariable(required=true)
    public List<String> appId;
    
    @InvocableVariable(required=true)
    public Boolean iscreate;

    }

}