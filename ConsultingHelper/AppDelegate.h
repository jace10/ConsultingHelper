//
//  AppDelegate.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "Company.h"
#import "Task.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) Facebook *facebook;
@end
