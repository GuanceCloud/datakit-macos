//
//  NSTabView+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/26.
//

#import "NSTabView+FTAutoTrack.h"
#import "FTSwizzler.h"
#import "FTRumManager.h"

@implementation NSTabView (FTAutoTrack)
-(void)dataflux_setDelegate:(id<NSTabViewDelegate>)delegate{
    [self dataflux_setDelegate:delegate];
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(tabView:didSelectTabViewItem:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        void (^didSelectItemBlock)(id, SEL, id, id) = ^(id view, SEL command, NSTableView *tabView, NSTabViewItem *tabViewItem) {
            
            if (tabView && tabViewItem) {
                [[FTRumManager sharedInstance] addActionEventWithView:self];

            }
        };
        
        [FTSwizzler swizzleSelector:selector
                            onClass:class
                          withBlock:didSelectItemBlock
                              named:@"tabView _didSelect"];
    }
    
}

@end
