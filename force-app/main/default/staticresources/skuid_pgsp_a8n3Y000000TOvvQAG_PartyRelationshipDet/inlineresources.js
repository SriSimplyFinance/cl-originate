(function(skuid){
skuid.snippet.register('CreditScoreSimpleView',function(args) {var params = arguments[0],
        $ = skuid.$;
    
    var simpleView = {
        render: function(item) {
            item.element.html('<div class="credit-score-row"><span class="credit-score-value">'+item.row.genesis__Score__c+'</span><span class="credit-score-type">'+item.row.ints__ModelNameType__c+'</span>');
        }
    };
    
    return simpleView;
});
skuid.snippet.register('LaunchCreditReportView',function(args) {var params = arguments[0],
        $ = skuid.$;
    
    var party = skuid.model.getModel('NGParty');
    var url = party.getFirstRow().genesis__Credit_Report__r.ints__Credit_Report_Attachment__c;
    var reportId = url.substring(url.lastIndexOf('/')+1);
    var title = 'Credit Report';
    var iframeUrl = '/servlet/servlet.FileDownload?file=' + reportId;
            
    openTopLevelDialog({
        title: title,
        iframeUrl: iframeUrl
    });
});
skuid.snippet.register('DisplayDefaultZero',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

value = value === null ? 0 : value;
var renderer = skuid.ui.fieldRenderers[field.metadata.displaytype];
renderer.readonly(field, value);
});
skuid.snippet.register('generateMessageCreditPullConfirmation',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];

var contactModel = skuid.model.getModel('PartiesContact');
var contact = contactModel.data[0];

var appId = party.genesis__Application__c;
var partyId = contact.Id;
var partyName = party.clcommon__Account__r.Name;

var title = 'Get Credit Report of ' + partyName;
var message = '<p>Are you sure you want to get the credit report of <strong>' 
                + partyName + '</strong>?</p>';
var cancelText = "No, do not get it.";
var okText = "Yes, Continue.";
var okAction = {
    func: 'getCreditReport',
    parameters: [appId, partyId, partyName]
};

openTopLevelConfirmation({
    title: title,
    message: message,
    cancelText: cancelText,
    okText: okText,
    okAction: okAction
});
});
skuid.snippet.register('LaunchCreditHistoryView',function(args) {var params = arguments[0],
    $ = skuid.$;

var party = skuid.model.getModel('NGParty');
var model = party.getFirstRow();
var partyId = model.Id;
var partyName = model.clcommon__Account__r.Name;
var title = 'Credit Report History of ' + partyName;
var skuidPage = 'CreditHistoryPage';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchEditPartyDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

var party = skuid.model.getModel('NGParty');
var model = party.getFirstRow();
var partyId = model.Id;
var partyName = model.clcommon__Account__r.Name;
var title = 'Edit ' + partyName;
var skuidPage = 'EditBorrowingStructure';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('RenderColumnWIthExternalLink',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var url = '/' + field.row.Id;
field.element.html('<a href="' + url + '" target="_blank">' + value + '</a>');
});
skuid.snippet.register('RenderAccountStatusColumn',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var message = value ? 'Active' : 'Not Active';

field.element.text(message);
});
skuid.snippet.register('LaunchCovenants',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyRow = skuid.model.getModel('NGParty').data[0];
var partyId = partyRow.Id;
var title = 'Active Covenants for ' + partyRow.clcommon__Account__r.Name;
var skuidPage = 'RelationshipCovenant';

var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCopyPartyDialog',function(args) {var params = arguments[0],
    $ = skuid.$;
    
var partyRow = skuid.model.getModel('NGParty').getFirstRow();
var title = 'Copy ';
if(partyRow.clcommon__Account__r && partyRow.clcommon__Account__r.Name){
    title = title + partyRow.clcommon__Account__r.Name + ' to Applications';
}
var skuidPage = 'CopyParty';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyRow.Id;
openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('deletePartyConfirmation',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var partyId = party.Id;
var title = 'Delete Party ';
if(party.clcommon__Account__r && party.clcommon__Account__r.Name){
    title = title + party.clcommon__Account__r.Name;
}
if(party.clcommon__Type__r && party.clcommon__Type__r.Name){
    title = title + ' ' + party.clcommon__Type__r.Name;
}
var message = '<p><strong>Are you sure you want to delete this party</strong>?</p>';
var cancelText = "Cancel";
var okText = "Yes, Continue";
var okAction = {
    func: 'deleteParty',
    parameters: [partyId]
    
};

openTopLevelConfirmation({
    title: title,
    message: message,
    cancelText: cancelText,
    okText: okText,
    okAction: okAction
});

parent.location.reload(true);
});
skuid.snippet.register('LaunchFinancialAccounts',function(args) {var params = arguments[0],
  $ = skuid.$;
var appId = skuid.page.params.id;
var title = 'Financial Accounts';
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var skuidPage = 'FinancialAccounts';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + party.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchLoanOpportunity',function(args) {var params = arguments[0],
  $ = skuid.$;
var appId = skuid.page.params.id;
var title = 'Loan Opportunities';
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var skuidPage = 'LoanOpportunities';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + party.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCreditAnalysis',function(args) {var params = arguments[0],
  $ = skuid.$;
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var appId = skuid.page.params.id;
var title = 'Credit Analysis';
var skuidPage = 'CreditAnalysis';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + party.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('PRD_LaunchFinancialStatementAnalysis',function(args) {var $ = skuid.$;

var party = skuid.model.getModel('NGParty').data[0];
if(party.clcommon__Account__c){
    var title = 'Financial Analysis - ' + party.clcommon__Account__r.Name;
    var skuidPage = 'AccountStatements';
    
    // get template id
    var templateRecord = skuid.model.getModel('PRD_ApplicableFinancialStatementTemplate').data[0];
    var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&accountid=' + party.clcommon__Account__c + '&templateid=' + templateRecord.Id;
    
    openTopLevelDialog({
        title: title,
        iframeUrl: iframeUrl
    });
}
});
skuid.snippet.register('RefreshParty',function(args) {var params = arguments[0],
	$ = skuid.$;
	alert('refresh');
//window.location.reload();
parent.location.reload();
});
}(window.skuid));