@isTest
public class CountContactTriggerHandler_Test {

    @testSetup
    private static void testSetupObjectDataFactory() {
        // Create an Account to link our contacts to
        Account testAcc = new Account(Name = 'Smith Tracking Test Acc');
        insert testAcc;
        

        // Profile and User block to mimic your template's pattern
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = [SELECT Id FROM User WHERE ProfileId = :p.Id AND IsActive = true LIMIT 1];
        
        System.runAs(u) {
            // Creating test contacts directly to match our custom logic 
            List<Contact> testContacts = new List<Contact>();
            
            // Contact 1: Valid (No FirstName, LastName is Smith)
            testContacts.add(new Contact(LastName = 'Smith', AccountId = testAcc.Id)); 
            
            // Contact 2: Valid (Empty string FirstName, LastName is Smith)
            testContacts.add(new Contact(FirstName = '', LastName = 'Smith', AccountId = testAcc.Id)); 
            
            // Contact 3: Invalid (Has a FirstName)
            testContacts.add(new Contact(FirstName = 'John', LastName = 'Smith', AccountId = testAcc.Id));
            
            // This insert WILL fire your Contact Trigger
            insert testContacts;
        }
    }

    // This test method verifies that inserting contacts correctly
    // calculates the 'Countcontact__c' on the Account.
    @isTest
    private static void insertContactsSuccess() {
        // Retrieve the test account we created in setup
        List<Account> activeAccounts = [SELECT Id, Countcontact__c FROM Account LIMIT 1];
        Account acc = activeAccounts[0];
        
        Decimal startingCount = acc.Countcontact__c;


        // Create a new contact to test a successful incremental insert
        Contact newContact = new Contact(
        AccountId = acc.Id,
        LastName = 'Smith',
        FirstName = '' // Explicitly empty
    );

        // Run the insert test
        Test.startTest();
    Database.SaveResult insertionResult = Database.insert(newContact, false);
    Test.stopTest();

    Assert.isTrue(insertionResult.isSuccess(), 'The contact insert should have been successful.');

    // 3. Verify that the count incremented by exactly 1
    Account updatedAcc = [SELECT Countcontact__c FROM Account WHERE Id = :acc.Id];
    
    Assert.areEqual(startingCount + 1, updatedAcc.Countcontact__c, 
        'The field should have incremented by exactly 1 after adding a new Smith contact.');
    }

    // Additional method to test what happens during an update scenario
    @isTest
    private static void updateContactSuccess() {
        Account acc = [SELECT Id,Countcontact__c FROM Account LIMIT 1];
        
    Contact testContact = [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
    testContact.FirstName = 'John';
    testContact.LastName = 'Smith';
        
    update testContact;
        
    Account Acc1 = [SELECT Countcontact__c FROM Account WHERE Id = :acc.Id];
        
    Decimal startingCount = Acc1.Countcontact__c;
        
        testContact.FirstName='';
        
        Test.startTest();
        Database.SaveResult updateResult = Database.update(
            testContact, false);
        Test.stopTest();
        
        Assert.isTrue(updateResult.isSuccess(), 'The contact update should have been successful.');

        // Verify account updated to 3 because John now qualifies
        Account updatedAcc = [SELECT Countcontact__c FROM Account WHERE Id = :acc.Id];
        
        Assert.areEqual(startingCount + 1, updatedAcc.Countcontact__c, 
        'The field should have incremented by exactly 1 after adding a new Smith contact.');
    }
}

