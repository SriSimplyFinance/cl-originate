public class KYCRelationshipResponse {
public data[] data;
     public class data {        
       public String[] errors;
		public String kyc_relationship_id;
        public String kyc_party1_id;
        public String kyc_party1_regNumber;
        public String kyc_party2_id;
        public String kyc_party2_regNumber;
        public String shareholder_bracket;
        public String shareholder_perc;
        public String shareholder_type;
        public String cls_relationship_id;
        public String zoho_relationship_id;
        public String source_data_system;
        public String  modified_on;
        public String created_on;
        public String joint_shareholding;
        public String joint_value;
        public String individual_value;
        public String total_value_tier_0;
        public String officer_role;
        public String share_class;
        public String nominal_value;
        public String no_of_shares;
        public String total_value;
        public Integer parent_company;
        public String share_bracket_Value;
     }
}