({
    getQnAValues: function(component, event) {
        
         var action = component.get("c.getQnA");
        action.setCallback(this,function(response)  {
                            var state = response.getState();
           // alert(state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                var arrayToStoreKeys=[];  // Declaring array to store Questions.
                /*for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                    console.log(fieldMap);
                }*/
                component.set("v.fieldMap", result);
                
                for(var key in result )
                {     
                   arrayToStoreKeys.push(key);   // Pushing Questions in array
                }
                component.set('v.list1',arrayToStoreKeys); 
            }        
                            });
         $A.enqueueAction(action);
         
         
     },
    
    saveSurvey:function(component,event){
        
          var survey = component.get("v.Survey");
        console.log(survey);
        
        var action = component.get("c.createSurvey");
       
        action.setParams({
            survobj : survey
        });
        action.setCallback(this,function(response){
        var state = response.getState();
            if(state === "SUCCESS"){
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
    
},
    
    
    
    
})