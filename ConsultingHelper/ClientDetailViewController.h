//
//  ClientDetailViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Task.h"
#import "EntryViewController.h"
#import "JobEditViewController.h"
#import "IncrementHoursViewController.h"
#import <MessageUI/MessageUI.h>

@interface ClientDetailViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *clientNameButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *companyNameButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButtonOutlet;
- (IBAction)clientEdit:(id)sender;

- (IBAction)contactButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskSegmentedControl;
- (IBAction)backButton:(id)sender;
- (IBAction)editButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *imgLeftArrow;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyEarned;

@property (weak, nonatomic) IBOutlet UIScrollView *taskContentScrollView;
@property (strong, nonatomic) Company *client;
@property (strong, nonatomic) UIImage *clientPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalHours;
@property (weak, nonatomic) IBOutlet UILabel *lblHoursWorked;
@property (weak, nonatomic) IBOutlet UILabel *lblHoursTotalWritten;
@property (weak, nonatomic) IBOutlet UILabel *lblJobDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDeadline;
@property (weak, nonatomic) IBOutlet UIImageView *imgDeadlineClose;
- (IBAction)infoShow:(id)sender;

@end
