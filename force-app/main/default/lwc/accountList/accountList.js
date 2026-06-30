import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AccountViewer extends LightningElement {
    maxRecords = 5; 
    accounts;
    error;

    connectedCallback(){
        console.log("aliceee");
    }
    @wire(getAccounts, { maxRecords: '$maxRecords' }) wiredAccounts;
    // wiredAccounts({ error, data }) {
    //     if (data) {
    //         this.accounts = data;
    //         this.error = undefined;
    //     } else if (error) {
    //         this.error = error.body ? error.body.message : error.message;
    //         this.accounts = undefined;
    //     }
    // }

   
    handleInputChange(event) {
        const inputValue = event.target.value;
       
        this.maxRecords = inputValue ? parseInt(inputValue, 10) : 0;
    }
}
