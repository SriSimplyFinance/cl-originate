/**
    @ name                      : SAF_ClsToZoho
    @ author                    : Happiest Minds/Phalguni
    @ description               : create/update the customer to zoho
    @ created date              : 11/16/2018  
    @ Modified by / Date        : 11/19/2018 
*/
Public class SAF_ClsToZoho
{
    
      public static final string COUNTRY_CODE = 'GB';
      // static Saf_Duedil__c settings = Saf_Duedil__c.getOrgDefaults();
      private static saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
      //Prepares the request
      //private static string ZohoAccessToken;
      
       public static string ZohoAccessToken = '';
      public static integer RetryToken =1;
     // public static boolean TokenExpired;
     
      public static string fetchZohoAccessToken(boolean IsTokenExpired)
      {
        String initialResponse = '';
        Http httpObj = new Http();
        string requestBody = 'client_id='+ objSettings.client_id__c + '&' + 
        'client_secret=' + objSettings.client_secret__c + '&' +
        'refresh_token=' + objSettings.refresh_token__c +'&' +
        'grant_type=' + objSettings.grant_type__c;
        //'username:phalguni.tandel@happiestminds.com.quickwuat' + '/r' +
        //'password:happy2019' +'/r' +
        //'grant_type:password';
        //string javabody = 'client_id=1000.GMC8W86AU7EC08023FD510L45PCSII&client_secret=a7c4723fe5e0bc62eb932667920b9fbea61cb0262a&refresh_token=1000.835fa04a6b25822f32ec9798faa2ee72.d4266af45d925a31fcf239a92c7bac9b&grant_type=refresh_token';
        
         if((objSettings.saf_ZohoAccesstoken__c == null && ZohoAccessToken == '') || (IsTokenExpired &&  ZohoAccessToken != ''))//ZohoAccessToken  != objSettings.saf_ZohoAccesstoken__c ||
       {
         system.debug('inside fetchaccesstoken: '+ IsTokenExpired);
        
        HttpRequest request = new HttpRequest();
        request.setBody(requestBody );
        system.debug('requestBody ---------------'+requestBody);
        request.setMethod('POST');
        //request.setTimeout(120000);
       
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Accept','application/json');
      
      
         
             
         /* request.setHeader('client_id','3MVG9X0_oZyBSzHpK2w79igiplxMQs3W9vou83Yc0axq5larN5vvz_IezafElAFhS1xHsrX.bnPCGu3F.MV9V');
            request.setHeader('client_secret', '7960050530337934334');
            request.setHeader('username',  'phalguni.tandel@happiestminds.com.quickwuat'); 
            request.setHeader('password',  'happy2019'); 
            request.setHeader('grant_type', 'password');*/
           
          
               
        request.setEndpoint(objSettings.zoho_AccessEndpoint__c); //('https://accounts.zoho.eu/oauth/v2/token');
        system.debug('request in utility---------------'+request);
         HttpResponse response = new HttpResponse();
      /*  response = httpObj.send(request);
        system.debug('===response ==='+response );
        string strbodyresp = response.getbody();
        system.debug('===strbodyresp ==='+strbodyresp);
         if(response.getStatusCode() == 200)
        {
         //Process response
          ZohoAccessResponse objexp = processResponse(strbodyresp);
          system.debug('===objexp ==='+objexp);
        }*/
         
         
          //Get the HTTP response
        Map<String,String> responseMap = fireRequestMap(httpObj,request);
        
        //Validate response
        if(responseMap.size()>0 && responseMap.containsKey('SUCCESS')){
        
           //Process response
           ZohoAccessResponse objexp = processResponse(responseMap.get('SUCCESS'));
           RetryToken = RetryToken + 1;
         
           if(objexp.access_token!=null){
               initialResponse = objexp.access_token;
           }
        }else{
            //Handle exception/errors
            initialResponse = 'ERROR';
             RetryToken =0;
            //Create Error logs and send mail to admin
            ErrorLogsUtils.createErrorLogs('', 'SAF_ClsToZoho', 'fetchZohoAccessToken', String.valueOf(responseMap.keyset()),'', 
            String.valueOf(request), String.valueOf(responseMap.values()), true, ErrorLogsUtils.ERROR, true, 
            'SAF_ClsToZoho Exception in fetchZohoAccessToken method', String.valueOf(responseMap.values()));
            
        }
          system.debug('initialResponseeeeeeeeeeeeeee'+initialResponse);
                    ZohoAccessToken = initialResponse;
           // objSettings.saf_ZohoAccesstoken__c = ZohoAccessToken;
            //Update objSettings;
            //system.debug('objSettings:' +objSettings);
                 
         
          
         
     }
     else
     {
         if(objSettings.saf_ZohoAccesstoken__c != '') ZohoAccessToken = objSettings.saf_ZohoAccesstoken__c;
         system.debug('ZohoAccessToken '+ZohoAccessToken ); 
     }
      //
       return ZohoAccessToken;   
       
    }
       /*****************************************************************************************************************
    *    Method Name   :    fireRequestMap
    *    Description   :    Fires HTTP request and stores the response with SUCCESS/FAILURE
    *    Params        :    HttpRequest request
    *    Return Type   :    Map<String,String>
    ******************************************************************************************************************/        
    
    public static Map<String,String> fireRequestMap(Http httpObj,HttpRequest request){
       Map<String,String> responseMap = new Map<String,String>{};
       HttpResponse response = new HttpResponse();
       
       String fetchedResponse = '';
       try {
             /*system.debug('===fireRequestMap request==='+request.getBody());
             system.debug('===fireRequestMap request==='+request.getHeader('Client_id'));
             system.debug('===fireRequestMap request==='+request.getHeader('Client_secret'));
             system.debug('===fireRequestMap request==='+request.getHeader('Content-Type'));*/
             
            response = httpObj.send(request);
           system.debug('===fireRequestMap==='+response );
            if(response.getStatusCode() == 200){//OK
                
                 string strbodyresp = response.getbody();
                 responseMap.put('SUCCESS', strbodyresp );
                 system.debug('===strbodyresp ==='+strbodyresp);
                
            }else if(response.getStatusCode() == 201 ){//Created
                responseMap.put('SUCCESS', response.getBody());                
                
            }else{
                responseMap.put('FAILURE', response.getBody());
            }
            
       } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            responseMap.put('FAILURE', e.getMessage());           
       } 
        
       return responseMap;
    }
    public static ZohoAccessResponse processResponse(string response){
     ZohoAccessResponse objResponse = (ZohoAccessResponse)JSON.deserialize(response,ZohoAccessResponse.class);
         if(objResponse !=null){
             return objResponse ;
         }else{
             return null;
         }
    }
    
    /*****************************************************************************************************************
    *    Class Name    :    Zoho Response
    *    Description   :    Wrapper class specifically for Zoho Integration
    ******************************************************************************************************************/        
    
    public class ZohoAccessResponse{

        public Integer expires_in_sec;
        public string access_token;    
        public String api_domain;
        public String token_type;
        public Integer expires_in;
      

    }
      public class ZohoUsers{
     public cls_users[] users;
     public cls_info info;
    }
   
    public class cls_users {
        public String country;  //gb
        public cls_role role;
        //public cls_city city;
        public String language; //en_GB
        public String locale;   //en_US
        public boolean microsoft;
        public boolean Isonline;
        public cls_Modified_By Modified_By;
        //public cls_alias alias;
        public String id;   //10777000001268001
        //public cls_state state;
        public String country_locale;   //US
        public String first_name;   //Paul
        public String email;    //paul.morrison@simply.finance
        //public cls_Reporting_To Reporting_To;
        //public cls_zip zip;
        public String created_time; //2019-08-01T15:35:00+05:30
        public String Modified_Time;    //2019-08-01T15:35:00+05:30
        public String time_format;  //hh:mm a
        public Integer offset;  //0
        public cls_profile profile;
        //public cls_mobile mobile;
        public String last_name;    //Morrison
        public String time_zone;    //GMT
        public cls_created_by created_by;
        public String zuid; //20067174770
        public boolean confirm;
        public String full_name;    //Paul Morrison
        public string SFDC;
        public cls_territories[] territories;
        //public cls_phone phone;
        public String date_format;  //MM/dd/yyyy
        public String status;   //active
        public String zohoId;
    }
    public class cls_role {
        public String name; //Sales Manager
        public String id;   //10777000001201297
    }
    public class cls_city {
    }
    public class cls_Modified_By {
        public String name; //System Admin
        public String id;   //10777000000140034
    }
    public class cls_alias {
    }
    public class cls_state {
    }
    public class cls_Reporting_To {
    }
    public class cls_zip {
    }
    public class cls_profile {
        public String name; //Standard
        public String id;   //10777000001182794
    }
    public class cls_mobile {
    }
    public class cls_created_by {
        public String name; //System Admin
        public String id;   //10777000000140034
    }
    public class cls_SFDC {
    }
    public class cls_territories {
    }
    public class cls_phone {
    }
    public class cls_info {
        public Integer per_page;    //200
        public Integer count;   //117
        public Integer page;    //1
        public boolean more_records;
    }
   
 public class cls_account{
    public List<cls_data> data;
    public cls_info info;
    }
    public class cls_data {
        /*public cls_Mobile_Phone Mobile_Phone;
        public cls_Owner Owner;
        public cls_Ownership Ownership;
        public cls_VAT_Number VAT_Number;
        //public String $currency_symbol; //£
        //public cls_$review_process $review_process;
        public cls_Current_Agreement_Exposure Current_Agreement_Exposure;
        public String County_Registered;    //West Yorkshire
        public String Country_Yard; //United Kingdom
        public boolean Do_not_market;
        public cls_Landline_Phone Landline_Phone;
        public String Last_Activity_Time;*/   //2019-09-20T19:27:52+05:30
        public String CLS_Customer_Id;  //0016E00000u3LdTQAU
        //public cls_$review $review;
        //public boolean $process_flow;
        public String Account_Name; //Wal-Mart Stores (UK) Limited
        public String id;   //10777000001358008
        /*public cls_NUTS3_Code NUTS3_Code;
       // public boolean $approved;
        public String Building_Name;    //Asda House Great Wilson Street
        public cls_Created_User Created_User;
        //public cls_$approval $approval;
        public String Modified_Time;    //2019-08-17T15:36:52+05:30
        public String County_Yard;  //West Yorkshire
        public cls_Approved_Email Approved_Email;
        public String Created_Time; //2019-08-08T15:06:33+05:30
        //public boolean $editable;
        public String Registered_Address_City;  //Leeds
        public String Postcode; //LS11 5AD
        public boolean Market;
        public cls_Current_Application_Exposure Current_Application_Exposure;
        public Integer Arrears; //0
        public String Postcode_Yard;    //LS11 5AD
        public String Company_Registration_No;  //03759197
        public cls_Parent_Account Parent_Account;
        public String Registered_Address_Country;   //United Kingdom
        public String SIC_Code_New; //80200
        public String Type; //Customer
        public String Address_1_Yard;   //Asda House Great Wilson Street
        public String City_Yard;    //Leeds
        public cls_Last_Modified_By Last_Modified_By;
        public cls_Tag[] Tag;
        public cls_Agreed_Marketing_Type[] Agreed_Marketing_Type;*/
    }
    public class cls_Mobile_Phone {
    }
    public class cls_Owner {
        public String name; //Sumit Kamra
        public String id;   //10777000000140188
    }
    public class cls_Ownership {
    }
    public class cls_VAT_Number {
    }
   // public class cls_$review_process {
   // }
    public class cls_Current_Agreement_Exposure {
    }
    public class cls_Landline_Phone {
    }
    //public class cls_$review {
    //}
    public class cls_NUTS3_Code {
    }
    public class cls_Created_User {
    }
    /*public class cls_$approval {
        public boolean delegate;
        public boolean approve;
        public boolean reject;
        public boolean resubmit;
    }*/
    public class cls_Approved_Email {
    }
    public class cls_Current_Application_Exposure {
    }
    public class cls_Parent_Account {
    }
    public class cls_Last_Modified_By {
    }
    public class cls_Tag {
    }
    public class cls_Agreed_Marketing_Type {
    }
   /* public class cls_info {
        public Integer per_page;    //200
        public Integer count;   //1
        public Integer page;    //1
        public boolean more_records;
    }
    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }*/

    

    
 }