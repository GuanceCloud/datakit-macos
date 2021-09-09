//
//  NSViewController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSViewController+FTAutoTrack.h"

@implementation NSViewController (FTAutoTrack)
- (void)dataflux_viewDidLoad{
//    self.ft_viewLoadStartTime =[NSDate date];
    [self dataflux_viewDidLoad];
}
-(void)dataflux_viewDidAppear{
    [self dataflux_viewDidAppear];
    
//    // 预防撤回侧滑
//    if ([FTMonitorManager sharedInstance].currentController != self) {
//        if(self.ft_viewLoadStartTime){
//            NSNumber *loadTime = [FTDateUtil nanotimeIntervalSinceDate:[NSDate date] toDate:self.ft_viewLoadStartTime];
//            self.ft_loadDuration = loadTime;
//            self.ft_viewLoadStartTime = nil;
//        }else{
//            NSNumber *loadTime = @0;
//            self.ft_loadDuration = loadTime;
//        }
//        self.ft_viewUUID = [NSUUID UUID].UUIDString;
//        [[FTMonitorManager sharedInstance] trackViewDidAppear:self];
//    }
    
}
-(void)dataflux_viewDidDisappear{
    [self dataflux_viewDidDisappear];
  
//    if ([FTMonitorManager sharedInstance].currentController == self) {
//        [[FTMonitorManager sharedInstance] trackViewDidDisappear:self];
//    }
    
}

@end
