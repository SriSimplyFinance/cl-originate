@isTest
global class SFDCUserSessionGenerateCtrlMock implements WebServiceMock{
    global void doInvoke(Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType){
                SFDCUserSessionGenerateCtrl.loginResponse_element response_x = new SFDCUserSessionGenerateCtrl.loginResponse_element();
               response.put('response_x', response_x); 
    }
}