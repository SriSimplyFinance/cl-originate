Global Class ApplicationXIRRCtrl {
    
    Webservice Static String calcuateApplicationXIRR(String applicationId) {
        return AppXirrCalcUtil.xirrCalculation_1to5(applicationId);
    }
    
}