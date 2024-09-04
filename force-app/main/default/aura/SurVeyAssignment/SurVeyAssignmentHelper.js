({
    saveSurvey : function(component, event) {
        //debugger;
        var survey = component.get("v.Survey");
         var allValid = component.find('input').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if(allValid){
            //alert('All form entries look valid. Ready to submit!');
        var action = component.get("c.createSurvey");
        action.setParams({
            survobj : survey
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                
                var result = response.getReturnValue();
                
                component.set("v.QnaRecords",response.getReturnValue());
                    component.set("v.show",true);
               
                
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
        });       
        $A.enqueueAction(action);
    }
        else{
            alert("error");
        }
    }
})