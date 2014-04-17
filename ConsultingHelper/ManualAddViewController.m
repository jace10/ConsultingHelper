//
//  ManualAddViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManualAddViewController.h"

@interface ManualAddViewController (){
    UIAlertView* alertView;
    UIImage *desiredProfilePic;
    BOOL isUp;
}

@end

@implementation ManualAddViewController
@synthesize txtJobTitle;
@synthesize txtPhoneNumber;
@synthesize imageButtonOutlet;
@synthesize txtDescription;
@synthesize txtBusinessName;
@synthesize segmentedControl;
@synthesize txtRate;
@synthesize txtClientName;
@synthesize scrollView;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        txtDescription.delegate = self;
    }
    return self;
}

-(BOOL) checkPhoneNumbers:(NSString*)number{
    for(int i = 0 ; i < [number length]; i++){
        char c = [number characterAtIndex:i];
        if(!isdigit(c)){
            return NO;
        }
    }
    return YES;
}

-(BOOL) checkRateNumbers:(NSString*)number{
    BOOL periodYet = NO;
    for(int i = 0 ; i < [number length]; i++){
        char c = [number characterAtIndex:i];
        if(!isdigit(c) && !(c == '.')){
            return NO;
        }
        if(c == '.'){
            if(!periodYet){
                periodYet = YES;
            }else{
                return NO;
            }
        }
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    UILabel *old = (UILabel*)[self.navigationController.navigationBar viewWithTag:900];
    [old removeFromSuperview];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, self.navigationController.navigationBar.frame.size.height)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTag:900];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    titleLabel.text = @"Add Job";
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    txtClientName.text = @"";
    txtBusinessName.text = @"";
    txtDescription.text = @"Job Description";
    txtJobTitle.text = @"";
    txtPhoneNumber.text = @"";
    txtRate.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isUp = NO;
    [scrollView setContentSize:CGSizeMake(320, 550)];
    txtDescription.layer.cornerRadius = 5;
    txtDescription.clipsToBounds = YES;
    [imageButtonOutlet.layer setBorderWidth:2];
    [imageButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    UIBarButtonItem *savebutton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(sendToDatePickers:)];
    self.navigationItem.rightBarButtonItem = savebutton;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSegmentedControl:nil];
    [self setScrollView:nil];
    [self setTxtClientName:nil];
    [self setTxtBusinessName:nil];
    [self setTxtDescription:nil];
    [self setTxtRate:nil];
    [self setTxtJobTitle:nil];
    [self setTxtPhoneNumber:nil];
    [self setImageButtonOutlet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    desiredProfilePic = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissModalViewControllerAnimated:YES];
    [imageButtonOutlet setBackgroundColor:[UIColor whiteColor]];
    [imageButtonOutlet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageButtonOutlet setTitle:@"Image Selected" forState:UIControlStateNormal];
}

- (IBAction)imageAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)segmentSwitch:(id)sender {
    if(segmentedControl.selectedSegmentIndex == 1){
        desiredProfilePic = nil;
        [imageButtonOutlet setBackgroundColor:[UIColor clearColor]];
        [imageButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [imageButtonOutlet setTitle:@"Image From Gallery" forState:UIControlStateNormal];
        imageButtonOutlet.hidden = YES;
        txtClientName.hidden = YES;
        txtBusinessName.hidden = YES;
        txtPhoneNumber.hidden = YES;
        txtJobTitle.frame = CGRectMake(txtClientName.frame.origin.x, imageButtonOutlet.frame.origin.y, txtClientName.frame.size.width, txtClientName.frame.size.height);
        txtDescription.frame = CGRectMake(txtBusinessName.frame.origin.x, txtJobTitle.frame.origin.y + txtJobTitle.frame.size.height +3, txtBusinessName.frame.size.width, 102);
        txtRate.frame = CGRectMake(txtClientName.frame.origin.x, txtDescription.frame.origin.y + txtDescription.frame.size.height + (txtBusinessName.frame.origin.y - (txtClientName.frame.origin.y + txtClientName.frame.size.height)), txtBusinessName.frame.size.width, txtBusinessName.frame.size.height);
    }else{
        txtJobTitle.frame = CGRectMake(25, 131, 270, 31);
        txtDescription.frame = CGRectMake(25,164,270,102);
        txtRate.frame = CGRectMake(25,267,270,31);
        txtClientName.hidden = NO;
        imageButtonOutlet.hidden = NO;
        txtBusinessName.hidden = NO;
        txtPhoneNumber.hidden = NO;
    }
    
    
    
}

-(void)sendToDatePickers: (UIButton*)sender{
    if(segmentedControl.selectedSegmentIndex == 0){
        

        if(txtRate.text == nil|| txtClientName.text== nil || [txtDescription.text isEqualToString:@""] || txtBusinessName.text== nil|| txtJobTitle.text== nil  || txtPhoneNumber.text== nil || [txtRate.text isEqualToString:@""]|| [txtClientName.text isEqualToString:@""]|| [txtBusinessName.text isEqualToString:@""]|| [txtJobTitle.text isEqualToString:@""]|| [txtPhoneNumber.text isEqualToString:@""]){
            alertView = [[UIAlertView alloc] initWithTitle:@"Please Fill All Fields" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];

        }else{
            [self performSegueWithIdentifier:@"toDatePickerSegue" sender:self];
        }
    }else{
        if([txtDescription.text isEqualToString:@""] || txtRate.text== nil|| txtJobTitle.text== nil|| [txtRate.text isEqualToString:@""]|| [txtJobTitle.text isEqualToString:@""]){
            alertView = [[UIAlertView alloc] initWithTitle:@"Please Fill All Fields" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];

        }else{
            [self performSegueWithIdentifier:@"toDatePickerSegue" sender:self];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DatePickersViewController *dpvc = (DatePickersViewController*)segue.destinationViewController;
    if(segmentedControl.selectedSegmentIndex == 1){
        dpvc.rate = txtRate.text;
        dpvc.jobTitle = txtJobTitle.text;
        dpvc.clientPhoneNumber = txtPhoneNumber.text;
        dpvc.description = txtDescription.text;
        dpvc.clientExists = @"Yes";
        dpvc.clientName = @"";
        dpvc.companyName = @"";
    }else{
        dpvc.rate = txtRate.text;
        dpvc.description = txtDescription.text;
        dpvc.jobTitle = txtJobTitle.text;
        dpvc.clientExists = @"No";
        dpvc.clientName = txtClientName.text;
        dpvc.companyName = txtBusinessName.text;
        dpvc.clientPhoneNumber = txtPhoneNumber.text;
        if(desiredProfilePic){
            dpvc.localImage = UIImagePNGRepresentation(desiredProfilePic);
        }
    }
}



-(void)textFieldDidBeginEditing:(UITextView *)textView{
    if ((UITextField*)textView == txtRate) {
        CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [scrollView setContentOffset:bottomOffset animated:YES];
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    
    if(textField == txtPhoneNumber){
        if(![self checkPhoneNumbers:txtPhoneNumber.text] || txtPhoneNumber.text.length != 10){
            txtPhoneNumber.text = @"";
            alertView = [[UIAlertView alloc] initWithTitle:@"Please enter in 5555555555 format" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    if(textField == txtRate){
        if(![self checkRateNumbers:txtRate.text]){
            txtRate.text = @"";
            alertView = [[UIAlertView alloc] initWithTitle:@"Not a Number" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)thisScrollView
{        
    [self.view endEditing:YES];
}

@end
