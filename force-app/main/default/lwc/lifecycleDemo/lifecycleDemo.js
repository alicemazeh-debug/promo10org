import { LightningElement } from 'lwc';

export default class LifecycleDemo extends LightningElement {
    loading = true;
    counter = 0;
    message = 'Hello LWC!';

    constructor() {
        super();
        console.log('Constructor called');
    }

    connectedCallback() {
        console.log('connectedCallback called');
        console.log(this.message);
    }

    renderedCallback() {
        console.log('renderedCallback called');
    }

    handleIncrement() {
        this.counter += 1;
        console.log('Counter incremented to: ' + this.counter);
    }

    handleShowHideMessage() {
        this.message = this.message ? '' : 'Hello LWC!';
    }
}
