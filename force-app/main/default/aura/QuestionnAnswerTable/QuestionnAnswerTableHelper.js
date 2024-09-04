({
	getqnaWrapperhelper : function(component, event, helper) {
        var action = component.get('c.getQnA');
        action.setCallback(this, function(response) {
        //store state of response
        var state = response.getState();
            //alert(state);
        if (state === "SUCCESS") {
          //set response value in wrapperList attribute on component.
          var result=response.getReturnValue();
            alert(result);
            //console.log(json.stringify(result));
          component.set('v.metaList', response.getReturnValue());
        }
      });
      $A.enqueueAction(action);
		
	},
    
     saveSurvey : function(component, event,helper) {
        var survey = component.get("v.Survey");
        alert(survey);
        var action = component.get("c.createSurvey");
        action.setParams({
            survobj : survey
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