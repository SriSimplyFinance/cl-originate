public class KYCOfficersResponse {
  public String etag;
  public String kind;
  public Integer inactive_count;
  public String company_Number;
  public Integer total_results;
  public Link[]	link;
  public String errors;
  public Integer resigned_count;
  public String active_count;
  public Integer start_index;
  public Integer items_per_page;
  public Item[] items;
  
    public class Item {        
        public string id;
        public String name;
        public String appointed_on;
        public String resigned_on;
        public String middle_name;
        public String title;
        public String surname;
        public String forename;
        public String officer_role;
        public String occupation;
        public String source_data_system;
        public String created_on;
        public String country_of_residence;
        public String nationality;
        public Address address;
        public DateOfBirth date_of_birth;
        public Links links;
    }
    public class Link {
      public String self;
      public String officers;
      public String charges;
      public String filing_history;  
    }
    public class Links {
      public Officers officer;
      public String self;
     	  
    }
    Public class Officers{
        public String appointments;
    }
    public class DateOfBirth{
      public String month;
      public String year;
     }
    
    public class Address{
        public String address_line_1;
        public String address_line_2;
        public String locality;
        public String country;
        public String postal_code;
        public String premises;
        public String region;
        public String registered_address_line1;
        public String registered_city;
        public String registered_county;
        public String registered_country;
        public String registered_postcode;
        public String registered_address_premises;
        public String registered_address_road;
    }
    

}