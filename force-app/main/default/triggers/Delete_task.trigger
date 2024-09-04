trigger Delete_task on Task (before delete) {
    List<User>lst = [select profile.name from user  where id =: userinfo.getUserId()];
    for(Task t:trigger.old){
        if(lst[0].profile.name!='System Administrator'){
            t.addError('cant be deleted');
        }
      
    }

}