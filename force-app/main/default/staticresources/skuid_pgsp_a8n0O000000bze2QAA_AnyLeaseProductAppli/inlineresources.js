(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	     // Allow Number Only Char
	        $(document).on( "keypress",".numberOnly input", function (e) { 
    	            var allowedChars = '0123456789.';
                    function contains(stringValue, charValue) {
                        return stringValue.indexOf(charValue) > -1;
                    }
                    var invalidKey = e.key.length === 1 && !contains(allowedChars, e.key)
                            || e.key === '.';
                    invalidKey && e.preventDefault();
            });
            
           // Allow Decimal Only including single dot
	        $(document).on( "keypress",".decimalOnly input", function (e) { 
    	            var allowedChars = '0123456789.';
                    function contains(stringValue, charValue) {
                        return stringValue.indexOf(charValue) > -1;
                    }
                    var invalidKey = e.key.length === 1 && !contains(allowedChars, e.key)
                            || e.key === '.' && contains(e.target.value, '.');
                    invalidKey && e.preventDefault();
            });
    	 
    	 // Prevent Paste  
    	  $(document).on( "paste",".numberOnly input", function (evt) { 
    	        evt.preventDefault();
    	    });
    	    
    	    $(document).on( "keydown",".datepickerOnly input", function (evt) { 
    	        evt.preventDefault();
    	    });
    	    
    	    
	var paramId = skuid.page.params.id;
	    var pageName = skuid.page.params.page;
	    if(pageName && pageName == 'AddDealsToPackage'){
	        var newRow = skuid.model.getModel('GeneralLeaseApplication').createRow({});
	    } else{
    	    if(paramId){
        	    queryApplication(paramId);
        	}else{
        	    var newRow = skuid.model.getModel('GeneralLeaseApplication').createRow({});
        	}
	    }
	});
})(skuid);

function queryApplication(id){
    var applicationModel = skuid.model.getModel('GeneralLeaseApplication');
    var appIdCondition = applicationModel.getConditionByName('AppId');
    applicationModel.setCondition(appIdCondition,id);
    
    var model_one = skuid.model.getModel('GeneralLeaseApplication');
		
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
    
    var model_one = skuid.model.getModel('GeneralLeaseApplication');
    //alert('Quote: '+model_one.data[0].SAF_Contra_TerminationQuote__c);
    skuid.model.updateData([applicationModel],function(){});
}

function ContractTablepopup(){
    var model_one = skuid.model.getModel('GeneralLeaseApplication');
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
    var model_one = skuid.model.getModel('GeneralLeaseApplication');
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
}

// Code for Attachment of Termination quote requirement.
/*function AttachmentTablepopup(){
    var model_one = skuid.model.getModel('GeneralLeaseApplication');
    if(model_one.data[0].SAF_Contra_TerminationQuote__c != undefined && model_one.data[0].SAF_Contra_TerminationQuote__c != null)
    {
        alert(model_one.data[0].SAF_Contra_TerminationQuote__c);
        $xml = skuid.utils.makeXMLDoc;
        var popupXMLString = 
    
        '<popup width="90%" title="Termination Quote">'
            + '<components>'
                +'<includepanel type="skuid" uniqueid="sk-33YJ-2633" querystring="?id='+ model_one.data[0].SAF_Contra_TerminationQuote__c+'" pagename="uploadGeneratedAgreements"/>'
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
}*/;
skuid.snippet.register('fieldsRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
if(renderMode && renderMode == "read"){
    skuid.ui.fieldRenderers[field.metadata.displaytype].read(field, value);
}else{
    skuid.ui.fieldRenderers[field.metadata.displaytype].edit(field, value);
}
});
skuid.snippet.register('getIncludedPageData',function(args) {var params = arguments[0],
	$ = skuid.$;
var productRow = skuid.model.getModel('GeneralLeaseCLProduct').getFirstRow();
var applicationModel = skuid.model.getModel('GeneralLeaseApplication');
if(applicationModel && applicationModel.data && applicationModel.data[0] && productRow){
    applicationModel.data[0].genesis__CL_Product__c = productRow.Id;
}
var result = {
    'genesis__Applications__c' : applicationModel,
};

return result;
});
skuid.snippet.register('LoadQueueUsers',function(args) {var field = arguments[0],
$ = skuid.$;
var productRow = skuid.model.getModel('GeneralLeaseCLProduct').getFirstRow();
var applicationModel = skuid.model.getModel('GeneralLeaseApplication');

var appModel = skuid.model.getModel('CommonApplicationModel');
var appRow = appModel.data[0];
var ret = sforce.apex.execute("LoaduserTeam","loadQueue",{AppId:appRow.Id});
if (ret!==null)
{
var appGnerealRow = applicationModel.getFirstRow();
//applicationModel.updateRow(appGnerealRow,Team_users,ret);
//applicationModel.Save();
var pikVal = [];

for(var a=0;a<ret.length;a++){
    pikVal.push({label: ret[a], value: ret[a]});
   //       picklistEntries.push({ value:ret[a].Name , label:ret[a].Name, defaultValue: false, active: true  });
    }
    console.log('========='+pikVal);
    return pikVal;
}
//skuid.ui.fieldRenderers[field.metadata.displaytype][field.mode](field,value);
});
skuid.snippet.register('Termdropdown',function(args) {var params = arguments[0],
$ = skuid.$;
var pikVal = [];

    for(var a=0;a<84;a++)
    {
        pikVal.push({label: a+1, value: a+1});
    }
    return pikVal;
});
}(window.skuid));