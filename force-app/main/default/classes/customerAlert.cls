//Apex Class : Created to insert / update the records into Alert objects
//Used: Alerts Visualforce Page [] used from the Account screen
//Test Class:

public with sharing class customerAlert
{

    string id = ApexPages.currentPage().getParameters().get('Id');
    public Customer_Alert__c alert
    {
        get;set;
    }
    
    public MasterAlert__c masterAlert
    {
        get;set;
    }
    
    public customerAlert()
    {
        alert = new Customer_Alert__c();
        alert.Customer__c = id;
        system.debug('********************** Params:'+ id +'*********************');
    }
    
    public pageReference currentAlerts()
    {
        //Customer_Alert__c mstrAlert = (Customer_Alert__c) stdCtrl.getRecord();
        system.debug('********************** Name:'+ alert.Id +'*********************');
        system.debug('********************** Params:'+ id +'*********************');
        masterAlert = [ Select Display_Alert_Date__c, Display_Amount__c, Display_Description__c, Display_Urgency__c From masterAlert__c Where Id = :alert.MasterAlert__c];
        return null;
    } 
    
    public PageReference save() 
    {
        Boolean isErrorFound = false;
        try
        {
            if(alert.Description__c != null)
            {
                if(alert.Description__c.length() > 255)
                {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Description should not exceed more than 255 characters')); 
                    isErrorFound = true;
                }
            }
            
            if(alert.Urgency__c != null)
            {
                if(alert.Urgency__c.length() > 255)
                {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Urgency should not exceed more than 255 characters'));
                    isErrorFound = true; 
                }
            }
            
            System.debug('-----isErrorFound -----');
            System.debug('-----isErrorFound -----' + isErrorFound );
            
            if(isErrorFound == false)
            {
                insert alert;
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
        return new PageReference('/'+id);
    }
    
    public PageReference back() 
    {
        PageReference pageRef = new PageReference('/' + id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
}