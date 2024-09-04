({
	handleEvent : function(component, event, helper) {
		var message=event.getParam("color");
        component.set("v.color",message);
	}
})