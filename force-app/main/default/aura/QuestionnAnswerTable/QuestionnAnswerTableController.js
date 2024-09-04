({
	doInit : function(component,event,helper) {
        console.log('***In controller');
        helper.getqnaWrapperhelper(component, event, helper);
		
	},
    
     saveSurvey : function(component, event, helper) {
        helper.saveSurvey(component, event,helper);
    }
     
})