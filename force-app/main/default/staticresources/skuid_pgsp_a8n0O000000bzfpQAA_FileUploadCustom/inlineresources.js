(function(skuid){
skuid.snippet.register('RenderFileName',function(args) {var field = arguments[0],
    value = arguments[1],
	$ = skuid.$;

field.element.text(value);
});
skuid.snippet.register('SelectUploadedFiles',function(args) {var params = arguments[0],
	$ = skuid.$;

var allAttachments = params.model.data;
//var origAttachments = getCurrentAttachments();
var DocumentModel = skuid.model.getModel('AppDocumentCategory');
var DocuModel = DocumentModel.data[0];
var AttacModel = skuid.model.getModel('Attachment');
var AttModel = AttacModel.data[0];
var attachId = params.component.fileId;
//var attachId = params && params.component && params.component.fileId || '';
var fileName = params && params.component && params.component.fileName || '';


//alert('hi'); return 0;
//console.log(params.component);
if(attachId !== null)
{
try {
    
    var documentSize = sforce.apex.execute("SAF_DocumentUploadToSharePoint","attachmentSize",{attachmentId:attachId});
    if(documentSize == 'false'){
        alert('Failed to Upload. Please upload files less than 6MB.');
         iteration++;
         var id = DocuModel.genesis__Application__c;
          if(iteration == fileSize)
            {
           // skuid.snippet.getSnippet('enableUploadButton')();    
            parent.location = '/'+id+'?skuidonly=1'; 
            }
        return;
    }
    
    var documentInfo = sforce.apex.execute("SAF_Custom_DocumentUploadToSharePoint","sendApplicationDocToSharePointCustom",{folderName:'Transact',attchmentId:attachId,appId:DocuModel.genesis__Application__c});
    
    if(documentInfo !== ''){
        console.log('Invoke Document Response :'+documentInfo);
     //Invoke SharePoint and grab the file URL after successful upload    
       var sharePointResponse = sforce.apex.execute("DocumentUploadClass","processSharePoint",{filePathURL:documentInfo[0],attachmentId:documentInfo[1]});
     // alert(sharePointResponse);
      // var sharepointURL = '<a href="sharePointResponse">View Document</a>' 
       //validate the response retrieved
      /* if(sharePointResponse !== null && sharePointResponse == 'Error'){
            console.log('Invoke SharePoint Response :'+sharePointResponse);
        var documentInfo = sforce.apex.execute("SAF_DisplayLinks","displayLinks",{url:sharePointResponse,appId:DocuModel.genesis__Application__c});
            alert(sharePointResponse);

       }*/
      /* alert(sharePointResponse);
       if(sharePointResponse != 'ERROR')
           alert('yes');
       else
       alert('No'); */
 
       
        if(sharePointResponse !== null && sharePointResponse !== 'Error'){
           // alert(sharePointResponse);
            console.log('Invoke SharePoint Response :'+sharePointResponse);
        var documentInfo = sforce.apex.execute("SAF_Custom_DisplayLinks","displayLinksCustom",{fileReturnUrl:documentInfo[0],url:sharePointResponse,appId:DocuModel.genesis__Application__c});
            //alert(sharePointResponse);

       }
       
       if(sharePointResponse !== null && sharePointResponse !== 'Error'){
            console.log('Invoke SharePoint Response to delete the file :'+sharePointResponse);
            console.log('Att Id'+attachId);
        var documentInfoDelete = sforce.apex.execute("SAF_DocumentUploadToSharePoint","deleteAttachment",{attId:attachId,appId:DocuModel.genesis__Application__c});
            //alert(sharePointResponse); 
           
            //redirect code based on last file 
            iteration++;
            var id = DocuModel.genesis__Application__c;
            if(iteration == fileSize)
            {
            skuid.snippet.getSnippet('enableUploadButton')();
            parent.location = '/'+id+'?skuidonly=1';
            }

       }
    }

 }
 catch(err) {
  alert(err);
}
}

//window.reload();
});
var fileSize;
var iteration = 0;

(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	
    	//Retrict multiple file selection
    // 	$("input[type='file']").removeAttr('multiple');
    	
    	
    	$("input[type='file']").change(function () {
                
                fileSize = this.files && this.files.length;
    
                if ($(this).val()) {
                       $(this).attr('disabled', 'disabled');
                    } 
                
        });

	});
})(skuid);;
skuid.snippet.register('enableUploadButton',function(args) {var params = arguments[0],
	$ = skuid.$;
	
	// Enable file upload button if file upload fails.
	$("input[type='file']").removeAttr('disabled');
});
skuid.snippet.register('SendFailureEmail',function(args) {var params = arguments[0],
	$ = skuid.$;

var DocumentModel = skuid.model.getModel('AppDocumentCategory');
var DocuModel = DocumentModel.data[0];
var applnName = DocuModel.genesis__Application__r.Name; 
	try
    	{
        var emailInfo = sforce.apex.execute("SAF_Custom_DocumentUploadToSharePoint","sendFailureEmail",{error:params.$Error.Message,Name:applnName});
        
        if(emailInfo !== '')
        {
             console.log(emailInfo);
        }
	}
	catch(err)
	{
	  console.log(err);
	}
	
var id = DocuModel.genesis__Application__c;
if(id)	
 parent.location = '/'+id+'?skuidonly=1';
});
}(window.skuid));