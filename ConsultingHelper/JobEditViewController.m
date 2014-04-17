//
//  JobEditViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobEditViewController.h"

@interface JobEditViewController (){
    NSMutableArray *reminders;
    NSInteger selectedTag;
    NSDate *newStartDate;
    NSDate *newDeadline;
    UIActionSheet *actionSheet;
}

@end

@implementation JobEditViewController
@synthesize txtJobTitle;
@synthesize txtJobDescription;
@synthesize txtRate;
@synthesize selectedTask;
@synthesize englishStart;
@synthesize englishDeadline;
@synthesize startDateButton;
@synthesize scrollView;
@synthesize deadlineDateButton;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        reminders = [[NSMutableArray alloc] initWithCapacity:selectedTask.reminder.count];
    }
    return self;
}

-(void) dismissActionSheet{
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    txtJobDescription.layer.cornerRadius = 5;
    txtJobDescription.clipsToBounds = YES;
    UIColor *color = [[UIColor alloc] initWithRed:(238/255.f) green:(205/255.f) blue:(116/255.f) alpha:1.0f];
    txtJobDescription.text = selectedTask.jobDescription;
    txtJobTitle.text = selectedTask.jobTitle;
    txtRate.text = selectedTask.rate;
    [startDateButton setTitle:[NSString stringWithFormat:@"%@ Edit ->",englishStart] forState:UIControlStateNormal];
    [deadlineDateButton setTitle:[NSString stringWithFormat:@"%@ Edit ->",englishDeadline] forState:UIControlStateNormal];
    
    
    txtJobTitle.backgroundColor = color;
    txtJobDescription.backgroundColor = color;
    txtRate.backgroundColor = color;
	double currentY = 348;
    if(selectedTask.reminder.count > 0){
        int i = 0;
        for(Reminder *thisReminder in selectedTask.reminder){
            [reminders addObject:thisReminder];
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            aButton.frame = CGRectMake(25, currentY, 270, 37);
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:thisReminder.fireDate];
            [aButton setTitle:[NSString stringWithFormat:@"%d/%d/%d Edit ->",[components month],[components day],[components year]] forState:UIControlStateNormal];
            [aButton addTarget:self action:@selector(reminderSelect:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:aButton];
            [aButton setTag:100+i];
            if(aButton.frame.origin.y + aButton.frame.size.height + 20 > 480){
                [scrollView setContentSize:CGSizeMake(320, aButton.frame.origin.y + aButton.frame.size.height + 20)];
            }
            currentY = currentY + 40;
            i++;
        }
    }else{
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame = CGRectMake(25, currentY, 270, 37);
        [aButton setTitle:@"No Reminders, Click to Add" forState:UIControlStateNormal];
        [scrollView addSubview:aButton];
        currentY = currentY + 40;

    }
    
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTxtJobTitle:nil];
    [self setTxtJobDescription:nil];
    [self setTxtRate:nil];
    [self setStartDateButton:nil];
    [self setDeadlineDateButton:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == txtRate){
        if(![self checkNumbers:txtRate.text]){
            txtRate.text = @"";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Must Be a Number" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)reminderSelect:(id)sender{
    UIButton *button = (UIButton*)sender;
    selectedTag = button.tag;
    [self performSegueWithIdentifier:@"newReminderSegue" sender:self];
}

-(void)newDate:(NSDate *)aDate :(NSString *)instruct{
    if([instruct isEqualToString:@"Enter new Start Date"]){
        newStartDate = aDate;
    }else if([instruct isEqualToString:@"Enter new Deadline"]){
        newDeadline = aDate;
        
    }else{
        int a = selectedTag - 100;
        Reminder *changedReminder = [reminders objectAtIndex:a];
        changedReminder.fireDate = aDate;
        UIButton *reminderButton = (UIButton*)[self.view viewWithTag:selectedTag];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:aDate];
        [reminderButton setTitle:[NSString stringWithFormat:@"Start Date: %d/%d/%d",[components month],[components day],[components year]] forState:UIControlStateNormal];
    }
}

-(void)saveReminderChanges:(NSInteger)i{
    Reminder *thisReminder = [reminders objectAtIndex:i];
    
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSArray *predicates;
    
    NSPredicate *predicatenotificationIdentifier = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"notificationIdentifier == '%@'",thisReminder.notificationIdentifier]];
    predicates = [[NSArray alloc] initWithObjects:predicatenotificationIdentifier, nil];
    
    NSSortDescriptor *sortnotificationIdentifier = [[NSSortDescriptor alloc] initWithKey:@"notificationIdentifier" ascending:YES];
    
    
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortnotificationIdentifier, nil];
    [request setSortDescriptors:sortDescriptors];
    
    //Request the data -- NOTE, this assumes only one match, that
    // yourIdentifyingQualifier is unique. It just grabs the first object in the array.
    NSError *error;
    //NSLog(@"%@", request);
    NSArray *theseReminders = [NSArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    Reminder *aReminder = [theseReminders objectAtIndex:0];
    aReminder.fireDate = thisReminder.fireDate;
    
    if (![self.managedObjectContext save:&error]) {
        return;
    }
    
}

-(void)saveJobChanges{
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSArray *predicates;
    
    // Set the predicate
    NSPredicate *predicateDaysInBillingPeriod = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"daysInBillingPeriod == %@",selectedTask.daysInBillingPeriod]];
    NSPredicate *predicateHoursWorked = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"hoursWorked == %@",selectedTask.hoursWorked]];
    NSPredicate *predicateJobDescription = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"jobDescription == '%@'",selectedTask.jobDescription]];
    NSPredicate *predicateJobTitle = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"jobTitle == '%@'",selectedTask.jobTitle]];
    NSPredicate *predicateMaximumHour = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"maximumHours == %@",selectedTask.maximumHours]];
    NSPredicate *predicateRate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"rate == '%@'",selectedTask.rate]];
    
    
    
    
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
    NSArray *jobs = [NSArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    Task *newTask = [jobs objectAtIndex:0];
    newTask.jobTitle = txtJobTitle.text;
    newTask.jobDescription = txtJobDescription.text;
    newTask.rate = txtRate.text;
    if(newStartDate){
        newTask.startDate = newStartDate;
    }
    if(newDeadline){
        newTask.deadline = newDeadline;
    }
    
    
    if (![self.managedObjectContext save:&error]) {
        return;
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

- (IBAction)saveButton:(id)sender {
    if(txtJobTitle.text == @"" || txtJobDescription.text == @"" || txtRate.text == @""){
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please Fill All Fields" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self performSelector:@selector(dismissActionSheet) withObject:nil afterDelay:3.0];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }else{
        [self saveJobChanges];
        for(int i = 0; i < reminders.count ; i++){
            [self saveReminderChanges:i];
        }
    }
    
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)CancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DateEditViewController *devc = (DateEditViewController*)segue.destinationViewController;
    devc.delegate = self;
    
    if([[segue identifier] isEqualToString:@"newStartSegue"]){
        devc.instructString = @"Enter new Start Date";
        devc.previousDate = selectedTask.startDate;
    }else if([[segue identifier] isEqualToString:@"newDeadlineSegue"]){
        devc.instructString = @"Enter new Deadline";
        devc.previousDate = selectedTask.deadline;
    }else{
        devc.instructString = @"Enter new Reminder Time";
        int a = selectedTag - 100;
        devc.previousDate = [[reminders objectAtIndex:a] fireDate];
    }
    
}
@end
