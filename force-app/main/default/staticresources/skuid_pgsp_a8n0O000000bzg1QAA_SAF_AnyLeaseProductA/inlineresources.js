(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	  
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
skuid.snippet.register('VATCalc',function(args) {var params = arguments[0],
	$ = skuid.$;
var VATAmount;
var model = skuid.model.getModel('GeneralLeaseApplication'),
row = model.getFirstRow();
VATAmount = (row.genesis__Financed_Amount__c *20)/100;
model.updateRow(row, 'SAF_VAT_UI', VATAmount);
});
skuid.snippet.register('proposalOwnerFilter',function(args) {var $ = skuid.$;
var RecordTypeModel = skuid.$M('OpportunityRecordTypes');
var OpportunitiesModel = skuid.$M('Opportunity');
var recordTypeIdCondition = OpportunitiesModel.getConditionByName('RecordTypeId');
var validRecordTypeIds = {};
var selectedRecordTypeId = recordTypeIdCondition.value;
if (!selectedRecordTypeId){
   // If we don't have a selected Record Type Id,
   // then ALL Record Type Ids are valid
   $.each(RecordTypeModel.data,function(){
      validRecordTypeIds[this.Id]=1;
   });
} else {
 // Otherwise, only the SELECTED Record Type Id is valid
 validRecordTypeIds[selectedRecordTypeId]=1;
}
var filterItems = [];
var validEntryValues = {};
var d = skuid.utils.getAPIDescribeLayout('Opportunity');
$.each(d.recordTypeMappings,function(i,rtm){
   if (rtm.recordTypeId in validRecordTypeIds) {
       $.each(rtm.picklistsForRecordType,function(j,picklist){
          if (picklist.picklistName==='StageName'){
              $.each(picklist.picklistValues,function(k,pv){
                  if (pv.active==='true'){
                      validEntryValues[pv.value]=1;
                  }
              });
              // All we care about is the StageName picklist
              return false;
          }
       });
   }
});
$.each(OpportunitiesModel.getField('StageName').picklistEntries,function(i,pe){
  if (pe.active && (pe.value in validEntryValues)) {
      filterItems.push(pe);
  }
});
return filterItems;
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