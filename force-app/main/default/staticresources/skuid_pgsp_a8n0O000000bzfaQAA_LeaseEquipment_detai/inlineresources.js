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
skuid.snippet.register('newSnippetRefresh',function(args) {var params = arguments[0],
	$ = skuid.$;
//window.location.reload();
parent.location.reload();
});
skuid.snippet.register('LaunchEditEquipmentDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

var equipment = skuid.model.getModel('AppEquipmentModel');
var model = equipment.getFirstRow();
var equipmentId = model.Id;
// var partyName = model.clcommon__Account__r.Name;
var title = 'Edit ' + equipmentId;
var skuidPage = 'LeaseEquipment__details';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + equipmentId;
alert(iframeUrl);
openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('showOnlyYear',function(args) {var params = arguments[0],
$ = skuid.$;
var pikVal = [];
var d = new Date();
var n = d.getFullYear();

    for(var a=1969;a<n;a++)
    {
        pikVal.push({label: a+1, value: a+1});
    }
    pikVal.reverse();
    return pikVal;
});
skuid.snippet.register('refresh',function(args) {var params = arguments[0],
	$ = skuid.$;
//closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,relationship-iframe']});

var AppModel = skuid.model.getModel('AppEquipmentModel');
var appRow = AppModel.data[0];

//parent.location = '/'+appRow.genesis__Application__c; +'#Equipment'
//parent.location.reload();
//parent.location+'#Equipment';
window.location.reload();
});
}(window.skuid));