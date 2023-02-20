@isTest
public class TestimportDataFromCSVController {
    static String str = 'Contract ID,Contract Name,Next Accural Date\n null,LES-0000006198,2020-02-25';       

    public static String[] csvFileLines;
    public static Blob csvFileBody;

    static testmethod void testfileupload(){
        Test.startTest();       
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 

        ImportDataFromCSVController importData = new ImportDataFromCSVController();
        importData.csvFileBody = csvFileBody;
        importData.importCSVFile();
        importData.runBatch();
        importData.updateAccuralDates();
        Test.stopTest();
    } 

    static testmethod void testfileuploadNegative(){
        Test.startTest();       
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 

        ImportDataFromCSVController importData = new ImportDataFromCSVController();
        importData.importCSVFile();
        Test.stopTest();
    }
}