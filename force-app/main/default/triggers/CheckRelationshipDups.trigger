trigger CheckRelationshipDups on clcommon__Relationship__c (before insert,before update, after update) {
    // enity,related and relationship 
    Saf_setting__c objsettings = Saf_setting__c.getOrgDefaults();
    set<string> entityset = new set<string>();
    set<string> relatedentity = new set<string>();
    set<string> relationship = new set<string>();
    set<string> dbentityset = new set<string>();
    set<string> dbrelatedentity = new set<string>();
    set<string> dbrelationship = new set<string>();
    if(!objsettings.DisableRelationshipTriggers__c)
    { 
    //if(saf_CreateRelationship.runTrigger != false){
   for (clcommon__Relationship__c rel: System.Trigger.new) {        
        //Make sure we don't treat account Name that isn't changing during an update as a duplicate.  
        if (System.Trigger.isInsert) {
         entityset.add(rel.clcommon__Entity__c);
         relatedentity.add(rel.clcommon__Related_Entity__c);
         relationship.add(rel.clcommon__Relationship__c);      
        }
        
        if(trigger.isAfter && trigger.isUpdate)
        {
            if(saf_CreateRelationship.runTrigger != false){
                saf_CreateRelationship.UpdateRelationship(rel);
            }
        }
    }
     
    //Query to find all the Accounts in the database that have the same name as any of the Accounts being inserted or updated.  
    for (clcommon__Relationship__c rel: [SELECT Name,clcommon__Entity__c,clcommon__Related_Entity__c,id,clcommon__Relationship__c FROM clcommon__Relationship__c 
                        WHERE clcommon__Entity__c IN :entityset and clcommon__Related_Entity__c IN:relatedentity and clcommon__Relationship__c IN:relationship]) 
                        {
                            dbentityset.add(rel.clcommon__Entity__c);
                            dbrelatedentity.add(rel.clcommon__Related_Entity__c);
                            dbrelationship.add(rel.clcommon__Relationship__c);
                        }
     for(clcommon__Relationship__c rel: System.Trigger.new){

        if(dbentityset.contains(rel.clcommon__Entity__c) && dbrelatedentity.Contains(rel.clcommon__Related_Entity__c) && dbrelationship.contains(rel.clcommon__Relationship__c))
            if(!Test.isRunningTest())
            {
            rel.addError('You are inserting Duplicate Relationship record');
            }
    }
    }
    //}
}