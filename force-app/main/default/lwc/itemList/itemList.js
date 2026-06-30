import { LightningElement, api } from 'lwc';

export default class ItemList extends LightningElement {
    item1Status = 'Deselected';
    item2Status = 'Deselected';

    get item1StatusClass() {
        return this.item1Status === 'Selected' ? 'slds-text-color_success' : 'slds-text-color_error';
    }

    get item2StatusClass() {
        return this.item2Status === 'Selected' ? 'slds-text-color_success' : 'slds-text-color_error';
    }

    handleSelectionChange(event) {
        const { itemName, isSelected } = event.detail;
        
        if (itemName === 'Component 1') {
            this.item1Status = isSelected ? 'Selected' : 'Deselected';
        } else if (itemName === 'Component 2') {
            this.item2Status = isSelected ? 'Selected' : 'Deselected';
        }

        // Bubble up to grand parent
        const totalCount = (this.item1Status === 'Selected' ? 1 : 0) + (this.item2Status === 'Selected' ? 1 : 0);
        
        const parentEvent = new CustomEvent('countchange', {
            detail: {
                totalCount: totalCount
            },
            bubbles: true,
            composed: true
        });
        
        this.dispatchEvent(parentEvent);
    }

    @api
    resetAllItems() {
        const selectItems = this.template.querySelectorAll('c-select-item');
        selectItems.forEach(item => {
            item.resetItem();
        });
        
        this.item1Status = 'Deselected';
        this.item2Status = 'Deselected';
        
        const resetEvent = new CustomEvent('countchange', {
            detail: {
                totalCount: 0
            },
            bubbles: true,
            composed: true
        });
        
        this.dispatchEvent(resetEvent);
    }
}
