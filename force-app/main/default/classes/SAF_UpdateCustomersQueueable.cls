public class SAF_UpdateCustomersQueueable implements Queueable,Database.AllowsCallouts{
    List<String> updatedAccList;
    
     public SAF_UpdateCustomersQueueable(List<String> updatedAccList){
        this.updatedAccList = updatedAccList;
        
    }  
    public void execute(QueueableContext context){
       SAF_ContactsUtils.UpdateContacts(updatedAccList);
       }
}