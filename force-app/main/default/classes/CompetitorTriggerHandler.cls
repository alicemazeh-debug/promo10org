public with sharing class CompetitorTriggerHandler extends TriggerHandler implements ITriggerHandler {

    // FIXED: Changed from Contact to Competitor__c
    private Map<Id, Competitor__c> newMap;
    private Map<Id, Competitor__c> oldMap;
    private List<Competitor__c> TriggerNew;
    private List<Competitor__c> TriggerOld;
    
    public CompetitorTriggerHandler(){
        // FIXED: Updated the type casting
        this.newMap = (Map<Id, Competitor__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Competitor__c>) Trigger.oldMap;
        this.TriggerNew = (List<Competitor__c>) Trigger.New;
        this.TriggerOld = (List<Competitor__c>) Trigger.Old;
    }
    
    public static Boolean TriggerDisabled = false;
    
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        // FIXED: Passing only TriggerNew to match the class signature
        Exercise3.checkCompetitorLinks(TriggerNew, newMap, oldMap);
    }
    
    public override void beforeUpdate() {
        // If your duplicate logic doesn't use oldMap, pass only TriggerNew here too
         Exercise3.checkCompetitorLinks(TriggerNew, newMap, oldMap);
    }

    public override void afterInsert() {
       Exercise3.assignCompetitorToAccount(TriggerNew , oldMap); 
    }
    public override void afterUpdate() {
        Exercise3.assignCompetitorToAccount(TriggerNew , oldMap); 
    }
    public override void beforeDelete() {}
    public override void afterDelete() {}
    public override void afterUnDelete() {}
}