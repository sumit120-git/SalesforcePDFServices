({
	 fetchAccounts : function(component, event, helper) {
         
         component.set('v.myColumns',[
             {label:'Account Name', fieldName:'Name', Type:'text' }	,
             {label:'Industry', fieldName:'Industry',Type:'Text',editable:'true'},
             {label:'Type',fieldName:'Type',
              type:'text'},
             {label:'City',fieldName:'City__c',type:'Text',editable:'true'},
             {label:'Active',fieldName:'Active__c',
              type:'picklist',editable:'true'}
         ]
                      );
         
      
        
        var accId = component.get("v.recordId");
         //alert(accId);
        
         
         var action=component.get("c.fetchAccountDetails");
         action.setParams({
             accId:accId
         });
         
         action.setCallback(this,function(response){
             if(response.getState()=== "SUCCESS"){
                 component.set("v.AccountList",response.getReturnValue());
             }
             
             else if(responseState==="ERROR"){
                var errors = response.getError();
                
                if(errors||errors[0].message){
                    
                    component.set("v.ErrorMsg",errors[0].pageErrors[0].message);
                }
            }
         });
         
         $A.enqueueAction(action);
		
	},
    
    editAccountDetailsModal:function(component,event,helper){
       
        component.set("v.isEditAccountModal",true);
       
        
        
    },
    
    handleSave:function(component,event,helper){
        var draftValues=event.getParam('draftValues');
        console.log(draftValues);
        var action=component.get("c.updateAccount");
        action.setParams({
            draftValues:draftValues
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    }
    
    
   
    
    
    

})