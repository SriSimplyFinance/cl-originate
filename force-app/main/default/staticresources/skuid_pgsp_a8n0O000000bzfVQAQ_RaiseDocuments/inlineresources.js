(function(skuid){
skuid.snippet.register('SAF_documentRaised',function(args) {var appModel = skuid.model.getModel('ApplicationModel');
var appRow = appModel.getFirstRow();



try {
    var ret = sforce.apex.execute("SAF_ValidateApplication","ValidateDocumentRaised",{AppId:appRow.Id});
 
}
catch(err) {
    alert(err);
}
window.location.reload();
});
skuid.snippet.register('documentReceived',function(args) {var appModel = skuid.model.getModel('ApplicationModel');
var appRow = appModel.getFirstRow();



try {
    var ret = sforce.apex.execute("SAF_ValidateApplication","ValidateDocumentCollected",{AppId:appRow.Id});
 
}
catch(err) {
    alert(err);
}
window.location.reload();
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
skuid.snippet.register('customRenderRefField',function(args) {var field = arguments[0],


    value = arguments[1];



if (field.mode === 'read') {


    field.element.append(skuid.$('<div>').addClass('nx-fieldtext').text(field.model.getFieldValue(field.row,skuid.utils.getFieldReference(field.id,field.metadata))));


} else {


    skuid.ui.fieldRenderers[field.metadata.displaytype][field.mode](field,value);


}
});
skuid.snippet.register('customDelete',function(args) {var params = arguments[0],
	$ = skuid.$;
$("#data tr").click(function() {
    $(this).toggleClass("highlight");
});
});
(function(skuid){
	var $ = skuid.$;
	$('head').append(
        $('<base target="_blank">')
    );
	
	$(document.body).one('pageload',function(){
        $(document).on('click','.fa-times-circle',function()
        {
            var trElem = $(this).parents('tr');
            if(trElem.hasClass('highlight')){
                trElem.removeClass('highlight');
            }
            else{
                trElem.addClass('highlight');
            }
        })
        
         var modelDoc = skuid.model.getModel('DocusignTemplate');
        var ret = sforce.apex.execute("Docusigntemplates","getdata",{});
        modelDoc.updateData(); 
        
        var model_one = skuid.model.getModel('ApplicationModel');
		
		//alert(model_one.data[0].SAF_Contra_Agreement_number__c);
		
		if(model_one.data[0].SAF_Contra_Agreement_number__c != undefined && model_one.data[0].SAF_Contra_Agreement_number__c != null)
		{
        	var model_two = skuid.model.getModel('contract1');
            model_two.setCondition(model_two.getConditionByName("agreement"), model_one.data[0].SAF_Contra_Agreement_number__c.split(";"));
            model_two.activateCondition(model_two.getConditionByName("agreement"));
            model_two.updateData(); 
		}
        
        //quote // TerminationQuote
        if(model_one.data[0].SAF_Contra_TerminationQuote__c != undefined && model_one.data[0].SAF_Contra_TerminationQuote__c != null)
		{
            var model_three = skuid.model.getModel('TerminationQuote');
            model_three.setCondition(model_three.getConditionByName("quote"), model_one.data[0].SAF_Contra_TerminationQuote__c.split(";"));
            model_three.activateCondition(model_three.getConditionByName("quote"));
            model_three.updateData(); 
            
            /*var atmt = model_three.data;
            var i=0;
            alert(atmt.length);
            for(i=0; i<atmt.length;i++)
            {
                alert(model_three.data[i].id+' - Contract: '+ model_three.data[i].cllease__Contract__r.Name);
            }*/
            var model_four = skuid.model.getModel('ContraAttachment');
            model_four.setCondition(model_four.getConditionByName("parentid"), model_one.data[0].SAF_Contra_Agreement_number__c.split(";"));
            model_four.activateCondition(model_four.getConditionByName("parentid"));
            model_four.updateData(); 
		}
	});
})(skuid);

function ContractTablepopup(){
    var model_one = skuid.model.getModel('ApplicationModel');
    
    if(model_one.data[0].SAF_Contra_Agreement_number__c != undefined && model_one.data[0].SAF_Contra_Agreement_number__c != null)
    {
        $xml = skuid.utils.makeXMLDoc;
        var popupXMLString = 
    
        '<popup width="50%" title="Contract">'
            + '<components>'
                +'<skootable showconditions="true" showsavecancel="false" showerrorsinline="true" searchmethod="server" searchbox="false" showexportbuttons="false" hideheader="false" hidefooter="false" pagesize="10" alwaysresetpagination="false" createrecords="false" model="contract1" buttonposition="" mode="readonly">'
                        +'<fields>'
                            +'<field id="Name"/>'
                        +'</fields>'
                        +'<rowactions/>'
                        +'<massactions usefirstitemasdefault="true"/>'
                        +'<views>'
                            +'<view type="standard"/>'
                        +'</views>'
                        +'<searchfields/>'
                        +'<renderconditions logictype="and"/>'
                    +'</skootable>'
            + '</components>'
        + '</popup>';
        //+'<javascript>         <jsitem location="inlinesnippet" name="ContractRequest" cachelocation="false" url="">var $ = skuid.$;';
    
        var popupXML = $xml(popupXMLString);
        
        var context = {};
        
        var popup = skuid.utils.createPopupFromPopupXML(popupXML, context);
    }
    else
    {
        alert('No Agreements are linked');
    }

}

function QuoteTablepopup(){
    var model_one = skuid.model.getModel('ApplicationModel');
    if(model_one.data[0].SAF_Contra_TerminationQuote__c != undefined && model_one.data[0].SAF_Contra_TerminationQuote__c != null)
    {
        $xml = skuid.utils.makeXMLDoc;
        var popupXMLString = 
    
        '<popup width="90%" title="Termination Quote">'
            + '<components>'
                +'<skootable showconditions="true" showsavecancel="false" showerrorsinline="true" searchmethod="server" searchbox="false" showexportbuttons="false" hideheader="false" hidefooter="false" pagesize="10" alwaysresetpagination="false" createrecords="false" model="TerminationQuote" buttonposition="" mode="readonly">'
                        +'<fields>'
                            +'<field id="Name"/>'
                            +'<field id="cllease__Contract__c"/>'
                        +'</fields>'
                        +'<rowactions/>'
                        +'<massactions usefirstitemasdefault="true"/>'
                        +'<views>'
                            +'<view type="standard"/>'
                        +'</views>'
                        +'<searchfields/>'
                        +'<renderconditions logictype="and"/>'
                    +'</skootable>'
            + '</components>'
        + '</popup>';
        //+'<javascript>         <jsitem location="inlinesnippet" name="ContractRequest" cachelocation="false" url="">var $ = skuid.$;';
    
        var popupXML = $xml(popupXMLString);
        
        var context = {};
        
        var popup = skuid.utils.createPopupFromPopupXML(popupXML, context);
    }
    else
    {
        alert('No Termination Quotes are linked');
    }
};
skuid.snippet.register('checkRows',function(args) {var params = arguments[0],
	$ = skuid.$;
	var trElem = $(this).parents('tr');
	alert(trElem.html);
	console.log(trElem.html);
	var args = arguments[0];
	console.log(args);
//$(document).on('click','.fa-times-circle',function()
  //      {
            //var trElem = $(this).parents('tr');
            // if(trElem.hasClass('highlight')){
            //     trElem.removeClass('highlight');
            // }
            // else{
            //     trElem.addClass('highlight');
            // }
        //})
});
skuid.snippet.register('NetAssetCostValidation',function(args) {var appModel = skuid.model.getModel('ApplicationModel');
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
skuid.snippet.register('ConvertToContract',function(args) {var appModel = skuid.model.getModel('ApplicationModel');
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
skuid.snippet.register('updatePaymentStartDate',function(args) {var newAppParams = {};
var editorWrapper = $('#sk-1duroQ-93'); 
var editor = editorWrapper.data('object').editor;

var paymentSchModel = skuid.model.getModel('ApplicationPaymentStreams');
var paymentSchModelPrev = skuid.model.getModel('ApplicationPaymentStreams_Previous');
var applicationModel = skuid.model.getModel('ApplicationModel');

var paymentSchData = [];
paymentSchData = paymentSchModel.data;
paymentSchDataPrev = paymentSchModelPrev.data;
applicationDataRow = applicationModel.data[0];


// alert("Length: "+paymentSchData.length);
// var i = 0;
// for(i=0;i<paymentSchData.length;i++)
// {
//     skuid.model.updateData([paymentSchModelPrev]);
//     var prevDate;
//     if(i === 0)
//     {
//         //alert(applicationDataRow.genesis__Dealer_Payment_Date__c);
//         paymentSchModel.updateRow(paymentSchData[i],'genesis__Start_Date__c',applicationDataRow.genesis__Dealer_Payment_Date__c);
//         alert(paymentSchData[i].PaymentEndDate__c);
//         skuid.model.save([paymentSchModel]);
//         prevDate = paymentSchData[i].PaymentEndDate__c;
//         alert(prevDate);
//     }
//     else
//     {
//         alert(prevDate);
//         paymentSchModel.updateRow(paymentSchData[i],'genesis__Start_Date__c',prevDate);
//         skuid.model.save([paymentSchModel]);
//         prevDate = paymentSchData[i].PaymentEndDate__c;
//     }
// }

//skuid.model.save([paymentSchModel]);
//alert("saved");
// var j=0;
// skuid.model.updateData([paymentSchModel]);
// for(j=0;j<paymentSchData.length;j++)
// {
//     alert(paymentSchData[j].PaymentEndDate__c);
// }
//skuid.model.save([paymentSchModel]);
//skuid.model.save([applicationModel]);
});
skuid.snippet.register('UpdateIncomeFeedateTransact',function(args) {var params = arguments[0],
	$ = skuid.$;

var feeRow,appRow;
var ApplicationModel = skuid.model.getModel('ApplicationModel');

if(ApplicationModel)
appRow = ApplicationModel.data[0];

var FeeScheduleTransactIncomeModel = skuid.model.getModel('IncomeFees');
if(FeeScheduleTransactIncomeModel)
{
    feeRow = FeeScheduleTransactIncomeModel.data;
}

if(appRow && appRow.genesis__Dealer_Payment_Date__c)
{
    FeeScheduleTransactIncomeModel.updateRow(feeRow[0],'genesis__Start_Date__c',appRow.genesis__Dealer_Payment_Date__c);
}
});
skuid.snippet.register('UpdateTransactExpenseFeeDate',function(args) {var params = arguments[0],
	$ = skuid.$;

var feeRow,appRow;
var ApplicationModel = skuid.model.getModel('ApplicationModel');

if(ApplicationModel)
appRow = ApplicationModel.data[0];

var FeeScheduleTransactExpenseModel = skuid.model.getModel('ExpenseFee');
if(FeeScheduleTransactExpenseModel)
{
    feeRow = FeeScheduleTransactExpenseModel.data;
}

if(appRow && appRow.genesis__Expected_Start_Date__c)
{
    FeeScheduleTransactExpenseModel.updateRow(feeRow[0],'genesis__Start_Date__c',appRow.genesis__Expected_Start_Date__c);
}
});
skuid.snippet.register('ApplicationConga',function(args) {var params = arguments[0],
	$ = skuid.$;


var appModel = skuid.model.getModel('ApplicationModel');
var appRow = appModel.data[0]; 
 




if(appRow.Id !== null)
{
    
    		    
	         var ret = sforce.apex.execute("OriginateCongaController","hpLesae",
       {   
	   
           appId : appRow.Id
       });
       alert(ret);
       window.location.reload();
     

}
else
{
		       alert('Application id is null');
}
});
skuid.snippet.register('GoToTransact',function(args) {var params = arguments[0],
	$ = skuid.$;

    var appModel = skuid.model.getModel('safdocumentlinksTransact');
  
    if (appModel.data.length !== 0)
    {
       
      var appRow = appModel.data[0];
   
       var maxlen = appRow.Document_Path__c.lastIndexOf('/'); 
       var fileFolder = appRow.Document_Path__c.substring(0,maxlen);
       //alert(fileFolder);   
	  var customerName = appRow.Application__r.genesis__Account__r.Name.replace(/[|,||//\\,||"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\|\\|\\{|\\}|\\;|\\\"|\\\\|]/g, '');
	  var url =  'https://simplyfinance.sharepoint.com/sites/CLO-Test/SAFDocuments/' + customerName + '/' + appRow.Application__r.Name + '/Transact/';//APP-0000001203/Transact/';
      //alert(url);  
	  window.open(url, '_blank');
  
    } else {   alert("No documents in Transact folder");   }
});
skuid.snippet.register('refreshApppage',function(args) {window.location.reload();
});
skuid.snippet.register('GotoTransactfolder',function(args) {var params = arguments[0],
	$ = skuid.$;

    var appModel = skuid.model.getModel('ApplicationModelTransact');
  
    if (appModel.data.length !== 0)
    {
       
      var appRow = appModel.data[0];
   
      // var maxlen = appRow.Document_Path__c.lastIndexOf('/'); 
      // var fileFolder = appRow.Document_Path__c.substring(0,maxlen);
      
      var folderId = appRow.genesis__Account__r.SAF_Sharepoint_Folder_ID__c;
      //alert(folderId); 
     // if(folderId !== undefined)
     // {
          
          var customerName = appRow.genesis__Account__r.Name.replace(/[|,||//\\,|.|"||:|~|!|@|#|$|%|^|*|_|+|=|<|>|?|\\(|\\|)\\{|\\}|\\;|\\\"|\\\\|']/g, '');
          var label = skuid.utils.mergeAsText("global","{{$Label.Sharepoint_URL}}");
    	  var url =  label + customerName + '/' + appRow.Name + '/Transact/';//APP-0000001203/Transact/';
          //alert(url);  
    	  window.open(url, '_blank');
      }
      else {   alert("No folders created in sharepoint.");   }
});
skuid.snippet.register('activateBrokeredOut',function(args) {var appModel = skuid.model.getModel('ApplicationModel');
var appRow = appModel.getFirstRow();



try {
    var ret = sforce.apex.execute("SAF_ValidateApplication","ActivateBrokeredOut",{AppId:appRow.Id});
 
}
catch(err) {
    alert(err);
}
window.location.reload();
});
skuid.snippet.register('ExperianCongareport',function(args) {var appModel = skuid.model.getModel('ApplicationModelTransact');
  
    if (appModel.data.length !== 0)
    {
       
      var appRow = appModel.data[0];
   
      // var maxlen = appRow.Document_Path__c.lastIndexOf('/'); 
      // var fileFolder = appRow.Document_Path__c.substring(0,maxlen);
        var accId=appRow.genesis__Account__c; 
        var expId=appRow.genesis__Account__r.AccountNumber; 
        var OwnershipValue=appRow.genesis__Account__r.Ownership; 
        var accname=appRow.genesis__Account__r.Name;
        accname = accname.replace(/[|,||//\\,|.|"||:|~|!|@|#|$|%|^|*|_|&|+|=|<|>|?|\\(|\\|)\\{|\\}|\\;|\\\"|\\\\|']/g, '');
     // var folderId = appRow.genesis__Account__r.SAF_Sharepoint_Folder_ID__c;
      alert(expId + OwnershipValue + accId);
       var result = sforce.apex.execute("Saf_Experian_data_processing","isExperianExists", {CompRegNo:expId,Accountid:accId}); 

        if(result == 'true') 
        { 
            var r = confirm("Report got generated in last 3 months only, Would you like to generate it again!"); 
            if (r === true) 
            { 
            var result = sforce.apex.execute("Saf_Experian_data_processing","ExperianUpdate", {CompRegNo:expId,Accountid:accId,Ownership:OwnershipValue}); 
            alert(result); 
            window.location.reload(); 
            } 
        } 
        else 
        { 
            var result = sforce.apex.execute("Saf_Experian_data_processing","ExperianUpdate", {CompRegNo:expId,Accountid:accId,Ownership:OwnershipValue}); 
            alert(result); 
            window.location.reload(); 
        }
       
      
     if(result !== undefined)
      {
         skuid.model.getModel('Application_Attachment1').updateData(); 
         
        var ret = sforce.apex.execute("OriginateCongaExperian","experian",
       {   
	   
           expId : result,CustName : accname
       });
       alert(ret);
       
       window.location.reload();
         // var url = 'https://testsso--safdev--apxtconga4.cs88.visual.force.com/apex/Conga_Composer?SolMgr=1&serverUrl=https%3A%2F%2Ftestsso--Safdev.cs88.my.salesforce.com%2Fservices%2FSoap%2Fu%2F37.0%2F00D9E0000001B8c&Id='+result+'&QueryId=[SAFEQ1]a9I9E00000003p9,[GE]a9I9E00000002rn,[CDH]a9I9E00000003t1,[ExperianPreviousSear]a9I9E00000003sw,[CD]a9I9E00000003t6,[ExperianScoringData]a9I9E00000003tB,[CorporateStructure]a9I9E00000003tL,[sicinfo]a9I9E00000003tQ,[scoreHistory]a9I9E00000003ta,[scoreHistoryDates]a9I9E00000003tf,[HistoricalScore]a9I9E00000003tk,[HSSameIndGroup]a9I9E00000003tp,[HSSameAssetSizeGroup]a9I9E00000003tu,[HSallScoredCompanies]a9I9E00000003tz,[FinanceAccounts]a9I9E0000008SWv,[ratios]a9I9E0000008SX0,[paymentFull]a9I9E0000008SX5,[CompanyDBTMonthly]a9I9E0000008SXA,[IndDBTMonthly]a9I9E0000008SXF,[LegalNotice]a9I9E0000008SXK,[sicinfo1980]a9I9E0000008SXP,[mortage]a9I9E0000008SXU,[sharecapital]a9I9E0000008SXZ,[shareholderdetails]a9I9E0000008SXe,[shareholdertype]a9I9E0000008SXj,[PreviousDirector]a9I9E0000008SXo,[CurrentSeceratory]a9I9E0000008SXt,[PreviousSecretary]a9I9E0000008SXy,[StatutoryDocs]a9I9E0000008SY3,[AlertNote]a9I9E0000008SY8,[cashflow]a9I9E0000008SYD,[FAProfitloss]a9I9E0000008SYI,[cifas]a9I9E0000008SYN&TemplateId=a9Q9E0000001x7u&DS7=1';
    	 // var url =  label + customerName + '/' + appRow.Name + '/Transact/';//APP-0000001203/Transact/';
    	 //var url = 'https://testsso--safdev--apxtconga4.cs88.visual.force.com/apex/Conga_Composer?SolMgr=1&serverUrl=https%3A%2F%2Ftestsso--Safdev.cs88.my.salesforce.com%2Fservices%2FSoap%2Fu%2F37.0%2F00D9E0000001B8c&Id='+result+'&QueryId=[SAFEQ1]a9I9E00000003p9,[GE]a9I9E00000002rn,[CDH]a9I9E00000003t1,[ExperianPreviousSear]a9I9E00000003sw,[CD]a9I9E00000003t6,[ExperianScoringData]a9I9E00000003tB,[CorporateStructure]a9I9E00000003tL,[sicinfo]a9I9E00000003tQ,[scoreHistory]a9I9E00000003ta,[scoreHistoryDates]a9I9E00000003tf,[HistoricalScore]a9I9E00000003tk,[HSSameIndGroup]a9I9E00000003tp,[HSSameAssetSizeGroup]a9I9E00000003tu,[HSallScoredCompanies]a9I9E00000003tz,[FinanceAccounts]a9I9E0000008SWv,[ratios]a9I9E0000008SX0,[paymentFull]a9I9E0000008SX5,[CompanyDBTMonthly]a9I9E0000008SXA,[IndDBTMonthly]a9I9E0000008SXF,[LegalNotice]a9I9E0000008SXK,[sicinfo1980]a9I9E0000008SXP,[mortage]a9I9E0000008SXU,[sharecapital]a9I9E0000008SXZ,[shareholderdetails]a9I9E0000008SXe,[shareholdertype]a9I9E0000008SXj,[PreviousDirector]a9I9E0000008SXo,[CurrentSeceratory]a9I9E0000008SXt,[PreviousSecretary]a9I9E0000008SXy,[StatutoryDocs]a9I9E0000008SY3,[AlertNote]a9I9E0000008SY8,[cashflow]a9I9E0000008SYD,[FAProfitloss]a9I9E0000008SYI,[cifas]a9I9E0000008SYN,[CAISD]a9I9E0000004IgM,[CAISSUM]a9I9E0000004Igb,[CIFASSum]a9I9E0000004IhF,[CCJD]a9I9E0000004Iir,[IDBTLimit2]a9I9E0000004Ij1,[CDBTlimit2]a9I9E0000004Iiw&TemplateId=a9Q9E0000001x7f&Defaultpdf=1&DS7=1&SC0=1&SC1=Attachments';
          //alert(url);  
    	 // window.open(url, '_blank');
      }
      }
      else {   alert("No Application records found.");   }
});
skuid.snippet.register('partysnippet',function(args) {// var myTable = skuid.$('#my-table').data('object');
// var selectedItems = list.getSelectedItems();
// $.each(selectedItems, function (i, item) {
//     console.log(i + ' - ' + item);
// });
  var  stream_model = skuid.model.getModel('ApplicationPaymentStreams');
  var  BAmodel = skuid.model.getModel('BankAccount');
  var Appmodel = skuid.model.getModel('ApplicationModel');
     var appRow = Appmodel.data[0];
  //var Equipmentmodel = skuid.model.getModel('ApplicationModel');
  

    var parties = skuid.model.getModel('Parties');

    var list = parties.data;
var selItems;
    skuid.$.each(parties.registeredLists,function(){
     selItems = this.getSelectedItems();
});

var objpartysel = {};
$.each(selItems,function(i,items){
    
 if(items.row && !items.row.clcommon__Account__r.clcommon__Email__c)
 {
      alert('Please populate Email field');
 }else
 {
     objpartysel[i] = items.row.clcommon__Account__r.Id;
     //alert(objpartysel[i]);
 }

    
});

 
    var templates = skuid.model.getModel('DocusignTemplate');
    var lsttemp = templates.data;
    var selItemstemp;
    skuid.$.each(templates.registeredLists,function(){
     selItemstemp = this.getSelectedItems();
});
var validIds = {};
$.each(selItemstemp,function(i,items){
    
 if(items.row && !items.row.Template_ID__c)
 {
      alert('Please select valid template');
 }else
 {
     validIds[i] = items.row.Template_ID__c;
     if(appRow.Equipment_Count__c > 3 &&  (items.row.Template_ID__c === '5977a6aa-1c6c-4b26-a198-aacec756a11e' || items.row.Template_ID__c === '32b5f6d7-e51d-4e41-88c4-bfb92b858752'|| items.row.Template_ID__c === 'ec0932eb-988e-4d29-ad2b-1b78e6e03a71'|| items.row.Template_ID__c === '1217cf67-0b2d-48c4-aae5-73962710c66c'))
     {
          i=i+1;
          validIds[i] = 'e9a19be4-a8bb-464b-b0b5-2127233a1a13'; // Equipment schedule template
     }
       if(stream_model.data.length > 2 &&  (items.row.Template_ID__c === '32b5f6d7-e51d-4e41-88c4-bfb92b858752'|| items.row.Template_ID__c === 'ec0932eb-988e-4d29-ad2b-1b78e6e03a71'|| items.row.Template_ID__c === '1217cf67-0b2d-48c4-aae5-73962710c66c'))
     {
          i=i+1;
          validIds[i] = '49783fa6-5fff-42bb-bd96-c2aca0fcfd2e'; //'22fef527-f1bd-417f-9bba-cd18cb299165'; //payment schedule for HP and S+HP
     }
     if(stream_model.data.length > 2 && items.row.Template_ID__c === '5977a6aa-1c6c-4b26-a198-aacec756a11e') //Lease Agreement template 
     {
        i=i+1;
        validIds[i] = '921390ae-f7c0-496e-8cdf-bf48c9865c58' ; //Payment schedule Lease template
     }
 }

    
});
     
    if(selItemstemp.length === 0 || selItems.length === 0 || appRow.Equipment_Count__c === 0 || stream_model.data.length === undefined || BAmodel.data.length === undefined ||  stream_model.data.length === 0 || BAmodel.data.length === 0)
    {
         alert('Please ensure template, party, equipment, and payments have been added. ');
    }
    else 
    { 
          //alert(JSON.stringify(validIds)); 
          var result = sforce.apex.execute("Saf_DocuSignEnevelope","CreateEnvelopeRequetbody", {templates:JSON.stringify(validIds),objpartyIds:JSON.stringify(objpartysel),genappId:appRow.Id,straccountId:appRow.genesis__Account__c}); 
          //alert(result);
           if(result === 'ERROR')
          {
             alert(result); 
          }
          else
          {
             
              var ret = sforce.apex.execute("SAF_ValidateApplication","ValidateDocumentRaised",{AppId:appRow.Id});  
              window.open(result, '_blank');
             
          }
         /* if(result !== 'ERROR')
          {
            window.open(result, '_blank');
          }
          else
          {     
              var ret = sforce.apex.execute("SAF_ValidateApplication","ValidateDocumentRaised",{AppId:appRow.Id});  
              window.open(result, '_blank');
               alert(result); 
          }*/
        
    }
});
skuid.snippet.register('calculateXIRR',function(args) {var appModel = skuid.model.getModel('ApplicationModel');
var appRow = appModel.data[0];


    var ret = sforce.apex.execute('ApplicationXIRRCtrl','calcuateApplicationXIRR',
    {   
        applicationId : appRow.Id
    });

    if(ret == 'XIRR Calculated successfully.') {
        alert(ret);
        window.location.reload();
    }
   else {
       alert(ret);
   }
});
skuid.snippet.register('ValidatePayables',function(args) {var feeModel = skuid.model.getModel('ExpenseFee1');
var feeModel2 = skuid.model.getModel('ExpenseFee');
var InvoiceModel = skuid.model.getModel('Invoice');
var InvoiceModel2 = skuid.model.getModel('Invoice1');
var ApplicationModel = skuid.model.getModel('ApplicationModel');
var appRow = ApplicationModel.data[0];

  alert(InvoiceModel.getRows().length);
if(feeModel2.getRows().length > 0 && feeModel.getRows().length != feeModel2.getRows().length)
{
    alert('Please add party in Expense Fee to create Commission records');
}else if(InvoiceModel2.getRows().length > 0 && InvoiceModel2.getRows().length != InvoiceModel.getRows().length )
{
     alert('Please add Invoice details to create dealer funding records.');
} 
else 
{
             ApplicationModel.updateRow(appRow, 'genesis__Status__c', 'READY TO CONVERT');
             skuid.model.save([ApplicationModel],{callback:function(result){
                if(result.totalsuccess){
                alert('Saved');
                //alert('Boolean:'+InvoiceModel.data[0].Is_Contract_created__c);
                }else{
                // I have no idea what insert results are but if it works for you...
                // There was a problem. Let's see what went wrong.
                      alert('Error: ' + result.insertResults[0]);
                      console.log(result.insertResults[0]);
                }
            }}); 
    
}
});
skuid.snippet.register('Contra',function(args) {var res = str.split(" ");
//alert('Agreement Ids: '+appRow.SAF_Contra_Agreement_numbers__c);
var Agrnames;
if(appRow.SAF_Contra_Agreement_number__c !== null && appRow.SAF_Contra_Agreement_number__c !== undefined)
{
    //alert('Agreement Ids: '+appRow.SAF_Contra_Agreement_number__c);
    var res = appRow.SAF_Contra_Agreement_number__c.split(";");
    //alert(res.length);
    var contractResult;
    var cont;
     for (var i = 0; i <res.length; i++)
        {
            if(i === 0)
            {
                //alert(res[i]);
                //contractResult = null;
                //cont = null;
                contractResult = sforce.connection.query("SELECT NAME FROM cllease__Lease_Account__c where Id ='"+res[i]+"'");
                cont= contractResult.getArray("records"); 
                if(cont && cont.length > 0 )
                Agrnames = cont[0].Name; 
                //alert(res[i]+' , Agr: '+Agrnames);
            }
            else
            {
                //contractResult = null;
                //cont = null;
                contractResult = sforce.connection.query("SELECT NAME FROM cllease__Lease_Account__c where Id ='"+res[i]+"'");
                cont= contractResult.getArray("records"); 
                if(cont && cont.length > 0 )
                Agrnames = Agrnames+','+cont[0].Name;
                //alert(res[i]+' , Agr: '+Agrnames);
            }
        }
    if(Agrnames !== undefined)
    appRow.SAF_Contra_Agreement_numbers__c = Agrnames;
}

var Termnames;
if(appRow.SAF_Contra_TerminationQuote__c !== null && appRow.SAF_Contra_TerminationQuote__c !== undefined)
{
    //alert('Agreement Ids: '+appRow.SAF_Contra_Agreement_number__c);
    var res = appRow.SAF_Contra_TerminationQuote__c.split(";");
    //alert(res.length);
    var termQuoteResult;
    var tq;
    for (var i = 0; i <res.length; i++)
    {
        if(i === 0)
        {
            //alert(res[i]);
            //contractResult = null;
            //cont = null;
            termQuoteResult = sforce.connection.query("SELECT NAME FROM cllease__Termination_Quote_Header__c where Id ='"+res[i]+"'");
            tq= termQuoteResult.getArray("records"); 
            if(tq && tq.length > 0 )
            Termnames = tq[0].Name; 
            //alert(res[i]+' , Agr: '+Agrnames);
        }
        else
        {
            //contractResult = null;
            //cont = null;
            contractResult = sforce.connection.query("SELECT NAME FROM cllease__Termination_Quote_Header__c where Id ='"+res[i]+"'");
            tq= contractResult.getArray("records"); 
            if(tq && tq.length > 0 )
            Termnames = Termnames+','+tq[0].Name;
            //alert(res[i]+' , Agr: '+Agrnames);
        }
    }
      if(Termnames !== undefined)
       appRow.SAF_Contra_Termination_Quote_numbers__c = Termnames;
}
//alert(Agrnames);
});
}(window.skuid));