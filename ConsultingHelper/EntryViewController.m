//
//  EntryViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController{
    UIView *wrapperView;
    UIImageView *currentJobChoice;
    UIImageView *newJobChoice;
    NSInteger instructTag;
    NSInteger circButtonTag;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        instructTag = 1;
        circButtonTag = 100;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSLog(@"count %d",[[[UIApplication sharedApplication] scheduledLocalNotifications]count]);
    [self.navigationController setNavigationBarHidden:YES];
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self setView:wrapperView];
    
    UILabel *instruct = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 30)];
    [instruct setBackgroundColor:[UIColor clearColor]];
    [instruct setTextColor:[UIColor whiteColor]];
    [instruct setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [instruct setTextAlignment:UITextAlignmentCenter];
    [instruct setText:@"Pull the circle towards your choice"];
    [instruct setTag:instructTag];
    [wrapperView addSubview:instruct];
    
    
    
    
    
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 40, 150, 50)];
    [currentLabel setBackgroundColor:[UIColor clearColor]];
    [currentLabel setTextColor:[UIColor whiteColor]];
    [currentLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [currentLabel setTextAlignment:UITextAlignmentCenter];
    [currentLabel setText:@"Current Jobs"];
    [wrapperView addSubview:currentLabel];
    
    UILabel *newJobLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 150, 50)];
    [newJobLabel setBackgroundColor:[UIColor clearColor]];
    [newJobLabel setTextColor:[UIColor whiteColor]];
    [newJobLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [newJobLabel setTextAlignment:UITextAlignmentCenter];
    [newJobLabel setText:@"Add New Job"];
    [wrapperView addSubview:newJobLabel];
    
    
    newJobChoice = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 150, wrapperView.frame.size.height-90)];
    [newJobChoice setBackgroundColor:[UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f]];
    newJobChoice.layer.cornerRadius = 10;
    newJobChoice.clipsToBounds = YES;
    [newJobChoice setAlpha:.5];
    [newJobChoice setTag:102];
    [wrapperView addSubview:newJobChoice];
    
    
    currentJobChoice = [[UIImageView alloc] initWithFrame:CGRectMake(170, 90, 150, wrapperView.frame.size.height-90)];
    [currentJobChoice setBackgroundColor:[UIColor colorWithRed:(185/255.f) green:(100/255.f) blue:(100/255.f) alpha:1.0f]];
    currentJobChoice.layer.cornerRadius = 10;
    currentJobChoice.clipsToBounds = YES;
    [currentJobChoice setAlpha:.5];
    [currentJobChoice setTag:101];
    [wrapperView addSubview:currentJobChoice];
    
    UIButton *circleButton = [[UIButton alloc] initWithFrame:CGRectMake(wrapperView.center.x-40, wrapperView.center.y-40, 80, 80)];
    [circleButton setBackgroundImage:[UIImage imageNamed:@"orangeCircle.png"] forState:UIControlStateNormal];
    [circleButton setBackgroundColor:[UIColor clearColor]];
    [circleButton addTarget:self action:@selector(draggedOut:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [circleButton addTarget:self action:@selector(dragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [circleButton setTag:circButtonTag];
    [wrapperView addSubview:circleButton];
    [wrapperView setBackgroundColor:[UIColor blackColor]];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)draggedOut: (id)sender withEvent: (UIEvent *) event {
    UIImageView *right = (UIImageView*)[self.view viewWithTag:101];
    UIImageView *left = (UIImageView*)[self.view viewWithTag:102];

    CGRect rightChoice = CGRectMake(170, 90, 150,  wrapperView.frame.size.height-90);
    CGRect leftChoice = CGRectMake(0, 90, 150,  wrapperView.frame.size.height-90);
    UIButton *selected = (UIButton *)sender;
    selected.center = [[[event allTouches] anyObject] locationInView:self.view];
    if(CGRectContainsPoint(rightChoice, selected.center)){
        [right setAlpha:1.0];
    }else{
        [right setAlpha:.5];
    }
    if(CGRectContainsPoint(leftChoice, selected.center)){
        [left setAlpha:1.0];
    }else{
        [left setAlpha:.5];
    }
} 

-(IBAction)dragEnded:(id)sender{
    UIButton *selected = (UIButton *)sender;
    CGRect rightChoice = CGRectMake(170, 90, 150,  wrapperView.frame.size.height-90);
    CGRect leftChoice = CGRectMake(0, 90, 150,  wrapperView.frame.size.height-90);
    
    if(!((CGRectContainsPoint(rightChoice, selected.center))||(CGRectContainsPoint(leftChoice, selected.center)))){
        double x = selected.center.x - wrapperView.center.x;
        double y = selected.center.y - wrapperView.center.y;
        [self animateView:selected :-x :-y];
    }else if(CGRectContainsPoint(leftChoice, selected.center)){
        [self performSegueWithIdentifier:@"toNewJobSegue" sender:selected];
        
    }else{
        [self performSegueWithIdentifier:@"toConsultingSegue" sender:selected];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"toNewJobSegue"]){
        UITabBarController *controller = [segue destinationViewController];
        NewJobViewController *njvc = [[controller viewControllers] objectAtIndex:0];
        njvc.tabChoice = @"1";
    }else if([[segue identifier] isEqualToString:@"toConsultingSegue"]){
        UITabBarController *controller = [segue destinationViewController];
        CurrentJobsViewController *cjvc = [[controller viewControllers] objectAtIndex:1];
        cjvc.tabChoice = @"0";
    }
    
    
}



- (void) animateView: (UIButton*) view : (NSInteger) xdistance : (NSInteger) ydistance
{
    
    
    const float movementDuration = 0.3f; // tweak as needed
    
    
    //NSLog(@"distance is %d", movement);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, xdistance, ydistance);
    [UIView commitAnimations];
    
    
    
    
}






@end
