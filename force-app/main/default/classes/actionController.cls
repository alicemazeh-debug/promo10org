public with sharing class actionController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getRecentAccounts() {
        return [
            SELECT Id, Name, Industry, Phone, Rating, Description
            FROM Account
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
      
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [
            SELECT Id, Name, Industry, Phone, Rating, Description
            FROM Account
            WHERE Rating = 'Hot'
            WITH SECURITY_ENFORCED // it show field only for the users who have access
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountWithoutPhone() {
        return [
            SELECT Id, Name, Industry, Phone, Rating, Description
            FROM Account
            WHERE Phone = NULL
            WITH SECURITY_ENFORCED
            LIMIT 50
        ];
    }

    @AuraEnabled
    public static Account updateAccountDescription(Id accountId, String description) {
        if (accountId == null) {
            throw new AuraHandledException('Account Id is required.');
        }

        Account accountToUpdate = new Account(Id = accountId, Description = description);
        update accountToUpdate;

        return [
            SELECT Id, Name, Industry, Phone, Rating, Description
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
    }
}