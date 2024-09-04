({
    
    getPicklistValues: function(component, event) {
        var action = component.get("c.getAnswerValue");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            alert(state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.fieldMap", fieldMap);
            }
        });
        $A.enqueueAction(action);
    },
     
    
    saveSurvey : function(component, event) {
        var survey = component.get("v.Survey__c");
        var action = component.get("c.createSurvey");
        action.setParams({
            survobj : Survey__c
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                alert('Record Created Successfully!!');
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
})