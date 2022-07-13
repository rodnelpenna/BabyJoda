import { LightningElement,api } from 'lwc';

export default class CaseTitle extends LightningElement {
    @api mandCaseId;
    @api mandCaseName;
    @api mandCaseSubject;

    caseClick(){
        const event = new CustomEvent('caseclick', {            
            detail: this.mandCaseId
        });
        this.dispatchEvent(event);
    }
}