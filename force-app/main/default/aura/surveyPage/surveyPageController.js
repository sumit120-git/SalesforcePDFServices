({
	
    doInit: function(component, event, helper) {        
        helper.getPicklistValues(component, event);
    },
     
    
    /*savesurvey : function(component, event, helper) {
        helper.saveSurvey(component, event);
    },
     
    //handle Industry Picklist Selection
    handleOnChange : function(component, event, helper) {
        var survey = component.get("v.Survey__c.Answer__c");
        alert(survey);
    }*/

})