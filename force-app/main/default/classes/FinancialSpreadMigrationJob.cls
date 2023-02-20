public inherited sharing class FinancialSpreadMigrationJob extends clcommon.BatchJob {
 
    public FinancialSpreadMigrationJob() {
        super(getJobName(), getJobQuery());
    }
     
    private static String getJobname() {
        return 'FinancialSpreadMigrationJob';
    }
 
    private static String getJobQuery() {
        return 'SELECT ID FROM clcommon__CL_Product__c LIMIT 1';
    }
     
    public override void doStart(Database.BatchableContext bc) {}
 
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
    }
     
    public override void doFinish(Database.BatchableContext bc) {
        updateTemplateAndStatementDetailVisibility();
        updateParentChildRelationshipOnTemplateDetail();
        updateParentChildRelationshipOnStatementDetail();
    }
  
    public override void submitNextJob() {}
     
    private void updateTemplateAndStatementDetailVisibility(){
        Savepoint sp = Database.setSavepoint();
        try {
            // Update template detail visibility
            List<clcommon__Template_Detail__c> templateDetailsToUpdate = [Select clcommon__Is_Visible__c
                                                                          from clcommon__Template_Detail__c
                                                                          where clcommon__Is_Visible__c=false];
             
            for(clcommon__Template_Detail__c templateDetail : templateDetailsToUpdate){
                templateDetail.clcommon__Is_Visible__c = true;
            }
             
            mfiflexUtil.SecureDML.updateRecords(templateDetailsToUpdate);
             
            // Update statement detail visibility
            List<clcommon__Statement_Detail__c> statementDetailsToUpdate = [Select Id, clcommon__Is_Visible__c,clcommon__Level__c,
                                                                            clcommon__Alias__c,clcommon__Expression__c,
                                                                            clcommon__Template_Detail__r.clcommon__Level__c,
                                                                            clcommon__Template_Detail__r.clcommon__Alias__c,
                                                                            clcommon__Template_Detail__r.clcommon__Expression__c
                                                                            from  clcommon__Statement_Detail__c
                                                                            where clcommon__Is_Visible__c=false];
             
            for(clcommon__Statement_Detail__c statementDetail : statementDetailsToUpdate){
                statementDetail.clcommon__Is_Visible__c = true;
                statementDetail.clcommon__Level__c = statementDetail.clcommon__Template_Detail__r.clcommon__Level__c;
                statementDetail.clcommon__Alias__c = statementDetail.clcommon__Template_Detail__r.clcommon__Alias__c;
                statementDetail.clcommon__Expression__c = statementDetail.clcommon__Template_Detail__r.clcommon__Expression__c;       
            }
            Update statementDetailsToUpdate;
            //SecureDML.updateRecords(statementDetailsToUpdate);
        } catch(Exception ex){
            Database.rollback(sp); 
            throw ex;
        }
    }
     
    private void updateParentChildRelationshipOnTemplateDetail() { 
        Savepoint sp = Database.setSavepoint();
        try {
            // Select all the template detail where chart of account is present
            List<clcommon__Template_Detail__c> templateDetailsToUpdate = [Select Id, Name, clcommon__Statement_Type__c, clcommon__Detail__c,clcommon__Template__c,
                                                                          clcommon__Parent_Template_Detail__c, clcommon__Has_Negative_Value__c, clcommon__Account_Type__c,
                                                                          clcommon__Chart_Of_Account__c, clcommon__Chart_Of_Account__r.clcommon__Parent_Account__c,
                                                                          clcommon__Chart_Of_Account__r.clcommon__Has_Negative_Value__c, clcommon__Chart_Of_Account__r.clcommon__Type__c
                                                                          from clcommon__Template_Detail__c
                                                                          where clcommon__Chart_Of_Account__c!=null];
             
             
            // Create map of chart of account + Statement type to template detail
            Map<string, clcommon__Template_Detail__c> coaAndTypeToTemplateDetail = new Map<string, clcommon__Template_Detail__c>();
             
            for(clcommon__Template_Detail__c templateDetail :templateDetailsToUpdate )
            {
                if(!coaAndTypeToTemplateDetail.containsKey(templateDetail.clcommon__Chart_Of_Account__c+templateDetail.clcommon__Statement_Type__c+templateDetail.clcommon__Template__c)){
                    coaAndTypeToTemplateDetail.put(templateDetail.clcommon__Chart_Of_Account__c+templateDetail.clcommon__Statement_Type__c+templateDetail.clcommon__Template__c, templateDetail);
                }
            }
             
            // Update parent template detail reference on the template detail
             
            for(clcommon__Template_Detail__c templateDetail :templateDetailsToUpdate )
            {
                if(templateDetail.clcommon__Chart_Of_Account__r.clcommon__Parent_Account__c!=null){
                    clcommon__Template_Detail__c parentTemplateDetail= coaAndTypeToTemplateDetail.get(templateDetail.clcommon__Chart_Of_Account__r.clcommon__Parent_Account__c+templateDetail.clcommon__Statement_Type__c+templateDetail.clcommon__Template__c);
                    if(parentTemplateDetail!=null){
                        templateDetail.clcommon__Parent_Template_Detail__c = parentTemplateDetail.Id;
                        templateDetail.clcommon__Has_Negative_Value__c = parentTemplateDetail.clcommon__Chart_Of_Account__r.clcommon__Has_Negative_Value__c;
                        templateDetail.clcommon__Account_Type__c =  parentTemplateDetail.clcommon__Chart_Of_Account__r.clcommon__Type__c;
                    }
                }
                else{
                    templateDetail.clcommon__Has_Negative_Value__c = templateDetail.clcommon__Chart_Of_Account__r.clcommon__Has_Negative_Value__c;
                    templateDetail.clcommon__Account_Type__c =  templateDetail.clcommon__Chart_Of_Account__r.clcommon__Type__c;
                     
                }
            }
            Update templateDetailsToUpdate;
            // SecureDML.updateRecords(templateDetailsToUpdate);
        } catch(Exception ex){
            Database.rollback(sp); 
        }
    }
     
    private void updateParentChildRelationshipOnStatementDetail() {
        Savepoint sp = Database.setSavepoint();
        try{
            // Select all the statement detail where template detail is present and not of HEADER type
            List<clcommon__Statement_Detail__c> statementDetailsToUpdate = [Select Id, Name, clcommon__Type__c,clcommon__Statement_Type__c,
                                                                            clcommon__Statement__c,clcommon__Statement__r.clcommon__Previous_Statement__c,
                                                                            clcommon__Template_Detail__c, clcommon__Template_Detail__r.clcommon__Detail__c,
                                                                            clcommon__Statement_Detail__c, clcommon__Account_Type__c,
                                                                            clcommon__Has_Negative_Value__c, clcommon__Parent_Statement_Detail__c,
                                                                            clcommon__Previous_Statement_Detail__c,
                                                                            clcommon__Chart_Of_Account__c,clcommon__Chart_Of_Account__r.clcommon__Parent_Account__c,
                                                                            clcommon__Chart_Of_Account__r.clcommon__Has_Negative_Value__c, clcommon__Chart_Of_Account__r.clcommon__Type__c
                                                                            from clcommon__Statement_Detail__c
                                                                            where clcommon__Type__c != :clcommon.QueryBuilderConstants.DetailType.HEADER.name()
                                                                            and clcommon__Template_Detail__c!=null
                                                                            and clcommon__Statement__c !=null ];
             
            // Create map of chart of account + Statement type to template detail for parent child relationship
            Map<string, clcommon__Statement_Detail__c> coaAndTypeToStatementDetail = new Map<string, clcommon__Statement_Detail__c>();
            // Create map for statement + template detail to statement detail
            Map<string, clcommon__Statement_Detail__c> stmtTemplateToStatementDetail = new Map<string, clcommon__Statement_Detail__c>();
             
            for(clcommon__Statement_Detail__c statementDetail :statementDetailsToUpdate )
            {
                if(statementDetail.clcommon__Chart_Of_Account__c!=null){
                    string detailKey = statementDetail.clcommon__Chart_Of_Account__c+statementDetail.clcommon__Statement_Type__c+statementDetail.clcommon__Statement__c;
                    if(!coaAndTypeToStatementDetail.containsKey(detailKey)){
                        coaAndTypeToStatementDetail.put(detailKey, statementDetail);
                    }
                }
                stmtTemplateToStatementDetail.put(string.valueOf(statementDetail.clcommon__Statement__c)+statementDetail.clcommon__Template_Detail__c, statementDetail);
            }
             
            // Update parent statement detail reference on the statment detail
             
            for(clcommon__Statement_Detail__c statementDetail :statementDetailsToUpdate )
            {
                if(statementDetail.clcommon__Chart_Of_Account__r.clcommon__Parent_Account__c!=null){
                    string parentDetailKey = statementDetail.clcommon__Chart_Of_Account__r.clcommon__Parent_Account__c+statementDetail.clcommon__Statement_Type__c+statementDetail.clcommon__Statement__c;
                    clcommon__Statement_Detail__c parentStatementDetail= coaAndTypeToStatementDetail.get(parentDetailKey);
                    if(parentStatementDetail!=null){
                        statementDetail.clcommon__Parent_Statement_Detail__c = parentStatementDetail.Id;
                        statementDetail.clcommon__Has_Negative_Value__c = parentStatementDetail.clcommon__Chart_Of_Account__r.clcommon__Has_Negative_Value__c;
                        statementDetail.clcommon__Account_Type__c =  parentStatementDetail.clcommon__Chart_Of_Account__r.clcommon__Type__c;
                    }
                }
                else{
                    statementDetail.clcommon__Has_Negative_Value__c = statementDetail.clcommon__Chart_Of_Account__r.clcommon__Has_Negative_Value__c;
                    statementDetail.clcommon__Account_Type__c =  statementDetail.clcommon__Chart_Of_Account__r.clcommon__Type__c;
                     
                }
                 
                if(statementDetail.clcommon__Template_Detail__r.clcommon__Detail__c!=null){
                    clcommon__Statement_Detail__c presentStatementDetail = stmtTemplateToStatementDetail.get(string.valueOf(statementDetail.clcommon__Statement__c)+statementDetail.clcommon__Template_Detail__r.clcommon__Detail__c);
                    if(presentStatementDetail!=null){
                        statementDetail.clcommon__Statement_Detail__c =  presentStatementDetail.Id;
                    }
                     
                    if(statementDetail.clcommon__Type__c.contains(clcommon.QueryBuilderConstants.DetailType.PRESENTMINUSPREV.name())&&statementDetail.clcommon__Statement__r.clcommon__Previous_Statement__c!=null){
                        clcommon__Statement_Detail__c previousStatementDetail = stmtTemplateToStatementDetail.get(string.valueOf(statementDetail.clcommon__Statement__r.clcommon__Previous_Statement__c)+statementDetail.clcommon__Template_Detail__r.clcommon__Detail__c);
                        if(previousStatementDetail!=null){
                            statementDetail.clcommon__Previous_Statement_Detail__c = previousStatementDetail.Id;
                        }
                    }
                }
            }
            Update statementDetailsToUpdate;
            //SecureDML.updateRecords(statementDetailsToUpdate);
        } catch(Exception ex){
            Database.rollback(sp);
        }
    }
}