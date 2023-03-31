//
//  NSTabView+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/26.
//

#import "NSTabView+FTAutoTrack.h"
#import <FTSwizzler.h>
#import "FTGlobalRumManager.h"
#import "NSView+FTAutoTrack.h"
#import <FTLog.h>
#import "FTAutoTrack.h"
@implementation NSTabView (FTAutoTrack)
-(void)datakit_setDelegate:(id<NSTabViewDelegate>)delegate{
    [self datakit_setDelegate:delegate];
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(tabView:didSelectTabViewItem:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        void (^didSelectItemBlock)(id, SEL, id, id) = ^(id view, SEL command, NSTableView *tabView, NSTabViewItem *tabViewItem) {
            
            if (tabView && tabViewItem) {
                if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
                    [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:self.datakit_actionName];
                }
            }
        };
        
        [FTSwizzler swizzleSelector:selector
                            onClass:class
                          withBlock:didSelectItemBlock
                              named:@"tabView _didSelect"];
    }
    
}

@end
