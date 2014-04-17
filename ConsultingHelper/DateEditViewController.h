//
//  DateEditViewController.h
//  ConsultingHelper
//
//  Created by Jason Mather on 7/30/12.
//
//

@protocol dateChangeDelegate <NSObject>

-(void)newDate: (NSDate*)aDate : (NSString*) instruct;

@end

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DateEditViewController : UIViewController <UIActionSheetDelegate>
- (IBAction)saveButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblInstruct;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicke;
@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;
@property (strong, nonatomic) NSString* instructString;
@property (strong, nonatomic) NSDate *previousDate;
@property (strong,nonatomic) id<dateChangeDelegate> delegate;

@end
