//
//  ClientDetailViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClientDetailViewController.h"

@interface ClientDetailViewController (){
    Task *selectedTask;
    UIAlertView *alertView;
}

@end

@implementation ClientDetailViewController
@synthesize clientNameButtonOutlet;
@synthesize companyNameButtonOutlet;
@synthesize phoneNumberButtonOutlet;
@synthesize imgProfilePic;

@synthesize taskSegmentedControl;
@synthesize taskContentScrollView;
@synthesize client;
@synthesize clientPic;
@synthesize lblTotalHours;
@synthesize lblHoursWorked;
@synthesize lblHoursTotalWritten;
@synthesize lblJobDescription;
@synthesize lblStartDate;
@synthesize lblDeadline;
@synthesize imgDeadlineClose;
@synthesize managedObjectContext;
@synthesize scrollView;
@synthesize imgRightArrow;
@synthesize imgLeftArrow;
@synthesize lblMoneyEarned;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toJobEditSegue"]){
        JobEditViewController *jevc = (JobEditViewController*)segue.destinationViewController;
        jevc.selectedTask = selectedTask;
        jevc.englishStart = lblStartDate.text;
        jevc.englishDeadline = lblDeadline.text;
    }else if([[segue identifier] isEqualToString:@"toIncrementHourSegue"]){
        IncrementHoursViewController *ihvc = (IncrementHoursViewController*)segue.destinationViewController;
        ihvc.selectedTask = selectedTask;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [self viewDidLoad];
    imgLeftArrow.transform = CGAffineTransformMakeRotation(3.14159265);
}

-(void)scrollViewDidScroll:(UIScrollView *)thisScrollView{
    float scrollViewWidth = thisScrollView.frame.size.width;
    float scrollContentSizeWidth = thisScrollView.contentSize.width;
    float scrollOffset = thisScrollView.contentOffset.x;
    
    if (scrollOffset == 0)
    {
        imgLeftArrow.hidden = YES;
        if(thisScrollView.contentSize.width >110){
            imgRightArrow.hidden = NO;
        }else{
            imgRightArrow.hidden = YES;
        }
    }
    else if (scrollOffset + scrollViewWidth == scrollContentSizeWidth)
    {
        imgRightArrow.hidden = YES;
        if(thisScrollView.contentSize.width >110){
            imgLeftArrow.hidden = NO;
        }else{
            imgLeftArrow.hidden = YES;
        }
    }else{
        imgRightArrow.hidden = NO;
        imgLeftArrow.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    clientNameButtonOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    companyNameButtonOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    phoneNumberButtonOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;


    [clientNameButtonOutlet setTitle:client.clientName forState:UIControlStateNormal];
    [companyNameButtonOutlet setTitle:client.companyName forState:UIControlStateNormal];
    [phoneNumberButtonOutlet setTitle:client.phoneNumber forState:UIControlStateNormal];
    imgProfilePic.image = clientPic;
    NSSet *setTasks = client.job;

    UIScrollView *scrollViewToRemove = (UIScrollView*)[self.view viewWithTag:999];
    for(UIView* v in scrollViewToRemove.subviews){
        [v removeFromSuperview];
    }
    [scrollViewToRemove removeFromSuperview];
    
    if(client.job.count > 1){
        UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        [self.view addSubview:wrapperView];
        UIScrollView *ascrollView = [[UIScrollView alloc] initWithFrame:wrapperView.bounds];
        [ascrollView setTag:999];
        [wrapperView addSubview:ascrollView];
        ascrollView.delegate = self;
        [ascrollView setContentSize:CGSizeMake(client.job.count*90, 40)];
        double currentX = ascrollView.frame.origin.x;
        double currentY = ascrollView.frame.origin.y;
        double buttonCounter = 100;
        for(Task *thisTask in setTasks){
            NSLog(@"in a task %@", thisTask.jobTitle);
            NSLog(@"numReminders = %d",thisTask.reminder.count);

            currentX = [self presentData:thisTask :currentX :currentY :buttonCounter :ascrollView];
            UIButton *thisButton = (UIButton*)[self.view viewWithTag:buttonCounter];
            NSLog(@"width %f",thisButton.frame.origin.x + thisButton.frame.size.width);
            [ascrollView setContentSize:CGSizeMake(thisButton.frame.origin.x + thisButton.frame.size.width, 40)];
            if(ascrollView.contentSize.width > ascrollView.bounds.size.width){
                imgRightArrow.hidden = NO;
            }
            buttonCounter ++;
        }
        
        
        
        
    }else{
        
        UIScrollView *ascrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        [ascrollView setTag:999];
        [self.view addSubview:ascrollView];
        for(Task *thisTask in setTasks){
            selectedTask = thisTask;
            NSLog(@"numReminders = %d",selectedTask.reminder.count);
            lblTotalHours.backgroundColor = [UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f]; 
            lblTotalHours.layer.cornerRadius = 10;
            double ratio = [thisTask.hoursWorked doubleValue]/[thisTask.maximumHours doubleValue];
            NSString *ratioString = [NSString stringWithFormat:@"%f",ratio*100];
            NSLog(@"%@",ratioString);
            
            lblHoursWorked.backgroundColor = [UIColor colorWithRed:(185/255.f) green:(100/255.f) blue:(100/255.f) alpha:1.0f];
            lblHoursWorked.layer.cornerRadius = 10;
            NSLog(@"descript : %@",thisTask.jobDescription);
            
            lblJobDescription.text = thisTask.jobDescription;
            lblJobDescription.frame = CGRectMake(lblJobDescription.frame.origin.x, lblJobDescription.frame.origin.y, 280, 0);
            lblJobDescription.lineBreakMode = UILineBreakModeWordWrap;
            lblJobDescription.numberOfLines = 0;
            [lblJobDescription sizeToFit];
            [scrollView setContentSize:CGSizeMake(280, lblJobDescription.frame.size.height)];
            NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:thisTask.startDate];
            NSDateComponents *deadlineComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:thisTask.deadline];
            NSTimeInterval todayDiff = [[NSDate date] timeIntervalSinceNow];
            NSTimeInterval deadlineDiff = [thisTask.deadline timeIntervalSinceNow];
            NSTimeInterval dateDiff = deadlineDiff - todayDiff;
            if(dateDiff/86400 < 7){
                imgDeadlineClose.hidden = NO;
            }else{
                imgDeadlineClose.hidden = YES;
            }
            lblStartDate.text = [NSString stringWithFormat:@"Start Date: %d/%d/%d",[startComponents month],[startComponents day],[startComponents year]];
            lblDeadline.text = [NSString stringWithFormat:@"Deadline: %d/%d/%d",[deadlineComponents month],[deadlineComponents day],[deadlineComponents year]];
            lblMoneyEarned.text = [NSString stringWithFormat:@"$%.2f",[thisTask.rate doubleValue]*[thisTask.hoursWorked doubleValue]];

            [UIView animateWithDuration:.2
                             animations:^{
                                 CGRect offsetFrame = lblHoursWorked.frame;
                                 offsetFrame.size.width = 5;
                                 lblHoursWorked.frame = CGRectOffset(offsetFrame, 0, 0);
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:2.0 animations:^{
                                     CGRect offsetFrame = lblHoursWorked.frame;
                                     offsetFrame.size.width = lblTotalHours.frame.size.width*ratio;
                                     lblHoursWorked.frame = CGRectOffset(offsetFrame, 0, 0);
                                 }];
                                 
                             }];
            
            
        }
    }
	// Do any additional setup after loading the view.
}

-(IBAction)taskSelect:(id)sender{
    
    for(int i = 0; i < client.job.count; i++){
        UIButton *thisButton = (UIButton*)[self.view viewWithTag:100+i];
        [thisButton setBackgroundColor:[UIColor whiteColor]];
        [thisButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *selected = (UIButton*)sender;
    [selected setBackgroundColor:[UIColor blackColor]];
    [selected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    NSSet *theTaskWeWant = [client.job objectsPassingTest:^(id obj,BOOL *stop){
        Task *so = (Task *)obj;
        
        // accept objects less or equal to two
        BOOL r = [so.jobTitle isEqualToString:selected.titleLabel.text];
        return r;
    }];
    for(Task *ermergerd in theTaskWeWant){
        selectedTask = ermergerd;    
        [self changeTaskData:ermergerd];
    }
}

- (void)viewDidUnload
{
    [self setImgProfilePic:nil];
    [self setTaskSegmentedControl:nil];
    [self setTaskContentScrollView:nil];
    [self setLblTotalHours:nil];
    [self setLblHoursWorked:nil];
    [self setLblHoursTotalWritten:nil];
    [self setLblJobDescription:nil];
    [self setLblStartDate:nil];
    [self setLblDeadline:nil];
    [self setImgDeadlineClose:nil];
    [self setScrollView:nil];
    [self setImgRightArrow:nil];
    [self setImgLeftArrow:nil];
    [self setLblMoneyEarned:nil];
    [self setClientNameButtonOutlet:nil];
    [self setCompanyNameButtonOutlet:nil];
    [self setPhoneNumberButtonOutlet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)changeTaskData: (Task*)aTask{
    lblTotalHours.backgroundColor = [UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f]; 
    lblTotalHours.layer.cornerRadius = 10;
    double ratio = [aTask.hoursWorked doubleValue]/[aTask.maximumHours doubleValue];
    NSString *ratioString = [NSString stringWithFormat:@"%f",ratio*100];
    NSLog(@"%@",ratioString);
    
    
    

    [self.view reloadInputViews];
    lblHoursWorked.backgroundColor = [UIColor colorWithRed:(185/255.f) green:(100/255.f) blue:(100/255.f) alpha:1.0f];
    lblHoursWorked.layer.cornerRadius = 10;
    lblHoursTotalWritten.text = [NSString stringWithFormat:@"%@ / %@ hours",aTask.hoursWorked,aTask.maximumHours];
    NSLog(@"descript : %@",aTask.jobDescription);
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:aTask.startDate];
    NSDateComponents *deadlineComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:aTask.deadline];
    NSTimeInterval todayDiff = [[NSDate date] timeIntervalSinceNow];
    NSTimeInterval deadlineDiff = [aTask.deadline timeIntervalSinceNow];
    NSTimeInterval dateDiff = deadlineDiff - todayDiff;
    if(dateDiff/86400 < 7){
        imgDeadlineClose.hidden = NO;
    }else{
        imgDeadlineClose.hidden = YES;
    }
    lblStartDate.text = [NSString stringWithFormat:@"Start Date: %d/%d/%d",[startComponents month],[startComponents day],[startComponents year]];
    lblDeadline.text = [NSString stringWithFormat:@"Deadline: %d/%d/%d",[deadlineComponents month],[deadlineComponents day],[deadlineComponents year]];
    
    lblJobDescription.text = aTask.jobDescription;
    lblJobDescription.frame = CGRectMake(lblJobDescription.frame.origin.x, lblJobDescription.frame.origin.y, 280, 0);
    lblJobDescription.lineBreakMode = UILineBreakModeWordWrap;
    lblJobDescription.numberOfLines = 0;
    [lblJobDescription sizeToFit];
    [scrollView setContentSize:CGSizeMake(320, lblJobDescription.frame.size.height)];

    lblMoneyEarned.text = [NSString stringWithFormat:@"$%.2f",[aTask.rate doubleValue]*[aTask.hoursWorked doubleValue]];

    [UIView animateWithDuration:.2
                     animations:^{
                         CGRect offsetFrame = lblHoursWorked.frame;
                         offsetFrame.size.width = 5;
                         lblHoursWorked.frame = CGRectOffset(offsetFrame, 0, 0);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:2.0 animations:^{
                             CGRect offsetFrame = lblHoursWorked.frame;
                             offsetFrame.size.width = lblTotalHours.frame.size.width*ratio;
                             lblHoursWorked.frame = CGRectOffset(offsetFrame, 0, 0);
                         }];
                         
                     }];
}

-(double)presentData: (Task*)aTask :(double)x :(double) y: (double)buttonCounter :(UIScrollView*)theScrollView{
    UIButton *taskButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 80, 40)];
    taskButton.layer.cornerRadius = 5;
    taskButton.clipsToBounds = YES;
    [taskButton setBackgroundColor:[UIColor whiteColor]];
    [taskButton.layer setBorderWidth:2.0];
    [taskButton setTag:buttonCounter];
    [taskButton addTarget:self action:@selector(taskSelect:) forControlEvents:UIControlEventTouchUpInside];
    [taskButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [taskButton setTitle:aTask.jobTitle forState:UIControlStateNormal];
    [taskButton sizeToFit];
    CGRect buttonFrame = taskButton.frame;
    buttonFrame.size.height = 40;
    buttonFrame.size.width = buttonFrame.size.width + 5;
    taskButton.frame = buttonFrame;
    [theScrollView addSubview:taskButton];
    x = x + taskButton.frame.size.width + 10;
    if(buttonCounter == 100){
        selectedTask = aTask;
        [taskButton setBackgroundColor:[UIColor blackColor]];
        [taskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblTotalHours.backgroundColor = [UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f]; 
        lblTotalHours.layer.cornerRadius = 10;
        double ratio = [aTask.hoursWorked doubleValue]/[aTask.maximumHours doubleValue];
        NSString *ratioString = [NSString stringWithFormat:@"%f",ratio*100];
        NSLog(@"%@",ratioString);
        
        lblHoursWorked.backgroundColor = [UIColor colorWithRed:(185/255.f) green:(100/255.f) blue:(100/255.f) alpha:1.0f];
        lblHoursWorked.layer.cornerRadius = 10;
        lblHoursTotalWritten.text = [NSString stringWithFormat:@"%@ / %@ hours",aTask.hoursWorked,aTask.maximumHours];
        NSLog(@"descript : %@",aTask.jobDescription);
        lblJobDescription.text = aTask.jobDescription;
        lblJobDescription.frame = CGRectMake(lblJobDescription.frame.origin.x, lblJobDescription.frame.origin.y, 280, 0);
        lblJobDescription.lineBreakMode = UILineBreakModeWordWrap;
        lblJobDescription.numberOfLines = 0;
        [lblJobDescription sizeToFit];
        [scrollView setContentSize:CGSizeMake(320, lblJobDescription.frame.size.height)];

        NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:aTask.startDate];
        NSDateComponents *deadlineComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:aTask.deadline];
        NSTimeInterval todayDiff = [[NSDate date] timeIntervalSinceNow];
        NSTimeInterval deadlineDiff = [aTask.deadline timeIntervalSinceNow];
        NSTimeInterval dateDiff = deadlineDiff - todayDiff;
        if(dateDiff/86400 < 7){
            imgDeadlineClose.hidden = NO;
        }else{
            imgDeadlineClose.hidden = YES;
        }
        lblStartDate.text = [NSString stringWithFormat:@"Start Date: %d/%d/%d",[startComponents month],[startComponents day],[startComponents year]];
        lblDeadline.text = [NSString stringWithFormat:@"Deadline: %d/%d/%d",[deadlineComponents month],[deadlineComponents day],[deadlineComponents year]];
        lblMoneyEarned.text = [NSString stringWithFormat:@"$%.2f",[aTask.rate doubleValue]*[aTask.hoursWorked doubleValue]];
        
        
        [UIView animateWithDuration:.2
                         animations:^{
                             CGRect offsetFrame = lblHoursWorked.frame;
                             offsetFrame.size.width = 5;
                             lblHoursWorked.frame = CGRectOffset(offsetFrame, 0, 0);
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:2.0 animations:^{
                                 CGRect offsetFrame = lblHoursWorked.frame;
                                 offsetFrame.size.width = lblTotalHours.frame.size.width*ratio;
                                 lblHoursWorked.frame = CGRectOffset(offsetFrame, 0, 0);
                             }];
                             
                         }];
    }
    
    return x;
}


- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)editButton:(id)sender {
}

- (IBAction)deleteButton:(id)sender {
    if(client.job.count > 1){
        alertView = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:[NSString stringWithFormat:@"Delete %@ Job?",selectedTask.jobTitle]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }else{
        alertView = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:[NSString stringWithFormat:@"Delete %@ Job and %@ Client?",selectedTask.jobTitle,client.clientName]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)thisAlertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{
    if(thisAlertView == alertView){
        if(buttonIndex == 1)
        {
            if(client.job.count > 1){
                
                for(Reminder *aReminder in selectedTask.reminder){
                    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        UILocalNotification *notification = (UILocalNotification *)obj;
                        NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
                        
                        NSString *notificationID = [userInfo valueForKey:@"notificationID"];
                        NSLog(@"id %@",notificationID);
                        NSLog(@"nI %@",aReminder.notificationIdentifier);
                        if ([notificationID isEqualToString:aReminder.notificationIdentifier])
                        {
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                            *stop = YES;
                        }
                    }];
                }
                
                
                [managedObjectContext deleteObject:selectedTask];
                
                NSError *error;
                [self.managedObjectContext save:&error];
                
                
                [self dismissModalViewControllerAnimated:YES]; 
            }else{
                Company *companyToDelete = selectedTask.client;
                for(Task *aTask in companyToDelete.job){
                    for(Reminder *aReminder in aTask.reminder){
                        [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            
                            UILocalNotification *notification = (UILocalNotification *)obj;
                            NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
                            
                            NSString *notificationID = [userInfo valueForKey:@"notificationID"];
                            NSLog(@"id %@",notificationID);
                            NSLog(@"nI %@",aReminder.notificationIdentifier);
                            if ([notificationID isEqualToString:aReminder.notificationIdentifier])
                            {
                                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                                *stop = YES;
                            }
                        }];
                    }
                }
                
                [managedObjectContext deleteObject:companyToDelete];

                NSError *error;
                [self.managedObjectContext save:&error];
                
                
                [self dismissModalViewControllerAnimated:YES];
            }
            
        }
    }
}




- (IBAction)infoShow:(id)sender {
    alertView = [[UIAlertView alloc] initWithTitle:@"Help" message:@"Click Edit Job to edit the deadline, to edit the job title, description, or rate, to see scheduled reminders, or to edit scheduled reminders.  Click delete job to delete the currently displayed job. If you only have one job with this client, the client will be deleted as well." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(IBAction)textSelect:(id)sender{
    MFMessageComposeViewController *sendSMS = [[MFMessageComposeViewController alloc] init];
    sendSMS.delegate = self;
    sendSMS.recipients = [NSArray arrayWithObject:selectedTask.client.phoneNumber];
    [self presentModalViewController:sendSMS animated:YES];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case 0:
            alertView = [[UIAlertView alloc] initWithTitle:@"Message Cancelled" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [self dismissModalViewControllerAnimated:YES];

            break;
        case 1:
            alertView = [[UIAlertView alloc] initWithTitle:@"Message Sent" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [self dismissModalViewControllerAnimated:YES];

            break;
        case 2:
            alertView = [[UIAlertView alloc] initWithTitle:@"Message Failed To Send, Check Network Availability" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [self dismissModalViewControllerAnimated:YES];

            break;
        default:
            [self dismissModalViewControllerAnimated:YES];

            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)callSelect:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",selectedTask.client.phoneNumber]]];

}

-(IBAction)cancelContactSelect:(id)sender{
    for (UIView *v in self.view.subviews){
        if(v.userInteractionEnabled == YES){
            [v removeFromSuperview];
        }else{
            v.userInteractionEnabled = YES;
            [v setAlpha:1.0];
        }
        
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

- (IBAction)clientEdit:(id)sender {
}

- (IBAction)contactButton:(id)sender {
    for(UIView *v in self.view.subviews){
        v.userInteractionEnabled = NO;
        [v setAlpha:.5];
    }
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    textButton.frame = CGRectMake(20, 440, 280, 40);
    [textButton setTitle:@"Text Message" forState:UIControlStateNormal];
    [textButton addTarget:self action:@selector(textSelect:) forControlEvents:UIControlEventTouchUpInside];
    [textButton setAlpha:1.0];
    [self.view addSubview:textButton];
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callButton.frame = CGRectMake(20, 440, 280, 40);
    [callButton setTitle:@"Phone Call" forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(callSelect:) forControlEvents:UIControlEventTouchUpInside];
    [callButton setAlpha:1.0];
    [self.view addSubview:callButton];
    
    UIButton *cancelContactButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelContactButton.frame = CGRectMake(20, 440, 280, 40);
    [cancelContactButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelContactButton addTarget:self action:@selector(cancelContactSelect:) forControlEvents:UIControlEventTouchUpInside];
    [cancelContactButton setAlpha:1.0];
    [self.view addSubview:cancelContactButton];
    
    [UIView animateWithDuration:.5
                     animations:^{
                         CGRect offsetFrame = CGRectMake(20, 50, 280, 40);
                         textButton.frame = CGRectOffset(offsetFrame, 0, 0);
                    }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:.5 animations:^{
                             CGRect offsetFrame = CGRectMake(20, 100, 280, 40);
                             callButton.frame = CGRectOffset(offsetFrame, 0, 0);
                         }completion:^(BOOL finished){
                             [UIView animateWithDuration:.5 animations:^{
                                 CGRect offsetFrame = CGRectMake(20, 150, 280, 40);
                                 cancelContactButton.frame = CGRectOffset(offsetFrame, 0, 0);
                             }];
                         }];
                         
                     }];
}
@end
