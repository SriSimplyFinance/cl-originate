/**
        @ name                      : CongaDocumentController 
        @ author                    : Happiest Minds
        @ description               : This invocable class is to generate the documents based document category
        @ created date              : 20/08/2018 
        @ Modified by / Date        : 
*/

public Class CongaDocumentController1 {

    public boolean isTerm1 { get; set; }
    //public String message { get; set; }
    public String AgreementIds { get; set; }
    public list<wrapaccount> wrapaccountList { get; set; }
    public list<cllease__Termination_Quote_Header__c> a;
    public list<cllease__Termination_Quote_Header__c> selectedAccounts{get;set;}    
    public cllease__Lease_Account__c  actObj{get;set;}
    public cllease__Lease_Account__c  leaseAccnt;
    public boolean isTerm{get;set;}
    public string AgreementId1; 
     
   
    public CongaDocumentController1() {
        wrapaccountList =new list<wrapaccount>();
        list<cllease__Termination_Quote_Header__c> a= new list<cllease__Termination_Quote_Header__c>();
        selectedAccounts = new list<cllease__Termination_Quote_Header__c>();
        actObj = new cllease__Lease_Account__c();
        AgreementIds = apexpages.currentpage().getparameters().get('id');

    }
    
    string AgreementId = apexpages.currentpage().getparameters().get('id');
    static String version = '/services/Soap/u/39.0/';
    static String partnerUrl = Url.getSalesforceBaseUrl().toExternalForm()+version+UserInfo.getOrganizationId().subString(0,15);  
    
    
    Public pageReference CongaSettlementDoc1() { 
    
        system.debug('congo test'+actObj.Conga_Docs__c);
        cllease__Lease_Account__c  leaseAccnt;
        list<cllease__Termination_Quote_Header__c> childQuoteHeaders = new list<cllease__Termination_Quote_Header__c>();
        system.debug('**agreement id**'+AgreementId );
        list<cllease__Termination_Quote_Header__c > termIds=new list<cllease__Termination_Quote_Header__c >();
        AgreementId1 =AgreementId ;
        if(AgreementId != null)
            {
            leaseAccnt = [SELECT name,Conga_Docs__c,cllease__CL_Product__r.name,cllease__Lease_Product_Name__r.name,cllease__Account__r.name,cllease__Account__r.BillingPostalCode,cllease__Account__r.BillingStreet,cllease__Account__r.BillingCity,cllease__Account__r.BillingState,cllease__Account__r.BillingCountry,(select cllease__Equipment_Description__c from cllease__Contract_Equipments__r),(select cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__r where cllease__Full_Termination__c = false) FROM cllease__Lease_Account__c where id=:AgreementId ];    
             
        }
     
             String sessionId = UserInfo.getSessionId();
             system.debug('**sessionId**'+sessionId);
             list<cllease__Termination_Quote_Header__c>  trmqt =[select id,cllease__Full_Termination__c from cllease__Termination_Quote_Header__c where cllease__Contract__c =:AgreementId and cllease__Full_Termination__c = true ]; 
       if(trmqt.size() > 0 )
       {
            isTerm = true;
            system.debug('***isTerm **'+isTerm )  ; 
        
            if(actObj.Conga_Docs__c == 'Full Settlement Quote' && leaseAccnt.cllease__Lease_Product_Name__r.name == 'Hire Purchase')
            {
                system.debug('**Conga_Docs__c **'+actObj.Conga_Docs__c );
                String congaUrl= Label.Conga_URL+sessionId+'&serverUrl='+partnerUrl+'&DS7=1';
                system.debug('**congaUrl**'+congaUrl);
                String finalLink = congaUrl+'&Id='+AgreementId+'&QueryId=[ContractQuery]'+Label.Contract_Query+',[ACQ]'+Label.Account_Contact_Query+'&TemplateId='+Label.Contract_Template;
                system.debug('**finalLink **'+finalLink );
                String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True'; 
                getCalloutToConga(finalLink1);
            
            }
            if(actObj.Conga_Docs__c == 'Full Settlement Quote' && leaseAccnt.cllease__Lease_Product_Name__r.name == 'Finance Lease')
            {
                system.debug('**Conga_Docs__c **'+actObj.Conga_Docs__c );
                String congaUrl= Label.Conga_URL+sessionId+'&serverUrl='+partnerUrl+'&DS7=1';
                system.debug('**congaUrl**'+congaUrl);
                String finalLink = congaUrl+'&Id='+AgreementId+'&QueryId=[ContractQuery]'+Label.Contract_Query+',[ACQ]'+Label.Account_Contact_Query+'&TemplateId='+Label.Lease_Settlement_Template;
                system.debug('**finalLink **'+finalLink );
                String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True'; 
                getCalloutToConga(finalLink1);
            
            }
       }
       
    
        for(cllease__Termination_Quote_Header__c trmqote:leaseAccnt.cllease__Termination_Quote_Header__r)
        {
            termIds.add(trmqote);
        }
        system.debug('**termIds**'+termIds);
   
   
        if((termIds.size()>0 || actObj.Conga_Docs__c == 'Reschedule Letter') && actObj.Conga_Docs__c != 'Full Settlement Quote')
        {
       
         isTerm = true;
         system.debug('***isTerm **'+isTerm )  ; 
         
             if(actObj.Conga_Docs__c == 'Part Settlement Quote' && leaseAccnt.cllease__Lease_Product_Name__r.name == 'Hire Purchase')
            {
                string congaDoc =string.valueOf(actObj.Conga_Docs__c);
                for(wrapaccount wrapobj:wrapaccountlist){
                    if(wrapobj.isSelected==true){
                    selectedAccounts.add(wrapobj.accn);
                    }
                    
                }
                selectedAccounts[0].isChecked__c = true;
                update selectedAccounts;
                system.debug('**selectedAccounts**'+selectedAccounts);
                string termId=selectedAccounts[0].id;
                system.debug('**termId**'+termId );
                String sessionId1 = UserInfo.getSessionId();
                system.debug('**sessionId1**'+sessionId1);
                list<cllease__Termination_Quote_Header__c> selectedRecords = new list<cllease__Termination_Quote_Header__c>();
                list<cllease__Termination_Quote_Header__c> selectedAccount = [select id,isChecked__c from cllease__Termination_Quote_Header__c where cllease__Contract__c =:AgreementId ];
                for(cllease__Termination_Quote_Header__c termQote:selectedAccount )
                {
                if(termQote.id != termId)
                {
                    termQote.isChecked__c = false;
                    selectedRecords.add(termQote);
                }
                }
            update selectedRecords;
            system.debug('**selectedRecords**'+selectedRecords);

            PartSettlementDoc(congaDoc,termId,AgreementId1,sessionId1);
            }
            if(actObj.Conga_Docs__c == 'Reschedule Letter' && (leaseAccnt.cllease__Lease_Product_Name__r.name == 'Finance Lease' || leaseAccnt.cllease__Lease_Product_Name__r.name == 'Hire Purchase') )
            {
             
            system.debug('**Conga_Docs__c **'+actObj.Conga_Docs__c );
            String congaUrl= Label.Conga_URL+sessionId+'&serverUrl='+partnerUrl+'&DS7=1';
            system.debug('**congaUrl**'+congaUrl);
            String finalLink = congaUrl+'&Id='+AgreementId+'&QueryId=[AGQ]'+Label.Agreement_Query+'&TemplateId='+Label.Agreement_Template;
            system.debug('**finalLink **'+finalLink );
            String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True'; 
            getCalloutToConga(finalLink1);
            
            }
        
        }
        else 
        {
            if(actObj.Conga_Docs__c != 'Full Settlement Quote')
            {
            isTerm = false;
                 system.debug('***isTerm **'+isTerm )  ; 
            }
            else
            {
                if(trmqt.size() > 0)
                {
                    isTerm = true;
                }
                else
                {
                isTerm = false;
                
                }
            }
        }
       
    return null;
    }
    @Future(callout=true)
    public static void PartSettlementDoc(string congaDoc,string termId,string agrId,string session){
 
        String congaUrl= Label.Conga_URL+session+'&serverUrl='+partnerUrl+'&DS7=1';
        system.debug('**congaUrl**'+congaUrl);
        String finalLink = congaUrl+'&Id='+agrId+'&QueryId=[PSQ]'+Label.Part_Settlement_Query+',[ACQ]'+Label.Account_Contact_Query
        +'&TemplateId='+Label.Part_Settlement_Template;
        system.debug('**finalLink **'+finalLink );
        String finalLink1 = finalLink+'&SC0=1&SC1=Attachments&UF0=1&MFTS0=Dcoument_Generated__c&MFTSValue0=True'; 
        getCalloutToConga(finalLink1);
     
    }
    public static String getCalloutToConga(String url) {
        system.debug('## URL ::'+url);
        // Instantiate a new http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(60000);
        // Send the request, and return a response
        try{
        HttpResponse res = h.send(req);
                   system.debug('***res'+res);
                    system.debug('***res**'+res.getBody());


            if(res.getStatusCode() != 200){
                system.debug('## status <>200'+res);
                return res.getStatus();
            }else if(!Pattern.matches('[a-zA-Z0-9]{18}',res.getBody())){
                system.debug('## status ==200'+res);
                system.debug('## status ==200'+res);

                return res.getBody();
            }

        } catch(System.CalloutException em){
            System.debug('## Callout Error message: '+em.getMessage());
        } 
        return 'Document Created successfully!!!';
    }
    public pageReference ProcessSelected(){
        cllease__Lease_Account__c  leaseAccnt;
        list<cllease__Termination_Quote_Header__c> childQuoteHeaders = new list<cllease__Termination_Quote_Header__c>();
        system.debug('**agreement id**'+AgreementId );
        
        if(AgreementId != null)
        {
            leaseAccnt = [SELECT name,cllease__CL_Product__r.name,cllease__Lease_Product_Name__r.name,cllease__Account__r.name,cllease__Account__r.BillingPostalCode,cllease__Account__r.BillingStreet,cllease__Account__r.BillingCity,cllease__Account__r.BillingState,cllease__Account__r.BillingCountry,(select cllease__Equipment_Description__c from cllease__Contract_Equipments__r),(select cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__r) FROM cllease__Lease_Account__c where id=:AgreementId ];
             
        }
        system.debug('**leaseAccnt**'+leaseAccnt);
        system.debug('**leaseAccnt**'+leaseAccnt.cllease__CL_Product__r.name);
        String sessionId = UserInfo.getSessionId();
        system.debug('**sessionId**'+sessionId);
        list<cllease__Termination_Quote_Header__c> termQuote = [select name,cllease__Full_Termination__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c where cllease__Contract__c=:AgreementId and cllease__Full_Termination__c =false];
             
        system.debug('**termQuote**'+termQuote);
        if(termQuote.size() > 0)
        {
            isTerm1= true;
            if(actObj.Conga_Docs__c == 'Part Settlement Quote' && leaseAccnt.cllease__Lease_Product_Name__r.name == 'Hire Purchase')
            {
            
                for(cllease__Termination_Quote_Header__c a:termQuote )
                wrapaccountlist.add(new wrapaccount(a)); 
                system.debug('**wrapaccountlist**'+wrapaccountlist);

            }
        }
        else
        {
            isTerm1= false;
        }
    return null;  
    }
     public PageReference Cancel() 
    {
        return new PageReference('/'+AgreementId);
    }
    public class wrapaccount{
    
        public cllease__Termination_Quote_Header__c accn{get;set;}
        public boolean isSelected{get;set;}
         
        public wrapaccount(cllease__Termination_Quote_Header__c a){
         
            accn=a;
            isselected=false;
        }
    }
 }