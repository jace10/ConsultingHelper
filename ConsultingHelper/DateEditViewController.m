//
//  DateEditViewController.m
//  ConsultingHelper
//
//  Created by Jason Mather on 7/30/12.
//
//

#import "DateEditViewController.h"

@interface DateEditViewController (){
    UIActionSheet *actionSheet;
}

@end

@implementation DateEditViewController
@synthesize lblInstruct;
@synthesize datePicke;
@synthesize saveButtonOutlet;
@synthesize instructString;
@synthesize previousDate;
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
     if(self){
         
     }
     
     return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [saveButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [datePicke setDate:previousDate];
    [saveButtonOutlet.layer setBorderWidth:2];
    lblInstruct.text = instructString;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dismissActionSheet{
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)saveButton:(id)sender {
    if(datePicke.date == previousDate){
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Date Unchanged, No Changes Saved." delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self performSelector:@selector(dismissActionSheet) withObject:nil afterDelay:3.0];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }else{
        [self.delegate newDate:datePicke.date:instructString];
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setLblInstruct:nil];
    [self setDatePicke:nil];
    [self setSaveButtonOutlet:nil];
    [super viewDidUnload];
}
@end
