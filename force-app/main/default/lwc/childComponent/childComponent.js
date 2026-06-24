import { LightningElement ,api} from 'lwc';

export default class ChildComponent extends LightningElement {
    greeting = 'Parent';
    //@api greeting ;
   // @api name ;
    //@api age ;
    //@api position ;


    sendDataToParent() {
        const customEvent = new CustomEvent('childmsg', {
            detail: { message: this.greeting, timestamp: Date.now() }
        });

        this.dispatchEvent(customEvent);
    }
}

