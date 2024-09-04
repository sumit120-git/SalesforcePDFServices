public with sharing class MyComponentController {

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunityRecordMethod(Id recordId) {

        List<Opportunity> opptyList = new List<Opportunity>();

        if (Opportunity.SObjectType.getDescribe().isAccessible()) {
            opptyList = [SELECT Id, Name, Type, StageName FROM Opportunity WHERE Id = :recordId];
        }

        return opptyList;
    }
}
