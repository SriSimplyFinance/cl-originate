@isTest
public inherited sharing class TestFinancialSpreadMigrationJob {
    @testSetup static void setup() {
        // Create financial statement template old configuration
        /*
        A1 --> ROLLUP
            B1 --> INPUT(-ve)
            A2 --> ROLLUP
                B2 --> INPUT
                B3 --> INPUT          
        */
        // create chart of accounts
        Map<String, Id> coaNameIdMap = new Map<String, Id>();
        List<clcommon__Chart_Of_Account__c> coaList = new List<clcommon__Chart_Of_Account__c>();
        coaList.add(new clcommon__Chart_Of_Account__c(Name = 'A1',clcommon__Chart_Of_Account_Code__c = '10000',
                                                      clcommon__Type__c = clcommon.QueryBuilderConstants.ChartOfAccountTypes.ASSET.name()));
        // SecureDML.insertRecords(coaList);
        insert coaList;
        coaNameIdMap.put(coaList[0].Name, coaList[0].Id);
          
        coaList = new List<clcommon__Chart_Of_Account__c>();
        coaList.add(new clcommon__Chart_Of_Account__c(Name = 'B1',clcommon__Chart_Of_Account_Code__c = '10001', clcommon__Parent_Account__c = coaNameIdMap.get('A1'),
                                                      clcommon__Type__c = clcommon.QueryBuilderConstants.ChartOfAccountTypes.ASSET.name(),
                                                      clcommon__Has_Negative_Value__c = true));
        coaList.add(new clcommon__Chart_Of_Account__c(Name = 'A2',clcommon__Chart_Of_Account_Code__c = '10002', clcommon__Parent_Account__c = coaNameIdMap.get('A1'),
                                                      clcommon__Type__c = clcommon.QueryBuilderConstants.ChartOfAccountTypes.ASSET.name()));
        // SecureDML.insertRecords(coaList);
        insert coaList;
          
        coaNameIdMap.put(coaList[0].Name, coaList[0].Id);
        coaNameIdMap.put(coaList[1].Name, coaList[1].Id);
          
        coaList = new List<clcommon__Chart_Of_Account__c>();                                
        coaList.add(new clcommon__Chart_Of_Account__c(Name = 'B2',clcommon__Chart_Of_Account_Code__c = '10003', clcommon__Parent_Account__c = coaNameIdMap.get('A2'),
                                                      clcommon__Type__c = clcommon.QueryBuilderConstants.ChartOfAccountTypes.ASSET.name()));
        coaList.add(new clcommon__Chart_Of_Account__c(Name = 'B3',clcommon__Chart_Of_Account_Code__c = '10004', clcommon__Parent_Account__c = coaNameIdMap.get('A2'),
                                                      clcommon__Type__c = clcommon.QueryBuilderConstants.ChartOfAccountTypes.ASSET.name()));                               
        // SecureDML.insertRecords(coaList);
        insert coaList;
        coaNameIdMap.put(coaList[0].Name, coaList[0].Id);
        coaNameIdMap.put(coaList[1].Name, coaList[1].Id);
          
        clcommon__Financial_Statement_Template__c header = new clcommon__Financial_Statement_Template__c(Name = 'Test Template');
        // SecureDML.insertRecords(header);
        insert header;
          
        // Intialize template details
        List<clcommon__Template_Detail__c> templateDetails = new List<clcommon__Template_Detail__c>();
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'A1 - B1',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.COMPUTE.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Expression__c = '$TotalA1 - $TOTALB1',
                                                             clcommon__Level__c = '1.1',
                                                             clcommon__Is_Visible__c=false));
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'Total A1',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.HEADER.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Level__c = '1.1',
                                                             clcommon__Is_Visible__c=false));
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'A1',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.ROLLUP.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Chart_of_Account__c = coaNameIdMap.get('A1'),
                                                             clcommon__Alias__c = 'TotalA1',
                                                             clcommon__Level__c = '1.1'));
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'B1',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.INPUT.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Chart_of_Account__c = coaNameIdMap.get('B1'),
                                                             clcommon__Alias__c = 'TotalB1',
                                                             clcommon__Level__c = '1.1'));
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'A2',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.ROLLUP.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Chart_of_Account__c = coaNameIdMap.get('A2'),
                                                             clcommon__Alias__c = 'TotalA2',
                                                             clcommon__Level__c = '1.1'));
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'B2',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.INPUT.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Chart_of_Account__c = coaNameIdMap.get('B2'),
                                                             clcommon__Alias__c = 'B2',
                                                             clcommon__Level__c = '1.1'));                                        
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'B3',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.INPUT.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Level__c = '1.1',
                                                             clcommon__Chart_of_Account__c = coaNameIdMap.get('B3')));
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'B3INCOME',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.INCOME.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.INPUT.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Level__c = '1.1',
                                                             clcommon__Chart_of_Account__c = coaNameIdMap.get('B3')));
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'B3UCA',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.INCOME.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.INPUT.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Chart_of_Account__c = coaNameIdMap.get('B3')));
        // SecureDML.insertRecords(templateDetails);
        insert templateDetails;
          
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'Copy of A1',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.INPUT.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Level__c = '1.1',
                                                             clcommon__Detail__c = templateDetails[2].Id,
                                                             clcommon__Alias__c = 'CopyOfA1'));                                       
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'Copy of A1/B2',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.COMPUTE.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Level__c = '1.1',
                                                             clcommon__Expression__c = '$CopyOfA1/$B2'));                                        
        templateDetails.add(new clcommon__Template_Detail__c(Name = 'Difference',
                                                             clcommon__Statement_Type__c = clcommon.QueryBuilderConstants.StatementType.BALANCESHEET.name(),
                                                             clcommon__Type__c = clcommon.QueryBuilderConstants.DetailType.PRESENTMINUSPREV.name(),
                                                             clcommon__Template__c = header.Id,
                                                             clcommon__Level__c = '1.1',
                                                             clcommon__Detail__c = templateDetails[0].Id));   
        // SecureDML.upsertRecords(templateDetails);
        upsert templateDetails;
          
        // Create finacial statement
        Account acc = new Account(Name = 'Acme Corp ...');
        acc.clcommon__Financial_Statement_Template__c = header.Id;
        // SecureDML.insertRecords(acc);
        insert acc;
          
        clcommon__Financial_Statement__c statement = new clcommon__Financial_Statement__c(Name = 'Year 2015',
                                                                                          clcommon__Account__c = acc.Id,
                                                                                          clcommon__Template__c = header.Id);
        // SecureDML.insertRecords(statement);
        insert statement;
              
        // Create statement detail with old template detail configuration
        List<clcommon__Statement_Detail__c> statementDetails =  new List<clcommon__Statement_Detail__c>();
        for(clcommon__Template_Detail__c templateDetail:templateDetails) {
            clcommon__Statement_Detail__c temp = new clcommon__Statement_Detail__c();
            temp.Name = templateDetail.Name;
            temp.clcommon__Template_Detail__c = templateDetail.Id;
            temp.clcommon__Statement__c = statement.Id;
            temp.clcommon__Chart_of_Account__c = templateDetail.clcommon__Chart_of_Account__c;
            temp.clcommon__Type__c = templateDetail.clcommon__Type__c;
            temp.clcommon__Statement_Type__c = templateDetail.clcommon__Statement_Type__c;
            temp.clcommon__Is_Visible__c=false;
            // set value depending on row type
            if(templateDetail.clcommon__Type__c != clcommon.QueryBuilderConstants.DetailType.HEADER.name()) {
                temp.clcommon__Input_Amount__c = 0;
                temp.clcommon__Amount__c = 0;
            }
            statementDetails.add(temp);
        }
          
        // Setup for present minus previous
        clcommon__Financial_Statement__c statement1 = new clcommon__Financial_Statement__c(Name = 'Year 2016',
                                                                       clcommon__Account__c = acc.Id,
                                                                       clcommon__Template__c = header.Id,
                                                                       clcommon__Previous_Statement__c = statement.Id);
        // SecureDML.insertRecords(statement1);
        insert statement1;
          
        for(clcommon__Template_Detail__c templateDetail:templateDetails) {
            clcommon__Statement_Detail__c temp = new clcommon__Statement_Detail__c();
            temp.Name = templateDetail.Name;
            temp.clcommon__Template_Detail__c = templateDetail.Id;
            temp.clcommon__Statement__c = statement1.Id;
            temp.clcommon__Chart_of_Account__c = templateDetail.clcommon__Chart_of_Account__c;
            temp.clcommon__Type__c = templateDetail.clcommon__Type__c;
            temp.clcommon__Statement_Type__c = templateDetail.clcommon__Statement_Type__c;
            temp.clcommon__Is_Visible__c=false;
            // set value depending on row type
            if(templateDetail.clcommon__Type__c != clcommon.QueryBuilderConstants.DetailType.HEADER.name()) {
                temp.clcommon__Input_Amount__c = 0;
                temp.clcommon__Amount__c = 0;
            }
            statementDetails.add(temp);
        }
          
        // SecureDML.insertRecords(statementDetails);
        insert statementDetails;
    }
    @isTest
    private static void testFinancialStatementUpgrade() {
        Test.startTest();
        FinancialSpreadMigrationJob fsMigrationJob = new FinancialSpreadMigrationJob();
        Database.executeBatch(fsMigrationJob, 1);
        Test.stopTest();
        // Test template detail and statement detail visibility
        List<clcommon__Template_Detail__c> visibleTemplateDetails = [Select clcommon__Is_Visible__c
                                                                      from clcommon__Template_Detail__c
                                                                      where clcommon__Is_Visible__c=true];
        System.assertEquals(12, visibleTemplateDetails.size());
          
        List<clcommon__Statement_Detail__c> visibleStatementDetails = [Select clcommon__Is_Visible__c
                                                                        from  clcommon__Statement_Detail__c
                                                                        where clcommon__Is_Visible__c=true];
        System.assertEquals(24, visibleStatementDetails.size());
          
        // Test template detail upgrade
        List<clcommon__Template_Detail__c> updatedChildTemplateDetails = [Select Id from clcommon__Template_Detail__c where clcommon__Parent_Template_Detail__c!=null];
        System.assertEquals(4, updatedChildTemplateDetails.size());
          
        // Test statment detail upgrade
        List<clcommon__Statement_Detail__c> updatedChildstatementDetails = [Select Id, Name from clcommon__Statement_Detail__c where clcommon__Parent_Statement_Detail__c!=null];
        System.assertEquals(8, updatedChildstatementDetails.size());
        List<clcommon__Statement_Detail__c> updatedPresentstatementDetails = [Select Id, Name from clcommon__Statement_Detail__c where clcommon__Statement_Detail__c!=null];
        System.assertEquals(4, updatedPresentstatementDetails.size());
        List<clcommon__Statement_Detail__c> updatedPreviousstatementDetails = [Select Id, Name from clcommon__Statement_Detail__c where clcommon__Statement_Detail__c!=null and clcommon__Previous_Statement_Detail__c!=null];
        System.assertEquals(1, updatedPreviousstatementDetails.size());
    }
}