({
    edit:function(component,event,helper){
        var editEvent=$A.get("e.force:editRecord");
            
        editEvent.setParams({
            "recordId":component.get("v.recordId")
        });
        editEvent.fire();
    }
})