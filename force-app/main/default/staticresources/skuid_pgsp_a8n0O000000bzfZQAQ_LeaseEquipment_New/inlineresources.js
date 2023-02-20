(function(skuid){
skuid.snippet.register('calcFinAmt',function(args) {// Get reference to our Application model
var appModel = skuid.$M('AppEquipmentModel'); 
// Get reference to the first row
var appRow = appModel.getFirstRow();
try {
    var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', { 
            applicationId : appRow.genesis__Application__c 
        }
    );
    console.log(result); 
} catch (err) {
    console.log('Error getting pricing: ' + err.description);
}
});
skuid.snippet.register('newSnippet',function(args) {var params = arguments[0],
	$ = skuid.$;
  closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,relationship-iframe']});
});
skuid.snippet.register('yearOfManufature',function(args) {myElement.addClass('hide-datepicker-calendar').datepicker({
     changeMonth: true,
     changeYear: true,
     showButtonPanel: true,
     dateFormat: 'MM yy',
     onClose: function(dateText, inst) { 
         var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
         var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
         $(this).datepicker('setDate', new Date(year, month, 1));
     }
});
});
skuid.snippet.register('newSnippetRefresh',function(args) {var params = arguments[0],
	$ = skuid.$;
//window.location.reload();
parent.location.reload();
});
skuid.snippet.register('ValidateEquipment',function(args) {var newAppParams = {};
var editorWrapper1 = $('div#Equipementheader'); 
var editor1 = editorWrapper1.data('object').editor;

var EquipmentModel = skuid.model.getModel('AppEquipmentModel');
var EquipmentRow = EquipmentModel.data[0];
var returnVal = true;

alert('EquipmentRow:' + EquipmentRow.Id);
//alert('seq:' + Psrow.genesis__Sequence__c);
//alert('total:' + paymentSchModel.data.length);
editor1.clearMessages();

if(EquipmentRow.genesis_Equipment_Description__c === null || EquipmentRow.genesis_Equipment_Description__c === '') 
{
   alert('Please enter description of Equipment.');
    editor1.handleMessages( 
        
        [{
           
            message: 'Please enter description of Equipment.', 
            severity: 'ERROR'
        }]
     
    );

   returnVal = false;
}

alert(returnVal); 
return returnVal;
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
    $ = skuid.$;
closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe']});
});
skuid.snippet.register('RefreshPage',function(args) {var params = arguments[0],
	$ = skuid.$;

var AppModel = skuid.model.getModel('AppEquipmentModel1');
//var appRow = AppModel.data[0];
//parent.location = '/'+appRow.Id; 
window.location.reload();
});
skuid.snippet.register('showOnlyYear',function(args) {var params = arguments[0],
$ = skuid.$;
var pikVal = [];
var d = new Date();
var n = d.getFullYear();

    for(var a=1970;a<n;a++)
    {
        pikVal.push({label: a+1, value: a+1});
    }
    pikVal.reverse();
    return pikVal;
});
}(window.skuid));