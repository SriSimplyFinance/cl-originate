(function(skuid){
skuid.snippet.register('UpdateRelationshipIFrame',function(args) {var params = arguments[0],
  $ = skuid.$;

var url = $('#relationship-iframe').attr('src');
if (url.lastIndexOf('&id=') >= 0) {
    url = url.substring(0, url.lastIndexOf('&id=')) + '&id=' + params.row.Id;
} else {
    url += '&id=' + params.row.Id;
}

$('#relationship-iframe').attr('src', url);
$('#relationship-iframe').hide();
$('#relationship-iframe').on('load', function() {
    $("#relationship-iframe").show();
});
});
skuid.snippet.register('refreshpartydash',function(args) {var params = arguments[0],
	$ = skuid.$;
//window.location.reload();
alert('Hi');
parent.location.reload();
});
skuid.snippet.register('refresh',function(args) {var params = arguments[0],
	$ = skuid.$;

window.location.reload();
});
}(window.skuid));