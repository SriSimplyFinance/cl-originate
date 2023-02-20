global class OriginateCongaController
{
    static String version = '/services/Soap/u/39.0/';
    static String partnerUrl = Url.getSalesforceBaseUrl().toExternalForm()+version+UserInfo.getOrganizationId().subString(0,15); 
    
    webservice static String hpLesae(string appId)
    {
        String sessionId = UserInfo.getSessionId();
        system.debug('**sessionId**'+sessionId);
        list<MasterDocument__c> mastDocs=[select id,MasterDocumentName__c,Application__c,Application__r.genesis__Account__r.name,Application__r.genesis__CL_Product_Name__c,IsChecked__c,Name from MasterDocument__c where Application__c =:appId];
        genesis__Applications__c  appCount=[SELECT Equipment_Count__c,genesis__Account__r.name FROM genesis__Applications__c WHERE Id =:appId];
        system.debug('**appCount**'+appCount.Equipment_Count__c);
        account acc=[select name from account where id in(select genesis__account__c from genesis__Applications__c where id=:appId)];

        string appId1= mastDocs[0].Application__c;
        system.debug('**appId1**'+appId1);
        system.debug('**mastDocs**'+mastDocs);
        boolean checked=false;

        String congaUrl= Label.Conga_URL+sessionId+'&serverUrl='+partnerUrl;
        system.debug('**congaUrl**'+congaUrl);
        for(MasterDocument__c mastDoc : mastDocs)
        {   
            system.debug('**account**'+acc.name);
            system.debug('**mastDoc **'+mastDoc );
            system.debug('**mastDoc.name**'+mastDoc.name);
            if( ((mastDoc.MasterDocumentName__c == 'Lease Agreement' && mastDoc.isChecked__c == true) || (mastDoc.MasterDocumentName__c == 'HP Agreement' && mastDoc.isChecked__c == true) || (mastDoc.MasterDocumentName__c == 'Guarantee Letter' && mastDoc.isChecked__c == true)) && mastDoc.Application__r.genesis__CL_Product_Name__c != 'Sale & HP Back' )
            {
                checked = true;
                if(mastDoc.MasterDocumentName__c == 'Lease Agreement' && mastDoc.isChecked__c == true)
                {       
                                      system.debug('**mastDoc.MasterDocumentName__c **'+mastDoc.MasterDocumentName__c );
                    if(appCount.Equipment_Count__c > 3)
                    {
                        String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQL]'+Label.Application_HP_Query+',[ACQL]'+Label.Account_Contact_HP_Query+',[PSQL]'+Label.Payment_Stream_HP_Query+',[ESQ]'+Label.Equipment_condition+',[EQL]'+Label.Equipment_HP_query+',[SRQ]'+Label.Secondary_Rental_Query+',[NPL]'+Label.PS_no_of_Payments+'&TemplateId='+Label.FLO_Template+'&TemplateId='+Label.Lease_Equipment_Template;               
                        //String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQL]'+Label.Application_HP_Query+',[ACQL]'+Label.Account_Contact_HP_Query+',[PSQL]'+Label.Payment_Stream_HP_Query+',[ESQ]'+Label.Equipment_condition+',[EQL]'+Label.Equipment_HP_query+'&TemplateId='+Label.HPO_Template+','+Label.HP_Equipment_Template; 
                        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'; 
                        getCalloutToConga(finalLink1);
                    }
                    else
                    {
                        String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQL]'+Label.Application_HP_Query+',[ACQL]'+Label.Account_Contact_HP_Query+',[PSQL]'+Label.Payment_Stream_HP_Query+',[EQL]'+Label.Equipment_HP_query+',[SRQ]'+Label.Secondary_Rental_Query+',[NPL]'+Label.PS_no_of_Payments+'&TemplateId='+Label.FLO_Template;
                        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'; 
                        getCalloutToConga(finalLink1);
                    }
                
                }
                if(mastDoc.MasterDocumentName__c == 'Guarantee Letter' && mastDoc.isChecked__c == true)
                {
                    system.debug('**mastDoc.MasterDocumentName__c **'+mastDoc.MasterDocumentName__c );

                    String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[GAQ]'+Label.Guarantee_Account_query+'&TemplateId='+Label.Guarantee_CLO_Template;

                    system.debug('**finalLink **'+finalLink );
                    String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'; 
                    getCalloutToConga(finalLink1);

                }
                if(mastDoc.MasterDocumentName__c == 'HP Agreement' && mastDoc.isChecked__c == true)
                {
                    if(appCount.Equipment_Count__c > 3)
                    {
                        String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQH]'+Label.Application_HP_Query+',[ACQH]'+Label.Account_Contact_HP_Query+',[SDQ]'+Label.Security_Deposit_Query+',[OPFQ]'+Label.Option_to_Purchase_Query+',[PSQC]'+Label.Payment_Stream_HP_Query+',[ESQ]'+Label.Equipment_condition+',[EQC]'+Label.Equipment_HP_query+',[SPQ]'+Label.Secondary_Pmt_Rental_Query+'&TemplateId='+Label.HPO_Template+'&TemplateId='+Label.HP_Equipment_Template;

                        system.debug('**finalLink **'+finalLink );
                        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'; 
                        getCalloutToConga(finalLink1);

                    }
                    else{
                        system.debug('**mastDoc.MasterDocumentName__c **'+mastDoc.MasterDocumentName__c );
                        String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQH]'+Label.Application_HP_Query+',[ACQH]'+Label.Account_Contact_HP_Query+',[SDQ]'+Label.Security_Deposit_Query+',[OPFQ]'+Label.Option_to_Purchase_Query+',[PSQC]'+Label.Payment_Stream_HP_Query+',[EQC]'+Label.Equipment_HP_query+',[SPQ]'+Label.Secondary_Pmt_Rental_Query+'&TemplateId='+Label.HPO_Template;

                        system.debug('**finalLink **'+finalLink );
                        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'; 

                        // String finalLink1 = finalLink+'&SC0=1&DS7=3'; 
                        getCalloutToConga(finalLink1);
                    }
                }
            }
            else if(mastDoc.MasterDocumentName__c == 'Sale & HP Back Agreement' && mastDoc.Application__r.genesis__CL_Product_Name__c == 'Sale & HP Back' )
            {
                 if(mastDoc.isChecked__c == true)
                 {
                    checked = true;

                    if(appCount.Equipment_Count__c > 3)
                    {
                        String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQS]'+Label.Application_HP_Query+',[ACQS]'+Label.Account_Contact_HP_Query+',[PSQS]'+Label.Payment_Stream_HP_Query+',[ESQ]'+Label.Equipment_condition+',[EQS]'+Label.Equipment_HP_query+',[OPS]'+Label.Option_to_Purchase_Query+',[NPS]'+Label.Secondary_Pmt_Rental_Query+'&TemplateId='+Label.Sales_HP_Back+'&TemplateId='+Label.Equipment_SHP;
                        
                        system.debug('**finalLink **'+finalLink );
                        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'; 
                        getCalloutToConga(finalLink1);
                    
                    }
                    else{
                        
                        String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQS]'+Label.Application_HP_Query+',[ACQS]'+Label.Account_Contact_HP_Query+',[PSQS]'+Label.Payment_Stream_HP_Query+',[EQS]'+Label.Equipment_HP_query+',[OPS]'+Label.Option_to_Purchase_Query+',[NPS]'+Label.Secondary_Pmt_Rental_Query+'&TemplateId='+Label.Sales_HP_Back;
                        
                        system.debug('**finalLink **'+finalLink );
                        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'; 
                        getCalloutToConga(finalLink1);
                    
                    }
                }   
            }
        }
        if(checked == true )
        {
            return 'Document Generated Successfully';
        }
        else
        {
            return 'No Document selected ';

        }
    }
    public static String getCalloutToConga(String url) {
        system.debug('## URL ::'+url);
        // Instantiate a new http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(60000);
        // Send the request, and return a response
        try{
        HttpResponse res = h.send(req);
                   system.debug('***res'+res);
                    system.debug('***res**'+res.getBody());


           if(res.getStatusCode() != 200){
           system.debug('## status <>200'+res);
                return res.getStatus();
         } else if(!Pattern.matches('[a-zA-Z0-9]{18}',res.getBody())){
           system.debug('## status ==200'+res);
                      system.debug('## status ==200'+res);

                return res.getBody();
          }

        } catch(System.CalloutException em){
          System.debug('## Callout Error message: '+em.getMessage());
        } 
        return 'Document Created successfully!!!';
    }
    
}