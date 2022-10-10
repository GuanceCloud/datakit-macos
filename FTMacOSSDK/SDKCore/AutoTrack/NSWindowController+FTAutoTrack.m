//
//  NSWindowController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindowController+FTAutoTrack.h"
#import "FTAutoTrackProtocol.h"
#import <objc/runtime.h>
#import "FTDateUtil.h"
#import "FTRumManager.h"
#import "FTConstants.h"
#import "FTGlobalRumManager.h"
#import "NSView+FTAutoTrack.h"
@interface NSWindowController(FTAutoTrack)<FTRumViewProperty>
@end

@implementation NSWindowController (FTAutoTrack)
#pragma mark - Rum Data -
static char *viewLoadStartTimeKey = "viewLoadStartTimeKey";
static char *viewLoadDuration = "viewLoadDuration";
static char *viewControllerUUID = "viewControllerUUID";
-(void)setDataflux_viewLoadStartTime:(NSDate *)dataflux_viewLoadStartTime{
    objc_setAssociatedObject(self, &viewLoadStartTimeKey, dataflux_viewLoadStartTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDate *)setDataflux_loadDuration{
    return objc_getAssociatedObject(self, &viewLoadStartTimeKey);
}
-(NSNumber *)dataflux_loadDuration{
    return objc_getAssociatedObject(self, &viewLoadDuration);
}
-(void)setDataflux_loadDuration:(NSNumber *)dataflux_loadDuration{
    objc_setAssociatedObject(self, &viewLoadDuration, dataflux_loadDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)dataflux_viewUUID{
    return objc_getAssociatedObject(self, &viewControllerUUID);
}
-(void)setDataflux_viewUUID:(NSString *)dataflux_viewUUID{
    objc_setAssociatedObject(self, &viewControllerUUID, dataflux_viewUUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)dataflux_parentVC{
    return FT_NULL_VALUE;
}
-(BOOL)dataflux_inMainWindow{
    return self.window.isMainWindow;
}
-(BOOL)dataflux_isKeyWindow{
    return self.window.isKeyWindow;
}
-(NSString *)dataflux_windowName{
    return NSStringFromClass(self.window.class);
}
#pragma mark - AutoTrack -

//即将加载nib
-(void)dataflux_windowWillLoad{
    self.dataflux_viewLoadStartTime =[NSDate date];
    [self dataflux_windowWillLoad];
}
//加载nib之后
- (void)dataflux_windowDidLoad{
    [self dataflux_windowDidLoad];
    if(!self.window.contentViewController){
        // 记录 window 的生命周期
        if(self.dataflux_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.dataflux_viewLoadStartTime toDate:[NSDate date]];
            self.dataflux_loadDuration = loadTime;
            self.dataflux_viewLoadStartTime = nil;
            self.dataflux_viewUUID = [NSUUID UUID].UUIDString;
//            [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
        }
    }
    
}
- (void)dataflux_windowWillClose:(NSNotification *)notification{
    if(!self.window.contentViewController){
//        [[FTGlobalRumManager sharedInstance] trackViewDidDisappear:self];
    }
    [self dataflux_windowWillClose:notification];
}

@end
