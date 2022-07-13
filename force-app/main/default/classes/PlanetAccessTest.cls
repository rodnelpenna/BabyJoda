@isTest
public with sharing class PlanetAccessTest {

    @TestSetup
    static void makeData(){
        Planet__c planet = new Planet__c();
        planet.Name = 'Earth';
        planet.Code__c = 'E';
        insert planet;
        
        Account acc = new Account();
        acc.Name = 'Acme';
        insert acc;

        Contact cont = new Contact();
        cont.FirstName = 'John';
        cont.LastName = 'Doe';
        cont.AccountId = acc.Id;
        cont.Email = 'test@test.com';
        insert cont;

    }


    @isTest
    public static void testPlanetAccessExistingPlanet() {
        Case testCase = new Case();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Acme'];
        Contact cont = [SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE FirstName = 'John'];
        testCase.Subject = 'Solicitud de escaneo - Earth';
        testCase.AccountId = acc.Id;
        testCase.ContactId = cont.Id;
        testCase.Description = 'Código de acceso al sistema de escaneo interplanetario: E';
        Test.startTest();
        insert testCase;
        Test.stopTest();
        Case caseInserted = [SELECT Id, Subject, AccountId, ContactId, Description, Planet__r.Name,Planet__r.Code__c,Planet__c FROM Case WHERE Subject = 'Solicitud de escaneo - Earth'];
        System.assert(caseInserted.Planet__c!=null, 'Planet__c is null');
        System.assert(caseInserted.Planet__r.Name=='Earth', 'Planet__r.Name is not Earth');
        System.assert(caseInserted.Planet__r.Code__c=='E', 'Planet__r.Code__c is not E');
    }

    @isTest
    public static void testPlanetAccessNotExistingPlanet() {
        Case testCase = new Case();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Acme'];
        Contact cont = [SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE FirstName = 'John'];
        testCase.Subject = 'Solicitud de escaneo - Mars';
        testCase.AccountId = acc.Id;
        testCase.ContactId = cont.Id;
        testCase.Description = 'Código de acceso al sistema de escaneo interplanetario: M';
        Test.startTest();
        insert testCase;
        Test.stopTest();
        Case caseInserted = [SELECT Id, Subject, AccountId, ContactId, Description, Planet__r.Name,Planet__r.Code__c,Planet__c FROM Case WHERE Subject = 'Solicitud de escaneo - Mars'];
        System.assert(caseInserted.Planet__c!=null, 'Planet__c is not null');
        System.assert(caseInserted.Planet__r.Name=='Mars', 'Planet__r.Name is not Mars');
        System.assert(caseInserted.Planet__r.Code__c=='M', 'Planet__r.Code__c is not M');
    }

    @isTest
    public static void testPlanetAccessListPlanet() {
        List<Case> testCases = new List<Case>();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Acme'];
        Contact cont = [SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE FirstName = 'John'];
        Case testCase = new Case();
        testCase.Subject = 'Solicitud de escaneo - Mars';
        testCase.AccountId = acc.Id;
        testCase.ContactId = cont.Id;
        testCase.Description = 'Código de acceso al sistema de escaneo interplanetario: M';
        testCases.add(testCase);
        Case testCase2 = new Case();
        testCase2.Subject = 'Solicitud de escaneo - Earth';
        testCase2.AccountId = acc.Id;
        testCase2.ContactId = cont.Id;
        testCase2.Description = 'Código de acceso al sistema de escaneo interplanetario: E';
        testCases.add(testCase2);
        Test.startTest();
        insert testCases;
        Test.stopTest();
        List<Case> casesInserted = [SELECT Id, Subject, AccountId, ContactId, Description, Planet__r.Name,Planet__r.Code__c,Planet__c FROM Case WHERE Subject IN ('Solicitud de escaneo - Mars','Solicitud de escaneo - Earth')];
        for(Case c : casesInserted) {
            System.assert(c.Planet__c!=null, 'Planet__c is null');
            System.assert(c.Planet__r.Name=='Mars' || c.Planet__r.Name=='Earth', 'Planet__r.Name is not Mars or Earth');
            System.assert(c.Planet__r.Code__c=='M' || c.Planet__r.Code__c=='E', 'Planet__r.Code__c is not M or E');
        }
    }
}
