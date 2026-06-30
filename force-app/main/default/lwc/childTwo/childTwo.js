// childCmp.js
import { api, LightningElement } from "lwc";

export default class childCmp extends LightningElement {
  @api isSelected;
  
      get buttonLabel() {
        return this.isSelected ? 'Deselect' : 'Select';
    
    }

    get buttonClass(){
                return this.isSelected ? 'btn-deselect' : 'btn-select';

    }
    handleToggle() {
        
        const toggleEvent = new CustomEvent('toggletwo');
        this.dispatchEvent(toggleEvent);
    }


  handlegrandChildEvent(event) {
    this.messageReceived = event.detail;
  }
}