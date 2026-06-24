import { LightningElement } from 'lwc';

export default class AddEmployee extends LightningElement {
    firstName = '';
    lastName = '';
    email = '';
    age = '';
    employees = [];

    handleNameChange(event) {
        const { firstName, lastName } = event.detail;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleAgeChange(event) {
        this.age = event.target.value;
    }

    handleSubmit() {
        if (!this.firstName || !this.lastName || !this.email || !this.age) {
            return;
        }

        const newEmployee = {
            id: Date.now().toString(),
            firstName: this.firstName,
            lastName: this.lastName,
            fullName: `${this.firstName} ${this.lastName}`,
            email: this.email,
            age: this.age
        };

        this.employees = [...this.employees, newEmployee];
        this.clearForm();
    }

    handleRemoveEmployee(event) {
        const employeeId = event.target.dataset.id;
        this.employees = this.employees.filter((employee) => employee.id !== employeeId);
    }

    clearForm() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.age = '';

        const nameInput = this.template.querySelector('lightning-input-name[name="employeeName"]');
        if (nameInput) {
            nameInput.firstName = '';
            nameInput.lastName = '';
        }

        const emailInput = this.template.querySelector('lightning-input[name="email"]');
        if (emailInput) {
            emailInput.value = '';
        }

        const ageInput = this.template.querySelector('lightning-input[name="age"]');
        if (ageInput) {
            ageInput.value = '';
        }
    }
}
