global class Saf_ZohoApplications{
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
        public static Saf_ZohoApplications parse(String json){
            return (Saf_ZohoApplications) System.JSON.deserialize(json, Saf_ZohoApplications.class);
        }
        public static SAF_ClsToZoho.ZohoUsers parseUser(String json){
        return (SAF_ClsToZoho.ZohoUsers) System.JSON.deserialize(json, SAF_ClsToZoho.ZohoUsers.class);
       }
       public static SAF_ClsToZoho.cls_account parseAccount(String json){
        return (SAF_ClsToZoho.cls_account) System.JSON.deserialize(json, SAF_ClsToZoho.cls_account.class);
       }
        public static void testParse(String json2) {
        String json= ' {"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}'+
        '';
        String json1= '{"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:36:26+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:36:26+05:30","id":"10777000001221089","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}';
        Saf_ZohoApplications obj = parse(json2);
        system.debug('***objzoho : '+obj);
    }
    
      public static string getAccountInZoho(string strAccountId) {
         string strReturnmsg = 'Failure';
         //saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
         HttpRequest req = new HttpRequest();
         //Map<string,SAF_ClsToZoho.cls_users> mapuser = new Map<string,SAF_ClsToZoho.cls_users>();
         string strZohoAccountId;
         string url = objSettings.saf_getZohoAccount__c; 
         url = url.replace('sfdc',strAccountId);
         SAF_ClsToZoho.cls_account gp = new SAF_ClsToZoho.cls_account();
        
        
        
        // string token = Accesstoken == null ? 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken() : Accesstoken; 
            string token = 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken(TokenExpired); 
         req.setEndpoint(url);
         req.setMethod('GET');
         req.setHeader('Authorization',token);
         req.setHeader('Content-Type','application/json');
         System.debug('user req'+req);
        
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
             gp = parseAccount(jsonStr);
             System.debug('==='+gp);
             
             if(gp.data.size()>0)
             {
                for(SAF_ClsToZoho.cls_data objacc:gp.data)
                {
                  if(objacc.CLS_Customer_Id == strAccountId)
                  {
                      strZohoAccountId = objacc.id;
                      system.debug('strZohoAccountId :' + strZohoAccountId );
                      break;
                  }
                }
             }
         }else {
         
                if(res.getStatusCode() == 401)
                     {  
                        //SAF_ClsToZoho.ZohoAccessToken ='';
                        TokenExpired = true;
                         system.debug('SAF_ClsToZoho.RetryToken :' +SAF_ClsToZoho.RetryToken);
                         if(SAF_ClsToZoho.RetryToken <= 3) getAccountInZoho(strAccountId);
                         
                      }
               } 
         
        return strZohoAccountId;
    } 
     //@InvocableMethod
      @Future(callout=true)
      webservice static void CreateInZoho(List<string> objAppId,boolean iscreate){
         CreateAccountInZoho(objAppId[0],iscreate);
     
      }
    
      Webservice static string CreateAccountInZoho(string objAppId,boolean IsCreate) {
         string strReturnmsg = 'Failure';
         saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
        //getallUser info from Zoho
       
         HttpRequest req = new HttpRequest();
         string url = settings.zoho_CretaOppEndpoint__c; 
         genesis__Applications__c objApp = new genesis__Applications__c();
         Saf_ZohoApplications gp = new Saf_ZohoApplications();
         List<genesis__Applications__c> lstapp = [Select Id,Introducer1__c,genesis__description__c,genesis_ProposalName__c,Name,Zoho_Customer_Id__c,genesis__Account__r.Zoho_Customer_Id__c,genesis__Account__c,Support_Owner__r.Zoho_ID__c,genesis_ProposalOwner__r.Zoho_ID__c from genesis__Applications__c where Id =: objAppId];
         if(lstapp.size() >0) {
         objApp = lstapp[0];
             system.debug('@@@appid'+objApp.genesis_ProposalName__c);
         string token = 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken(TokenExpired); 
        // AccessToken = token;
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
        string strRequestBody = GetRequestbody(objApp,IsCreate);
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
             if(gp != null &&  gp.data != null && gp.data.size()>0 )
             {
               string strzohoId = gp.data[0].details.id;
                system.debug('***strzohoId : '+strzohoId );
                if(iscreate) {UpdateZohoId(objApp,strzohoId);}
                UpdateToken();
                strReturnmsg = strzohoId ; //gp.data[0].message + ' :' + gp.data[0].status;
             }
         }else {
                 if(res.getStatusCode() == 401)
                     {  
                        //SAF_ClsToZoho.ZohoAccessToken ='';
                        TokenExpired = true;
                         system.debug('SAF_ClsToZoho.RetryToken :' +SAF_ClsToZoho.RetryToken);
                         if(SAF_ClsToZoho.RetryToken <= 3) CreateAccountInZoho(objAppId,IsCreate);
                         
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
        public static Map<String,object> getQuery(string strApplicationId)
        {
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType ApplicationSchema = schemaMap.get('genesis__Applications__c');
                Map<String, Schema.SObjectField> fieldMap = ApplicationSchema.getDescribe().fields.getMap();
                system.debug('schemaMap'+schemaMap);
              
                //List<genesis__Applications__c> opp=[Select name,id,IsDeleted,MasterRecordId,Type from genesis__Applications__c limit 1];
                system.debug('fieldMap :'+fieldMap);
                 Map<String,object> valueMap=new Map<String,object>();
                string str = '';
                for(String fieldName: fieldMap.keySet())
                {
                 str = str + fieldName + ',';
                }

                 str = str.removeend(',');
                 string strquery = 'Select  '+ str + '  FROM genesis__Applications__c where Id = :strApplicationId limit 1';//',CreatedBy.Name
                 system.debug('strquery :' +strquery );
                List<genesis__Applications__c> lstApp = Database.query(strquery);
                system.debug('lstApp :' +lstApp);
               
                for(genesis__Applications__c o:lstApp)
                {
                    for(String fieldName: fieldMap.keySet())
                    {
                        system.debug('@@fieldname:'+fieldName);
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
        }

         public static String GetRequestbody(genesis__Applications__c objapp,boolean Iscreate)
        {
            string applicationid=objapp.id;
              string strzohoIntroducerId = objapp.introducer1__c != null ? getAccountInZoho(objapp.introducer1__c):null;
            system.debug('strzohoIntroducerId :' +strzohoIntroducerId);
            string strzohoIntroductionTypeId = objapp.Introduction_Type__c != null ? getAccountInZoho(objapp.genesis__Account__c):null;
            system.debug('strzohoIntroductionTypeId :' +strzohoIntroductionTypeId);
            List<Saf_ZohoApplicationFieldMapping__c> mcs = Saf_ZohoApplicationFieldMapping__c.getall().values();
            List<genesis__Applications__c> listApp = [Select Id,Introducer1__c,genesis__description__c,genesis_ProposalName__c,Name,Zoho_Customer_Id__c,genesis__Account__r.Zoho_Customer_Id__c,genesis__Account__c,Support_Owner__r.Zoho_ID__c,genesis_ProposalOwner__r.Zoho_ID__c from genesis__Applications__c where Id =: objapp.Id limit 1];
            string strzohoUserId;
           
                 string requestBodycreate =   '{'+
                '  "data": ['+
                '    {';
               // '      "Owner": {'+
               // '        "id": "10777000000710007"'+
               // '      },';
               
            if(!Iscreate) { requestBodycreate = requestBodycreate + '      "id": "'+objapp.Zoho_Customer_Id__c +'",';}//10777000001223134;
               
            Map<String,object> mapvalues = getQuery(objapp.Id);
            
            for(Saf_ZohoApplicationFieldMapping__c os: mcs)
            {
                 //system.debug();
                system.debug('map : '+ os.Salesforce_Field__c + ':'+ mapvalues.get(os.Salesforce_Field__c));
                
                if(os.Salesforce_Field__c !=null && os.Zoho_Fields__c != ''  )
                {
                   //adds in the support owner ID
                    if(os.Salesforce_Field__c == 'Support_Owner__c')
                   {
                       if(listApp.size()>0){
                        strzohoUserId =string.valueof(listApp[0].Support_Owner__r.Zoho_ID__c);
                     system.debug('strzohoUserId :' +strzohoUserId );
                       }
                       else
                           {
                           //uses the default id for the system admin to catch issues
                               strzohoUserId = '15784000005987003';
                               System.debug('in else');
                           }
                       //adds the string the the request body
                     requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": {"id":"'+ strzohoUserId +'"},';
                   }
                   //pulls out the section for creating the PROPOSAL OWNER
                    else if(os.Salesforce_Field__c == 'genesis_ProposalOwner__c')
                   {
                     if(listApp.size()>0){
                        strzohoUserId =string.valueof(listApp[0].genesis_ProposalOwner__r.Zoho_ID__c);
                     system.debug('strzohoUserId :' +strzohoUserId );
                       }
                       else
                           {
                               //places the system admin in the proposal owner if thir is no owner in the field
                            strzohoUserId = '15784000005987003';
                               System.debug('in else');
                            
                           }
                     requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": {"id":"'+ strzohoUserId +'"},';
                   }
                  //updates how the date string is presented for Zhoho
                    else if(os.Salesforce_Field__c == 'genesis__expected_start_date__c')
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
                    else if(os.Salesforce_Field__c == 'genesis__cl_product__c')
                   { 
                    string res;
                    
                    if(mapvalues.get(os.Salesforce_Field__c) != null) res = String.valueof(mapvalues.get(os.Salesforce_Field__c));//.replace(';','";"')).split
                    System.debug('Before printing the salesforce result field date is::::::'+res);
                    clcommon__CL_Product__c pr=[select id,clcommon__Product_Name__c from clcommon__CL_Product__c where id=:res];
                       system.debug('@@@pr'+pr);
                    string productname= pr.clcommon__Product_Name__c;
                       system.debug('@@@productname:'+productname);
                    //lst = mapvalues.get(os.Salesforce_Field__c).split(';');
                   requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ productname +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('Before printing the requestBodycreaterequestBodycreate'+requestBodycreate);
                   }
                    else if(os.Salesforce_Field__c == 'introducer1__c' )
                   {                    
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ strzohoIntroducerId +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('Before printing introducer1'+requestBodycreate);
                   }
                        //code for introduction field type
                    else if(os.Salesforce_Field__c == 'Introduction_Type__c' )
                    {
                        string zohoIntroductiontype = objapp.Introduction_Type__c;
                        requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ zohoIntroductiontype +'",';
                        requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                        System.debug('Before printing introduction type '+requestBodycreate);
                    }
                    else if(os.Salesforce_Field__c == 'Application_link__c' )
                   { 
                       string link=System.Label.Application_url;
                       string url=link+applicationid;
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ url +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('Before printing Application_link__c'+requestBodycreate);
                   }
                    else if(os.Salesforce_Field__c == 'genesis__Account__c' )
                   {
                    
                     string strZohoCustId = objapp.genesis__Account__r.Zoho_Customer_Id__c;    
                      System.debug('strZohoCustId :'+strZohoCustId );                
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ strZohoCustId +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('Before printing genesis__Account__c'+requestBodycreate);
                   }
                   //adds all the other fields and passes the values through
                    else
                   {
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ mapvalues.get(os.Salesforce_Field__c) +'",';
                   } requestBodycreate = requestBodycreate.replace('"true"','true').replace('"false"','false').replace('"null"','null');
                    system.debug(requestBodycreate);
                }
            }
            
             requestBodycreate =  requestBodycreate + '    }'+
                '  ]'+
                '}';
            requestBodycreate = requestBodycreate.replace(',    }  ]}','    }  ]}');
            return requestBodycreate;
        }
         public static void UpdateZohoId(genesis__Applications__c objApp,string ZohoId) {
         
         //List<genesis__Applications__c> lstapp = [Select Id,Name,Zoho_Customer_Id__c from genesis__Applications__c where Id =: objApp.Id];
         if(objApp!= null&&ZohoId!=null)
          {
             // for(genesis__Applications__c objapp: lstacc)
            //  {
              
                   objApp.Zoho_Customer_Id__c = ZohoId;
              system.debug('@@@Zohoid'+ZohoId);
                          
            //  }
              update objApp;
              System.debug('working..');
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