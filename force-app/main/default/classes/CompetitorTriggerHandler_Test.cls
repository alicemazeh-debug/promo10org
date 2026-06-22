@IsTest
public class CompetitorTriggerHandler_Test {

    @testSetup
    static void setupData() {

        Account acc = new Account(//create an acc
            Name = 'Test Account'
        );
        insert acc;

        Opportunity opp = new Opportunity(//create an opp
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp;

        Quote q = new Quote(// create a quote
            Name = 'Test Quote',
            OpportunityId = opp.Id
        );
        insert q;
    }

    @IsTest
    static void testAssignCompetitorToAccount() {

        Account acc = [//get the acc
            SELECT Id
            FROM Account
            LIMIT 1
        ];

        Quote q = [//get the quote
            SELECT Id
            FROM Quote
            LIMIT 1
        ];

        Test.startTest();

        insert new Competitor__c(// insert new comp
            Name = 'Primary Competitor',
            Account__c = acc.Id,
            Quote__c = q.Id
        );

        Test.stopTest();

        List<Competitor__c> competitors = [
            SELECT Id, Account__c, Quote__c, Opportunity__c
            FROM Competitor__c
        ];

        System.assert(
            competitors.size() >= 1,//verifies comp exist
            'Competitor should be created'
        );
    }

    @IsTest
    static void testDuplicateQuoteCompetitorBlocked() {

        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Quote q1 = [
            SELECT Id
            FROM Quote
            LIMIT 1
        ];

        Quote q2 = new Quote(
            Name = 'Second Quote',
            OpportunityId = opp.Id
        );
        insert q2;

        insert new Competitor__c(
            Name = 'Competitor 1',
            Account__c = acc.Id,
            Quote__c = q1.Id
        );

        Test.startTest();

        Database.SaveResult sr = Database.insert(
            new Competitor__c(
                Name = 'Competitor 2',
                Account__c = acc.Id,
                Quote__c = q2.Id
            ),
            false
        );

        Test.stopTest();

        System.assertEquals(
            false,
            sr.isSuccess(),
            'Duplicate quote competitor should fail'
        );
    }

    @IsTest
    static void testDuplicateOpportunityCompetitorBlocked() {

        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];

        Opportunity opp1 = new Opportunity(
            Name = 'Opp 1',
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp1;

        Opportunity opp2 = new Opportunity(
            Name = 'Opp 2',
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp2;

        insert new Competitor__c(
            Name = 'Competitor 1',
            Account__c = acc.Id,
            Opportunity__c = opp1.Id
        );

        Test.startTest();

        Database.SaveResult sr = Database.insert(
            new Competitor__c(
                Name = 'Competitor 2',
                Account__c = acc.Id,
                Opportunity__c = opp2.Id
            ),
            false
        );

        Test.stopTest();

        System.assertEquals(
            false,
            sr.isSuccess(),
            'Duplicate opportunity competitor should fail'
        );
    }

    @IsTest
    static void testUpdateCompetitor() {//beforeupdate afterupdate

        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Quote q = [
            SELECT Id
            FROM Quote
            LIMIT 1
        ];

        Competitor__c comp = new Competitor__c(
            Name = 'Update Test',
            Account__c = acc.Id
        );

        insert comp;

        Test.startTest();

        comp.Quote__c = q.Id;
        update comp;

        Test.stopTest();

        Competitor__c updatedComp = [
            SELECT Id, Quote__c
            FROM Competitor__c
            WHERE Id = :comp.Id
        ];

        System.assertEquals(
            q.Id,
            updatedComp.Quote__c
        );
    }
}