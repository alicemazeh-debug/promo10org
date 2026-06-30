public with sharing class AccountController {
    @AuraEnabled
    public static Id createNewAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer maxRecords) {
        
        Integer limitCount = (maxRecords != null && maxRecords > 0) ? maxRecords : 10;
        return [SELECT Id, Name FROM Account ORDER BY CreatedDate DESC LIMIT :limitCount];
    }
}
