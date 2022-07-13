import { LightningElement, api,wire, track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled }  from 'lightning/empApi';
import getLatestCases from '@salesforce/apex/MandalorianRequestHelper.getLatestCases';

export default class CasesList extends LightningElement {
    @track mandCases;
    @api channelName = '/event/AutoAddCase__e';

    handleClick(evt) {
        const event = new CustomEvent('caseselected', {
            detail: evt.detail            
        });
        console.log(evt.detail);        
        this.dispatchEvent(event);
    }

    connectedCallback() {
        getLatestCases().then((listItems) => {    
            console.log('listItems: '+JSON.stringify(listItems));        
            this.mandCases=listItems;                    
            });    
        this.registerErrorListener();
        this.handleSubscribe();
    }

     // Handles subscribe button click
     handleSubscribe() {
        const messageCallback = function(response) { 
            console.log('Received message from server: ' + JSON.stringify(response));
            let obj = JSON.parse(JSON.stringify(response));            
            if (obj.data.payload.MakeAutoRefresh__c){
                console.log('MakeAutoRefresh__c: '+obj.data.payload.MakeAutoRefresh__c);
                getLatestCases().then((listItems) => {    
                    console.log('listItems: '+JSON.stringify(listItems));        
                    this.mandCases=JSON.parse(JSON.stringify(listItems)); 
                    eval("$A.get('e.force:refreshView').fire();");                  
                    });
                }
            };
       
        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    registerErrorListener() {        
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));            
        });
    }
}