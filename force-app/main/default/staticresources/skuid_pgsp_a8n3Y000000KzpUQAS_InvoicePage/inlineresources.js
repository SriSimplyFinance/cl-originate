(function(skuid){
skuid.snippet.register('Refresh Page',function(args) {var params = arguments[0],
	$ = skuid.$;

var InModel = skuid.model.getModel('Invoice');
//var appRow = InModel.data[0];
//parent.location = '/'+appRow.Id; 
window.location.reload();
});
skuid.snippet.register('Deposit Validation Check',function(args) {var InModel = skuid.model.getModel('Invoice');
var InRow = InModel.data[0];
//alert(InRow.Id);

var TotalPayable = InRow.Total_Payable__c;
var TotalSupplier = InRow.Total_Paid_To_Supplier__c;

//alert(TotalPayable);
//alert(TotalSupplier);

if(TotalSupplier < TotalPayable){

//SaveModel
InModel.updateRow(InRow,'Deposit_Validation_Check__c',true);
    skuid.model.save([InModel],{callback:function(result){
                if(result.totalsuccess){
                //alert('Saved');
                InModel.updateRow(InRow,'Deposit_Validation_Check__c',true);
                }else{
                    InModel.updateRow(InRow,'Deposit_Validation_Check__c',false);
                      alert('Error: ' + result.insertResults[0]);
                      console.log(result.insertResults[0]);
                }
            }}); 
}else{
    InModel.updateRow(InRow,'Deposit_Validation_Check__c',false);    
   alert('The Total Supplier is greater than the Total Payable. Please ensure that the total supplier added across all assets do not exceed the total payable amount.');
   return false;
}
});
skuid.snippet.register('newSnippet',function(args) {var params = arguments[0],
	$ = skuid.$;

var InModel = skuid.model.getModel('Invoice');
var InRow = InModel.data[0];
alert(InRow.Id);

var PayableAmount = InRow.Total_Gross_Amount__c - InRow.Deposit_Paid_To_Supplier__c;

alert(PayableAmount);

InModel.updateRow(InRow,'Payable_Amount_For_Auto_Generation__c',Payable_Amount__c);

alert(Payable_Amount_For_Auto_Generation__c);
});
}(window.skuid));