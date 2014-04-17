//
//  CurrentJobsViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CurrentJobsViewController.h"

@interface CurrentJobsViewController ()

@end

@implementation CurrentJobsViewController{
    NSMutableArray *sortedJobs;
    NSMutableArray *jobs;
    NSMutableArray *clientPics;
    UIAlertView *alertView;
    NSInteger selectedRow;
    UIActionSheet *actionsheet;
}
@synthesize managedObjectContext;
@synthesize jobTable;
@synthesize tabChoice;

-(IBAction)punchCard:(id)sender{
    NSLog(@"Herp a derp");
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        tabChoice = @"";
        sortedJobs = [[NSMutableArray alloc] initWithCapacity:25];
        jobs = [[NSMutableArray alloc] initWithCapacity:25];
        clientPics = [[NSMutableArray alloc] initWithCapacity:[jobs count]];
    }
    return self;
}

-(void) dismissActionSheet{
    
    [actionsheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self.navigationController setNavigationBarHidden:NO];
    UILabel *old = (UILabel*)[self.navigationController.navigationBar viewWithTag:900];
    
    [old removeFromSuperview];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, self.navigationController.navigationBar.frame.size.height)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTag:900];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    titleLabel.text = @"Current Jobs";
    [self.navigationController.navigationBar addSubview:titleLabel];

    if(tabChoice.length > 0){
        
        [self.tabBarController setSelectedIndex:[tabChoice integerValue]];
    }
    
    [self fetchCoreData];
    clientPics = [[NSMutableArray alloc] initWithCapacity:[jobs count]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:jobTable animated:YES];
    hud.labelText = @"Loading";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [jobTable setUserInteractionEnabled:NO];
        [self performSelectorOnMainThread:@selector(fetchImage:) withObject:sortedJobs waitUntilDone:YES];
        [jobTable reloadData];
        [jobTable setUserInteractionEnabled:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:jobTable animated:YES];
        });
    });
    
    if(!([sortedJobs count] > 0)){
        jobTable.hidden = YES;
        UILabel *hiddenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
        [hiddenLabel setBackgroundColor:[UIColor clearColor]];
        [hiddenLabel setTextColor:[UIColor whiteColor]];
        [hiddenLabel setTextAlignment:UITextAlignmentCenter];
        [hiddenLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [hiddenLabel setText:@"You have no jobs at this time!"];
        [self.view addSubview:hiddenLabel];
        
        UIButton *buttonForDummies = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonForDummies.frame = CGRectMake(50, 200, 220, 70);
        [buttonForDummies setBackgroundColor:[UIColor colorWithRed:(135/255.f) green:(143/255.f) blue:(144/255.f) alpha:1.0f]];
        [buttonForDummies setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonForDummies.layer.cornerRadius = 10;
        buttonForDummies.clipsToBounds = YES;
        [buttonForDummies setTitle:@"Add New job" forState:UIControlStateNormal];
        [buttonForDummies addTarget:self action:@selector(newJobClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonForDummies];
    }else{
        if(tabChoice.length == 0){
            actionsheet = [[UIActionSheet alloc] initWithTitle:@"Clients Are Sorted By Proximity of Deadline, Then Number of Jobs, Then Total Rate" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
            actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [self performSelector:@selector(dismissActionSheet) withObject:nil afterDelay:3.0];
            [actionsheet showFromTabBar:self.tabBarController.tabBar];
        }
        
        for(UIView *v in [self.view subviews]){
            if(v == jobTable){
                v.hidden = NO;
            }else{
                [v removeFromSuperview];
            }
        }
    }
    
    [jobTable reloadData];
}

-(IBAction)newJobClick:(id)sender{
    NewJobViewController *njvc = [self.tabBarController.viewControllers objectAtIndex:1];
    njvc.tabChoice = @"";
    [self.tabBarController setSelectedIndex:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setJobTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated{
    NewJobViewController *njvc = (NewJobViewController*)[self.tabBarController.viewControllers objectAtIndex:1];
    njvc.tabChoice = @"";
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [sortedJobs count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toClientDetailSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toClientDetailSegue"]){
        ClientDetailViewController *cdvc = (ClientDetailViewController*)segue.destinationViewController;
        
        cdvc.client = [sortedJobs objectAtIndex:[[jobTable indexPathForSelectedRow] row]];
        cdvc.clientPic = [clientPics objectAtIndex:[[jobTable indexPathForSelectedRow] row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    Company *thisClient = [sortedJobs objectAtIndex:indexPath.row];
    NSSet *thisClientsJobs = thisClient.job;
    return 100 + (thisClientsJobs.count*60);
    
}

-(void)fetchImage: (NSMutableArray *)thisStuff{
    for(Company *c in thisStuff){
        if(![c.imgPath isEqualToString:@"null"]){
            UIImage *thisImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:c.imgPath]]];
            [clientPics addObject:thisImage];
        }else{
            if(c.localImage){
                UIImage *profilePic = [UIImage imageWithData:c.localImage];
                [clientPics addObject:profilePic];

            }else{
                [clientPics addObject:[UIImage imageNamed:@"shop_Man.png"]];
            }
        }
    }
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jobCell"];
    for(UIView *v in cell.subviews){
        if(v.tag >=500){
            [v removeFromSuperview];
        }
    }
    UIImageView *clientPic = (UIImageView*)[cell viewWithTag:1];
    UILabel *clientName = (UILabel*)[cell viewWithTag:2];
    UILabel *companyName = (UILabel*)[cell viewWithTag:3];
    UILabel *phoneNumber = (UILabel*)[cell viewWithTag:4];
    UILabel *total = (UILabel*)[cell viewWithTag:100];
    UILabel *lblPercent = (UILabel*)[cell viewWithTag:102];
    UILabel *hoursDone = (UILabel*)[cell viewWithTag:101];
    UILabel *lblJobTitle = (UILabel*)[cell viewWithTag:103];
    UILabel *lblDeadline = (UILabel*)[cell viewWithTag:104];
    Company *thisClient = [sortedJobs objectAtIndex:indexPath.row];
    clientName.text = thisClient.clientName;
    companyName.text = thisClient.companyName;
    phoneNumber.text = thisClient.phoneNumber;
    if(clientPics.count > 0){
        clientPic.image = [clientPics objectAtIndex:indexPath.row];
        
    }else{
        if(thisClient.localImage){
            UIImage *profilePic = [UIImage imageWithData:thisClient.localImage];
            clientPic.image = profilePic;
        }
    }
    total.backgroundColor = [UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f];
    total.layer.cornerRadius = 5;
    total.clipsToBounds = YES;
    double totalx = total.frame.size.width;
    NSSet *thisClientsJobs = thisClient.job;
    int count = 0;
    int amount = 60;
    for(Task *thisTask in thisClientsJobs){
        if(count > 0){
            
            CGRect labelFrame = total.frame;
            labelFrame.origin.y = labelFrame.origin.y + amount;
            CGRect percentFrame = lblPercent.frame;
            percentFrame.origin.y = percentFrame.origin.y + amount;
            CGRect hoursFrame = hoursDone.frame;
            hoursFrame.origin.y = hoursFrame.origin.y + amount;
            CGRect newTitle = lblJobTitle.frame;
            newTitle.origin.y = newTitle.origin.y + amount;
            CGRect newDeadline = lblDeadline.frame;
            newDeadline.origin.y = newDeadline.origin.y + amount;
            
            UILabel *newTotal = [[UILabel alloc] initWithFrame:labelFrame];
            newTotal.backgroundColor = [UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f];
            newTotal.layer.cornerRadius = 5;
            [newTotal setTag:500 + count];
            newTotal.clipsToBounds = YES;
            
            [cell addSubview:newTotal];
            
            UILabel *newPercent = [[UILabel alloc] initWithFrame:percentFrame];
            [newPercent setFont:[UIFont fontWithName:@"System" size:17]];
            [newPercent setTag:501+count];
            [cell addSubview:newPercent];
            
            double ratio = [thisTask.hoursWorked doubleValue]/[thisTask.maximumHours doubleValue];
            NSString *ratioString = [NSString stringWithFormat:@"%f",ratio*100];
            NSLog(@"%@",ratioString);
            if(ratio*100 == 100){
                newPercent.text = [NSString stringWithFormat:@"%@%@",[ratioString substringToIndex:3],@"%"];
            }else if (ratio* 100 >= 10){
                newPercent.text = [NSString stringWithFormat:@"%@%@",[ratioString substringToIndex:2],@"%"];
                
            }else{
                newPercent.text = [NSString stringWithFormat:@"%@%@",[ratioString substringToIndex:1],@"%"];
                
            }
            
            UILabel *newHours = [[UILabel alloc] initWithFrame:hoursFrame];
            newHours.backgroundColor = [UIColor colorWithRed:(185/255.f) green:(100/255.f) blue:(100/255.f) alpha:1.0f];
            newHours.layer.cornerRadius = 5;
            [newHours setTag:502+count];
            [cell addSubview:newHours];
            [UIView animateWithDuration:.2
                             animations:^{
                                 CGRect offsetFrame = newHours.frame;
                                 offsetFrame.size.width = 5;
                                 newHours.frame = CGRectOffset(offsetFrame, 0, 0);
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:2.0 animations:^{
                                     CGRect offsetFrame = newHours.frame;
                                     offsetFrame.size.width = totalx*ratio;
                                     newHours.frame = CGRectOffset(offsetFrame, 0, 0);
                                 }];
                                 
                             }];
            
            UILabel *newDeadlineLabel = [[UILabel alloc] initWithFrame:newDeadline];
            [newDeadlineLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [newDeadlineLabel setTextAlignment:NSTextAlignmentCenter];
            [newDeadlineLabel setMinimumFontSize:10];
            [newDeadlineLabel setAdjustsFontSizeToFitWidth:YES];
            NSDateComponents *deadlineComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:thisTask.deadline];
            newDeadlineLabel.text = [NSString stringWithFormat:@"Deadline: %d/%d/%d",[deadlineComponents month],[deadlineComponents day],[deadlineComponents year]];
            [newDeadlineLabel setTag:504+count];
            [cell addSubview:newDeadlineLabel];
            
            UILabel *newTitleLabel = [[UILabel alloc] initWithFrame:newTitle];
            [newTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [newTitleLabel setMinimumFontSize:10];
            [newTitleLabel setTextAlignment:UITextAlignmentCenter];
            [newTitleLabel setAdjustsFontSizeToFitWidth:YES];
            newTitleLabel.text = thisTask.jobTitle;
            [newTitleLabel setTag:503+count];
            [cell addSubview:newTitleLabel];
            amount = amount + 50;
        }else{
            lblJobTitle.text =thisTask.jobTitle;
            NSDateComponents *deadlineComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:thisTask.deadline];
            lblDeadline.text = [NSString stringWithFormat:@"Deadline: %d/%d/%d",[deadlineComponents month],[deadlineComponents day],[deadlineComponents year]];
            double ratio = [thisTask.hoursWorked doubleValue]/[thisTask.maximumHours doubleValue];
            NSString *ratioString = [NSString stringWithFormat:@"%f",ratio*100];
            NSLog(@"%@",ratioString);
            if(ratio*100 == 100){
                lblPercent.text = [NSString stringWithFormat:@"%@%@",[ratioString substringToIndex:3],@"%"];
            }else if (ratio* 100 >= 10){
                lblPercent.text = [NSString stringWithFormat:@"%@%@",[ratioString substringToIndex:2],@"%"];
                
            }else{
                lblPercent.text = [NSString stringWithFormat:@"%@%@",[ratioString substringToIndex:1],@"%"];
                
            }            hoursDone.backgroundColor = [UIColor colorWithRed:(185/255.f) green:(100/255.f) blue:(100/255.f) alpha:1.0f];
            hoursDone.layer.cornerRadius = 5;
            [UIView animateWithDuration:.2
                             animations:^{
                                 CGRect offsetFrame = hoursDone.frame;
                                 offsetFrame.size.width = 5;
                                 hoursDone.frame = CGRectOffset(offsetFrame, 0, 0);
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:2.0 animations:^{
                                     CGRect offsetFrame = hoursDone.frame;
                                     offsetFrame.size.width = totalx*ratio;
                                     hoursDone.frame = CGRectOffset(offsetFrame, 0, 0);
                                 }];
                                 
                             }];
        }
        
        count ++;
    }
    return cell;
}

//-(void)animateLabel: (UILabel*)label: (double) distance{
//    const float movementDuration = 2.0f; // tweak as needed
//    
//    //NSLog(@"distance is %d", movement);
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    CGRect offsetFrame = label.frame;
//    offsetFrame.size.width = distance;
//    label.frame = CGRectOffset(offsetFrame, 0, 0);
//    [UIView commitAnimations];
//}

-(void)fetchCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    
    jobs = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    sortedJobs = [NSMutableArray arrayWithArray:jobs];
    NSMutableArray *datesTillDeadline = [[NSMutableArray alloc] initWithCapacity:[jobs count]];
    NSMutableArray *totalRates = [[NSMutableArray alloc] initWithCapacity:[jobs count]];
    NSMutableArray *companyNames = [[NSMutableArray alloc] initWithCapacity:[jobs count]];
    NSNumber *aNumber;
    NSNumber *rateNumber = [NSNumber numberWithDouble:0];
    for(Company *aCompany in jobs){
        rateNumber = [NSNumber numberWithDouble:0];
        for(Task *aTask in aCompany.job){
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                       fromDate:[NSDate date]
                                                         toDate:aTask.deadline
                                                        options:0];
            aNumber = [NSNumber numberWithDouble:([components day] + (31*[components month]) + (365*[components year]))];
            rateNumber = [NSNumber numberWithDouble:[rateNumber doubleValue] + [aTask.rate doubleValue]];
        }
        
        aNumber = [NSNumber numberWithDouble:[aNumber doubleValue]/aCompany.job.count];
        
        [totalRates addObject:rateNumber];
        NSLog(@"what it thinks a number is for %@ : %f",aCompany.clientName,[aNumber doubleValue]);
        [datesTillDeadline addObject:aNumber];
        [companyNames addObject:aCompany.clientName];
        
    }
    
    
    NSDictionary *rateDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithArray:totalRates] forKeys:[NSArray arrayWithArray:companyNames]];
    if(datesTillDeadline.count > 1){
        for(int i = 0; i < datesTillDeadline.count; i ++){
            NSNumber *thisNumber = [datesTillDeadline objectAtIndex:i];
            for(int j = i+1; j <datesTillDeadline.count; j++){
                NSNumber *secondNumber = [datesTillDeadline objectAtIndex:j];
                if([secondNumber doubleValue] > [thisNumber doubleValue]){
                    Company *moveA = [sortedJobs objectAtIndex:i];
                    Company *moveB = [sortedJobs objectAtIndex:j];
                    [datesTillDeadline removeObjectAtIndex:i];
                    [datesTillDeadline removeObjectAtIndex:j-1];
                    [datesTillDeadline insertObject:secondNumber atIndex:i];
                    [datesTillDeadline insertObject:thisNumber atIndex:j];
                    [sortedJobs removeObjectAtIndex:i];
                    [sortedJobs removeObjectAtIndex:j-1];
                    [sortedJobs insertObject:moveA atIndex:i];
                    [sortedJobs insertObject:moveB atIndex:j];
                    thisNumber = [datesTillDeadline objectAtIndex:i];
                }else if([secondNumber doubleValue] == [thisNumber doubleValue]){
                    Company *firstCompany = [sortedJobs objectAtIndex:i];
                    NSLog(@"Thinks %@ s job count is %d",firstCompany.clientName,firstCompany.job.count);
                    NSLog(@"Thinks %@ s job rate is %f",firstCompany.clientName,[[rateDictionary objectForKey:firstCompany.clientName] doubleValue]);
                    
                    Company *secondCompany = [sortedJobs objectAtIndex:j];
                    NSLog(@"Thinks %@ s job count is %d",secondCompany.clientName,secondCompany.job.count);
                    NSLog(@"Thinks %@ s job rate is %f",secondCompany.clientName,[[rateDictionary objectForKey:secondCompany.clientName] doubleValue]);
                    
                    if(firstCompany.job.count > secondCompany.job.count){
                        Company *moveA = [sortedJobs objectAtIndex:i];
                        Company *moveB = [sortedJobs objectAtIndex:j];
                        [datesTillDeadline removeObjectAtIndex:i];
                        [datesTillDeadline removeObjectAtIndex:j-1];
                        [datesTillDeadline insertObject:secondNumber atIndex:i];
                        [datesTillDeadline insertObject:thisNumber atIndex:j];
                        [sortedJobs removeObjectAtIndex:i];
                        [sortedJobs removeObjectAtIndex:j-1];
                        [sortedJobs insertObject:moveA atIndex:i];
                        [sortedJobs insertObject:moveB atIndex:j];
                        
                        thisNumber = [datesTillDeadline objectAtIndex:i];
                    }else if(firstCompany.job.count == secondCompany.job.count){
                        NSNumber *firstTotalRate = [rateDictionary objectForKey:firstCompany.clientName];
                        NSNumber *secondTotalRate = [rateDictionary objectForKey:secondCompany.clientName];
                        if([firstTotalRate doubleValue] > [secondTotalRate doubleValue]){
                            Company *moveA = [sortedJobs objectAtIndex:i];
                            Company *moveB = [sortedJobs objectAtIndex:j];
                            [datesTillDeadline removeObjectAtIndex:i];
                            [datesTillDeadline removeObjectAtIndex:j-1];
                            [datesTillDeadline insertObject:secondNumber atIndex:i];
                            [datesTillDeadline insertObject:thisNumber atIndex:j];
                            [sortedJobs removeObjectAtIndex:i];
                            [sortedJobs removeObjectAtIndex:j-1];
                            [sortedJobs insertObject:moveA atIndex:i];
                            [sortedJobs insertObject:moveB atIndex:j];
                            
                            thisNumber = [datesTillDeadline objectAtIndex:i];
                        }
                    }
                }
            }
        }
    }
    
    
    
}

-(void)deleteItemFromCoreData: (Company *)thisCompany{
    
    for(Task *aTask in thisCompany.job){
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
    
    [managedObjectContext deleteObject:thisCompany];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        return;
    }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        selectedRow = [indexPath row];
        alertView = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"Deleting a client will delete all of their jobs!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
        
    }
}

- (void)alertView:(UIAlertView *)thisAlertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{
    if(thisAlertView == alertView){
        if(buttonIndex == 1)
        {
            NSLog(@"idp %d",selectedRow);
            [self deleteItemFromCoreData:[sortedJobs objectAtIndex:selectedRow]];
            [self fetchCoreData];
            [jobTable reloadData];
            if(!([sortedJobs count] > 0)){
                jobTable.hidden = YES;
                UILabel *hiddenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
                [hiddenLabel setBackgroundColor:[UIColor clearColor]];
                [hiddenLabel setTextColor:[UIColor whiteColor]];
                [hiddenLabel setTextAlignment:UITextAlignmentCenter];
                [hiddenLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
                [hiddenLabel setText:@"You have no jobs at this time!"];
                [self.view addSubview:hiddenLabel];
                
                UIButton *buttonForDummies = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonForDummies.frame = CGRectMake(50, 200, 220, 70);
                [buttonForDummies setBackgroundColor:[UIColor colorWithRed:(135/255.f) green:(143/255.f) blue:(144/255.f) alpha:1.0f]];
                [buttonForDummies setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                buttonForDummies.layer.cornerRadius = 10;
                buttonForDummies.clipsToBounds = YES;
                [buttonForDummies setTitle:@"Add New job" forState:UIControlStateNormal];
                [buttonForDummies addTarget:self action:@selector(newJobClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:buttonForDummies];
            }else{
                
            }
            
        }
    }
}

@end
