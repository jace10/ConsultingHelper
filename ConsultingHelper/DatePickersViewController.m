//
//  DatePickersViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickersViewController.h"
#include <stdlib.h>

@interface DatePickersViewController (){
    BOOL isUp;
    UIAlertView *alertView;
    UITextField *billingPeriodLength;
    UITextField *maximumHours;
    UITextField *hoursWorked;
    Company *existingClient;
    BOOL clientSet;
    UIButton *clientButton;
    UIButton *deadlineReminder;
    NSMutableArray *deadlineNumbers;
    UIButton *savebutton;
}

@end

@implementation DatePickersViewController
@synthesize jobTitle;
@synthesize scrollView;
@synthesize clientPhoneNumber;
@synthesize startPicker;
@synthesize deadlinePicker;
@synthesize clientName;
@synthesize companyName;
@synthesize clientExists;
@synthesize rate;
@synthesize localImage;
@synthesize description;
@synthesize managedObjectContext;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        deadlineNumbers = [[NSMutableArray alloc] initWithCapacity:25];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    clientSet = NO;
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

    isUp = NO;
    billingPeriodLength = [[UITextField alloc] initWithFrame:CGRectMake(20, deadlinePicker.frame.origin.y + deadlinePicker.frame.size.height + 20, 280, 30)];
    [billingPeriodLength setTextColor:[UIColor whiteColor]];
    billingPeriodLength.placeholder = @"# of Days per Billing Period";
    [billingPeriodLength setBorderStyle:UITextBorderStyleBezel];
    billingPeriodLength.delegate = self;
    billingPeriodLength.tag = 100;
    [scrollView addSubview:billingPeriodLength];
    
    
    maximumHours = [[UITextField alloc] initWithFrame:CGRectMake(20, billingPeriodLength.frame.origin.y+billingPeriodLength.frame.size.height + 20, 280, 30)];
    maximumHours.placeholder = @"Maximum Hours Per Billing Period";
    [maximumHours setBorderStyle:UITextBorderStyleBezel];
    [maximumHours setTextColor:[UIColor whiteColor]];
    maximumHours.tag = 101;
    maximumHours.delegate = self;
    [scrollView addSubview:maximumHours];
    
    hoursWorked = [[UITextField alloc] initWithFrame:CGRectMake(20, maximumHours.frame.origin.y+maximumHours.frame.size.height + 20, 280, 30)];
    hoursWorked.placeholder = @"Hours Worked This Billing Period";
    [hoursWorked setBorderStyle:UITextBorderStyleBezel];
    [hoursWorked setTextColor:[UIColor whiteColor]];
    hoursWorked.tag = 102;
    hoursWorked.delegate = self;
    [scrollView addSubview:hoursWorked];
    
    deadlineReminder = [[UIButton alloc] initWithFrame:CGRectMake(20, hoursWorked.frame.origin.y+hoursWorked.frame.size.height + 20, 280, 30)];
    [deadlineReminder setBackgroundColor:[UIColor clearColor]];
    [deadlineReminder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deadlineReminder setTitle:@"Set Deadline Reminder" forState:UIControlStateNormal];
    [deadlineReminder.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [deadlineReminder.layer setBorderWidth:2.0];
    [deadlineReminder addTarget:self action:@selector(deadlineReminderButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:deadlineReminder];
    
    savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(240, 10, 80, 30);
    [savebutton setBackgroundColor:[UIColor blackColor]];
    [savebutton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [savebutton.layer setBorderWidth:2.0];
    [savebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    savebutton.clipsToBounds = YES;
    [savebutton setTitle:@"Save" forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:savebutton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 10, 80, 30);
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cancelButton.layer setBorderWidth:2.0];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.clipsToBounds = YES;
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cancelButton];
    
    
    if([clientExists isEqualToString:@"Yes"]){
        clientButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clientButton.frame = CGRectMake(110, 10, 100, 30);
        [clientButton setBackgroundColor:[UIColor blackColor]];
        [clientButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [clientButton.layer setBorderWidth:2.0];
        [clientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        clientButton.clipsToBounds = YES;
        [clientButton setTitle:@"Client" forState:UIControlStateNormal];
        [clientButton addTarget:self action:@selector(selectClient:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:clientButton]; 
    }
   
   
    
    [scrollView setContentSize:CGSizeMake(320, deadlineReminder.frame.origin.y + deadlineReminder.frame.size.height + 50)];
    [scrollView flashScrollIndicators];
	
    // Do any additional setup after loading the view.
}

-(IBAction)deadlineReminderButton:(id)sender{
    [self.view endEditing:YES];
    isUp = NO;
    [self performSegueWithIdentifier:@"toDeadlineReminderSegue" sender:self];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setStartPicker:nil];
    [self setDeadlinePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) animateView: (UIView*) view up: (BOOL) up 
{
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    if(up){
        isUp = true;
    }else {
        isUp = false;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    savebutton.userInteractionEnabled = NO;
    if(textField.tag ==100 && isUp == false){
        [self animateView:self.view up:YES];
    }
    if(textField.tag ==101 && isUp == false){
        [self animateView:self.view up:YES];
    }
    
    if(textField.tag ==102 && isUp == false){
        [self animateView:self.view up:YES];
    }
}

-(BOOL) checkNumbers:(NSString*)number{
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    //NSLog(@"tag is %d",nextTag);
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [self animateView:self.view up:NO];
        
        UIBarButtonItem *saveButton1 = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [saveButton1 setEnabled:YES];
        [textField resignFirstResponder];
        [savebutton setUserInteractionEnabled:YES];
    }
    
    if([textField.text doubleValue] < 0){
        textField.text = @"";
        alertView = [[UIAlertView alloc] initWithTitle:@"Must Be Non-Negative" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    }
    if(![self checkNumbers:textField.text]){
        textField.text = @"";
        alertView = [[UIAlertView alloc] initWithTitle:@"Must Be a Number" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    }else{
        if(textField == hoursWorked){
            
            if(maximumHours.text == @""){
                textField.text = @"";
                alertView = [[UIAlertView alloc] initWithTitle:@"Enter the Value for Maximum Hours First" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];

            }else{
                if([textField.text doubleValue] > [maximumHours.text doubleValue]){
                    textField.text = @"";
                    alertView = [[UIAlertView alloc] initWithTitle:@"Must Be Less Than Maximum Hours" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];

                }
            }
        }
    }
    
    
    
    

    
    return NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)thisScrollView
{
    if(thisScrollView == scrollView){
        
        [self.view endEditing:YES];
        [savebutton setUserInteractionEnabled:YES];
        UIBarButtonItem *saveButton1 = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [saveButton1 setEnabled:YES];
        if(isUp){
            [self animateView:self.view up:NO];
        }
    }
}

-(IBAction)cancelAction:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender{
    if([clientExists isEqualToString:@"Yes"]){
        if(maximumHours.text == nil || billingPeriodLength.text == nil || hoursWorked.text == nil || clientSet == NO){
            alertView = [[UIAlertView alloc] initWithTitle:@"Please Fill In All Fields And Select Client" message:@"Even the ones at the bottom" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];

        }else{
            [self insertjobInfoIntoCoreDataExistingClient];
            
            if(deadlineNumbers.count > 1){
                for(int i = 1; i < deadlineNumbers.count; i ++){
                    [self insertReminderIntoJob:i];
                }
            }
            
            [self dismissModalViewControllerAnimated:YES];
        }
    }else{
        if(maximumHours.text == nil || billingPeriodLength.text == nil || hoursWorked.text == nil){
            alertView = [[UIAlertView alloc] initWithTitle:@"Please Fill In All Fields" message:@"Even the ones at the bottom" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            
            [self insertjobInfoIntoCoreData];
            if(deadlineNumbers.count > 1){
                for(int i = 1; i < deadlineNumbers.count; i ++){
                    [self insertReminderIntoJob:i];
                }
            }
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
}

-(IBAction)selectClient:(id)sender{
    
    [self performSegueWithIdentifier:@"toClientTableSegue" sender:self];
}

-(NSDate*)setReminder:(NSInteger)number : (NSString*)taskName{
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[deadlinePicker date]];
    if([startComponents day] <= number){
        if([startComponents month] == 1){
            [startComponents setYear:[startComponents year] -1];
            [startComponents setMonth:12];
            [startComponents setDay:31-(number - [startComponents day])];
        }else{
            [startComponents setMonth:[startComponents month] - 1];
            switch ([startComponents month]) {
                case 1:
                    [startComponents setDay:31-(number - [startComponents day])];
                    break;
                case 2:
                    if([startComponents year] % 4 ==0 && ([startComponents year] % 100 != 0 || [startComponents year] % 400 == 0)){
                        [startComponents setDay:29-(number - [startComponents day])];
                        
                    }else{
                        [startComponents setDay:28-(number - [startComponents day])];
                        
                    }
                    
                    break;
                    
                case 3:
                    [startComponents setDay:31-(number - [startComponents day])];
                    break;
                    
                case 4:
                    [startComponents setDay:30-(number - [startComponents day])];
                    
                    break;
                    
                case 5:
                    [startComponents setDay:31-(number - [startComponents day])];
                    break;
                    
                case 6:
                    [startComponents setDay:30-(number - [startComponents day])];
                    
                    break;
                    
                case 7:
                    [startComponents setDay:31-(number - [startComponents day])];
                    break;
                    
                case 8:
                    [startComponents setDay:31-(number - [startComponents day])];
                    break;
                    
                case 9:
                    [startComponents setDay:30-(number - [startComponents day])];
                    
                    break;
                    
                case 10:
                    [startComponents setDay:31-(number - [startComponents day])];
                    break;
                    
                case 11:
                    [startComponents setDay:30-(number - [startComponents day])];
                    
                    break;
                    
                    
                case 12:
                    [startComponents setDay:31-(number - [startComponents day])];
                    
                    break;
                default:
                    break;
            }
        }
    }else{
        [startComponents setDay:[startComponents day] - number];
    }
    NSDate *reminderFireDate = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] dateFromComponents:startComponents];
    UILocalNotification *thisReminder = [[UILocalNotification alloc] init];
    thisReminder.fireDate = reminderFireDate;
    thisReminder.timeZone = [NSTimeZone defaultTimeZone];
    startComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[deadlinePicker date]];
    
    thisReminder.alertBody = [NSString stringWithFormat:@"Reminder, the deadline for %@ is %d days away, on %d/%d/%d",jobTitle,number,[startComponents month],[startComponents day],[startComponents year]];
    // Set the action button
    thisReminder.alertAction = @"Thanks!";
    thisReminder.soundName = UILocalNotificationDefaultSoundName;
    NSLog(@"taskName %@",taskName);
    thisReminder.userInfo  = [NSDictionary dictionaryWithObject:taskName forKey:@"notificationID"];
    [[UIApplication sharedApplication] scheduleLocalNotification:thisReminder];
    
    return thisReminder.fireDate;
}

- (void) insertjobInfoIntoCoreData{
    
    Company *thisClient = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    Task *thisJob = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    if (deadlineNumbers.count > 0) {
        Reminder *thisReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.managedObjectContext];
                
        thisClient.clientName = clientName;
        thisClient.companyName = companyName;
        thisClient.phoneNumber = clientPhoneNumber;
        if(localImage){
            thisClient.localImage = localImage;

        }
        thisClient.imgPath = @"null";
        thisJob.jobTitle = jobTitle;
        thisJob.jobDescription = description;
        thisJob.rate = rate;
        thisJob.numHoursToAdd = 0;
        thisJob.nextHourAddDate = nil;
        thisJob.hourScheduleNumDays = 0;
        thisJob.startDate = startPicker.date;
        thisJob.deadline = deadlinePicker.date;
        thisJob.billingPeriodEnd = [self billingPeriodEndCalculator:startPicker.date :[billingPeriodLength.text integerValue]];
        thisJob.maximumHours = [NSNumber numberWithDouble:[maximumHours.text doubleValue]];
        thisJob.hoursWorked = [NSNumber numberWithDouble:[hoursWorked.text doubleValue]];
        thisJob.daysInBillingPeriod = [NSNumber numberWithDouble:[billingPeriodLength.text doubleValue]];
        [thisJob setReminder:[NSSet setWithObject:thisReminder]];
        [thisClient setJob:[NSSet setWithObject:thisJob]];
        
        int rand = arc4random() % 7000;
        thisReminder.fireDate = [self setReminder:[[deadlineNumbers objectAtIndex:0] intValue] :[NSString stringWithFormat:@"%@ %d",jobTitle, rand]];
        thisReminder.notificationIdentifier = [NSString stringWithFormat:@"%@ %d",jobTitle,rand ];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            return;
        }

    }else{
        thisClient.clientName = clientName;
        thisClient.companyName = companyName;
        thisClient.phoneNumber = clientPhoneNumber;
        if(localImage){
            thisClient.localImage = localImage;
            
        }
        thisClient.imgPath = @"null";
        thisJob.jobTitle = jobTitle;
        thisJob.jobDescription = description;
        thisJob.rate = rate;
        thisJob.startDate = startPicker.date;
        thisJob.deadline = deadlinePicker.date;
        thisJob.numHoursToAdd = 0;
        thisJob.nextHourAddDate = nil;
        thisJob.hourScheduleNumDays = 0;
        thisJob.maximumHours = [NSNumber numberWithDouble:[maximumHours.text doubleValue]];
        thisJob.hoursWorked = [NSNumber numberWithDouble:[hoursWorked.text doubleValue]];
        thisJob.billingPeriodEnd = [self billingPeriodEndCalculator:startPicker.date :[billingPeriodLength.text integerValue]];

        thisJob.daysInBillingPeriod = [NSNumber numberWithDouble:[billingPeriodLength.text doubleValue]];
        [thisClient setJob:[NSSet setWithObject:thisJob]];
        [thisJob setReminder:nil];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            return;
        }
    }
    
   
}

- (void) insertReminderIntoJob: (int) atIndex{
    Reminder *thisReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.managedObjectContext];
    
//    if (self.managedObjectContext == nil) {
//        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
//    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSArray *predicates;
    
    // Set the predicate
    NSPredicate *predicateDaysInBillingPeriod = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"daysInBillingPeriod == %@",billingPeriodLength.text]];
    NSPredicate *predicateHoursWorked = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"hoursWorked == %@",hoursWorked.text]];
    NSPredicate *predicateJobDescription = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"jobDescription == '%@'",description]];
    NSPredicate *predicateJobTitle = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"jobTitle == '%@'",jobTitle]];
    NSPredicate *predicateMaximumHour = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"maximumHours == %@",maximumHours.text]];
    NSPredicate *predicateRate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"rate == '%@'",rate]];
    
    
    
    
    predicates = [[NSArray alloc] initWithObjects:predicateRate,predicateMaximumHour,predicateJobTitle,predicateJobDescription,predicateDaysInBillingPeriod,predicateHoursWorked, nil];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    [request setPredicate:compoundPredicate];
    
    // Set the sorting -- mandatory, even if you're fetching a single record/object
    NSSortDescriptor *sortDaysInBillingPeriod = [[NSSortDescriptor alloc] initWithKey:@"daysInBillingPeriod" ascending:YES];
    NSSortDescriptor *sortHoursWorked = [[NSSortDescriptor alloc] initWithKey:@"hoursWorked" ascending:YES];
    NSSortDescriptor *sortJobDescription = [[NSSortDescriptor alloc] initWithKey:@"jobDescription" ascending:YES];
    NSSortDescriptor *sortJobTitle = [[NSSortDescriptor alloc] initWithKey:@"jobTitle" ascending:YES];
    NSSortDescriptor *sortMaximumHours = [[NSSortDescriptor alloc] initWithKey:@"maximumHours" ascending:YES];
    NSSortDescriptor *sortRate = [[NSSortDescriptor alloc] initWithKey:@"rate" ascending:YES];

    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortRate,sortMaximumHours,sortJobTitle,sortJobDescription,sortHoursWorked,sortDaysInBillingPeriod, nil];
    [request setSortDescriptors:sortDescriptors];
    
    //Request the data -- NOTE, this assumes only one match, that 
    // yourIdentifyingQualifier is unique. It just grabs the first object in the array. 
    NSError *error; 
    //NSLog(@"%@", request);
    NSArray *jobs = [NSArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
    Task *thisTask = [jobs objectAtIndex:0];
    int rand = arc4random() % 7000;
    thisReminder.fireDate = [self setReminder:[[deadlineNumbers objectAtIndex:0] intValue] :[NSString stringWithFormat:@"%@ %d",jobTitle, rand]];
    thisReminder.notificationIdentifier = [NSString stringWithFormat:@"%@ %d",jobTitle,rand ];
    NSMutableSet *jobsYo = [NSMutableSet setWithSet:thisTask.reminder];
    [jobsYo addObject:thisReminder];
    [thisTask setReminder:[NSSet setWithSet:jobsYo]];
    if (![self.managedObjectContext save:&error]) {
        return;
    }
}

- (void) insertjobInfoIntoCoreDataExistingClient{

    Task *thisJob = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    
    
    
//    if (self.managedObjectContext == nil) {
//        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
//    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSArray *predicates;
    
    // Set the predicate
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"clientName == %@", existingClient.clientName];
    NSPredicate *predicateCompanyName = [NSPredicate predicateWithFormat:@"companyName == %@", existingClient.companyName];
    NSPredicate *predicateImg = [NSPredicate predicateWithFormat:@"imgPath == %@", existingClient.imgPath];
    
    
    predicates = [[NSArray alloc] initWithObjects:predicateName,predicateCompanyName,predicateImg, nil];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    [request setPredicate:compoundPredicate];
    
    // Set the sorting -- mandatory, even if you're fetching a single record/object
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clientName" ascending:YES];
    NSSortDescriptor *sortCompanyName = [[NSSortDescriptor alloc] initWithKey:@"companyName" ascending:YES];
    NSSortDescriptor *sortImg = [[NSSortDescriptor alloc] initWithKey:@"imgPath" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor,sortCompanyName,sortImg, nil];
    [request setSortDescriptors:sortDescriptors];
    sortDescriptors = nil;
    sortImg = nil;
    sortCompanyName = nil;
    sortNameDescriptor = nil;
    //Request the data -- NOTE, this assumes only one match, that 
    // yourIdentifyingQualifier is unique. It just grabs the first object in the array. 
    NSError *error; 
    //NSLog(@"%@", request);
    NSArray *companies = [NSArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
    Company *thisCompany = [companies objectAtIndex:0];
    
    if (deadlineNumbers.count > 0) {
        Reminder *thisReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.managedObjectContext];
        thisJob.jobTitle = jobTitle;
        thisJob.rate = rate;
        thisJob.startDate = startPicker.date;
        thisJob.jobDescription = description;
        thisJob.deadline = deadlinePicker.date;
        thisJob.billingPeriodEnd = [self billingPeriodEndCalculator:startPicker.date :[billingPeriodLength.text integerValue]];
        thisJob.numHoursToAdd = 0;
        thisJob.nextHourAddDate = nil;
        thisJob.hourScheduleNumDays = 0;
        thisJob.maximumHours = [NSNumber numberWithDouble:[maximumHours.text doubleValue]];
        thisJob.billingPeriodEnd = [self billingPeriodEndCalculator:startPicker.date :[billingPeriodLength.text integerValue]];

        thisJob.hoursWorked = [NSNumber numberWithDouble:[hoursWorked.text doubleValue]];
        thisJob.daysInBillingPeriod = [NSNumber numberWithDouble:[billingPeriodLength.text doubleValue]];
        [thisJob setReminder:[NSSet setWithObject:thisReminder]];
        NSMutableSet *jobsYo = [NSMutableSet setWithSet:thisCompany.job];
        [jobsYo addObject:thisJob];
        [thisCompany setJob:[NSSet setWithSet:jobsYo]];
        int rand = arc4random() % 7000;
        thisReminder.fireDate = [self setReminder:[[deadlineNumbers objectAtIndex:0] intValue] :[NSString stringWithFormat:@"%@ %d",jobTitle, rand]];
        thisReminder.notificationIdentifier = [NSString stringWithFormat:@"%@ %d",jobTitle,rand ];
        
        if (![self.managedObjectContext save:&error]) {
            return;
        }
    }else{
        thisJob.jobTitle = jobTitle;
        thisJob.rate = rate;
        thisJob.startDate = startPicker.date;
        thisJob.jobDescription = description;
        thisJob.deadline = deadlinePicker.date;
        thisJob.billingPeriodEnd = [self billingPeriodEndCalculator:startPicker.date :[billingPeriodLength.text integerValue]];
        thisJob.numHoursToAdd = 0;
        thisJob.nextHourAddDate = nil;
        thisJob.hourScheduleNumDays = 0;
        thisJob.maximumHours = [NSNumber numberWithDouble:[maximumHours.text doubleValue]];
        thisJob.hoursWorked = [NSNumber numberWithDouble:[hoursWorked.text doubleValue]];
        thisJob.billingPeriodEnd = [self billingPeriodEndCalculator:startPicker.date :[billingPeriodLength.text integerValue]];

        thisJob.daysInBillingPeriod = [NSNumber numberWithDouble:[billingPeriodLength.text doubleValue]];
        [thisJob setReminder:nil];
        NSMutableSet *jobsYo = [NSMutableSet setWithSet:thisCompany.job];
        [jobsYo addObject:thisJob];
        [thisCompany setJob:[NSSet setWithSet:jobsYo]];
        
        
        if (![self.managedObjectContext save:&error]) {
            return;
        }
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toClientTableSegue"]){
        ClientTableViewController *ctvc = (ClientTableViewController*)segue.destinationViewController;
        ctvc.delegate = self;
    }else if([[segue identifier] isEqualToString:@"toDeadlineReminderSegue"]){
        DeadlineReminderViewController *drvc = (DeadlineReminderViewController*)segue.destinationViewController;
        drvc.delegate = self;
    }
    
}

-(void)saveNumber:(NSNumber*)aNumber{
    
    [deadlineNumbers addObject:aNumber];
}

-(NSDate*) billingPeriodEndCalculator: (NSDate*)start: (NSInteger)numDays{
    numDays = numDays * 24 * 60 * 60;
    
    
    
    return [NSDate dateWithTimeInterval:numDays sinceDate:start];
}

-(void)setClientDelegate:(Company *)thisClient{
    existingClient = thisClient;
    NSLog(@"client name = %@",existingClient.clientName);
    NSLog(@"company = %@",existingClient.companyName);
    clientSet = YES;
    [clientButton setBackgroundColor:[UIColor whiteColor]];
    [clientButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clientButton setTitle:@"Set!" forState:UIControlStateNormal];
    clientButton.layer.borderColor = [[UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f] CGColor];
}


@end
