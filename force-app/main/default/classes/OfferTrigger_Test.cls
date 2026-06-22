@isTest
public with sharing class OfferTrigger_Test {
    @isTest
    static void testSingleOfferIdentifier(){ // opp Identifier =EIT ----- First Offer = EIT-000
         //Arrange 
         Opportunity opp = new Opportunity ( Name = 'Test opp', StageName = 'Prospecting' , CloseDate = Date.today() , Identifier__c='EIT');
         insert opp;

         Offer__c offer = new Offer__c( Name = ' Offer 1 ', Opportunity__c = opp.Id );

         //Act 
         Test.startTest();
         insert offer;
         Test.stopTest();

         //Assert
         Offer = [ SELECT Identifier__c FROM Offer__c WHERE Id = :offer.Id];

         System.assertEquals('EIT-000', offer.Identifier__c);
    }

    //Multiple offers can be added at the same time.
    @isTest
static void testBulkOfferInsert() {

    // Arrange
    Opportunity opp = new Opportunity(
        Name = 'Bulk Opportunity',
        StageName = 'Prospecting',
        CloseDate = Date.today(),
        Identifier__c = 'EIT'
    );
    insert opp;

    List<Offer__c> offers = new List<Offer__c>();

    offers.add(
        new Offer__c(
            Name = 'Offer 1',
            Opportunity__c = opp.Id
        )
    );

    offers.add(
        new Offer__c(
            Name = 'Offer 2',
            Opportunity__c = opp.Id
        )
    );

    offers.add(
        new Offer__c(
            Name = 'Offer 3',
            Opportunity__c = opp.Id
        )
    );

    // Act
    Test.startTest();
    insert offers;
    Test.stopTest();

    // Assert
    List<Offer__c> insertedOffers = [
        SELECT Identifier__c
        FROM Offer__c
        WHERE Opportunity__c = :opp.Id
        ORDER BY CreatedDate
    ];

    System.assertEquals(
        'EIT-000',
        insertedOffers[0].Identifier__c
    );

    System.assertEquals(
        'EIT-001',
        insertedOffers[1].Identifier__c
    );

    System.assertEquals(
        'EIT-002',
        insertedOffers[2].Identifier__c
    );
}
  //The opportunity on the offer can be changed.
  @isTest
  static void testOpportunityChange(){
    // Arrange
    Opportunity opp1 = new Opportunity(
        Name = 'Opp 1',
        StageName = 'Prospecting',
        CloseDate = Date.today(),
        Identifier__c = 'EIT'
    );

    Opportunity opp2 = new Opportunity(
        Name = 'Opp 2',
        StageName = 'Prospecting',
        CloseDate = Date.today(),
        Identifier__c = 'ABC'
    );
    insert new List<Opportunity>{opp1,opp2};

    Offer__c offer  = new Offer__c( Name ='Offer Test ',Opportunity__c = opp1.Id);
    insert offer ;

     //Act
     Test.startTest();

     offer.Opportunity__c = opp2.Id;
     update offer;

     Test.stopTest();

     // Assert
     offer = [
        SELECT Identifier__c
        FROM Offer__c
        WHERE Id = :offer.Id
     ];

     System.assert(
        offer.Identifier__c.startsWith('ABC-')
     );




  }
    
    
}