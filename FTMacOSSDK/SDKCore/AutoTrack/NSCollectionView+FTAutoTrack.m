//
//  NSCollectionView+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "NSCollectionView+FTAutoTrack.h"
#import "FTSwizzler.h"
#import "FTRumManager.h"

@implementation NSCollectionView (FTAutoTrack)

-(void)dataflux_setDelegate:(id<NSCollectionViewDelegate>)delegate{
    [self dataflux_setDelegate:delegate];
    
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(collectionView:didSelectItemsAtIndexPaths:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        void (^didSelectItemBlock)(id, SEL, id, id) = ^(id view, SEL command, NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths) {
            
            if (collectionView && indexPaths) {
                [[FTRumManager sharedInstance] addActionEventWithView:self];
            }
        };
        
        [FTSwizzler swizzleSelector:selector
                            onClass:class
                          withBlock:didSelectItemBlock
                              named:@"collectionView_didSelect"];
    }
    
    
}
@end
@implementation NSTableView (FTAutoTrack)

-(void)dataflux_setDoubleAction:(SEL)doubleAction{
    [self dataflux_setDoubleAction:doubleAction];
    void (^doubleActionBlock)(void) = ^() {
        [[FTRumManager sharedInstance] addActionEventWithView:self];
    };
    [FTSwizzler swizzleSelector:doubleAction
                        onClass:self.class
                      withBlock:doubleActionBlock
                          named:@"tableView_doubleAction"];
}

@end
