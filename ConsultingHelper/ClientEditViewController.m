//
//  ClientEditViewController.m
//  ConsultingHelper
//
//  Created by Jason Mather on 8/1/12.
//
//

#import "ClientEditViewController.h"

@interface ClientEditViewController ()

@end

@implementation ClientEditViewController

@synthesize managedObjectContext;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButton:(id)sender {
}

- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
