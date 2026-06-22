/**
@Description: This Apex Class is the controller for the ReservationTrigger . It handles calling the helper method in Exercise5 class to check for overlapping reservations.
@Author: Alice Mazeh
@Company: EI-Technologies
@Last Modified : 19/06/2024
@Last Modified By  : Alice Mazeh
@Related Classes: ReservationTriggerHandler.cls

@Test Class: ReservationTriggerHandler_Test.cls
*/


public with sharing class Exercise5 {

    public static void ReservationResourse (List <Resource_reservation__c> reservations , Map<Id,Resource_reservation__c > newMap, Map<Id,Resource_reservation__c> oldMap) {
        //for trigger  its a helper method

       
        Map<String,List<Resource_reservation__c>> reservedResources = new Map<String,List<Resource_reservation__c>>();

          Set<String> reserved= new Set<String>();

          Time minStartDate;
          Time maxEndDate;

        for(Resource_reservation__c  rs : reservations) {// For each reservation in new trigger compare
            if (oldMap==null || oldMap.get(rs.Id).Reserved_resource__c != rs.Reserved_resource__c || oldMap.get(rs.Id).Start_date_of_use__c != rs.Start_date_of_use__c || oldMap.get(rs.Id).End_date_of_use__c != rs.End_date_of_use__c) {
                reserved.add(rs.Reserved_resource__c);
            }

            if (minStartDate == null || rs.Start_date_of_use__c < minStartDate) {
                minStartDate = rs.Start_date_of_use__c;
            }
            if (maxEndDate == null || rs.End_date_of_use__c > maxEndDate) {
                maxEndDate = rs.End_date_of_use__c;
            }
        }

        if (reserved.isEmpty()) return;

        if (minStartDate == null) minStartDate = Time.newInstance(0,0,0,0);/// if minStartDate is null set it to the earliest time of the day
        if (maxEndDate == null) maxEndDate = Time.newInstance(23,59,59,999);/// if maxEndDate is null set it to the latest time of the day

        List<Resource_reservation__c> queryResults = [SELECT Id, Reserved_resource__c, Start_date_of_use__c, End_date_of_use__c
         FROM Resource_reservation__c 
         WHERE Reserved_resource__c IN :reserved
         AND (Start_date_of_use__c <= :maxEndDate AND End_date_of_use__c >= :minStartDate)
         ]; //query all reservations for the reserved resources in the trigger

        for (Resource_reservation__c res : reservations) {
            //for each reservation in the trigger compare with the query results  
            for (Resource_reservation__c all : queryResults) {
                if (res.Id == all.Id) continue;

                if (res.Reserved_resource__c == all.Reserved_resource__c
                    && res.Start_date_of_use__c <= all.End_date_of_use__c
                    && res.End_date_of_use__c >= all.Start_date_of_use__c) {
                    res.addError('The reserved resource is already reserved for the selected dates');
                }
            }
        }


    }


}







