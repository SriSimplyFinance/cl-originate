@isTest 
Private class SafExperain_Test 
{
    @isTest static void GetCreditReportTest()
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
        System.debug('objSettings1'+objSettings);
        
        Test.startTest();
        test.setMock(httpcalloutmock.class, new Saf_Experian_data_processing_Mock());
        Saf_Experain.GetCreditReport('11209193');
        Test.stopTest(); 
    }
    @isTest static void GetNLCreditReportTest()
    {
        Saf_Experian__c objSettings = Saf_Experian__c.getOrgDefaults();
        objSettings.BI_Non_Ltd_Credit_Report__c='https://uat-uk-api.experian.com/risk/business/v1/nonregisteredbusinesscredit?nonlimitedkey=CompRegNo';
        objSettings.username__c='simplyassetuat02';
        objSettings.password__c='Loga1987!#';
        objSettings.Client_id__c='FDzlh5CGjthS9TwWc7ppLUDsmd1O0DBK';
        objSettings.Client_secret__c ='FvSyTUG69x0wylSp';
        objSettings.content_type__c ='application/json'; 
        objSettings.content_type__c = 'application/json' ;
        UPSERT objSettings;
        System.debug('objSettings2'+objSettings);
        
        Test.startTest();
        test.setMock(httpcalloutmock.class, new Saf_Experian_data_processing_Mock());
        Saf_Experain.GetNLCreditReport('11209193');
        Test.stopTest();                 
    }
    @isTest static void GetCreditReport_1Test()
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
        
        Test.startTest();
        test.setMock(httpcalloutmock.class, new SafExperain_Mock());
        saf_Experain.GetCreditReport_1('11209193');
        Test.stopTest(); 
    }
    @isTest static void GetAlerts()
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
        
        Test.startTest();
        test.setMock(httpcalloutmock.class, new SafExperain_Mock());
        saf_Experain.GetAlerts('11209193');
        Test.stopTest(); 
    }
}