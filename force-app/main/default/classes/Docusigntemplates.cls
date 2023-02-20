global class Docusigntemplates {
    Webservice static String getData(){
        
        Map<String,String>  data=new Map<String,String>();
        if(test.isrunningtest()){
            data.put('37e0fdb7-835d-41d5-8808-595f023afb5d','Specific Guarantee & Indemnity FINAL - Updated');
        }else{
            data=Saf_DocuSign.GetAllTemplates();
        }
        system.debug('Data'+data);
        list<Docusign_Template__c> dstinsert=new list<Docusign_Template__c>();
        list<Docusign_Template__c> dst=[select Template_ID__c from Docusign_Template__c];
        list<string> keys=new list<string>();
        For(Docusign_Template__c d1: dst){
            keys.add(d1.Template_id__c);
        }
        for(String d: data.keyset()){
            if(!keys.contains(d)){
             Docusign_Template__c dt= new Docusign_Template__c();
                system.debug('HELLLLO'+d);
                dt.Template_ID__c=d;
                dt.Name=data.get(d);
                dstinsert.add(dt);
            }   
        }
        if(dstinsert.size() > 0){
            insert dstinsert;}
        return null;
        
      
    }
}