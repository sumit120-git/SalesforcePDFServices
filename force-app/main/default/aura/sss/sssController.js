({
    init:function(component,event,handler){
        var pageReference= {
            type: 'standard__component',
            attributes:{
                componentName:'c__Component2',
            },
            state:{
                "c__FirstName":"Sumit"
            }
        };
        component.set("v.pageReference",pageReference);
    },
    
    handleClick:function(component,event,helper){
        var navService=component.find("navService");
        var pageReference=component.get('v.pageReference');
        event.preventDefault();
        navService.navigate(pageReference);
    }
    
    
})