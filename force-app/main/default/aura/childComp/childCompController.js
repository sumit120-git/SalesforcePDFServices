({
	firecmp : function(component, event, helper) {
        var pName=component.get("v.pName");
		var cmpEvent=component.getEvent("cEvent");
        cmpEvent.setParams({"context":pName});
        cmpEvent.fire();
	},
    
    fireapp:function(component, event, helper) {
          var pName=component.get("v.pName");
        var appEvent=$A.get("e.c:appEvent");
        appEvent.setParams({"context":pName});
        appEvent.fire();
	}
})