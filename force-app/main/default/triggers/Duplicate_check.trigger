trigger Duplicate_check on Contact (before insert) {
    List<String>lst=new List<String>();
    
    Map<String,contact>mp=new Map<String,Contact>();
    for(contact c:[select id,phone,email from contact]){
        
        mp.put(c.phone,c);
        mp.put(c.email,c);
    }
   
// List<contact>cont=[select id,phone,email from contact where id in : trigger.new];
    for(contact con:trigger.new){
        
        if(mp.get(con.email)!=null || mp.get(con.phone)!=null )
        {
            system.debug('errrr');
            con.addError('Phone already exists');
            
            
            
        }
    }
    
}