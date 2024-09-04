({
    doinit : function(component, event, helper) {
        var qnaRecord = component.get('v.test');
        var optionstr = component.get('v.option');
        var array = [];
        var resultArray = optionstr.split(',');
      // array = optionstr.split(",");
        component.set('v.options',resultArray);
    },
    handleOnChange : function(component, event, helper) {
        var answer = component.find("OptionPicklist").get("v.value");
        var cmpEvent = component.getEvent("QnAevt");
        cmpEvent.setParams( { "test" : component.get("v.test") ,"answer" : answer} );
        cmpEvent.fire();
    },
})