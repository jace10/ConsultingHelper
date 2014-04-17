//
//  IncrementHoursViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IncrementHoursViewController.h"

@interface IncrementHoursViewController (){
    BOOL expanded;
    BOOL oneTime;
    BOOL scheduled;
    UIActionSheet *actionSheet;
}
    
@end

@implementation IncrementHoursViewController
@synthesize lblSchedule;
@synthesize txtNumHours;
@synthesize txtNumDays;
@synthesize lblHourChange;
@synthesize doneButton;
@synthesize selectedTask;
@synthesize managedObjectContext;
@synthesize cancelButtonOutlet;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(![selectedTask.numHoursToAdd doubleValue] == 0){
        lblSchedule.hidden = NO;
        lblSchedule.text = [NSString stringWithFormat:@"Currently Scheduled to Add %.1f hours every %d days",[selectedTask.numHoursToAdd doubleValue],[selectedTask.hourScheduleNumDays integerValue]];
    }
    oneTime = NO;
    scheduled = NO;
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    expanded = NO;
    [doneButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [doneButton.layer setBorderWidth:2];
    [cancelButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cancelButtonOutlet.layer setBorderWidth:2];
    lblHourChange.text = [NSString stringWithFormat:@"%.1f -> %.1f",[selectedTask.hoursWorked doubleValue],[selectedTask.hoursWorked doubleValue]];
    UIButton *selectAMethod = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 220, 30)];
    [self.view addSubview:selectAMethod];
    [selectAMethod setBackgroundColor:[UIColor whiteColor]];
    [selectAMethod setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectAMethod.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [selectAMethod.titleLabel setTextAlignment:UITextAlignmentCenter];
    [selectAMethod setTitle:@"Select a Method" forState:UIControlStateNormal];
    [selectAMethod addTarget:self action:@selector(methodSelect:) forControlEvents:UIControlEventTouchUpInside];
    selectAMethod.layer.cornerRadius = 5;
    selectAMethod.clipsToBounds = YES;
    
    UIButton *oneTimeButton = [[UIButton alloc] initWithFrame:selectAMethod.frame];
    [oneTimeButton setHidden:YES];
    [self.view addSubview:oneTimeButton];
    [oneTimeButton setBackgroundColor:[UIColor whiteColor]];
    [oneTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    oneTimeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [oneTimeButton setTag:500];
    [oneTimeButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [oneTimeButton setTitle:@"One Time Addition" forState:UIControlStateNormal];
    [oneTimeButton addTarget:self action:@selector(oneTimeSelect:) forControlEvents:UIControlEventTouchUpInside];
    oneTimeButton.layer.cornerRadius = 5;
    oneTimeButton.clipsToBounds = YES;
    
    UIButton *scheduleButton = [[UIButton alloc] initWithFrame:selectAMethod.frame];
    [scheduleButton setHidden:YES];
    [self.view addSubview:scheduleButton];
    [scheduleButton setTag:501];
    [scheduleButton setBackgroundColor:[UIColor whiteColor]];
    [scheduleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    scheduleButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [scheduleButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [scheduleButton setTitle:@"Schedule Regular Addition" forState:UIControlStateNormal];
    [scheduleButton addTarget:self action:@selector(scheduleSelect:) forControlEvents:UIControlEventTouchUpInside];
    scheduleButton.layer.cornerRadius = 5;
    scheduleButton.clipsToBounds = YES;
    
	// Do any additional setup after loading the view.
}

-(void) dismissActionSheet{
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)scheduleSelect:(id)sender{
    oneTime = NO;
    scheduled = YES;
    [self animateView:(UIButton*)[self.view viewWithTag:500] :expanded :-35];
    [self animateView:(UIButton*)[self.view viewWithTag:501] :expanded :-70];
    expanded = NO;
    if(![selectedTask.numHoursToAdd doubleValue] == 0){
        lblSchedule.hidden = NO;
        lblSchedule.text = [NSString stringWithFormat:@"Currently Scheduled to Add %.1f hours every %d days",[selectedTask.numHoursToAdd doubleValue],[selectedTask.hourScheduleNumDays integerValue]];
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"If You Save You Will Replace The Existing Incrementing Schedule. To Cancel the Existing Schedule, Save the Number of Hours to Add as 0" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self performSelector:@selector(dismissActionSheet) withObject:nil afterDelay:3.0];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    
    
    txtNumDays.hidden = NO;
    txtNumHours.hidden = NO;
}

-(IBAction)oneTimeSelect:(id)sender{
    scheduled = NO;
    oneTime = YES;
    [self animateView:(UIButton*)[self.view viewWithTag:500] :expanded :-35];
    [self animateView:(UIButton*)[self.view viewWithTag:501] :expanded :-70];
    expanded = NO;

    txtNumDays.hidden = YES;
    txtNumHours.hidden = NO;
}

-(IBAction)methodSelect:(id)sender{
    [self animateView:(UIButton*)[self.view viewWithTag:500] :expanded :-35];
    [self animateView:(UIButton*)[self.view viewWithTag:501] :expanded :-70];

    
    if(!expanded){
        expanded = YES;
    }else{
        expanded = NO;
    }
    
    txtNumDays.hidden = YES;
    txtNumHours.hidden = YES;
}

- (void)viewDidUnload
{
    [self setDoneButton:nil];
    [self setTxtNumHours:nil];
    [self setTxtNumDays:nil];
    [self setLblHourChange:nil];
    [self setCancelButtonOutlet:nil];
    [self setLblSchedule:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneAction:(id)sender {
    if(![self checkHourNumbers:txtNumHours.text] || ![self checkDayNumbers:txtNumDays.text]){
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Invalid Arguments, Hours Can Be Any Decimal, Days Must Be An Integer" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self performSelector:@selector(dismissActionSheet) withObject:nil afterDelay:3.0];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }else{
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
        if(oneTime){
            
            newTask.hoursWorked = [NSNumber numberWithDouble:[selectedTask.hoursWorked doubleValue] + [txtNumHours.text doubleValue]];
            
            
            if (![self.managedObjectContext save:&error]) {
                return;
            }
            
        }
        
        if(scheduled){
            newTask.hoursWorked = [NSNumber numberWithDouble:[selectedTask.hoursWorked doubleValue] + [txtNumHours.text doubleValue]];
            
            newTask.numHoursToAdd = [NSNumber numberWithDouble:[txtNumHours.text doubleValue]];
            newTask.hourScheduleNumDays = [NSNumber numberWithDouble:[txtNumDays.text doubleValue]];
            newTask.nextHourAddDate = [NSDate dateWithTimeInterval:[txtNumDays.text doubleValue]*24*60*60 sinceDate:[NSDate date]];
            
            if (![self.managedObjectContext save:&error]) {
                return;
            }
        }
        
        
        
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (void) animateView: (UIButton*) view : (BOOL) up : (NSInteger) distance
{
    if(!expanded){
        view.hidden = NO;
    }
    
    const int movementDistance = distance; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (!up ? -movementDistance : movementDistance);
    //NSLog(@"distance is %d", movement);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
    
    if(expanded){
        view.hidden = YES;
    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [doneButton setUserInteractionEnabled:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    
    
    if(textField == txtNumHours && [self checkHourNumbers:txtNumHours.text]){
        if([selectedTask.hoursWorked doubleValue],[selectedTask.hoursWorked doubleValue] + [txtNumHours.text doubleValue] > [selectedTask.maximumHours doubleValue]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"That Would Be Too Many Hours, Maximum For This Job is %.1f",[selectedTask.maximumHours doubleValue]] message:nil delegate:nil cancelButtonTitle:@"My Mistake" otherButtonTitles:nil, nil];
            [alertView show];
            txtNumHours.text = @"";
            
        }
        lblHourChange.text = [NSString stringWithFormat:@"%.1f -> %.1f",[selectedTask.hoursWorked doubleValue],[selectedTask.hoursWorked doubleValue] + [txtNumHours.text doubleValue]];
    }
    if(![self checkHourNumbers:txtNumHours.text]){
        txtNumHours.text = @"";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Must be Positive Number" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
    
    [doneButton setUserInteractionEnabled:YES];
    return YES;
}

-(BOOL) checkHourNumbers:(NSString*)number{
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

-(BOOL) checkDayNumbers:(NSString*)number{
    for(int i = 0 ; i < [number length]; i++){
        char c = [number characterAtIndex:i];
        if(!isdigit(c)){
            return NO;
        }
        
    }
    return YES;
}

- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
