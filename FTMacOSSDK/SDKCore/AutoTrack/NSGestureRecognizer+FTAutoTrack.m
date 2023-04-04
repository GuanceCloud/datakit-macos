//
//  NSGestureRecognizer+FTAutoTrack.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "NSGestureRecognizer+FTAutoTrack.h"
#import "FTLog.h"
#import "FTSwizzler.h"
#import "FTRumManager.h"
#import "FTGlobalRumManager.h"
#import "NSView+FTAutoTrack.h"
#import "FTAutoTrack.h"

@implementation NSGestureRecognizer (FTAutoTrack)


-(void)datakit_setAction:(SEL)action{
    [self datakit_setAction:action];
    if (self.target) {
        __weak typeof(self) weakSelf = self;
        [FTSwizzler swizzleSelector:action onClass:[self.target class] withBlock:^{
            [weakSelf ftTrackGestureRecognizerAppClick];
        } named:@"action"];
    }
}
-(void)datakit_setTarget:(id)target{
    [self datakit_setTarget:target];
    if (self.action) {
        __weak typeof(self) weakSelf = self;
        [FTSwizzler swizzleSelector:self.action onClass:[self.target class] withBlock:^{
            [weakSelf ftTrackGestureRecognizerAppClick];
        } named:@"action"];
    }
}
- (void)ftTrackGestureRecognizerAppClick{
    @try {
        if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
            [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:self.view.datakit_actionName];
        }
    }@catch (NSException *exception) {
        ZYErrorLog(@"%@ error: %@", self, exception);
    }
}
-(void)dealloc{
    
}
@end
