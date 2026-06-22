@IsTest
public with sharing class ReservationTriggerHandler_Test {

    // Helper method to get a valid picklist value
    private static String getFirstValidPicklistValue() {

        List<Schema.PicklistEntry> values =
            Resource_reservation__c.Reserved_resource__c
                .getDescribe()
                .getPicklistValues();

        if (!values.isEmpty()) {
            return values[0].getValue();
        }

        return null;
    }

    @TestSetup // Set up test data for all test methods
    static void setupTestData() {// Create an existing reservation to test overlap

        String resourceValue = getFirstValidPicklistValue();

        Resource_reservation__c existingReservation =
            new Resource_reservation__c(
                Reserved_resource__c = resourceValue,
                Start_date_of_use__c = Time.newInstance(10, 0, 0, 0),
                End_date_of_use__c = Time.newInstance(12, 0, 0, 0)
            );

        insert existingReservation;
    }

    @IsTest
    static void testReservationOverlapBlocked() {// Create an overlapping reservation to test the trigger

        String resourceValue = getFirstValidPicklistValue();

        Resource_reservation__c overlappingReservation = // This reservation overlaps with the existing one (11:00 - 13:00)
            new Resource_reservation__c(
                Reserved_resource__c = resourceValue,
                Start_date_of_use__c = Time.newInstance(11, 0, 0, 0),
                End_date_of_use__c = Time.newInstance(13, 0, 0, 0)
            );

        Test.startTest();

        Database.SaveResult result =// Attempt to insert the overlapping reservation
            Database.insert(overlappingReservation, false); // Use partial success to capture the error

        Test.stopTest();

        System.assertEquals(
            false,
            result.isSuccess(),
            'The overlapping reservation should not be inserted.'
        );

        System.assert(
            result.getErrors()[0]
                .getMessage()
                .contains(
                    'The reserved resource is already reserved for the selected dates'
                ),
            'Expected overlap error message.'
        );
    }

    @IsTest
    static void testReservationAllowed() {// Create a non-overlapping reservation to test the trigger

        String resourceValue = getFirstValidPicklistValue();

        Resource_reservation__c validReservation =// This reservation does not overlap with the existing one (12:00 - 14:00)
            new Resource_reservation__c(
                Reserved_resource__c = resourceValue,
                Start_date_of_use__c = Time.newInstance(12, 0, 1, 0),
                End_date_of_use__c = Time.newInstance(14, 0, 0, 0)
            );

        Test.startTest();

        Database.SaveResult result =
            Database.insert(validReservation, false);

        Test.stopTest();

        System.assert(
            result.isSuccess(),
            'The non-overlapping reservation should be inserted.'
        );

        System.assertNotEquals(
            null,
            result.getId(),
            'The inserted reservation should have an Id.'
        );
    }
}