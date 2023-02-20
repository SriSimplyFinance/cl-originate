/**
        @ name                        : HPIParserclass
        @ author                      : Happiest Minds
        @ description                 : Parsing hpi xml file
        @ created date                : 08/17/2018  
        @ Modified by / Date          : 
*/

global class HPI_Parserclass
{
    public static string CustomerCode = System.Label.HPI_Customercode; // 'R080' ;
    public  static string Passcode = System.Label.HPI_Passcode;  //'999fz01768'; 
     private String returnedContinuationId ;
     public static Map<String,webservicesHpiCoUkFinanceReg.CodeDescriptionType> map_codeDesc;
    // public String response {get;set;}

            public static string hpi_WebFinanceAdd(cllease__Contract_Equipment__c objContractEquipment)
              {    
                    system.debug('******************getting HPI Finance Add************************************************* ');
                   
                     string ContractId = objContractEquipment.cllease__Contract__r.name.replace('-','') + '5'; //'TEST';
                    system.debug('ContractId  :' + ContractId );
                    string VRM = objContractEquipment.Vehicle_Registration_Number__c; //'TEST';
                    string VIN = objContractEquipment.cllease__VIN__c; //'TEST';
                    string EquipmentDesc = objContractEquipment.cllease__Equipment_Description__c;
                    datetime dt = objContractEquipment.cllease__Contract__r.cllease__Contract_Date__c;
                    Date AgreementDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    string Term = string.valueof(objContractEquipment.cllease__Contract__r.cllease__Term__c);
                    string ProductName = objContractEquipment.cllease__Contract__r.cllease__Lease_Product_Name__r.Name;
                    Boolean Is_NewUsed = (objContractEquipment.NewUsed__c == null) ? false :Boolean.valueof(objContractEquipment.NewUsed__c);
                   string CategoryName = objContractEquipment.cllease__Make__c;
                   string EquipmentType = objContractEquipment.cllease__Equipment_Type__c;
                     
                    string response= '';
                    webservicesHpiCoUkFinanceReg.FinanceRegistrationV1 wb_fr = new webservicesHpiCoUkFinanceReg.FinanceRegistrationV1();
                   
                    webservicesHpiCoUkFinanceReg.CustomerType ct =  new webservicesHpiCoUkFinanceReg.CustomerType();
                    ct.CustomerCode = CustomerCode;
                    ct.Initials = 'SAF';
                    ct.Password = Passcode;
                    
                    system.debug('ProductName : ' + ProductName + 'CategoryName :' + CategoryName +'EquipmentType :' +EquipmentType);
                    Get_Hpi_Agreementype(new list<string> {ProductName,EquipmentType,CategoryName});
                    
                    webservicesHpiCoUkFinanceReg.AgreementTypeCode wb_code = new webservicesHpiCoUkFinanceReg.AgreementTypeCode();
                    if(map_codeDesc.containskey(ProductName))
                   {
                     wb_code.Code =  map_codeDesc.get(ProductName).Code; //'1';
                     system.debug('========= wb_code.Code======='+wb_code.Code);
                   }
                  
                     
                    webservicesHpiCoUkFinanceReg.AgreementIdentificationType wb_Iden_type = new webservicesHpiCoUkFinanceReg.AgreementIdentificationType();
                    //wb_Iden_type.Vin = VIN;
                    wb_Iden_type.AgreementType = wb_code;
                    wb_Iden_type.Vrm = VRM;
                    wb_Iden_type.AgreementReference = ContractId;
                   // wb_Iden_type.OriginalCustomerCode = ;*/
                    
                    webservicesHpiCoUkFinanceReg.AgreementTermsType wb_term_type = new  webservicesHpiCoUkFinanceReg.AgreementTermsType();
                    wb_term_type.AgreementTerm = Term;
                    wb_term_type.AgreementDate = AgreementDate; 
                    
                    webservicesHpiCoUkFinanceReg.HpiCategoryType wb_cat_type = new webservicesHpiCoUkFinanceReg.HpiCategoryType();
                   if(map_codeDesc.containskey(EquipmentType))
                   {
                       wb_cat_type.Code = map_codeDesc.get(EquipmentType).Code; 
                       system.debug('========= wb_cat_type.Code======='+wb_cat_type.Code);
                   }                
                    
                      
                    webservicesHpiCoUkFinanceReg.HpiMakeType wb_make_type = new webservicesHpiCoUkFinanceReg.HpiMakeType();
                   if(map_codeDesc.containskey(CategoryName))
                   {
                     wb_make_type.Code =  map_codeDesc.get(CategoryName).Code; //'BM';
                       system.debug('========= wb_make_type.Code======='+wb_make_type.Code);
                   }                 
                   
                     
                    webservicesHpiCoUkFinanceReg.AssetDetailsType wb_asset_type = new webservicesHpiCoUkFinanceReg.AssetDetailsType();
                    wb_asset_type.Description = EquipmentDesc;
                    //wb_asset_type.Mileage = null;
                    wb_asset_type.HpiCategory = wb_cat_type;
                    wb_asset_type.HpiMake= wb_make_type;
                    wb_asset_type.IsNew =Is_NewUsed;
                    
                    webservicesHpiCoUkFinanceReg.InterestAddType wb_interest_add = new webservicesHpiCoUkFinanceReg.InterestAddType();
                    wb_interest_add.Identification = wb_Iden_type;
                    wb_interest_add.AgreementTerms = wb_term_type;
                    wb_interest_add.AssetDetails = wb_asset_type;      
                                    
                    webservicesHpiCoUkFinanceReg.AuthenticationType au = new webservicesHpiCoUkFinanceReg.AuthenticationType();
                    au.CustomerDetails = ct;
                    
                    webservicesHpiCoUkFinanceReg.HpiSoapFaultType wb_error = new webservicesHpiCoUkFinanceReg.HpiSoapFaultType();
                    List<webservicesHpiCoUkFinanceReg.ErrorType> wb_error_type = new List<webservicesHpiCoUkFinanceReg.ErrorType>();
                    wb_error.Error = wb_error_type;
                   
                   webservicesHpiCoUkFinanceReg.UpdateResponseType res_x =wb_fr.financeAdd(au,wb_interest_add);
                    
                    if(response != null)
                    {
                    if(response.contains('TRUE'))
                    {
                        objContractEquipment.IS_Registered__c = true ;
                        update objContractEquipment;
                        system.debug('========= response objContractEquipment========'+objContractEquipment);
                    }               
                   }
                    /*System.Continuation con = new System.Continuation(60);
                       AsyncWebservicesHpiCoUkFinanceReg.AsyncFinanceRegistrationV1  Async_fr = new AsyncWebservicesHpiCoUkFinanceReg.AsyncFinanceRegistrationV1();
                      AsyncWebservicesHpiCoUkFinanceReg.UpdateResponseTypeFuture Async_res = new AsyncWebservicesHpiCoUkFinanceReg.UpdateResponseTypeFuture();
                     Async_res = Async_fr.beginFinanceAdd(con,au,wb_interest_add);*/
                  
                  
                   return 'response : ' + response ;
              }  
                    
    public static String hpi_FinanceAdd(cllease__Contract_Equipment__c objContractEquipment)
    {
                    string msg = '';
                    //string SecurityCode = System.Label.Equifax_SecurityCode ; //'99';
                    string ContractId = objContractEquipment.cllease__Contract__r.name.replace('-',''); //'TEST';
                    system.debug('ContractId  :' + ContractId );
                    string VRM = objContractEquipment.Vehicle_Registration_Number__c; //'TEST';
                    string serialno = objContractEquipment.cllease__Equipment_Serial_Number__c; 
                    string VIN = (objContractEquipment.Vehicle_Chassis_Number__c == null) ? '' :objContractEquipment.Vehicle_Chassis_Number__c; //'TEST';
                    //schema accepts description upto 25 characters only
                    string EquipmentDesc = (string.isblank(objContractEquipment.cllease__Equipment_Description__c)) ? '' : objContractEquipment.cllease__Equipment_Description__c.left(25);
                    system.debug('EquipmentDesc : ' + EquipmentDesc);
                    datetime dt = objContractEquipment.cllease__Contract__r.cllease__Contract_Date__c;
                    string AgreementDate = dt.format('yyyy-MM-dd');
                    string Term = string.valueof(objContractEquipment.cllease__Contract__r.cllease__Term__c).replace('.0','');
                    string ProductName = objContractEquipment.cllease__Contract__r.cllease__Lease_Product_Name__r.Name;
                    Boolean Is_NewUsed = (objContractEquipment.NewUsed__c == 'New') ? true :false;
                   string CategoryName = (string.isblank(objContractEquipment.cllease__Make__c) ? '' : objContractEquipment.cllease__Make__c.toUppercase());
                   string EquipmentType = objContractEquipment.cllease__Equipment_Type__c;
                    
                   
                    
                    // dynamic string 
                    system.debug('ProductName : ' + ProductName + 'CategoryName :' + CategoryName +'EquipmentType :' +EquipmentType + 'Term :' +Term);
                    Get_Hpi_Agreementype(new list<string> {ProductName,EquipmentType,CategoryName});
                    
                    string strproductCode = (map_codeDesc.containskey(ProductName)) ? map_codeDesc.get(ProductName).Code : '';
                    string strEquipmentTypeCode = (map_codeDesc.containskey(EquipmentType)) ? map_codeDesc.get(EquipmentType).Code : '';
                    string strCategoryCode = (map_codeDesc.containskey(CategoryName)) ? map_codeDesc.get(CategoryName).Code : '';
                    string strVehicleNo = string.isblank(VRM) ? (string.isblank(serialno) ? '' : serialno): VRM;
                     system.debug('before strCategoryCode :' +strCategoryCode );
                    
                    List<HPI_Agreement_Types__c> lst_Agreement_Types = [Select Id,Name,Code__c,Desciption__c,Category_SubCode__c,Category__c from HPI_Agreement_Types__c 
                    where Category_SubCode__c =: strEquipmentTypeCode and Code__c =: strCategoryCode ];
                    if(lst_Agreement_Types.size() == 0 && !string.isblank(CategoryName))
                    {
                        strCategoryCode = 'OT';
                        //msg = '\n' + 'HPI could not find make code for : ' + CategoryName  + '\n'+ ',hence equipment is tried registering with make code as OTHERS.';
                        msg = '\n' + 'Could not register with make as "' + CategoryName +'", tried registering with "OTHERS".';  
                    }                               
                    
                    system.debug('Is_NewUsed :' + Is_NewUsed +' VIN :' +VIN +' strVehicleNo :' + strVehicleNo + 'strproductCode : ' + strproductCode + 'strEquipmentTypeCode :' + strEquipmentTypeCode +'strCategoryCode :' +strCategoryCode );
                    string InputValueXML = '';
                    string response= '';
                    if((strVehicleNo != null || VIN != null) && strproductCode != null)
                    {
                    InputValueXML = InputValueXML +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fin="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
                    InputValueXML = InputValueXML +'<soapenv:Header/>';
                    InputValueXML = InputValueXML +'<soapenv:Body>';
                    InputValueXML = InputValueXML +'<fin:FinanceAdd>';
                    InputValueXML = InputValueXML +'<fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'<fin:CustomerCode>' +CustomerCode + '</fin:CustomerCode>';
                    InputValueXML = InputValueXML +'<fin:Initials>ABC</fin:Initials>';
                    InputValueXML = InputValueXML +'<fin:Password>' +Passcode + '</fin:Password>';
                    InputValueXML = InputValueXML +'</fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'</fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:Interest>';
                    InputValueXML = InputValueXML +'<fin:Identification>';
                    InputValueXML = InputValueXML +'<fin:AgreementType>';
                    InputValueXML = InputValueXML +'<fin:Code>' +strproductCode + '</fin:Code>';
                    InputValueXML = InputValueXML +'</fin:AgreementType>';                   
                    InputValueXML = InputValueXML +'<fin:Vin>'+VIN+'</fin:Vin>';
                    InputValueXML = InputValueXML +'<fin:Vrm>'+strVehicleNo+'</fin:Vrm>';
                    InputValueXML = InputValueXML +'<fin:AgreementReference>'+ ContractId +'</fin:AgreementReference>';                   
                    //InputValueXML = InputValueXML +'<fin:Vin>ABC1234DEF567890G</fin:Vin>';
                    //InputValueXML = InputValueXML +'<fin:Vrm>XX11YYY</fin:Vrm>';
                    //InputValueXML = InputValueXML +'<fin:AgreementReference>FIN123456</fin:AgreementReference>';
                    InputValueXML = InputValueXML +'</fin:Identification>';
                    InputValueXML = InputValueXML +'<fin:AgreementTerms>';
                    //InputValueXML = InputValueXML +'<fin:AgreementTerm>24</fin:AgreementTerm>';
                    //InputValueXML = InputValueXML +'<fin:AgreementDate>2011-07-01</fin:AgreementDate>';
                    InputValueXML = InputValueXML +'<fin:AgreementTerm>'+Term+'</fin:AgreementTerm>';
                    InputValueXML = InputValueXML +'<fin:AgreementDate>'+AgreementDate+'</fin:AgreementDate>';          
                    InputValueXML = InputValueXML +'</fin:AgreementTerms>';
                    InputValueXML = InputValueXML +'<fin:AssetDetails>';
                   //InputValueXML = InputValueXML +'<fin:Description>325D SALOON</fin:Description>';
                    InputValueXML = InputValueXML +'<fin:Description>'+EquipmentDesc+'</fin:Description>';
                    InputValueXML = InputValueXML +'<fin:HpiCategory>';
                    InputValueXML = InputValueXML +'<fin:Code>' +strEquipmentTypeCode+'</fin:Code>';
                    InputValueXML = InputValueXML +'</fin:HpiCategory>';
                    InputValueXML = InputValueXML +'<fin:HpiMake>';                   
                    InputValueXML = InputValueXML +'<fin:Code>'+ strCategoryCode +'</fin:Code>';                   
                    InputValueXML = InputValueXML +'</fin:HpiMake>';
                    InputValueXML = InputValueXML +'<fin:IsNew>'+Is_NewUsed +'</fin:IsNew>';
                    InputValueXML = InputValueXML +'</fin:AssetDetails>';
                    InputValueXML = InputValueXML +'</fin:Interest>';
                    InputValueXML = InputValueXML +'</fin:FinanceAdd>';
                    InputValueXML = InputValueXML +'</soapenv:Body>';
                    InputValueXML = InputValueXML +'</soapenv:Envelope>';
               
                    system.debug('========= string values ========'+InputValueXML);

                    HPI_Integration.STSRequestSoap  eqcan =new HPI_Integration.STSRequestSoap();
                    
                    string efxEnv ='FinanceAddResponse'; // 'FinanceEnquiryResponse';// 'FinanceAddResponse'; //System.Label.Equifax_EFXEnvironment ;
                    
                    //system.debug('========= equifax Envirnment value ========'+efxEnv);

                    response= eqcan.Submit_Http(InputValueXML,efxEnv); //'A01PKSS'
                    system.debug('========= response ========'+response);
                   /* if(response.contains('TRUE') && response.contains('200'))
                    {
                        objContractEquipment.IS_Registered__c = true ;
                        update objContractEquipment;
                        system.debug('========= response objContractEquipment========'+objContractEquipment);
                    }*/
                  
                    // XML Parsing  

                    //Map<string,list<Dom.XMLNode>> childXMLlist = new Map<string,list<Dom.XMLNode>>();

                    //Dom.Document doc = new Dom.Document();
                    //doc.load(response); 
                   }
                   else 
                   {
                       response= 'Lease Product or Serial/chasis number is null.';
                   }
                   
                    return response+msg;  
    }
    
     webservice static void HPI_RegiterAllEquipments(String leaseAccId)
    {   
        Hpi_RegisterEquipments obj = new Hpi_RegisterEquipments(); 
        Obj.strContractId = leaseAccId;
        Integer recordscount= [select count() from cllease__Contract_Equipment__c where cllease__Contract__c =:leaseAccId and HPI_Registration_Required__c =:true];
         system.debug('========= strContractId ========'+obj.strContractId ); 
         system.debug('========= recordscount========'+recordscount ); 
        Database.executeBatch(obj,1); 
      
    }    
    //hpi_parsing
    
     webservice static string hpi_parsing(String leaseAccId)
    {      
           string response = ' No Equipments Found';
           List<cllease__Contract_Equipment__c> lstEquipement = [select Id,Name,IS_Registered__c,cllease__Contract__c,cllease__Contract__r.cllease__Contract_Date__c,cllease__Contract__r.Name,cllease__Contract__r.cllease__Term__c,
           HPI_Code__c,HPI_Registration_Required__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,Vehicle_Registration_Number__c,Vehicle_Chassis_Number__c,
           cllease__VIN__c,cllease__Equipment_Description__c,cllease__Equipment_Serial_Number__c,cllease__Equipment_Type__c,cllease__Contract__r.cllease__Lease_Product_Name__r.Name,cllease__Make__c, cllease__Model__c,  NewUsed__c
           from cllease__Contract_Equipment__c where cllease__Contract__c =:leaseAccId];
           system.debug('========= lstEquipement ========'+lstEquipement); 
             
           if(lstEquipement.size() >0)
           {
               cllease__Contract_Equipment__c objContractEquipment = lstEquipement[0];
        
              
               //response  = hpi_FinanceAdd(objContractEquipment);
               // response  = hpi_WebFinanceAdd(objContractEquipment);
               
           }
           
             for(cllease__Contract_Equipment__c objEquip :lstEquipement)
                   {
                        response  = hpi_FinanceAdd(objEquip);
                        system.debug('========= response ======== for Equipment :' +objEquip.Name +response);   
                        if(response.contains('TRUE') && response.contains('200'))
                            {
                                objEquip.IS_Registered__c = true ;
                                system.debug('========= response objContractEquipment========'+objEquip);
                            }
                  
                   }
           //response = responseAdd;
            update lstEquipement;
            system.debug('========= response ========'+response);   
           
      return response;    
    }
    @Future(callout=true) 
   public static void hpi_getCategoryCode()
    {                                                                       
               
               
                      // dynamic string 

                    string InputValueXML = '';
                    InputValueXML = InputValueXML +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fin="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
                    InputValueXML = InputValueXML +'<soapenv:Header/>';
                    InputValueXML = InputValueXML +'<soapenv:Body>';
                    InputValueXML = InputValueXML +'<fin:FinanceCodeEnquiry>';
                    InputValueXML = InputValueXML +'<fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'<fin:CustomerCode>' +CustomerCode + '</fin:CustomerCode>';
                    InputValueXML = InputValueXML +'<fin:Initials>ABC</fin:Initials>';
                    InputValueXML = InputValueXML +'<fin:Password>' +Passcode + '</fin:Password>';
                    InputValueXML = InputValueXML +'</fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'</fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:Parameters>';
                    InputValueXML = InputValueXML +'<fin:DataType>category</fin:DataType>';
                    InputValueXML = InputValueXML +'</fin:Parameters>';
                    InputValueXML = InputValueXML +'</fin:FinanceCodeEnquiry>';
                    InputValueXML = InputValueXML +'</soapenv:Body>';
                    InputValueXML = InputValueXML +'</soapenv:Envelope>';
              
                    system.debug('========= string values ========'+InputValueXML);

                    HPI_Integration.STSRequestSoap  eqcan =new HPI_Integration.STSRequestSoap();
                    
                    string efxEnv = 'FinanceEnquiryResponse';// 'FinanceAddResponse'; //System.Label.Equifax_EFXEnvironment ;
                    
                    //system.debug('========= equifax Envirnment value ========'+efxEnv);

                    string response = eqcan.Submit_Http(InputValueXML,efxEnv); //'A01PKSS'
                    system.debug('========= response ========'+response);
                    // XML Parsing  

                    //Map<string,list<Dom.XMLNode>> childXMLlist = new Map<string,list<Dom.XMLNode>>();

                    Dom.Document doc = new Dom.Document();
                    //doc.load(response); 
                   // return response;
                   
                      
             }
            /* public Object callback() {
                  //  HttpResponse response = Continuation.getResponse((String)state);
                
                    //Integer statusCode = response.getStatusCode();
                   // if (statusCode >= 2000) {
                    //    return 'Continuation error: ' + response.getStatus();
                   // }
                 //system.debug('response.getBody(); :' +response.getBody());
                    
                    //result =resfuture.getValue();
                    // Get the response by using the unique label

                  HttpResponse httpRes = Continuation.getResponse(returnedContinuationId);
            
                  // Set the result variable that is displayed on the Visualforce page
            
                  response = httpRes.getBody();
            
                  // Return null to re-render the original Visualforce page
   
                    return null;
                }
                public Object getAynscCodes()
              {
                   
                    AsyncWebservicesHpiCoUkFinanceReg.AsyncFinanceRegistrationV1 wb_fr = new AsyncWebservicesHpiCoUkFinanceReg.AsyncFinanceRegistrationV1();
                    webservicesHpiCoUkFinanceReg.CustomerType ct =  new webservicesHpiCoUkFinanceReg.CustomerType();
                    ct.CustomerCode = CustomerCode;
                    ct.Initials = 'SAF';
                    ct.Password = Passcode;
                   
                    webservicesHpiCoUkFinanceReg.ParameterType pr = new  webservicesHpiCoUkFinanceReg.ParameterType();
                    pr.DataType ='category';
                   
                    webservicesHpiCoUkFinanceReg.AuthenticationType au = new webservicesHpiCoUkFinanceReg.AuthenticationType();
                    au.CustomerDetails = ct;
                    
                    AsyncWebservicesHpiCoUkFinanceReg.FinanceCodeResponseTypeFuture res = new AsyncWebservicesHpiCoUkFinanceReg.FinanceCodeResponseTypeFuture();
                   
                      HttpRequest req = new HttpRequest();
                        req.setEndpoint(System.Label.HPI_Endpoint);
                        req.setMethod('POST');
                        req.setHeader('Content-Type', 'text/xml; charset=UTF-8'); 
                        req.setHeader('SOAPAction', 'https://pat-wss.hpi.co.uk/TradeSoap/services/FinanceRegistrationV1/FinanceEnquiry');
                    System.Continuation con = new System.Continuation(60);
                   
                    con.continuationMethod = 'callback';        
                    returnedContinuationId = con.addHttpRequest(req);
                      
                    res = wb_fr.beginFinanceCodeEnquiry(con,au,pr);
                   HttpResponse response = Continuation.getResponse(returnedContinuationId);
                   
                    //system.debug('response.getBody():' +response.getBody());
                      system.debug('res:' +res.getValue());               
                   return con;
              }*/
              public static List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> getAgreementTypes()
              {    
                    system.debug('******************getting HPI codes************************************************* ');
                    string response= '';
                    webservicesHpiCoUkFinanceReg.FinanceRegistrationV1 wb_fr = new webservicesHpiCoUkFinanceReg.FinanceRegistrationV1();
                    webservicesHpiCoUkFinanceReg.CustomerType ct =  new webservicesHpiCoUkFinanceReg.CustomerType();
                    ct.CustomerCode = CustomerCode;
                    ct.Initials = 'SAF';
                    ct.Password = Passcode;
                    webservicesHpiCoUkFinanceReg.ParameterType pr = new  webservicesHpiCoUkFinanceReg.ParameterType();
                    pr.DataType ='agreementtype';
                    webservicesHpiCoUkFinanceReg.AuthenticationType au = new webservicesHpiCoUkFinanceReg.AuthenticationType();
                    au.CustomerDetails = ct;
                    webservicesHpiCoUkFinanceReg.FinanceCodeResponseType res = new webservicesHpiCoUkFinanceReg.FinanceCodeResponseType();
                    res =  wb_fr.financeCodeEnquiry(au,pr);
                    webservicesHpiCoUkFinanceReg.ParameterType rs_pr = res.Parameters;
                    webservicesHpiCoUkFinanceReg.DescriptionListType rs_dl = res.DescriptionList;
                    List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> Lst_rs_dl_code = rs_dl.CodeDescription;
                    //system.debug('code : ' +Lst_rs_dl_code[0].Code + +Lst_rs_dl_code[0].Description);
                    //StoreInDB(pr.DataType,Lst_rs_dl_code,'');
                  
                  
                  /* List<HPI_Agreement_Types__c> lst_AgreementType = [Select Id,Name,Code__c,Desciption__c from HPI_Agreement_Types__c];
                   if(lst_AgreementType.size() >0) {delete lst_AgreementType;}
                   lst_AgreementType = new  List<HPI_Agreement_Types__c>();
                   for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :Lst_rs_dl_code)
                   {
                       HPI_Agreement_Types__c objAgType = new HPI_Agreement_Types__c();
                       objAgType.Code__c = objdlcode.Code;
                       objAgType.Desciption__c = objdlcode.Description.trim();
                       lst_AgreementType.add(objAgType);
                       system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                   }
                   //system.debug('lst_AgreementType : ' +lst_AgreementType);
                   insert lst_AgreementType;*/
                   return Lst_rs_dl_code;
              } 
               public static void StoreInDB(string strCategory,List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> Lst_rs_dl_code,string strSubCategory)
              { 
               List<HPI_Agreement_Types__c> lst_AgreementType = [Select Id,Name,Code__c,Desciption__c,Category__c,Category_SubCode__c from HPI_Agreement_Types__c where Category__c =: strCategory];
                  system.debug('strCategory : ' +strCategory + '  strSubCategory : ' +strSubCategory);
                   if(lst_AgreementType.size() >0) {
                       if(strSubCategory == null) { delete lst_AgreementType; }
                       else {
                        List<HPI_Agreement_Types__c> lst_deleteSubCategories = [Select Id,Name,Code__c,Desciption__c,Category__c,Category_SubCode__c  from HPI_Agreement_Types__c where Category__c =: strCategory and Category_SubCode__c =: strSubCategory];
                         system.debug('lst_deleteSubCategories : ' +lst_deleteSubCategories);
                        if(lst_deleteSubCategories.size() >0)  { delete lst_deleteSubCategories; }
                       }
                   }
                   lst_AgreementType = new  List<HPI_Agreement_Types__c>();
                   for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :Lst_rs_dl_code)
                   {
                       HPI_Agreement_Types__c objAgType = new HPI_Agreement_Types__c();
                       objAgType.Category__c = strCategory;
                       objAgType.Category_SubCode__c = strSubCategory;
                       objAgType.Code__c = objdlcode.Code;
                       objAgType.Desciption__c = objdlcode.Description.trim();
                       lst_AgreementType.add(objAgType);
                       //system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                   }
                   
                    system.debug('lst_AgreementType: ' + lst_AgreementType);
                    insert lst_AgreementType;
              } 
              
              
                public static void Get_Hpi_Agreementype(List<string> lstDescription)
              {     
                   system.debug('lstDescription :' + lstDescription);
                   map_codeDesc = new Map<String,webservicesHpiCoUkFinanceReg.CodeDescriptionType>();
                 
                   //List<string> lst_category = new List<string>{'agreementtype','category','makecode'};
                   List<String> lst_CategoryCode = new List<String>();
                  
                  List<HPI_Equipments__c> lst_EquipmentType = [Select Id,Name,HPI_Agreement_Types__c,HPI_Agreement_Types__r.Code__c,HPI_Agreement_Types__r.Desciption__c,HPI_Agreement_Types__r.Category__c,Equipment_Type_Name__c from HPI_Equipments__c where 
                       Equipment_Type_Name__c In: lstDescription];
                  system.debug('lst_EquipmentType :' + lst_EquipmentType);
                 
                 for(HPI_Equipments__c obj :lst_EquipmentType)
                   {
                        webservicesHpiCoUkFinanceReg.CodeDescriptionType objcodedesc = new webservicesHpiCoUkFinanceReg.CodeDescriptionType();
                        objcodedesc.Code = obj.HPI_Agreement_Types__r.Code__c;
                        objcodedesc.Description = obj.HPI_Agreement_Types__r.Desciption__c;
                 
                        map_codeDesc.put(obj.Equipment_Type_Name__c, objcodedesc);
                        //******************get the category codes
                        if(obj.HPI_Agreement_Types__r.Category__c == 'category') {lst_CategoryCode.add(obj.HPI_Agreement_Types__r.Code__c); }
                     // 
                   } 
                   
                List<HPI_Agreement_Types__c> lst_Agreement_Types = [Select Id,Name,Code__c,Desciption__c,Category__c from HPI_Agreement_Types__c 
                    where Category_SubCode__c In: lst_CategoryCode or Desciption__c In: lstDescription];
                 system.debug('lst_Agreement_Types :' + lst_Agreement_Types );
                  //******************get the category sub codes from Agreement types
                   for(HPI_Agreement_Types__c obj :lst_Agreement_Types)
                   {
                        webservicesHpiCoUkFinanceReg.CodeDescriptionType objcodedesc = new webservicesHpiCoUkFinanceReg.CodeDescriptionType();
                        objcodedesc.Code = obj.Code__c;
                        objcodedesc.Description = obj.Desciption__c;
                 
                       map_codeDesc.put(obj.Desciption__c, objcodedesc);
                     // 
                   }
               system.debug('map_codeDesc :' + map_codeDesc);
                  
              }  
               
                    public static List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> getCategoryCodes()
              {    
                    system.debug('******************getting HPI Category codes************************************************* ');
                    string response= '';
                    webservicesHpiCoUkFinanceReg.FinanceRegistrationV1 wb_fr = new webservicesHpiCoUkFinanceReg.FinanceRegistrationV1();
                    webservicesHpiCoUkFinanceReg.CustomerType ct =  new webservicesHpiCoUkFinanceReg.CustomerType();
                    ct.CustomerCode = CustomerCode;
                    ct.Initials = 'SAF';
                    ct.Password = Passcode;
                    webservicesHpiCoUkFinanceReg.ParameterType pr = new  webservicesHpiCoUkFinanceReg.ParameterType();
                    pr.DataType ='category';
                   // pr.DataType ='category';
                    webservicesHpiCoUkFinanceReg.AuthenticationType au = new webservicesHpiCoUkFinanceReg.AuthenticationType();
                    au.CustomerDetails = ct;
                    webservicesHpiCoUkFinanceReg.FinanceCodeResponseType res = new webservicesHpiCoUkFinanceReg.FinanceCodeResponseType();
                    res =  wb_fr.financeCodeEnquiry(au,pr);
                      system.debug('res: ' +res);
                    webservicesHpiCoUkFinanceReg.ParameterType rs_pr = res.Parameters;
                    webservicesHpiCoUkFinanceReg.DescriptionListType rs_dl = res.DescriptionList;
                      system.debug('rs_dl : ' +rs_dl);
                    List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> Lst_rs_dl_code = rs_dl.CodeDescription;
                      for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :Lst_rs_dl_code)
                       {
                            system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                       }
                   
                   //StoreInDB(pr.DataType,Lst_rs_dl_code,''); 
                   
                   return Lst_rs_dl_code;
              }
               
             /*    public static string getDeleteFinance()
              {    
                    system.debug('******************getting HPI Category codes************************************************* ');
                    string response= '';
                    webservicesHpiCoUkFinanceReg.FinanceRegistrationV1 wb_fr = new webservicesHpiCoUkFinanceReg.FinanceRegistrationV1();
                    webservicesHpiCoUkFinanceReg.CustomerType ct =  new webservicesHpiCoUkFinanceReg.CustomerType();
                    ct.CustomerCode = CustomerCode;
                    ct.Initials = 'SAF';
                    ct.Password = Passcode;
                    webservicesHpiCoUkFinanceReg.ParameterType pr = new  webservicesHpiCoUkFinanceReg.ParameterType();
                    pr.DataType ='category';
                   // pr.DataType ='category';
                    webservicesHpiCoUkFinanceReg.AuthenticationType au = new webservicesHpiCoUkFinanceReg.AuthenticationType();
                    au.CustomerDetails = ct;
                    webservicesHpiCoUkFinanceReg.FinanceCodeResponseType res = new webservicesHpiCoUkFinanceReg.FinanceCodeResponseType();
                    res =  wb_fr.financeCodeEnquiry(au,pr);
                    webservicesHpiCoUkFinanceReg.ParameterType rs_pr = res.Parameters;
                    webservicesHpiCoUkFinanceReg.DescriptionListType rs_dl = res.DescriptionList;
                    List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> Lst_rs_dl_code = rs_dl.CodeDescription;
                      for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :Lst_rs_dl_code)
                       {
                            system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                       }
                   
                   StoreInDB(pr.DataType,Lst_rs_dl_code,''); 
                   
                   return 'code : ' +Lst_rs_dl_code[0].Code + +Lst_rs_dl_code[0].Description;
              }*/
               public static  List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> getMakeCodes(string strmakecode)
              {
                     system.debug('******************getting HPI Make code************************************************* ');
                    string response= '';
                    webservicesHpiCoUkFinanceReg.FinanceRegistrationV1 wb_fr = new webservicesHpiCoUkFinanceReg.FinanceRegistrationV1();
                    webservicesHpiCoUkFinanceReg.CustomerType ct =  new webservicesHpiCoUkFinanceReg.CustomerType();
                    ct.CustomerCode = CustomerCode;
                    ct.Initials = 'SAF';
                    ct.Password = Passcode;
                    webservicesHpiCoUkFinanceReg.ParameterType pr = new  webservicesHpiCoUkFinanceReg.ParameterType();
                    pr.DataType ='makecode';
                    pr.Code =strmakecode ;//'G';
                    webservicesHpiCoUkFinanceReg.AuthenticationType au = new webservicesHpiCoUkFinanceReg.AuthenticationType();
                    au.CustomerDetails = ct;
                    webservicesHpiCoUkFinanceReg.FinanceCodeResponseType res = new webservicesHpiCoUkFinanceReg.FinanceCodeResponseType();
                    res =  wb_fr.financeCodeEnquiry(au,pr);
                    webservicesHpiCoUkFinanceReg.ParameterType rs_pr = res.Parameters;
                    webservicesHpiCoUkFinanceReg.DescriptionListType rs_dl = res.DescriptionList;
                    List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> Lst_rs_dl_code = rs_dl.CodeDescription;
                      for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :Lst_rs_dl_code)
                       {
                           system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                       }
                   
                     // StoreInDB(pr.DataType ,Lst_rs_dl_code,strmakecode); 
                   
                   return Lst_rs_dl_code;
              }
                public static string getMakeDescription(string strmakedesc)
              {
                      
                     system.debug('******************getting HPI Make description************************************************* ');
                    string response= '';
                    webservicesHpiCoUkFinanceReg.FinanceRegistrationV1 wb_fr = new webservicesHpiCoUkFinanceReg.FinanceRegistrationV1();
                    webservicesHpiCoUkFinanceReg.CustomerType ct =  new webservicesHpiCoUkFinanceReg.CustomerType();
                    ct.CustomerCode = CustomerCode;
                    ct.Initials = 'SAF';
                    ct.Password = Passcode;
                    webservicesHpiCoUkFinanceReg.ParameterType pr = new  webservicesHpiCoUkFinanceReg.ParameterType();
                    pr.DataType ='makedescription';
                    pr.Code = strmakedesc ;//'AU';
                    webservicesHpiCoUkFinanceReg.AuthenticationType au = new webservicesHpiCoUkFinanceReg.AuthenticationType();
                    au.CustomerDetails = ct;
                    webservicesHpiCoUkFinanceReg.FinanceCodeResponseType res = new webservicesHpiCoUkFinanceReg.FinanceCodeResponseType();
                    res =  wb_fr.financeCodeEnquiry(au,pr);
                    webservicesHpiCoUkFinanceReg.ParameterType rs_pr = res.Parameters;
                    webservicesHpiCoUkFinanceReg.DescriptionListType rs_dl = res.DescriptionList;
                    List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> Lst_rs_dl_code = rs_dl.CodeDescription;
                      for(webservicesHpiCoUkFinanceReg.CodeDescriptionType objdlcode :Lst_rs_dl_code)
                       {
                           system.debug('code : ' +objdlcode.Code + '  Desc : ' +objdlcode.Description);
                       }
                   
                     StoreInDB(pr.DataType ,Lst_rs_dl_code,strmakedesc); 
                   
                   return 'code : ' +Lst_rs_dl_code[0].Code + +Lst_rs_dl_code[0].Description;
              }
     @Future(callout=true) 
   public static void hpi_getAgreementType()
    {                                                                       
               
               
                      // dynamic string 

                    string InputValueXML = '';
                    InputValueXML = InputValueXML +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fin="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
                    InputValueXML = InputValueXML +'<soapenv:Header/>';
                    InputValueXML = InputValueXML +'<soapenv:Body>';
                    InputValueXML = InputValueXML +'<fin:FinanceCodeEnquiry>';
                    InputValueXML = InputValueXML +'<fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'<fin:CustomerCode>' +CustomerCode + '</fin:CustomerCode>';
                    InputValueXML = InputValueXML +'<fin:Initials>ABC</fin:Initials>';
                    InputValueXML = InputValueXML +'<fin:Password>' +Passcode + '</fin:Password>';
                    InputValueXML = InputValueXML +'</fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'</fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:Parameters>';
                    InputValueXML = InputValueXML +'<fin:DataType>agreementtype</fin:DataType>';
                    InputValueXML = InputValueXML +'</fin:Parameters>';
                    InputValueXML = InputValueXML +'</fin:FinanceCodeEnquiry>';
                    InputValueXML = InputValueXML +'</soapenv:Body>';
                    InputValueXML = InputValueXML +'</soapenv:Envelope>';

              
                    system.debug('========= string values ========'+InputValueXML);

                    HPI_Integration.STSRequestSoap  eqcan =new HPI_Integration.STSRequestSoap();
                    
                    string efxEnv = 'FinanceCodeResponse';// 'FinanceAddResponse'; //System.Label.Equifax_EFXEnvironment ;
                    
                    //system.debug('========= equifax Envirnment value ========'+efxEnv);

                    string response = eqcan.Submit_Http(InputValueXML,efxEnv); //'A01PKSS'
                    system.debug('========= response ========'+response);
                    // XML Parsing  

                    //Map<string,list<Dom.XMLNode>> childXMLlist = new Map<string,list<Dom.XMLNode>>();

                    Dom.Document doc = new Dom.Document();
                    //doc.load(response); 
                   // return response;    
             }   
   webservice static String hpi_FinanceInquiry(String EquipmentId)
    {                                                                       
                   string response = ' No Equipments Found';
                   List<cllease__Contract_Equipment__c> lstEquipement = [select Id,cllease__Contract__c,cllease__Contract__r.cllease__Contract_Date__c,cllease__Contract__r.Name,cllease__Contract__r.cllease__Term__c,HPI_Code__c,HPI_Registration_Required__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,
                   Vehicle_Registration_Number__c,Vehicle_Chassis_Number__c,cllease__VIN__c,cllease__Equipment_Description__c,cllease__Equipment_Serial_Number__c
                   from cllease__Contract_Equipment__c where Id =:EquipmentId];
                   
                     system.debug('========= lstEquipement ========'+lstEquipement);                    
                   
                    if(lstEquipement.size() >0)
                   {
                     cllease__Contract_Equipment__c objContractEquipment = lstEquipement[0];                              
                 
                    string serialno = objContractEquipment.cllease__Equipment_Serial_Number__c; 
                    string VIN = (objContractEquipment.Vehicle_Chassis_Number__c == null) ? '' :objContractEquipment.Vehicle_Chassis_Number__c; //'TEST';
                                    
                   
           
                    string ContractId = objContractEquipment.cllease__Contract__r.name.replace('-',''); //'TEST';
                    system.debug('ContractId  :' + ContractId );
                    string VRM = objContractEquipment.Vehicle_Registration_Number__c; //'TEST';
                    //string VIN = objContractEquipment.Vehicle_Chassis_Number__c; //'TEST';
                    string strVehicleNo = string.isblank(VRM) ? (string.isblank(serialno) ? '' : serialno): VRM;            
                      
                      // you can pass only VRM or VIN number to get Inquiry details at one time.
                    string Vrmfinal = string.isblank(VIN) ? strVehicleNo : '';
                     system.debug('========= Vrmfinal ========'+Vrmfinal);     
                      // dynamic string 

                    string InputValueXML = '';

                   //InputValueXML = InputValueXML +'<?xml version="1.0" encoding="utf-8"?><CNCustTransmitToEfx xmlns="http://www.equifax.ca/XMLSchemas/CustToEfx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.equifax.ca/XMLSchemas/UAT/CNCustTransmitToEfx.xsd">';
                    InputValueXML = InputValueXML +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fin="http://webservices.hpi.co.uk/FinanceRegistrationV1">';
                    InputValueXML = InputValueXML +'<soapenv:Header/>';
                    InputValueXML = InputValueXML +'<soapenv:Body>';
                    InputValueXML = InputValueXML +'<fin:FinanceEnquiry>';
                    InputValueXML = InputValueXML +'<fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'<fin:CustomerCode>' +CustomerCode + '</fin:CustomerCode>';
                    InputValueXML = InputValueXML +'<fin:Initials>ABC</fin:Initials>';
                    InputValueXML = InputValueXML +'<fin:Password>' +Passcode + '</fin:Password>';
                    InputValueXML = InputValueXML +'</fin:CustomerDetails>';
                    InputValueXML = InputValueXML +'</fin:Authentication>';
                    InputValueXML = InputValueXML +'<fin:Interest>';
                    InputValueXML = InputValueXML +'<fin:Identification>';
                    InputValueXML = InputValueXML +'<fin:Vin>'+VIN+'</fin:Vin>';
                    InputValueXML = InputValueXML +'<fin:Vrm>'+Vrmfinal+'</fin:Vrm>';
                    InputValueXML = InputValueXML +'<fin:AgreementReference>'+ ContractId +'</fin:AgreementReference>';
                   // InputValueXML = InputValueXML +'<fin:Vrm>XX11YYY</fin:Vrm>'; 
                   //InputValueXML = InputValueXML +'<fin:AgreementReference>FIN123456</fin:AgreementReference>'; 
                    InputValueXML = InputValueXML +'</fin:Identification>';
                    InputValueXML = InputValueXML +'</fin:Interest>';
                    InputValueXML = InputValueXML +'</fin:FinanceEnquiry>';
                    InputValueXML = InputValueXML +'</soapenv:Body>';
                    InputValueXML = InputValueXML +'</soapenv:Envelope>';

              
                    system.debug('========= string values ========'+InputValueXML);

                    HPI_Integration.STSRequestSoap  eqcan =new HPI_Integration.STSRequestSoap();
                    
                    string efxEnv = 'FinanceEnquiryResponse';// 'FinanceAddResponse'; //System.Label.Equifax_EFXEnvironment ;
                    
                    //system.debug('========= equifax Envirnment value ========'+efxEnv);
                    
                       
                    response = eqcan.Submit_Http(InputValueXML,efxEnv); //'A01PKSS'
                   
                 
                    // XML Parsing  

                    //Map<string,list<Dom.XMLNode>> childXMLlist = new Map<string,list<Dom.XMLNode>>();

                    //Dom.Document doc = new Dom.Document();
                    //doc.load(response); 
                    }
                    system.debug('========= response ========'+response);
                    return response;    
             }
             
 
 }