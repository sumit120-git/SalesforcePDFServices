({
	
    doInit: function(component, event, helper) {  
        var label1 = $A.get("$Label.c.How_was_the_Ambience");
        var label2 = $A.get("$Label.c.Food_Quality");
        //alert(label);
        component.set("v.Survey.Question1__c", label1);
        component.set("v.Survey.Question2__c", label2);
        
        helper.getPicklistValues(component, event);
    },
     
    
    /*saveSurvey : function(component, event, helper) {
        helper.saveSurvey(component, event);
    },*/
     
    //handle Industry Picklist Selection
    handleOnChange : function(component, event, helper) {
        var survey = component.get("v.Survey.Answer__c");
        alert(survey);
    },
    

})