trigger Update_acc on Opportunity (after update) {
    set<Id>st = new Set<Id>();
    List<contact>cont = new List<Contact>();
    List<Account>acct = new List<Account>();
    for(Opportunity op:trigger.new){
        if(op.City__c!=null){
            st.add(op.accountId);
        }
    }
    
    List<Account>acc=[select id,city__c from account where id in:st];
    Map<Id,Account>mp=new Map<Id,Account>();
    for(Account a:acc){
        mp.put(a.Id,a);
    }
    List<Contact>con=[select id,city__c from contact where accountid in:mp.keySet()];
    for(opportunity opp:trigger.new){
        if(opp.city__C!=trigger.oldMap.get(opp.Id).city__C){
            for(Account a:acc){
                if(a.Id==opp.accountId){
                    a.city__C=opp.city__C;
                    
                }
                acct.add(a);
            }
            
            for(contact c:con){
                c.city__c=opp.city__C;
                cont.add(c);
            }
        }
    }
    
    update acct;
    update cont;
    

}