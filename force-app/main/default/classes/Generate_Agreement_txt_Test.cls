@isTest (SeeAllData=True)
private class Generate_Agreement_txt_Test {
    static testMethod void validateFolder() {
       Folder f =[select id from folder where name =: System.Label.Cais_FolderName];
       User u =[Select Id from User where name like '%Phalguni%' limit 1];
       Document d = new Document (Name='Test',FolderId=f.Id,Body = Blob.valueOf('This is Test'),AuthorId=u.Id);
       insert d;
       /*List<CAIS_setting__c>csList=new List<CAIS_setting__c>();
       CAIS_setting__c cs1 = new CAIS_setting__c(Name='Date of Creation',Description__c='Right justified,filled with leading zeros where appropriate',
                                                ISFixed__c=false,Data_Type__c='Text',Sequence_Number__c=1111,
                                                Starting_Byte__c=24,Value__c='03022003',Type__c='Header record',IsLeftAligned__c=False,
                                                Ending_Byte__c=31,Byte_Length__c=8, Contents_and_Format__c='DDMMCCYY');
      cslist.add(cs1);                                       
      CAIS_setting__c cs2 = new CAIS_setting__c(Name='Trailer',Description__c='Right justified,filled with leading zeros where appropriate',
                                                ISFixed__c=false,Data_Type__c='Text',Sequence_Number__c=1111,
                                                Starting_Byte__c=24,Value__c='03022003',Type__c='Trailer record',IsLeftAligned__c=False,
                                                Ending_Byte__c=31,Byte_Length__c=8, Contents_and_Format__c='DDMMCCYY');
      cslist.add(cs2);
      CAIS_setting__c cs3 = new CAIS_setting__c(Name='Account',Description__c='Right justified,filled with leading zeros where appropriate',
                                                ISFixed__c=false,Data_Type__c='Text',Sequence_Number__c=1111,
                                                Starting_Byte__c=24,Value__c='03022003',Type__c='Account record',IsLeftAligned__c=False,
                                                Ending_Byte__c=31,Byte_Length__c=8, Contents_and_Format__c='DDMMCCYY');
      cslist.add(cs3);  
      insert cslist;*/
       RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
       Account a = new Account();
        a.RecordtypeID=rec.id;
        a.Name = 'TestAccount-phalguni';
        a.Phone = '98767 678987';
        a.Landline__c= '98767 678987';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'London';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'London';
        insert a;
        
      cllease__Lease_Product__c prd = [Select Id,name from cllease__Lease_Product__c where cllease__Status__c='Active' /*name like'%Test%'*/ limit 1];
      clcommon__Fee_Set__c fs = [SELECT Id, name FROM clcommon__Fee_Set__c LIMIT 1];
      //Insert agreement
     cllease__Lease_Account__c clobj = new cllease__Lease_Account__c (cllease__Account__c=a.id,cllease__Lease_Product_Name__c=prd.id,
                                       cllease__Lease_Status__c=/*'Partial Application'*/'ACTIVE - GOOD STANDING',   cllease__Fee_Set1__c=fs.id
                                       ,cllease__Contract_Date__c=System.Today(),cllease__First_Payment_Date__c=System.Today()+1
                                       ,cllease__Current_Term__c=24,cllease__Payment_Frequency__c='Monthly',cllease__Grace_Period_for_Repayments__c=6
                                       ,cllease__Delinquency_Grace_Days__c=30,cllease__Pre_Bill_Days__c=30,cllease__Active_flag__c=True
                                       ,cllease__Term__c=12);
       insert clobj; //used for unit test
       cllease__Lease_Account__c negclobj = new cllease__Lease_Account__c (cllease__Account__c=a.id,cllease__Lease_Product_Name__c=prd.id,
                                       cllease__Lease_Status__c='Partial Application'/*'ACTIVE - GOOD STANDING'*/,   cllease__Fee_Set1__c=fs.id
                                       ,cllease__Contract_Date__c=System.Today(),cllease__First_Payment_Date__c=System.Today()+1
                                       ,cllease__Current_Term__c=24,cllease__Payment_Frequency__c='Monthly',cllease__Grace_Period_for_Repayments__c=6
                                       ,cllease__Delinquency_Grace_Days__c=30,cllease__Pre_Bill_Days__c=30,cllease__Active_flag__c=True
                                       ,cllease__Term__c=12);
      insert negclobj; // Object inserted for negative test.Agreement with Partial Application should not turn up in the generated doc.
      //end of insert agreement 
       
       
       List<cllease__Lease_Account__c> clist = new list<cllease__Lease_Account__c>();
       List<String> status = new List<String> {'ACTIVE - GOOD STANDING', 'ACTIVE - BAD STANDING'};
       //for(integer i=1;i<5;i++)
       //{
       Integer i = 1;
        cllease__Lease_Account__c tempclobj = new cllease__Lease_Account__c (cllease__Account__c=a.id,cllease__Lease_Product_Name__c=prd.id,
                                       cllease__Lease_Status__c=status[math.mod(i, 2)],cllease__Fee_Set1__c=fs.id
                                       ,cllease__Contract_Date__c=System.Today(),cllease__First_Payment_Date__c=System.Today()+1
                                       ,cllease__Current_Term__c=12,cllease__Payment_Frequency__c='Monthly',cllease__Grace_Period_for_Repayments__c=3
                                       ,cllease__Delinquency_Grace_Days__c=30,cllease__Pre_Bill_Days__c=30,cllease__Active_flag__c=True
                                       ,cllease__Term__c=12);
        clist.add(tempclobj);
       //}
       
       insert clist;
       /*List<String>IdList=new List<String>();
       for(cllease__Lease_Account__c x:clist)
           IdList.add(x.ID);*/
       Test.startTest();
       Generate_Agreement_txt obj = new Generate_Agreement_txt();
       cllease__Lease_Account__c temp=[Select Id,Name from cllease__Lease_Account__c where Id =:clobj.Id];
       cllease__Lease_Account__c tempNeg=[Select Id,Name from cllease__Lease_Account__c where Id=:negclobj.id];
       //List<cllease__Lease_Account__c> tempList=[Select Id,Name,cllease__Lease_Status__c from cllease__Lease_Account__c where Id In:IdList];
       obj.GetDocuments();
       obj.Generate_Agreement_txt();
       obj.DownloadDoc();
       Document doc=[Select ID,Body,Name from Document order by createddate desc limit 1];
       System.Debug('DOccccBody'+doc.Body.toString());
       System.Debug('ttttemp'+temp); 
       System.Debug('ttttempneg'+tempNeg);
       //System.Assert(!doc.Body.toString().contains(temp.Name),'Agreement missed in file'); //unit test
       //System.Assert(!doc.Body.toString().contains(tempNeg.Name),'Agreement should not be in file');// Negative test
       
      /* //Bulk check start
       for(cllease__Lease_Account__c z:templist)
          {
           System.Debug('oooobj'+z);
           System.Assert(doc.Body.toString().contains(z.name),'Agreement missed in file');
          }
       //Bulk check end*/
       Test.stopTest();
       
    }
     static testMethod void Test1(){
         Test.startTest();
        cllease.TestHelper.createSeedDataForTesting();
        //Create a Fee Set
        clcommon__Fee_Definition__c dummyFee = cllease.TestHelper.createLeaseFee();
        System.debug(LoggingLevel.ERROR, '*** dummyFee : ' + dummyFee);
        RecordType rec= [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Account' and name = 'Lessee'];
        Account lessee = new Account();
        lessee.RecordtypeID=rec.id;
        lessee.Name = 'TestAccount-phalguni';
        lessee.Phone = '98767 678987';
        lessee.Landline__c= '98767 678987';
        lessee.BillingPostalCode = 'BD1 1HA';
        lessee.BillingCity = 'London';
         lessee.ShippingPostalCode = 'BD1 1HA';
        lessee.ShippingCity = 'London';
        insert lessee;
         System.debug(LoggingLevel.ERROR, '*** lessee : ' + lessee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        //cllease.TestHelper.createOffice('Test Office', true);
        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLP = cllease.TestHelper.createLeaseProduct(dummyOffice,
                                   dummyFeeSet);
        System.debug(LoggingLevel.ERROR, '*** dummyLP : ' + dummyLP);
        dummyLP.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        dummyLP.cllease__Dep_over_asset_life__c = true;
        dummyLP.cllease__Dep_Stream_Accrual_Flag__c = true;
        dummyLP.cllease__idc_Accrual_Flag__c = true;
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' + cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE + ';' +
                                                                                         cllease.LendingConstants.LEASE_CASHBAL_FEES + ';' + cllease.LendingConstants.CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_INCOME + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE + ';' +
                                                                                                 cllease.LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_IDC + ';' +
                                                                                cllease.LendingConstants.LEASE_NONCASHBAL_IDC_ACCRUAL + ';' + cllease.LendingConstants.LEASE_NONCASHBAL_FEL_RECEIVABLE;
        update dummyLP;  
        List<cllease__Lease_Account__c> clist = new List<cllease__Lease_Account__c>();
    
        cllease__Lease_Account__c leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
 
 
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000, cllease__Life_In_Months__c=18,cllease__Equipment_Description__c ='OK',Net_Asset_Cost__c =10000));
           System.debug(LoggingLevel.ERROR, '*** contractEquipments : ' + contractEquipments);
          /**
         * Creating Parties
         */
        List<cllease__Contract_Parties__c> contractParty = new List<cllease__Contract_Parties__c>();
        contractParty.add(new cllease__Contract_Parties__c( cllease__Party_Account_Name__c =  lessee.ID, cllease__Party_Type__c = 'DEALER', cllease__Contract__c =leaseAccount.Id));
          System.debug(LoggingLevel.ERROR, '*** contractParty : ' + contractParty);
 
        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c= cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=1000,cllease__Total_Payment__c=12000,
                                                cllease__Payment_Date__c=Date.newInstance(2018, 01, 01)));
           System.debug(LoggingLevel.ERROR, '*** paymentDetails : ' + paymentDetails );
        /**
         * Calling ContractBuilder for Contract Creation
         */
        
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(contractParty);
        builder.addChildObjects(paymentDetails);
        
        String response = builder.createContract(null);
        System.debug(LoggingLevel.ERROR, '*** response: ' + response);
        
        cllease.RegenerateStreamsCtrl.regenerateStreams(leaseAccount.Id);
        leaseAccount.cllease__Lease_Status__c = 'ACTIVE - GOOD STANDING';
       
        update leaseAccount;
        //string response1 = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        // System.debug(LoggingLevel.ERROR, '---Response: '+response1);
         
        cllease.ActivateContractCtrl.activateContract(leaseAccount.id);
        system.debug('Contract ----'+leaseAccount.id);
        system.debug('Contract status----'+leaseAccount.cllease__lease_status__c);
        
      //  for(integer i=1;i<5;i++)
     //  { 
       
 
         
        leaseAccount       = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c             = lessee.ID;
        leaseAccount.cllease__Fee_Set1__c             = dummyFeeSet .ID;
        leaseAccount.cllease__Lease_Product_Name__c  = dummyLP.ID;
        leaseAccount.cllease__Branch__c              = dummyOffice.ID;
        leaseAccount.cllease__Payment_Spread__c      = dummyLP.cllease__Payment_Spread__c;
        leaseAccount.cllease__Product_Type__c        = 'LEASE';
        leaseAccount.cllease__Contract_Date__c       = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Term__c                = 12;
        leaseAccount.cllease__First_Payment_Date__c  = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE;
        leaseAccount.cllease__Amort_Start_Date__c    = Date.newInstance(2018, 01, 01);
        leaseAccount.cllease__Payment_Frequency__c   = 'MONTHLY';
        leaseAccount.cllease__Financed_Amount__c     = 10000;
        leaseAccount.cllease__Due_Day__c             = 1;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c = 500;
        leaseAccount.cllease__Income_Accrual_Frequency__c = 'END OF MONTH';
        leaseAccount.cllease__Accrual_Streams__c = 'Income;Subsidy;Residual;IDC;Tax;Rent;Depreciation';
        
           cllease.ContractBuilder builder1 = new cllease.ContractBuilder(leaseAccount);
        builder1.addChildObjects(contractEquipments);
        builder1.addChildObjects(contractParty);
        builder1.addChildObjects(paymentDetails);
        
        String response1 = builder1.createContract(null);
        System.debug(LoggingLevel.ERROR, '*** response1: ' + response1);
        
        cllease.RegenerateStreamsCtrl.regenerateStreams(leaseAccount.Id);
        leaseAccount.cllease__Lease_Status__c = 'ACTIVE - GOOD STANDING';
       
        update leaseAccount;
        //string response1 = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        // System.debug(LoggingLevel.ERROR, '---Response: '+response1);
         
        cllease.ActivateContractCtrl.activateContract(leaseAccount.id);
        system.debug('Contract1 ----'+leaseAccount.id);
        system.debug('Contract1 status----'+leaseAccount.cllease__lease_status__c);
     //   }
     Test.stopTest();
}
}