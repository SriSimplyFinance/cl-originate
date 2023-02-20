public class KYCResponse{
    public data[] data;
    public cls_AccountUpdate[] lstAccountUpdate;
    public class data {
        public cls_errors[] errors;
        public Integer kyc_relationship_id; //1228
        public String kyc_party1_id;   //IND-344
        //public string kyc_accountId1;
        public String kyc_party1_regNumber; //08550337
        public String kyc_party2_id; //IND-3447
        //public string kyc_accountId2;       //1078
        public String kyc_party2_regNumber; //RJYU9Dhpu_g-cxrNCTrs2w-fB9A
        public string shareholder_bracket;
        public string shareholder_perc;
        public String shareholder_type; //officers
        public string cls_relationship_id;
        public cls_zoho_relationship_id zoho_relationship_id;
        public String source_data_system;   //Company House
        //public Integer modified_on; //1611449825000
        //public cls_created_on created_on;
        public cls_joint_shareholding joint_shareholding;
        public cls_joint_value joint_value;
        public cls_individual_value individual_value;
        public cls_total_value_tier_0 total_value_tier_0;
        public String officer_role; //director
        public cls_share_class share_class;
        public cls_nominal_value nominal_value;
        public cls_no_of_shares no_of_shares;
        public cls_total_value total_value;
        public Integer parent_company;  //0
        public string share_bracket_Value;
    }
    class cls_errors {
    }
    public class cls_shareholder_bracket {
    }
    class cls_shareholder_perc {
    }
    class cls_cls_relationship_id {
    }
    class cls_zoho_relationship_id {
    }
    class cls_created_on {
    }
    class cls_joint_shareholding {
    }
    class cls_joint_value {
    }
    class cls_individual_value {
    }
    class cls_total_value_tier_0 {
    }
    class cls_share_class {
    }
    class cls_nominal_value {
    }
    class cls_no_of_shares {
    }
    class cls_total_value {
    }
    class cls_share_bracket_Value {
    }
    public class cls_AccountUpdate {
        public cls_errors[] errors;
        public String id;  //2
        public string name;
        public String cls_account_id;   //8765xxxxxxxxxxui
        //public cls_zoho_account_id zoho_account_id;
       
    }
  /*  public static cls_AccountUpdate parseAccountUpdate(String json){
        return (cls_AccountUpdate) System.JSON.deserialize(json, cls_AccountUpdate.class);
    }*/

    public class cls_account {
        public String id;  //2
        public String cls_account_id;   //8765xxxxxxxxxxui
    }
    public static string parseAccount(List<cls_account> objacc){
        return (string) System.JSON.serialize(objacc);
    }
    
    public class Ind_accUpdate {
        public String id;  //kyc id
        public String name;  
        public String company_name;  
        public String cls_account_id;   //8765xxxxxxxxxxui
        public string company_number; //
        public string registered_address_line1;  //12-14,Lumley Court
        public string registered_city;   //Chester Le Street
        public string registered_postcode;  //DH2 1AN
        public string registered_county;
        public string registered_country;
        public string registered_address_premises;  //12-14
        public string registered_address_road;    //Lumley Court
        public string trading_address_line1;
        public string trading_city;
        public string trading_county;
        public string trading_postcode;
        public string trading_country;
        public string trading_address_premises;
        public string trading_address_road;
        public string sic_code;
        public string nuts_code;
        public string mobile_phone;
        public string landline;
        public string email;
        public string surname;
        public string forename;
        public string middle_name;
        public string title;
        public string date_of_birth_month;
        public string date_of_birth_day;
        public string date_of_birth_year;
        public string date_of_birth;
        public string occupation;
        public string nationality;
        public string ownership;
        public string legal_entity_type;
        public string watch_list_active;
        public string watch_list;
        public string ssid;
        public string zoho_account_id;
        public string Aggregate;
    }
    public static string parseIndAccount(List<Ind_accUpdate> objacc){
        return (string) System.JSON.serialize(objacc);
    }

    public class CalloutNewCustomer{
        //public cls_errors errors;
        public String id;  //385
        //public cls_ssid ssid;
        public String company_number;   //12987827
    }
     public static KYCResponse parse(String json){
        return (KYCResponse) System.JSON.deserialize(json, KYCResponse.class);
    }
    
    /*//public static CalloutNewCustomer parseNewCust(String json){ //HttpResponse 
    public static CalloutNewCustomer parseNewCust(HttpResponse jsonResponse){
        //return (CalloutNewCustomer) System.JSON.deserialize(json, CalloutNewCustomer.class);
        jsonResponse.setBody('{'+jsonResponse.getBody()+'}');
        String jsonString = (String)JSON.deserialize(jsonResponse.getBody(), String.class);
        system.debug('jsonResponse.getBody()---'+jsonResponse.getBody());
        system.debug('jsonString ---'+jsonString );
        //jsonString = '{'+jsonString +'}';
        system.debug('jsonString 2 ---'+jsonString);
        List<CalloutNewCustomer> respJson =(List<CalloutNewCustomer>)JSON.deserialize(jsonString, List<CalloutNewCustomer>.class);
        return respJson[0];
    }*/
    public static CalloutNewCustomer parseNewCust(String json){
        return (CalloutNewCustomer) System.JSON.deserialize(json, CalloutNewCustomer.class);
    }
    /*public static calloutIndividualWithAccount parseIndAcc(String json){
        return (calloutIndividualWithAccount) System.JSON.deserialize(json, calloutIndividualWithAccount.class);
    }*/
   }