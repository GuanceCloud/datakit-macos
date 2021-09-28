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


@implementation NSGestureRecognizer (FTAutoTrack)


-(void)dataflux_setAction:(SEL)action{
    [self dataflux_setAction:action];
    if (self.target) {
        __weak typeof(self) weakSelf = self;
        [FTSwizzler swizzleSelector:action onClass:[self.target class] withBlock:^{
            [weakSelf ftTrackGestureRecognizerAppClick];
        } named:@"action"];
    }
}
-(void)dataflux_setTarget:(id)target{
    [self dataflux_setTarget:target];
    if (self.action) {
        __weak typeof(self) weakSelf = self;
        [FTSwizzler swizzleSelector:self.action onClass:[self.target class] withBlock:^{
            [weakSelf ftTrackGestureRecognizerAppClick];
        } named:@"action"];
    }
}
- (void)ftTrackGestureRecognizerAppClick{
    @try {
        [[FTRumManager sharedInstance] addActionEventWithView:self.view];
        
    }@catch (NSException *exception) {
        ZYErrorLog(@"%@ error: %@", self, exception);
    }
}
-(void)dealloc{
    
}
@end
