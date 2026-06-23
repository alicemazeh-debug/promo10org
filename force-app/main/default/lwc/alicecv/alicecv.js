import { LightningElement } from 'lwc';

export default class Alicecv extends LightningElement {
    name = 'Alice';
    number = '+961-81949591';
    email = 'alice.mazeh@eit-mena.com';

    handleMenuSelect(event) {
        // TODO: Add menu handling logic here if needed.
        console.log('Menu selection:', event.detail.value);
    }
}