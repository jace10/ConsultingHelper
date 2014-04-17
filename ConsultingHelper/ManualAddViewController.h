//
//  ManualAddViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryViewController.h"
#import "DatePickersViewController.h"

@interface ManualAddViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UIScrollViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtJobTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonOutlet;
- (IBAction)imageAction:(id)sender;

- (IBAction)segmentSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtBusinessName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *txtRate;
@property (weak, nonatomic) IBOutlet UITextField *txtClientName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
