public with sharing class editcustomerAlert {

    string id = ApexPages.currentPage().getParameters().get('Id');
    public Customer_Alert__c custAlert
    {
        get;set;
    }
    
    public editcustomerAlert(ApexPages.StandardController stdController) 
    {
        //custAlert= (Customer_Alert__c)stdController.getRecord(); //initialize the standard controller
        custAlert = [ Select Alert_Date__c, Amount__c, Customer__c, Description__c, MasterAlert__c, Urgency__c From Customer_Alert__c Where Id = :id];
        mstrAlert = [ Select Display_Alert_Date__c, Display_Amount__c, Display_Description__c, Display_Urgency__c From masterAlert__c Where Id = :custAlert.MasterAlert__c];
    }
    
    public MasterAlert__c mstrAlert
    {
        get;set;
    }
    
    public editcustomerAlert()
    {
        custAlert = new Customer_Alert__c();
        system.debug('********************** Params:'+ id +'*********************');
        custAlert = [ Select Alert_Date__c, Amount__c, Customer__c, Description__c, MasterAlert__c, Urgency__c From Customer_Alert__c Where Id = :id];
        mstrAlert = [ Select Display_Alert_Date__c, Display_Amount__c, Display_Description__c, Display_Urgency__c From masterAlert__c Where Id = :custAlert.MasterAlert__c];
    }
    
    public pageReference currentAlerts()
    {
        //Customer_Alert__c mstrAlert = (Customer_Alert__c) stdCtrl.getRecord();
        system.debug('********************** Name:'+ custAlert.Id +'*********************');
        system.debug('********************** Params:'+ id +'*********************');
        mstrAlert = [ Select Display_Alert_Date__c, Display_Amount__c, Display_Description__c, Display_Urgency__c From masterAlert__c Where Id = :custAlert.MasterAlert__c];
        return null;
    } 
    
    public PageReference save() 
    {
        try
        {
            Boolean isErrorFound = false;
            if(custAlert.Description__c != null)
            {
                if(custAlert.Description__c.length() > 255)
                {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Description should not exceed more than 255 characters')); 
                    isErrorFound = true;
                }
            }
            
            if(custAlert.Urgency__c != null)
            {
                if(custAlert.Urgency__c.length() > 255)
                {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Urgency should not exceed more than 255 characters'));
                    isErrorFound = true; 
                }
            }
            
            
            if(isErrorFound == false)
            {
                update custAlert;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Infomation Saved successfully'));
            }
            else
            {
                return null;
            }
            
        } 
        catch(Exception e) 
        {
            System.debug('-----Exception -----' + e);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'System Error : Contact System Admin')); 
        }
        return new PageReference('/'+custAlert.Customer__c);
    }
    
    public PageReference back() 
    {
        return new PageReference('/'+custAlert.Customer__c);
    }

}