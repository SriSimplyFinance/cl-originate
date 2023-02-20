@isTest
private class DocusignTemplatesTest {
    static Testmethod void Templates(){
         list<Docusign_Template__c> dst= new list<Docusign_Template__c>();
    Docusign_Template__c d= new Docusign_Template__c();
    d.Template_ID__c='3434223';
    d.Name='test';
    dst.add(d);
    Docusign_Template__c d1= new Docusign_Template__c();
    d1.Template_ID__c='34343343224';
    d1.Name='test';
    dst.add(d1);
    
    insert dst;
    map<string,string> dstmap=new map<string,string>();
    dstmap.put('37e0fdb7-835d-41d5-8808-595f023afb5d','Specific Guarantee & Indemnity FINAL - Updated');
    dstmap.put('52d00073-deac-4a88-9739-96f1aac24bf5','Tst template 1');
    dstmap.put('5a907383-7ea6-4a8d-952f-7c71871f9246','Limited Guarantee & Indemnity FINAL - Updated');
    
   	Docusigntemplates.getData();
       
        
    }
   
}