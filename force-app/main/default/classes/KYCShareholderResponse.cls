public class KYCShareholderResponse {
    public Data[] data{get;set;}
  public string company_Number{get;set;}
    public class Data {        
        public string id{get;set;}
        public String name{get;set;}
        public String ceased_on{get;set;}
        public String legal_entity_type{get;set;}
        public String legal_entity_type_id{get;set;}
        public String ownership{get;set;}
        public String parentCompany{get;set;}
        public String bracket{get;set;}
        public String shareholder_perc{get;set;}
        public String nationality{get;set;}
        public String country_of_residence{get;set;}
        public String identification{get;set;}
        public String notified_xon{get;set;}
        public String kind{get;set;}
        public String etag{get;set;}
        public String cls_account_id{get;set;}
        public Address address{get;set;}
        public Link links{get;set;}
        public Name_elements name_elements{get;set;}
        public Date_of_birth date_of_birth{get;set;}
    }
    public class Link {
      public String self{get;set;}
      public String officers{get;set;}
      public String charges{get;set;}
      public String filing_history{get;set;}
    }
    public class Date_of_birth{
      public String month{get;set;}
      public String year{get;set;}
     }
    public class Name_elements{
      public String middle_name{get;set;}
      public String title{get;set;}
      public String surname{get;set;}
      public String forename{get;set;}
    }
    public class Address{
        public String address_line_1{get;set;}
        public String address_line_2{get;set;}
        public String locality{get;set;}
        public String country{get;set;}
        public String postal_code{get;set;}
        public String premises{get;set;}
        public String region{get;set;}
        public String registered_address_line1{get;set;}
        public String registered_city{get;set;}
        public String registered_county{get;set;}
        public String registered_country{get;set;}
        public String registered_postcode{get;set;}
        public String registered_address_premises{get;set;}
        public String registered_address_road{get;set;}
    }
    public class NaturesOfControl {
      //public String ownership-of-shares-75-to-100-percent;
      //public String voting-rights-75-to-100-percent;
      //public String right-to-appoint-and-remove-directors;
    }   
}