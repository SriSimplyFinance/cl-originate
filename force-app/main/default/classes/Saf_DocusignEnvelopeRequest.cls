global class Saf_DocusignEnvelopeRequest {
//updated docusign code replacing saf_docuignEnvelope
  Webservice static string CreateEnvelopeRequestbody(Saf_DocusignPayload payload){
    Integer count=0;
    system.debug('Parties :' + payload.objpartyIds + 'genappId:' + payload.genappId + 'lstemplates:' + payload.templates);
    Saf_Docusign__c objSettings = Saf_Docusign__c.getOrgDefaults();
    List<saf_docusign.cls_compositeTemplates> lstcomptemp = new List<saf_docusign.cls_compositeTemplates>();
      saf_docusign.cls_customFields objCustomFields = new saf_docusign.cls_customFields();
    
   List<Payment_Stream_Proposal__c> LstOfStream =[select id,Number_of_Payments__c,Payment_Amount__c,Payment_Frequency__c,Payment_inc_VAT__c,Proposal_Sequence__c from Payment_Stream_Proposal__c where Application__c =:payload.genappId ORDER BY Proposal_Sequence__c ASC];

    //can be removed on second deployment
    AggregateResult[] SumofTotalPaymentamount =[select sum(Total_Payment_amount_proposal__c) from Payment_Stream_Proposal__c where Application__c =:payload.genappId];
    List<clcommon__Party__c> lstpartycontact = [select Id,Name,genesis__Application__c,genesis__Application__r.Name,clcommon__Contact__r.Name, clcommon__Contact__r.Mailingstreet, clcommon__Contact__r.MailingCity,clcommon__Contact__r.MailingPostalCode,clcommon__Contact__r.MailingCountry, clcommon__Contact__r.SAF_OfficerId__c,clcommon__Type__c,clcommon__Type__r.Name,genesis__Party_Name__c,clcommon__Contact__r.Email,clcommon__Contact__r.MobilePhone from clcommon__Party__c where genesis__Application__c =:payload.genappId and clcommon__Type__r.Name =: 'Guarantor' and clcommon__Contact__c != null];
    List<clcommon__Party__c> lstsupplierparty = [select Id,Name,clcommon__Account__r.Phone,clcommon__Account__r.Name,genesis__Application__c,clcommon__Contact__r.Name, clcommon__Contact__r.Mailingstreet, clcommon__Contact__r.MailingCity,clcommon__Contact__r.MailingPostalCode,clcommon__Contact__r.MailingCountry, clcommon__Type__c,clcommon__Type__r.Name,genesis__Party_Name__c,clcommon__Contact__r.Email,clcommon__Contact__r.MobilePhone from clcommon__Party__c where genesis__Application__c =: payload.genappId and (clcommon__Type__r.Name =: 'DEALER' OR clcommon__Type__r.Name =: 'VENDOR') and clcommon__Contact__c != null];
//still used so need to remain      
    List<genesis__Applications__c> genapp = [select Name,id,genesis__Contact__r.Name,Term_Transact__c,genesis__CL_Product_Name__c,genesis__Contact__r.Email,genesis__Account__r.Phone, genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.BillingAddress, Documentation_Fee__c, Total_Gross_Asset_Cost__c,Total_VAT__c,Total_Net_Asset_Cost__c,genesis__Account__r.AccountNumber,Security_Deposit__c,genesis__Expected_Start_Date__c,genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingStreet,genesis__Account__r.BillingCountry,genesis_Option_to_purchase_Fee__c,Finance_Charges__c,Evergreen_Payment_Amount__c,Total_Rental_Payments__c,Balance_finance_transact__c from genesis__Applications__c where id =:payload.genappId];    
    List<Account> lstparty = [Select id,name,clcommon__Email__c,AccountNumber,BillingStreet,BillingCity,BillingPostalCode,BillingCountry,Phone from Account where Id In: payload.objpartyIds or Id =:payload.straccountId];
    List<dsfs__DocuSign_Envelope_Recipient__c> recepientList = [select Id,dsfs__DocuSign_Signature_Name__c,dsfs__Recipient_Email__c,dsfs__Routing_Order__c,dsfs__DocuSign_Recipient_Role__c,dsfs__Access_Code__c,Account__r.Id,Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,Account__r.Name,Account__r.Phone,Account__r.clcommon__Email__c,dsfs__DocuSign_EnvelopeID__c from dsfs__DocuSign_Envelope_Recipient__c where (Account__r.Id In: payload.objpartyIds or Account__r.Id =:payload.straccountId) and dsfs__DocuSign_EnvelopeID__c =:payload.recipientEnvelopeId];
    dsfs__DocuSign_Envelope__c envelopInfo = [select Id,dsfs__DocuSign_Email_Subject__c,dsfs__Custom_Field_1_Name__c,dsfs__Custom_Field_1_Value__c,dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Envelope__c where dsfs__Custom_Field_1_Name__c =:payload.genappName order by CreatedDate desc Limit 1];
   	List<genesis__Application_Equipment__c> lstEquipmnt = [select id,name,genesis_Equipment_Description__c,genesis_make__c,genesis_Model__c,New_Used__c,genesis_Equipment_Serial_Number__c,genesis_Vehicle_Chassis_Number__c,genesis_Vehicle_Registration_Number__c,Total_asset_cost__c,Year_Of_Manufature_text__c,genesis_Net_Asset_Cost__c from genesis__Application_Equipment__c where genesis__Application__c =: payload.genappId];

   //generate the available templates frm docusign
   for(string strtemp: payload.templates)
    {
      saf_docusign.cls_serverTemplates objstem = new saf_docusign.cls_serverTemplates();
      List<saf_docusign.cls_serverTemplates> lsttemp = new List<saf_docusign.cls_serverTemplates>();

      if(!string.isblank(strtemp)) {
        count=count+1;
        system.debug('count:' +string.valueof(count)+strtemp);
        objstem.sequence=string.valueof(count);
        objstem.templateId = strtemp; //'62ab05ab-33a9-469a-87e4-e820d3c52941';
        lsttemp.add(objstem);
      }
      saf_docusign.cls_recipients objrecip = new saf_docusign.cls_recipients ();
      saf_docusign.cls_textCustomFields objtxtCustomFields = new saf_docusign.cls_textCustomFields();
      saf_docusign.cls_inlineTemplates objtemp = new saf_docusign.cls_inlineTemplates();
      objtemp.sequence=string.valueof(count);
      List<saf_docusign.cls_inlineTemplates> lstinlinetemp= new List<saf_docusign.cls_inlineTemplates>();
      lstinlinetemp.add(objtemp);
        
      saf_docusign.cls_tabs  objtabs= new saf_docusign.cls_tabs();
      Saf_DocuSign.cls_textTabs objtxttab=new Saf_DocuSign.cls_textTabs();
      List<saf_docusign.cls_textTabs> lsttxttab = new List<saf_docusign.cls_textTabs>();
      List<saf_docusign.cls_textCustomFields> lsttxtCustomFields = new List<saf_docusign.cls_textCustomFields>();
      
      List<saf_docusign.cls_signers> lstsigner= new List<saf_docusign.cls_signers>();
      
      Integer recpientId = 0;
      system.debug('lstparty size:: '+lstparty.size());
      for(Account objparty: lstparty )
      {
       //create the signer objects
        recpientId = recpientId +1;
        saf_docusign.cls_signers objsigner = new saf_docusign.cls_signers();
        system.debug('objparty:' + objparty); 

        objsigner.recipientId = string.valueof(recpientId);
       
          //add recipient details to signers
          //objsigner.roleName = 'Signer 1';
        system.debug('recepientList size:: '+recepientList.size());
        String recepientBillingStreet=null,recepientBillingCity=null,
                recepientBillingPostCode=null,recepientName=null,recepientPhone=null,recepientEmail=null;
          integer signingOrderCount=recepientList.size();
          System.debug('recepientList.size():'+recepientList.size());
        for(integer j=0;j<recepientList.size();j++) {
          system.debug('j value:: '+j+' recepientID:: '+ recepientList[j].Account__r.Id+' ObjectId:: '+objparty.Id+' accessCode:: '+recepientList[j].dsfs__Access_Code__c);
          if(recepientList[j].Account__r.Id==objparty.Id){
            objsigner.email = recepientList[j].dsfs__Recipient_Email__c;
            objsigner.name = recepientList[j].dsfs__DocuSign_Signature_Name__c;
            objsigner.accessCode=recepientList[j].dsfs__Access_Code__c;
            objsigner.roleName = recepientList[j].dsfs__DocuSign_Recipient_Role__c;
            objsigner.routingOrder =  string.valueOf(recepientList[j].dsfs__Routing_Order__c);
            recepientBillingStreet=recepientList[j].Account__r.BillingStreet;
            recepientBillingCity=recepientList[j].Account__r.BillingCity;
            recepientBillingPostCode=recepientList[j].Account__r.BillingPostalCode;
            recepientName=recepientList[j].Account__r.Name;
            recepientPhone=recepientList[j].Account__r.Phone;
            recepientEmail=recepientList[j].Account__r.clcommon__Email__c;
			
            System.debug('RoleName:'+objsigner.roleName+'Routing Order:'+objsigner.routingOrder+ 'recepientName '+recepientName
                         +recepientPhone+'  '+recepientEmail );
            
            signingOrderCount=signingOrderCount+1;
				
            }

        }
          //envelope custom fields 
		objtxtCustomFields.name = 'APPLICATION NUMBER';
		objtxtCustomFields.value = envelopInfo.dsfs__Custom_Field_1_Name__c;
          objtxtCustomFields.show = true;
          objtxtCustomFields.required = true;
          lsttxtCustomFields.add(objtxtCustomFields);
          
          
      //start making bookmarks
        
        objtxttab.tabLabel = 'Your_Name';//DRName
        objtxttab.value = recepientName;
        lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Phone_Number';//DRPhone
        objtxttab.value =recepientPhone;
        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Email_Address';//DREmail
        objtxttab.value =  recepientEmail;        lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Full_Name';//DRName
        objtxttab.value = recepientName;
        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
        
       //create list of Signer and Guarantor Bookmarks i.e. GuarantorName1, SignerName1   
        Integer signerCount=0;
        Integer guarantorCount=0;
        for(dsfs__DocuSign_Envelope_Recipient__c objRecipientInfo : recepientList){
          signerCount = signerCount+1;
          guarantorCount=guarantorCount+1;
          if(objRecipientInfo.dsfs__DocuSign_Recipient_Role__c.contains('Guarantor')){
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Name'+guarantorCount;
            objtxttab.value = objRecipientInfo.Account__r.Name;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Address'+guarantorCount;
            string strpartyaddress = ((objRecipientInfo.Account__r.BillingStreet != null && objRecipientInfo.Account__r.BillingStreet != '') ? objRecipientInfo.Account__r.BillingStreet:'')+','+
                                     ((objRecipientInfo.Account__r.BillingCity != null && objRecipientInfo.Account__r.BillingCity != '') ? objRecipientInfo.Account__r.BillingCity : '')+','+((objRecipientInfo.Account__r.BillingPostalCode != null && objRecipientInfo.Account__r.BillingPostalCode != '') ? objRecipientInfo.Account__r.BillingPostalCode : '');
            strpartyaddress = strpartyaddress.removeend(',,').removeend(',');
            strpartyaddress = strpartyaddress.removestart(',,').removestart(',');
            objtxttab.value = strpartyaddress;
            if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Phone'+guarantorCount;
            objtxttab.value = objRecipientInfo.Account__r.Phone;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Email'+guarantorCount;
            objtxttab.value = objRecipientInfo.Account__r.clcommon__Email__c;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);


          }
          else{
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Signer_Name'+signerCount;
            objtxttab.value = objRecipientInfo.Account__r.Name;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Signer_Address'+signerCount;
            string strpartyaddress = ((objRecipientInfo.Account__r.BillingStreet != null && objRecipientInfo.Account__r.BillingStreet != '') ? objRecipientInfo.Account__r.BillingStreet:'')+','+
                                     ((objRecipientInfo.Account__r.BillingCity != null && objRecipientInfo.Account__r.BillingCity != '') ? objRecipientInfo.Account__r.BillingCity : '')+','+((objRecipientInfo.Account__r.BillingPostalCode != null && objRecipientInfo.Account__r.BillingPostalCode != '') ? objRecipientInfo.Account__r.BillingPostalCode : '');
            strpartyaddress = strpartyaddress.removeend(',,').removeend(',');
            strpartyaddress = strpartyaddress.removestart(',,').removestart(',');
            objtxttab.value = strpartyaddress;
            if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Signer_Phone'+signerCount;
            objtxttab.value = objRecipientInfo.Account__r.Phone;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Signer_Email'+signerCount;
            objtxttab.value = objRecipientInfo.Account__r.clcommon__Email__c;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

          }
        }

        //Supplier Details for HP(Fixed term) agreement template
        system.debug('lstsupplierparty.size():' +lstsupplierparty.size());
        if(lstsupplierparty.size() >0)
        {
          objtxttab = new saf_docusign.cls_textTabs();
          objtxttab.tabLabel = 'Supplier_Name';
          objtxttab.value = lstsupplierparty[0].clcommon__Account__r.Name;
          if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
          system.debug('Supplier Name:' +objtxttab);

          objtxttab = new saf_docusign.cls_textTabs();
          objtxttab.tabLabel = 'Supplier_Phone';
          objtxttab.value = lstsupplierparty[0].clcommon__Account__r.Phone;
          if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

        }

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Customer_Name';
        objtxttab.value = genapp[0].genesis__Account__r.Name;
        lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Customer_Address';

        string strcustaddress =  ((genapp[0].genesis__Account__r.BillingStreet != null && genapp[0].genesis__Account__r.BillingStreet != '')  ? genapp[0].genesis__Account__r.BillingStreet : '') +
                                 ','+ ((genapp[0].genesis__Account__r.BillingCity != null && genapp[0].genesis__Account__r.BillingCity != '') ? genapp[0].genesis__Account__r.BillingCity : '') +
                                 ','+ ((genapp[0].genesis__Account__r.BillingPostalCode != null && genapp[0].genesis__Account__r.BillingPostalCode != '') ? genapp[0].genesis__Account__r.BillingPostalCode : '');
        strcustaddress  = strcustaddress.removeend(',,').removeend(',');
        strcustaddress  = strcustaddress.removestart(',,').removestart(',');
        objtxttab.value = strcustaddress ;
        if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Customer_Postcode';
        objtxttab.value = string.valueof(genapp[0].genesis__Account__r.BillingPostalCode);
        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Account_Holder_Name';
        objtxttab.value = genapp[0].genesis__Account__r.Name;
        lsttxttab.add(objtxttab);
          
        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Company_Address';
        string strbillingaddress =  ((genapp[0].genesis__Account__r.BillingStreet != null && genapp[0].genesis__Account__r.BillingStreet != '')  ? genapp[0].genesis__Account__r.BillingStreet : '') +
                                    ','+ ((genapp[0].genesis__Account__r.BillingCity != null && genapp[0].genesis__Account__r.BillingCity != '') ? genapp[0].genesis__Account__r.BillingCity : '') +
                                    ','+ ((genapp[0].genesis__Account__r.BillingPostalCode != null && genapp[0].genesis__Account__r.BillingPostalCode != '') ? genapp[0].genesis__Account__r.BillingPostalCode : '');
        strbillingaddress = strbillingaddress.removeend(',,').removeend(',');
        strbillingaddress = strbillingaddress.removestart(',,').removestart(',');
        objtxttab.value = strbillingaddress;
        if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Company_Reg_No_if_applicable';
        objtxttab.value = genapp[0].genesis__Account__r.AccountNumber;
        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
         
        objtxttab.tabLabel = 'Full_Business_Name';
        objtxttab.value = genapp[0].genesis__Account__r.Name;
        System.debug('Business Name:'+objtxttab.value);
        lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Business_Address';
        string strbusinessaddress =  ((genapp[0].genesis__Account__r.BillingStreet != null && genapp[0].genesis__Account__r.BillingStreet != '')  ? genapp[0].genesis__Account__r.BillingStreet : '') +
                                     ','+ ((genapp[0].genesis__Account__r.BillingCity != null && genapp[0].genesis__Account__r.BillingCity != '') ? genapp[0].genesis__Account__r.BillingCity : '') +
                                     ','+ ((genapp[0].genesis__Account__r.BillingPostalCode != null && genapp[0].genesis__Account__r.BillingPostalCode != '') ? genapp[0].genesis__Account__r.BillingPostalCode : '');
        strbusinessaddress = strbusinessaddress.removeend(',,').removeend(',');
        strbusinessaddress = strbusinessaddress.removestart(',,').removestart(',');
        objtxttab.value = strbusinessaddress;
        System.debug('Business Address:'+objtxttab.value);
        if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Reg_No';
        objtxttab.value = genapp[0].genesis__Account__r.AccountNumber;
        lsttxttab.add(objtxttab);


        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Equipment_cash';
        objtxttab.value = '£ '+string.valueof(genapp[0].Total_Net_Asset_Cost__c);
        lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'VAT_Rate';
        objtxttab.value = '£ '+string.valueof(genapp[0].Total_VAT__c);
        lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Total_Cash_Price';
        objtxttab.value = '£ '+string.valueof(genapp[0].Total_Gross_Asset_Cost__c);
        lsttxttab.add(objtxttab);
         
        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel ='Term_Months';
        objtxttab.value = string.valueof(genapp[0].Term_Transact__c);
        System.debug('Term:'+string.valueof(genapp[0].Term_Transact__c));
        lsttxttab.add(objtxttab);

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'APFinanceCharge';
        objtxttab.value = '£ '+string.valueof(genapp[0].Finance_Charges__c);
        lsttxttab.add(objtxttab);
 
        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'APDocFee';
        objtxttab.value = '£ '+string.valueof(genapp[0].Documentation_Fee__c);
        lsttxttab.add(objtxttab);
          
        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'APOTPFee';
        objtxttab.value = '£ '+string.valueof(genapp[0].genesis_Option_to_purchase_Fee__c);
        lsttxttab.add(objtxttab);         
          
        objtxttab = new saf_docusign.cls_textTabs();
        //objtxttab.tabLabel = 'APDeposit';
        objtxttab.tabLabel = 'Total_Deposit';
        objtxttab.value = '£ '+string.valueof(genapp[0].Security_Deposit__c);
          
        lsttxttab.add(objtxttab); 
   
        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'APSecondary';
        objtxttab.value = '£ '+string.valueof(genapp[0].Evergreen_Payment_Amount__c);
        lsttxttab.add(objtxttab); 
          
        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'APTotalAF';
        objtxttab.value = '£ '+string.valueof(genapp[0].Balance_finance_transact__c);
        lsttxttab.add(objtxttab); 

        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'APTotalAP';
        objtxttab.value = '£ '+string.valueof(genapp[0].Total_Rental_Payments__c);
        lsttxttab.add(objtxttab);   
          
        objtxttab = new saf_docusign.cls_textTabs();
        objtxttab.tabLabel = 'Agreement_StartDate';
        objtxttab.value = string.valueof(genapp[0].genesis__Expected_Start_Date__c);
        lsttxttab.add(objtxttab);
          
        Integer noofStreams = Integer.valueof(Label.Number_of_Payment);
        Integer i=0;

        System.debug('LstOfStream.size():'+LstOfStream.size());
        if(LstOfStream.size()<=noofStreams)
        {
          for(Payment_Stream_Proposal__c stream:LstOfStream){
            i=i+1;

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel ='NoP'+i;
            objtxttab.value = string.valueof(stream.Number_of_Payments__c);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel ='PaymentAmount'+i;
            objtxttab.value = '£ '+string.valueof(stream.Payment_Amount__c);
            lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel='PaymentIncVAT'+i;
            objtxttab.value = '£ '+string.valueof(stream.Payment_inc_VAT__c);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

          }
        }

        //Equipment
        Integer noofEquipments = Integer.valueof(Label.Number_of_Equipment);
        Integer k=0;
        system.debug('lstEquipmnt.size():' +lstEquipmnt.size());
        System.debug('number of equipments:'+noofEquipments);
        if(lstEquipmnt.size() <= noofEquipments)
        {

          for(genesis__Application_Equipment__c Equipmnt: lstEquipmnt)
          {
            k=k+1;

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Equipment_Desc_row'+k;
            objtxttab.value = Equipmnt.genesis_Equipment_Description__c +'/'+Equipmnt.genesis_make__c+'/'+Equipmnt.genesis_Model__c+'/'+string.valueof(Equipmnt.New_Used__c)+'/'+Equipmnt.Year_Of_Manufature_text__c;
            objtxttab.value =  objtxttab.value.replace('null','').removeend('////').removeend('///').removeend('//').removeend('/').removestart('////').removestart('///').removestart('//').removestart('/');
            system.debug('Equipment:'+objtxttab.value);
            lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Serials _Chassis_row'+k;
            objtxttab.value = Equipmnt.genesis_Equipment_Serial_Number__c+'/'+Equipmnt.genesis_Vehicle_Chassis_Number__c+'/'+Equipmnt.genesis_Vehicle_Registration_Number__c;
            objtxttab.value =  objtxttab.value.replace('null','').removeend('//').removeend('/').removestart('//').removestart('/');
            lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Cost_of_Equipment_row'+k;
            objtxttab.value = '£ '+string.valueof(Equipmnt.Total_asset_cost__c);
            lsttxttab.add(objtxttab);
          }
        }
        else
        {
          k=0;//more than 3 equipments
          for(genesis__Application_Equipment__c Equipmnt: lstEquipmnt)
          {
            k=k+1;

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'New_UsedRow' +k;
            objtxttab.value = string.valueof(Equipmnt.New_Used__c);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Make_ModelRow' +k;
            objtxttab.value = Equipmnt.genesis_make__c+'/'+Equipmnt.genesis_Model__c;
            //if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            objtxttab.value =  objtxttab.value.replace('null','').removeend('/').removestart('/');
            lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Chassis_SerialRow' +k;
            objtxttab.value = Equipmnt.genesis_Vehicle_Chassis_Number__c+'/'+Equipmnt.genesis_Equipment_Serial_Number__c;
            objtxttab.value =  objtxttab.value.replace('null','').removeend('/').removestart('/');
            lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Eq_RegNo_Row' +k;
            objtxttab.value = Equipmnt.genesis_Vehicle_Registration_Number__c;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Date_of_Reg_Row' +k;
            objtxttab.value = Equipmnt.Year_Of_Manufature_text__c;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Net_Asset_Cost_Row' +k;
            objtxttab.value = '£ '+string.valueof(Equipmnt.genesis_Net_Asset_Cost__c);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Cost_Incl_Row' +k;
            objtxttab.value = '£ '+string.valueof(Equipmnt.Total_asset_cost__c);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Desc_of_EquipmentRow' +k;
            objtxttab.value = Equipmnt.genesis_Equipment_Description__c;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Equipment_Message';
            objtxttab.value = 'Please refer to equipment schedule';
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);

          }


        }
        objtabs.texttabs = lsttxttab;
        objsigner.tabs = objtabs;
        lstsigner.add(objsigner);
        objrecip.signers = lstsigner;
        objCustomFields.textCustomFields = lsttxtCustomFields; 
        
      }


      objtemp.recipients = objrecip;
      objtemp.customFields = objCustomFields;

      saf_docusign.cls_compositeTemplates objcomptem = new saf_docusign.cls_compositeTemplates();
      objcomptem.inlineTemplates = lstinlinetemp;
      objcomptem.serverTemplates = lsttemp;

      lstcomptemp.add(objcomptem);
    }


    saf_docusign.DocusignEnvelope obj = new saf_docusign.DocusignEnvelope();
    obj.emailSubject = envelopInfo.dsfs__DocuSign_Email_Subject__c;
    obj.emailBlurb = Label.Docusign_email_body;//'EMAIL_BODY';
    obj.Status='Created';
    obj.compositeTemplates = lstcomptemp ;
    //obj.appName = envelopInfo.dsfs__Custom_Field_1_Name__c;
    //obj.appId =  envelopInfo.dsfs__Custom_Field_1_Value__c;

    string resbody = parse(obj);
    system.debug('resbody :' + resbody);
    string strResponseUrl= 'ERROR';
      string strEnevlopeId;
      if(envelopInfo.dsfs__DocuSign_Envelope_ID__c != Null){
          strEnevlopeId = envelopInfo.dsfs__DocuSign_Envelope_ID__c;
          System.debug('already created');
          
      }
      else{
          strEnevlopeId  = Saf_DocuSign.CreateEnevelope(resbody);
          System.debug('creating new');
           
      }
    
    if(strEnevlopeId  != 'ERROR') 
    {
      strResponseUrl = Saf_DocuSign.GetEnvelopeSenderDetails(strEnevlopeId);
      SafDocusignApp(payload.genappId,strEnevlopeId);
      system.debug('SafDocusignApp:'+SafDocusignApp(payload.genappId,strEnevlopeId));
      envelopInfo.dsfs__DocuSign_Envelope_ID__c=strEnevlopeId;
      update envelopInfo;

    }

    return strResponseUrl;
  }
  public static string parse(saf_docusign.DocusignEnvelope objenevelope){
    return System.JSON.serialize(objenevelope);
  }
  public static string SafDocusignApp(string AppId,string EnvelopeId){

    List<Saf_Docusign_Application__c> lstdocapp = [select Id,name,saf_Status__c,saf_Application__c,saf_EnvelopeId__c from Saf_Docusign_Application__c where saf_Application__c =:AppId and saf_EnvelopeId__c =:EnvelopeId];
    if(lstdocapp.size() ==0)
    {
      Saf_Docusign_Application__c objdocapp = new Saf_Docusign_Application__c();
      objdocapp.saf_Application__c = AppId;
      objdocapp.saf_EnvelopeId__c = EnvelopeId;
      objdocapp.saf_Status__c = 'Created';
      insert objdocapp;
    }
    else
    {
      system.debug('lstdocapp ' +lstdocapp);
    }

    return '';
  }
}