public with sharing class Exercise4 {
    public static void generateIdentifiers(List <Offer__c> offers , Map<Id,Offer__c > newMap, Map<Id,Offer__c> oldMap){
     Set<Id> oppIds = new Set<Id>();//collet opp Ids

     for(Offer__c offer : offers){

        if (offer.Opportunity__c != null){
            oppIds.add(offer.Opportunity__c);//add it to the set

        }
     }
         if (oppIds.isEmpty()) {// exist if no opp
            return;
        }
             Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
             [
                SELECT Id, Identifier__c
                FROM Opportunity
                WHERE Id IN :oppIds
             ]
              );
                      Map<Id, Integer> counterByOpp =new Map<Id, Integer>();//opp1--2(identifier)

                      for (AggregateResult ar : [SELECT Opportunity__c oppId , COUNT(Id) total FROM Offer__c
                         WHERE Opportunity__c IN :oppIds
                         GROUP BY Opportunity__c]) { //For each Opportunity, how many Offers already exist?

                            counterByOpp.put((Id) ar.get('oppId'),(Integer) ar.get('total'));
                         }

                         for(Offer__c offer : offers){ //assign identifiers to every new offer

                            Opportunity opp = oppMap.get(offer.Opportunity__c);//get parent opp

                            if ( opp ==null ){
                                continue;
                            }

                            Integer nextNumber = counterByOpp.containsKey(offer.Opportunity__c)? counterByOpp.get(offer.Opportunity__c): 0;

                         offer.Identifier__c = opp.Identifier__c +'-' + String.valueOf(nextNumber).leftPad(3, '0');//EIT-002

                         counterByOpp.put(offer.Opportunity__c,nextNumber + 1);//Increment counter

                         }

                            
                        }
                    }
