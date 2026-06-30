// import { LightningElement } from 'lwc';
// import getRecentAccounts from '@salesforce/apex/actionController.getRecentAccounts';
// import getAccountWithoutPhone from '@salesforce/apex/actionController.getAccountWithoutPhone';
// import getAccountList from '@salesforce/apex/actionController.getAccountList';
// import updateAccountDescription from '@salesforce/apex/actionController.updateAccountDescription';
// import { NavigationMixin } from 'lightning/navigation';

// export default class AccountActionCenter extends NavigationMixin(LightningElement) {
//     accounts = [];
//     selectedAccount;
//     description = '';
//     errorMessage = '';
//     loading = false;


   
//     async handleLoad() {
//         this.loading = true;
//         this.selectedAccount = undefined; // clear details card

//         try {
//             this.accounts = await getRecentAccounts();
//             this.errorMessage = undefined;
//         } catch (error) {
//             this.accounts = [];
//             this.errorMessage = error.body?.message || 'Error loading recent accounts';//check erros then update ui with an error message
//         } finally {
//             this.loading = false;
//         }
//     }

   
//     async handleHotAccounts() {
//         this.loading = true;
//         this.selectedAccount = undefined; // clear details card

//         try {
//             this.accounts = await getAccountList();
//             this.errorMessage = undefined;
//         } catch (error) {
//             this.accounts = [];
//             this.errorMessage = error.body?.message || 'Error loading hot accounts';
//         } finally {
//             this.loading = false;
//         }
//     }

   
//     async handleAccountsWithoutPhone() {
//         this.loading = true;
//         this.selectedAccount = undefined; // clear details card

//         try {
//             this.accounts = await getAccountWithoutPhone();
//             this.errorMessage = undefined;
//         } catch (error) {
//             this.accounts = [];
//             this.errorMessage = error.body?.message || 'Error loading accounts without phone';
//         } finally {
//             this.loading = false;
//         }
//     }

    
//     async handleUpdateDescription() {
//         this.loading = true;

//         try {
            
//             const updatedAccount = await updateAccountDescription({
//                 accountId: this.selectedAccount.Id,
//                 description: this.description
//             });

//             this.selectedAccount = updatedAccount;
//             this.errorMessage = undefined;
            
            
//             this.accounts = this.accounts.map(acc => 
//                 acc.Id === updatedAccount.Id ? updatedAccount : acc// if same id update old b l new else leave it
//             );
//         } catch (error) {
//             this.errorMessage = error.body?.message || 'Error updating description';
//         } finally {
//             this.loading = false;
//         }
//     }

    
//     handleAccountSelect(event) {
//         const accountId = event.currentTarget.dataset.id;
        
//         // Find the selected account 
//         this.selectedAccount = this.accounts.find(acc => acc.Id === accountId);
        
        
//         this.description = this.selectedAccount?.Description || '';
//     }

//     // for des changing
//     handleDescriptionChange(event) {
//         this.description = event.target.value;
//     }

//     // Getter for HTML template
//     get hasAccounts() {
//         return this.accounts && this.accounts.length > 0;
//     }
     


//     // Navigate to the selected account's record page
//     navPageRef() {
//         if (!this.selectedAccount || !this.selectedAccount.Id) {
//             this.errorMessage = 'Please select an account first.';
//             return;
//         }

//         this[NavigationMixin.Navigate](this.accountPageRef);
//     }

//     get accountPageRef() {
//         return {
//             type: 'standard__recordPage',
//             attributes: {
//                 recordId: this.selectedAccount.Id,
//                 objectApiName: 'Account',
//                 actionName: 'view'
//             }
//         };
//     }
// }
import { LightningElement, wire } from 'lwc';
import getRecentAccounts from '@salesforce/apex/actionController.getRecentAccounts';
import getAccountWithoutPhone from '@salesforce/apex/actionController.getAccountWithoutPhone';
import getAccountList from '@salesforce/apex/actionController.getAccountList';
import { updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import ID_FIELD from '@salesforce/schema/Account.Id';
import DESCRIPTION_FIELD from '@salesforce/schema/Account.Description';

export default class AccountActionCenter extends NavigationMixin(LightningElement) {
    accounts = [];
    selectedAccount;
    description = '';
    errorMessage = '';
    loading = false;

    currentView = 'recent';
    wiredResultCache;

    // A reactive counter that forces Apex to reload when refreshed
    refreshCounter = 0;

    // We pass the refreshCounter as a parameter so refreshApex knows the data is dirty
    @wire(getRecentAccounts, { cacheBuster: '$refreshCounter' })
    wiredRecentResult(result) {
        debugger;
        if (this.currentView === 'recent') {
            this.handleWireResponse(result, 'Error loading recent accounts');
        }
    }

    @wire(getAccountList, { cacheBuster: '$refreshCounter' })
    wiredHotResult(result) {
        if (this.currentView === 'hot') {
            this.handleWireResponse(result, 'Error loading hot accounts');
        }
    }

    @wire(getAccountWithoutPhone, { cacheBuster: '$refreshCounter' })
    wiredNoPhoneResult(result) {
        if (this.currentView === 'nophone') {
            this.handleWireResponse(result, 'Error loading accounts without phone');
        }
    }

    handleWireResponse(result, fallbackError) {
        this.wiredResultCache = result; // Keep track of the active cache object
        const { data, error } = result;
        
        this.loading = true;
        if (data) {
            this.accounts = data.map(account => ({
                Id: account.Id,
                Name: account.Name ? account.Name : 'Not Specified',
                Industry: account.Industry ? account.Industry : 'Not Specified',
                Phone: account.Phone ? account.Phone : 'Not Specified',
                Rating: account.Rating ? account.Rating : 'Not Specified',
                Description: account.Description ? account.Description : 'Not Specified'
            }));
            this.errorMessage = undefined;
            this.loading = false; 
        } else if (error) {
            this.accounts = [];
            this.errorMessage = error.body?.message || fallbackError;
            this.loading = false;
        }
    }

    handleLoad() {
        
        this.loading = true;
        this.currentView = 'recent';
        this.selectedAccount = undefined;
        this.refreshCounter++; // Increment to force a clean fetch
    }

    handleHotAccounts() {
        this.loading = true;
        this.currentView = 'hot';
        this.selectedAccount = undefined;
        this.refreshCounter++;
    }

    handleAccountsWithoutPhone() {
        this.loading = true;
        this.currentView = 'nophone';
        this.selectedAccount = undefined;
        this.refreshCounter++;
    }

    handleUpdateDescription() {
        this.loading = true;
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.selectedAccount.Id;
        fields[DESCRIPTION_FIELD.fieldApiName] = this.description;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.errorMessage = undefined;
                
                //  Increment the counter to break the wire cache
                this.refreshCounter++; 
                
                // Call refreshApex to force the UI to repaint with the new database value
                return refreshApex(this.wiredResultCache);
            })
            .then(() => {
                // Keep the details card updated with what was just saved
                if (this.selectedAccount) {
                    this.selectedAccount = { ...this.selectedAccount, Description: this.description };
                }
            })
            .catch(error => {
                this.errorMessage = error.body?.message || 'Error updating description';
            })
            .finally(() => {
                this.loading = false;
            });
    }

    handleAccountSelect(event) {
        const accountId = event.currentTarget.dataset.id;
        this.selectedAccount = this.accounts.find(acc => acc.Id === accountId);
        this.description = this.selectedAccount?.Description === 'Not Specified' ? '' : this.selectedAccount?.Description || '';
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    get hasAccounts() {// prevent looping and check if accounts has a data 
        return this.accounts && this.accounts.length > 0;
    }

    navPageRef() {
        if (!this.selectedAccount || !this.selectedAccount.Id) {
            this.errorMessage = 'Please select an account first.';
            return;
        }
        this[NavigationMixin.Navigate](this.accountPageRef);
    }

    get accountPageRef() {
        return {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.selectedAccount.Id,
                objectApiName: 'Account',
                actionName: 'view'
            }
        };
    }
}
