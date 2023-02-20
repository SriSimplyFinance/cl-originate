global class Saf_ZohoLSContract{
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
        public static Saf_ZohoLSContract parse(String json){
            return (Saf_ZohoLSContract) System.JSON.deserialize(json, Saf_ZohoLSContract.class);
        }
        public static SAF_ClsToZoho.ZohoUsers parseUser(String json){
        return (SAF_ClsToZoho.ZohoUsers) System.JSON.deserialize(json, SAF_ClsToZoho.ZohoUsers.class);
       }
        public static void testParse(String json2) {
        String json= ' {"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}'+
        '';
        String json1= '{"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:36:26+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:36:26+05:30","id":"10777000001221089","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}';
        Saf_ZohoLSContract obj = parse(json2);
        system.debug('***objzoho : '+obj);
    }
    public static Map<string,SAF_ClsToZoho.cls_users> getUserInzoho() {
         string strReturnmsg = 'Failure';
         //saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
         HttpRequest req = new HttpRequest();
         Map<string,SAF_ClsToZoho.cls_users> mapuser = new Map<string,SAF_ClsToZoho.cls_users>();
         string url = objSettings.zoho_GetUsersEndpoint__c; 
        
         SAF_ClsToZoho.ZohoUsers gp = new SAF_ClsToZoho.ZohoUsers();
        
        
        
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
         if(res.getStatusCode() == 201 || res.getStatusCode() == 200)//CreateInZoho
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
      @future(Callout=true)
      webservice static void CreateInZoho(List<string> objLscId,boolean iscreate){
         CreateAccountInZoho(objLscId[0],iscreate);  
      }
      Webservice static string CreateAccountInZoho(string objLscId,boolean iscreate) {
         string strReturnmsg = 'Failure';
        // saf_zoho__c settings = saf_zoho__c.getOrgDefaults();
        //getallUser info from Zoho
       
         HttpRequest req = new HttpRequest();
         string url = objSettings.zoho_CretaOppEndpoint__c; 
         cllease__Lease_Account__c objLsc = new cllease__Lease_Account__c();
         Saf_ZohoLSContract gp = new Saf_ZohoLSContract();
         List<cllease__Lease_Account__c> lstlsc = [Select Id,Name,cllease__Account__r.Name,cllease__Account__r.Zoho_Customer_Id__c,xirr5__c,Application__r.Zoho_Customer_Id__c from cllease__Lease_Account__c where Id =: objLscId];
         system.debug('***lstlsc: '+lstlsc);
          if(lstlsc.size() >0) {
         objLsc = lstlsc[0];
         string token = 'Bearer ' + SAF_ClsToZoho.fetchZohoAccessToken(TokenExpired); 
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
        '      "Shipping_Street": "Shipping_Street"'+  //Saf_ZohoLSContract
        '    }'+
        '  ]'+
        '}';
        string strRequestBody = GetRequestbody(objLsc,IsCreate);
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
             System.debug('gp:'+gp);
             System.debug('gp.data:'+gp.data.size());
             if(gp.data.size()>0)
             {
               string strzohoId = gp.data[0].details.id;
                system.debug('***strzohoId : '+strzohoId );
                //if(IsCreate) {UpdateZohoId(objLsc,strzohoId);}
                UpdateToken();
                strReturnmsg = strzohoId ; //gp.data[0].message + ' :' + gp.data[0].status;
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
        }
        // gp.ResponeCode = res.getStatusCode();
         return strReturnmsg;
        }
        public static Map<String,object> getQuery(string strLscontactId)
        {
            
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType LscontractSchema = schemaMap.get('cllease__Lease_Account__c');
                Map<String, Schema.SObjectField> fieldMap = LscontractSchema.getDescribe().fields.getMap();
              
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
                 str = str.removeend(',');
                 string strquery = 'Select '+ str +'  FROM cllease__Lease_Account__c where Id = :strLscontactId limit 1';//',CreatedBy.Name
                 system.debug('strquery :' +strquery );
                List<cllease__Lease_Account__c> lstlsc = Database.query(strquery);
                system.debug('lstlsc :' +lstlsc);
               
                for(cllease__Lease_Account__c o:lstlsc)
                {
                    for(String fieldName: fieldMap.keySet())
                    {
                     if((o.get(fieldName))!=null)
                         {
                            valueMap.put(String.valueof(fieldName),o.get(fieldName));//,String.valueof(
                        //    valueMap.put('cllease__Account__r.genesis__description__c','<p>testing zoho opp</p>');
                           // valueMap.put('(xirr5__c.setscale(2))',o.get('(xirr5__c.setscale(2))'));
                          }
                    //break;
                      system.debug('valueMap1 :' +String.valueof(fieldName));
                      system.debug('value1 :' +String.valueof(o.get(fieldName)));
                    }                         
             }

                system.debug('valueMap :' +valueMap);
                return valueMap;
        }
         
         public static String GetRequestbody(cllease__Lease_Account__c objLsc,boolean Iscreate)
        {
            //string strzohocustomerId = objLsc.cllease__Account__c != null ? Saf_ZohoApplications.getAccountInZoho(objLsc.cllease__Account__c):null;
           // System.debug('strzohocustomerId'+strzohocustomerId);
            string agreementid = objLsc.id;
            system.debug('@@agreementid'+agreementid);
            Decimal yield=null;
            /*if(string.valueof(objLsc.XIRR5__c)!= null)
            {
            Decimal yieldvalue=objLsc.XIRR5__c;
            yield= yieldvalue.setscale(2,RoundingMode.CEILING);
            system.debug('yield avlueeee'+yield);
           
            }
            else {yield=null;}*/
              Map<string,SAF_ClsToZoho.cls_users> mapuser = getUserInzoho();
               system.debug('mapuser :' +mapuser.keyset());
            List<Saf_ZohoLSFieldMapping__c> mcs = Saf_ZohoLSFieldMapping__c.getall().values();
           
                 string requestBodycreate =   '{'+
                '  "data": ['+
                '    {';
               // '      "Owner": {'+
               // '        "id": "10777000000710007"'+
               // '      },';
               
            
            
            
            if(!Iscreate) { requestBodycreate = requestBodycreate + '      "id": "'+objLsc.Application__r.Zoho_Customer_Id__c +'","Yield":"'+yield+'",';}//10777000001223134; 
            Map<String,object> mapvalues = getQuery(objLsc.Id);
            system.debug('mapvalues'+mapvalues);
            for(Saf_ZohoLSFieldMapping__c  os: mcs)
            {
                 //system.debug();
                system.debug('map : '+ os.Salesforce_Field__c + ':'+ mapvalues.get(os.Salesforce_Field__c));
              //  yield.yieldvalue= yield.SetScale(2); 
                if(os.Salesforce_Field__c !=null && os.Zoho_Fields__c != '')
                {
                /*   if(os.Salesforce_Field__c == 'cllease__Account__c ')// || os.Salesforce_Field__c == 'createdbyid' || os.Salesforce_Field__c == 'lastmodifiedbyid')
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
                   }*/
                    if(os.Salesforce_Field__c == 'Agreement_link__c' )
                   { 
                       string link=System.Label.Agreement_Link;
                       system.debug('@@@link::'+link);
                       string url=link+agreementid;
                       system.debug('@@url:'+url);
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ url +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('@@@Before printing Agreement_link__c '+url);
                   }  
                   else if(os.Salesforce_Field__c == 'cllease__Lease_Status__c') 
                  {
                    cllease__Lease_Account__c cls=[select cllease__Lease_Status__c from cllease__Lease_Account__c where id=:agreementid];
                    string status= cls.cllease__Lease_Status__c;
                    system.debug('@@@@status'+status);
                   // string status='Partial Application';
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ status +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                     }
                  
                     else if(os.Salesforce_Field__c == 'cllease__contract_date__c' || os.Salesforce_Field__c == 'cllease__maturity_date__c'|| os.Salesforce_Field__c =='cllease__next_due_date__c' || os.Salesforce_Field__c =='vat_deferred_date_due__c')
                   {
                    string res;
                    if(mapvalues.get(os.Salesforce_Field__c) != null) 
                    {res = String.valueof(mapvalues.get(os.Salesforce_Field__c));}
                      //else{res=String.valueOf(date.today());}
                      //.replace(';','";"')).split
                    System.debug('Before printing the salesforce result field date is::::::'+res);
                     if(res != null)
                       {
                            Date  newDate = date.valueof(res) ;
                           // Date myDate = date.newinstance(newDate.year(), newDate.month(), newDate.day());
                            String myDate=String.valueof(date.newinstance(newDate.year(), newDate.month(), newDate.day())); 
                             System.debug('Before printing the datatatatat'+myDate);
                             
                            //lst = mapvalues.get(os.Salesforce_Field__c).split(';');
                           requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ myDate +'",';
                            requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                            System.debug('Before printing the requestBodycreaterequestBodycreate'+requestBodycreate);
                    }
                   }
                 /*   else if(os.Salesforce_Field__c == 'cllease__Account__c' )
                   {                    
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ strzohocustomerId +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('Before printing introducer1'+requestBodycreate);
                   } */
                    else if(os.Salesforce_Field__c == 'XIRR5__c' )
                   {
                    string yieldvalue= string.valueof(mapvalues.get(os.Salesforce_Field__c));
                    if(yieldvalue != NULL)
                    {
                    yield =  decimal.valueof(yieldvalue);
                    decimal yield2 = yield.setscale(2,RoundingMode.CEILING);
                    system.debug('yield2 :'+yield2 );                    
                    requestBodycreate = requestBodycreate  + '      "'+os.Zoho_Fields__c +'": "'+ string.valueof(yield2) +'",';
                    requestBodycreate = requestBodycreate.replace('"(','"' ).replace(')"','"' );
                    System.debug('Before printing XIRR5__c'+requestBodycreate);
                    }
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
        /* public static void UpdateZohoId(cllease__Lease_Account__c objAcc,string ZohoId) {
         
         //List<Account> lstacc = [Select Id,Name,Zoho_Customer_Id__c from Account where Id =: objAcc.Id];
         if(objAcc!= null)
          {
             // for(Account objac: lstacc)
            //  {
                  objAcc.Application__r.Zoho_Customer_Id__c = ZohoId;
            //  }
              update objAcc;
          } 
       }*/
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