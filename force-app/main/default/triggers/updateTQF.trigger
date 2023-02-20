trigger updateTQF on Termination_Quote_Figures_Header__c (after Insert) {

system.debug('Trigger--->'+Trigger.New);

    List<Termination_Quote_Figures__c> TQF = [Select Id, name from Termination_Quote_Figures__c where Termination_Quote_Header__c IN : Trigger.new];
    system.debug('TQF----->'+TQF);

}