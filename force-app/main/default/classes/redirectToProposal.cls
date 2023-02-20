public class redirectToProposal
{

    public redirectToProposal(ApexPages.StandardController controller) {

    }

    public PageReference  redirect(){
    
    String p = ApexPages.currentPage().getParameters().get('id');
    String skuidonly = ApexPages.currentPage().getParameters().get('skuidonly');
 
    
            if(p != null && skuidonly == null){
                PageReference pageRef = new PageReference('/apex/genesisExtn__ApplicationDetails?id='+p+'#Proposal');
                return pageRef;
            }
            else if(p != null && skuidonly != null){
                PageReference pageRef = new PageReference('/apex/genesisExtn__ApplicationDetails?id='+p);
                return pageRef;
            }
            
            else{
                return null;
            }
    }
 }