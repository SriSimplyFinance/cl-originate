public class SFDCUserSessionGenerateCtrl {
    public class CallOptions_element {
        public String client;
        public String defaultNamespace;
        private String[] client_type_info = new String[]{'client','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] defaultNamespace_type_info = new String[]{'defaultNamespace','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'client','defaultNamespace'};
    }
    public class GetUserInfoResult {
        public Boolean accessibilityMode;
        public String currencySymbol;
        public Integer orgAttachmentFileSizeLimit;
        public String orgDefaultCurrencyIsoCode;
        public Boolean orgDisallowHtmlAttachments;
        public Boolean orgHasPersonAccounts;
        public String organizationId;
        public Boolean organizationMultiCurrency;
        public String organizationName;
        public String profileId;
        public String roleId;
        public Integer sessionSecondsValid;
        public String userDefaultCurrencyIsoCode;
        public String userEmail;
        public String userFullName;
        public String userId;
        public String userLanguage;
        public String userLocale;
        public String userName;
        public String userTimeZone;
        public String userType;
        public String userUiSkin;
        private String[] accessibilityMode_type_info = new String[]{'accessibilityMode','urn:partner.soap.sforce.com','boolean','1','1','false'};
        private String[] currencySymbol_type_info = new String[]{'currencySymbol','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] orgAttachmentFileSizeLimit_type_info = new String[]{'orgAttachmentFileSizeLimit','urn:partner.soap.sforce.com','int','1','1','false'};
        private String[] orgDefaultCurrencyIsoCode_type_info = new String[]{'orgDefaultCurrencyIsoCode','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] orgDisallowHtmlAttachments_type_info = new String[]{'orgDisallowHtmlAttachments','urn:partner.soap.sforce.com','boolean','1','1','false'};
        private String[] orgHasPersonAccounts_type_info = new String[]{'orgHasPersonAccounts','urn:partner.soap.sforce.com','boolean','1','1','false'};
        private String[] organizationId_type_info = new String[]{'organizationId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] organizationMultiCurrency_type_info = new String[]{'organizationMultiCurrency','urn:partner.soap.sforce.com','boolean','1','1','false'};
        private String[] organizationName_type_info = new String[]{'organizationName','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] profileId_type_info = new String[]{'profileId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] roleId_type_info = new String[]{'roleId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] sessionSecondsValid_type_info = new String[]{'sessionSecondsValid','urn:partner.soap.sforce.com','int','1','1','false'};
        private String[] userDefaultCurrencyIsoCode_type_info = new String[]{'userDefaultCurrencyIsoCode','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] userEmail_type_info = new String[]{'userEmail','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] userFullName_type_info = new String[]{'userFullName','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] userLanguage_type_info = new String[]{'userLanguage','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] userLocale_type_info = new String[]{'userLocale','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] userName_type_info = new String[]{'userName','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] userTimeZone_type_info = new String[]{'userTimeZone','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] userType_type_info = new String[]{'userType','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] userUiSkin_type_info = new String[]{'userUiSkin','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessibilityMode','currencySymbol','orgAttachmentFileSizeLimit','orgDefaultCurrencyIsoCode','orgDisallowHtmlAttachments','orgHasPersonAccounts','organizationId','organizationMultiCurrency','organizationName','profileId','roleId','sessionSecondsValid','userDefaultCurrencyIsoCode','userEmail','userFullName','userId','userLanguage','userLocale','userName','userTimeZone','userType','userUiSkin'};
    }
    public class login_element {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] password_type_info = new String[]{'password','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
    public class loginResponse_element {
        public SFDCUserSessionGenerateCtrl.LoginResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com','LoginResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class LoginResult {
        public String metadataServerUrl;
        public Boolean passwordExpired;
        public Boolean sandbox;
        public String serverUrl;
        public String sessionId;
        public String userId;
        public SFDCUserSessionGenerateCtrl.GetUserInfoResult userInfo;
        private String[] metadataServerUrl_type_info = new String[]{'metadataServerUrl','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] passwordExpired_type_info = new String[]{'passwordExpired','urn:partner.soap.sforce.com','boolean','1','1','false'};
        private String[] sandbox_type_info = new String[]{'sandbox','urn:partner.soap.sforce.com','boolean','1','1','false'};
        private String[] serverUrl_type_info = new String[]{'serverUrl','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] sessionId_type_info = new String[]{'sessionId','urn:partner.soap.sforce.com','string','1','1','true'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] userInfo_type_info = new String[]{'userInfo','urn:partner.soap.sforce.com','GetUserInfoResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'metadataServerUrl','passwordExpired','sandbox','serverUrl','sessionId','userId','userInfo'};
    }
    public class LoginScopeHeader_element {
        public String organizationId;
        public String portalId;
        private String[] organizationId_type_info = new String[]{'organizationId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] portalId_type_info = new String[]{'portalId','urn:partner.soap.sforce.com','ID','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'organizationId','portalId'};
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','urn:partner.soap.sforce.com','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class Soap {
        public String endpoint_x ;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public SFDCUserSessionGenerateCtrl.LoginScopeHeader_element LoginScopeHeader;
        private String LoginScopeHeader_hns = 'LoginScopeHeader=urn:partner.soap.sforce.com';
        public SFDCUserSessionGenerateCtrl.CallOptions_element CallOptions;
        private String CallOptions_hns = 'CallOptions=urn:partner.soap.sforce.com';
        private String[] ns_map_type_info = new String[]{'urn:sobject.partner.soap.sforce.com','sobjectSFDCUserSessionGenerateCtrl','urn:partner.soap.sforce.com','SFDCUserSessionGenerateCtrl','urn:fault.partner.soap.sforce.com','faultSFDCUserSessionGenerateCtrl'};

        public SFDCUserSessionGenerateCtrl.LoginResult login(String username,String password) {
            SFDCUserSessionGenerateCtrl.login_element request_x = new SFDCUserSessionGenerateCtrl.login_element();
            SFDCUserSessionGenerateCtrl.loginResponse_element response_x;
            request_x.username = username;
            request_x.password = password;
            Map<String, SFDCUserSessionGenerateCtrl.loginResponse_element> response_map_x = new Map<String, SFDCUserSessionGenerateCtrl.loginResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'urn:partner.soap.sforce.com',
                'login',
                'urn:partner.soap.sforce.com',
                'loginResponse',
                'SFDCUserSessionGenerateCtrl.loginResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}