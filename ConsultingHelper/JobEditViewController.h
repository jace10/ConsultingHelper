//
//  JobEditViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Task.h"
#import "Reminder.h"
#import "DateEditViewController.h"
#import "AppDelegate.h"

@interface JobEditViewController : UIViewController <UITextFieldDelegate, dateChangeDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtJobTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtJobDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtRate;

@property (strong, nonatomic) Task *selectedTask;
@property (strong, nonatomic) NSString *englishStart;
@property (strong, nonatomic) NSString *englishDeadline;

@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *deadlineDateButton;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveButton:(id)sender;
- (IBAction)CancelButton:(id)sender;

@end
