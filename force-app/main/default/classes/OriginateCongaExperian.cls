global class OriginateCongaExperian
{
    static String version = '/services/Soap/u/39.0/';
    static String partnerUrl = Url.getSalesforceBaseUrl().toExternalForm()+version+UserInfo.getOrganizationId().subString(0,15); 
    
    webservice static String experian(string expId,String CustName)
    {
        //List<SAF_Experian_Info__c> ExpInfo = [SELECT Account__c,Id,Name,Account__r.Name FROM SAF_Experian_Info__c where Id = : expId];
        String sessionId = UserLoginSessionCtrl.getsessionId();
        system.debug('**sessionId**'+sessionId);
        system.debug('**expId**'+expId);
       boolean checked=false;
       if(expId!=Null)
       {
       checked= true;
      // CustName = CustName.replaceAll('[|,|.|//\\,||"||:|~|!|@|#|$|%|^|*|_|+|&|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"|\\\\|]', ' ');
        String congaUrl= Label.Conga_URL+sessionId+'&serverUrl='+partnerUrl;
        system.debug('**congaUrl**'+congaUrl);
        //String finalLink = congaUrl+'&Id='+expId+'&QueryId=[SAFEQ1]a9I9E00000003p9,[GE]a9I9E00000002rn,[CDH]a9I9E00000003t1,[ExperianPreviousSear]a9I9E00000003sw,[CD]a9I9E00000003t6,[ExperianScoringData]a9I9E00000003tB,[CorporateStructure]a9I9E00000003tL,[sicinfo]a9I9E00000003tQ,[scoreHistory]a9I9E00000003ta,[scoreHistoryDates]a9I9E00000003tf,[HistoricalScore]a9I9E00000003tk,[HSSameIndGroup]a9I9E00000003tp,[HSSameAssetSizeGroup]a9I9E00000003tu,[HSallScoredCompanies]a9I9E00000003tz,[FinanceAccounts]a9I9E0000008SWv,[ratios]a9I9E0000008SX0,[paymentFull]a9I9E0000008SX5,[CompanyDBTMonthly]a9I9E0000008SXA,[IndDBTMonthly]a9I9E0000008SXF,[LegalNotice]a9I9E0000008SXK,[sicinfo1980]a9I9E0000008SXP,[mortage]a9I9E0000008SXU,[sharecapital]a9I9E0000008SXZ,[shareholderdetails]a9I9E0000008SXe,[shareholdertype]a9I9E0000008SXj,[PreviousDirector]a9I9E0000008SXo,[CurrentSeceratory]a9I9E0000008SXt,[PreviousSecretary]a9I9E0000008SXy,[StatutoryDocs]a9I9E0000008SY3,[AlertNote]a9I9E0000008SY8,[cashflow]a9I9E0000008SYD,[FAProfitloss]a9I9E0000008SYI,[cifas]a9I9E0000008SYN,[CAISD]a9I9E0000004IgM,[CAISSUM]a9I9E0000004Igb,[CIFASSum]a9I9E0000004IhF,[CCJD]a9I9E0000004Iir,[IDBTLimit2]a9I9E0000004Ij1,[CDBTlimit2]a9I9E0000004Iiw&TemplateId=a9Q9E0000001x7f';               
        String childUrl= 'Experian Report -'+CustName+DateTime.now();
        childUrl = childUrl.replace(' ','+');
        system.debug('ReportName++++++++++++'+childUrl);
        String finalLink = congaUrl+'&Id='+expId+'&QueryId=[SAFEQ1]'+Label.SAFEQ1+',[GE]'+Label.GE+',[CDH]'+Label.CDH+',[ExperianPreviousSear]'+Label.ExperianPreviousSear+',[CD]'+Label.CD+',[ExperianScoringData]'+Label.ExperianScoringData+',[CorporateStructure]'+Label.CorporateStructure+',[sicinfo]'+Label.sicinfo+',[scoreHistory]'+Label.scoreHistory+',[scoreHistoryDates]'+Label.scoreHistoryDates+',[HistoricalScore]'+Label.HistoricalScore+',[HSSameIndGroup]'+Label.HSSameIndGroup+',[HSSameAssetSizeGroup]'+Label.HSSameAssetSizeGroup+',[HSallScoredCompanies]'+Label.HSallScoredCompanies+',[FinanceAccounts]'+Label.FinanceAccounts+',[ratios]'+Label.ratios+',[paymentFull]'+Label.paymentFull+',[CompanyDBTMonthly]'+Label.CompanyDBTMonthly+',[IndDBTMonthly]'+Label.IndDBTMonthly+',[LegalNotice]'+Label.LegalNotice+',[sicinfo1980]'+Label.sicinfo1980+',[mortage]'+Label.mortage+',[sharecapital]'+Label.sharecapital+',[shareholderdetails]'+Label.shareholderdetails+',[shareholdertype]'+Label.shareholdertype+',[PreviousDirector]'+Label.PreviousDirector+',[CurrentSeceratory]'+Label.CurrentSeceratory+',[PreviousSecretary]'+Label.PreviousSecretary+',[StatutoryDocs]'+Label.StatutoryDocs+',[AlertNote]'+Label.AlertNote+',[cashflow]'+Label.cashflow+',[FAProfitloss]'+Label.FAProfitloss+',[cifas]'+Label.cifas+',[CAISD]'+Label.CAISD+',[CAISSUM]'+Label.CAISSUM+',[CIFASSum]'+Label.CIFASSum+',[CCJD]'+Label.CCJD+',[IDBTLimit2]'+Label.IDBTLimit2+',[CDBTlimit2]'+Label.CDBTlimit2+'&TemplateId='+Label.TemplateId;
        //String finalLink = congaUrl+'&Id='+appId1+'&QueryId=[AQL]'+Label.Application_HP_Query+',[ACQL]'+Label.Account_Contact_HP_Query+',[PSQL]'+Label.Payment_Stream_HP_Query+',[ESQ]'+Label.Equipment_condition+',[EQL]'+Label.Equipment_HP_query+'&TemplateId='+Label.HPO_Template+','+Label.HP_Equipment_Template; 
                        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True&DefaultPDF=1'+'&OFN='+childUrl; 
                        getCalloutToConga(finalLink1);
           System.debug('link'+finalLink1);
           
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
        system.debug('## URL :'+url);
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