import { LightningElement,wire,api,track } from 'lwc';

import getOpportunityRecordMethod from '@salesforce/apex/MyComponentController.getOpportunityRecordMethod';


//const FIELDS = [Name, Type, Stage];
export default class FetchRecord extends LightningElement {
    @api recordId;
    @track OpportunityRecord;

    @track error;

    @wire(getOpportunityRecordMethod,{ recordId: '$recordId'})

    OpportunityData({ error, data }) {

        if (data) {

            console.log('RecordId is'+data);

            this.OpportunityRecord = data;

            this.error = undefined;

        } else if (error) {

            console.log('Error block');

            this.error = error;

            this.accountRecord = undefined;

        }
      };

}