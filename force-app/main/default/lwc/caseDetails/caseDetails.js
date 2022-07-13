import { LightningElement,api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCaseById from '@salesforce/apex/MandalorianRequestHelper.getCaseById';
import sendScan from '@salesforce/apexContinuation/MandalorianRequestHelper.sendScan';
import closeCase from '@salesforce/apex/MandalorianRequestHelper.closeCase';

export default class CaseDetails extends LightningElement {
@track mandCase;
@track scanbody;

@wire(sendScan, {accessCode: '$mandCase.AccessCode'})
    scanContinuation;

_caseId = undefined;

    set caseId(value) {
        this._caseId = value; 
        if(this._caseId!=undefined){
            console.log('caseId: '+this._caseId);
            getCaseById({caseId :this._caseId}).then((value) => {
                console.log('case: '+JSON.stringify(value));
                this.mandCase=value;
            });
        }       
    }

@api get caseId(){
        return this._caseId;
    }

    handleScan() {
        sendScan({accessCode:mandCase.AccessCode}).then((value) => {
            this.scanbody=value;
            console.log('scanbody: '+JSON.stringify(this.scanbody));
            console.log('scanContinuation: '+JSON.stringify(this.scanContinuation));
            let scan = JSON.parse(JSON.stringify(this.scanbody));
            closeCase({caseId:this._caseId, successfulScan : scan.SuccessfulScan});
            if(scan.SuccessfulScan){
                this.dispatchEvent(
                    new ShowToastEvent({
                        taitle: 'Satisfactorio',
                        message: 'Hemos encontrado al bebé Joda',
                        variant: 'success'
                    })
                );
            }
        })
        .catch(error => {            
            this.scanbody=error;
            const event = new ShowToastEvent({
                title: 'Conexion fallida',
                message:
                    'No se pudo conectar con el planeta requerido. Intente mas tarde.',
                variant: 'error'
            });
            this.dispatchEvent(event);
        });
    }
   
}