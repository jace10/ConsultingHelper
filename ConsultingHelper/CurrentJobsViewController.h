//
//  CurrentJobsViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Task.h"
#import "ClientDetailViewController.h"
#import "MBProgressHUD.h"
@interface CurrentJobsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *jobTable;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic) NSString *tabChoice;

@end
