@isTest 
Private class SafExperainNotes_Test 
{
    @isTest static void parseNotes()
    {
        Saf_Experian__c objSettings = Saf_Experian__c.getOrgDefaults();
        objSettings.BI_Ltd_Credit_Report__c='https://uat-uk-api.experian.com/risk/business/v1/nonregisteredbusinesscredit?nonlimitedkey=CompRegNo';
        objSettings.username__c='simplyassetuat02';
        objSettings.password__c='Loga1987!#';
        objSettings.Client_id__c='FDzlh5CGjthS9TwWc7ppLUDsmd1O0DBK';
        objSettings.Client_secret__c ='FvSyTUG69x0wylSp';
        objSettings.content_type__c ='application/json'; 
        objSettings.content_type__c = 'application/json' ;
       // objSettings.BI_Non_Ltd_Credit_Report__c='https://uat-uk-api.experian.com/risk/business/v1/nonregisteredbusinesscredit?nonlimitedkey=CompRegNo';
        UPSERT objSettings;
        System.debug('objSettings3'+objSettings);
        String json= '{'+
        '    "RegNumber": "11209193",'+
        '    "CommercialName": "VATA ENVIRONMENTAL LTD",'+
        '   "CorporateStructure":'+
                                    '{'+
                          '"CompanyOwnership": {'+
                                             '"BulkShareHolders":"N",'+
                                                       '"BulkTelephone":"01159016000",'+
                                                       '"NumPrincShareHldrs":"4",'+
                                                       '"ParentDetail": {} ,'+
                                                       '"UltParentDetail":{ },'+
                                                       '"CorporateShareholder": [{}]'+                                
                                           '},'+
                          '"Subsidiaries":{'+
                                                      '"TreePosition":"1",'+
                                                      '"TotalElements":"1",'+
                                                       '"TotalSubs":"0",'+
                                                       '"TotalNumImmediateSubs":"0",'+
                                                       '"TotalNumLiveImmediateSubs":"0",'+  //0
                                                      '"TotalNumDormantImmediateSubs":"0",'+
                                                      '"TotalNumDissolvedLiquidatedImmediateSubs":"0",'+
                                                      '"TotalNumNestedSubs":"0",' +
                                                      '"TotalNumSubs":"0",'+
                                                       '"TotalNumUKSubs":"0",'+
                                                       '"TotalNumOverseasSubs":"0",' +     
                                         '"UKSubsidiaries":[{'+
                                                         '"SubRegNumber":"03457731",'+
                                                                         '"SubStatus":"D",'+
                                                                         '"SubLegalStatus":"2",'+
                                                                         '"SubName":"BOSTOCKSCOACHESLIMITED"'+
                                                            '}]'+
                                   '}'+
                '}'+
        '}';
        
        Test.startTest();
     //   test.setMock(httpcalloutmock.class, new SafExperainNotes_Mock());
        Saf_ExperainNotes.parseNotes(json);
        Saf_ExperainNotes.parse2(json);
        Test.stopTest(); 
    }
    
}