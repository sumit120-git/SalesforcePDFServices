trigger countContact on Contact (after insert,after update,after delete) {
    
    set<ID> acctids=new set<Id>();
    List<Account>acct=new List<Account>();
    if(trigger.isInsert || trigger.isUpdate){
        for(Contact con:trigger.new){
            acctids.add(con.accountid);
        }
    }
        if(trigger.isDelete ){
        for(Contact con:trigger.old){
            acctids.add(con.accountid);
        }
        }
            System.debug('Size'+ acctids.size());
            if(acctids.size()>0){
                for(Account acc:[select name,No_of_Contacts__c,(select Id from contacts) from Account where Id =:acctids])
                {
                    acc.No_of_Contacts__c=acc.contacts.size();
               
                
            
            acct.add(acc);
              
            }
            update(acct);
            }
    }