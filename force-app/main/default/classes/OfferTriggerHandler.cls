public with sharing class OfferTriggerHandler extends TriggerHandler implements ITriggerHandler {

    private Map<Id, Offer__c> newMap;
    private Map<Id, Offer__c> oldMap;
    private List<Offer__c> TriggerNew;
    private List<Offer__c> TriggerOld;

    public OfferTriggerHandler() {

        this.newMap = (Map<Id, Offer__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Offer__c>) Trigger.oldMap;
        this.TriggerNew = (List<Offer__c>) Trigger.new;
        this.TriggerOld = (List<Offer__c>) Trigger.old;
    }

    public static Boolean TriggerDisabled = false;

    public Boolean isDisabled() {
        return TriggerDisabled;
    }

    public override void beforeInsert() {

        Exercise4.generateIdentifiers(TriggerNew,newMap,oldMap);
    }

    public override void beforeUpdate() {

        Exercise4.generateIdentifiers(TriggerNew,newMap,oldMap );
    }

    public override void afterInsert() {}

    public override void afterUpdate() {}

    public override void beforeDelete() {}

    public override void afterDelete() {}

    public override void afterUnDelete() {}
}