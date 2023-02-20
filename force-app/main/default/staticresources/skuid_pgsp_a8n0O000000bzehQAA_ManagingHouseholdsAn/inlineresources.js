(function(skuid){
(function(skuid){
	var $ = skuid.$;
	
	$(document.body).one('pageload',function(){
	    // create relationship view table
	    var relationView = skuid.model.getModel('MHA_RelationshipView');
		relationView.data = [];
		
		var relations = skuid.model.getModel('MHA_RelationshipsAsEntity').data;
		for (i = 0; i < relations.length; i++) { 
            relationView.createRow({
                additionalConditions: [
                    { field: 'AccountName', value:relations[i].clcommon__Related_Entity__r.Name },
                    { field: 'RelationName', value:relations[i].clcommon__Related_Entity_Role__c },
                    { field: 'AccountId', value:relations[i].clcommon__Related_Entity__c}
                ]
            });   
        }
        
        var relatedRelations = skuid.model.getModel('MHA_RelationshipsAsRelatedEntity').data;
        for (i = 0; i < relatedRelations.length; i++) { 
            relationView.createRow({
                additionalConditions: [
                    { field: 'AccountName', value:relatedRelations[i].clcommon__Entity__r.Name },
                    { field: 'RelationName', value:relatedRelations[i].clcommon__Entity_Role__c },
                    { field: 'AccountId', value:relatedRelations[i].clcommon__Entity__c}
                ]
            });   
        }
        
        if(relationView.data.length > 0){
            // sort the records
            relationView.data.sort(function(a, b){return a.AccountName - b.AccountName});
            
            // need to save else skuid shows unsaved changes css
            skuid.model.save([relationView], {callback: function(result){
                // get first relationship details
                querySelectedAccount(relationView.data[0].AccountId);
            }});
        }
        
        // show button label as tooltip
        showIconicBtnLabelAsTooltip();
	});
	// click the first div
})(skuid)

function querySelectedAccount(selectedAccountId){
    if(selectedAccountId){
        var selectedAccModel = skuid.model.getModel('MHA_SelectedRelationshipAccount');
        var accountIdCondition = selectedAccModel.getConditionByName('AccountId');
        selectedAccModel.setCondition(accountIdCondition, selectedAccountId);
        skuid.model.updateData([selectedAccModel],function(){
            // success
            highlightSelectedRow(selectedAccountId);
        });
    }
}

function highlightSelectedRow(rowId){
    // remove highlighted row css
    $('.account-relationships').find('table tbody tr').each(
        function(index, element) {
            $(element).removeClass("highlighted-row");  
        }                
    )
    $('.account-relationships table tr').each(
        function(index, element) {
            $(element).find('div #' + rowId).each(
                function(i, e) {
                    $(element).addClass('highlighted-row');      
                }   
            )
        } 
    )
};
skuid.snippet.register('OpenAddNewRelationshipDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var title = 'Add Member';
var skuidPage = 'AddNewRelationship';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + skuid.model.getModel('MHA_SelectedAccount').getFirstRow().Id;
openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));