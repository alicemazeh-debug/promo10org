trigger ReservationTrigger on Resource_reservation__c  (before insert, before update, before delete, after insert, after update, after delete) {
    new ReservationTriggerHandler().run();

}