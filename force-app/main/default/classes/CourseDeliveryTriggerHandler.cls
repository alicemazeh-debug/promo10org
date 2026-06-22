public class CourseDeliveryTriggerHandler {

    public static Set<Date> allHolidays = new Set<Date>();

    static {
        for (Holiday h : [SELECT ActivityDate FROM Holiday]) {
            allHolidays.add(h.ActivityDate);
        }
    }

    //TODO #2: Review the following static method.
    // It encapsulates the logic that was formerly found in the trigger.
    // It is static, so it can be invoked without instantiating the class.
    // Notice that instead of referencing Trigger.new and Trigger.oldMap directly as 
    // was done in the trigger block, we now reference the trigger context variables passed
    // in as arguments to this method in order to improve testability and code reuse.
    
    public static void preventInvalidCourseDeliveries(List<Course_Delivery__c> newCourseDeliveryList,
                                                      Map<ID, Course_Delivery__c> oldCourseDeliveryMap) {

        for (Course_Delivery__c cd : newCourseDeliveryList) {
            //TODO #3: Complete the following if statement using the Apex Safe Navigation Operator
            // to reference oldCourseDeliveryMap. The if statement should evaluate to true if
            // oldCourseDeliveryMap is null or if the old start date is not equal to the new start date            
            if ( oldCourseDeliveryMap?.get(cd.Id).Start_Date__c != cd.Start_Date__c) { 
                

                // Prevent the invoking DML action if the Start Date is in the allHolidays set.
                if (allHolidays.contains(cd.Start_Date__c)) {
                    cd.Start_Date__c.addError(Label.Error_Custom);
                    // TODO #1
                    // Immediately Publish a platform event with details of the error
                    Error_Message__e event = new Error_Message__e();
                    event.Source_Component__c = 'CourseDeliveryTriggerHandler';
                    event.Error_Message__c = 'ERROR: ' ;
                    EventBus.publish(event);

                }
            }
        }
    }
}