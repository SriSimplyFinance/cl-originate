(function(skuid){
skuid.componentType.register('DisplaySharepointDocLinks',function(elem) {var params = arguments[0],
	$ = skuid.$;

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
});
skuid.snippet.register('GotoTransact',function(args) {var params = arguments[0],
	$ = skuid.$;

    var appModel = skuid.model.getModel('SAFDocumentLinksTransact');
  
    if (appModel.data.length !== 0)
    {
       
      var appRow = appModel.data[0];
   
       var maxlen = appRow.Document_Path__c.lastIndexOf('/'); 
       var fileFolder = appRow.Document_Path__c.substring(0,maxlen);
       alert(fileFolder);   
	
	  //var url =  //'https://simplyfinance.sharepoint.com/sites/CLO-Test/SAFDocuments/1TestHM/APP-0000001203/Transact/';

	  window.open(fileFolder, '_blank');
  
    }
});
skuid.snippet.register('newSnippet',function(args) {var params = arguments[0],
	$ = skuid.$;

    var appModel = skuid.model.getModel('SAFDocumentLinksTransact');
  
    if (appModel.data.length !== 0)
    {
       
      var appRow = appModel.data[0];
   
       var maxlen = appRow.Document_Path__c.lastIndexOf('/'); 
       var fileFolder = appRow.Document_Path__c.substring(0,maxlen);
       alert(fileFolder);   
	
	  //var url =  //'https://simplyfinance.sharepoint.com/sites/CLO-Test/SAFDocuments/1TestHM/APP-0000001203/Transact/';

	  window.open(fileFolder, '_blank');
  
    }
});
}(window.skuid));