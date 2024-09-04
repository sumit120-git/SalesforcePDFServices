({
    packItem:function(component,event,helper){
        var xyz=component.get("v.item");
        console.log(xyz);
      
        component.set("v.item.Packed__c",true);
        var bclicked=event.getSource();
        bclicked.set("v.disabled",true);
    }
})

/*({
    packItem : function(component, event, helper) {

        component.set("v.item.Packed__c",true );
        var buttonclicked=event.getSource();
        buttonclicked.set("v.disabled","true");
        
    }
})*/