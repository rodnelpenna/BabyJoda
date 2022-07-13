@isTest
public with sharing class MandalorianRequestHelperTest {
    
    @TestSetup
    static void makeData(){
        List<Planet__c> planets = new List<Planet__c>();
        List<Contact> contacts = new List<Contact>();
        List<Case> cases = new List<Case>();
        Account acc= new Account();
        acc.Name = 'Test Account';
        insert acc;

        for(Integer i = 0; i < 10; i++){
            Planet__c planet = new Planet__c();
            planet.Name = 'Planet ' + i;
            planet.Code__c = 'Code' + i;
            planets.add(planet);
        }
        insert planets;
        for(Integer i = 0; i < 10; i++){
            Contact contact = new Contact();
            contact.LastName = 'Contact ' + i;
            contact.FirstName = 'First ' + i;
            contact.Email = 'test' + i+'@test.com';
            contact.AccountId = acc.Id;
            contacts.add(contact);
        }
        insert contacts;

        for(Integer i = 0; i < 10; i++){
            Case casei = new Case();
            casei.Subject = 'Case ' + i;
            casei.AccountId = acc.Id;
            casei.ContactId = contacts[i].Id;
            casei.Planet__c = planets[i].Id;
            cases.add(casei);
        }
        insert cases;
    }


    @isTest
    public static void testGetLatestCases() {
        List<Case> cases = [SELECT Id, Subject, AccountId, ContactId, Planet__r.Name FROM Case order by LastModifiedDate desc limit 5];
        List<MandalorianRequestHelper.MandCase> mandCases = new List<MandalorianRequestHelper.MandCase>();
        Test.startTest();
        mandCases = MandalorianRequestHelper.getLatestCases();
        Test.stopTest();
        System.assert(mandCases.size() == 5, 'Expected 5 cases, got ' + mandCases.size());
        for(Integer i = 0; i < mandCases.size(); i++){
            System.assertEquals(cases[i].Id, mandCases[i].IdC, 'Case ' + i + ' did not match');
        }
    }

    @isTest
    public static void testGetCaseById(){
        Case c = [SELECT Id, Subject, AccountId, ContactId, Planet__r.Name FROM Case LIMIT 1];
        Test.startTest();
        MandalorianRequestHelper.MandCase mandCase = MandalorianRequestHelper.getCaseById(c.Id);
        Test.stopTest(); 
        System.assertEquals(c.Id, mandCase.IdC, 'Case did not match');
    }

    @isTest
    public static void testSendScan(){
        String responseBody = '{"status":"success"}';

        Test.startTest();
        Continuation con = (Continuation) MandalorianRequestHelper.sendScan('code');
        Map<String,HttpRequest> requests = con.getRequests();
        System.assertEquals(1, requests.size(), 'The number of requests associated to the Continuation is not correct');

        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(responseBody);

        Test.setContinuationResponse(MandalorianRequestHelper.contState, response);

        List<String> labels = new List<String>();
        labels.add(MandalorianRequestHelper.contState);

        String result = (String) MandalorianRequestHelper.scanResponse(labels, '');
        Test.stopTest();

        System.assertEquals(response.getBody(), result, 'The response did not match');
    }

    @isTest
    public static void testCloseCase(){
        List<Case> cases = [SELECT Id, Subject, Successful_Scan__c, ContactId, Planet__r.Name FROM Case order by LastModifiedDate desc limit 5];
        Test.startTest();
        Id caseNoSuccess = cases[0].Id;
        Id caseSuccess = cases[1].Id;
        MandalorianRequestHelper.closeCase(caseNoSuccess,false);
        MandalorianRequestHelper.closeCase(caseSuccess,true);
        Test.stopTest();
        Map<Id,Case> casesClosed =new Map<Id,Case>([SELECT Id, Subject, Successful_Scan__c, ContactId, Planet__r.Name FROM Case WHERE Status = 'Closed' order by LastModifiedDate desc limit 5]);
        System.assert(casesClosed.size() == 2, 'Expected 2 cases closed, got ' + casesClosed.size());
        System.assert(casesClosed.get(caseSuccess).Successful_Scan__c, 'Case ' + caseSuccess + ' was not successful');
        System.assert(!casesClosed.get(caseNoSuccess).Successful_Scan__c, 'Case ' + caseNoSuccess + ' was successful');

    }
}
 