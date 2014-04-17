//
//  DeadlineReminderViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol saveNumberOfDaysDelegate <NSObject>

-(void)saveNumber: (NSNumber*)number;
    


@end


@interface DeadlineReminderViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate>
- (IBAction)saveButton:(id)sender;
- (IBAction)switchSwitched:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtDaysBeforeDeadline;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (strong, nonatomic) id <saveNumberOfDaysDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblQueso;
- (IBAction)addReminder:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *lblReminder;

@end
