global class Saf_DocuSignEnevelope {

       
       Webservice static string CreateEnvelopeRequetbody(string templates, string objpartyIds, string genappId,string straccountId){ 

           String[] lstids = templates.split(':');
           Map<string,string> lstemplates = new  map<string,string>();
           for(Integer a=0;a<lstids.size();a++){
              
               string s = lstids[a];
               s = s.replace('{"','').replace('"}','').replace('"','').trim().mid(0, 36);
               system.debug('s:' + s);
               if(s.length() == 36) lstemplates.put(s,s);
              //system.debug('templates[a]:' + templates[a]);
            }
          String[] lstparties = objpartyIds.split(':');
           Map<string,string> mapParties = new  map<string,string>();
           for(Integer a=0;a<lstparties.size();a++){
              
               string s = lstparties[a];
               s = s.replace('{"','').replace('"}','').replace('"','').trim().mid(0, 18);
               system.debug('s:' + s);
               if(s.length()== 18) mapParties.put(s,s);
              //system.debug('templates[a]:' + templates[a]);
            }
         system.debug('mapParties :' + mapParties + 'genappId:' + genappId + 'lstemplates:' + lstemplates);
          
       
       Saf_Docusign__c objSettings = Saf_Docusign__c.getOrgDefaults();
       List<saf_docusign.cls_compositeTemplates> lstcomptemp = new List<saf_docusign.cls_compositeTemplates>();
         List<genesis__Payment_Stream__c> lststream = [select id, name,PaymentNo_Docusign__c,genesis__Sequence__c,genesis__Application__r.genesis__CL_Product_Name__c,No_Of_payments__c,genesis__Payment_Frequency__c,Finance_Charges__c,Sum_of_Payment_Amount__c,Payment_Amount_Inc_Vat__c,Updated_Payment_amount__c,genesis__Payment_Amount__c,Payment_Doc_Fee_Excl_Vat__c,Payment_Doc_Fee_Inc_Vat__c,
        genesis__Number_of_Payments__c from genesis__Payment_Stream__c where genesis__Application__c =: genappId order by genesis__Sequence__c];//'a7F9E0000004heVUAQ'
        
         AggregateResult[] SumofTotalPaymentamount = [select sum(Total_Payment_amount_transact__c)spay from genesis__Payment_Stream__c where genesis__Application__c =: genappId ];//'a7F9E0000004heVUAQ'
        
        //genesis__Payment_Stream__c stream = lststream[0];
        List<genesis__Applications__c> genapp = [select Name,id,genesis__Contact__r.Name,genesis__Term__c,genesis__CL_Product_Name__c,Document_Fee_Excl_Vat__c,genesis__Contact__r.Email,Balance_Financed_Conga__c,genesis__Account__r.Phone, genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.BillingAddress, Documentation_Fee__c, OTP_Fee_Calculation_Conga__c,Total_Gross_Asset_Cost__c,Total_VAT__c,Total_Net_Asset_Cost__c,genesis__Account__r.AccountNumber,Security_Deposit__c,genesis__Expected_Start_Date__c,genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingStreet,genesis__Account__r.BillingCountry,genesis_Option_to_purchase_Fee__c from genesis__Applications__c where id =: genappId];
        clcommon__Bank_Account__c BankAcc = [select id, name,clcommon__Account__c,clcommon__Account__r.Name, clcommon__Bank_Name__c,clcommon__Bank_Account_Name__c,Account_Number__c,clcommon__Routing_Number__c,clcommon__Active__c from clcommon__Bank_Account__c where clcommon__Active__c=true and clcommon__Account__c =: straccountId]; //'0019E000012MQxxQAG'
        
        //cllease__Lease_Account__c agreement = [select id, name from cllease__Lease_Account__c where Application__c =: genappId];
        List<clcommon__Party__c> lstpartycontact = [select Id,Name,genesis__Application__c,genesis__Application__r.Name,clcommon__Contact__r.Name, clcommon__Contact__r.Mailingstreet, clcommon__Contact__r.MailingCity,clcommon__Contact__r.MailingPostalCode,clcommon__Contact__r.MailingCountry, clcommon__Contact__r.SAF_OfficerId__c,clcommon__Type__c,clcommon__Type__r.Name,genesis__Party_Name__c,clcommon__Contact__r.Email,clcommon__Contact__r.MobilePhone from clcommon__Party__c where genesis__Application__c =: genappId and clcommon__Type__r.Name =: 'Guarantor' and clcommon__Contact__c != null];
       List<Account> lstparty = [Select id,name,clcommon__Email__c,AccountNumber,BillingStreet,BillingCity,BillingPostalCode,BillingCountry,Phone from Account where Id In: mapParties.keyset() or Id =:straccountId];
       
       List<clcommon__Party__c> lstsupplierparty = [select Id,Name,clcommon__Account__r.Phone,clcommon__Account__r.Name,genesis__Application__c,clcommon__Contact__r.Name, clcommon__Contact__r.Mailingstreet, clcommon__Contact__r.MailingCity,clcommon__Contact__r.MailingPostalCode,clcommon__Contact__r.MailingCountry, clcommon__Type__c,clcommon__Type__r.Name,genesis__Party_Name__c,clcommon__Contact__r.Email,clcommon__Contact__r.MobilePhone from clcommon__Party__c where genesis__Application__c =: genappId and (clcommon__Type__r.Name =: 'DEALER' OR clcommon__Type__r.Name =: 'VENDOR') and clcommon__Contact__c != null];
      
       List<genesis__Fee_Schedule__c> lstschedule = [select id, name,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c where genesis__Application__c=: genappId and genesis__Fee_Definition__r.Name =: objSettings.Saf_Docusign_SecurityFee__c];  //Security Deposit
       
       List<genesis__Fee_Schedule__c> lstdocfee_FL = [select id, name,genesis__Fee_Definition__r.Name,genesis__Amount__c,genesis__Application__r.genesis__CL_Product_Name__c from genesis__Fee_Schedule__c where genesis__Application__c=: genappId and genesis__Fee_Definition__r.Name =: objSettings.Saf_Docusign_DocFee_FL__c]; //Documentation Fee (VAT: Standard Rated)'
        List<genesis__Fee_Schedule__c> lstdocfee_HP = [select id, name,genesis__Fee_Definition__r.Name,genesis__Amount__c,genesis__Application__r.genesis__CL_Product_Name__c from genesis__Fee_Schedule__c where genesis__Application__c=: genappId and genesis__Fee_Definition__r.Name =: objSettings.Saf_Docusign_DocFee_HP__c]; //Documentation Fee (VAT Exempt)
       List<genesis__Fee_Schedule__c> lstotpfee = [select id, name,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c where genesis__Application__c=: genappId and genesis__Fee_Definition__r.Name =: objSettings.Saf_Docusign_OTPFee__c]; //Option to Purchase (VAT: Standard Rate)
       //Added by Megha Production Issue: 
       List<genesis__Payment_Stream__c> paymentno =[select id,name,PaymentNo_Docusign__c from genesis__Payment_Stream__c where genesis__Application__c =: genappId order by genesis__Sequence__c limit 1];
        
         integer a =0;
        List<genesis__Application_Equipment__c> lstEquipmnt = [select id,name,genesis_Equipment_Description__c,genesis_make__c,genesis_Model__c,New_Used__c,genesis_Equipment_Serial_Number__c,genesis_Vehicle_Chassis_Number__c,genesis_Vehicle_Registration_Number__c,Total_asset_cost__c,Year_Of_Manufature_text__c,genesis_Net_Asset_Cost__c from genesis__Application_Equipment__c where genesis__Application__c =: genappId];
       for(string strtemp: lstemplates.keyset())
       {
            saf_docusign.cls_serverTemplates objstem = new saf_docusign.cls_serverTemplates();
            List<saf_docusign.cls_serverTemplates> lsttemp = new List<saf_docusign.cls_serverTemplates>();
            
            if(!string.isblank(strtemp)) {
             a=a+1;
            system.debug('a:' +string.valueof(a)+strtemp);
            objstem.sequence=string.valueof(a);
            objstem.templateId = strtemp; //'62ab05ab-33a9-469a-87e4-e820d3c52941';
            lsttemp.add(objstem);
          }
                   
        
          saf_docusign.cls_recipients objrecip = new saf_docusign.cls_recipients ();
        
        
         saf_docusign.cls_inlineTemplates objtemp = new saf_docusign.cls_inlineTemplates();
        objtemp.sequence=string.valueof(a);
        
         List<saf_docusign.cls_inlineTemplates> lstinlinetemp= new List<saf_docusign.cls_inlineTemplates>();
        lstinlinetemp.add(objtemp);
        

        
      
        saf_docusign.cls_tabs  objtabs= new saf_docusign.cls_tabs();
        //List<saf_docusign.cls_tabs> lsttabs = new List<saf_docusign.cls_tabs>();
        //lsttabs.add(objtabs);
        
        //objsigner.cls_tabs = lsttabs; 
         saf_docusign.cls_textTabs objtxttab = new saf_docusign.cls_textTabs();
        List<saf_docusign.cls_textTabs> lsttxttab = new List<saf_docusign.cls_textTabs>();
        
          List<saf_docusign.cls_signers> lstsigner= new List<saf_docusign.cls_signers>(); 
          Integer recpientId = 0;  
          for(Account objparty: lstparty )
          {
            recpientId = recpientId +1;
             saf_docusign.cls_signers objsigner = new saf_docusign.cls_signers();
            system.debug('objparty:' + objparty);
            objsigner.email = objparty.clcommon__Email__c; // 'sumit.kamra@happiestminds.com'; 
            objsigner.name = objparty.Name; //'Sumit';
            objsigner.recipientId = string.valueof(recpientId);
            objsigner.roleName = 'Signer 1';
            
            //lstsigner.add(objsigner);
            //system.debug('lstsigner:' + lstsigner );
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Your_Name';
            objtxttab.value = objparty.Name; 
            lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Phone_Number';
            objtxttab.value =objparty.Phone;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Email_Address';
            objtxttab.value =  objparty.clcommon__Email__c;
            lsttxttab.add(objtxttab);
           
            
              //Guarantor Details
           if(lstpartycontact.size() >0)
           {  
             objtxttab = new saf_docusign.cls_textTabs();
             objtxttab.tabLabel = 'Guarantor_Name';
             objtxttab.value = lstpartycontact[0].clcommon__Contact__r.Name;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); //lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Address';
           // objtxttab.value =  lstpartycontact[0].clcommon__Contact__r.Mailingstreet+','+ lstpartycontact[0].clcommon__Contact__r.MailingCity+','+ lstpartycontact[0].clcommon__Contact__r.MailingPostalCode+','+ lstpartycontact[0].clcommon__Contact__r.MailingCountry;
           String strpartyaddress = ((lstpartycontact[0].clcommon__Contact__r.Mailingstreet!=null && lstpartycontact[0].clcommon__Contact__r.Mailingstreet!='')?lstpartycontact[0].clcommon__Contact__r.Mailingstreet : '')+
                                     ','+((lstpartycontact[0].clcommon__Contact__r.MailingCity != null && lstpartycontact[0].clcommon__Contact__r.MailingCity != '') ? lstpartycontact[0].clcommon__Contact__r.MailingCity : '') + ','
                                      + ((lstpartycontact[0].clcommon__Contact__r.MailingPostalCode != null && lstpartycontact[0].clcommon__Contact__r.MailingPostalCode != '') ? lstpartycontact[0].clcommon__Contact__r.MailingPostalCode : '');
            
            strpartyaddress = strpartyaddress.removeend(',,').removeend(',');
            strpartyaddress = strpartyaddress.removestart(',,').removestart(',');
            objtxttab.value = strpartyaddress;
            if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);
             system.debug('Guarantor_Address1:'+objtxttab);
            
           /* objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Reg_No_if_applicable';
            objtxttab.value = lstpartycontact[0].clcommon__Contact__r.SAF_OfficerId__c;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);  */
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = '\\*Full_Name';
            objtxttab.value = lstpartycontact[0].clcommon__Contact__r.Name; //genapp[0].genesis__Account__r.Name
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            
           
           
           }   
           else
           {
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Name';
            objtxttab.value = objparty.Name;
            lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Address';
           // objtxttab.value = objparty.BillingStreet+','+objparty.BillingCity+','+objparty.BillingPostalCode+','+objparty.BillingCountry;
            string strpartyaddress = ((objparty.BillingStreet != null && objparty.BillingStreet != '') ? objparty.BillingStreet:'')+','+
            ((objparty.BillingCity != null && objparty.BillingCity != '') ? objparty.BillingCity : '')+','+((objparty.BillingPostalCode != null && objparty.BillingPostalCode != '') ? objparty.BillingPostalCode : '');
            strpartyaddress = strpartyaddress.removeend(',,').removeend(',');
            strpartyaddress = strpartyaddress.removestart(',,').removestart(',');
            objtxttab.value = strpartyaddress;
            if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);
            system.debug('Guarantor_Address2:'+objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Guarantor_Reg_No_if_applicable';
            objtxttab.value = objparty.AccountNumber;
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
           
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
          
         //objtxttab = new saf_docusign.cls_textTabs();
           // objtxttab.tabLabel = 'Director_Company';
           //objtxttab.value = objparty.Name;
            //lsttxttab.add(objtxttab);
            //objtabs.texttabs = lsttxttab; 
            //objsigner.tabs = objtabs; 
            
              //Bank Account
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Bank_Name';
            objtxttab.value = BankAcc.clcommon__Bank_Name__c;
            system.debug('objtxttab:'+objtxttab);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            //lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Customer_Address';
            //objtxttab.value = genapp[0].genesis__Account__r.BillingStreet +','+ genapp[0].genesis__Account__r.BillingCity+ ',' + genapp[0].genesis__Account__r.BillingCountry;
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
            objtxttab.tabLabel = 'SortCode';
            objtxttab.value = BankAcc.clcommon__Routing_Number__c;
            lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'AccountNumber';
            objtxttab.value = BankAcc.Account_Number__c;
            lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel ='Term';
            objtxttab.value = string.valueof(genapp[0].genesis__Term__c);
            lsttxttab.add(objtxttab);
        
      
        
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = '\\*Customer_Name';
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
            
            //Guarantor details ends
        
              
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Agreement_Number';
            //objtxttab.value = agreement.Name;
            lsttxttab.add(objtxttab);
            
            objtxttab.tabLabel = 'Full_Business_Name';
            objtxttab.value = genapp[0].genesis__Account__r.Name;
            lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Business_Address';
            //objtxttab.value = genapp[0].genesis__Account__r.BillingStreet +','+ genapp[0].genesis__Account__r.BillingCity+ ','+ genapp[0].genesis__Account__r.BillingPostalCode+','+ genapp[0].genesis__Account__r.BillingCountry;
            string strbusinessaddress =  ((genapp[0].genesis__Account__r.BillingStreet != null && genapp[0].genesis__Account__r.BillingStreet != '')  ? genapp[0].genesis__Account__r.BillingStreet : '') +
             ','+ ((genapp[0].genesis__Account__r.BillingCity != null && genapp[0].genesis__Account__r.BillingCity != '') ? genapp[0].genesis__Account__r.BillingCity : '') +
             ','+ ((genapp[0].genesis__Account__r.BillingPostalCode != null && genapp[0].genesis__Account__r.BillingPostalCode != '') ? genapp[0].genesis__Account__r.BillingPostalCode : '');
            strbusinessaddress = strbusinessaddress.removeend(',,').removeend(',');
            strbusinessaddress = strbusinessaddress.removestart(',,').removestart(',');
            objtxttab.value = strbusinessaddress;
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
            
            if(lstschedule.size()>0)
            {
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Total_Deposit';
                objtxttab.value ='£ '+string.valueof(lstschedule[0].genesis__Amount__c) ;
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            }
            
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Balance_Financed';
            decimal blnce_fin = genapp[0].Total_Gross_Asset_Cost__c - ((lstschedule.size()>0)? lstschedule[0].genesis__Amount__c : 0);
            objtxttab.value = '£ '+string.valueof(blnce_fin);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            
            if(lstotpfee.size() > 0)
            {
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'OTP1';
               // objtxttab.value = string.valueof(genapp[0].OTP_Fee_Calculation_Conga__c);
                objtxttab.value ='£ '+string.valueof(lstotpfee[0].genesis__Amount__c );
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
             }
            
          /*  objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'DocFee1';
            objtxttab.value = '£ '+string.valueof(genapp[0].Documentation_Fee__c);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); */
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'DocFee_Ex_VAT';
            objtxttab.value = '£ '+string.valueof(genapp[0].Document_Fee_Excl_Vat__c);
            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            
            objtxttab = new saf_docusign.cls_textTabs();
            objtxttab.tabLabel = 'Agreement_StartDate';
            objtxttab.value = string.valueof(genapp[0].genesis__Expected_Start_Date__c);
            lsttxttab.add(objtxttab);
         
            //Doc fee for Finance lease application
            system.debug('lstdocfee_FL.size()'+lstdocfee_FL.size());
           // system.debug('Product:'+lstdocfee_FL[0].genesis__Application__r.genesis__CL_Product_Name__c);
            
                if(lstdocfee_FL.size()>0 && lstdocfee_FL[0].genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease')
                { 
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'DocFee_FL';
                    objtxttab.value = '£ '+string.valueof(lstdocfee_FL[0].genesis__Amount__c);
                    //if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    if(!objtxttab.value.contains('null')) lsttxttab.add(objtxttab);
            
                }
              
            else if(lstdocfee_HP.size() > 0)
            {
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'DocFee1';
                objtxttab.value = '£ '+string.valueof(lstdocfee_HP[0].genesis__Amount__c);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
            }
 
         Integer noofStreams = Integer.valueof(Label.Number_of_Payment);
         Integer i=0;
         system.debug('lststream.size():' +lststream.size());
        if(lststream.size() <= noofStreams)
        {
         
              for(genesis__Payment_Stream__c stream: lststream)
                {
                i=i+1;             
                system.debug('@@@@ivalue@@@@@@@@@'+i);
                
                    if(i == 1)
                    {
                     objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*First_Payment_Number';
                        objtxttab.value = '1';
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);                 
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '';
                        objtxttab.value = '£ '+string.valueof(stream.Updated_Payment_amount__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        //Hire purchase FT agreement fields
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_withDocFee_HPFT';
                        Decimal Payamt = stream.genesis__Payment_Amount__c + ((lstdocfee_HP.size() > 0) ? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(Payamt);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_withDocFee_HPFT_new';
                        Decimal Payamt1 = stream.genesis__Payment_Amount__c + ((lstdocfee_HP.size() > 0) ? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(Payamt1);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                        
                        //First_Payment_withDocFee_HPFT_new
 
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*First_Payment_Number_lease';
                        objtxttab.value = '1';
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_Ex_VAT' +i;
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        lsttxttab.add(objtxttab);
                        system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab); 
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_Inc_VAT' +i ;
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*First_Payment_Number_lease_FL';
                        objtxttab.value = '1';
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_Ex_VAT_FL' +i;
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        lsttxttab.add(objtxttab);
                        system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab); 
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_Inc_VAT_FL' +i ;
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_DocFee_Ex_VAT' ;
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Doc_Fee_Excl_Vat__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_DocFee_Inc_VAT' ;
                        Decimal Paymnt1 = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_HP.size()>0)? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(Paymnt1);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        //For Finance Lease only when security deposite is not added
                        if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && (genapp[0].Security_Deposit__c == 0 || genapp[0].Security_Deposit__c == null) && stream.PaymentNo_Docusign__c != 1)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'second_payment_docfee_FL';
                            objtxttab.value = '£ '+string.valueof(stream.Updated_Payment_amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                            system.debug('second_payment_docfee_FL:' +objtxttab);
                        
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'second_payment_docfeeVAT_FL' ;
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Doc_Fee_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('second_payment_docfeeVAT_FL:' +objtxttab);
                        }
                     
                    }
                   system.debug('*******Payment number for Docusign*****'+paymentno[0].PaymentNo_Docusign__c);
                    if(i==2 && paymentno[0].PaymentNo_Docusign__c ==1)
                    {
                    
                     system.debug('*****StreamSequenceafterif*********'+stream.genesis__Sequence__c);
                     system.debug('security deposite:'+genapp[0].Security_Deposit__c);
                    if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && (genapp[0].Security_Deposit__c == 0 ||genapp[0].Security_Deposit__c == null) )
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'second_payment_docfee_FL';
                            Decimal d = stream.genesis__Payment_Amount__c + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                            objtxttab.value = '£ '+ string.valueof(d);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                            system.debug('second_payment_docfee_FL_sequence2:' +objtxttab);
                        
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'second_payment_docfeeVAT_FL' ;
                            Decimal b = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                            objtxttab.value = '£ '+string.valueof(b);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('second_payment_docfeeVAT_FL_Sequence2:' +objtxttab);
                        }
                        if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && (genapp[0].Security_Deposit__c == 0 || genapp[0].Security_Deposit__c == null) && stream.genesis__Number_of_Payments__c > 1)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'First_Payment_Sequence_FL';
                           // Decimal f1 = stream.No_Of_payments__c-1;
                           Decimal pay = stream.genesis__Number_of_Payments__c-1; 
                            objtxttab.value = string.valueof(pay) ;
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('No of payments for FL:' +stream.genesis__Number_of_Payments__c);
                             
                                
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT_FL'; 
                            objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_FL';
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                       }
                        if((stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Hire Purchase' || stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Sale & HP Back') && stream.genesis__Number_of_Payments__c > 1)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'First_Payment_Sequence_Lease';
                             Decimal f1 = stream.genesis__Number_of_Payments__c-1;
                            objtxttab.value = string.valueof(f1) ;
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('No of payments for FL:' +stream.genesis__Number_of_Payments__c);
                            
                             objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Monthly_Payment_Ex_VAT_HPFT';
                            objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('HPFT Value:' +objtxttab);
                            
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_HPFT';
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                        
                        }
                        //For HP Agreement template when first payment is 1
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment';
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_Sequence';
                        //Decimal FPS = stream.No_Of_payments__c - 1;
                        objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c) ;
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                         
                      /*  objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*FrequencyRow' +i;
                        objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                        lsttxttab.add(objtxttab); */
                              
                       //For HPFT Template
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_withDocFee_HPFT_new';
                        Decimal Payamt = stream.genesis__Payment_Amount__c + ((lstdocfee_HP.size() > 0) ? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(Payamt);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_DocFee_Inc_VAT' ;
                        Decimal b = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_HP.size() > 0) ? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(b);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);       
                                                      
                            
                      }
                    
                   system.debug('stream.No_Of_payments__c:' +stream.No_Of_payments__c);
                   if(i == 1 && stream.No_Of_payments__c >= 1)
                    {
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_Sequence';
                        //Decimal FPS = stream.No_Of_payments__c - 1;
                        objtxttab.value = string.valueof(stream.No_Of_payments__c) ;
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                       
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment';
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                           //HP FT fields
                           
                         objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_Sequence_Lease';
                        Decimal f = stream.No_Of_payments__c-1;
                        objtxttab.value = string.valueof(f) ;
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Monthly_Payment_Ex_VAT_HPFT';
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_HPFT';
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        //For Finance lease only when security deposite is not added
                        if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && (genapp[0].Security_Deposit__c == 0 || genapp[0].Security_Deposit__c == null))
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'First_Payment_Sequence_FL';
                            Decimal f1 = stream.No_Of_payments__c-1;
                            objtxttab.value = string.valueof(f1) ;
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('No of payments for FL:' +stream.No_Of_payments__c);
                             
                                
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT_FL'; 
                            objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_FL';
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        }
                    
                   } 
                   
                 //For Finance lease application
                 system.debug('lstschedule.size() for FL:' +lstschedule.size());
                if(genapp[0].Security_Deposit__c > 0 && stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && stream.genesis__Sequence__c == 2)
                {
                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'second_payment_docfee_FL';
                    Decimal secondPay = stream.genesis__Payment_Amount__c + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                    objtxttab.value = '£ '+string.valueof(secondPay);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('second_payment_docfee_FL:' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'second_payment_docfeeVAT_FL';
                    Decimal SecPayVAT = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                    objtxttab.value = '£ '+string.valueof(SecPayVAT);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('second_payment_docfeeVAT_FL:' +objtxttab);
                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'First_Payment_Sequence_FL';
                    Decimal S = stream.genesis__Number_of_Payments__c-1;
                    objtxttab.value = string.valueof(S) ;
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT_FL';
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('Monthly_Payment_Ex_VAT_FL:' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_FL';
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('monthly_Payment_Inc_VAT_FL:' +objtxttab);
                    
                       
                }
                else if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease')
                {
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*First_Payment_Number_lease_FL'; //First_Payment_Number_lease
                    objtxttab.value = '1';
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Payment_Ex_VAT_FL' +i; //Payment_Ex_VAT
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    lsttxttab.add(objtxttab);
                    system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Payment_Inc_VAT_FL' +i ; //Payment_Inc_VAT
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                 
                }
               
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Finance_Charges';
                 decimal d = ((Decimal)(SumofTotalPaymentamount[0].get('spay'))) - blnce_fin;
                 objtxttab.value = '£ '+string.valueof(d);
                 system.debug('d (Financecharges):' +objtxttab.value);
                 if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                
                
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = '\\*Total_Amount_Payable' ;
               decimal di = (Decimal)(SumofTotalPaymentamount[0].get('spay'));
                objtxttab.value = '£ '+string.valueof(di.setscale(2,RoundingMode.CEILING));
                 system.debug('objtxttab.value(SumofTotalPaymentamount[0]):' +objtxttab.value);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = '\\*Payment_Type' +i;
                objtxttab.value = 'Direct Debit';
                lsttxttab.add(objtxttab);
                
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = '\\*FrequencyRow' +i;
                objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                lsttxttab.add(objtxttab);                
                
                //For HP  and SHPB agreement fields
                system.debug('i value:' +i);
                if(i >= 2 && paymentno[0].PaymentNo_Docusign__c ==0)
                 { 
                   //i=i-1;
                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                   
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab); 
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*PaymentRow' +i;
                    objtxttab.value = '£ '+string.valueof(stream.Updated_Payment_amount__c);
                    lsttxttab.add(objtxttab);
                    
                    system.debug('i value after:' +i);
                   
                }
                
                 /*i=i+1;
                 if( i >= 2 && stream.genesis__Sequence__c == 1 && stream.genesis__Number_of_Payments__c > 1 )
                 {
                     
                    i=i+1;
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                     system.debug('Number row:' +objtxttab);
                    
                     objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*PaymentRow' +i;
                    objtxttab.value = '£ '+string.valueof(stream.Updated_Payment_amount__c);
                    lsttxttab.add(objtxttab);
                    
                 }
                */
                
                           
                //For HP Agreement FT Financial Details
               /* objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Payment_Ex_VAT' +i;
                objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                lsttxttab.add(objtxttab);
                system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab); */
                
              /*  objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Payment_Inc_VAT' ;
                objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); */
                
              /*  objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Payment_DocFee_Ex_VAT' ;
                objtxttab.value = '£ '+string.valueof(stream.Payment_Doc_Fee_Excl_Vat__c);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);  */
                
             /*   objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Payment_DocFee_Inc_VAT' ;
                objtxttab.value = '£ '+string.valueof(stream.Payment_Doc_Fee_Inc_Vat__c);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);  */
                
                 objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT_Lease' +i;
                objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = '\\*monthly_Payment_Inc_VAT_Lease' +i ;
                objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                }
        }
        else{
                i=0;//more than 4 payment streams
              for(genesis__Payment_Stream__c stream: lststream)
                {
                i=i+1;
                    if(i == 1)
                    {
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'NT_First_Payment_Number';
                        objtxttab.value = '1';
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                       
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'NT_First_Payment_withDocFee_PT';
                        Decimal Payamt_NT = stream.genesis__Payment_Amount__c + ((lstdocfee_HP.size() > 0) ? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(Payamt_NT);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        system.debug('NT_First_Payment_withDocFee_PT'+objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*NT_Payment_Type' +i;
                        objtxttab.value = 'Direct Debit';
                        lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*NT_FrequencyRow' +i;
                        objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                        lsttxttab.add(objtxttab);
                        
                        //Hire purchase FT agreement  fields
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_withDocFee_HPFT_new';
                        Decimal Payamt = stream.genesis__Payment_Amount__c + ((lstdocfee_HP.size() > 0) ? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(Payamt);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                        
                       /* objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*First_Payment_Number';
                        objtxttab.value = '1';
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); */
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*First_Payment_Number_lease';
                        objtxttab.value = '1';
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_Ex_VAT' +i;
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        lsttxttab.add(objtxttab);
                        system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab); 
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_Inc_VAT' +i ;
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_DocFee_Ex_VAT' ;
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Doc_Fee_Excl_Vat__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Payment_DocFee_Inc_VAT' ;
                        Decimal Paymnt = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_HP.size()>0)? lstdocfee_HP[0].genesis__Amount__c : 0);
                        objtxttab.value = '£ '+string.valueof(Paymnt);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT_Lease' +i;
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        //For Finance Lease only when security deposite is not added
                      /*  if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && genapp[0].Security_Deposit__c == 0)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'second_payment_docfee_FL';
                            objtxttab.value = '£ '+string.valueof(stream.Updated_Payment_amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                        
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'second_payment_docfeeVAT_FL' ;
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Doc_Fee_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        } */
                        
                        //For Payment schedule template Finance lease when security deposite is not added
                        if(genapp[0].Security_Deposit__c == 0 || genapp[0].Security_Deposit__c == null)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_second_payment_docfee_FL2'; //second_payment_docfee_FL
                            Decimal secondPay1 = stream.genesis__Payment_Amount__c + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                            objtxttab.value = '£ '+string.valueof(secondPay1);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                        
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_second_payment_docfeeVAT_FL2' ; //second_payment_docfeeVAT_FL
                            Decimal SecPayVAT1 = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                            objtxttab.value = '£ '+string.valueof(SecPayVAT1);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                        } 
                        
                       
                    }
                    //Added by Megha 18/12/2019 - Ticket no SAFCIF-432 and 430
                    system.debug('******ivalue in new template*****'+i);
                    if(i==3 && paymentno[0].PaymentNo_Docusign__c ==1)
                    {                                        
                     system.debug('******ivalue in new template*****'+i);
                     system.debug('*****StreamSequenceafterifnew*********'+stream.genesis__Sequence__c);
                     system.debug('security deposite:'+genapp[0].Security_Deposit__c);
                    if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && (genapp[0].Security_Deposit__c == 0 ||genapp[0].Security_Deposit__c == null) )
                        {
                            system.debug('******Payment Amount value******'+stream.Updated_Payment_amount__c);
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_second_payment_docfee_FL2'; //second_payment_docfee_FL
                            Decimal secondPay1 = stream.genesis__Payment_Amount__c + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                            objtxttab.value = '£ '+string.valueof(secondPay1);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                        
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_second_payment_docfeeVAT_FL2' ; //second_payment_docfeeVAT_FL
                            Decimal SecPayVAT1 = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                            objtxttab.value = '£ '+string.valueof(SecPayVAT1);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        }
                        if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && (genapp[0].Security_Deposit__c == 0 || genapp[0].Security_Deposit__c == null) && stream.genesis__Number_of_Payments__c > 1)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_First_Payment_Sequence'; //First_Payment_Sequence_FL
                            Decimal f1 = stream.genesis__Number_of_Payments__c-1;
                            objtxttab.value = string.valueof(f1) ;
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('No of payments for FL:' +stream.genesis__Number_of_Payments__c);
                             
                                
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_Monthly_Payment_Ex_VAT2';  //Monthly_Payment_Ex_VAT_FL
                            objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_Monthly_Payment_Inc_VAT2'; //monthly_Payment_Inc_VAT_FL
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        }
                        
                      /*  objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*FrequencyRow' +i;
                        objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                        lsttxttab.add(objtxttab); */
                              
                      }
                      
                      //For HP Agreement extra template when first payment is 1 added on 20-12-19
                       if(i==2 && paymentno[0].PaymentNo_Docusign__c ==1)
                       {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'NT_First_Payment';
                            objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'NT_First_Payment_Sequence';
                            //Decimal FPS = stream.No_Of_payments__c - 1;
                            objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c) ;
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); 
                           
                         }
                      
                    system.debug('i:' +i);
                    system.debug('stream.No_Of_payments__c:' +stream.No_Of_payments__c);
 
                   if(i == 1 && stream.No_Of_payments__c >= 1)
                    {
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*NT_First_Payment_Sequence';
                        //Decimal NT_P = stream.No_Of_payments__c - 1;
                        objtxttab.value = string.valueof(stream.No_Of_payments__c) ;
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        system.debug('objtxttab.value(NT_First_Payment_Sequence):' +objtxttab);
                        
                       
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*NT_First_Payment';
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        system.debug('objtxttab.value(First_Payment):' +objtxttab.value);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*NT_Payment_Type' +i;
                        objtxttab.value = 'Direct Debit';
                        lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*NT_FrequencyRow' +i;
                        objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                        lsttxttab.add(objtxttab);
                        
                        
                        
                          //HP FT  agreement fields
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'First_Payment_Sequence_Lease';
                        Decimal f = stream.No_Of_payments__c-1;
                        objtxttab.value = string.valueof(f) ;
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Monthly_Payment_Ex_VAT_HPFT';
                        objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_HPFT';
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*monthly_Payment_Inc_VAT_Lease' +i ;
                        objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        
                        //For Finance lease only when security deposite is not added
                     /*   if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && genapp[0].Security_Deposit__c == 0)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'First_Payment_Sequence_FL';
                            Decimal f1 = stream.No_Of_payments__c-1;
                            objtxttab.value = string.valueof(f1) ;
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('No of payments for FL:' +stream.No_Of_payments__c);
                             
                                
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT_FL'; 
                            objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_FL';
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        } */
                        
                        //For new Payment schedule template for Finance lease only when security deposite is not added
                        if(genapp[0].Security_Deposit__c == 0 || genapp[0].Security_Deposit__c == null)
                        {
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_First_Payment_Sequence'; //First_Payment_Sequence_FL
                            Decimal f1 = stream.No_Of_payments__c-1;
                            objtxttab.value = string.valueof(f1) ;
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            system.debug('No of payments for FL:' +stream.No_Of_payments__c);
                             
                                
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_Monthly_Payment_Ex_VAT2';  //Monthly_Payment_Ex_VAT_FL
                            objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                            objtxttab = new saf_docusign.cls_textTabs();
                            objtxttab.tabLabel = 'Lease_Monthly_Payment_Inc_VAT2'; //monthly_Payment_Inc_VAT_FL
                            objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                            if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                            
                        }
                        
                        
                    }   
                      
                  //For Finance lease when security deposite is added    
             /*    if(genapp[0].Security_Deposit__c > 0 && stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && stream.genesis__Sequence__c == 2)
                {
                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'second_payment_docfee_FL';
                    Decimal secondPay = stream.genesis__Payment_Amount__c + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                    objtxttab.value = '£ '+string.valueof(secondPay);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('second_payment_docfee_FL:' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'second_payment_docfeeVAT_FL';
                    Decimal SecPayVAT = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                    objtxttab.value = '£ '+string.valueof(SecPayVAT);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('second_payment_docfeeVAT_FL:' +objtxttab);
                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'First_Payment_Sequence_FL';
                    Decimal S = stream.genesis__Number_of_Payments__c-1;
                    objtxttab.value = string.valueof(S) ;
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT_FL';
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('Monthly_Payment_Ex_VAT_FL:' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'monthly_Payment_Inc_VAT_FL';
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('monthly_Payment_Inc_VAT_FL:' +objtxttab);
                        
                } 
                //For finance lease when security deposite is not added
                else if(stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Finance Lease' && genapp[0].Security_Deposit__c == 0)
                {
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*First_Payment_Number_lease_FL'; //First_Payment_Number_lease
                    objtxttab.value = '1';
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Payment_Ex_VAT_FL' +i; //Payment_Ex_VAT
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    lsttxttab.add(objtxttab);
                    system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Payment_Inc_VAT_FL' +i ; //Payment_Inc_VAT
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                 
                } */
                
                //New Payment schedule for finance lease when security deposite is added
                if(genapp[0].Security_Deposit__c > 0)
                {
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Type_secRow' +i; // \\*Lease_Payment_Type
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_First_Payment_Number'; //First_Payment_Number_lease
                    objtxttab.value = '1';
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Ex_VAT' +i; //Payment_Ex_VAT
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    lsttxttab.add(objtxttab);
                    system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Inc_VAT' +i ; //Payment_Inc_VAT
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_second_payment_docfee_FL' +i; //second_payment_docfee_FL
                    Decimal secondPayNew = stream.genesis__Payment_Amount__c + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                    objtxttab.value = '£ '+string.valueof(secondPayNew);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('Second payment row new temp2:' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_second_payment_docfeeVAT_FL' +i; //second_payment_docfeeVAT_FL
                    Decimal SecPayVATNew = (stream.genesis__Payment_Amount__c * 1.2) + ((lstdocfee_FL.size()>0)? lstdocfee_FL[0].genesis__Amount__c : 0);
                    objtxttab.value = '£ '+string.valueof(SecPayVATNew);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    system.debug('Second payment row with VAT new temp2:' +objtxttab);
                    
                    if(stream.genesis__Sequence__c == 2)
                     {
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Lease_First_Payment_Sequence'; //First_Payment_Sequence_FL
                        Decimal S = stream.genesis__Number_of_Payments__c-1;
                        objtxttab.value = string.valueof(S) ;
                        if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                        system.debug('Lease_First_Payment_Sequence:' +objtxttab);
                
                     }
                    
                   
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Ex_VAT' +i; //Monthly_Payment_Ex_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Inc_VAT' +i ; //monthly_Payment_Inc_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                }
                Else if(paymentno[0].PaymentNo_Docusign__c ==0)
                {
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_First_Payment_Number'; //First_Payment_Number_lease
                    objtxttab.value = '1';
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Ex_VAT' +i; //Payment_Ex_VAT
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    lsttxttab.add(objtxttab);
                    system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Inc_VAT' +i ; //Payment_Inc_VAT
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Type_secRow' +i; // \\*Lease_Payment_Type
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                  
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                    
                    if(stream.genesis__Sequence__c >= 2)
                    { 
                        i=i-1;
                        
                    }
                    i=i+1;
                    system.debug('@@@i:'+i);  
                    
                  /*  if(paymentno[0].PaymentNo_Docusign__c ==1)
                    {
                    system.debug('@@@iinsidenewif:'+i);
                    i=i-1;
                    system.debug('@@@iinsidenewifafterdec:'+i);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Ex_VAT' +i; //Monthly_Payment_Ex_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Inc_VAT' +i ; //monthly_Payment_Inc_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    i++;
                   } */
                    
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Type_secRow' +i; // \\*Lease_Payment_Type
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Ex_VAT' +i; //Monthly_Payment_Ex_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Inc_VAT' +i ; //monthly_Payment_Inc_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Type_secRow' +i; // \\*Lease_Payment_Type
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                        
                }
                 if(paymentno[0].PaymentNo_Docusign__c ==1 && (genapp[0].Security_Deposit__c == 0 || genapp[0].Security_Deposit__c == null))
                    {
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_First_Payment_Number'; //First_Payment_Number_lease
                    objtxttab.value = '1';
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Ex_VAT' +i; //Payment_Ex_VAT
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    lsttxttab.add(objtxttab);
                    system.debug('objtxttab.value(First_Payment_Amount):' +objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Inc_VAT' +i ; //Payment_Inc_VAT
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c); 
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    
                    if(i<= stream.genesis__Sequence__c)
                    {
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*Lease_FrequencyRow' +i;
                        objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                        lsttxttab.add(objtxttab);
                        
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = '\\*Lease_Payment_Type' +i;
                        objtxttab.value = 'Direct Debit';
                        lsttxttab.add(objtxttab);                
                      
                        objtxttab = new saf_docusign.cls_textTabs();
                        objtxttab.tabLabel = 'Lease_NumberRow' +i;
                        objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                        lsttxttab.add(objtxttab);
                    }
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_Payment_Type_secRow' +i; // \\*Lease_Payment_Type
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    if(stream.genesis__Sequence__c >= 2)
                    { 
                        i=i-1;
                        
                    }
                    i=i+1;
                    system.debug('@@@i:'+i);
                    system.debug('@@@iinsidenewif:'+i);
                    i=i-1;
                    system.debug('@@@iinsidenewifafterdec:'+i);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'Lease_NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Ex_VAT' +i; //Monthly_Payment_Ex_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                                
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*Lease_Monthly_Payment_Inc_VAT' +i ; //monthly_Payment_Inc_VAT_Lease
                    objtxttab.value = '£ '+string.valueof(stream.Payment_Amount_Inc_Vat__c);
                    if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                    i++;
                   }
                
                //added by kavya 19/12/2019 for New HP Payment schedule extra template 
                if(paymentno[0].PaymentNo_Docusign__c ==0 && (stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Hire Purchase' || stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Sale & HP Back'))
                {
                     if(stream.genesis__Sequence__c >= 2)
                        { 
                            i=i+1;          
                        }
                       if(i>=2)
                       {
                           i=i-1;
                       }
                        
                    system.debug('i value for payment template:' +i);              
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*NT_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'NT_NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                    
                     objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*NT_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'NT_PaymentRow' +i;
                    objtxttab.value = '£ '+string.valueof(stream.Updated_Payment_amount__c);
                    lsttxttab.add(objtxttab);
               
                }
                
                if(paymentno[0].PaymentNo_Docusign__c ==1 && (stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Hire Purchase' || stream.genesis__Application__r.genesis__CL_Product_Name__c == 'Sale & HP Back'))
                {
                
                    system.debug('++++++ivalueforHPdoc++++++'+i);
                   if(stream.genesis__Sequence__c >= 2)
                        { 
                     
                            i= i+1;
                            
                        }
                        system.debug('++++++ivalueforHPdocafterinc++++++'+i);
                        i=i-1;
                        system.debug('++++++ivalueforHPdocafterdec++++++'+i);
                    if(i>=2)
                    { 
                    i= i-1;   
                    system.debug('i value for payment template:' +i);              
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*NT_Payment_Type' +i;
                    objtxttab.value = 'Direct Debit';
                    lsttxttab.add(objtxttab);
                    
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'NT_NumberRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Number_of_Payments__c);
                    lsttxttab.add(objtxttab);
                    
                     objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = '\\*NT_FrequencyRow' +i;
                    objtxttab.value = string.valueof(stream.genesis__Payment_Frequency__c);
                    lsttxttab.add(objtxttab);
                    
                    objtxttab = new saf_docusign.cls_textTabs();
                    objtxttab.tabLabel = 'NT_PaymentRow' +i;
                    objtxttab.value = '£ '+string.valueof(stream.Updated_Payment_amount__c);
                    lsttxttab.add(objtxttab);
                    i=i+1;
                    }
                }
                
                
                 objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Finance_Charges';
                 decimal d = ((Decimal)(SumofTotalPaymentamount[0].get('spay'))) - genapp[0].Balance_Financed_Conga__c;
                 objtxttab.value = '£ '+string.valueof(d);
                 system.debug('d (Financecharges):' +objtxttab.value);
                 if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                
                
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = '\\*Total_Amount_Payable' ;
                decimal di =(Decimal)(SumofTotalPaymentamount[0].get('spay'));
                objtxttab.value = '£ '+string.valueof(di.setscale(2,RoundingMode.CEILING));
                 system.debug('di (SumofTotalPaymentamount[0]):' +objtxttab.value);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab);
                
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Payment_Message';
                objtxttab.value = 'Please refer to payment schedule';
                lsttxttab.add(objtxttab);
                
               /* objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = '\\*Monthly_Payment_Ex_VAT';
                objtxttab.value = '£ '+string.valueof(stream.genesis__Payment_Amount__c);
                if(!string.isblank(objtxttab.value)) lsttxttab.add(objtxttab); */
                
                }
        
        }
       
        //Equipment
        Integer noofEquipments = Integer.valueof(Label.Number_of_Equipment);
         Integer k=0;
         system.debug('lstEquipmnt.size():' +lstEquipmnt.size());
        if(lstEquipmnt.size() <= noofEquipments)
        {
       
            for(genesis__Application_Equipment__c Equipmnt: lstEquipmnt)
            {
                k=k+1;
     
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Equipment_Desc_row' +k;
                objtxttab.value = Equipmnt.genesis_Equipment_Description__c +'/'+Equipmnt.genesis_make__c+'/'+Equipmnt.genesis_Model__c+'/'+string.valueof(Equipmnt.New_Used__c)+'/'+Equipmnt.Year_Of_Manufature_text__c;
                objtxttab.value =  objtxttab.value.replace('null','').removeend('////').removeend('///').removeend('//').removeend('/').removestart('////').removestart('///').removestart('//').removestart('/');
                  lsttxttab.add(objtxttab);
                
                 objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Serials _Chassis_row' +k;
                objtxttab.value = Equipmnt.genesis_Equipment_Serial_Number__c+'/'+Equipmnt.genesis_Vehicle_Chassis_Number__c+'/'+Equipmnt.genesis_Vehicle_Registration_Number__c;
                objtxttab.value =  objtxttab.value.replace('null','').removeend('//').removeend('/').removestart('//').removestart('/');
                  lsttxttab.add(objtxttab);
                
                objtxttab = new saf_docusign.cls_textTabs();
                objtxttab.tabLabel = 'Cost_of_Equipment_row' +k;
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
        
          }
        
       
            objtemp.recipients = objrecip; 
            
            saf_docusign.cls_compositeTemplates objcomptem = new saf_docusign.cls_compositeTemplates();
            objcomptem.inlineTemplates = lstinlinetemp;
            objcomptem.serverTemplates = lsttemp;
         
            lstcomptemp.add(objcomptem );
           system.debug('objcomptem::'+objcomptem.serverTemplates);
        }
        
        
        saf_docusign.DocusignEnvelope obj = new saf_docusign.DocusignEnvelope();
        obj.emailSubject = 'EMAIL_SUBJECT';
        obj.emailBlurb = Label.Docusign_email_body;//'EMAIL_BODY';
        obj.Status='Created';
        obj.compositeTemplates = lstcomptemp ;
        system.debug('obj compositeTemplates:' + obj.compositeTemplates);
        string resbody = parse(obj);
        system.debug('resbody :' + resbody);
        string strResponseUrl= 'ERROR';
       string strEnevlopeId  = Saf_DocuSign.CreateEnevelope(resbody);
        if(strEnevlopeId  != 'ERROR')
        { 
           strResponseUrl = Saf_DocuSign.GetEnvelopeSenderDetails(strEnevlopeId);
           SafDocusignApp(genappId,strEnevlopeId);
           system.debug('SafDocusignApp:'+SafDocusignApp(genappId,strEnevlopeId));
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