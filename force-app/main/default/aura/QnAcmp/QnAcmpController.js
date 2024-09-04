({
 doinit : function(component, event, helper) {
  var Question=component.get("v.Question");
     console.log(Question);
        var map=component.get("v.map");
     console.log(map);
     var str = map[Question];
     var arr = str.split(",");
     console.log(arr);
        component.set("v.Options",arr);
 },
        
        //handle Industry Picklist Selection
    handleOnChange : function(component, event, helper) {
        var answer = component.find("OptionPicklist").get("v.value");
        //component.set("v.Answers",answer);
        //console.log(answer);
         var cmpEvent = cmp.getEvent("QnAevt");
        // Get the value from Component and set in Event
        cmpEvent.setParams( { "test" : cmp.get("v.test") } );
        cmpEvent.fire();
    },
        
        saveQnA : function(component,event,helper) {
           var map = component.get("v.map");
            var arrayMapQuestion = [];
            for(var key in map){
                
                    arrayMapQuestion.push({key: key, value: map[key]});
                }
            var action = component.get("c.createQnA");
            action.setParams({
                mapQnA : arrayMapQuestion
            });
            action.setCallback(this,function(response){
        var state = response.getState();
            if(state === "SUCCESS"){
                //component.set("v.show",true);
                Alert(state);
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