({
    onPageReferenceChange: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var firstname = myPageRef.state.c__firstname;
        component.set("v.firstname", firstname);
    }
})