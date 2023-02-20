public class SAF_CompanyRelationShipQueueable implements Queueable,Database.AllowsCallouts{
    List<String> accountNumbers;
    public SAF_CompanyRelationShipQueueable(List<String> accountNumbers){
        this.accountNumbers=accountNumbers;
    }    
    public void execute(QueueableContext context){
        SAF_CompanyRelationshipCallout.updateRelationshipDetails(accountNumbers);
    }

}