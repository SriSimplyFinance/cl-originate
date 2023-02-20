(function(skuid){
skuid.snippet.register('Refresh Page (Not Used)',function(args) {var params = arguments[0],
	$ = skuid.$;

var InModel = skuid.model.getModel('Invoice');
//var appRow = InModel.data[0];
//parent.location = '/'+appRow.Id; 
window.location.reload();
});
skuid.snippet.register('Refresh Page',function(args) {var params = arguments[0],
	$ = skuid.$;
//window.location.reload();
parent.location.reload();
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
skuid.snippet.register('newSnippet',function(args) {var EQInModel = skuid.model.getModel('Equipment Invoice');
var EQInRow = EQInModel.data[0];
alert(EQInRow.Id);

var IsDelete = EQInRow.IsDeleted__c;

alert(IsDelete);

EQInModel.updateRow(EQInRow,'IsDeleted__c',true);

alert(IsDelete);
});
skuid.snippet.register('render button',function(args) {return true;
});
skuid.snippet.register('Validate Payables',function(args) {var params = arguments[0],
	$ = skuid.$;
var InModel = skuid.model.getModel('Invoice');
var InRow = InModel.data[0];
//alert(InRow.Id);

var TotalAppPayable = InRow.Total_Application_Payable_Amount__c;
var TotalGross = InRow.Total_Gross_Amount__c;
var ValidationCheck = InRow.Validated__c;

//alert(TotalAppPayable);
//alert(TotalGross);

if(TotalGross == TotalAppPayable && ValidationCheck === false){

//SaveModel
InModel.updateRow(InRow,'Validated__c',true);
InModel.updateRow(InRow,'Invoice_Status__c','Valid');
    skuid.model.save([InModel],{callback:function(result){
                if(result.totalsuccess){
                alert('INVOICE VALIDATED');    
                //alert('Saved');
                InModel.updateRow(InRow,'Validated__c',true);
                InModel.updateRow(InRow,'Invoice_Status__c','Valid');
                }else{
                    InModel.updateRow(InRow,'Validated__c',false);
                    InModel.updateRow(InRow,'Invoice_Status__c','Invalid');
                      alert('Error: ' + result.insertResults[0]);
                      console.log(result.insertResults[0]);
                }
            }}); 
} else if(TotalGross > TotalAppPayable && ValidationCheck === false){
    
    InModel.updateRow(InRow,'Validated__c',false);
    InModel.updateRow(InRow,'Invoice_Status__c','Invalid');
    alert('INVALID INVOICE: Application payables should be equal to the total amount of the invoice in order to be valid.');
    return false;


} else if(ValidationCheck === true){

    alert('This Invoice has already been validated.');
    return false;

}    else{
    InModel.updateRow(InRow,'Validated__c',false);
    InModel.updateRow(InRow,'Invoice_Status__c','Invalid');
   alert('INVALID INVOICE: Application payables should not exceed the total amount of the invoice. Please amend the Payables and try again.');
   return false;
}
});
}(window.skuid));