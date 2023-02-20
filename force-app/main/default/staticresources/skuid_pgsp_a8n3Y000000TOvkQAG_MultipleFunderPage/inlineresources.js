(function(skuid){
skuid.snippet.register('newSnippet',function(args) {var $ = skuid.$;
var field = arguments[0],
    value = arguments[1],
    model = field.model,
    row = field.row;
 
switch(row.isSubmitted__c)
{
    case true:
        //skuid.ui.getFieldRenderer(field.metadata.displaytype).edit( field, value );
        alert('true');
        //var renderer = skuid.ui.getFieldRenderer(field.metadata.displaytype);
        //renderer.readonly(field, value);
        break;

    case false:
        alert('false');
        break;
   /* case 'readonly':
        // If the email address is null, then just skip the rest of the logic
        if ( !value ) break;

        var cellElem = field.element.addClass( 'nx-fieldtext' );

        var isOptOut = model.getFieldValue( row, 'HasOptedOutOfEmail'); var linkElemTemplate = '';
        if ( !isOptOut ) linkElemTemplate =
            '<a href="mailto:{{{Email}}}">' +
            '<div class="inline ui-silk ui-silk-email-go"></div> ' +
            'Send Email to {{{FirstName}}} {{{LastName}}} at {{{Email}}}</a>';
        else
            linkElemTemplate =
                '<div class="inline ui-silk ui-silk-email-delete"></div> ' +
                'Do Not Email! ' +
                '<span style="text-decoration: line-through;">{{{Email}}}</span>';

        // mergeRow calls mustache to parse the template and returns the result
        $( field.model.mergeRow( field.row, linkElemTemplate ) )
            .appendTo( cellElem );
        break;*/
}
});
skuid.snippet.register('testSnippet',function(args) {/*
var x = document.getElementsByClassName("nx-fieldtext");
for(var i=0; i< x.length; i++){
    if(x[i].firstChild != undefined){
        x[i].firstChild.style.pointerEvents = "none"
    }
}*/

(function(skuid){ 

var $ = skuid.$; 

$(function(){ 

$('head').append( 

$('<base target="_blank">') 

); 

}); 

})(skuid);
});
skuid.snippet.register('refreshPage',function(args) {var params = arguments[0],
	$ = skuid.$;
window.location.reload();
//parent.location.reload();
});
skuid.snippet.register('validateComments',function(args) {var params = arguments[0],
	$ = skuid.$;
var editorWrapper = $('#UnderwritingError');

//alert(editorWrapper.length);
if(editorWrapper.length === 0 && skuid.page.params.id)
{
    var editorWrapper = $('#UWErrorTitle');
}

//var model = arguments[0].model, row = arguments[0].row;
//model.updateRow(row, {Underwriting__c:''});

//var row = arguments[0].row;
//alert("Test"+row);
//console.log(skuid.page.params);
//console.log(underwritingModel.data);
var editor = editorWrapper.data('object').editor;
var underwritingModel = skuid.model.getModel('Underwriting');
var uwRow = underwritingModel.data[0];
var decision = uwRow.genesis_Decision__c;
//alert(decision);
var reasonfordecline = uwRow.Reason_for_decline__c;
//alert(reasonfordecline);

var affordabilitycomment = uwRow.genesis_Affordability_comment__c;
var affordabilitycommentFieldLen = underwritingModel.getField('genesis_Affordability_comment__c').length||255;

//alert("affordabilitycommentFieldLen : "+underwritingModel.getField('genesis_Affordability_comment__c').length);
//alert(affordabilitycomment.length);
//alert(Underwriting__C.genesis_Affordability_comment__c);

var cabotcomment = uwRow.genesis_Cabot_Comment__c;
var cabotcommentFieldLen = underwritingModel.getField('genesis_Cabot_Comment__c').length||255;

var error = false;
editor.clearMessages();
if(affordabilitycomment && affordabilitycomment.length>affordabilitycommentFieldLen){
    
    editor.handleMessages(
            [
              {
                  message: 'Affordability comment: data value too large (max length='+affordabilitycommentFieldLen+')',
                  severity: 'ERROR'
              },
            ]
        );
        error = true;
}

if(cabotcomment && cabotcomment.length>cabotcommentFieldLen){
    
    editor.handleMessages(
            [
              {
                  message: 'Cabot comment: data value too large (max length='+cabotcommentFieldLen+')',
                  severity: 'ERROR'
              },
            ]
        );
        error = true;
}
/*if(decision === 'Decline' && (reasonfordecline === undefined || reasonfordecline === '')){
    
    editor.handleMessages(
            [
              {
                  message: 'Enter value for reasonfordecline field',
                  severity: 'ERROR'
              },
            ]
        );
        error = true;
} */

if(error === true)
{
    return false;
}
});
skuid.snippet.register('Underwritinghistory',function(args) {var params = arguments[0],
	$ = skuid.$;

var uwRow,uwhRow,uwCom;
var underwritingHistroy = skuid.model.getModel('underwritingHistory');
if(underwritingHistroy)
uwhRow = underwritingHistroy.data[0];

var Underwriting = skuid.model.getModel('Underwriting');
if(Underwriting)
uwRow = Underwriting.data[0];

if(uwhRow && uwhRow.genesis_Internal_fraud_screening__c)
uwRow.genesis_Internal_fraud_screening__c = uwhRow.genesis_Internal_fraud_screening__c;

if(uwhRow && uwhRow.genesis_Rate_to_Reflect_Risk__c)
uwRow.genesis_Rate_to_Reflect_Risk__c = uwhRow.genesis_Rate_to_Reflect_Risk__c;

if(uwhRow && uwhRow.genesis_Recommend_to_Cabot__c)
uwRow.genesis_Recommend_to_Cabot__c = uwhRow.genesis_Recommend_to_Cabot__c;

if(uwhRow && uwhRow.RATE_CARD_PROCESS_EXCECUTED__c)
uwRow.RATE_CARD_PROCESS_EXCECUTED__c = uwhRow.RATE_CARD_PROCESS_EXCECUTED__c;
Underwriting.updateRow(uwRow);
});
skuid.snippet.register('copyUnderwritingConditions',function(args) {var params = arguments[0],
	$ = skuid.$;
	
// Fetch Currently Inserted Underwriting ID
var appId = params && params.row && params.row.Id||'';

// Fetch Last Underwriting Id
var underwritingHistory = skuid.model.getModel('underwritingHistory');
var lastUWId = underwritingHistory && underwritingHistory.data[0] && underwritingHistory.data[0].Id || '';

// Fetch Comments from 
var UnderwriterComments = skuid.model.getModel('UnderwriterComments');
var fetchLastUWC = UnderwriterComments && UnderwriterComments.data || '';

var results = fetchLastUWC.filter(function (entry) { return entry.Underwriting__c === lastUWId; });

var isNew = fetchLastUWC.filter(function (entry) { return entry.Underwriting__c === appId; });


if(results && results.length>0 && isNew && isNew.length === 0)
{
    $.each(results,function(i,row){
        
        // Add rows to UnderwriterComments model
        var NewUnderwriterComments = UnderwriterComments.createRow({ 
                additionalConditions: [
                    { field: 'Underwriting__c', value: params.row.Id },
                    { field: 'Condition__c', value: row.Condition__c},
                    { field: 'Application__c', value: row.Application__c }
                ]
            });
        
    });
}


//Save Underwriting Conditions of UnderwriterComments model
if(results && results.length>0)
skuid.model.save([UnderwriterComments]);
});
skuid.snippet.register('updateApplicationFields',function(args) {var params = arguments[0],
	$ = skuid.$;
var uwRow,ApplicationRow;

var ApplicationModel = skuid.model.getModel('application');
ApplicationRow = ApplicationModel.data[0];

//var Underwriting = skuid.model.getModel('Underwriting');
var Underwriting = skuid.model.getModel('UnderwritingQuality');

if(Underwriting)
{
    uwRow = Underwriting.data[0];

    if(uwRow && uwRow.isSubmitted__c && uwRow.genesis_Decision__c === 'Accepted')
    {
        //console.log(uwRow.Asset_quality__c + uwRow.genesis_Customer_quality__c);
        ApplicationModel.updateRow(ApplicationRow,'Latest_Underwriter_Quality__c',uwRow.Asset_quality__c + uwRow.genesis_Customer_quality__c);
        ApplicationModel.save();
    }
}
});
skuid.snippet.register('Submit',function(args) {var params = arguments[0],
	$ = skuid.$;

var uwmodel = skuid.model.getModel('Underwriting');

var uwrow = uwmodel.data[0];

var IsSubmitted = uwrow.isSubmitted__c;

uwmodel.updateRow(uwrow,'IsSubmitted',true);
    skuid.model.save([uwmodel],{callback:function(result){
                if(result.totalsuccess){
                //alert('Saved');
                uwmodel.updateRow(uwrow,'IsSubmitted',true);
                }else{
                    uwmodel.updateRow(uwrow,'IsSubmitted',false);
                      alert('Error: ' + result.insertResults[0]);
                      console.log(result.insertResults[0]);
                }
            }});
});
}(window.skuid));