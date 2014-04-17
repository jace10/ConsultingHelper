//
//  IncrementHoursViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Task.h"
#import "Reminder.h"
#import "AppDelegate.h"


@interface IncrementHoursViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblHourChange;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtNumHours;
@property (weak, nonatomic) IBOutlet UITextField *txtNumDays;
@property (strong, nonatomic) Task *selectedTask;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIButton *cancelButtonOutlet;
- (IBAction)cancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedule;

@end
