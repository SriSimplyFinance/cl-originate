@isTest
public class SumofPaymentStreamAmount_Test {

    @isTest
    public static void SumofPaymentAmount() 
    {
        genesis__Payment_Stream__c payStr = new genesis__Payment_Stream__c();
        payStr.Name = 'test';
        insert payStr;
        
    }
}