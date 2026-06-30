import { LightningElement, api } from 'lwc';

export default class SelectItem extends LightningElement {
    @api itemName = 'Item';
    isSelected = false;

    get status() {
        return this.isSelected ? 'Selected' : 'Deselected';
    }

    get statusClass() {
        return this.isSelected ? 'slds-text-color_success' : 'slds-text-color_error';
    }

    get buttonLabel() {
        return this.isSelected ? 'Deselect' : 'Select';
    }

    handleToggleSelection() {
        this.isSelected = !this.isSelected;
        
        const event = new CustomEvent('selectionchange', {
            detail: {
                itemName: this.itemName,
                isSelected: this.isSelected
            },
            bubbles: true,
            composed: true
        });
        
        this.dispatchEvent(event);
    }

    @api
    resetItem() {
        this.isSelected = false;
    }
}
