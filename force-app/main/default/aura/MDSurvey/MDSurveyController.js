({
	doInit: function(component, event, helper) {  
       helper.getQnAValues(component, event);
        
    },
       
    saveSurvey : function(component,event,helper){
        
        helper.saveSurvey(component, event);
        //helper.saveQnA(component,event);
    }
        
        
    
    
    
     
})