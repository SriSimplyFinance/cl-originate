@isTest
private class SFDCUserSessionGenerateCtrl_Test {
    @isTest static void SoapLoginCalloutTest(){
        Test.startTest();           
        Test.setMock(WebServiceMock.class, new SFDCUserSessionGenerateCtrlMock());
        SFDCUserSessionGenerateCtrl.Soap obj = new SFDCUserSessionGenerateCtrl.Soap();
        obj.login('sumit.kamra@happiestminds.com.safdev','Power@7878');
         SFDCUserSessionGenerateCtrl.GetUserInfoResult  obj2 = new SFDCUserSessionGenerateCtrl.GetUserInfoResult ();
          SFDCUserSessionGenerateCtrl.LoginResult obj3 = new SFDCUserSessionGenerateCtrl.LoginResult();
        SFDCUserSessionGenerateCtrl.LoginScopeHeader_element obj4 = new SFDCUserSessionGenerateCtrl.LoginScopeHeader_element();
        SFDCUserSessionGenerateCtrl.SessionHeader_element obj5 = new SFDCUserSessionGenerateCtrl.SessionHeader_element();
        SFDCUserSessionGenerateCtrl.CallOptions_element obj6 = new SFDCUserSessionGenerateCtrl.CallOptions_element ();
        UserLoginSessionCtrl.getsessionId();
        
        Test.stopTest();
    }       
    
     @isTest static void UserLoginSessionCtrlTest(){
        Test.startTest();           
         Test.setMock(WebServiceMock.class, new SFDCUserSessionGenerateCtrlMock());
        UserLoginSessionCtrl.getsessionId();
        
        Test.stopTest();
    }       
}