/**
*
* @Name                 : customerAlert_Test
* @Author               : Deepak - Happiest minds 
* @Description          : This test class is used to check for Customer_Alert VF page's Controller class
* @Created date         : 25-09-2018
*
**/
@isTest
public class customerAlert_Test
{
    static testMethod void customerAlert_Test() 
    {
        // Create Account
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.Name = 'TestAccount-1';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
        lessee.ShippingPostalCode = 'BD1 1HA';
        lessee.ShippingCity = 'London';
        insert lessee;
        
        MasterAlert__c masterAlert = new MasterAlert__c();
        masterAlert.Name = 'Test-MasterAlert';
        masterAlert.Display_Alert_Date__c = true;
        masterAlert.Display_Amount__c = true;
        masterAlert.Display_Description__c = true;
        masterAlert.Display_Urgency__c = true;
        masterAlert.Keydata_to_show__c = 'Urgency';
        insert masterAlert;

        Customer_Alert__c alert = new Customer_Alert__c();
        alert.Alert_Date__c = Date.newInstance(2018, 02, 01);
        alert.Amount__c = 1500; 
        alert.Customer__c = lessee.Id;
        alert.Description__c = 'Test';
        alert.MasterAlert__c = masterAlert.Id;
        alert.Urgency__c = 'High';
        //insert alert;
        //Short Text In Access web apps the Short Text field is set to store 255 characters by default, but you can adjust the Character Limit property all the way up to 4000 characters. Its SQL Server equivalent is nvarchar, with length from 1 to 4000. Learn more about data types for Access web apps.
        
        Customer_Alert__c alert1 = new Customer_Alert__c();
        alert1.Alert_Date__c = Date.newInstance(2018, 02, 01);
        alert1.Amount__c = 1500; 
        alert1.Customer__c = lessee.Id;
        alert1.Description__c = 'Short Text In Access web apps the Short Text field is set to store 255 characters by default, but you can adjust the Character Limit property all the way up to 4000 characters. Its SQL Server equivalent is nvarchar, with length from 1 to 4000. Learn more about data types for Access web apps.';
        alert1.MasterAlert__c = masterAlert.Id;
        alert1.Urgency__c = 'Short Text In Access web apps the Short Text field is set to store 255 characters by default, but you can adjust the Character Limit property all the way up to 4000 characters. Its SQL Server equivalent is nvarchar, with length from 1 to 4000. Learn more about data types for Access web apps.';
        //insert alert1;
        
        PageReference pageRef = Page.Customer_Alert;
        Test.setCurrentPage(pageRef);
        
        customerAlert controller = new customerAlert();
        
        controller.alert = alert;
        controller.masterAlert = masterAlert;
        
        String nextPage = controller.save().getUrl();
        pageReference nextPageNull = null;
        nextPageNull = controller.currentAlerts();
        nextPage = controller.save().getUrl();
        nextPage = controller.back().getUrl();
        
        customerAlert controller1 = new customerAlert();
        controller1.alert = alert1;
        controller1.masterAlert = masterAlert;
        
        pageReference nextPage1 = controller1.save();
    }

}