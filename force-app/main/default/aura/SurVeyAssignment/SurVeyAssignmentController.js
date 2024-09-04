({
    doInit:function(component, event, helper) { 
    },
    saveSurvey: function(component, event, helper) {  
        helper.saveSurvey(component, event);
    },
    addToQnA:function(component, event, helper){
        var qnarecord = event.getParam('test');
        qnarecord.MarkedAnswer__c = event.getParam('answer');
        var selectedIds = component.get("v.QnaRecordstoUpdate"); 
        selectedIds.push(qnarecord); 
        component.set("v.QnaRecordstoUpdate",selectedIds);
    },
    saveQnA:function(component, event, helper){
        var survey = component.get("v.QnaRecordstoUpdate");
        //alert(survey);
        var action = component.get("c.updateQnaRecords");
        action.setParams({
            qnaList : survey
        });
        
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                alert(state);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Success!',
                    message: 'The record has been updated successfully.'
                });
                
                toastEvent.fire();
                component.set("v.show",false);
               
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
             $A.get('e.force:refreshView').fire();
        });  //toastEvent.fire();     
        $A.enqueueAction(action);
    }
    
})