({
    init: function(cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");
        var firstname = myPageRef.state.c__firstname;
        cmp.set("v.firstname", firstname);
    }
})