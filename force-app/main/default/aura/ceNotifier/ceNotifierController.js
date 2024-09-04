({
	fireComponentEvent : function(component, event, helper) {
        
        var cmpEvent=component.getEvent("cmpEvent");
        cmpEvent.setParams({
            "color":"green"
        });
        
        cmpEvent.fire();
		
	}
})