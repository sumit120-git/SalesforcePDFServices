({
	clickCreateItem : function(component, event, helper) {
        
        var check=component.find('newItemform').reduce(function(validsoFar,inputcmp){
            inputcmp.showmessageifInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        },true);
        
        if(validform){
            var newItem=component.get("v.newItem");
           
        }
		
	}
})