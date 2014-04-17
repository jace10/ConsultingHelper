//
//  Company.h
//  ConsultingHelper
//
//  Created by Jason Mather on 7/31/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * clientName;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * imgPath;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSData * localImage;
@property (nonatomic, retain) NSSet *job;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addJobObject:(Task *)value;
- (void)removeJobObject:(Task *)value;
- (void)addJob:(NSSet *)values;
- (void)removeJob:(NSSet *)values;

@end
