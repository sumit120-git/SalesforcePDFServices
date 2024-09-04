/*trigger Update_contact on Account (before delete) {
    Set<Id>st=new Set<Id>();Integer count=0;
    for(Account acc:trigger.old){
        st.add(acc.Id);
    }
    
    List<Account>lst=[select id,(select id from contacts) from Account where id in:st];
    Map<Id,Account> mp=new Map<id,Account>();
    for(Account acc:lst){
        mp.put(acc.id,acc);
    }
    
    for(Account a:trigger.old){
        if(mp.get(a.Id).contacts.size()>=1){
            a.addError('cant be deleted');
        }
    }
    
}*/

/*trigger Update_contact on Account (after update) {
   set<Id>st=new set<Id>();
    List<Contact>con = new List<Contact>();
    
    for(Account acc:trigger.new){
        if(acc.Amount__c!=Null && 
           acc.Amount__c!=trigger.oldMap.get(acc.id).Amount__c){
            st.add(acc.Id);
        }
        system.debug('set is'+st);
    }
    List<Account> acct=[select id,Amount__c,(select id,Amount__C from contacts) from Account where id in:st];
    map<Id,Account>mp=new Map<Id,Account>(acct);
    for(Account a:acct){
        Integer count=mp.get(a.Id).contacts.size();
        system.debug('count of contact'+count);
        Decimal storeamount = a.Amount__C/count ;
        
        for(contact cont:a.contacts){
            system.debug('Here');
            cont.Amount__C = storeamount;
            con.add(cont);
        }
        
    }
    
    update con;
    
   
}*/

trigger Update_contact on Account (after update) {
    
    set<id>st=new set<id>();
    for(Account acc:trigger.new){
        if(acc.phone!=null &&(trigger.oldmap.get(acc.ID).phone!=acc.phone)){
            st.add(acc.Id);
        }
        
        Map<Id,Account>mp=new Map<id,Account>([select id,phone,(select id,phone from contacts) from Account where id in:st]);
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}