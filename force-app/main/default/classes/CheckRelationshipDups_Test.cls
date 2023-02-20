@isTest(SeeAllData=true)
    public class CheckRelationshipDups_Test{
          public  static clcommon__Relationship__c rel = new clcommon__Relationship__c(); 
            static testMethod void Checkreldups() {
                clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='Limited Liability Company');
                    insert legal;
                  	
                	Saf_setting__c objSettings2 = Saf_setting__c.getOrgDefaults();
                    objSettings2.DisableCustomerTriggers__c = true;    
                    UPSERT objSettings2;  
                
                     clcommon__Reciprocal_Role__c recip = new clcommon__Reciprocal_Role__c();
                     recip.Name ='UBO';
                     recip.clcommon__Inverse_Role__c = 'UBO';
                     insert recip;
                    
                	Account acc = new Account();
                    acc.clcommon__Legal_Entity_Type__c = legal.id;
                    acc.Name = 'TestAccount';
                    acc.BillingPostalCode = 'BD1 1HA';
                    acc.BillingCity = 'London';
                    acc.ShippingPostalCode = 'BD1 1HA';
                    acc.ShippingCity = 'London';
                    acc.Landline__c='12345 123456';
                    insert acc;
                    
                    Account acc1 = new Account();
                    acc1.clcommon__Legal_Entity_Type__c = legal.id;
                    acc1.Name = 'TestAccount1';
                    acc1.BillingPostalCode = 'BD1 1HA';
                    acc1.BillingCity = 'London';
                    acc1.ShippingPostalCode = 'BD1 1HA';
                    acc1.ShippingCity = 'London';
                    acc1.Landline__c='12345 123456';
                    insert acc1;
                    
                    clcommon__Relationship__c rel = new clcommon__Relationship__c();
                    rel.clcommon__Entity__c = acc.id;
                    rel.clcommon__Related_Entity__c = acc1.id;
                    rel.clcommon__Relationship__c  = recip.id;
                    insert rel;
                    
                	clcommon__Relationship__c rel1 = new clcommon__Relationship__c();       
                    rel1.clcommon__Entity__c = acc.id;
                    rel1.clcommon__Related_Entity__c = acc1.id;
                    rel1.clcommon__Relationship__c  = recip.id;
                    insert rel1;
                   
         }
     }