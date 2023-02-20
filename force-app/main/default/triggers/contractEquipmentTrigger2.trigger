trigger contractEquipmentTrigger2 on cllease__Contract_Equipment__c (before insert, after insert,after update) 
{
    List<cllease__Contract_Equipment__c> LstcontractEquip = new List<cllease__Contract_Equipment__c>();
    Saf_Equipment_UREL objBatch = new Saf_Equipment_UREL();
     List<Id> IdsContEquip =new List<Id>();   
        for(cllease__Contract_Equipment__c e:Trigger.new){
            IdsContEquip.add(e.cllease__Contract__c);
            objBatch.IdsContEquip2.add(e.cllease__Contract__c);
            LstcontractEquip.add(e);
        }
       system.debug('IsfirstTime :' + objBatch.IsfirstTime);
      if(objBatch.IsfirstTime && !system.isBatch())
      {
        Id batchInstanceId = Database.executeBatch(objBatch, 250); //earlier commented uncommented on feb14th
      }
      Boolean updateCEPonInsert = false;
    // added for CEP to COL changes
    if (Trigger.isInsert && Trigger.isBefore) {
        String contractId;
        for(cllease__Contract_Equipment__c e:Trigger.new){
            contractId = e.cllease__Contract__c;
            System.debug('contractId::::::'+contractId);
        }
        List<clcommon__Collateral_Category_Type_Association__c> cctaList = [SELECT Id, 
                                                                  clcommon__Collateral_Type__c,
                                                                  clcommon__Collateral_Category__c
                                                                  FROM clcommon__Collateral_Category_Type_Association__c
                                                                  WHERE clcommon__Collateral_Type__r.Name = 'Equipment'
                                                                  AND clcommon__Collateral_Category__r.Name = 'Lease Category'];
        System.debug('CCTALIST:::'+cctaList);
        List<cllease__Lease_Account__c> contractList = [select cllease__Branch__r.Name, cllease__Contract_Date__c from cllease__Lease_Account__c where Id = :contractId];
        String branch;
        Date contractDate;
        if(contractList != null && !contractList.isEmpty())
        {
            branch = contractList[0].cllease__Branch__r.Name;
            contractDate = contractList[0].cllease__Contract_Date__c;          
        }
        List<clcommon__Collateral__c> colList = new List<clcommon__Collateral__c>();
        //Map<cllease__Contract_Equipment__c,clcommon__Collateral__c> ceptocolMap = new Map<cllease__Contract_Equipment__c,clcommon__Collateral__c>();        
        /*List<cllease__Contract_Equipment__c> cepEquipments = new List<cllease__Contract_Equipment__c>();
        for(cllease__Contract_Equipment__c e:Trigger.new){
            cepEquipments.add(e);            
        } */   
        List<CEPtoCOLWrapper> cepEquipments = new List<CEPtoCOLWrapper>();  
        List<clcommon__Company__c> commonCompany = new List<clcommon__Company__c>();        
        if (branch != null) {
              commonCompany = [SELECT Id, Name, clcommon__Company_Name__c from clcommon__Company__c where clcommon__Company_Name__c = :branch];
        }
                   
        if(cctaList != null && !cctaList.isEmpty())
        {
            for(cllease__Contract_Equipment__c e:Trigger.new){
                CEPtoCOLWrapper ceptoCOLWrapper = new CEPtoCOLWrapper();
                contractId = e.cllease__Contract__c;
                clcommon__Collateral__c whEquipment = new clcommon__Collateral__c();
                clcommon__Collateral_Category__c leaseCategory = new clcommon__Collateral_Category__c();
                String whEquipmentType;
                if(e.cllease__Warehouse_Equipment__c == null)
                {
                    //standard fields
                    if(e.cllease__Estimated_Selling_Price__c != null){
                        whEquipment.clcommon__purchased_price__c = e.cllease__Estimated_Selling_Price__c;
                    }
                    if(e.Net_Asset_Cost__c != null){
                        whEquipment.clcommon__book_value__c = e.Net_Asset_Cost__c;
                    }
                    if(e.VAT__c != null){
                        whEquipment.VAT__c = e.VAT__c;
                    }
                    whEquipment.clcommon__salvage_value__c = e.cllease__Residual_Amount__c == null ? 0 : e.cllease__Residual_Amount__c;         
                    whEquipment.clcommon__depreciation_basis_amount__c = e.cllease__Equipment_Book_Value__c != null ? e.cllease__Equipment_Book_Value__c : e.cllease__Estimated_Selling_Price__c;
                    whEquipment.clcommon__Equipment_NBV__c = e.cllease__Equipment_Book_Value__c;                              
                    if(contractDate != null){
                        whEquipment.clcommon__depreciation_start_date__c = contractDate;
                        whEquipment.clcommon__Next_Depreciation_Date__c = contractDate.addMonths(1).toStartofMonth().adddays(-1); 
                    }
                   whEquipment.clcommon__Vehicle_Serial_Number__c = e.cllease__Equipment_Serial_Number__c;
                    whEquipment.clcommon__Vehicle_Identification_Number__c = e.Vehicle_Registration_Number__c;
                    whEquipment.clcommon__equipment_life_in_months__c = e.cllease__life_in_months__c;               
                    if(e.cllease__Generate_Book_Depreciation__c && e.cllease__Depreciation_Basis__c  == 'Equipment'){
                        whEquipment.clcommon__generate_book_depreciation__c = true;
                    }
                    //if (branch != null) {
                    //    List<clcommon__Company__c> commonCompany = [SELECT Id, Name, clcommon__Company_Name__c from clcommon__Company__c where clcommon__Company_Name__c = :branch];
                        if (!commonCompany.isEmpty())
                            whEquipment.clcommon__Company__c =  commonCompany.get(0).Id;
                    //}
                    /*List<clcommon__Company__c> commonCompany = [SELECT Id, Name, clcommon__Company_Name__c from clcommon__Company__c LIMIT 1];
                    if (!commonCompany.isEmpty()){
                        whEquipment.clcommon__Company__c = commonCompany.get(0).Id;
                    }*/
                    whEquipment.clcommon__status__c = clcommon.Constants.COLLATERAL_STATUS_WAREHOUSE;//'Warehouse';               
                    whEquipment.clcommon__Collateral_Type__c = cctaList[0].clcommon__Collateral_Type__c;
                    whEquipment.clcommon__Collateral_Category__c = cctaList[0].clcommon__Collateral_Category__c;
                    whEquipment.RecordTypeId = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();                   
                    // custom fields
                    if(e.Asset_Category__c != null){
                        whEquipment.Asset_Category__c = e.Asset_Category__c;
                    }
                    if(e.cllease__Equipment_Type__c != null){
                        whEquipment.clcommon__Equipment_Type__c = e.cllease__Equipment_Type__c;
                    }
                    if(e.Asset_Manufacturer__c != null){
                        whEquipment.clcommon__Manufacturer__c = e.Asset_Manufacturer__c;
                    }
                    if(e.NewUsed__c != null){
                        whEquipment.New_Used__c = e.NewUsed__c;
                    }
                    if(e.Invoice_Due_Date__c == null){
                        whEquipment.Invoice_Due_Date__c = e.Invoice_Due_Date__c;
                    }
                    if(e.cllease__Equipment_Description__c != null){
                        whEquipment.clcommon__Equipment_Description__c = e.cllease__Equipment_Description__c;
                        whEquipment.clcommon__Collateral_Name__c = e.cllease__Equipment_Description__c;
                    }
                    if(e.cllease__Make__c != null){
                        whEquipment.clcommon__Make__c = e.cllease__Make__c;
                    }
                    if(e.cllease__Model__c != null){
                        whEquipment.clcommon__Model__c = e.cllease__Model__c;
                    }
                    if(e.Year_of_Manufacture__c != null){
                        whEquipment.Year_of_Manufacture__c = e.Year_of_Manufacture__c;
                    }
                    if(e.Vehicle_Chassis_Number__c != null){
                        whEquipment.Vehicle_Chassis_Number__c = e.Vehicle_Chassis_Number__c;
                    }
                    if(e.cllease__Equipment_Serial_Number__c != null){
                        whEquipment.clcommon__Vehicle_Serial_Number__c = e.cllease__Equipment_Serial_Number__c;
                    }
                    if(e.Vehicle_Registration_Number__c != null){
                        whEquipment.clcommon__Vehicle_Identification_Number__c = e.Vehicle_Registration_Number__c;
                    }
                    if(e.HPI_Registration_Required__c != null){
                        whEquipment.HPI_Registration_Required__c = e.HPI_Registration_Required__c;
                    }
                    if(e.IS_Registered__c != null){
                        whEquipment.IS_Registered__c = e.IS_Registered__c;
                    }
                    if(e.cllease__Dealer_Name__c != null){
                        whEquipment.Dealer_Name__c = e.cllease__Dealer_Name__c;
                    }
                    colList.add(whEquipment);
                    System.debug('whEquipment::'+whEquipment);
                    ceptoCOLWrapper.setCEPEquipment(e);
                    ceptoCOLWrapper.setCOLEquipment(whEquipment);
                    cepEquipments.add(ceptoCOLWrapper);
                    //ceptocolMap.put(e,whEquipment);
                }
            }
        }
        System.debug('COLLIST:::'+colList);
        if (colList.size() > 0) {
            insert colList; 
        }
        //System.debug('ceptocolMap.size:::'+ceptocolMap.size());
        //if(ceptocolMap.size() > 0  ){
            //System.debug('MAP of CEPTOCOL::::'+ceptocolMap);
             //for(cllease__Contract_Equipment__c e:cepEquipments){  
        if(cepEquipments.size() > 0  ){
            for(CEPtoCOLWrapper e : cepEquipments){
                     System.debug('COntract Equipment::::'+e);     
                     //System.debug('CEPtoCOL MAP KEY for'+e.Name+'::::'+ceptocolMap.containsKey(e));
                     //clcommon__Collateral__c whCol = ceptocolMap.get(e);
                      clcommon__Collateral__c whCol = e.getCOLEquipment();
                      System.debug('whCollateral::'+whCol); 
                      System.debug('whcollateralID:::'+whCol);
                      cllease__Contract_Equipment__c cep = e.getCEPEquipment();
                      System.debug('cep:::'+cep);
                      cep.cllease__Warehouse_Equipment__c = whCol.Id;
                      //e.cllease__Warehouse_Equipment__c = whCol.Id;
                      updateCEPonInsert = true;  
             }
        }
        List<clcommon__Equipment_Transaction__c> equipmentTransactions = new List<clcommon__Equipment_Transaction__c>();
        Set<String> colIds = new Set<String>();
        for(clcommon__Collateral__c whCol:colList)
        {
            colIds.add(whCol.Id);
        }
        List<clcommon__Equipment_Transaction__c> newEquipmentTxns = [SELECT ID,clcommon__Collateral__c,name FROM clcommon__Equipment_Transaction__c 
                                                                    WHERE clcommon__Collateral__c IN :colIds];
        
        Map<Id,Id> colTxnMap = new Map<Id,Id>();
        for(clcommon__Equipment_Transaction__c neweqTxn : newEquipmentTxns)
        {
            colTxnMap.put(neweqTxn.clcommon__Collateral__c, neweqTxn.ID);            
        }
        
        for(clcommon__Collateral__c whCol:colList)
        {
            if(whCol.clcommon__Status__c == clcommon.Constants.COLLATERAL_STATUS_WAREHOUSE){
                //List<clcommon__Equipment_Transaction__c> newEquipmentTxn = [SELECT ID FROM clcommon__Equipment_Transaction__c WHERE clcommon__Collateral__c = :whCol.Id];                
                //if(newEquipmentTxn.isEmpty()){
                if(colTxnMap.get(whCol.Id) == null){
                    clcommon__Equipment_Transaction__c txn = new clcommon__Equipment_Transaction__c();
                    txn.clcommon__Collateral__c = whCol.Id;
                    txn.clcommon__Transaction_Type__c = clcommon.Constants.TRANSACTION_NEW_EQUIPMENT;
                    txn.clcommon__Book_Value__c = whCol.clcommon__Book_Value__c;
                    txn.clcommon__transaction_date__c = CLLease.SystemDateUtil.getCurrentSystemDate();
                    txn.clcommon__Purchase_Price__c = whCol.clcommon__Purchased_Price__c;
                    txn.clcommon__Salvage_Value__c = whCol.clcommon__Salvage_Value__c;
                    txn.clcommon__Depreciation_Basis_Amount__c = whCol.clcommon__Depreciation_Basis_Amount__c;    
                    txn.clcommon__Transaction_Amount__c = 0;
                    //insert txn;
                    equipmentTransactions.add(txn);
                   //SecureDml.InsertRecords(txn);
                }
            }
        }
        if(equipmentTransactions.size()>0)
        {
            insert equipmentTransactions;
        }
        
        
        
    }
    else if(Trigger.isUpdate && !updateCEPonInsert)
    {
        List<clcommon__Collateral__c> parentList = new List<clcommon__Collateral__c>(); 
        List<clcommon__Collateral__c> updateParentList = new List<clcommon__Collateral__c>(); 
        Map<Id,clcommon__Collateral__c> parentMap = new Map<Id,clcommon__Collateral__c>();
        List<Id> listIds = new List<Id>();
        for(cllease__Contract_Equipment__c col : Trigger.new){
            listIds.add(col.cllease__Warehouse_Equipment__c);
        }    
        parentList = [SELECT Id, Name FROM clcommon__Collateral__c WHERE ID IN :listIds];
        System.debug('parentList:::'+parentList);
        for(clcommon__Collateral__c p : parentList){
            parentMap.put(p.Id, p);
        }
        for(cllease__Contract_Equipment__c e:Trigger.new){
            clcommon__Collateral__c whCol = parentMap.get(e.cllease__Warehouse_Equipment__c);
            System.debug('whCol::e::'+e);
          if(whCol !=null)
          {
            if(e.Asset_Category__c != null){
                    whCol.Asset_Category__c = e.Asset_Category__c;
                }
                if(e.cllease__Equipment_Type__c != null){
                    whCol.clcommon__Equipment_Type__c = e.cllease__Equipment_Type__c;
                }
                if(e.Asset_Manufacturer__c != null){
                    whCol.clcommon__Manufacturer__c = e.Asset_Manufacturer__c;
                }
                if(e.NewUsed__c != null){
                    whCol.New_Used__c = e.NewUsed__c;
                }
                if(e.Invoice_Due_Date__c != null){
                    whCol.Invoice_Due_Date__c = e.Invoice_Due_Date__c;
                }
                if(e.cllease__Equipment_Description__c != null){
                    whCol.clcommon__Equipment_Description__c = e.cllease__Equipment_Description__c;
                }
                if(e.cllease__Equipment_Serial_Number__c != null){
                    whCol.clcommon__Vehicle_Serial_Number__c = e.cllease__Equipment_Serial_Number__c;
                }
                if(e.Vehicle_Registration_Number__c != null){
                    whCol.clcommon__Vehicle_Identification_Number__c = e.Vehicle_Registration_Number__c;
                }
                if(e.cllease__Make__c != null){
                    whCol.clcommon__Make__c = e.cllease__Make__c;
                }
                if(e.cllease__Model__c != null){
                    whCol.clcommon__Model__c = e.cllease__Model__c;
                }
                if(e.Year_of_Manufacture__c != null){
                    whCol.Year_of_Manufacture__c = e.Year_of_Manufacture__c;
                }
                if(e.Vehicle_Chassis_Number__c != null){
                    whCol.Vehicle_Chassis_Number__c = e.Vehicle_Chassis_Number__c;
                }
                if(e.HPI_Registration_Required__c != null){
                    whCol.HPI_Registration_Required__c = e.HPI_Registration_Required__c;
                }
                if(e.IS_Registered__c != null){
                    whCol.IS_Registered__c = e.IS_Registered__c;
                }
                if(e.cllease__Dealer_Name__c != null){
                    whCol.Dealer_Name__c = e.cllease__Dealer_Name__c;
                }
            updateParentList.add(whCol);
          }
        }
        if (updateParentList.size() > 0) {
            update updateParentList;
        }
    }
    
    class CEPtoCOLWrapper{
        private cllease__Contract_Equipment__c cepEquipment;
        
        public cllease__Contract_Equipment__c getCEPEquipment(){
            return cepEquipment;
        }
        public void setCEPEquipment(cllease__Contract_Equipment__c cepEquipment){
            this.cepEquipment = cepEquipment;
        }
        private clcommon__Collateral__c colEquipment;
        
        public clcommon__Collateral__c getCOLEquipment(){
            return colEquipment;
        }
        public void setCOLEquipment(clcommon__Collateral__c colEquipment){
            this.colEquipment = colEquipment;
        }
        
    }
    

}