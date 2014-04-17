//
//  DeadlineReminderViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeadlineReminderViewController.h"

@interface DeadlineReminderViewController (){
    NSInteger numReminders;
}

@end

@implementation DeadlineReminderViewController
@synthesize scrollView;
@synthesize addButton;
@synthesize saveButtonOutlet;
@synthesize lblReminder;
@synthesize txtDaysBeforeDeadline;
@synthesize onOffSwitch;
@synthesize delegate;
@synthesize lblQueso;
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        numReminders = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTxtDaysBeforeDeadline:nil];
    [self setOnOffSwitch:nil];
    [self setLblQueso:nil];
    [self setScrollView:nil];
    [self setAddButton:nil];
    [self setSaveButtonOutlet:nil];
    [self setLblReminder:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveButton:(id)sender {
    for(int i = 1; i <= numReminders; i ++){
        if(i == 1){
            if([onOffSwitch isOn]){
                
                [self.delegate saveNumber:[NSNumber numberWithInt:[txtDaysBeforeDeadline.text intValue]]];
                
            } 
        }else{
            UISwitch *aSwitch = (UISwitch*)[self.view viewWithTag:100+i];
            UITextField *aText = (UITextField*)[self.view viewWithTag:200+i];
            if([aSwitch isOn]){
                
                [self.delegate saveNumber:[NSNumber numberWithInt:[aText.text intValue]]];
                
            } 
        }
    }
    
    
    
    
    [self dismissModalViewControllerAnimated:YES];

}

- (IBAction)switchSwitched:(id)sender {
    if((UISwitch*)sender == onOffSwitch){
        if([onOffSwitch isOn]){
            txtDaysBeforeDeadline.hidden = NO;
        }else{
            if([txtDaysBeforeDeadline.text isEqualToString:@"ME GUSTA QUESO"]){
                lblQueso.hidden = NO;
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideQueso) userInfo:nil repeats:NO];
            }
            txtDaysBeforeDeadline.hidden = YES;
        }
    }else{
        
        UISwitch *thisSwitch = (UISwitch*)sender;
        

        UITextField *thisText = (UITextField*)[self.view viewWithTag:thisSwitch.tag + 100];
        if([thisSwitch isOn]){
            thisText.hidden = NO;
        }else{
            thisText.hidden = YES;
        }
    }
    
}

-(void)hideQueso{
    lblQueso.hidden = YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(![self checkDayNumbers:textField.text]){
        textField.text = @"";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Must Be an Integer" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    return YES;
}
- (IBAction)addReminder:(id)sender {
    numReminders ++;
    CGRect addFrame = addButton.frame;
    addFrame.origin.y = addFrame.origin.y + 80;

    addButton.frame = addFrame;
    addFrame = saveButtonOutlet.frame;
    addFrame.origin.y = addFrame.origin.y + 80;
    saveButtonOutlet.frame = addFrame;
    
    if(numReminders == 2){
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblReminder.frame.origin.x, lblReminder.frame.origin.y + 80, lblReminder.frame.size.width, lblReminder.frame.size.height)];
        [newLabel setBackgroundColor:[UIColor clearColor]];
        [newLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [newLabel setText:@"Reminder:"];
        [newLabel setTextColor:[UIColor whiteColor]];
        [newLabel setTag:300+numReminders];
        [scrollView addSubview:newLabel];
        
        UISwitch *newSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(onOffSwitch.frame.origin.x, onOffSwitch.frame.origin.y + 80, onOffSwitch.frame.size.width, onOffSwitch.frame.size.height)];
        [newSwitch addTarget:self action:@selector(switchSwitched:) forControlEvents:UIControlEventValueChanged];
        [scrollView addSubview: newSwitch];
        [newSwitch setTag:100+ numReminders];
        UITextField *newField = [[UITextField alloc] initWithFrame:CGRectMake(txtDaysBeforeDeadline.frame.origin.x, txtDaysBeforeDeadline.frame.origin.y + 80, txtDaysBeforeDeadline.frame.size.width, txtDaysBeforeDeadline.frame.size.height)];
        [newField setBackgroundColor:[UIColor whiteColor]];
        [newField setHidden:YES];
        [newField setDelegate:self];
        [newField setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [newField setTextAlignment:UITextAlignmentLeft];
        [newField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [newField setPlaceholder:@"Days Before Deadline"];
        newField.layer.cornerRadius = 4;
        [scrollView addSubview:newField];
        [newField setTag:200+numReminders];

    }else{
        UISwitch *switchBefore = (UISwitch*)[self.view viewWithTag:100+numReminders-1];
        UITextField *textBefore = (UITextField*)[self.view viewWithTag:200+numReminders-1];
        UILabel *labelBefore = (UILabel*)[self.view viewWithTag:300+numReminders-1];
        
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelBefore.frame.origin.x, labelBefore.frame.origin.y + 80, labelBefore.frame.size.width, labelBefore.frame.size.height)];
        [newLabel setBackgroundColor:[UIColor clearColor]];
        [newLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [newLabel setTextColor:[UIColor whiteColor]];
        [newLabel setText:@"Reminder:"];
        [newLabel setTag:300+numReminders];
        [scrollView addSubview:newLabel];

        
        
        UISwitch *newSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(switchBefore.frame.origin.x, switchBefore.frame.origin.y + 80, switchBefore.frame.size.width, switchBefore.frame.size.height)];
        [newSwitch addTarget:self action:@selector(switchSwitched:) forControlEvents:UIControlEventValueChanged];

        [scrollView addSubview: newSwitch];
        [newSwitch setTag:100+ numReminders];

        UITextField *newField = [[UITextField alloc] initWithFrame:CGRectMake(textBefore.frame.origin.x, textBefore.frame.origin.y + 80, textBefore.frame.size.width, textBefore.frame.size.height)];
        [newField setBackgroundColor:[UIColor whiteColor]];
        [newField setHidden:YES];
        [newField setDelegate:self];
        [newField setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [newField setTextAlignment:UITextAlignmentLeft];
        [newField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

        [newField setPlaceholder:@"Days Before Deadline"];
        newField.layer.cornerRadius = 5;

        [scrollView addSubview:newField];
        [newField setTag:200+numReminders];
        if(newField.frame.origin.y + newField.frame.size.height + 100 > 400){
            [scrollView setContentSize:CGSizeMake(320, newField.frame.origin.y + newField.frame.size.height + 100)];

        }
    }
    
    
    
    
    
    
    
    
    
    
    
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag > 202){
        CGPoint offset = CGPointMake(0, textField.frame.origin.y - 20);
        [scrollView setContentOffset:offset animated:YES];
    }
}

-(BOOL) checkDayNumbers:(NSString*)number{
    for(int i = 0 ; i < [number length]; i++){
        char c = [number characterAtIndex:i];
        if(!isdigit(c)){
            return NO;
        }
        
    }
    return YES;
}








@end
