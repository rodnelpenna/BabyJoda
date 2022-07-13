//Testclass: MandalorianRequestHelperTest
public with sharing class MandalorianRequestHelper {     
  
  @TestVisible
  private static String contState;
  //need add this to remote sites in the setup
  private static final String  EXTERNAL_URL = 'URL';
  public class MandCase{
    @AuraEnabled
    public Id IdC;
    @AuraEnabled
    public String Name;
    @AuraEnabled
    public String Subject;
    @AuraEnabled
    public String AccessCode;
    @AuraEnabled
    public Boolean Successful_Scan;
   }

   @AuraEnabled
   public static List<MandCase> getLatestCases() {
      List<Case> cases = [SELECT Id,Subject,Planet__r.Name, Successful_Scan__c, Planet__r.Code__c FROM Case WHERE Status != 'Closed' and Planet__c != null ORDER BY CreatedDate DESC LIMIT 5];
      Map<String,List<Case>> codeCaseMap = new Map<String,List<Case>>();
      for(Case c:cases){
        if(!codeCaseMap.containsKey(c.Planet__r.Code__c)){
          codeCaseMap.put(c.Planet__r.Code__c, new List<Case>());
        }
        codeCaseMap.get(c.Planet__r.Code__c).add(c);
      }
      Map<String,String> accessCodeMap = new Map<String,String>();
      List<PlanetAccess__mdt> accessCodes = [SELECT AccessCode__c, External_Id__c FROM PlanetAccess__mdt WHERE External_Id__c IN :codeCaseMap.keySet()];
        for(PlanetAccess__mdt a:accessCodes){
            accessCodeMap.put(a.External_Id__c, a.AccessCode__c);
        }
      List<MandCase> result = new List<MandCase>();
      for(String pc:codeCaseMap.keySet()){
        for(Case c:codeCaseMap.get(pc)){
          MandCase mc = new MandCase();
          mc.IdC = c.Id;
          mc.Name = c.Planet__r.Name;
          mc.Subject = c.Subject;
          mc.AccessCode = accessCodeMap.get(c.Planet__r.Code__c);
          mc.Successful_Scan = c.Successful_Scan__c;
          result.add(mc);
        }
      }
        return result;
    }

   @AuraEnabled
   public static MandCase getCaseById(Id caseId){
    if(caseId == null)
        return null;
    Case detailCase = [SELECT Id,Subject,Planet__r.Name, Successful_Scan__c, Planet__r.Code__c FROM Case WHERE Id = :caseId];
    List<PlanetAccess__mdt> accessCodes = [SELECT AccessCode__c, External_Id__c FROM PlanetAccess__mdt WHERE External_Id__c = :detailCase.Planet__r.Code__c];
    MandCase mc = new MandCase();
    mc.IdC = detailCase.Id;
    mc.Name = detailCase.Planet__r.Name;
    mc.Subject = detailCase.Subject;
    mc.AccessCode = accessCodes.size()>0 ? accessCodes[0].AccessCode__c : 'Code not found';
    mc.Successful_Scan = detailCase.Successful_Scan__c;
    return mc;
   }

    @AuraEnabled(cacheable=true continuation=true)
    public static Object sendScan(String accessCode){
      if(accessCode == 'Code not found'){
        return null;
      }        
      Continuation con = new Continuation(2);
      con.continuationMethod='scanResponse';

      Blob headerValue = Blob.valueOf('mando:12345');
      String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
      // Create callout request
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint(EXTERNAL_URL);
      req.setHeader('Authorization', authorizationHeader);

      contState = con.addHttpRequest(req);
      con.state = contState;
      return con;
    }

    @AuraEnabled(cacheable=true)
    public static Object scanResponse(List<String> labels, Object state) {
      HttpResponse response = Continuation.getResponse(labels[0]);      
      String result = response.getBody();
      return result;
    }

    @AuraEnabled
    public static void closeCase(String caseId, Boolean successfulScan){
      Case c = [SELECT Id,Status,Successful_Scan__c FROM Case WHERE Id = :caseId];
      c.Successful_Scan__c = successfulScan;
      c.Status = 'Closed';
      update c;
    }
}