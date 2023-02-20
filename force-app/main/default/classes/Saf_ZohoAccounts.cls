global class Saf_ZohoAccounts{
         //public class cls_dataAcc {
           public cls_data[] data;
           
           private static saf_zoho__c objSettings = saf_zoho__c.getOrgDefaults();
           public static boolean TokenExpired = false;
        // }
                
        public class cls_data {
            public String code; //SUCCESS
            public cls_details details;
            public String message;  //record added
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
        public static Saf_ZohoAccounts parse(String json){
            return (Saf_ZohoAccounts) System.JSON.deserialize(json, Saf_ZohoAccounts.class);
        }
        public static SAF_ClsToZoho.ZohoUsers parseUser(String json){
        return (SAF_ClsToZoho.ZohoUsers) System.JSON.deserialize(json, SAF_ClsToZoho.ZohoUsers.class);
       }
        public static void testParse(String json2) {
        String json= ' {"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}'+
        '';
        String json1= '{"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:36:26+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:36:26+05:30","id":"10777000001221089","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}';
        Saf_ZohoAccounts obj = parse(json2);
        system.debug('***objzoho : '+obj);
    }
    public static Map<string,SAF_ClsToZoho.cls_users> getUserInzoho() {
         string strReturnmsg = 'Failure';
         saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
         Map<string,SAF_ClsToZoho.cls_users> mapuser = new Map<string,SAF_ClsToZoho.cls_users>();
         string url = settings.zoho_GetUsersEndpoint__c; 
        
         SAF_ClsToZoho.ZohoUsers gp = new SAF_ClsToZoho.ZohoUsers();
        
         string token = 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken(TokenExpired); 
         system.debug('***token  : '+token );
        
         HttpRequest req = new HttpRequest();
         req.setEndpoint(url);
         req.setMethod('GET');
         req.setHeader('Authorization',token);
         req.setHeader('Content-Type','application/json');
         System.debug('user req'+req);
  System.debug('user content'+req.getHeader('Authorization'));       
        
         // Create a new http object to send the request object
         // A response object is generated as a result of the request  
      
         Http http = new Http();
         HTTPResponse res = http.send(req);
         System.debug(res.getBody());
        
          
         String jsonStr = res.getBody() + '';
         system.debug('***Jsonstring: '+jsonStr);
         system.debug('***res.getStatusCode(): '+res.getStatusCode()); 
         if(res.getStatusCode() == 201 || res.getStatusCode() == 200)
         {
             System.debug('response'+res);
             gp = parseUser(jsonStr);
             System.debug('==='+gp);
             
             if(gp != null && gp.users != null && gp.users.size()>0)
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
    
                        if(SAF_ClsToZoho.RetryToken <= 3) getUserInzoho();
    
                  
                     }
                 //Saf_ExperainTest objExp = new Saf_ExperainTest();
                 //gp = parse(objExp.strjsonNLcompany);
                  //gp.Responemessage = res.getStatus();
               //  if(res.getStatusCode() == 202 && gp.data.size()>0) { strReturnmsg = gp.data[0].message + ' :' + gp.data[0].status;}
               } 
         
        return mapuser;
    } 
     //@InvocableMethod
      @Future(callout=true)
      webservice static void CreateInZoho(List<string> objAccId,boolean iscreate){
          System.debug('isCreate:'+iscreate);
         CreateAccountInZoho(objAccId[0],iscreate);   
      }
      Webservice static string CreateAccountInZoho(string objAccId,boolean IsCreate) {
         string strReturnmsg = 'Failure';
         saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
        //getallUser info from Zoho
       
         HttpRequest req = new HttpRequest();
         string url = settings.zoho_CretaAccEndpoint__c; 
         Account objAcc = new Account();
         Saf_ZohoAccounts gp = new Saf_ZohoAccounts();
         List<account> lstacc = [Select Id,Name,Zoho_Customer_Id__c from Account where Id =: objAccId];
         if(lstacc.size() >0) {
         objAcc = lstacc[0];
         string token = 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken(TokenExpired);
         system.debug('***token  : '+token ); 
         string strpost = (IsCreate) ? 'POST' : 'PUT';
         req.setEndpoint(url);
         req.setMethod(strpost);
         req.setHeader('Authorization',token);
         req.setHeader('Accept','application/json');
     /*    string requestBodycreate =   '{'+
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
        '}';*/
        string strRequestBody = GetRequestbody(objAcc,IsCreate);
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
             if(gp != null && gp.data != null && gp.data.size()>0)
             {
               string strzohoId = gp.data[0].details.id;
                system.debug('***strzohoId : '+strzohoId );
                if(iscreate) {UpdateZohoId(objAcc,strzohoId);}
                UpdateToken();
                strReturnmsg = strzohoId ; //gp.data[0].message + ' :' + gp.data[0].status;
             }
         }else {
         
                 if(res.getStatusCode() == 401)
                 {
                     //SAF_ClsToZoho.ZohoAccessToken ='';
                     TokenExpired = true;
                     system.debug('SAF_ClsToZoho.RetryToken :' +SAF_ClsToZoho.RetryToken);
                     if(SAF_ClsToZoho.RetryToken <= 3) CreateAccountInZoho(objAccId,IsCreate);
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
        public static Map<String,object> getQuery(string strAccountId)
        {
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType AccountSchema = schemaMap.get('Account');
                Map<String, Schema.SObjectField> fieldMap = AccountSchema.getDescribe().fields.getMap();
              
                //List<Account> opp=[Select name,id,IsDeleted,MasterRecordId,Type from Account limit 1];
                system.debug('fieldMap :'+fieldMap);
                 Map<String,object> valueMap=new Map<String,object>();
                string str = '';
                for(String fieldName: fieldMap.keySet())
                {
                 str = str + fieldName + ',';
                }

                 str = str.removeend(',');
                 string strquery = 'Select '+ str + ' FROM Account where Id = :strAccountId limit 1';//',CreatedBy.Name
                 system.debug('strquery :' +strquery );
                List<Account> lstAcc = Database.query(strquery);
                system.debug('lstAcc :' +lstAcc);
               
                for(Account o:lstAcc)
                {
                    for(String fieldName: fieldMap.keySet())
                    {
                     if((o.get(fieldName))!=null)
                                        {
                                            valueMap.put(String.valueof(fieldName),o.get(fieldName));//,String.valueof(
                                        }
                    //break;
                      system.debug('valueMap1 :' +String.valueof(fieldName));
                      system.debug('value1 :' +String.valueof(o.get(fieldName)));
                    }
         
                
             }

                system.debug('valueMap :' +valueMap);
                return valueMap;
        }
         
         public static String GetRequestbody(Account objacc,boolean Iscreate)
        {
              Map<string,SAF_ClsToZoho.cls_users> mapuser = getUserInzoho();
               system.debug('mapuser :' +mapuser.keyset());
            List<Saf_ZohoFieldMapping__c> mcs = Saf_ZohoFieldMapping__c.getall().values();
           
                 string requestBodycreate =   '{'+
                '  "data": ['+
                '    {';
               // '      "Owner": {'+
               // '        "id": "10777000000710007"'+
               // '      },';
               
            if(!Iscreate) 
            { 
                requestBodycreate = requestBodycreate + '      "id": "'+objacc.Zoho_Customer_Id__c +'",';
            }//10777000001223134;
               
            Map<String,object> mapvalues = getQuery(objacc.Id);
            
            for(Saf_ZohoFieldMapping__c os: mcs)
               {
                         
                if(os.Salesforce_Field__c !=null && os.Zoho_Fields__c != ''  )
                {
                   if(os.Type__c == 'User')
                   {
                       
                       system.debug('Salesforce_Field__c:'+string.valueof(mapvalues.get(os.Salesforce_Field__c)));
                      string userid = string.valueof(mapvalues.get(os.Salesforce_Field__c));
                       system.debug('userid'+userid);
                     List<User> lstuser = [Select id,name,email,Zoho_ID__c from User where id =: userid limit 1];
                     system.debug('lstuser :' +lstuser);
                       string strzohoUserId= '12129000000285024';
                           // '15784000000550203';
                       system.debug('lstuser!=null:'+lstuser!=null);
                       system.debug('lastUser Size:'+lstuser.size());
                       if(lstuser!=null && lstuser.size()>0){
                        strzohoUserId = string.valueof(lstuser[0].Zoho_ID__c);
                           system.debug('strzohoUserId:'+strzohoUserId);
                       }
                        
                     system.debug('strzohoUserId :' +strzohoUserId );
                      requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": {"id":"'+ strzohoUserId +'"},';
                     
                   }
                   else if(os.Type__c == 'Boolean')
                   {  
                    string res = 'false';
                    if(mapvalues.get(os.Salesforce_Field__c) != null)
                    {
                        string result =string.valueof(mapvalues.get(os.Salesforce_Field__c));
                        res = (string.valueof(mapvalues.get(os.Salesforce_Field__c)));
                    }
                       
                    
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": '+ res +',';
                    requestBodycreate = requestBodycreate.replace('(','' ).replace(')','' );
                   
                   }
                   else
                   {
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ mapvalues.get(os.Salesforce_Field__c) +'",';
                   } requestBodycreate = requestBodycreate.replace('"true"','true').replace('"false"','false').replace('"null"','null');
                    
                }
            }
            
             requestBodycreate =  requestBodycreate + '    }'+
                '  ]'+
                '}';
            requestBodycreate = requestBodycreate.replace(',    }  ]}','    }  ]}');
            return requestBodycreate;
        }
         public static void UpdateZohoId(Account objAcc,string ZohoId) {
         
         //List<Account> lstacc = [Select Id,Name,Zoho_Customer_Id__c from Account where Id =: objAcc.Id];
         if(objAcc!= null)
          {
             // for(Account objac: lstacc)
            //  {
                  objAcc.Zoho_Customer_Id__c = ZohoId;
                    system.debug('ZohoId:'+ZohoId);
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
                 TokenExpired = false;
          }
        }
    }