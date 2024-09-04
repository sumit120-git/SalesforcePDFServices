trigger Lead_email on Lead (after insert) {
    
    List<lead>ld=new List<Lead>();
    ld=[select id,email from lead ];
    
    for(Lead ld:trigger.new){
        messaging.EmailFileAttachment attach = new messaging.EmailFileAttachment();
        attach.setFileName('SFDC Access.pdf');
        attach.setContentType('application/pdf');
        
        messaging.SingleEmailMessage mail=new messaging.SingleEmailMessage();
        
        mail.setToAddresses(new String[] {'sumit.suman@bakerhughes.com'});
    mail.setSubject('PDF Generation');
    mail.setHtmlBody('PFA');
        
    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
    }

}