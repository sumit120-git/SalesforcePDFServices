({
    createModal : function(component, event, helper) {
        $A.createComponent(
            "c:modalContent",{},
            function(myModal){
                if (component.isValid()) {
                    var targetCmp = component.find('ModalDiv');
                    var body = targetCmp.get("v.body");
                    body.push(myModal);
                    targetCmp.set("v.body", body);           
                }
            }
        );
    },
})