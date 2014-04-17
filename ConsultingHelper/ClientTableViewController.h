//
//  ClientTableViewController.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "AppDelegate.h"

@protocol existingClient <NSObject>

-(void)setClientDelegate: (Company *)thisClient;

@end


@interface ClientTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *clientTable;
@property (strong, nonatomic) id <existingClient> delegate;

@end
