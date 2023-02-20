(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var isLatestCheched = $('input[type="checkbox"]').eq(0).prop('checked');
	    if(!isLatestCheched)
		$('input[type="checkbox"]').eq(0).prop('checked', true);
	});
})(skuid);;
}(window.skuid));