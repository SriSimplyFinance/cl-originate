/* The below class is used to update Future Rentals and Unearned Interest in Lease contract which calculates the sum of all Capital and sum of all Income for Future Rentals and Sum of all Income for Unearned Interest from Lease Income streams*/
public Class vls_updateContractRentalsFromStreams{
    
    @InvocableMethod 
    public static void updateContractRentals(){
    
        List<Id> IdsRentalstreams =new List<Id>();
        List<Id> rentalstreamsId =new List<Id>();
        Map<Id,Decimal> streamCapitalRecovery = new Map<Id,Decimal>();
        Map<Id,Decimal> streamIncome = new Map<Id,Decimal>();
        //Get the branch system date.
        User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c from user WHERE id =: UserInfo.getUserId()];
        Date systemDate= userRec.cllease__Current_Branch_s_System_Date__c;
        List<cllease__Rental_Stream__c > listRentalstreams = new List<cllease__Rental_Stream__c >();
        
        //Query for Capital and Income fields from Rental streams where date > system date and it to a list.
        list<AggregateResult> rentalStreams = [Select cllease__Contract__c contract From cllease__Rental_Stream__c Where cllease__Date__c > :systemDate group by cllease__Contract__c];
        for(AggregateResult e:rentalStreams){
            
            IdsRentalstreams.add((id)e.get('contract'));
            rentalstreamsId.add((id)e.get('contract'));
            
        }
        
        //Summing up all the capital and income values from Rental streams.
         AggregateResult[] arDeptSum = [Select SUM(cllease__Capital_Recovery__c) totalCapital, SUM(cllease__Lease_Income__c) totalIncome, cllease__Contract__c From cllease__Rental_Stream__c Where cllease__Contract__c IN :IdsRentalstreams and cllease__Date__c > :systemDate GROUP BY cllease__Contract__c];
         for(Integer i=0;i<rentalstreamsId.size();i++){
                
            for (AggregateResult ar : arDeptSum)  {
                    if(rentalstreamsId[i]==ar.get('cllease__Contract__c')){
                    
                    streamCapitalRecovery.put(IdsRentalstreams[i],(Decimal)ar.get('totalCapital'));
                    streamIncome.put(IdsRentalstreams[i],(Decimal)ar.get('totalIncome'));
               }
            }
        }
                   
        List<cllease__Lease_Account__c> leasecontract = [select name,Id,Future_Rentals__c,Unearned_Interest__c from cllease__Lease_Account__c
                 where id in :rentalstreamsId];
        for(cllease__Lease_Account__c cl:leasecontract) {
        
           // updating the values to lease contracts.
             cl.Future_Rentals__c = streamCapitalRecovery.get(cl.Id)+streamIncome.get(cl.Id);
             cl.Unearned_Interest__c = streamIncome.get(cl.Id);
           /*  if(cl.Future_Rentals__c == null || String.isBlank(String.valueOf(cl.Future_Rentals__c))){
                cl.Future_Rentals__c = 0.0;
             }
             if(cl.Unearned_Interest__c == null || String.isBlank(String.valueOf(cl.Unearned_Interest__c))){
                cl.Unearned_Interest__c = 0.0;
             }
             system.debug('FutureRentalsc ===='+cl.Future_Rentals__c);*/
        }
        try{
        update leasecontract; 
        }catch(DMLException e){
        
        }
    }   
    }