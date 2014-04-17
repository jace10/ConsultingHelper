//
//  ClientEditViewController.h
//  ConsultingHelper
//
//  Created by Jason Mather on 8/1/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ClientEditViewController : UIViewController
- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
