public with sharing class apexController {
  
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, Industry, Phone, Rating FROM Account WITH SECURITY_ENFORCED LIMIT 50];
    }
}




    
