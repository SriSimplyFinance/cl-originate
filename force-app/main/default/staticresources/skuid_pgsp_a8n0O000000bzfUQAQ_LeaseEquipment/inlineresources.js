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
skuid.snippet.register('UpdateRelationshipIFrame',function(args) {var params = arguments[0],
  $ = skuid.$;

var url = $('#relationship-iframe').attr('src');
if (url.lastIndexOf('&id=') >= 0) {
    url = url.substring(0, url.lastIndexOf('&id=')) + '&id=' + params.row.Id;
} else {
    url += '&id=' + params.row.Id;
}

$('#relationship-iframe').attr('src', url);
$('#relationship-iframe').hide();
$('#relationship-iframe').on('load', function() {
    $("#relationship-iframe").show();
});
});
skuid.snippet.register('newSnippet',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyModel = skuid.model.getModel('AppEquipmentModel');
var party = partyModel.data[0];
var partyId = party.Id;
var title = 'Delete Equipment '
/*if(party.clcommon__Account__r && party.clcommon__Account__r.Name){
    title = title + party.clcommon__Account__r.Name;
}
if(party.clcommon__Type__r && party.clcommon__Type__r.Name){
    title = title + ' ' + party.clcommon__Type__r.Name;
}*/
var message = '<p><strong>Are you sure you want to delete this Equipment</strong>?</p>';
var cancelText = "Cancel";
var okText = "Yes, Continue";
var okAction = {
    func: 'deleteEquipment',
    parameters: [partyId]
};

openTopLevelConfirmation({
    title: title,
    message: message,
    cancelText: cancelText,
    okText: okText,
    okAction: okAction
});
});
skuid.snippet.register('refreshPage',function(args) {$('#sk-icon-save').click(function() {
    location.reload(true);
});
});
}(window.skuid));