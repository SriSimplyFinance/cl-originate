public with sharing class TerminationQuoteAction {        
    public class Equipment {
        public boolean isSelected {get; set;}        
        public cllease__Contract_Equipment__c eqp {get; set;}
        public clcommon__Equipment_Detail__c eqpDetail {get; set;}
        public Equipment(cllease__Contract_Equipment__c equip) {
            this.eqp = equip;            
            this.isSelected = this.eqp.cllease__Status__c == cllease.LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED  ? true : false;
        }
        
    }    
}