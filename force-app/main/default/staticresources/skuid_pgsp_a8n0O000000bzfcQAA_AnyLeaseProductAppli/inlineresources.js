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

    skuid.model.updateData([applicationModel],function(){});
};
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
skuid.snippet.register('dynamicTerminationQuote',function(args) {var params = arguments[0],
	$ = skuid.$;
var model_one = skuid.model.getModel('GeneralLeaseApplication');

//alert(model_one.data[0].SAF_Contra_Agreement_number__c);
if(model_one.data[0].SAF_Contra_Agreement_number__c != undefined && model_one.data[0].SAF_Contra_Agreement_number__c != null)
{
    //alert('Filtering...');
	var model_two = skuid.model.getModel('TerminationQuoteForContra');
    model_two.setCondition(model_two.getConditionByName("selectedagreement"), model_one.data[0].SAF_Contra_Agreement_number__c.split(";"));
    model_two.activateCondition(model_two.getConditionByName("selectedagreement"));
    model_two.updateData(); 
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