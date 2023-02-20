global class saf_contra {
    Public static string strterminateQotes = '';//'a6s9E000000K7NKQA0;a6s9E000000K7NFQA0;a6s9E000000K7NPQA0';
    Public static string strAgreementnames = '';
    webservice static String getTerminationqotes(string strQuoteIds)
    {
      List<string> lstres = strQuoteIds.split(';'); //appRow.SAF_Contra_TerminationQuote__c.split(";");
      //alert(res.length);
      system.debug('lstres :' + lstres);
      List<cllease__Termination_Quote_Header__c> lstquote = [SELECT NAME FROM cllease__Termination_Quote_Header__c where Id IN:lstres];
      system.debug('lstquote :' + lstquote);
      for(cllease__Termination_Quote_Header__c objQh:lstquote)
      {
       strterminateQotes += objQh.Name + ',';
      }
     return strterminateQotes;
    }
    webservice static String getAgreements(string strContractIds)
    {
      List<string> lstres = strContractIds.split(';'); //appRow.SAF_Contra_TerminationQuote__c.split(";");
      //alert(res.length);
      system.debug('lstres :' + lstres);
      List<cllease__Lease_Account__c> lstContracts = [SELECT NAME FROM cllease__Lease_Account__c where Id IN:lstres];
      system.debug('lstContracts :' + lstContracts);
      for(cllease__Lease_Account__c objCon:lstContracts)
      {
       strAgreementnames += objCon.Name + ',';
      }
     return strAgreementnames;
    }

}