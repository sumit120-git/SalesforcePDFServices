trigger opptLineItem_insertt on Opportunity (after insert) {
    
    set<Id>st=new set<Id>();
    for(opportunity opp:trigger.new){
        st.add(opp.id);
    }
    List<OpportunityLineItem> lst = new List<OpportunityLineItem>();
        for(opportunity o:trigger.new){
            
         OpportunityLineItem op=new opportunityLineItem();
            op.OpportunityId=o.Id;
            op.Product2Id=op.Product2Id;
            op.Quantity=5;
            op.TotalPrice=250000;
            op.PricebookEntryId=op.PricebookEntryId;
            lst.add(op);
        }
    insert lst;

}