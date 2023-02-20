(function(skuid){
(function(skuid){
  var $ = skuid.$;
  $('head').append(
      $('<base target="_blank">')
  );
  
  $(document.body).one('pageload',function(){
      var paramId = skuid.page.params.id;
      var orgParamRow = skuid.model.getModel('OrgParameter').getFirstRow();
      var applicationModel = skuid.model.getModel('CommonApplicationModel');
      applicationModel.emptyData();
      if(paramId){
            var appIdCondition = applicationModel.getConditionByName('AppId');
            applicationModel.setCondition(appIdCondition,paramId);
            skuid.model.updateData([applicationModel],function(){
                // record type
                var appRecType = applicationModel.data[0].RecordTypeId;
                var applicationRTModel = skuid.model.getModel('ApplicationRecordType');
                var rtIdCondition = applicationRTModel.getConditionByName('Id');
                applicationRTModel.setCondition(rtIdCondition,appRecType);
              
                var productModel = skuid.model.getModel('SelectedProduct');
                var prodIdCondition = productModel.getConditionByName('Id');
                productModel.setCondition(prodIdCondition, applicationModel.data[0].genesis__CL_Product__c);
                skuid.model.updateData([productModel,applicationRTModel],function(){
                    skuid.snippet.getSnippet('fetchAccountData')();
                    skuid.snippet.getSnippet('fetchContactData')();
                });
            });
      }else{
          // fetch record type info
          var appRecType = skuid.page.params.RecordType;
            var applicationRTModel = skuid.model.getModel('ApplicationRecordType');
            var rtIdCondition = applicationRTModel.getConditionByName('Id');
            applicationRTModel.setCondition(rtIdCondition,appRecType);
          
          skuid.model.updateData([applicationRTModel],function(){
              var newRow = applicationModel.createRow({
                    additionalConditions: [
                        { field: 'NewBorrower', value:false },
                        { field: 'RecordType', value:applicationRTModel.getFirstRow() },
                        { field: 'RecordTypeId', value:applicationRTModel.getFirstRow().Id },
                    ]
                });
          }); 
      }  
  });
})(skuid);;
skuid.snippet.register('fieldRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('fetchAccountData',function(args) {var params = arguments[0],
  $ = skuid.$;
  
var applicationRowData = skuid.model.getModel('CommonApplicationModel').data[0];
var commonAccountModel = skuid.model.getModel('CommonAccountModel');
var biModel = skuid.model.getModel('CommonBusinessInforModel');

commonAccountModel.emptyData();
biModel.emptyData();

if(applicationRowData && applicationRowData.genesis__Account__c){
    var accountIdCondition = commonAccountModel.getConditionByName('CommonAccId');
    commonAccountModel.setCondition(accountIdCondition,applicationRowData.genesis__Account__c);
    skuid.model.updateData([commonAccountModel],function(){
        if(!(commonAccountModel.data && commonAccountModel.data.length > 0)){
            var newPSRow = commonAccountModel.createRow({ });
        }else{
            if(commonAccountModel.data[0].genesis__Business_Information__c){
                // fetch business info
                var bIdCondition = biModel.getConditionByName('BusinessInfoId');
                biModel.setCondition(bIdCondition,commonAccountModel.data[0].genesis__Business_Information__c);
                skuid.model.updateData([biModel],function(){});
            }else{
                var newBIRow = biModel.createRow({ });
            }
        }
    });    
}else{
    if(!(commonAccountModel.data && commonAccountModel.data.length > 0)){
        var newPSRow = commonAccountModel.createRow({ });
        var newBIRow = biModel.createRow({ });
    } 
}
});
skuid.snippet.register('fetchContactData',function(args) {var params = arguments[0],
  $ = skuid.$;

var applicationRowData = skuid.model.getModel('CommonApplicationModel').data[0];
var commonContactModel = skuid.model.getModel('CommonContactModel');
commonContactModel.emptyData();
if(applicationRowData && applicationRowData.Name){
    if(applicationRowData.genesis__Contact__c){
        var contactIdCondition = commonContactModel.getConditionByName('CommonContactId');
        commonContactModel.setCondition(contactIdCondition,applicationRowData.genesis__Contact__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });    
    }
    
    if(applicationRowData.genesis__Account__c && applicationRowData.genesis__Account__r && 
        applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__c && 
        (applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__r.Name.toUpperCase() == 'INDIVIDUAL' ||
            applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__r.Name.toUpperCase() == 'SOLE PROPRIETORSHIP')){
        var accountIdCondition = commonContactModel.getConditionByName('AccountId');
        commonContactModel.setCondition(accountIdCondition,applicationRowData.genesis__Account__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });
    }
}else{
    if(applicationRowData && applicationRowData.genesis__Contact__c){
        var contactIdCondition = commonContactModel.getConditionByName('CommonContactId');
        commonContactModel.setCondition(contactIdCondition,applicationRowData.genesis__Contact__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });    
    }else{
        if(!(commonContactModel.data && commonContactModel.data.length > 0)){
            var newPSRow = commonContactModel.createRow({ });
        }
    }
}
});
skuid.snippet.register('saveApplication',function(args) {var params = arguments[0],
  $ = skuid.$;
var newAppParams = {};
var editorWrapper = $('#AppTitleHeader'); 
if(skuid.page.params.id){
    editorWrapper = $('#AppDetailTitleHeader'); 
}
var editor = editorWrapper.data('object').editor;
var fetchIncludedPageData = skuid.snippet.getSnippet('getIncludedPageData');
var result = fetchIncludedPageData();

// Clear the Error messages to avoid error being displayed even after condition is satisfied.
editor.clearMessages();

if(!result){
    editor.handleMessages(
        [
          {
              message: 'Unable to save Application data.',
              severity: 'ERROR'
          },
        ]
    );
    return false;
}

var applicationModel = result['genesis__Applications__c'];
var appRow = applicationModel.data[0];

if(skuid.page.params.RecordType){
    appRow.RecordTypeId = skuid.page.params.RecordType;    
}
if(skuid.page.params.parentId){
    appRow.genesis__Parent_Application__c = skuid.page.params.parentId;    
}
var appModelCommon = skuid.model.getModel('CommonApplicationModel');
var appRowCommon = appModelCommon.data[0];
appRow.genesis__Sales_Division__c=appRowCommon.genesis__Sales_Division__c;
if(appRow.Team_users!==undefined)
{
   appRow.User__c =appRow.Team_users;
   var user = appRow.Team_users;
   var result = sforce.connection.query("SELECT ID FROM User where name ='"+user+"'");
   var opp= result.getArray("records"); 
   var UserId = opp[0].Id; 
   appRow.OwnerId=UserId;
}


var selectedProductModel = skuid.model.getModel('SelectedProduct');
var selectedProductRow = selectedProductModel.data[0];


if(selectedProductRow.Id && selectedProductRow.Id.length > 14){
    appRow.genesis__CL_Product__c = selectedProductRow.Id;
}

var newProduct = appRow.genesis__CL_Product__r && appRow.genesis__CL_Product__r.Id;
if(appRow.genesis__CL_Product__c != newProduct)
{
    
    var productCheck = confirm("Please review all the fee sets");
        if (productCheck === true) {
           // return false;
        } else {
            return false;
        }
}

//Product Changes
if(appRow.genesis__CL_Product__r && appRow.genesis__CL_Product__r.Id)
         appRow.genesis__CL_Product__c = appRow.genesis__CL_Product__r.Id;


var contactModel = skuid.model.getModel('CommonContactModel');
var contactRow = contactModel.data[0];
var accountModel = skuid.model.getModel('CommonAccountModel');
var accRow = accountModel.data[0];
//alert(contactRow.clcommon__Legal_Entity_Type__c); // Commented by Deepak M on May 21, 2018, because only from account we get Legal Entity Type not from Contact
var PartyModel = skuid.model.getModel('RDParty');
var partyRow = PartyModel.data[0];


var businessModel = skuid.model.getModel('CommonBusinessInforModel');
var businessRow = businessModel.data[0];

if(!appRow.genesis__Term__c){
    appRow.genesis__Term__c = 0;
}
if(!appRow.genesis__Interest_Rate__c){
    appRow.genesis__Interest_Rate__c = 0;
}
if(!appRow.genesis__Loan_Amount__c){
    appRow.genesis__Loan_Amount__c = 0;
}
if(!appRow.genesis__Credit_Limit__c){
    appRow.genesis__Credit_Limit__c = 0;
}
if(!appRow.genesis__Financed_Amount__c){
    appRow.genesis__Financed_Amount__c = 0;
}
if(!appRow.genesis__Draw_Term__c){
    appRow.genesis__Draw_Term__c = 0;
}

newAppParams.applicationM = applicationModel;
newAppParams.pmtstreamM = null;
newAppParams.businessM = businessModel;
if(accRow.Name){
   //alert(accRow.clcommon__Legal_Entity_Type__c); // Commented by Deepak M on May 22, 2018, not required
   /* if(accRow.clcommon__Legal_Entity_Type__c === null){
        editor.handleMessages(
            [
              {
                  message: 'Legal Entity Type is missing:acc',
                  severity: 'ERROR'
              },
            ]
        );
        return false;
    }*/
    newAppParams.accountM = accountModel;
}else{
    newAppParams.accountM = null;
}

if(contactRow && contactRow.LastName){
  /*  if(contactRow.clcommon__Legal_Entity_Type__c === null){
        editor.handleMessages(
            [
              {
                  message: 'Legal Entity Type is missing:con',
                  severity: 'ERROR'
              },
            ]
        );
        return false;
    }*/
    newAppParams.contactM = contactModel;
}else{
    newAppParams.contactM = null;
}

// Deepak Started For Contra Ticket
//var res = str.split(" ");
//alert('Agreement Ids: '+appRow.SAF_Contra_Agreement_numbers__c);
//var Agrnames;
//if(appRow.SAF_Contra_Agreement_number__c !== null && appRow.SAF_Contra_Agreement_number__c !== undefined)
//{
//    //alert('Agreement Ids: '+appRow.SAF_Contra_Agreement_number__c);
//    var res = appRow.SAF_Contra_Agreement_number__c.split(";");
//    //alert(res.length);
//    var contractResult;
//    var cont;
//     for (var i = 0; i <res.length; i++)
//        {
//            if(i === 0)
//            {
//                //alert(res[i]);
//                //contractResult = null;
//                //cont = null;
//                contractResult = sforce.connection.query("SELECT NAME FROM cllease__Lease_Account__c where Id ='"+res[i]+"'");
//                cont= contractResult.getArray("records"); 
//                if(cont && cont.length > 0 )
//                Agrnames = cont[0].Name; 
//                //alert(res[i]+' , Agr: '+Agrnames);
//            }
//            else
//            {
//                //contractResult = null;
//                //cont = null;
//                contractResult = sforce.connection.query("SELECT NAME FROM cllease__Lease_Account__c where Id ='"+res[i]+"'");
//                cont= contractResult.getArray("records"); 
//                if(cont && cont.length > 0 )
//                Agrnames = Agrnames+','+cont[0].Name;
//                //alert(res[i]+' , Agr: '+Agrnames);
//            }
//        }
//    if(Agrnames !== undefined)
//    appRow.SAF_Contra_Agreement_numbers__c = Agrnames;
//}
//
//var Termnames;
//if(appRow.SAF_Contra_TerminationQuote__c !== null && appRow.SAF_Contra_TerminationQuote__c !== undefined)
//{
//    //alert('Agreement Ids: '+appRow.SAF_Contra_Agreement_number__c);
//    var res = appRow.SAF_Contra_TerminationQuote__c.split(";");
//    //alert(res.length);
//    var termQuoteResult;
//    var tq;
//    for (var i = 0; i <res.length; i++)
//    {
//        if(i === 0)
//        {
//            //alert(res[i]);
//            //contractResult = null;
//            //cont = null;
//            termQuoteResult = sforce.connection.query("SELECT NAME FROM cllease__Termination_Quote_Header__c where Id ='"+res[i]+"'");
//            tq= termQuoteResult.getArray("records"); 
//            if(tq && tq.length > 0 )
//            Termnames = tq[0].Name; 
//            //alert(res[i]+' , Agr: '+Agrnames);
//        }
//        else
//        {
//            //contractResult = null;
//            //cont = null;
//            contractResult = sforce.connection.query("SELECT NAME FROM cllease__Termination_Quote_Header__c where Id ='"+res[i]+"'");
//            tq= contractResult.getArray("records"); 
//            if(tq && tq.length > 0 )
//            Termnames = Termnames+','+tq[0].Name;
//            //alert(res[i]+' , Agr: '+Agrnames);
//        }
//    }
//      if(Termnames !== undefined)
//       appRow.SAF_Contra_Termination_Quote_numbers__c = Termnames;
//}
//alert(Agrnames);
// Deepak Ends For Contra Ticket

var skuidApplicationId = appRow.Id;
var result = saveNGApplication(newAppParams);
var resultJSON = $.parseJSON(result[0]);

//Customer should not be blank
if(!appRow.genesis__Account__c){
    
    editor.handleMessages([
              {
                  message: 'Customer is blank',
                  severity: 'ERROR'
              }]
        );
        return false;
}



// Bug #155305 #Restric Max Length of Proposal Name field
var proposalName = appRow.genesis_ProposalName__c;
var proposalNameFieldLen = applicationModel.getField('genesis_ProposalName__c').length||255;
if(proposalName && proposalName.length>proposalNameFieldLen){
    
    editor.handleMessages(
            [
              {
                  message: 'Proposal Name: data value too large (max length='+proposalNameFieldLen+')',
                  severity: 'ERROR'
              },
            ]
        );
        return false;
    
}

// Required fields in UI
if(!appRow.genesis__Expected_Start_Date__c){
    
    editor.handleMessages([
              {
                  message: 'Forecast Drawdown Date is blank',
                  severity: 'ERROR'
              }]
        );
       return false;
}


// Bug #155307 #Term should not be blank and error should be specific to it
if(!appRow.genesis__Term__c){
    
    var errMsg = 'Term should not be blank and required positive value';
    
    editor.handleMessages([
              {
                  message: errMsg,
                  severity: 'ERROR'
              }]
        );
        return false;
}


var prodName = appRow.genesis__CL_Product__r && appRow.genesis__CL_Product__r.clcommon__Product_Name__c;
if((appRow.genesis_Total_Deposit__c <= 0 || appRow.genesis_Total_Deposit__c === null) && prodName === 'Sale & HP Back'){
    
    var errMsg = 'Please enter Total Deposit';
    
    editor.handleMessages([
              {
                  message: errMsg,
                  severity: 'ERROR'
              }]
        );
       return false;
}

if(appRow.genesis__Term__c && appRow.genesis__Term__c>84){
    
     editor.handleMessages([
              {
                  message: 'Term value should not be more than 84',
                  severity: 'ERROR'
              }]
        );
        return false;
    
}

// Required fields in UI
if(!appRow.genesis__Expected_First_Payment_Date__c){
    
    editor.handleMessages([
              {
                  message: 'Expected First Payment Date is blank',
                  severity: 'ERROR'
              }]
        );
        return false;
}

// Bug #155307 #Net Amount should not be blank and error should be specific to it
if(!appRow.genesis__Financed_Amount__c){
   
    var errMsg = 'Net Amount should not be blank and required positive value';
    
    editor.handleMessages([
              {
                  message: errMsg,
                  severity: 'ERROR'
              }]
        );
        return false;
}
if(appRow.Security_Deposit__c < 0){
   
    var errMsg = 'Security Deposit should be positive value';
    
    editor.handleMessages([
              {
                  message: errMsg,
                  severity: 'ERROR'
              }]
        );
        return false;
}
console.log(applicationModel);

if (resultJSON.status === 'ERROR') {
    
    if(resultJSON.errorMessage.indexOf('drawdown date should be greater or equal to the system date')!=-1)
       resultJSON.errorMessage = 'Drawdown Date should be greater or equal to the system date';
       
    else if(resultJSON.errorMessage.indexOf('Expected First Payment Date should be greater than')!=-1)
       resultJSON.errorMessage = 'Expected First Payment Date should be greater than or equal to the Start Date';
      
    editor.handleMessages(
        [
          {
              message: resultJSON.errorMessage,
              severity: 'ERROR'
          },
        ]
    );

    return false;
    
} else {
    if(skuidApplicationId == resultJSON.content[0].Id){
        //closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe','deal-dashboard-iframe,document-iframe']});
    }else{
         window.location = '/' + resultJSON.content[0].Id;   
    }
}
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

//closeTopLevelDialogAndRefresh({iframeIds: ['loan-details-iframe']});
closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe']});
});
skuid.snippet.register('IsReadModeDisabled',function(args) {var params = arguments[0],
  $ = skuid.$;

var readMode = false;
if(skuid.page.params.mode && skuid.page.params.mode == 'read'){
    readMode = true; // changed from true
}

return !readMode;
});
skuid.snippet.register('SAF_UpdateApplicationStatus',function(args) {var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];


// Added for Change Request #159440: 27 - Supplier Validation - Starts
var appRowData = skuid.model.getModel('CommonApplicationModel').data[0];
var appId = appRowData.Id;

var partyModel = skuid.model.getModel('RDParty');
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
    var r=confirm("Are you sure to submit the application for Approval");

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
        parent.location = '/'+appRow.Id;
        parent.location.reload();
        skuid.$('.ui-dialog-content').dialog('close');
        //parent.location = '/'+appRow.Id;
        //window.location = '/'+appRow.Id;
    }
}
else
{
    alert('Please ensure there is a Supplier associated to the proposal before submitting to underwriting');
}
});
skuid.snippet.register('BackButton',function(args) {var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];


try {
    //alert("Hi");
    var ret = sforce.apex.execute("SAF_ValidateApplication","moreInformationRequired",{AppId:appRow.Id});
}
catch(err) {
    alert(err);
}
//window.location.reload();
parent.location = '/'+appRow.Id;
parent.location.reload();
//parent.location = '/'+appRow.Id;
//window.location = '/'+appRow.Id;
});
skuid.snippet.register('refresh',function(args) {var params = arguments[0],
	$ = skuid.$;
closeTopLevelDialogAndRefresh({iframeIds: ['party-iframe']});
});
skuid.snippet.register('manageParties',function(args) {var params = arguments[0],
	$ = skuid.$;

var appModelCommon = skuid.model.getModel('CommonApplicationModel');
var appRowCommon = appModelCommon.data[0];

try
{
var partyCheck = sforce.apex.execute("genesis_CheckParty","updategenesisParty",{ApplicationIds:appRowCommon.Id});
//alert(appRowCommon.Id);
parent.location = '/'+appRowCommon.Id; 
}
catch(err)
{
    alert(err);
}
});
}(window.skuid));