trigger send_email on Contact (after insert) {
    
    for(contact con:trigger.new){
        HelperContactTrigger.sendEmail(trigger.new);
    }

}