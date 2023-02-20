(function(skuid){
skuid.snippet.register('NewRelationship',function(args) {var params = arguments[0],
  $ = skuid.$;

$('#newRelation').addClass('selected-btn');
$('#existingRelation').removeClass('selected-btn');

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
if(!newPartyRow){
    var newRow = newPartyModel.createRow({
        additionalConditions: [
            { field: 'NewRelationship', value:true },
            { field: 'ExistingRelationship', value: false },
        ]
    });
}else{
    newPartyModel.updateRow(newPartyRow ,{
                            NewRelationship : true ,
                            ExistingRelationship : false,
                            BusinessRelationship : false ,
                            IndividualRelationship : false,
                            clcommon__Account__c : null
                        }
    );
}
});
skuid.snippet.register('ExistingRelationship',function(args) {var params = arguments[0],
  $ = skuid.$;

$('#newRelation').removeClass('selected-btn');
$('#existingRelation').addClass('selected-btn');
var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
if(!newPartyRow){
    var newRow = newPartyModel.createRow({
        additionalConditions: [
            { field: 'NewRelationship', value:false },
            { field: 'ExistingRelationship', value: true },
        ]
    });
}else{
    var rowUpdates = {};
    rowUpdates['NewRelationship'] = false;
    rowUpdates['ExistingRelationship'] = true;
    rowUpdates['BusinessRelationship'] = false;
    rowUpdates['IndividualRelationship'] = false;
    rowUpdates['clcommon__Account__c'] = null;
    newPartyModel.updateRow( newPartyRow , rowUpdates);
}
});
skuid.snippet.register('moveToStep2',function(args) {var params = arguments[0],
    $ = skuid.$;

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
if(!(newPartyRow && (newPartyRow.NewRelationship || newPartyRow.ExistingRelationship))){
    $('#newRelation').addClass('selected-btn');
    $('#existingRelation').removeClass('selected-btn');
    var newRow = newPartyModel.createRow({
        additionalConditions: [
            { field: 'NewRelationship', value:true },
            { field: 'ExistingRelationship', value: false },
        ]
    });
}
});
skuid.snippet.register('selectBusinessRelation',function(args) {var params = arguments[0],
  $ = skuid.$;

$('#businessRelation').addClass('selected-btn');
$('#indiividualRelation').removeClass('selected-btn');
var newPartyModel = skuid.model.getModel('NewPartyModel');
newPartyModel.updateRow(newPartyModel.data[0] ,{
                            BusinessRelationship : true ,
                            IndividualRelationship : false,
                            clcommon__Account__c : null}
);
});
skuid.snippet.register('queryAccount',function(args) {var params = arguments[0],
  step = params.step,
    stepEditor = step.editor,
    $ = skuid.$;

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
// if nothing is selected and user moves forward
if(newPartyRow.NewRelationship && (!(newPartyRow.BusinessRelationship || newPartyRow.IndividualRelationship))){
    $('#businessRelation').addClass('selected-btn');
    $('#indiividualRelation').removeClass('selected-btn');
    newPartyRow.BusinessRelationship = true;
    newPartyRow.clcommon__Account__c = null;
}

//fetch model and cancel any changes
var newAccountModel = skuid.model.getModel('NewAccountModel');
newAccountModel.cancel();

var newCollateralOwnersModel = skuid.model.getModel('CollateralOwnerModel');
newCollateralOwnersModel.cancel();

var newBIModel = skuid.model.getModel('NewBusinessInfoModel');
newBIModel.cancel();

var newPartyModelClone = skuid.model.getModel('NewPartyModelClone');
newPartyModelClone.cancel();

var newContactModelForExistingRel = skuid.model.getModel('NewContactModelForExistingRel');
newContactModelForExistingRel.cancel();

var newContactModel = skuid.model.getModel('NewContactModel');
newContactModel.cancel();

// validate
if(newPartyRow.ExistingRelationship){
    if(!newPartyRow.clcommon__Account__c){
        var pageTitle = $('#errorTitle2');
        var editor = pageTitle.data('object').editor;
        editor.handleMessages(
            [
              {
                  message: 'Please select an existing account',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
}

//fetch conditions
var accountIdCondition = newAccountModel.getConditionByName('Id');
var partyAccountIdCondition = newPartyModelClone.getConditionByName('clcommon__Account__c');
var coAccountIdCondition = newCollateralOwnersModel.getConditionByName('clcommon__Account__c');
var biIdCondition = newBIModel.getConditionByName('Id');
var newContactModelIdCondition = newContactModel.getConditionByName('AccountId');

// set and activate condtions
if(newPartyRow.clcommon__Account__c){
    newAccountModel.setCondition(accountIdCondition,newPartyRow.clcommon__Account__c);
    newPartyModelClone.setCondition(partyAccountIdCondition,newPartyRow.clcommon__Account__c);
    newCollateralOwnersModel.setCondition(coAccountIdCondition,newPartyRow.clcommon__Account__c);
    newContactModel.setCondition(newContactModelIdCondition,newPartyRow.clcommon__Account__c);
}else{
    newAccountModel.setCondition(accountIdCondition,'');
    newPartyModelClone.setCondition(partyAccountIdCondition,'');
    newCollateralOwnersModel.setCondition(coAccountIdCondition,'');
    newContactModel.setCondition(newContactModelIdCondition,'');
}

//query models
skuid.model.updateData([newAccountModel, newCollateralOwnersModel, newPartyModelClone, newContactModelForExistingRel, newContactModel],function(){
    createNewAccountRow(newAccountModel);
    createNewCORow(newCollateralOwnersModel);
    createNewContactRow(newContactModel);
    if(!newPartyRow.NewRelationship && newPartyModelClone.data && newPartyModelClone.data.length == 1){

    }else{
        newPartyModel.updateRow(newPartyRow,{
                                    clcommon__Type__c: null,
                                    clcommon__Signer_Capacity__c : null,
                                    clcommon__Signing_on_Behalf_of__c : null,
                                });
    }

    //query bi for account
    if(newAccountModel.data && newAccountModel.data.length > 0 && newAccountModel.data[0].genesis__Business_Information__c){
        newBIModel.setCondition(biIdCondition,newAccountModel.data[0].genesis__Business_Information__c);
    }else{
        newBIModel.setCondition(biIdCondition,'');
    }

    skuid.model.updateData([newBIModel],function(){
        createNewBIRow(newBIModel);
        moveToNextStepPls();
    });
});

function createNewAccountRow(newAccountModel){
    if(newAccountModel.data && newAccountModel.data.length < 1){
        var newRow = newAccountModel.createRow({
            additionalConditions: [
                { field: 'BusinessRelationship', value:true },
                { field: 'IndividualRelationship', value:false },
                //{ field: 'Name', value:'Set Account Name' },
            ]
        });
    }
}

function createNewContactRow(newContactModel){
    if(newContactModel.data && newContactModel.data.length < 1){
        var newRow = newContactModel.createRow({
            additionalConditions: [
                { field: 'BusinessRelationship', value:false },
                { field: 'IndividualRelationship', value:true }

            ]
        });
    }
}

function createNewCORow(newCollateralOwnersModel){
    if(newCollateralOwnersModel.data && newCollateralOwnersModel.data.length < 1){
        var newRow = newCollateralOwnersModel.createRow({
            additionalConditions: [
                { field: 'clcommon__Ownership__c', value: 100 },
                { field: 'clcommon__Collateral__c', value: null},
            ]
        });
    }
}

function createNewBIRow(newBIModel){
    if(newBIModel.data && newBIModel.data.length < 1){
        var newRow = newBIModel.createRow({
            additionalConditions: [
                //{ field: 'genesis__Business_Legal_Name__c', value:'Set Business Info' },
            ]
        });
    }
}

function moveToNextStepPls(){
    var wizard = $('.nx-wizard').data('object');
    var currentStep = wizard.steps[wizard.currentstep];
    currentStep.navigate('step3');
}
});
skuid.snippet.register('selectIndividualRelation',function(args) {var params = arguments[0],
  $ = skuid.$;
$('#businessRelation').removeClass('selected-btn');
$('#indiividualRelation').addClass('selected-btn');
var newPartyModel = skuid.model.getModel('NewPartyModel');
newPartyModel.updateRow(newPartyModel.data[0] ,{
                            BusinessRelationship : false ,
                            IndividualRelationship : true,
                            clcommon__Account__c : null
                        }
    );
});
skuid.snippet.register('moveToStep4',function(args) {var params = arguments[0],
  step = params.step,
    stepEditor = step.editor,
    $ = skuid.$;

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
var models;

var pageTitle = $('#errorTitle3');
var editor = pageTitle.data('object').editor;

if(newPartyRow.BusinessRelationship){
    models = [
        skuid.model.getModel("NewAccountModel"),
        skuid.model.getModel("NewBusinessInfoModel")
    ];
}else{
    models = [
        skuid.model.getModel("NewContactModel"),
        skuid.model.getModel("NewBusinessInfoModel")
    ];
}
var vres = validateAllRequiredFields($,editor,models);
if(!vres){
    return vres;
}
});
skuid.snippet.register('saveUpdateParty',function(args) {var params = arguments[0],
$ = skuid.$;

skuid.$('.nx-wizard-step .ui-button:visible').has('.ui-button-text:contains(Save)').button('disable');
var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];

var newAccountModel = skuid.model.getModel('NewAccountModel');
var newAccountRow = newAccountModel.data[0];
console.log('newAccountRow ##',newAccountRow);

var newContactModel = skuid.model.getModel('NewContactModel');
var newContactRow = newContactModel.data[0];
console.log('newContactRow ## ',newContactRow);

var businessInfoModel = skuid.model.getModel('NewBusinessInfoModel');
var businessInfoRow = businessInfoModel.data[0];

var collateralOwnerModel = skuid.model.getModel('CollateralOwnerModel');
var collData = [];
collateralOwnerModel.data.forEach(function (colDataObj){
    if(!collateralOwnerModel.isRowMarkedForDeletion(colDataObj) && colDataObj.clcommon__Collateral__c){
        collData.push(colDataObj);
    }
});
collateralOwnerModel.data = collData;

var pageTitle = $('#finalTitlePanel');
var editor = pageTitle.data('object').editor;
if(!newPartyRow.clcommon__Type__c){
    editor.handleMessages(
        [
           {
              message: 'Select Party Type for Party.',
              severity: 'ERROR'
           },
        ]
    );
    skuid.$('.nx-wizard-step .ui-button:visible').has('.ui-button-text:contains(Save)').button('enable');
    return;
}
var partyArgs = {};

if(newPartyRow.NewRelationship) {
    if(newPartyRow.IndividualRelationship){
        partyArgs[0] = newContactModel;
        partyArgs[1] = null;
    } else {
        partyArgs[0] = null;
        partyArgs[1] = newAccountModel;
    }
} else {
    if(newPartyRow.IndividualRelationship){
        partyArgs[0] = newContactModel;
        partyArgs[1] = null;
    } else {
        partyArgs[0] = null;
        partyArgs[1] = newAccountModel;
    }
}
// if(newPartyRow.IndividualRelationship){
//     partyArgs[0] = newContactModel;
//     partyArgs[1] = null;
// }
// if(newPartyRow.BusinessRelationship || newPartyRow.ExistingRelationship){
//     partyArgs[0] = null;
//     partyArgs[1] = newAccountModel;
// }

var bModel = businessInfoModel;
if (Object.keys(businessInfoModel.data[0]).length <= 2){
    bModel = null;
}

var res = saveParty(newPartyModel,partyArgs[0],partyArgs[1],bModel,collateralOwnerModel);
var resObj = JSON.parse(res);
if(resObj.status == 'SUCCESS'){
    editor.handleMessages(
        [
          {
              message: 'Record is successfully saved!',
              severity: 'INFO'
          },
        ]
    );
    closeTopLevelDialogAndRefresh({iframeIds: ['document-iframe', 'party-iframe', 'deal-dashboard-iframe,document-iframe', 'deal-dashboard-iframe,party-iframe']});
}else{
    $("#PartySaveButton").button('enable');
    editor.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          },
        ]
    );
}
});
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
// 	    alert(2);
      $('#step1button').click();
	    
// 		var myModel = skuid.model.getModel('MyModelId');
// 		var myComponent = skuid.component.getById('MyComponentUniqueId');
	});
})(skuid);;
skuid.snippet.register('refresh',function(args) {var params = arguments[0],
	$ = skuid.$;
window.location.reload();
});
}(window.skuid));