//
//  NewJobViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewJobViewController.h"

@interface NewJobViewController ()

@end

@implementation NewJobViewController{
    UIView *wrapperView;
    UIButton *circleButton;
    UIImageView *topChoice;
    UIImageView *bottomChoice;
}

@synthesize tabChoice;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        tabChoice = @"";
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    UILabel *old = (UILabel*)[self.navigationController.navigationBar viewWithTag:900];
    [old removeFromSuperview];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, self.navigationController.navigationBar.frame.size.height)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTag:900];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    titleLabel.text = @"New Job";
    [self.navigationController.navigationBar addSubview:titleLabel];
    if(tabChoice.length > 0){
        [self.tabBarController setSelectedIndex:[tabChoice integerValue]];
    }
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.view = wrapperView;
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topLabel setBackgroundColor:[UIColor clearColor]];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [topLabel setTextAlignment:UITextAlignmentCenter];
    [topLabel setText:@"Enter New Job/Client Manually"];
    [wrapperView addSubview:topLabel];
    
    topChoice = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 320, 135)];
    [topChoice setBackgroundColor:[UIColor colorWithRed:(185/255.f) green:(100/255.f) blue:(100/255.f) alpha:1.0f]];
    topChoice.layer.cornerRadius = 10;
    topChoice.clipsToBounds = YES;
    [topChoice setAlpha:.5];
    [topChoice setTag:102];
    [wrapperView addSubview:topChoice];
    
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 330, 320, 30)];
    [bottomLabel setBackgroundColor:[UIColor clearColor]];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    [bottomLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [bottomLabel setTextAlignment:UITextAlignmentCenter];
    [bottomLabel setText:@"Enter New Client From Facebook/LinkedIn"];
    [wrapperView addSubview:bottomLabel];
    
    bottomChoice = [[UIImageView alloc] initWithFrame:CGRectMake(0, 195, 320, 135)];
    [bottomChoice setBackgroundColor:[UIColor colorWithRed:(94/255.f) green:(105/255.f) blue:(179/255.f) alpha:1.0f]];
    bottomChoice.layer.cornerRadius = 10;
    bottomChoice.clipsToBounds = YES;
    [bottomChoice setAlpha:.5];
    [bottomChoice setTag:101];
    [wrapperView addSubview:bottomChoice];
    
    circleButton = [[UIButton alloc] initWithFrame:CGRectMake(wrapperView.center.x-40, 140, 80, 80)];
    [circleButton setBackgroundImage:[UIImage imageNamed:@"orangeCircle.png"] forState:UIControlStateNormal];
    [circleButton setBackgroundColor:[UIColor clearColor]];
    [circleButton addTarget:self action:@selector(draggedOut:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [circleButton addTarget:self action:@selector(dragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [circleButton setTag:100];
    [wrapperView addSubview:circleButton];
    
    CurrentJobsViewController *cjvc = [[self.tabBarController viewControllers] objectAtIndex:0];
    cjvc.tabChoice = @"";
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
    
    CGRect rightChoice = CGRectMake(0, 30, 320, 135);
    CGRect leftChoice = CGRectMake(0, 195, 320, 135);
    circleButton.center = [[[event allTouches] anyObject] locationInView:self.view];
    if(CGRectContainsPoint(rightChoice, circleButton.center)){
        [topChoice setAlpha:1.0];
    }else{
        [topChoice setAlpha:.5];
    }
    if(CGRectContainsPoint(leftChoice, circleButton.center)){
        [bottomChoice setAlpha:1.0];
    }else{
        [bottomChoice setAlpha:.5];
    }
} 

-(IBAction)dragEnded:(id)sender{
    CGRect rightChoice = CGRectMake(0, 30, 320, 135);
    CGRect leftChoice = CGRectMake(0, 195, 320, 135);
    
    if(!((CGRectContainsPoint(rightChoice, circleButton.center))||(CGRectContainsPoint(leftChoice, circleButton.center)))){
        double x = circleButton.center.x - wrapperView.center.x;
        double y = circleButton.center.y - wrapperView.center.y;
        [self animateView:circleButton :-x :-y];   
    }else if(CGRectContainsPoint(leftChoice, circleButton.center)){
        
        [self performSegueWithIdentifier:@"toSocialAddSegue" sender:circleButton];
        
    }else{
        [self performSegueWithIdentifier:@"toManualAddSegue" sender:circleButton];
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
