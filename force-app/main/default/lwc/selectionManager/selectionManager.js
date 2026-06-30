import { LightningElement } from 'lwc';

export default class SelectionManager extends LightningElement {
    totalCount = 0;

    handleCountChange(event) {
        this.totalCount = event.detail.totalCount;
        console.log('Total count updated to:', this.totalCount);
    }

    handleResetAll() {
        const itemList = this.template.querySelector('c-item-list');
        if (itemList) {
            itemList.resetAllItems();
        }
        this.totalCount = 0;
    }
}
