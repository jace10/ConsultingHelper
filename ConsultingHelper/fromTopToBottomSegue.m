//
//  fromTopToBottomSegue.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "fromTopToBottomSegue.h"

@implementation fromTopToBottomSegue

- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
    
}

@end
