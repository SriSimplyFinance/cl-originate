/* The below class is used to create new party when introducer is updated in application object. This is called from skuid page on click of save button*/
global Class genesis_CheckParty{
    
    @InvocableMethod 
    webservice static void updategenesisParty(List<string> ApplicationIds){
    
         // Grab your Custom Setting values
         Saf_setting__c settings = Saf_setting__c.getOrgDefaults();
         String  PartyType = settings.IntroducerPartyType__c;
        system.debug('PartyType:' + PartyType);
        if(string.isblank(PartyType)) {system.debug('Custom setting missing for Party Type.');}

        String strApplicationId = ApplicationIds[0];
        List<genesis__Applications__c> Lst_App = [select name,Id,genesis__Account__c,Introducer1__c from genesis__Applications__c
                where  Id =: strApplicationId];
          system.debug('ApplicationIds:' +strApplicationId);
       
        clcommon__Party_Type__c objPartyType = [select name,Id from clcommon__Party_Type__c
                where Name =: PartyType Limit 1];
        system.debug('objPartyType :' +objPartyType);
                                
       List<clcommon__Party__c> LstoldParty = [select name,Id,clcommon__Type__c,clcommon__Account__c,clcommon__Type__r.Name,genesis__Application__c from clcommon__Party__c
                where  genesis__Application__c =: strApplicationId and clcommon__Type__r.Name =: objPartyType.Name and IsIntroducerParty__c = true Limit 1];
       system.debug('LstoldParty :' +LstoldParty );
      
      
           for(genesis__Applications__c objapp:Lst_App)
           { 
               If(objapp.Introducer1__c != null)
               { /*List<clcommon__Party__c> LstParty = [select name,Id,clcommon__Type__c,IsIntroducerParty__c,clcommon__Account__c,clcommon__Type__r.Name,genesis__Application__c from clcommon__Party__c
                where  genesis__Application__c =: strApplicationId and clcommon__Account__c =: objapp.Introducer1__c and clcommon__Type__r.Name =: objPartyType.Name and IsIntroducerParty__c = true];
                system.debug('LstParty:' +LstParty);*/
                    if(LstoldParty.size() == 0)
                    {
                      clcommon__Party__c objpar = new clcommon__Party__c();
                          objpar.clcommon__Account__c = objapp.Introducer1__c;
                          objpar.genesis__Application__c = objapp.Id;
                          objpar.clcommon__Type__c = objPartyType.Id; //'a4y9E000000Chas';
                          objpar.IsIntroducerParty__c = true;
                          
                          insert objpar;
                          system.debug('objpar:' +objpar);
                      
                        
                    }
                    else
                    {
                        for(clcommon__Party__c objparty:LstoldParty)
                       { 
                           objparty.clcommon__Account__c = objapp.Introducer1__c;
                       }
                        update LstoldParty;
                    }
               }
          }
          
               
        
    }   
    }