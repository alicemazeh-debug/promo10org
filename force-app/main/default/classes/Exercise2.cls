public with sharing class Exercise2 {

    public static void countContactOccurences(List<Contact> contactList, Map<Id, Contact> oldContactMap) {
        Set<Id> accountIdsToUpdate = new Set<Id>();
        
        if (contactList != null) {
            for (Contact con : contactList) {
                if (con.AccountId != null) {
                    accountIdsToUpdate.add(con.AccountId);
                }
                // Track the old account if a contact was moved from one account to another
                if (oldContactMap != null && oldContactMap.containsKey(con.Id)) {
                    Id oldAccountId = oldContactMap.get(con.Id).AccountId;
                    if (oldAccountId != null && oldAccountId != con.AccountId) {
                        accountIdsToUpdate.add(oldAccountId);
                    }
                }
            }
        }
        
        if (!accountIdsToUpdate.isEmpty()) {
            recalculateSmithContacts(accountIdsToUpdate);
        }
    }
    
    private static void recalculateSmithContacts(Set<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Id accId : accountIds) {
            // Default count to 0 to handle cases where all matching contacts are removed
            accountsToUpdate.add(new Account(Id = accId, Countcontact__c = 0));
        }
        
        // Aggregate query counting contacts with null/empty FirstName and 'Smith' LastName
        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) total
            FROM Contact 
            WHERE AccountId IN :accountIds 
              AND (FirstName = NULL OR FirstName = '' OR LastName = 'Smith') 
              
            GROUP BY AccountId
        ];
        
        Map<Id, Account> accountMap = new Map<Id, Account>(accountsToUpdate);
        for (AggregateResult ar : results) {
            Id accId = (Id)ar.get('AccountId');
            Integer count = (Integer)ar.get('total');
            if (accountMap.containsKey(accId)) {
                accountMap.get(accId).Countcontact__c = count;
            }
        }
        
        if (!accountMap.isEmpty()) {
            update accountMap.values();
        }
    }
}