//
//  NSWindowController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindowController+FTAutoTrack.h"
#import <objc/runtime.h>
#import "FTDateUtil.h"
#import "FTRumManager.h"
@implementation NSWindowController (FTAutoTrack)
static char *viewLoadStartTimeKey = "viewLoadStartTimeKey";
static char *viewLoadDuration = "viewLoadDuration";
static char *viewControllerUUID = "viewControllerUUID";
-(void)setFt_viewLoadStartTime:(NSDate *)viewLoadStartTime{
    objc_setAssociatedObject(self, &viewLoadStartTimeKey, viewLoadStartTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDate *)ft_viewLoadStartTime{
    return objc_getAssociatedObject(self, &viewLoadStartTimeKey);
}
-(NSNumber *)ft_loadDuration{
    return objc_getAssociatedObject(self, &viewLoadDuration);
}
-(void)setFt_loadDuration:(NSNumber *)ft_loadDuration{
    objc_setAssociatedObject(self, &viewLoadDuration, ft_loadDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)ft_viewUUID{
    return objc_getAssociatedObject(self, &viewControllerUUID);
}
-(void)setFt_viewUUID:(NSString *)ft_viewUUID{
    objc_setAssociatedObject(self, &viewControllerUUID, ft_viewUUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//即将加载nib
-(void)dataflux_windowWillLoad{
    self.ft_viewLoadStartTime =[NSDate date];
    [self dataflux_windowWillLoad];
}
//加载nib之后
- (void)dataflux_windowDidLoad{

    [self dataflux_windowDidLoad];
    NSLog(@"ft_windowDidLoad contentViewController = %@",self.window.contentViewController);
    if(!self.window.contentViewController){
        // 记录 window 的生命周期
        if(self.ft_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanotimeIntervalSinceDate:[NSDate date] toDate:self.ft_viewLoadStartTime];
            self.ft_loadDuration = loadTime;
            self.ft_viewLoadStartTime = nil;
            self.ft_viewUUID = [NSUUID UUID].UUIDString;
            [[FTRumManager sharedInstance] addViewAppearEvent:self];
        }
    }
    
}
- (void)dataflux_windowWillClose:(NSNotification *)notification{
    [self dataflux_windowWillClose:notification];
}

@end
