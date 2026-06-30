 

import { LightningElement, wire, track, api } from 'lwc';
import getAccountListRating from '@salesforce/apex/apexController1.getAccountListRating';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
import getAccountRecordTypeID from '@salesforce/apex/apexController1.getAccountRecordTypeID';

export default class PicklistAcc  extends LightningElement {
    @api recordId;
    @track selectedRating = 'All';
    @track accounts;
    @track dynamicOptions = []; 
    @track recordTypeID;
    error;

    @wire(getAccountRecordTypeID, {ac: '$recordId'})
    getRecordType({error , data}) {
        if(data){
            this.recordTypeID=data[0].RecordTypeId;
            console.log('values:', this.recordTypeID);
        }
      else if (error) {
            console.error('Error fetching picklist values:', error);
    }
}

    @wire(getPicklistValues, { 
        recordTypeId:'$recordTypeID', 
        fieldApiName: RATING_FIELD 
    })
    wiredPicklistValues({ error, data }) {
        if (data) {
            const picklistOptions = data.values.map(picklist => ({
                label: `${picklist.label} Accounts`,
                value: picklist.value
            }));

            this.dynamicOptions = [
                { label: 'All Accounts', value: 'All' },
                ...picklistOptions
            ];
        } else if (error) {
            console.error('Error fetching picklist values:', error);
        }
    }

   
    get filterOptions() {
        return this.dynamicOptions;
    }

 
    @wire(getAccountListRating, { filter: '$selectedRating' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data.map(account => {
                return {
                    ...account,
                    Name: account.Name ? account.Name : 'Not Specified',
                    Industry: account.Industry ? account.Industry : 'Not Specified',
                    Phone: account.Phone ? account.Phone : 'Not Specified',
                    Rating: account.Rating ? account.Rating : 'Not Specified'
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }

    handleRatingChange(event) {
        this.selectedRating = event.detail.value;
    }
}