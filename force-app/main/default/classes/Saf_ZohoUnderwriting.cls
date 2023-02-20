global class Saf_ZohoUnderwriting{
         //public class cls_dataAcc {
           public cls_data[] data;
           private static saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
           public static boolean TokenExpired = false;
        // }
                
        public class cls_data {
            public String code; //SUCCESS
            public cls_details details;
            public String message;  //record added genesis_Application__c
            public String status;   //success
        }
        public class cls_details {
            public String Modified_Time;    //2019-07-22T12:52:38+05:30
            public cls_Modified_By Modified_By;
            public String Created_Time; //2019-07-22T12:52:38+05:30
            public String id;   //10777000001221002
            public cls_Created_By Created_By;
        }
        public class cls_Modified_By {
            public String name; //Happiest Minds Dev
            public String id;   //10777000000162006
        }
        public class cls_Created_By {  
            public String name; //Happiest Minds Dev
            public String id;   //10777000000162006
        }
        public static Saf_ZohoUnderwriting parse(String json){
            return (Saf_ZohoUnderwriting) System.JSON.deserialize(json, Saf_ZohoUnderwriting.class);
        }
        public static SAF_ClsToZoho.ZohoUsers parseUser(String json){
        return (SAF_ClsToZoho.ZohoUsers) System.JSON.deserialize(json, SAF_ClsToZoho.ZohoUsers.class);
       }
        public static void testParse(String json2) {
        String json= ' {"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}'+
        '';
        String json1= '{"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:36:26+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:36:26+05:30","id":"10777000001221089","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}';
        Saf_ZohoUnderwriting obj = parse(json2);
        system.debug('***objzoho : '+obj);
    }
    public static Map<string,SAF_ClsToZoho.cls_users> getUserInzoho() {
         string strReturnmsg = 'Failure';
        // saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
         HttpRequest req = new HttpRequest();
         Map<string,SAF_ClsToZoho.cls_users> mapuser = new Map<string,SAF_ClsToZoho.cls_users>();
         string url = objSettings.zoho_GetUsersEndpoint__c; 
        
         SAF_ClsToZoho.ZohoUsers gp = new SAF_ClsToZoho.ZohoUsers();
        
        
       // string token = 'Bearer ' + '1000.7c6294f32afc8ac73f82065a6704ac42.3b9f3d524b6be2393984a498f6583826'; 
        string token = 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken(TokenExpired); 
        System.debug('Tokennnnnnnnnnnnn'+token);
        
         req.setEndpoint(url);
         req.setMethod('GET');
         req.setHeader('Authorization',token);
         req.setHeader('Content-Type','application/json');
         System.debug('user req'+req.getBody());
        
         // Create a new http object to send the request object
         // A response object is generated as a result of the request  
      
         Http http = new Http();
         HTTPResponse res = http.send(req);
          
         String jsonStr = res.getBody() + '';
         system.debug('***Jsonstring: '+jsonStr);
         system.debug('***res.getStatusCode(): '+res.getStatusCode()); 
         if(res.getStatusCode() == 201 || res.getStatusCode() == 200)
         {
             System.debug('response'+res);
             gp = parseUser(jsonStr);
             System.debug('==='+gp);
             
             if(gp.users.size()>0)
             {
                for(SAF_ClsToZoho.cls_users objuser:gp.users)
                {
                  if(objuser.status == 'active')
                  {
                      mapuser.put(objuser.email,objuser);
                      system.debug('objuser email:' + objuser.email + ':' + objuser.id);
                  }
                }
             }
         }else {
                 if(res.getStatusCode() == 401)
                 {
                     //SAF_ClsToZoho.ZohoAccessToken ='';
                      TokenExpired = true;
                      system.debug('SAF_ClsToZoho.RetryToken :' +SAF_ClsToZoho.RetryToken);
                      if(SAF_ClsToZoho.RetryToken <= 3)getUserInzoho();
                  }
                 //Saf_ExperainTest objExp = new Saf_ExperainTest();
                 //gp = parse(objExp.strjsonNLcompany);
                  //gp.Responemessage = res.getStatus();
               //  if(res.getStatusCode() == 202 && gp.data.size()>0) { strReturnmsg = gp.data[0].message + ' :' + gp.data[0].status;}
               system.debug('err');
               } 
         
        return mapuser;
    } 
      //@InvocableMethod
      @future(Callout=true)
      webservice static void CreateInZoho(List<string> objUndId,boolean iscreate){
         CreateAccountInZoho(objUndId[0],iscreate);  
      }
      Webservice static string CreateAccountInZoho(string objUndId,boolean IsCreate) {
         string strReturnmsg = 'Failure';
        // saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
        //getallUser info from Zoho
       
         HttpRequest req = new HttpRequest();
         string url = objSettings.zoho_CretaOppEndpoint__c; 
         Underwriting__c objUnd = new Underwriting__c();
         Saf_ZohoUnderwriting gp = new Saf_ZohoUnderwriting();
         List<Underwriting__c> lstund = [Select Id,Name,genesis_Application__r.Zoho_Customer_Id__c from Underwriting__c where Id =: objUndId];
         system.debug('***lstund: '+lstund);
          if(lstund.size() >0) {
         objUnd = lstund[0];
         string token = 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken(TokenExpired); 
          System.debug('token'+token);
         string strpost = (IsCreate) ? 'POST' : 'PUT';
         req.setEndpoint(url);
         req.setMethod(strpost);
         req.setHeader('Authorization',token);
         req.setHeader('Accept','application/json');
         string requestBodycreate =   '{'+
        '  "data": ['+
        '    {'+
        '      "Owner": {'+
        '        "id": "10777000000710007"'+
        '      },'+
        '      "id": "10777000001223134",'+
        '      "Ownership": "Private",'+
        '      "Description": "Design your own layout",'+
        '      "SIC_Code": 12792,'+
        '      "Account_Name": "Kavya",'+
        '      "Account_Number": "1245678",'+
        '    }'+
        '  ]'+
        '}';  
         
         string requestBody =   '{'+
        '  "data": ['+
        '    {'+
        '      "Owner": {'+
        '        "id": "10777000000710007"'+
        '      },'+
        '      "id": "10777000001223134",'+
        '      "Ownership": "Private",'+
        '      "Description": "Design your own layout",'+
        '      "Account_Type": "Competitor",'+
        '      "Rating": "Active",'+
        '      "SIC_Code": 12792,'+
        '      "Shipping_State": "Shipping_State",'+
        '      "Website": "crm.zoho.com",'+
        '      "Employees": 12792,'+
        '      "Industry": "Data/Telecom OEM",'+
        '      "Account_Site": "Account_Site",'+
        '      "Phone": "988844559",'+
        '      "Billing_Country": "Billing_Country",'+
        '      "Account_Name": "krishna venkat2",'+
        '      "Account_Number": "1245678",'+
        '      "Ticker_Symbol": "Ticker_Symbol",'+
        '      "Billing_Street": "Billing_Street",'+
        '      "Billing_Code": "Billing_Code",'+
        '      "Shipping_City": "Shipping_City",'+
        '      "Shipping_Country": "Shipping_Country",'+
        '      "Shipping_Code": "Shipping_Code",'+
        '      "Billing_City": "Billing_City",'+
        '      "Billing_State": "Billing_State",'+
        '      "Fax": "Fax",'+
        '      "Annual_Revenue": 127.67,'+
        '      "Shipping_Street": "Shipping_Street"'+
        '    }'+
        '  ]'+
        '}';
        string strRequestBody = GetRequestbody(objUnd,IsCreate);
        req.setBody(strRequestBody);
        system.debug('strRequestBody---------------'+strRequestBody);
         // Create a new http object to send the request object
         // A response object is generated as a result of the request  
      
         Http http = new Http();
         System.debug('ID req'+req);
         HTTPResponse res = http.send(req);
          
         String jsonStr = res.getBody() + '';
         system.debug('***Jsonstring: '+jsonStr);
         system.debug('***res.getStatusCode(): '+res.getStatusCode());  
          if(res.getStatusCode() == 201 || res.getStatusCode() == 200)
         {    
             gp = parse(jsonStr);
             System.debug('zohoresp'+jsonStr);
             if(gp.data.size()>0)
             {
               string strzohoId = gp.data[0].details.id;
                system.debug('***strzohoId : '+strzohoId );
                if(IsCreate) {UpdateZohoId(objUnd,strzohoId);}
                UpdateToken();
                strReturnmsg = strzohoId ; //gp.data[0].message + ' :' + gp.data[0].status;
             }
         }else {
                 if(res.getStatusCode() == 401)
                 {
                     //SAF_ClsToZoho.ZohoAccessToken ='';
                     TokenExpired = true;
                     system.debug('SAF_ClsToZoho.RetryToken :' +SAF_ClsToZoho.RetryToken);
                     if(SAF_ClsToZoho.RetryToken <= 3) CreateAccountInZoho(objUndId,IsCreate);
                  }
                 //Saf_ExperainTest objExp = new Saf_ExperainTest();
                 //gp = parse(objExp.strjsonNLcompany);
                  //gp.Responemessage = res.getStatus();
               //  if(res.getStatusCode() == 202 && gp.data.size()>0) { strReturnmsg = gp.data[0].message + ' :' + gp.data[0].status;}
               }
        }
        // gp.ResponeCode = res.getStatusCode();
         return strReturnmsg;
        }
        public static Map<String,object> getQuery(string strUnderwritingId)
        {
            
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType UnderwritingSchema = schemaMap.get('Underwriting__c');
                Map<String, Schema.SObjectField> fieldMap = UnderwritingSchema.getDescribe().fields.getMap();
              
                //List<Account> opp=[Select name,id,IsDeleted,MasterRecordId,Type from Account limit 1];
                system.debug('fieldMap :'+fieldMap);
                 Map<String,object> valueMap=new Map<String,object>();
                string str = '';
                for(String fieldName: fieldMap.keySet())  
                {
                 str = str + fieldName + ',';
                }

                 //str = str.replace('marketing_preference_checklist__c,' ,'marketing_preference_checklist__c');
                 //str = str.replace('parent_customer_name__c,' ,'parent_customer_name__c');
                 //str = str.removeend(',');
                 string strquery = 'Select '+ str + '(select condition__c from Underwriter_comments__r),genesis_Application__r.genesis__description__c FROM Underwriting__c where Id = :strUnderwritingId limit 1';//',CreatedBy.Name
                 system.debug('strquery :' +strquery );
                 List<Underwriting__c> lstund = Database.query(strquery);
                system.debug('lstund :' +lstund);
               
                for(Underwriting__c o:lstund)
                {
                    for(String fieldName: fieldMap.keySet())
                    {
                     if((o.get(fieldName))!=null)
                         {
                            valueMap.put(String.valueof(fieldName),o.get(fieldName));//,String.valueof(
                            valueMap.put('genesis_Application__r.genesis__description__c','<p>testing zoho opp</p>');
                          }
                    //break;
                      system.debug('valueMap1 :' +String.valueof(fieldName));
                      system.debug('value1 :' +String.valueof(o.get(fieldName)));
                    }                         
             }

                system.debug('valueMap :' +valueMap);
                return valueMap;
        }
         
         public static String GetRequestbody(Underwriting__c objUnd,boolean Iscreate)
        {
            String condition2='';
            List<Underwriter_condition__c> lstconditions=[select Condition__c ,Underwriting__c  from Underwriter_condition__c where Underwriting__c=:objUnd.id];
            if(lstconditions.size()>0){
                    for(Underwriter_condition__c objcon:lstconditions)
                    {
                        if(objcon.Condition__c != null || objcon.Condition__c != '')  condition2= condition2 + ', ' + String.valueOf(objcon.Condition__c);
                    }
                   if(condition2 != '') condition2 = condition2.removeend(',').removestart(',');
                }
            System.debug('condition=!!!'+condition2);
            
              Map<string,SAF_ClsToZoho.cls_users> mapuser = getUserInzoho();
               system.debug('mapuser :' +mapuser.keyset());
            List<Saf_ZohoUWFieldMapping__c> mcs = Saf_ZohoUWFieldMapping__c.getall().values();
           
                 string requestBodycreate =   '{'+
                '  "data": ['+
                '    {';
               // '      "Owner": {'+
               // '        "id": "10777000000710007"'+
               // '      },';
               
            if(!Iscreate) { requestBodycreate = requestBodycreate + '      "id": "'+objUnd.genesis_Application__r.Zoho_Customer_Id__c +'",';}//10777000001223134;
               
            Map<String,object> mapvalues = getQuery(objUnd.Id);
            
            for(Saf_ZohoUWFieldMapping__c    os: mcs)
            {
                 //system.debug();
                system.debug('map : '+ os.Salesforce_Field__c + ':'+ mapvalues.get(os.Salesforce_Field__c));
                
                if(os.Salesforce_Field__c !=null && os.Zoho_Fields__c != ''  )
                {
                   if(os.Salesforce_Field__c == 'underwriter__c')// || os.Salesforce_Field__c == 'createdbyid' || os.Salesforce_Field__c == 'lastmodifiedbyid')
                   {
                     string userid = string.valueof(mapvalues.get(os.Salesforce_Field__c));
                     List<User> lstuser = [Select id,name,email from User where id =: userid limit 1];
                       System.debug('lstuser size='+lstuser.size());
                     system.debug('lstuser :' +lstuser);
                       string d;
                       if(lstuser.size()>0)
                       {
                     string v =string.valueof(lstuser[0].email);
                           d=v;
                       }
                     string strzohoUserId = mapuser.containskey(d) ? mapuser.get(d).id : '10777000000140034';
                     system.debug('strzohoUserId :' +strzohoUserId );
                     requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": {"id":"'+ strzohoUserId +'"},';
                   }
                    else if(os.Salesforce_Field__c == 'condition__c')
                    {
                        String con=String.valueOf(mapvalues.get(os.Salesforce_Field__c)); 
                        System.debug('con='+con);
                        con = (String.isEmpty(con)) ? condition2 : con;
                        requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+con+'",';
                        System.debug('requestBodycreatecondition'+requestBodycreate);
                    }
                 else if(os.Salesforce_Field__c == 'lastmodifieddate')
                   { 
                    string res;
                    
                    if(mapvalues.get(os.Salesforce_Field__c) != null) res = String.valueof(mapvalues.get(os.Salesforce_Field__c));//.replace(';','";"')).split
                    System.debug('Before printing the salesforce result field date is::::::'+res);
                    Date  newDate = date.valueof(res) ;
                   // Date myDate = date.newinstance(newDate.year(), newDate.month(), newDate.day());
                    String myDate=String.valueof(date.newinstance(newDate.year(), newDate.month(), newDate.day())); 
                     System.debug('Before printing the datatatatat'+myDate);
                    //lst = mapvalues.get(os.Salesforce_Field__c).split(';');
                   requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ myDate +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('Before printing the requestBodycreaterequestBodycreate'+requestBodycreate);
                   }
                   else
                   {
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ mapvalues.get(os.Salesforce_Field__c) +'",';
                   } requestBodycreate = requestBodycreate.replace('"true"','true').replace('"false"','false').replace('"null"','null');
                    //system.debug(requestBodycreate);
                }
            }
            
             requestBodycreate =  requestBodycreate + '    }'+
                '  ]'+
                '}';
            requestBodycreate = requestBodycreate.replace(',    }  ]}','    }  ]}');
            return requestBodycreate;
        }
         public static void UpdateZohoId(Underwriting__c objAcc,string ZohoId) {
         
         //List<Account> lstacc = [Select Id,Name,Zoho_Customer_Id__c from Account where Id =: objAcc.Id];
         if(objAcc!= null)
          {
             // for(Account objac: lstacc)
            //  {
                  objAcc.genesis_Application__r.Zoho_Customer_Id__c = ZohoId;
            //  }
              update objAcc;
          }
       }
       public static void UpdateToken() {
             system.debug('TokenExpired :' +TokenExpired + objSettings.saf_ZohoAccesstoken__c);
          if(TokenExpired ||  objSettings.saf_ZohoAccesstoken__c == null)
          {
              
                objSettings.saf_ZohoAccesstoken__c = SAF_ClsToZoho.ZohoAccessToken;
                update objSettings;
                 system.debug('objSettings:' +objSettings);
          }
        }
    }