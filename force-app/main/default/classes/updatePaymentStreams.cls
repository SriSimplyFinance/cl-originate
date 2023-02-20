public Class updatePaymentStreams
{
    public static void updateRecords(List<genesis__Applications__c> Application)
    {
        String     strApplicationId;
        String     paymentStreamId;
        Date       dealerPaymentDate,agreementStartDate;
        // Added for Ticket No: #159931 Security deposit for Finance lease - Starts
        Decimal    securityDeposit; 
        String     strProductId;
        // Added for Ticket No: #159931 Security deposit for Finance lease - Ends
        
        if(Application.size() >0)
        {
            strApplicationId     = Application[0].Id;
            dealerPaymentDate    = Application[0].genesis__Dealer_Payment_Date__c;
            agreementStartDate   = Application[0].genesis__Expected_Start_Date__c;
            securityDeposit      = Application[0].Security_Deposit__c; // Added for Ticket No: #159931 Security deposit for Finance lease
            strProductId         = Application[0].genesis__CL_Product__c;
            
            System.debug('#### HM Agreement Start date: '+agreementStartDate);
            System.debug('#### HM Dealer Payment date: '+dealerPaymentDate);
            System.debug('#### HM Product name: '+Application[0].genesis__CL_Product_Name__c);
            IF(Application[0].genesis__CL_Product_Name__c == 'Finance Lease')
            {
                //genesis__Expected_Start_Date__c , ADDMONTHS( genesis__Expected_Start_Date__c ,1))
                loopingPaymentStreams(strApplicationId,agreementStartDate);
                loopingFees(strApplicationId,agreementStartDate,agreementStartDate);
            }
            else
            {
                loopingPaymentStreams(strApplicationId,agreementStartDate.addMonths(1));
                loopingFees(strApplicationId,agreementStartDate.addMonths(1),agreementStartDate);
            }
            //loopingFees(strApplicationId,dealerPaymentDate,agreementStartDate);
        }
        
    }   
    
    public static void loopingPaymentStreams(string strApplicationId,date paymentStartDate)
    {
        list<genesis__Payment_Stream__c> paymentStreams = [Select Id, genesis__Sequence__c, genesis__Start_Date__c, PaymentEndDate__c,genesis__Number_of_Payments__c From genesis__Payment_Stream__c Where genesis__Application__c =:strApplicationId order by genesis__Sequence__c ASC];
        date prevPaymentEndDate;
        Decimal prevNoOfPayments = 0;
        
        for(genesis__Payment_Stream__c p_Streams:paymentStreams ) 
        {
            if(p_Streams.genesis__Sequence__c == 1)
            {
                system.debug('@@@@@@@@@@@@@@Dealer Payment Date@@@@@@@@@@@@@@'+paymentStartDate);
                p_Streams.genesis__Start_Date__c = paymentStartDate;
            }
            else
            {
                system.debug('*************Payment numbers Before*************'+prevNoOfPayments);
               // p_Streams.genesis__Start_Date__c = prevPaymentEndDate.addMonths(integer.valueof(prevNoOfPayments));
                p_Streams.genesis__Start_Date__c = paymentStartDate.addMonths(integer.valueof(prevNoOfPayments));
                system.debug('*************Payment numbers After*************'+prevNoOfPayments);
                system.debug('*************Payment Start date: '+p_Streams.genesis__Start_Date__c);
            }
            update p_Streams;
            prevPaymentEndDate = p_Streams.PaymentEndDate__c;
            prevNoOfPayments = prevNoOfPayments + p_Streams.genesis__Number_of_Payments__c;
            system.debug('*************Payment Sequence: '+p_Streams.genesis__Sequence__c);
            system.debug('*************Payment End date: '+prevPaymentEndDate);
            system.debug('*************No Payments: '+prevNoOfPayments);
        }
    } 
    
    public static void loopingFees(string strApplicationId,date paymentStartDate, date agreementStartDate)
    {
        list<genesis__Fee_Schedule__c> feeSchedule = [Select Id,genesis__Start_Date__c,genesis__Fee_Definition__c From genesis__Fee_Schedule__c Where genesis__Application__c =:strApplicationId];
        
        
        for(genesis__Fee_Schedule__c f_Sch:feeSchedule) 
        {
            clcommon__Fee_Definition__c fees=[select Id,clcommon__Class__c from clcommon__Fee_Definition__c where id =: f_Sch.genesis__Fee_Definition__c];
            
            if(fees.clcommon__Class__c == 'Income')
            {
                f_Sch.genesis__Start_Date__c = paymentStartDate;
            }
            else
            {
                f_Sch.genesis__Start_Date__c = agreementStartDate;
            }
            update f_Sch;
        }
    } 
    
    // Added for Ticket No: #159931 Security deposit for Finance lease - Starts
    public static void updateFLRecords(List<genesis__Applications__c> Application)
    {
        String     strApplicationId;
        String     paymentStreamId;
        Date       dealerPaymentDate,agreementStartDate;
        Decimal    securityDeposit; 
        String     strProductId;      
        system.debug('#################Update FL records 1: '+Application[0].Security_Deposit__c);
        if(Application.size() >0)
        {
            strApplicationId     = Application[0].Id;
            dealerPaymentDate    = Application[0].genesis__Dealer_Payment_Date__c;
            agreementStartDate   = Application[0].genesis__Expected_Start_Date__c;
            securityDeposit      = Application[0].Security_Deposit__c; // Added for Ticket No: #159931 Security deposit for Finance lease
            strProductId         = Application[0].genesis__CL_Product__c;          
            loopingFLPaymentStreams(strApplicationId,dealerPaymentDate,securityDeposit,strProductId);
            
        }
        
    }  
    
    public static void loopingFLPaymentStreams(string strApplicationId,date paymentStartDate, decimal securityDeposit, string strProductId)
    {
        list<genesis__Payment_Stream__c> paymentStreamsFL = [Select Id, SAF_is_Finance_Lease__c, genesis__Sequence__c, genesis__Start_Date__c, PaymentEndDate__c,genesis__Number_of_Payments__c From genesis__Payment_Stream__c Where genesis__Application__c =:strApplicationId order by genesis__Sequence__c ASC];
        date prevPaymentEndDate;
        Decimal prevNoOfPayments = 0;
        boolean isPaymentAvailable = false;
        clcommon__CL_Product__c clProduct = new clcommon__CL_Product__c();
        Boolean isFinancePaymentDeleted = false;
        Boolean isPaymentStreamModified = false;
        //Extra added for reopened ticket 159931 on 04-01-2019
        clProduct = [Select Id,clcommon__Product_Name__c From clcommon__CL_Product__c Where Id =:strProductId];
        
        system.debug('#################Update FL records 2: '+securityDeposit);
        for(genesis__Payment_Stream__c p_Streams:paymentStreamsFL) 
        {
            isPaymentAvailable = true;
            if(p_Streams.genesis__Sequence__c == 1)
            {
                clProduct = [Select Id,clcommon__Product_Name__c From clcommon__CL_Product__c Where Id =:strProductId];
                
                if(clProduct.clcommon__Product_Name__c == 'Finance Lease')
                {
                    if(securityDeposit > 0 && p_Streams.SAF_is_Finance_Lease__c) //Update Scenario
                    {
                        system.debug('#################Update FL records 3: '+securityDeposit);
                        p_Streams.genesis__Payment_Amount__c = securityDeposit;
                        update p_Streams;
                    }
                    else if(securityDeposit > 0 && !p_Streams.SAF_is_Finance_Lease__c) // Create Scenario
                    {
                        system.debug('#################Update FL records 4: '+securityDeposit);
                        createPaymentStream(strApplicationId,paymentStartDate,securityDeposit);
                        isPaymentStreamModified = true;
                    }
                    else if(securityDeposit == 0 && p_Streams.SAF_is_Finance_Lease__c) // Delete Scenario
                    {
                        isFinancePaymentDeleted = true;
                        isPaymentStreamModified = true;
                        system.debug('#################Update FL records 5: '+securityDeposit);
                        deletePaymentStream(strApplicationId, isFinancePaymentDeleted);
                    }
                }
            }
        }
        //Extar added && clProduct.clcommon__Product_Name__c == 'Finance Lease' 0n 04-01-2019
        if(!isPaymentAvailable && securityDeposit > 0 && clProduct.clcommon__Product_Name__c == 'Finance Lease')
        {
            createPaymentStream(strApplicationId,paymentStartDate,securityDeposit);
        }
        
        if(isPaymentStreamModified)
        {
            system.debug('#################Calling Payment Stream loop#################');
            loopingPaymentStreams(strApplicationId,paymentStartDate);
        }
    } 
    
    // Creation of Payment streams for Finance lease Applications
    public static void createPaymentStream(string strApplicationId,date dealerPaymentDate, decimal securityDeposit)
    {
        list<genesis__Payment_Stream__c> payStreams = [Select Id, SAF_is_Finance_Lease__c, genesis__Sequence__c, genesis__Start_Date__c, PaymentEndDate__c,genesis__Number_of_Payments__c From genesis__Payment_Stream__c Where genesis__Application__c =:strApplicationId];
        genesis__Payment_Stream__c paymCreation = new genesis__Payment_Stream__c();
        //securityDeposit
        for(genesis__Payment_Stream__c p_StreamsF:payStreams) 
        {
            p_StreamsF.genesis__Sequence__c = p_StreamsF.genesis__Sequence__c +1;
            update p_StreamsF;
        }
        
        system.debug('#################Update FL records Inserted: '+securityDeposit);
        paymCreation.genesis__Sequence__c = 1;
        paymCreation.genesis__Start_Date__c = dealerPaymentDate;
        paymCreation.genesis__Number_of_Payments__c = 1;
        paymCreation.genesis__Payment_Amount__c = securityDeposit;
        paymCreation.SAF_is_Finance_Lease__c = true;
        paymCreation.genesis__Payment_Frequency__c = 'MONTHLY';
        paymCreation.genesis__Application__c = strApplicationId;
        insert paymCreation;
    }
    
    // Deletion of Payment streams for Finance lease Applications
    public static void deletePaymentStream(string strApplicationId, boolean isFinancePaymentDeleted )
    {
        list<genesis__Payment_Stream__c> payStreamsDel = [Select Id, SAF_is_Finance_Lease__c, genesis__Sequence__c, genesis__Start_Date__c, PaymentEndDate__c,genesis__Number_of_Payments__c From genesis__Payment_Stream__c Where genesis__Application__c =:strApplicationId  order by genesis__Sequence__c ASC];
        genesis__Payment_Stream__c paymDeletion = new genesis__Payment_Stream__c();
        
        for(genesis__Payment_Stream__c p_StreamsFDel:payStreamsDel) 
        {
            if(p_StreamsFDel.genesis__Sequence__c == 1 && p_StreamsFDel.SAF_is_Finance_Lease__c)
            {
                system.debug('#################Update FL records Deleted');
                delete p_StreamsFDel;
                isFinancePaymentDeleted = true;
            }
            else if(isFinancePaymentDeleted)
            {
                system.debug('#################Update FL records updated other sequences: '+ (p_StreamsFDel.genesis__Sequence__c - 1));
                p_StreamsFDel.genesis__Sequence__c = p_StreamsFDel.genesis__Sequence__c - 1;
                update p_StreamsFDel;
            }
            system.debug('#################isFinancePaymentDeleted '+isFinancePaymentDeleted);
            system.debug('#################Update FL records Sequence: '+p_StreamsFDel.genesis__Sequence__c);
        }
    }
    // Added for Ticket No: #159931 Security deposit for Finance lease - Ends
    //Added For SAF DisplayLink Object Agreement No Update
    public static void updateSaflinkRecords(List<genesis__Applications__c> Application)
    {
        String     strApplicationId;
        String     strAgreementNo;//Added For DisplayLink
        if(Application.size() >0)
        {
            strApplicationId     = Application[0].Id;
            strAgreementNo = Application[0].Agreement_No__c;
            updateDisplaylink(strApplicationId,strAgreementNo);
        }
     }
            
    public static void updateDisplaylink(string strApplicationId, string strAgreementNo)
    {
        list<SAF_Document_Links__c> safDisplayLink= [SELECT Id,Name,Application__c,SAF_Agreement_Number__c,SAF_Sharepoint_Document_ID__c FROM SAF_Document_Links__c Where Application__c=:strApplicationId];
        SAF_Document_Links__c updatedislink = new SAF_Document_Links__c();
        for(SAF_Document_Links__c link_update:safDisplayLink) 
        {
           link_update.SAF_Agreement_Number__c = strAgreementNo;
           update link_update;
        }
    }
    
     public static void updateSaflinkRecords2(List<genesis__Applications__c> Application,list<SAF_Document_Links__c> lstdispLinks)
    {
        String     strApplicationId;
        String     strAgreementNo;//Added For DisplayLink
        if(Application.size() >0)
        {
            strApplicationId     = Application[0].Id;
            strAgreementNo = Application[0].Agreement_No__c;
            //list<SAF_Document_Links__c> safDisplayLink= [SELECT Id,Name,Application__c,SAF_Agreement_Number__c,SAF_Sharepoint_Document_ID__c FROM SAF_Document_Links__c Where Application__c=:strApplicationId];
            List<SAF_Document_Links__c> updatedislink = new List<SAF_Document_Links__c>();
            for(SAF_Document_Links__c link_update:lstdispLinks) 
            {
               link_update.SAF_Agreement_Number__c = strAgreementNo;
               updatedislink.add(link_update);
            }
            
            if(updatedislink.size()>0)
            { update updatedislink;}
        }
     }
}