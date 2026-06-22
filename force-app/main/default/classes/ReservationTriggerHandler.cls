public with sharing class ReservationTriggerHandler extends TriggerHandler implements ITriggerHandler {
    
       
    private Map<Id, Resource_reservation__c> newMap;
    private Map<Id, Resource_reservation__c> oldMap;
    private List<Resource_reservation__c> TriggerNew;
    private List<Resource_reservation__c> TriggerOld;

    public ReservationTriggerHandler() {

        this.newMap = (Map<Id, Resource_reservation__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Resource_reservation__c>) Trigger.oldMap;
        this.TriggerNew = (List<Resource_reservation__c>) Trigger.new;
        this.TriggerOld = (List<Resource_reservation__c>) Trigger.old;
    }

    public static Boolean TriggerDisabled = false;

    public Boolean isDisabled() {
        return TriggerDisabled;
    }

    public override void beforeInsert() {

        Exercise5.ReservationResourse(TriggerNew, newMap, oldMap);
    }

    public override void beforeUpdate() {

        Exercise5.ReservationResourse(TriggerNew,  newMap, oldMap);
    }

    public override void afterInsert() {}

    public override void afterUpdate() {}

    public override void beforeDelete() {}

    public override void afterDelete() {}

    public override void afterUnDelete() {}
}

    
