import { LightningElement,api } from 'lwc';

export default class MandalorianRequests extends LightningElement {
    @api mandCaseId;
    handleMandCaseSelected(event) {
        this.mandCaseId = event.detail;
    }    
}