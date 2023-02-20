@isTest
public class HPI_Parserclass_test
{//(SeeAllData=True)
    public static List<cllease__Contract_Equipment__C> contractEquipments;
    public static cllease__Lease_Account__c leaseAccount;
    Public static testmethod void createrecords()
    {
           
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
        
        
        Contact con = new contact();      
        con.Birthdate = Date.newInstance(1965, 10, 29);    
        con.LastName = 'TESTADAIR';
        con.Firstname = 'PETER';      
        con.accountid = lessee.id ;        
        insert con ;
    
        System.debug(LoggingLevel.ERROR, '*** lessee : ' + lessee);
        clcommon__Fee_Set__c dummyFeeSet = cllease.TestHelper.createLeaseFeeSet();
        System.debug(LoggingLevel.ERROR, '*** dummyFeeSet : ' + dummyFeeSet);
        clcommon__Fee_Junction__c dummyFeeJunction = cllease.TestHelper.createFeeJunction(dummyFee.id, dummyFeeSet.id);
        System.debug(LoggingLevel.ERROR, '*** dummyFeeJunction : ' + dummyFeeJunction);
       // cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
        cllease.TestHelper.createOffice('Test Office', true);
        cllease__Office_Name__c dummyOffice = [select Id,Name from cllease__Office_Name__c limit 1];
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
        insert leaseAccount;
 
       
        contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000, 
        cllease__Equipment_Serial_Number__c= '100',
        Vehicle_Registration_Number__c = 'BC64OHO',
        Vehicle_Chassis_Number__c = 'VF7YDTMFC12667844',
        HPI_Registration_Required__c = true,
        cllease__Equipment_Type__c = 'Tractor',
        cllease__Make__c = 'LEYLAND DAF',
        Year_of_Manufacture__c = '2000',
        HPI_Error_Message__c ='',IS_Registered__c = false,
        cllease__Contract__c = leaseAccount.Id,
        cllease__Life_In_Months__c=18,cllease__Equipment_Description__c ='OK',Net_Asset_Cost__c =10000));
        insert contractEquipments;
        System.debug(LoggingLevel.ERROR, '*** contractEquipments : ' + contractEquipments);
        
        List<cllease__Contract_Parties__c> contractParty = new List<cllease__Contract_Parties__c>();
        contractParty.add(new cllease__Contract_Parties__c( cllease__Party_Account_Name__c =  lessee.ID, cllease__Party_Type__c = 'DEALER', cllease__Contract__c =leaseAccount.Id));
        insert contractParty;
        System.debug(LoggingLevel.ERROR, '*** contractParty : ' + contractParty);
    }
    
    public Static testmethod void praserTest()
    {
  
        createrecords();
        /*cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(contractParty);      
        String response = builder.createContract(null);
        System.debug(LoggingLevel.ERROR, '*** response: ' + response);*/
        string equipmentId = contractEquipments[0].Id; //'a5h9E000000Ac0f';
        List<cllease__Contract_Equipment__c> lstEquipement = [select Id,Name,IS_Registered__c,cllease__Contract__c,cllease__Contract__r.cllease__Contract_Date__c,cllease__Contract__r.Name,cllease__Contract__r.cllease__Term__c,
           HPI_Code__c,HPI_Registration_Required__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,Vehicle_Registration_Number__c,Vehicle_Chassis_Number__c,
           cllease__VIN__c,cllease__Equipment_Description__c,cllease__Equipment_Serial_Number__c,cllease__Equipment_Type__c,cllease__Contract__r.cllease__Lease_Product_Name__r.Name,cllease__Make__c, cllease__Model__c,  NewUsed__c
           from cllease__Contract_Equipment__c where Id =:equipmentId];
           system.debug('========= lstEquipement ========'+lstEquipement); 
        
        Test.startTest();
          
        Test.setMock(HttpCalloutMock.class, new HPI_calloutMock());            
        //Test.setMock(WebServiceMock.class, new HPIParserMock());
       // Test.setMock(WebServiceMock.class, new HPIWebParserMock());  
        String result = HPI_Parserclass.hpi_FinanceAdd(lstEquipement[0]);
        System.debug(LoggingLevel.ERROR, '*** result : ' + result ); 
        String result_inquiry = HPI_Parserclass.hpi_FinanceInquiry(equipmentId);
        HPI_Parserclass.hpi_getAgreementType();
        HPI_Parserclass.hpi_getCategoryCode();
        HPI_Parserclass.hpi_parsing(lstEquipement[0].cllease__Contract__c);     
       //Aircraft
        HPI_Parserclass.HPI_RegiterAllEquipments(lstEquipement[0].cllease__Contract__c);
        System.debug(LoggingLevel.ERROR, '*** result : ' + result_inquiry); 
            
        
     
         Test.stopTest();
    }
     public Static testmethod void WebpraserTest()
    {
       createrecords();
        string equipmentId = contractEquipments[0].Id;
       List<cllease__Contract_Equipment__c> lstEquipement = [select Id,Name,IS_Registered__c,cllease__Contract__c,cllease__Contract__r.cllease__Contract_Date__c,cllease__Contract__r.Name,cllease__Contract__r.cllease__Term__c,
           HPI_Code__c,HPI_Registration_Required__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,Vehicle_Registration_Number__c,Vehicle_Chassis_Number__c,
           cllease__VIN__c,cllease__Equipment_Description__c,cllease__Equipment_Serial_Number__c,cllease__Equipment_Type__c,cllease__Contract__r.cllease__Lease_Product_Name__r.Name,cllease__Make__c, cllease__Model__c,  NewUsed__c
           from cllease__Contract_Equipment__c where Id =:equipmentId];
           system.debug('========= lstEquipement ========'+lstEquipement); 
           
       Test.startTest();
       HPI_Parserclass hp = new HPI_Parserclass();
       //Test.setMock(HttpCalloutMock.class, new HPI_calloutMock()); 
       //Test.setMock(WebServiceMock.class, new HPIParserMock()); 
       Test.setMock(WebServiceMock.class, new HPIWebParserMock());
       List<webservicesHpiCoUkFinanceReg.CodeDescriptionType> lst_codes = HPI_Parserclass.getCategoryCodes();
       HPI_Parserclass.getMakeCodes('G');
       HPI_Parserclass.getAgreementTypes();
       String strtype = 'agreementtype';      
       HPI_Parserclass.getMakeDescription('AU');
      
       HPI_Parserclass.StoreInDB(strtype ,lst_codes,'');
        System.debug(LoggingLevel.ERROR, '*** lst_codes : ' + lst_codes); 
        Test.stopTest(); 
    }
     public Static testmethod void WebFinanceAddTest()
    {
       createrecords();
        string equipmentId = contractEquipments[0].Id;
       List<cllease__Contract_Equipment__c> lstEquipement = [select Id,Name,IS_Registered__c,cllease__Contract__c,cllease__Contract__r.cllease__Contract_Date__c,cllease__Contract__r.Name,cllease__Contract__r.cllease__Term__c,
           HPI_Code__c,HPI_Registration_Required__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,Vehicle_Registration_Number__c,Vehicle_Chassis_Number__c,
           cllease__VIN__c,cllease__Equipment_Description__c,cllease__Equipment_Serial_Number__c,cllease__Equipment_Type__c,cllease__Contract__r.cllease__Lease_Product_Name__r.Name,cllease__Make__c, cllease__Model__c,  NewUsed__c
           from cllease__Contract_Equipment__c where Id =:equipmentId];
           system.debug('========= lstEquipement ========'+lstEquipement); 
           
       Test.startTest();
       HPI_Parserclass hp = new HPI_Parserclass();
       //Test.setMock(HttpCalloutMock.class, new HPI_calloutMock()); 
       Test.setMock(WebServiceMock.class, new HPIParserMock()); 
       //Test.setMock(WebServiceMock.class, new HPIWebParserMock());     
       HPI_Parserclass.hpi_WebFinanceAdd(lstEquipement[0]);    
       
        webservicesHpiCoUkFinanceReg.ServiceVersionType web_ser = new webservicesHpiCoUkFinanceReg.ServiceVersionType();
         webservicesHpiCoUkFinanceReg.EnquiryIdentificationType web_InquiryIndenType = new webservicesHpiCoUkFinanceReg.EnquiryIdentificationType();
         webservicesHpiCoUkFinanceReg.InterestEnquiryType web_InquiryType = new webservicesHpiCoUkFinanceReg.InterestEnquiryType();
         webservicesHpiCoUkFinanceReg.FinanceEnquiryType web_FinanceInquiryType = new webservicesHpiCoUkFinanceReg.FinanceEnquiryType();
         webservicesHpiCoUkFinanceReg.FinanceEnquiryResponseType web_FinanceInquiryResType = new webservicesHpiCoUkFinanceReg.FinanceEnquiryResponseType();
         webservicesHpiCoUkFinanceReg.InterestDeleteType web_InterestDelType = new webservicesHpiCoUkFinanceReg.InterestDeleteType();
         webservicesHpiCoUkFinanceReg.FinanceDeleteType web_FinanDelType = new webservicesHpiCoUkFinanceReg.FinanceDeleteType();
         webservicesHpiCoUkFinanceReg.FinanceAmendAssetType web_FinanAmendType = new webservicesHpiCoUkFinanceReg.FinanceAmendAssetType();
        webservicesHpiCoUkFinanceReg.InterestAmendAssetType web_InterestAmendType = new webservicesHpiCoUkFinanceReg.InterestAmendAssetType();
        webservicesHpiCoUkFinanceReg.ErrorType web_ErrorType = new webservicesHpiCoUkFinanceReg.ErrorType();
         webservicesHpiCoUkFinanceReg.FinanceAmendTermsType web_FinanceAmendTermType = new webservicesHpiCoUkFinanceReg.FinanceAmendTermsType();
        webservicesHpiCoUkFinanceReg.InterestAmendTermsType web_InterestAmendTermType = new webservicesHpiCoUkFinanceReg.InterestAmendTermsType();
         webservicesHpiCoUkFinanceReg.FinanceInterestType web_FinanceInterestType = new webservicesHpiCoUkFinanceReg.FinanceInterestType();
         webservicesHpiCoUkFinanceReg.VehicleDetailsType web_VehicleType = new webservicesHpiCoUkFinanceReg.VehicleDetailsType();
         webservicesHpiCoUkFinanceReg.DeleteIdentificationType web_DelIndetificationType = new webservicesHpiCoUkFinanceReg.DeleteIdentificationType();
         webservicesHpiCoUkFinanceReg.ServiceDetailsType web_SerType = new webservicesHpiCoUkFinanceReg.ServiceDetailsType();
        
        Test.stopTest(); 
    }
    
      public Static testmethod void HPI_IntegrationTest()
    {
       createrecords();
        string equipmentId = contractEquipments[0].Id;
       List<cllease__Contract_Equipment__c> lstEquipement = [select Id,Name,IS_Registered__c,cllease__Contract__c,cllease__Contract__r.cllease__Contract_Date__c,cllease__Contract__r.Name,cllease__Contract__r.cllease__Term__c,
           HPI_Code__c,HPI_Registration_Required__c,cllease__LeaseApplicationNumber__c,cllease__LeaseApplication__c,Vehicle_Registration_Number__c,Vehicle_Chassis_Number__c,
           cllease__VIN__c,cllease__Equipment_Description__c,cllease__Equipment_Serial_Number__c,cllease__Equipment_Type__c,cllease__Contract__r.cllease__Lease_Product_Name__r.Name,cllease__Make__c, cllease__Model__c,  NewUsed__c
           from cllease__Contract_Equipment__c where Id =:equipmentId];
           system.debug('========= lstEquipement ========'+lstEquipement); 
           
       Test.startTest();
       HPI_Integration hp = new HPI_Integration();
       //Test.setMock(HttpCalloutMock.class, new HPI_calloutMock()); 
       Test.setMock(HttpCalloutMock.class, new HPI_FaultcalloutMock()); 
         
       HPI_Integration.STSRequestSoap objsts = new HPI_Integration.STSRequestSoap();
       HPI_Integration.SubmitResponse_element res_element = new HPI_Integration.SubmitResponse_element();
       String result = HPI_Parserclass.hpi_FinanceAdd(lstEquipement[0]);
       System.debug(LoggingLevel.ERROR, '*** result : ' + result );
       
        Test.stopTest(); 
    }
}