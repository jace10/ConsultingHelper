//
//  Reminder.h
//  ConsultingHelper
//
//  Created by Vision Retail on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSDate * fireDate;
@property (nonatomic, retain) NSString * notificationIdentifier;
@property (nonatomic, retain) Task *task;

@end
