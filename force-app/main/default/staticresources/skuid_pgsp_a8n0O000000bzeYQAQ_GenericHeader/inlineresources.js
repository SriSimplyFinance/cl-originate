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

    	   
	    // determine sobject type and prefix
	    if(skuid.page.params.id){
	        getDataFromId();
	    } else if(skuid.page.params.sobjecttype){
	        getDataFromSobjectType();
	    } else {
	        skuid.page.params.sobjecttype = 'genesis__Applications__c';
	        getDataFromSobjectType();
	    }
	    // show button labels as icons
	    showIconicBtnLabelAsTooltip();
	});

    // determine sobject type and prefix from param id
    function getDataFromId(){
        var sobjectPrefix = skuid.page.params.id.substring(0,3);
        var sobjectType = getSobjectType(sobjectPrefix);
        updateUIModel(sobjectType, sobjectPrefix);
    }

    // determine sobject type and prefix from param sobjecttype
    function getDataFromSobjectType(){
        var sobjectType = skuid.page.params.sobjecttype;
        var sobjectPrefix = getSobjectPrefix(sobjectType);
        updateUIModel(sobjectType, sobjectPrefix);
    }
	
	//create a new row in model to set sobject type and prefix
    function updateUIModel(sobjectType, sobjectPrefix){
        skuid.$M("GH_AnySObjectModel").createRow({
            additionalConditions: [
                { field: 'SObjectType', value: sobjectType},
                { field: 'Prefix', value: sobjectPrefix},
            ], doAppend: true
        });
    }
    
	// get sobject name from sobject prefix
	function getSobjectType(prefix) {
        var selectedObjectType;
        // skuid gets object prefix for any polymorphic fields like parentid field on attachment
        skuid.$M("GH_AnyAttachmentModel").getField("ParentId").referenceTo.forEach(function(relatedObject){
            if(relatedObject.keyPrefix == prefix){
                selectedObjectType = relatedObject.objectName;
                return false;
            }
        });
        return selectedObjectType;
    }

    // get sobject prefix from sobject type
	function getSobjectPrefix(sobjectType) {
        var prefix;
        // skuid gets object prefix for any polymorphic fields like parentid field on attachment
        skuid.$M("GH_AnyAttachmentModel").getField("ParentId").referenceTo.forEach(function(relatedObject){
            if(relatedObject.objectName == sobjectType){
                prefix = relatedObject.keyPrefix;
                return false;
            }
        });
        return prefix;
    }

})(skuid);;
skuid.snippet.register('ManageStages',function(args) {var params = arguments[0],
	$ = skuid.$;

var popover = $('.webui-popover')[0];
if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
    $('#manage-stages').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=NGTaskList&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '620px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').attr('id', 'task-list-popover');
    			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-stages').webuiPopover('show');
}
});
skuid.snippet.register('ManageLoanTeamPopOver',function(args) {var params = arguments[0],
	$ = skuid.$;
console.log(' popup session app id :: ' + sessionStorage.selectApplicationId);
var popover = $('.webui-popover')[0];
if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
	$('#manage-loan-team-members').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=LoanTeamMembers&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '620px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-loan-team-members').webuiPopover('show');
}
});
skuid.snippet.register('ManageApplicationNotes',function(args) {var params = arguments[0],
	$ = skuid.$;
var popover = $('.webui-popover')[0];

if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
	$('#manage-notes').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=ManageApplicationNotes&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '620px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-notes').webuiPopover('show');
}
});
skuid.snippet.register('ManageMyTasks',function(args) {var params = arguments[0],
	$ = skuid.$;
var appId = sessionStorage.selectApplicationId;
var popover = $('.webui-popover')[0];
if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
    $('#manage-my-tasks').webuiPopover({
		trigger: 'manual',
		type: 'iframe',
		url: '/apex/skuid__ui?page=UserNotificationList&id=' + sessionStorage.getItem('selectApplicationId'),
		width: '620px',
		placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
			var popover = element[0];
			$(popover).css('bottom', 0);
			$(popover).find('.webui-popover-content').css('padding', 0);
			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-my-tasks').webuiPopover('show');
}
});
skuid.snippet.register('manageLoanTeamCommunication',function(args) {var params = arguments[0],
	$ = skuid.$;

console.log(' popup session app id :: ' + sessionStorage.selectApplicationId);
var popover = $('.webui-popover')[0];
if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
    $('#loan-team-communication').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=LoanTeamCommunication&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '820px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').attr('id', 'ltc-popover');
    			$(popover).find('.webui-popover-content > iframe').css('width', '800px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
    			$(popover).find('.webui-popover-content > iframe').css('overflow','hidden');
    // 			$(popover).find('.webui-popover-content > iframe').css('position', 'fixed');
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#loan-team-communication').webuiPopover('show');
}
});
skuid.snippet.register('ManagePreviousAgreements',function(args) {var params = arguments[0],
	$ = skuid.$;
var popover = $('.webui-popover')[0];

if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
	$('#manage-previous-agreements').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=ManagePreviousAgreements&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '620px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-previous-agreements').webuiPopover('show');
}
});
}(window.skuid));