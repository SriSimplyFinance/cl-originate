/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_Payment_Stream_ProposalTrigger on Payment_Stream_Proposal__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(Payment_Stream_Proposal__c.SObjectType);
}