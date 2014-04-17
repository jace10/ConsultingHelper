//
//  DatePickersViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryViewController.h"
#import "AppDelegate.h"
#import "Company.h"
#import "Task.h"
#import "Reminder.h"
#import "ClientTableViewController.h"
#import "DeadlineReminderViewController.h"

@interface DatePickersViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate, existingClient, saveNumberOfDaysDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *deadlinePicker;
@property (strong, nonatomic) NSString *clientExists;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *clientName;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *clientPhoneNumber;
@property (strong, nonatomic) NSString *rate;
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSData *localImage;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
