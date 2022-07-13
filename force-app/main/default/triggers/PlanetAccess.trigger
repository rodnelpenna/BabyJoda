//Testclass: PlanetAccessTest
trigger PlanetAccess on Case (before insert, after insert) {
    Map<String,Planet__c> planetsToInsert = new Map<String,Planet__c>();
    Map<String,String> planetNames = new Map<String,String>();
    Map<String,Case> planteToCases = new Map<String,Case>();

    //Extrat the planets to insert from the Case
    for(Case c:Trigger.new){
        if(c.Subject.contains('Solicitud de escaneo -') && c.Description.contains('acceso al sistema ')){
            String planetName = c.Subject.split('-')[1].trim();
            String planetCode = c.Description.split(':')[1].trim();
            planetNames.put(planetCode, planetName);   
            planteToCases.put(planetCode, c);
        }
    }
    if(trigger.isBefore && trigger.isInsert) {
        
        if(planetNames.size() > 0){
            //Extract the planets inserted on the database
            Map<String,Planet__c> planetByCode = new Map<String,Planet__c>();
            List<Planet__c> planets = [Select Id, Name, Code__c From Planet__c where Code__c in :planetNames.keySet()];
            for(Planet__c p:planets){
                planetByCode.put(p.Code__c, p);
            }
            //Insert the planets to insert on the database
            for(String pCode:planetNames.keySet()){
                if(!planetByCode.containsKey(pCode)){
                    Planet__c p = new Planet__c();
                    p.Name = planetNames.get(pCode);
                    p.Code__c = pCode;
                    planetsToInsert.put(pCode, p);
                }
            }
            if(planetsToInsert.size() > 0){
                insert planetsToInsert.values();
            }
            //Update the Case with the planet
            for(String pCode: planteToCases.keySet()){
                if(planetByCode.containsKey(pCode)){
                    planteToCases.get(pCode).Planet__c = planetByCode.get(pCode).Id;
                }
                if(planetsToInsert.containsKey(pCode)){
                    planteToCases.get(pCode).Planet__c = planetsToInsert.get(pCode).Id;
                }
            }
    
    
        }
    }
    else if(trigger.isAfter && trigger.isInsert){
        
       if(planteToCases.size() > 0){
            AutoAddCase__e e = new AutoAddCase__e();
            e.MakeAutoRefresh__c = true;
            Eventbus.publish(e);
        }
        
    }
    
    
    
}