// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//author: Roger Rosset
//description: Upload custom metadata records using CSV/JSON

public static void insertMetadata(String metaDataTypeName, String jsonString){
        // try {
            Integer count = 1;
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            List<mdtRecords> csv = (List<mdtRecords>)JSON.deserialize(jsonStringMdt(jsonString), List<mdtRecords>.class);
            System.debug(csv);
            for(mdtRecords item : csv){
                //Sets the custom metadata type you'll insert your records on
                //If you're using namespaces on your org set it here
                System.debug(item);
                String nameSpacePrefix ='';                                     
                Metadata.CustomMetadata rec =  new Metadata.CustomMetadata();
                String label = 'Record '+count;                      
                rec.fullName = nameSpacePrefix+metaDataTypeName+'.'+label;
                rec.label = label; 

                //Sets the custom metadata custom fields to be inserted
                /*
                * Use the template below to setup any fields you want to:
                *    
                Metadata.CustomMetadataValue fieldX = new Metadata.CustomMetadataValue();     //New instance
                fieldX.field = 'Custom_Field_Name__c'; //Custom Metadata Field you want to fill
                field1.value = item.JSON_Matching_Key_Value; //The matching key value on the wrapper
                rec.values.add(fieldX); //adds the value and the matching field
                *
                */
                system.debug(item.AccessCode+' '+item.External_id);
                Metadata.CustomMetadataValue field1 = new Metadata.CustomMetadataValue();
                field1.field = 'AccessCode__c';
                field1.value = item.AccessCode;
                rec.values.add(field1);            
                Metadata.CustomMetadataValue field2 = new Metadata.CustomMetadataValue();
                field2.field = 'External_Id__c';
                field2.value = item.External_id;
                rec.values.add(field2);                                           
                mdContainer.addMetadata(rec);  
                count++;
            } 
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
            system.debug('Container>>'+mdContainer);
            system.debug('Id>>'+jobId);
            return;
        //}
        // catch(Exception ex){             
        //     system.debug('Error on insert');
        //     system.debug('Error:'+ex.getMessage());
        // }
    }
    private static String jsonStringMdt(String jsonString){
        String resultJson = '{"data":{"mdtRecordsList":'+jsonString+'}}';
        return resultJson;
    }

public class mdtImport  {    
    

}
public class Data{
        private List<mdtRecords> mdtRecordsList;
    }
public class mdtRecords{
        private String AccessCode;
        private String External_id;
    }
public class JSONCsvTemplate{
    private Data data;
}



String mtdInfo = 
'[{"External_id":"A-00001","AccessCode":"jPnR\\5625"},{"External_id":"AM-00002","AccessCode":"t$Th\5199"},{"External_id":"B-00003","AccessCode":"qoby\@@59"},{"External_id":"BI-00004","AccessCode":"FQwC\7485"},{"External_id":"CN-00005","AccessCode":"qBBt\2339"},{"External_id":"C-00006","AccessCode":"ZNJZ\537@"},{"External_id":"C-00007","AccessCode":"KLSd\9@76"},{"External_id":"C-00008","AccessCode":"oyaN\841@"},{"External_id":"CD-00009","AccessCode":"lvgr\2716"},{"External_id":"C-00010","AccessCode":"TZeZ\5414"},{"External_id":"C-00011","AccessCode":"aHBN\16@6"},{"External_id":"D-00012","AccessCode":"cGHy\9562"},{"External_id":"D-00013","AccessCode":"G$mf\2@35"},{"External_id":"D-00014","AccessCode":"ghjU\258@"},{"External_id":"D-00015","AccessCode":"LXVh\61@2"},{"External_id":"E-00016","AccessCode":"tRZw\839@"},{"External_id":"E-00017","AccessCode":"$VjP\9859"},{"External_id":"F-00018","AccessCode":"dCMt\558@"},{"External_id":"G-00019","AccessCode":"pj$k\1635"},{"External_id":"GA-00020","AccessCode":"fopy\@339"},{"External_id":"HK-00021","AccessCode":"qS$$\2288"},{"External_id":"H-00022","AccessCode":"XCEv\3071"},{"External_id":"I-00023","AccessCode":"Xpqo\1578"},{"External_id":"I-00024","AccessCode":"jcpF\5694"},{"External_id":"J-00025","AccessCode":"Tgto\2@0@"},{"External_id":"K-00026","AccessCode":"MXon\@577"},{"External_id":"K-00027","AccessCode":"GHhT\636"},{"External_id":"K-00028","AccessCode":"FHHa\943"},{"External_id":"M-00029","AccessCode":"JzKF\1225"},{"External_id":"M-00030","AccessCode":"HqjE\7698"},{"External_id":"MC-00031","AccessCode":"EZA$\5@88"},{"External_id":"M-00032","AccessCode":"hQyE\@603"},{"External_id":"M-00033","AccessCode":"PWav\820"},{"External_id":"M-00034","AccessCode":"YGcK\92@"},{"External_id":"N-00035","AccessCode":"Vauj\570"},{"External_id":"NH-00036","AccessCode":"FSYl\229"},{"External_id":"O-00037","AccessCode":"aRqr\9@7"},{"External_id":"OM-00038","AccessCode":"ngdO\1@5"},{"External_id":"PM-00039","AccessCode":"m$mM\309"},{"External_id":"Q-00040","AccessCode":"YW$L\363"},{"External_id":"R-00041","AccessCode":"AFF$\@43"},{"External_id":"R-00042","AccessCode":"UnUu\20@"},{"External_id":"S-00043","AccessCode":"nZmp\84"},{"External_id":"S-00044","AccessCode":"nkqn\619"},{"External_id":"S-00045","AccessCode":"LRHQ\7@3"},{"External_id":"S-00046","AccessCode":"JVOn\375"},{"External_id":"S-00047","AccessCode":"aHVY\505"},{"External_id":"S-00048","AccessCode":"kdna\829"},{"External_id":"S-00049","AccessCode":"tOTs\2@"},{"External_id":"T-00050","AccessCode":"wVnV\@0"},{"External_id":"T-00051","AccessCode":"bWxd\42"},{"External_id":"T-00052","AccessCode":"Zm$a\77"},{"External_id":"T-00053","AccessCode":"alxf\30"},{"External_id":"T-00054","AccessCode":"XOSo\98"},{"External_id":"T-00055","AccessCode":"JDrm\37"},{"External_id":"U-00056","AccessCode":"RXgm\30"},{"External_id":"U-00057","AccessCode":"HnkY\87"},{"External_id":"V-00058","AccessCode":"gtqP\85"},{"External_id":"YI-00059","AccessCode":"Fz$m\2@"},{"External_id":"Z-00060","AccessCode":"TYKp\@4"}]'; 
//insertMetadata('PlanetAccess__mdt', mtdInfo);
List<mdtRecords> csv = (List<mdtRecords>)JSON.deserialize(mtdInfo, List<mdtRecords>.class);