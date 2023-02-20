@isTest
private class Saf_ExperianTokenGenerator_Test 
{
    @isTest static void functionTest()
    {
        Saf_Experian__c objSettings = Saf_Experian__c.getOrgDefaults();
        objSettings.username__c='simplyassetuat02';
        objSettings.password__c='Loga1987!#';
        objSettings.Client_id__c='FDzlh5CGjthS9TwWc7ppLUDsmd1O0DBK';
        objSettings.Client_secret__c ='FvSyTUG69x0wylSp';
        objSettings.content_type__c ='application/json'; 
        objSettings.content_type__c = 'application/json' ;
        UPSERT objSettings;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Saf_ExperianTokenGenerator_Mock());
        String accessToken = Saf_ExperianTokenGenerator.fetchExperianAccessToken();
        Test.stopTest();
        System.assertEquals('DUMMY-ACCESSTOKEN', accessToken);
    }
}