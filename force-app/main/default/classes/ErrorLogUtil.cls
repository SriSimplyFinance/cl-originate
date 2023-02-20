global class ErrorLogUtil {   
    private List<clcommon__Batch_Process_Log__c> errors = new List<clcommon__Batch_Process_Log__c>();       
    global ErrorLogUtil() {
    }      
    public void addError(clcommon__Batch_Process_Log__c e){ 
         errors.add(e);   
          }    
          
    public void addError(Id jobId, Id contractId, String message, Date jobRunDate) {
    
        addError(jobId, contractId, message, 'DISTRESS_MANAGEMENT', jobRunDate);   
         }    
         
    public void addError(Id jobId, Id contractId, String message, String type, Date jobRunDate) {
      clcommon__Batch_Process_Log__c clog = new clcommon__Batch_Process_Log__c();
      clog.clcommon__Batch_Job_Id__c = jobId;
      clog.clcommon__Summary_Record_Id__c = contractId;
      clog.clcommon__Timestamp__c = (jobRunDate != null ? jobRunDate : System.Now());
      clog.clcommon__Type__c = type;
      clog.clcommon__Message__c = (message != null ? message : '');
      errors.add(clog);   
       }  
       
    public void addAndCommitErrors(List<clcommon__Batch_Process_Log__c> errs){
            errors.addAll(errs); 
        commitErrors();    
        }  
    global void commitErrors() 
    {      
    try {
        if(errors.size() > 0 && Schema.sObjectType.clcommon__Batch_Process_Log__c.isCreateable()){
        
          insert errors;       
           }     
            } catch(Exception e) 
            {                
            }      errors.clear();    
            } 
            
             }