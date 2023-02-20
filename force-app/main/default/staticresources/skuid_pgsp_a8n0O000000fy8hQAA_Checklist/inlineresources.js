(function(skuid){
skuid.snippet.register('PageRefresh',function(args) {var genesisKYCAMLModel = skuid.model.getModel('genesisKYCAML');
var ApplicationModel = skuid.model.getModel('Application'); 
/*    {
        window.location.reload();
    }
    
    */
    
 window.location.reload();
});
(function(skuid){
	var $ = skuid.$;
	$('head').append(
        $('<base target="_blank">')
    );
	
})(skuid);;
}(window.skuid));