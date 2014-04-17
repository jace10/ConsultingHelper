//
//  SocialAddViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialAddViewController.h"

@interface SocialAddViewController ()

@end

@implementation SocialAddViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (IBAction)facebookLogin:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:nil delegate:self cancelButtonTitle:@"Can't Wait@" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)linkedInLogin:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:nil delegate:self cancelButtonTitle:@"Can't Wait@" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toLinkedInSegue"]){
        
    }
}
@end
