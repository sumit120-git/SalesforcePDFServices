({
	handlecompEventfired : function(component, event, helper) {
		var context=event.getParam("context");
        component.set("v.mostRecentEvent",context);
	},
    
    handleAppEventfired:function(component,event,helper){
       		var context=event.getParam("context");
        component.set("v.mostRecentEvent",context); 
    }
})