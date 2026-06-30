public with sharing class apexController1 {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountListRating(String filter) {
        if (String.isBlank(filter) || filter == 'All') {
            return [SELECT Id, Name, Industry, Phone, Rating  FROM Account  LIMIT 10];
        }
        return [SELECT Id, Name, Industry, Phone, Rating  FROM Account WHERE Rating = :filter  LIMIT 10];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountRecordTypeID(Id ac){
        return[SELECT RecordTypeId FROM Account WHERE Id =: ac];

    }

}






    

