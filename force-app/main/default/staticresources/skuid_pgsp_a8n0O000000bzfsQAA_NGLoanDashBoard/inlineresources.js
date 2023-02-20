(function(skuid){
skuid.snippet.register('SelectFirstEntryInQueue',function(args) {var params = arguments[0],
  $ = skuid.$;

$(function() {
    var pageInclude = skuid.$('#relationship-dashboard').data('object');
    if(pageInclude !== undefined){
        pageInclude.load(function() {
            clickQueueEntry(true, sessionStorage.selectedPartyId);
        });
    }
});

function clickQueueEntry(force, partyId) {
    sessionStorage.removeItem('selectedPartyId');
    if (partyId) {
        var clickIndex = 0;
        $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
            if (party.Id === partyId) {
                clickIndex = index;
                return false;
            }
        });
        $($('#relationship-queue .nx-item.nx-queue-item')[clickIndex]).trigger('click');
    } else {
        if (force) {
            $($('#relationship-queue .nx-item.nx-queue-item')[0]).trigger('click');
        }
    }
}
});
skuid.snippet.register('AdjustLayoutRelationshipDashboard',function(args) {var params = arguments[0],
  $ = skuid.$;

if (sessionStorage.refreshParty) {
    sessionStorage.removeItem('refreshParty');
    var pageInclude = skuid.$('#relationship-dashboard').data('object');
    pageInclude.load(function() {
        clickQueueEntry(true, sessionStorage.selectedPartyId);
    });
} else {
    clickQueueEntry(false, sessionStorage.selectedPartyId);
}

function clickQueueEntry(force, partyId) {
    skuid.model.updateData([skuid.model.getModel('DashboardParty')],function(){
        if (partyId) {
            var clickIndex = 0;
            $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
                if (party.Id === partyId) {
                    clickIndex = index;
                    return false;
                }
            });
            $($('#relationship-queue .nx-item.nx-queue-item')[clickIndex]).trigger('click');
        } else {
            if (force) {
                $($('#relationship-queue .nx-item.nx-queue-item')[0]).trigger('click');
            }
        }
    });
}
});
skuid.snippet.register('LaunchEditLoanDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var appRowData = skuid.model.getModel('NGLDApplication').data[0];
var appId = appRowData.Id;
var title = "Edit Application " + appRowData.Name;
var skuidPage = 'ApplicationForm__Edit';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCreditMemoDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Credit Memo';
var skuidPage = 'CreditMemo';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchChangeMemoDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var title = 'Manage Change Memo';

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var skuidPage = 'ChangeMemos';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
  title: title,
  iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchFeeDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Fees';
var skuidPage = 'Fees';

// launchSimplePopupDialog(appId, title, skuidPage);

var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchPolicyExceptionDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'Manage Policy Exceptions';
var skuidPage = 'PolicyExceptions';

// launchSimplePopupDialog(appId, title, skuidPage);

var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('AddTooltipCollateralTab',function(args) {var params = arguments[0],
  $ = skuid.$;

$(function() {
    var pageInclude = skuid.$('#collateral-tab').data('object');
    pageInclude.load(function() {
        openLinksInNewTab();
      showIconicBtnLabelAsTooltip();
    });
});
});
skuid.snippet.register('LaunchLoanHistoryDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'View Renewal History';
var skuidPage = 'RenewalHistory';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCovenantsDialog',function(args) {var params = arguments[0],
  $ = skuid.$;
var appId = skuid.model.getModel('NGLDApplication').data[0].Id;
var title = 'View Covenants';
var skuidPage = 'ApplicationCovenant';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('refreshDocument',function(args) {var params = arguments[0],
  $ = skuid.$;

if(sessionStorage.refreshDocument) {
    sessionStorage.removeItem('refreshDocument');
    $('#document-iframe')[0].contentWindow.postMessage({type: 'action-refresh-tree-details'}, '*');
}
console.log('Parent window is invoked');
});
(function(skuid){
  var $ = skuid.$;
  $(document.body).one('pageload',function(){
      showIconicBtnLabelAsTooltip();
      
      var applicationData = skuid.model.getModel('NGLDApplication').getFirstRow();
      if(applicationData && applicationData.genesis__Product_Type__c && applicationData.genesis__Product_Type__c == 'PACKAGE'){
          $('#loan-dashboard-parties-section').css('top','0');
          $('#loan-dashboard-parties-section').css('bottom','0');
           
      }
    
    
    if(document.location.href.indexOf('#Proposal') !== -1)
    {
          var tabset = $('#cls-originate-page');
          var tabPanels = tabset.children('.ui-tabs-panel');
          var targetTabIndex = tabPanels.filter(window.location.hash).index() - 1;
          tabset.tabs('option','active',targetTabIndex);
          window.location.hash = '';
        
    }
  
    skuid.snippet.getSnippet('buttonsPosition')();


  });
})(skuid);;
skuid.snippet.register('ConvertToContract',function(args) {var appModel = skuid.model.getModel('NGLDApplication');
var appRow = appModel.data[0];

//alert(appRow.Id);
//alert(appRow.Name); 


try {
   if(!appRow.Is_Contract_created__c){
        var ret = sforce.apex.execute('genesis.ConvertApplicationCtrl','convertApplicationToContract',
       {   
           appId : appRow.Id
       });
       alert(ret);
       if(ret == 'Application is converted to contract successfully') {
            appModel.updateRow(appRow, 'Is_Contract_created__c', true);
            var ret = sforce.apex.execute("SAF_ValidateApplication","onConvert",{AppId:appRow.Id});
            //var ret1 = sforce.apex.execute("DeleteProposalFeeOnLease","deleteRecords",{AppId:appRow.Id});
            appModel.save();
       }
   }
   else {
       alert('This application is already converted');
   }
}
   catch(err) {
   alert(err);
}
window.location.reload();
});
skuid.snippet.register('newSnippet',function(args) {console.log('Syed console is called ');
var params = arguments[0],
	$ = skuid.$;

console.log('Parent window is invoked');
});
skuid.snippet.register('RegenrateStreams',function(args) {var contractModel = skuid.model.getModel('LeaseContract');
var contractRow = contractModel.data[0];

alert(contractRow.Id);
alert(contractRow.Name); 


try {
   var ret = sforce.apex.execute('cllease.RegenerateStreamsCtrl','FinregenerateStreams',
   {   
       leaseAccId : contractRow.Id,
       FinancedAmount1 : contractRow.cllease__Financed_Amount__c
   });
   alert(ret);
   
   }
   catch(err) {
   alert(err);
}
window.location.reload();
});
skuid.snippet.register('ConvertNgenerate',function(args) {var appModel = skuid.model.getModel('NGLDApplication');
var appRow = appModel.data[0];

alert(appRow.Id);
//alert(appRow.Name); 


try {
   if(!appRow.Is_Contract_created__c){
        var ret = sforce.apex.execute('genesis.ConvertApplicationCtrl','convertApplicationToContract',
       {   
           appId : appRow.Id
       });
       alert(ret);
       console.log(ret);
       if(ret == 'Application is converted to contract successfully') {
           appRow.Is_Contract_created__c = true;
           appModel.updateRow(appRow, 'Is_Contract_created__c', true);
           var contractModel = skuid.model.getModel('LeaseContract');
           //Generate streams
            var contractRow = contractModel.data[0];
            
            alert(contractRow.Id);
            alert(contractRow.Name); 
            
            
            try {
               var ret = sforce.apex.execute('cllease.RegenerateStreamsCtrl','FinregenerateStreams',
               {   
                   leaseAccId : contractRow.Id,
                   FinancedAmount1 : contractRow.cllease__Financed_Amount__c
               });
               alert(ret);
               
               }
               catch(err) {
               alert(err);
            }

           
            skuid.model.save([appModel],{callback:function(result){
                if(result.totalsuccess){
                alert('Saved');
                alert('Boolean:'+appModel.data[0].Is_Contract_created__c);
                }else{
                // I have no idea what insert results are but if it works for you...
                // There was a problem. Let's see what went wrong.
                      alert('Error: ' + result.insertResults[0]);
                      console.log(result.insertResults[0]);
                }
            }}); 
       }
   }
   else {
       alert('This application is already converted');
   }
}
   catch(err) {
   alert(err);
}
window.location.reload();
});
skuid.snippet.register('ChangeApplicationStatus',function(args) {var params = arguments[0],
	$ = skuid.$;
var appModel = skuid.model.getModel('NGLDApplication');
var appRow = appModel.getFirstRow();



try {
    var ret = sforce.apex.execute("SAF_ValidateApplication","onConvert",{AppId:appRow.Id});
 
}
catch(err) {
    alert(err);
}
window.location.reload();
});
skuid.snippet.register('NetAssetCostValidation',function(args) {var appModel = skuid.model.getModel('NGLDApplication');
var appRow = appModel.data[0];

//alert(appRow.Id);
//alert(appRow.Name); 

// var params = arguments[0];
// var  stepEditor = params.editor, $ = skuid.$;
// stepEditor.clearMessages();
// stepEditor.handleMessages(
//         [
//           {
//               message: 'Unable to Convert Application data.',
//               severity: 'ERROR'
//           },
//         ]
//     );

if(appRow !== null && (appRow.Total_Net_Asset_Cost__c > (appRow.genesis__Financed_Amount__c*1.1)))
{
    alert('Total net asset cost('+ appRow.Total_Net_Asset_Cost__c +') should be less than or equal to Proposed net asset cost('+ appRow.genesis__Financed_Amount__c +')');
    return false;
}
else
{
    return true;
}
});
skuid.snippet.register('SAF_UpdateApplicationStatus',function(args) {var appModel = skuid.model.getModel('NGLDApplication');
var appRow = appModel.data[0];

// Added for Change Request #159440: 27 - Supplier Validation - Starts

var appRowData = skuid.model.getModel('NGLDApplication').data[0];
var appId = appRowData.Id;
var partyModel = skuid.model.getModel('DashboardParty');
var partyData = [];
partyData = partyModel.data;

var i = 0;
var canBeSubmitted = false;

for(i=0;i<partyData.length;i++)
{
    if(partyData[i].Party_type_name__c === 'VENDOR' || partyData[i].Party_type_name__c === 'DEALER')
    {
        canBeSubmitted = true;
    }
}

if(!canBeSubmitted && appRow.genesis_Unapproved_Supplier__c !== undefined)
{
    canBeSubmitted = true;
}

// Added for Change Request #159440: 27 - Supplier Validation - Ends

if(canBeSubmitted === true) // Added this condition for Change Request #159440: 27 - Supplier Validation
{
    var r=confirm("Are you sure to submit the application for Approval"); // Moved from 3rd line, for Change Request #159440: 27 - Supplier Validation
    if(r===true)
    {
        try 
        {
            var ret = sforce.apex.execute("SAF_ValidateApplication","Validatestatus",{AppId:appRow.Id});
            if(ret=='failure'){alert('Please ensure party have been added');}
        }
        catch(err) 
        {
            alert(err);
        }
        //window.location.reload();
        window.location = '/'+appRow.Id;
        window.location.reload();
        //skuid.$('.ui-dialog-content').dialog('close');
        //parent.location = '/'+appRow.Id;
        //window.location = '/'+appRow.Id;
    }
}
else
{
    alert('Please ensure there is a Supplier associated to the proposal before submitting to underwriting');
}
});
skuid.snippet.register('AddAttachmentsModal',function(args) {var params = arguments[0],
	$ = skuid.$;
var selectDocument = skuid.model.getModel('DocumentCategoryDetails').data[0];

console.log(selectDocument);
//var title = 'Add Application Documents to ' + selectDocument.Name; 
var skuidPage = 'ApplicationAttachmentList';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + selectDocument.Id;
//var prefixHtml = '<div><p>Select the following application documents that have not been added to any application document category and add them to <strong>' + selectDocument.Name + '</strong>.</p></div>';
openTopLevelDialog({
	title: 'Document Upload',
	iframeUrl: iframeUrl,
	type : 'alert'
	//prefixHtml: prefixHtml
});
});
skuid.snippet.register('buttonsPosition',function(args) {var params = arguments[0],
	$ = skuid.$;

    var copybtn = 0,editbtn=0,addbtn=0; 
    
    copybtn = $( ".wrapper-title-custom .iconic-button-copy").is(":visible")?(2):0;
    
    if(copybtn === 0)
    {
        editbtn = $( ".wrapper-title-custom .iconic-button-edit").is(":visible")?(2):0;
    }
    else
    {
        editbtn = $( ".wrapper-title-custom .iconic-button-edit").is(":visible")?(copybtn+7):0;
    }
    
    if(copybtn === 0 && editbtn === 0)
    {
        addbtn = $( ".wrapper-title-custom .iconic-button-add").is(":visible")?(2):0;
    }
    else if(copybtn > 0 && editbtn === 0)
    {
        addbtn = $( ".wrapper-title-custom .iconic-button-copy").is(":visible")?(copybtn+7):0;
    }
    else if(copybtn === 0 && editbtn > 0)
    {
        addbtn = $( ".wrapper-title-custom .iconic-button-edit").is(":visible")?(editbtn+7):0;
    }
    else if(copybtn > 0 && editbtn > 0)
    {
        addbtn = $( ".wrapper-title-custom .iconic-button-edit").is(":visible")?(editbtn+7):0;
    }
    
    $( ".wrapper-title-custom .iconic-button-copy:visible" ).css('left',copybtn+'%');
    $( ".wrapper-title-custom .iconic-button-edit:visible" ).css('left',editbtn+'%');
    $( ".wrapper-title-custom .iconic-button-add:visible" ).css('left',addbtn+'%');
});
skuid.snippet.register('GotoProposal',function(args) {var params = arguments[0],
	$ = skuid.$;

    var appModel = skuid.model.getModel('SafDocumentlinksProposal');
  
    if (appModel.data.length !== 0)
    {
       
      var appRow = appModel.data[0];
   
       var maxlen = appRow.Document_Path__c.lastIndexOf('/'); 
       var fileFolder = appRow.Document_Path__c.substring(0,maxlen);
       //alert(fileFolder);   
      var customerName = appRow.Application__r.genesis__Account__r.Name.replace('/','');
	  var url =  'https://simplyfinance.sharepoint.com/sites/CLO-Test/SAFDocuments/' + customerName + '/' + appRow.Application__r.Name + '/Proposal/';//APP-0000001203/Transact/';
      alert(url); 
      alert(appRow.Application__r.Name);
	  window.open(url, '_blank');
  
   }else {   alert("No documents in Proposal folder");   }
});
skuid.snippet.register('GotoProposalfolder',function(args) {var params = arguments[0],
	$ = skuid.$;

    var appModel = skuid.model.getModel('NGLDApplicationProposal');
  
    if (appModel.data.length !== 0)
    {
       
      var appRow = appModel.data[0];
   
      // var maxlen = appRow.Document_Path__c.lastIndexOf('/'); 
      // var fileFolder = appRow.Document_Path__c.substring(0,maxlen);
      var SP_appCreated = appRow.SAF_SPAppfoldercheck__c;
     //alert(SP_appCreated);
      var folderId = appRow.genesis__Account__r.SAF_Sharepoint_Folder_ID__c;
      //alert(folderId); 
      if(SP_appCreated === false)//if(folderId !== undefined)
      {
           alert("Please wait.....");
          var documentInfo = sforce.apex.execute("SAF_Custom_FolderCreation","sendApplicationDocToSharePointCustom",{appId:appRow.Id});
          //console.log(resultJSON.content[0].Id);
         
          if(documentInfo!=Error)
          {
              appModel.updateRow(appRow, 'SAF_SPAppfoldercheck__c', true);
          var customerName = appRow.genesis__Account__r.Name.replace(/[|,||//\\,|.|"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\|)\\{|\\}|\\;|\\\"|\\\\|']/g, '');
          var label = skuid.utils.mergeAsText("global","{{$Label.Sharepoint_URL}}");
    	  var url =  label + customerName + '/' + appRow.Name + '/Proposal/';//APP-0000001203/Transact/';
          //alert(url);  
    	  window.open(url, '_blank');
    	  appModel.save();
          }
          else {   alert("No folders created in sharepoint.");   }
      }
      else {   
         // alert(SP_appCreated);
          var customerName = appRow.genesis__Account__r.Name.replace(/[|,||//\\,|.|"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\|)\\{|\\}|\\;|\\\"|\\\\|']/g, '');
          var label = skuid.utils.mergeAsText("global","{{$Label.Sharepoint_URL}}");
    	  var url =  label + customerName + '/' + appRow.Name + '/Proposal/';//APP-0000001203/Transact/';
          //alert(url);  
    	  window.open(url, '_blank');   } 
    }else {   alert("No folders created in sharepoint.");   }
});
skuid.snippet.register('TitlePositionAdjustment',function(args) {var params = arguments[0],
	$ = skuid.$;
    var appModel = skuid.model.getModel('NGLDApplication');
    var appRow = appModel.data[0];
    //var appRowData = skuid.model.getModel('NGLDApplication').data[0];
    //var CustomerName = appRowData.Account;
    //alert(appRow.genesis__Account__r.Name);
    //alert(appRow.genesis__Account__r.Name.length);
    
    if((skuid.model.getModel('LeaseContract').data.length) < 1)
    {
        var elementStyleCust = document.getElementById("CustomerIdTmp").style;
        elementStyleCust.position = "absolute"; // relative
        elementStyleCust.top = "78px";
        
        //alert('test');
        var custNameLen = appRow.genesis__Account__r.Name.length;
        //alert('custNameLen');
        if(appRow.genesis__Account__r.Name.length <= 59)
        {
            var elementStyle = document.getElementById("LoanDetailsTmp").style;
            elementStyle.position = "absolute"; // relative
            
            elementStyle.top = "96px"; // 1 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 08+'px'); // 1 lines
        }
        else if(appRow.genesis__Account__r.Name.length > 59 && appRow.genesis__Account__r.Name.length <= 134)
        {
            var elementStyle = document.getElementById("LoanDetailsTmp").style;
            elementStyle.position = "absolute"; // relative
            
            elementStyle.top = "116px"; // 2 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 27+'px'); // 2 lines
        }
        else if(appRow.genesis__Account__r.Name.length > 134  && appRow.genesis__Account__r.Name.length <= 208)
        {
            var elementStyle = document.getElementById("LoanDetailsTmp").style;
            elementStyle.position = "absolute"; // relative
            
            elementStyle.top = "133px"; // 3 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 44+'px'); // 3 lines
        }
        else if(appRow.genesis__Account__r.Name.length > 208)
        {
            var elementStyle = document.getElementById("LoanDetailsTmp").style;
            elementStyle.position = "absolute"; // relative
            
            elementStyle.top = "148px"; // 4 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 60+'px'); // 4 lines
        }
    }
    else
    {
        var nameLen = appRow.genesis__Account__r.Name.length;
        var elementStyle = document.getElementById("LoanDetailsTmp").style;
        elementStyle.position = "absolute"; // relative
        
        if(appRow.genesis__Account__r.Name.length < 59)
        {
            elementStyle.top = "116px"; // 1 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 27+'px'); // 1 lines
        }
        else if(appRow.genesis__Account__r.Name.length > 59 && appRow.genesis__Account__r.Name.length <= 134)
        {
            elementStyle.top = "133px"; // 2 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 44+'px'); // 2 lines
        }
        else if(appRow.genesis__Account__r.Name.length > 134  && appRow.genesis__Account__r.Name.length <= 208)
        {
            elementStyle.top = "148px"; // 3 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 60+'px'); // 3 lines
        }
        else if(appRow.genesis__Account__r.Name.length > 208)
        {
            elementStyle.top = "168px"; // 4 lines
            $(".cls-dashboard-section .nx-pagetitle .nx-pagetitle-maintitle").css('padding-bottom', 80+'px'); // 4 lines
        }
    }
});
skuid.snippet.register('GoToZohoDocs',function(args) {var params = arguments[0],
	$ = skuid.$;

    var appModel = skuid.model.getModel('NGLDApplicationProposal');       
    var appRow = appModel.data[0];
    var folderId = appRow.Zoho_Documentation__c;
    //alert(folderId);
    var url = folderId;
    window.open(url,'blank');
    appModel.save();
});
skuid.snippet.register('Conga',function(args) {var params = arguments[0],
	$ = skuid.$;

// variables represent queries from Conga Solution 'Application Documents'. Please do not change unless requested
    var appModel = skuid.model.getModel('NGLDApplicationProposal');  
    //alert(appModel);
    var appRow = appModel.data[0];
    //alert(appRow);
    var Id = appRow.Id;
    //alert(Id);
    var ServerURL = appRow.API_Partner_Server_For_Conga_ONLY__c;
   // alert(ServerURL);
    var APP = '[APPCLO]a9U0O000000XcKt';
    var EQ = '[EQCLO]a9U0O000000XcLN';
    var AC = '[ACCLO]a9U0O000000XcKy';
    var GUARANTOR= '[GUARANTOR]a9U0O000000XcLI';
    var label = '/apex/APXTConga4__Conga_Composer?SolMgr=1&serverUrl=';
    var CongaUrl = label+ServerURL+'&Id='+Id+'&QueryId='+ APP +','+ EQ +','+ AC +','+GUARANTOR+'&TemplateGroup=CLOApplication&LiveEditVisible=1&LiveEditEnable=1';

    //alert(CongaUrl);
    alert('Please Wait...');
    var url = CongaUrl;
    window.open(url,'popUpWindow','height=650,width=1150,left=100,top=50,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes');
    appModel.save();
});
skuid.snippet.register('AdjustLayoutIndirectDashboard',function(args) {var params = arguments[0],
  $ = skuid.$;

if (sessionStorage.refreshParty) {
    sessionStorage.removeItem('refreshParty');
    var pageInclude = skuid.$('#relationship-dashboard2').data('object');
    pageInclude.load(function() {
        clickQueueEntry(true, sessionStorage.selectedPartyId);
    });
} else {
    clickQueueEntry(false, sessionStorage.selectedPartyId);
}

function clickQueueEntry(force, partyId) {
    skuid.model.updateData([skuid.model.getModel('DashboardParty')],function(){
        if (partyId) {
            var clickIndex = 0;
            $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
                if (party.Id === partyId) {
                    clickIndex = index;
                    return false;
                }
            });
            $($('#relationship-queue2 .nx-item.nx-queue-item')[clickIndex]).trigger('click');
        } else {
            if (force) {
                $($('#relationship-queue2 .nx-item.nx-queue-item')[0]).trigger('click');
            }
        }
    });
}
});
skuid.snippet.register('SelectFirstEntryInQueueIndirect',function(args) {var params = arguments[0],
  $ = skuid.$;

$(function() {
    var pageInclude = skuid.$('#relationship-dashboard2').data('object');
    if(pageInclude !== undefined){
        pageInclude.load(function() {
            clickQueueEntry(true, sessionStorage.selectedPartyId);
        });
    }
});

function clickQueueEntry(force, partyId) {
    sessionStorage.removeItem('selectedPartyId');
    if (partyId) {
        var clickIndex = 0;
        $.each(skuid.model.getModel('DashboardParty').data, function(index, party) {
            if (party.Id === partyId) {
                clickIndex = index;
                return false;
            }
        });
        $($('#relationship-queue2 .nx-item.nx-queue-item')[clickIndex]).trigger('click');
    } else {
        if (force) {
            $($('#relationship-queue2 .nx-item.nx-queue-item')[0]).trigger('click');
        }
    }
}
});
}(window.skuid));