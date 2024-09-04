({
 createContact: function (component) {
       var createAcountContactEvent = $A.get('e.force:createRecord');
createAcountContactEvent.setParams({
    "entityApiName": "Contact",
    "defaultFieldValues": {
        'Phone' : '415-240-6590',
        'AccountId' : '001xxxxxxxxxxxxxxx'
    }
});
createAcountContactEvent.fire();
        }
    
})