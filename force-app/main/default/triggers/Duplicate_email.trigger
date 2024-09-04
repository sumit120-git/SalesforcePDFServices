trigger Duplicate_email on Lead (before insert,before update) {
    
    
    List<Lead>lst=[select id,email from Lead];
    Map<String,Lead> mp = new Map<String,Lead>();
    for(Lead ld:lst){
        
        mp.put(ld.email,ld);
        
    }
    
    for(Lead l:trigger.new){
        if((l.email!=null) && (trigger.isInsert ||(l.email != trigger.oldMap.get(l.iD).email))){
            if(mp.containsKey(l.email)){
                system.debug('duplicate found');
                l.email.adderror('Duplicate email found');
            }
        }
        
    }
}