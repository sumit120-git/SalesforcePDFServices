({
     doInit : function(component, event, helper) {
       
     },
	searchMovies : function(component, event, helper) {
        
        var searchVariable=component.get("v.searchVariable");
        if(searchVariable!=''){
            
        var action=component.get("c.getMovieDetails");
            action.setParams({
                searchVariable:searchVariable 
            });
        action.setCallback(this,function(response){
            var responsestate=response.getState();
            if(responsestate==="SUCCESS"){
                var responsevalue=response.getReturnValue();
               //var resbobj=JSON.parse(responsevalue);
                console.log(responsevalue);
                component.set('v.MovieDetails',responsevalue);
            }
            
           
        });
            $A.enqueueAction(action);
		
	}
    }
    
})