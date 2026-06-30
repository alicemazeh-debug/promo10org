import { LightningElement, api, wire } from 'lwc';
import getAccountList from '@salesforce/apex/apexController.getAccountList';
//import {  } from 'lightning/uiRelatedListApi';
const COLUMNS = [
    { label: 'Account Name', fieldName: 'Name', type: 'text' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Rating', fieldName: 'Rating', type: 'text' }
];
export default class FilteredAccounts extends LightningElement {

    columns = COLUMNS;

    @api recordId;

    filterOptions = [
        { label: 'All Accounts', value: 'All'},
        { label: 'Warm Accounts', value: 'Warm' },
        { label: 'Hot Accounts', value: 'Hot' },
        { label: 'Cold Accounts', value: 'Cold' },
        //{ label: 'Escalated', value: 'Escalated' }
    ];
    
    

    
     allAccounts = [];//master copy of data
     accountsToDisplay = [];//filtered data
     selectedRating = 'All';
      showAccounts = false;
    
     get cardLabel() {
        return 'Related Accounts (' + this.allAccounts.length + ')';
    }
     @wire(getAccountList)
     wiredAccounts({ error, data }) {
        if (data) {
            
            this.allAccounts = data.map(account => {
                return {
                    Id: account.Id,
                    Name: account.Name ? account.Name : 'Not Specified',
                    Industry: account.Industry ? account.Industry : 'Not Specified',
                    Phone: account.Phone ? account.Phone : 'Not Specified',
                    Rating: account.Rating ? account.Rating : 'Not Specified'
                };
            });
         this.updateList();

         } else if (error) {
            console.error('Error occurred retrieving Account records...', error);
        }
    }

    handleSelection(event) {
        this.selectedRating = event.target.value;
        this.updateList();
    }
    updateList() {
        if (this.selectedRating === 'All') {
            this.accountsToDisplay = this.allAccounts;
        } else {
            this.accountsToDisplay = this.allAccounts.filter(acc => acc.Rating === this.selectedRating );
        }
        this.showAccounts = this.accountsToDisplay.length > 0;
    }
}