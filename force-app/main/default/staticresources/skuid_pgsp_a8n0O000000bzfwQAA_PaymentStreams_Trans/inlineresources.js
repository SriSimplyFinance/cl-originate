(function(skuid){
skuid.snippet.register('LaunchAddEditPaymentStreamDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.page.params.id;
var title = 'Add New Payment Schedule ';
var index = $('.'+params.row.Id).attr('index');

var ApplicationPaymentStreamsModel = skuid.model.getModel('ApplicationPaymentStreams');
var ifNewRow = ApplicationPaymentStreamsModel.data.length;

if(index === undefined)
{
    index = ApplicationPaymentStreamsModel.data.length+1;
}

skuidPage = 'AddModifyPaymentStreams__Transact';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&appId=' + appId+ '&sequenceNo='+index;

if(params && params.row && params.row.Name){
    title = 'Edit Payment Schedule';
    iframeUrl = iframeUrl + '&id=' + params.row.Id+ '&sequenceNo='+index;
}

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));