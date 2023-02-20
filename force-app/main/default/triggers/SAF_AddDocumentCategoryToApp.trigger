trigger SAF_AddDocumentCategoryToApp on genesis__Applications__c (after insert,after update) 
{   
    Set<Id> appIds = new Set<Id>();
   
        List<genesis__Application_Document_Category__c> AppDocCatList = new List<genesis__Application_Document_Category__c>();
        List<genesis__Document_Category__c> docCategoryList = new List<genesis__Document_Category__c>();
        Map<String,String> docCategoryMap = new Map<String,String>();
        
        
        Map<String,genesis__Application_Document_Category__c> appDocCategoryMap = new Map<String,genesis__Application_Document_Category__c>();
        docCategoryList = [select id, genesis__Category_Name__c,genesis__Parent_Document_Category__r.genesis__Category_Name__c from genesis__Document_Category__c];
        system.debug('docCategoryList ---'+docCategoryList);
        for(genesis__Applications__c objacc: Trigger.New){
             if(objacc.id!=null){
               /*  system.debug('@@@objacc'+objacc.genesis__Description__c);
                    boolean iscreate = true;
               system.debug('Zoho customer ID@@@@'+objacc.Zoho_Customer_Id__c);
               if(objacc.Zoho_Customer_Id__c!= Null)
               {
                   iscreate = false;
               }
               
               appId.add(objacc.Id);             
               system.debug('objacc.Id: ' + objacc.Id);
              
               system.debug('*****System is future******'+System.isFuture());
               system.debug('*****System is IsBatch******'+System.IsBatch());*/
                 
                      // Saf_ZohoApplications.CreateInZoho(appId,iscreate);
                      //  break;
                 appIds.add(objacc.id);
               
                }
        }
       if (trigger.isInsert) 
        { 
        if(docCategoryList.size() > 0)
        {
            for(genesis__Applications__c App: Trigger.New)
            {
                for(genesis__Document_Category__c docCategoryRec : docCategoryList)
                {
                    if(docCategoryRec.genesis__Parent_Document_Category__r != null)
                    {
                        docCategoryMap.put(docCategoryRec.genesis__Category_Name__c,docCategoryRec.genesis__Parent_Document_Category__r.genesis__Category_Name__c); 
                    }
                    genesis__Application_Document_Category__c appDocCatRec = new genesis__Application_Document_Category__c();
                    appDocCatRec.Name = docCategoryRec.genesis__Category_Name__c;
                    appDocCatRec.genesis__Application__c = App.Id;
                    AppDocCatList.add(appDocCatRec);
                    appDocCategoryMap.put(appDocCatRec.Name,appDocCatRec);
                }
            }
            system.debug('AppDocCatList---------'+AppDocCatList);
            insert AppDocCatList;
        } 
        for(genesis__Application_Document_Category__c appDocCat: AppDocCatList)
        {
            if(docCategoryMap.containsKey(appDocCat.Name))
            {
                system.debug('Inside 2nd for loop');
                appDocCat.genesis__Parent_Application_Document_Category__c = appDocCategoryMap.get(docCategoryMap.get(appDocCat.Name)).Id;
            }
        }    
        update AppDocCatList;

        genesis__Applications__c applicationsDocCat = trigger.New.get(0);
        SAF_DisplayLinks.populateThirdpartyDocs((string) applicationsDocCat.Id);   
        /* for(genesis__Applications__c addAppId: Trigger.New)
        {
            genesis__Application_Document_Category__c addDocCatRoot = new genesis__Application_Document_Category__c();
            addDocCatRoot.genesis__Application__c = addAppId.Id;
            addDocCatRoot.Name= 'Root';

            genesis__Application_Document_Category__c addDocCatThirdParty = new genesis__Application_Document_Category__c();
            addDocCatThirdParty.genesis__Application__c = addAppId.Id;
            addDocCatThirdParty.Name = 'Third Party Documents';
            if(addDocCatThirdParty.genesis__Parent_Application_Document_Category__c != null )
            {
                addDocCatThirdParty.genesis__Parent_Application_Document_Category__r.Name='Root';
            }
            genesis__Application_Document_Category__c addDocCatApp = new genesis__Application_Document_Category__c();
            addDocCatApp.genesis__Application__c = addAppId.Id;
            addDocCatApp.Name = 'App';
            addDocCatApp.genesis__Parent_Application_Document_Category__r.Name='Third Party Documents';

            addAppDocCatList.add(addDocCatRoot);
            addAppDocCatList.add(addDocCatThirdParty);
            addAppDocCatList.add(addDocCatApp);
        } 
        insert addAppDocCatList;*/
    }
    system.debug('********firstRun: ' + HelperClass1.firstRun);
    Saf_setting__c objsetting = Saf_setting__c.getOrgDefaults();
    if (trigger.isUpdate) 
    {  
        if(HelperClass1.firstRun){
            
            //system.debug('trigger.isUpdate: ' + trigger.isUpdate);
            for(genesis__Applications__c objacc:trigger.New)
            {
                if(objacc.id!=null){
                    boolean iscreate = true;
               system.debug('Zoho customer ID@@@@'+objacc.Zoho_Customer_Id__c);
               if(objacc.Zoho_Customer_Id__c!= Null)
               {
                   iscreate = false;
               }
               List<string> appId = new List<string>();
               appId.add(objacc.Id);             
               system.debug('objacc.Id: ' + objacc.Id);
              
               system.debug('*****System is future******'+System.isFuture());
               system.debug('*****System is IsBatch******'+System.IsBatch());
               if(System.IsBatch() == false && System.isFuture() == false && objacc.genesis__Status__c != 'TRANSFERED' && objacc.genesis__Status__c != 'ACTIVATED')
                {     
                      List<Id> listStrings = new List<Id>(appIds);

                       Saf_ZohoApplications.CreateInZoho(listStrings,iscreate);
                        break;
                 
                
                }
                }
                string oldvalue = trigger.oldMap.get(objacc.Id).genesis__CL_Product__c;
                string NewValue = objacc.genesis__CL_Product__c;
                system.debug('oldvalue : ' + oldvalue);
                system.debug('NewValue : ' + NewValue);
                if(oldvalue != NewValue)
                { 
                    system.debug('objacc.Id: ' + objacc.Id);
                    CreateMasterDocsAndCreditconditions.CreateRecords(Trigger.New);                     break;
                }

            }              
            /*This creates/updates/deletes Security deposit fee when we update security deposit fee in application object.if security fee = 0 then deletes it.*/  
            string strProductId;
            for(genesis__Applications__c App: Trigger.New)
            {
                strProductId = App.genesis__CL_Product__c;
            }
            clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
            if(strProductId!=null) 
            {
                clProduct = [Select Id,clcommon__Product_Name__c,Fee_Set__c From clcommon__CL_Product__c Where Id =:strProductId];
                if (clProduct.clcommon__Product_Name__c != 'Finance Lease') 
                {  
                    system.debug('trigger.isUpdate: ' + trigger.isUpdate);
                    List<genesis__Applications__c> lstAppIds = new List<genesis__Applications__c >();
                    Set<Id> AppIds = new Set<Id>();
                    for(genesis__Applications__c objacc:trigger.New)
                    {
                        Decimal oldvalueFee = trigger.oldMap.get(objacc.Id).Security_Deposit__c;
                        Decimal NewValueFee = objacc.Security_Deposit__c;
                        System.debug('**'+objacc.genesis__Financed_Amount__c);
                        System.debug('=='+trigger.oldMap.get(objacc.Id).genesis__Financed_Amount__c);
                        system.debug('oldvalueFee : ' + oldvalueFee );
                        system.debug('NewValueFee : ' + NewValueFee );
                        if(oldvalueFee != NewValueFee)
                        {
                            lstAppIds.add(objacc);                           
                            AppIds.add(objacc.Id);
                        }

                    }           
                    system.debug('AppIds: ' + AppIds);
                    List<genesis__Fee_Schedule__c> lstFeeSchProp = [select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.Security_Deposit__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
                    where genesis__Application__c In:AppIds and genesis__Fee_Definition__c =: objsetting.Security_Fee__c];
                     System.debug('lstAppIds'+lstAppIds.size());
                    if(lstFeeSchProp.size() == 0 && lstAppIds.size() >0)
                    {
                        genesis__Fee_Schedule__c objFeeProposal = new genesis__Fee_Schedule__c();
                        objFeeProposal.genesis__Application__c= lstAppIds[0].Id; 
                        objFeeProposal.genesis__Fee_Definition__c =objsetting.Security_Fee__c;
                        //objFeeProposal.Class__c ='Income';                        
                        objFeeProposal.genesis__Number_of_Periods__c =objsetting.Security_Deposit_Period__c; 
                        objFeeProposal.genesis__Frequency__c = objsetting.Security_Deposit_Frequency__c; 
                        objFeeProposal.genesis__Start_Date__c = lstAppIds[0].genesis__Dealer_Payment_Date__c; 
                        objFeeProposal.genesis__Amount__c = lstAppIds[0].Security_Deposit__c;   
                        if(objFeeProposal.genesis__Amount__c > 0 ) {insert objFeeProposal;}
                        system.debug('objFeeProposal: ' + objFeeProposal);
                    }
                    List<genesis__Fee_Schedule__c> lstFeeSchdelete = new List<genesis__Fee_Schedule__c>(); 
                    for(genesis__Fee_Schedule__c objFeeSch:lstFeeSchProp )
                    { 
                        objFeeSch.genesis__Amount__c = objFeeSch.genesis__Application__r.Security_Deposit__c;
                        if(objFeeSch.genesis__Amount__c <=0) {lstFeeSchdelete.add(objFeeSch);} 
                        break;
                    }
                    if(lstFeeSchProp.size()>0 && lstFeeSchdelete.size() == 0 ) {  system.debug('lstFeeSchProp: ' + lstFeeSchProp); update lstFeeSchProp; }
                    if(lstFeeSchdelete.size() >0)  system.debug('lstFeeSchdelete: ' + lstFeeSchdelete); {delete lstFeeSchdelete;}
                }
            }
            /*This creates/updates/deletes OTP fee when we update OTP fee in application object.if OTP fee = 0 then deletes it.*/  
            //if (trigger.isUpdate) 
            //{  
            system.debug('trigger.isUpdate: ' + trigger.isUpdate);
            List<genesis__Applications__c> lstAppIds = new List<genesis__Applications__c >();
            Set<Id> AppIds = new Set<Id>();
            for(genesis__Applications__c objacc:trigger.New)
            {
                Decimal oldvalueFee = trigger.oldMap.get(objacc.Id).genesis_Option_to_purchase_Fee__c ;
                Decimal NewValueFee = objacc.genesis_Option_to_purchase_Fee__c ;
                system.debug('oldvalueFee : ' + oldvalueFee );
                system.debug('NewValueFee : ' + NewValueFee );
                if(oldvalueFee != NewValueFee)
                {
                    lstAppIds.add(objacc);  AppIds.add(objacc.Id);
                }

            }           
            system.debug('AppIds: ' + AppIds);
            List<genesis__Fee_Schedule__c> lstFeeSchProp = [select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.genesis_Option_to_purchase_Fee__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
            where genesis__Application__c In:AppIds and genesis__Fee_Definition__c =: objsetting.OTPFee__c];
            if(lstFeeSchProp.size() == 0 && lstAppIds.size() >0)
            {

                genesis__Fee_Schedule__c objFeeProposal = new genesis__Fee_Schedule__c();   objFeeProposal.genesis__Application__c= lstAppIds[0].Id; objFeeProposal.genesis__Fee_Definition__c =objsetting.OTPFee__c; objFeeProposal.genesis__Number_of_Periods__c =objsetting.NoOfPeriods__c; objFeeProposal.genesis__Frequency__c = objsetting.Security_Deposit_Frequency__c;   objFeeProposal.genesis__Start_Date__c = lstAppIds[0].genesis__Dealer_Payment_Date__c; objFeeProposal.genesis__Amount__c = lstAppIds[0].genesis_Option_to_purchase_Fee__c;                 if(objFeeProposal.genesis__Amount__c > 0 ) {insert objFeeProposal;}
                system.debug('objFeeProposal: ' + objFeeProposal);
            }
            List<genesis__Fee_Schedule__c> lstFeeSchdelete = new List<genesis__Fee_Schedule__c>(); 
            for(genesis__Fee_Schedule__c objFeeSch:lstFeeSchProp )
            {
                objFeeSch.genesis__Amount__c = objFeeSch.genesis__Application__r.genesis_Option_to_purchase_Fee__c;               if(objFeeSch.genesis__Amount__c <=0) {lstFeeSchdelete.add(objFeeSch);}                break;
            }
            if(lstFeeSchProp.size()>0 && lstFeeSchdelete.size() == 0 ) {  system.debug('lstFeeSchProp: ' + lstFeeSchProp); update lstFeeSchProp; }
            if(lstFeeSchdelete.size() >0)  system.debug('lstFeeSchdelete: ' + lstFeeSchdelete); {delete lstFeeSchdelete;}
            //}
            /*This creates/updates/deletes Documentation fee when we update Documentation fee in application object.if Doc fee = 0 then deletes it.*/  
            /* Added For the Ticket: #160671 - documentation fee needs to be added as per the fee set of the prodct Started */
            // if (trigger.isUpdate && clProduct.Fee_Set__c != objsetting.Feeset_HirePurchase__c)
            if (clProduct.Fee_Set__c != objsetting.Feeset_HirePurchase__c) 
            {  
                system.debug('trigger.isUpdate: ' + trigger.isUpdate);
                List<genesis__Applications__c> lstAppIdsdoc = new List<genesis__Applications__c >();
                Set<Id> AppIdsdoc = new Set<Id>();
                for(genesis__Applications__c objacc:trigger.New)
                {
                    Decimal oldvalueFee = trigger.oldMap.get(objacc.Id).Documentation_Fee__c ;
                    Decimal NewValueFee = objacc.Documentation_Fee__c ;
                    system.debug('oldvalueFee : ' + oldvalueFee );
                    system.debug('NewValueFee : ' + NewValueFee );
                    if(oldvalueFee != NewValueFee)
                    {
                        lstAppIdsdoc.add(objacc); AppIdsdoc.add(objacc.Id);
                    }
                }           
                system.debug('AppIdsdoc: ' + AppIdsdoc);
                List<genesis__Fee_Schedule__c> lstFeeSchProp1 = [select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.Documentation_Fee__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
                where genesis__Application__c In:AppIdsdoc and genesis__Fee_Definition__c =: objsetting.DcoumentFee__c];

                if(lstFeeSchProp1.size() == 0 && lstAppIdsdoc.size() >0)
                { genesis__Fee_Schedule__c objFeeProposal = new genesis__Fee_Schedule__c(); objFeeProposal.genesis__Application__c= lstAppIdsdoc[0].Id;objFeeProposal.genesis__Fee_Definition__c =objsetting.DcoumentFee__c; objFeeProposal.genesis__Number_of_Periods__c =objsetting.NoOfPeriods__c;objFeeProposal.genesis__Frequency__c = objsetting.Security_Deposit_Frequency__c; objFeeProposal.genesis__Start_Date__c = lstAppIdsdoc[0].genesis__Dealer_Payment_Date__c; objFeeProposal.genesis__Amount__c = lstAppIdsdoc[0].Documentation_Fee__c;  if(objFeeProposal.genesis__Amount__c > 0 ) {insert objFeeProposal;}
                    system.debug('objFeeProposal: ' + objFeeProposal);
                }
                List<genesis__Fee_Schedule__c> lstFeeSchdelete1 = new List<genesis__Fee_Schedule__c>(); 
                for(genesis__Fee_Schedule__c objFeeSch:lstFeeSchProp1 )
                { objFeeSch.genesis__Amount__c = objFeeSch.genesis__Application__r.Documentation_Fee__c;if(objFeeSch.genesis__Amount__c <=0) {lstFeeSchdelete1.add(objFeeSch);} break;
                }
                if(lstFeeSchProp1.size()>0 && lstFeeSchdelete1.size() == 0 ) {  system.debug('lstFeeSchProp1: ' + lstFeeSchProp1); update lstFeeSchProp1; }
                if(lstFeeSchdelete1.size() >0)  system.debug('lstFeeSchdelete1: ' + lstFeeSchdelete1); {delete lstFeeSchdelete1;}
            }
            /*****************Documentation fee (NO VAT) ************************************/
            //if (trigger.isUpdate && clProduct.Fee_Set__c!=objsetting.Feeset_Lease__c)
            if (clProduct.Fee_Set__c!=objsetting.Feeset_Lease__c)
            {  
                system.debug('trigger.isUpdate: ' + trigger.isUpdate);
                List<genesis__Applications__c> lstAppIdsdoc = new List<genesis__Applications__c >();
                Set<Id> AppIdsdoc = new Set<Id>();
                for(genesis__Applications__c objacc:trigger.New)
                {
                    Decimal oldvalueFee = trigger.oldMap.get(objacc.Id).Documentation_Fee__c ;
                    Decimal NewValueFee = objacc.Documentation_Fee__c ;
                    system.debug('oldvalueFee : ' + oldvalueFee );
                    system.debug('NewValueFee : ' + NewValueFee );
                    if(oldvalueFee != NewValueFee)
                    {
                    lstAppIdsdoc.add(objacc);   AppIdsdoc.add(objacc.Id);
                    }

                }           
                system.debug('AppIdsdoc: ' + AppIdsdoc);
                List<genesis__Fee_Schedule__c> lstFeeSchProp2= [select Id,Name,genesis__Start_Date__c,genesis__Application__c,genesis__Application__r.genesis__Dealer_Payment_Date__c,genesis__Application__r.Documentation_Fee__c,genesis__Fee_Definition__r.Name,genesis__Amount__c from genesis__Fee_Schedule__c
                where genesis__Application__c In:AppIdsdoc and genesis__Fee_Definition__c =: objsetting.Documentation_Fee_no_VAT__c];

                if(lstFeeSchProp2.size() == 0 && lstAppIdsdoc.size() >0 && lstAppIdsdoc[0].Documentation_Fee__c > 0 )
                {

                    genesis__Fee_Schedule__c objFeeProposal = new genesis__Fee_Schedule__c();  objFeeProposal.genesis__Application__c= lstAppIdsdoc[0].Id;objFeeProposal.genesis__Fee_Definition__c =objsetting.Documentation_Fee_no_VAT__c;  objFeeProposal.genesis__Number_of_Periods__c =objsetting.NoOfPeriods__c;   objFeeProposal.genesis__Frequency__c = objsetting.Security_Deposit_Frequency__c;objFeeProposal.genesis__Start_Date__c = lstAppIdsdoc[0].genesis__Dealer_Payment_Date__c;objFeeProposal.genesis__Amount__c = lstAppIdsdoc[0].Documentation_Fee__c;  if(objFeeProposal.genesis__Amount__c > 0 ) {insert objFeeProposal;}
                    system.debug('objFeeProposal: ' + objFeeProposal);
                }
                List<genesis__Fee_Schedule__c> lstFeeSchdelete2 = new List<genesis__Fee_Schedule__c>(); 
                for(genesis__Fee_Schedule__c objFeeSch:lstFeeSchProp2 )
                {
                    objFeeSch.genesis__Amount__c = objFeeSch.genesis__Application__r.Documentation_Fee__c;  if(objFeeSch.genesis__Amount__c <=0) {lstFeeSchdelete2.add(objFeeSch);} break;
                }
                if(lstFeeSchProp2.size()>0 && lstFeeSchdelete2.size() == 0) {  system.debug('lstFeeSchProp2: ' + lstFeeSchProp2); update lstFeeSchProp2; }
                if(lstFeeSchdelete2.size() >0)  system.debug('lstFeeSchdelete2: ' + lstFeeSchdelete2); {delete lstFeeSchdelete2;}
            }
            /* Added For the Ticket: #160671 - documentation fee needs to be added as per the fee set of the product Ended*/
            /*if (trigger.isUpdate) 
            { */ 
            //system.debug('trigger.isUpdate: ' + trigger.isUpdate);
            for(genesis__Applications__c paymentStream:trigger.New)
            {
                date oldvalue = trigger.oldMap.get(paymentStream.Id).genesis__Expected_Start_Date__c;
                date newValue = paymentStream.genesis__Expected_Start_Date__c;

                system.debug('oldvalue : ' + oldvalue);
                system.debug('NewValue : ' + newValue);

                if(oldvalue != NewValue)
                { 
                    system.debug('paymentStream.Id: ' + paymentStream.Id);updatePaymentStreams.updateRecords(Trigger.New);   break;
                }

                // Added for Ticket No: #159931 Security deposit for Finance lease - Starts
                decimal oldvalueFL = trigger.oldMap.get(paymentStream.Id).Security_Deposit__c;
                decimal newValueFL = paymentStream.Security_Deposit__c;

                system.debug('oldvalueFL : ' + oldvalueFL);
                system.debug('NewValueFL : ' + newValueFL);

                if(oldvalueFL != NewValueFL)
                { system.debug('paymentStream.Id: ' + paymentStream.Id); updatePaymentStreams.updateFLRecords(Trigger.New);  break;
                }
                // Added for Ticket No: #159931 Security deposit for Finance lease - Ends
                /*  //Added for SAF Display Link object Agreement no Update started
                String oldvaluelink = trigger.oldMap.get(paymentStream.Id).Agreement_No__c;
                String newValuelink = paymentStream.Agreement_No__c;

                system.debug('oldvaluelink : ' + oldvaluelink);
                system.debug('newValuelink : ' + newValuelink);

                if(oldvaluelink!= newValuelink)
                { 
                    system.debug('paymentStream.Id: ' + paymentStream.Id);
                    updatePaymentStreams.updateSaflinkRecords(Trigger.New); 
                    break;
                }
                //Added for SAF Display Link object Agreement no Update Ends */
            }
        } 
        
        
        
        HelperClass1.firstRun=false;
    }
//Added for SharePoint Proposal Description changes
    if(trigger.isInsert || trigger.isUpdate)
    {  
         
            List <SAF_Document_ChangeRequest__c> recordsToInsert = new List <SAF_Document_ChangeRequest__c>(); 
            for(genesis__Applications__c genApp:trigger.New)
            {
               if(HelperClass2.firstRun){
               List<genesis__Applications__c> AccName = [select genesis__Account__r.Name from genesis__Applications__c where id=:genApp.id];            
               system.debug('AccName+++++++++++++++++++++++++: ' + AccName);
               SAF_Document_ChangeRequest__c spdocCr = new SAF_Document_ChangeRequest__c();                 
               if(trigger.isInsert)             
                {            
                       spdocCr.SAF_Change_Type__c = 'Application_Insert_Update';
                       spdocCr.SAF_Application_Number__c = genApp.Name;
                       spdocCr.SAF_SP_Customer_Name__c = AccName[0].genesis__Account__r.Name;
                       spdocCr.Proposal_Description__c = genApp.genesis_ProposalName__c;
                       spdocCr.Balance_Finance__c = genApp.genesis__Financed_Amount__c;
                       recordsToInsert.add(spdocCr);
                }                   
               if(trigger.isUpdate)
               {  String oldProposal = trigger.oldMap.get(genApp.Id).genesis__Description__c; String newProposal = genApp.genesis__Description__c; Decimal oldFinance = trigger.oldMap.get(genApp.Id).Balance_finance_Hirepurchase__c; Decimal newFinance = genApp.Balance_finance_Hirepurchase__c; if((oldProposal != newProposal) || (oldFinance != newFinance) ) { spdocCr.SAF_Change_Type__c = 'Application_Insert_Update'; spdocCr.SAF_Application_Number__c = genApp.Name; spdocCr.SAF_SP_Customer_Name__c = AccName[0].genesis__Account__r.Name;spdocCr.Proposal_Description__c = genApp.genesis__Description__c; spdocCr.Balance_Finance__c = genApp.Balance_finance_Hirepurchase__c; recordsToInsert.add(spdocCr); }  } HelperClass2.firstRun=false;   }
        if(recordsToInsert.size()>0)
        insert recordsToInsert; 
        }  
    }  
    
    //Added for Broker app Integration
    //To send the App id details to broker app when updated in CL
    List<id> AppList = new List<id>();
     for(genesis__Applications__c App: trigger.new)   
     {
         if(genesis__Applications__c.Introducer1__c != null)
         {
             system.debug('Introducer value of app::' +genesis__Applications__c.Introducer1__c);
             if(!System.isFuture() && !System.isBatch()){
             
                 AppList.add(App.Id);
                 system.debug('Application list:' +AppList);
              }
         
         }
         if(trigger.isUpdate)
         {    
                 system.debug('list of application to update:' +AppList);
                  SAF_BrokerAppUpdate.UpdateAppId(AppList);
         }
     
     
     
     
     }         
}