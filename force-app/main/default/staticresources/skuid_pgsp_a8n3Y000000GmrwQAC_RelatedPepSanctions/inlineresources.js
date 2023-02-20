(function(skuid){
skuid.snippet.register('PEPCheck',function(args) {var params = arguments[0],
	$ = skuid.$;

var appModel = skuid.model.getModel('Application');
var appRow = appModel.data[0]; 
 //alert(appRow.genesis__Account__r.AccountNumber) ;

if(appRow.Id !== null && appRow.genesis__Account__r.AccountNumber !== undefined && appRow.genesis__Account__r.AccountNumber !== null)
{
   
	 var ret = sforce.apex.execute("SAF_PepSanction","GetPepSanctionApplication",
       {   
	   
           strCustomerId : appRow.genesis__Account__c,
           strAppId : appRow.Id,
           IsSelected : false
       });
       alert(ret);
       window.location.reload();
     

}
else
{
		       alert('Company Registration is null');
}
});
skuid.snippet.register('GetRelatedCustomers',function(args) {var params = arguments[0],
	$ = skuid.$;
var AppModel = skuid.model.getModel('Application');
var custModel = skuid.model.getModel('Customers');
var contactModel = skuid.model.getModel('contacts');
var pepAppModel = skuid.model.getModel('PEP_APP_Customer');
var custRow = custModel.data[0]; 
var appRow = AppModel.data[0]; 
  //alert(custModel.data.length) ;
 
 var total = custModel.data.length + contactModel.data.length;
 // alert(total) ;
if(custRow.Id !== null && custRow.AccountNumber !== undefined && custRow.AccountNumber !== null)
{
     // alert(custRow.Name) ;
	 var ret = sforce.apex.execute("SAF_PepSanction","GetRelatedCustomers",
       {   
	   
           CompanyId : custRow.AccountNumber,
           strCompanyName : custRow.Name
       });
       
        //alert(ret);
      
        custModel.setCondition(custModel.getConditionByName('IdConditionName'),ret);
        $.when(custModel.updateData()).then(function(){
            //Do anything you need to do after the query here.
        });
      
      custModel.save({callback: function(result){
        if (result.totalsuccess) {
                // Get the 15-digit Id of our newly-saved George Bailey Contact,
                // which will have had its Id and other fields updated after save
                //console.log(georgeBailey.Id15);
                // Show the entire George Bailey Contact record
                //console.log(georgeBailey);
              //  alert('The save success.');
            } else {
                alert('The save failed.');
                console.log(result.insertResults);
                console.log(result.updateResults);
                console.log(result.deleteResults);
            }
        }});
        //alert('going for contacts');
        contactModel.setCondition(contactModel.getConditionByName('GetDirectors'),ret);
        $.when(contactModel.updateData()).then(function(){
            //Do anything you need to do after the query here.
        });
        
         contactModel.save({callback: function(result){
        if (result.totalsuccess) {
                // Get the 15-digit Id of our newly-saved George Bailey Contact,
                // which will have had its Id and other fields updated after save
                //console.log(georgeBailey.Id15);
                // Show the entire George Bailey Contact record
                //console.log(georgeBailey);
                //alert('The save success.');
            } else {
                alert('The save contact failed.');
                console.log(result.insertResults);
                console.log(result.updateResults);
                console.log(result.deleteResults);
            }
        }});
        
       //window.location.reload();
      /* var retStatus = sforce.apex.execute("SAF_PepSanction","GetAppStatus",
       {   
           strAppId : appRow.Id,
           strCustId : appRow.genesis__Account__c
       });
       alert(retStatus);*/
}
else
{
		       alert('Company Registration number is null');
}
});
skuid.snippet.register('GetSelectedCompanies',function(args) {var params = arguments[0],
	$ = skuid.$;
    action = arguments[0].action,
    list = arguments[0].list,
    model = arguments[0].model,
    selectedItems = list.getSelectedItems();
   var appModel = skuid.model.getModel('Application');
   var appRow = appModel.data[0]; 

    var selectedItems = arguments[0].list.getSelectedItems();
        $.each( selectedItems,
        function( i, item )
        {
           var custRow = item.row;
           //alert(custRow.Name);
            var ret = sforce.apex.execute("SAF_PepSanction","GetPepSanctionApplication",
               {   
        	   
                   strCustomerId : custRow.Id,
                   strAppId : appRow.Id,
                   IsSelected : true
               });
        alert(custRow.Name + ' : '+ ret);
        });
        alert('PEp sanction done for all customers.');
    
    var custmodel = skuid.model.getModel('Customers');
    var contactmodel = skuid.model.getModel('contacts');
    var total = custmodel.data.length + contactmodel.data.length;
      //alert(total) ;
      
     var retStatus = sforce.apex.execute("SAF_PepSanction","GetAppStatus",
       {   
           strAppId : appRow.Id,
           strCustId : appRow.genesis__Account__c,
           totalrecords : total
       });
       alert(retStatus);
        
        window.location.reload();
});
skuid.snippet.register('Page Refresh',function(args) {var params = arguments[0],
	$ = skuid.$;
	var appModel = skuid.model.getModel('Application');
  
    if (appModel.Id !== null)
    {
        window.location.reload();
    }
});
skuid.snippet.register('pepcheckselected',function(args) {var table = skuid.$('#MyTable'),
   list,
   items;
if (table.length) {
      // alert(table.length);
   list = table.data('object').list;
   items = list.getSelectedItems();
  
}
 var appModel = skuid.model.getModel('Application');
 var appRow = appModel.data[0]; 
   
        $.each( items,
        function( i, item )
        {
           var custRow = item.row;
          // alert(custRow.Name);
            var ret = sforce.apex.execute("SAF_PepSanction","GetPepSanctionApplication",
               {   
        	   
                   strCustomerId : custRow.Id,
                   strAppId : appRow.Id,
                   IsSelected : false
               });
        alert(custRow.Name + ' : '+ ret);
        });
      window.location.reload();
});
skuid.snippet.register('pepcheckselected2',function(args) {var appModel = skuid.model.getModel('Application');
 var appRow = appModel.data[0]; 
   
 var OutstandingItemModel = skuid.model.getModel('Customers');
$.each(OutstandingItemModel.data,function(i,row){
 
       var ret = sforce.apex.execute("SAF_PepSanction","GetPepSanctionApplication",
               {   
        	   
                   strCustomerId : row.Id,
                   strAppId : appRow.Id,
                   IsSelected : false
               });
        alert(row.Name + ' : '+ ret);
      
  
});

     var contactmodel = skuid.model.getModel('contacts');
$.each(contactmodel.data,function(i,row){
       // alert(row.Name);
        var ret2 = sforce.apex.execute("SAF_PepSanction","GetPepSanctionApplicationInd",
               {   
        	   
                   strContactId : row.Id,
                   strAppId : appRow.Id,
                   IsSelected : false
               });
        alert(row.Name + ' : '+ ret2);
  
});

    var total = OutstandingItemModel.data.length + contactmodel.data.length;
    //alert(total) ;
 
     var retStatus = sforce.apex.execute("SAF_PepSanction","GetAppStatus",
       {   
           strAppId : appRow.Id,
           strCustId : appRow.genesis__Account__c,
           totalrecords : total
       });
       alert(retStatus);
       
      window.location.reload();
});
skuid.snippet.register('GetSelectedContacts',function(args) {var params = arguments[0],
	$ = skuid.$;
    action = arguments[0].action,
    list = arguments[0].list,
    model = arguments[0].model,
    selectedItems = list.getSelectedItems();
   var appModel = skuid.model.getModel('Application');
   var appRow = appModel.data[0]; 

    var selectedItems = arguments[0].list.getSelectedItems();
        $.each( selectedItems,
        function( i, item )
        {
           var custRow = item.row;
           alert(custRow.Name);
            var ret = sforce.apex.execute("SAF_PepSanction","GetPepSanctionApplicationInd",
               {   
        	   
                   strContactId : custRow.Id,
                   strAppId : appRow.Id,
                   IsSelected : true
               });
        alert(custRow.Name + ' : '+ ret);
        });
       // alert('PEp sanction done for all customers.');
    var custmodel = skuid.model.getModel('Customers');
    var contactmodel = skuid.model.getModel('contacts');
    var total = custmodel.data.length + contactmodel.data.length;
      //alert(total) ;
      
     var retStatus = sforce.apex.execute("SAF_PepSanction","GetAppStatus",
       {   
           strAppId : appRow.Id,
           strCustId : appRow.genesis__Account__c,
           totalrecords : total
       });
       alert(retStatus);
        window.location.reload();
});
skuid.snippet.register('UnionSnippet',function(args) {alert('Snippet executed');
var CustomerModel = skuid.model.getModel("Customers");
var Pep_AppModel = skuid.model.getModel("Pep_App");
var targetModel = skuid.model.getModel("UnionModel");
var newRowsFromA = CustomerModel.getRows().map(function(sourceRow) {
    return {
         Customer: sourceRow.Id,
         LastModifiedDate: sourceRow.LastModifiedDate,
         LastModifiedBy: sourceRow.LastModifiedBy.LastName,
    };
});
var newRowsFromB = Pep_AppModel.getRows().map(function(sourceRow) {
    return {
         Customer: sourceRow.saf_Customer__c,
         LastModifiedDate: sourceRow.LastModifiedDate,
         LastModifiedBy: sourceRow.LastModifiedBy.Name,
    };
});
targetModel.adoptRows(
   newRowsFromA.concat(newRowsFromB)
);
});
skuid.snippet.register('CheckPassbutton',function(args) {var appModel = skuid.model.getModel('Application');
 var appRow = appModel.data[0]; 
  var strreturn = false;  
  var intcountred =0;var intcountredchecked =0;
 var OutstandingItemModel = skuid.model.getModel('Customers');
$.each(OutstandingItemModel.data,function(i,row){
 if(row.saf_IsRed__c > 0) {intcountred = intcountred + 1;}
 if(row.saf_IsRed__c > 0 && row.saf_manual_check__c === true && row.saf_comments__c !== null) {intcountredchecked = intcountredchecked + 1;}
 //else {strreturn = false;}
     
  //alert(strreturn);
      
  
});
//if(intcountred === intcountredchecked ) {strreturn = true;}

 var intcountred_c =0;var intcountredchecked_c =0;
 var OutstandingItemModel = skuid.model.getModel('contacts');
$.each(OutstandingItemModel.data,function(i,row){
 if(row.saf_IsRed__c > 0) {intcountred_c = intcountred_c + 1;}
 if(row.saf_IsRed__c > 0 && row.saf_manual_check__c === true && row.saf_comments__c !== null) {intcountredchecked_c = intcountredchecked_c + 1;}
 //else {strreturn = false;}
     
  //alert(strreturn);
      
  
});
if((intcountred > 0 || intcountred_c >0) && intcountred === intcountredchecked && intcountred_c === intcountredchecked_c) {strreturn = true;}
//alert(strreturn);
return strreturn;
});
skuid.snippet.register('Passcustomers',function(args) {var pepappModel = skuid.model.getModel('Pep_App_All');
 
 var custModel = skuid.model.getModel('Customers');

$.each(pepappModel.data,function(p,rowp){
    $.each(custModel.data,function(i,rowc){
         
 if(rowp.saf_Customer__c === rowc.Id && rowp.saf_Individual__c === undefined )
     {
         if(rowc.saf_IsRed__c > 0 && rowc.saf_manual_check__c === true && rowc.saf_comments__c !== null) {
           rowp.SAF_Status__c = 'PEPs and Sanctions Passed - Manually Verified';
        
           pepappModel.updateRow(rowp,'SAF_Status__c','PEPs and Sanctions Passed - Manually Verified');
           alert(rowp.SAF_Status__c + rowp.saf_Customer__r.Name);
     }
     }
    });
});
//if(intcountred === intcountredchecked ) {strreturn = true;}
   /*  pepappModel.save({callback: function(result){
        if (result.totalsuccess) {
              
               alert('The save success.');
            } else {
                alert('The save failed.');
              
            }
        }});*/
        
       
        pepappModel.save();
});
}(window.skuid));