public class UserLoginSessionCtrl{
    public static String getsessionId(){
        String userName = Label.SFDCUserName;
        String password = Label.SFDCPwd; 
        String endPoint;
        Organization org =[SELECT Id, IsSandbox FROM Organization Limit 1];
        if(org.IsSandbox){
            endPoint='callout:SFDCSoapURLSandBox';
        }
        else{
            endPoint='callout:SFDCSoapURLProd';  
        }
        SFDCUserSessionGenerateCtrl.Soap sfdcSession = new SFDCUserSessionGenerateCtrl.Soap();
        sfdcSession.endpoint_x=endPoint;
        SFDCUserSessionGenerateCtrl.LoginResult loginResult = sfdcSession.login(userName, password);
        system.debug('++++loginResult+++++++++'+loginResult);
        
        return loginResult == null ? null:loginResult.sessionId;
        
    }
    
}