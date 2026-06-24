import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    childMessage = '';

    handledatafromchild(event) {
        const { message, timestamp } = event.detail;
        this.childMessage = message;
        console.log('Received message from child:', message);
        console.log('Timestamp:', timestamp);
    }
}