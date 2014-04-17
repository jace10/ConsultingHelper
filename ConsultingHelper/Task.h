//
//  Task.h
//  ConsultingHelper
//
//  Created by Jason Mather on 7/30/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, Reminder;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * billingPeriodEnd;
@property (nonatomic, retain) NSNumber * daysInBillingPeriod;
@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSNumber * hoursWorked;
@property (nonatomic, retain) NSString * jobDescription;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSNumber * maximumHours;
@property (nonatomic, retain) NSString * rate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * hourScheduleNumDays;
@property (nonatomic, retain) NSDate * nextHourAddDate;
@property (nonatomic, retain) NSNumber * numHoursToAdd;
@property (nonatomic, retain) Company *client;
@property (nonatomic, retain) NSSet *reminder;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addReminderObject:(Reminder *)value;
- (void)removeReminderObject:(Reminder *)value;
- (void)addReminder:(NSSet *)values;
- (void)removeReminder:(NSSet *)values;

@end
