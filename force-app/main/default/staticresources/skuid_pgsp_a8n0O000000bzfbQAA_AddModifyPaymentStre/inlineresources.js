(function(skuid){
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
    $ = skuid.$;
//closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe']});

var AppModel = skuid.model.getModel('application');
var appRow = AppModel.data[0];
parent.location = '/'+appRow.Id+'?skuidonly=1';
});
skuid.snippet.register('newSnippet1',function(args) {var newAppParams = {};
var editorWrapper = $('#AppTitleHeader1'); 
var editor = editorWrapper.data('object').editor;

var AppModel = skuid.model.getModel('application');
var appRow = AppModel.data[0];
//alert(appRow.NewFieldAppDate);

var sequenceNo = skuid.page.params.sequenceNo;

var paymentSchModel = skuid.model.getModel('PaymentSchedule');

var paymentEndDateModel = skuid.model.getModel('paymentEndDate');
var paymentEndDateRow = paymentEndDateModel.data[0];
var returnVal = true;

var Psmodel = skuid.model.getModel('NewApplicationPS');
var Psrow = Psmodel.data[0];

editor.clearMessages();
if(sequenceNo > 1)
 { 
     var paymentSchrow = paymentSchModel.data[sequenceNo -1];
     //alert('paymentSchrow:' + paymentSchrow.genesis__Start_Date__c);
 }
 
// if(!Psrow.LastModifiedDate && (Psrow.genesis__Start_Date__c < appRow.NewFieldAppDate && (Psmodel.isRowNew(Psrow) || Psrow.genesis__Sequence__c === 1))) 
// {
//   // alert('Start Date should be greater than previous payment scheduled date.');
//     editor.handleMessages( 
        
//         [{
           
//             message: 'Start date should be greater than Previous Payment schedule end date or Expected First Payment Date.', 
//             severity: 'ERROR'
//         }]
     
//     );
//     returnVal = false;
// }

var isTransact__c           = Psmodel.getFieldValue(Psrow,'isTransact__c');
if(Psmodel.isRowNew(Psrow) && isTransact__c)
{
    Psmodel.updateRow(Psrow,'Start_Date_Proposal__c',appRow.NewFieldAppDate);
}

//Psmodel.updateRow(Psrow,'genesis_Sequence_Number__c',sequenceNo);

if(Psrow.genesis__Start_Date__c < appRow.NewFieldAppDate && Psmodel.isRowNew(Psrow)) 
{
  // alert('Start Date should be greater than previous payment scheduled date.');
    editor.handleMessages( 
        
        [{
           
            message: 'Start date should be greater than Previous Payment schedule end date or Expected First Payment Date.', 
            severity: 'ERROR'
        }]
     
    );
    returnVal = false;
}

if(sequenceNo > 1) // Condition added for second row onwards not for first row 
{
    // if(!Psmodel.isRowNew(Psrow) && sequenceNo < paymentSchModel.data.length) 
    // {
       
    //     editor.handleMessages( 
            
    //         [{
               
    //             message: 'You can edit only the last sequence of Payment Schedule.', 
    //             severity: 'ERROR'
    //         }]
         
    //     );
    
    //   returnVal = false;
    // }
    if(!Psmodel.isRowNew(Psrow) && sequenceNo === paymentSchModel.data.length && Psrow.genesis__Start_Date__c < paymentSchrow.genesis__Start_Date__c) 
    {
      //alert('Edit');
      
        editor.handleMessages( 
            
            [{
                message:  'Start date should be greater than Previous Payment schedule end date or Expected First Payment Date.', 
                severity: 'ERROR'
            }]
         
        );
    
       returnVal = false;
    }
}

/*var gn_maturitydate = appRow.genesis_Maturity_date__c;
 alert('gn_maturitydate' +gn_maturitydate);
if(Psmodel.isRowNew(Psrow) && Psrow.genesis__Start_Date__c > gn_maturitydate) 
{
   
    editor.handleMessages( 
        
        [{
           
            message: 'Scheduled Payment date has crossed Maturity date.', 
            severity: 'ERROR'
        }]
     
    );

   returnVal = false;
}*/

 var NoPayments = Psmodel.getFieldValue(Psrow,'genesis__Number_of_Payments__c',true);
 var Paymentamount = Psmodel.getFieldValue(Psrow,'genesis__Payment_Amount__c',true);
 var pattern = /^\d+$/;
 var patternDecimal = /^\d{1,6}(\.\d{1,2})?$/;
//  alert('NoPayments' +NoPayments);
if (!pattern.test(NoPayments) || !patternDecimal.test(Paymentamount)) {
    
   editor.handleMessages( 
        
        [{
           
            message: 'Invalid Number Format.', 
            severity: 'ERROR'
        }]
     
    );
    returnVal = false;
}
if(Psrow.genesis__Number_of_Payments__c <= 0 || Psrow.genesis__Number_of_Payments__c === undefined) 
{
    editor.handleMessages( 
        
        [{
           
            message: 'Number of Payments should be greater than 0.', 
            severity: 'ERROR'
        }]
     
    );
    returnVal = false;
}
if(Psrow.genesis__Payment_Amount__c <= 0 || Psrow.genesis__Payment_Amount__c === undefined) 
{
    editor.handleMessages( 
        
        [{
           
            message: 'Payment Amount should be greater than 0.', 
            severity: 'ERROR'
        }]
     
    );
    returnVal = false;
}
if(Psrow.genesis__Start_Date__c === null) 
{
    editor.handleMessages( 
        
        [{
           
            message: 'Please enter start Date.', 
            severity: 'ERROR'
        }]
     
    );
    returnVal = false;
}

//alert(returnVal); 
/*if(returnVal)
{
    Psrow.count = 1;
    Psmodel.updateRow(Psrow, 'count', 1);
            Psmodel.save();
            alert(Psrow.count);
}*/
return returnVal;
});
(function(skuid){
	var $ = skuid.$;
	
	$(document.body).one('pageload',function(){
		$(document).on( "keydown",".datepickerOnly input", function (evt) { 
    	        evt.preventDefault();
    	    });
	});
})(skuid);;
skuid.snippet.register('deleteConditions',function(args) {var newAppParams = {};
var editorWrapper = $('#AppTitleHeader1'); 
var editor = editorWrapper.data('object').editor;

// var sequenceNo = skuid.page.params.sequenceNo;

// var paymentSchModel = skuid.model.getModel('NewApplicationPS');

// var paymentSchData = [];
// paymentSchData = paymentSchModel.data;

//var i = 0;
//for(i=0;i<paymentSchData.length;i++)
//{
//    paymentSchModel.updateRow(paymentSchData[i],'genesis__Sequence__c',i+1);
//}

//skuid.model.save([paymentSchModel]);
});
skuid.snippet.register('notToDisplay',function(args) {var params = arguments[0],
	$ = skuid.$;
return false;
});
skuid.snippet.register('reorder',function(args) {var newAppParams = {};
var editorWrapper = $('#AppTitleHeader1'); 
var editor = editorWrapper.data('object').editor;

var sequenceNo = skuid.page.params.sequenceNo;

var paymentSchModel = skuid.model.getModel('PaymentSchedule');
var applicationModel = skuid.model.getModel('application');

var paymentSchData = [];
paymentSchData = paymentSchModel.data;
applicationDataRow = applicationModel.data[0];

var i = 0;
for(i=0;i<paymentSchData.length;i++)
{
    paymentSchModel.updateRow(paymentSchData[i],'genesis__Sequence__c',i+1);
    // if(i === 0)
    // {
    //     applicationModel.updateRow(applicationDataRow,'genesis__Dealer_Payment_Date__c',paymentSchData[i].genesis__Start_Date__c);
    // }
}

skuid.model.save([paymentSchModel]);
//skuid.model.save([applicationModel]);
});
skuid.snippet.register('NetProfit',function(args) {var params = arguments[0],
	$ = skuid.$,
    updates = params.updates;

var appModel = skuid.model.getModel('application');
var appRow = appModel.data[0];
alert(appRow.Id);

//var docfee = appRow.Documentation_Fee__c;
//var otpfee = appRow.genesis_Option_to_purchase_Fee__c;
//var secfee = appRow.Total_Security_Deposit__c;

//alert(docfee);
//alert(otpfee);
var psModel = skuid.model.getModel('SumPs');
var psRow = psModel.data[0];
alert(psRow.spay);
var feesModel = skuid.model.getModel('FeesTransact');
var feesRow = feesModel.data[0];
alert(feesRow.spay);
//alert(appRow.Total_Gross_Asset_Cost__c);
//alert(appRow.Total_Security_Deposit__c);
var sum = (psRow.spay);
var feesum =(feesRow.sumFees);
alert(sum);
alert(feesum);
var netprofit = sum - (appRow.Balance_finance_transact__c * 1.05) +  feesum;
alert('net:' + netprofit);
if(netprofit > 0){
//appRow.saf_NetProfit__c = netprofit;
appModel.updateRow(appRow,'saf_NetProfit__c',netprofit);
//appModel.save();

    skuid.model.save([appModel],{callback:function(result){
                if(result.totalsuccess){
                //alert('Saved');
                alert('saf_NetProfit__c:'+appModel.data[0].saf_NetProfit__c);
                }else{
                // I have no idea what insert results are but if it works for you...
                // There was a problem. Let's see what went wrong.
                      alert('Error: ' + result.insertResults[0]);
                      console.log(result.insertResults[0]);
                }
            }});
}else{
    appModel.updateRow(appRow,'saf_NetProfit__c','0');
}
//skuid.model.save([applicationModel]);
// appModel.updateRow(appRow, 'Is_Contract_created__c', true);
});
}(window.skuid));