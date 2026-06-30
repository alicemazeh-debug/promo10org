import { LightningElement } from 'lwc';

export default class CompThree extends LightningElement {
    
    childOneSelected = true;
    childTwoSelected = false;

    get childOne() {
        return this.childOneSelected ? 'Selected' : 'Deselected';
    }

    get childTwo() {
        return this.childTwoSelected ? 'Selected' : 'Deselected';
    }

    // Event handlers triggered by child buttons
    handleChildOneToggle() {
        this.childOneSelected = !this.childOneSelected;
    }

    handleChildTwoToggle() {
        this.childTwoSelected = !this.childTwoSelected;
    }

    handleSelectionChange(event) {
        const { itemName, isSelected } = event.detail;
        if (itemName === 'Component 1') {
            this.childOneSelected = isSelected;
        } else if (itemName === 'Component 2') {
            this.childTwoSelected = isSelected;
        }
    }
}
