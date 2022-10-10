//
//  NSWindow+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindow+FTAutoTrack.h"
#import "FTAutoTrackProtocol.h"
#import "FTSwizzler.h"
#import <objc/runtime.h>
#import "FTDateUtil.h"
#import "FTGlobalRumManager.h"
#import "FTRumManager.h"
#import "NSViewController+FTAutoTrack.h"
#import "FTConstants.h"
@interface NSWindow (FTAutoTrack)<FTRumViewProperty>
@end
@implementation NSWindow (FTAutoTrack)
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
    return self.isMainWindow;
}
-(BOOL)dataflux_isKeyWindow{
    return self.isKeyWindow;
}
-(NSString *)dataflux_windowName{
    return NSStringFromClass(self.class);
}
#pragma mark - AutoTrack -

-(instancetype)dataflux_init{
    NSWindow *win = [self dataflux_init];
    return win;
}
-(instancetype)dataflux_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag{
    NSWindow *win = [self dataflux_initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];

    return win;
}
- (instancetype)dataflux_initWithCoder:(NSCoder *)coder{
    NSWindow *win = [self dataflux_initWithCoder:coder];
    return win;
    
}
-(void)dataflux_makeMainWindow{
    [self dataflux_makeMainWindow];
    if (!self.contentViewController && !self.windowController && ![self isKindOfClass:NSPanel.class]) {
        //window
        //记录 init - keyWindow 的时间差 作为window显示加载时长
        //只记录第一次 变成keyWindow
        if(self.dataflux_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.dataflux_viewLoadStartTime toDate:[NSDate date]];
            self.dataflux_loadDuration = loadTime;
            self.dataflux_viewLoadStartTime = nil;
            self.dataflux_viewUUID = [NSUUID UUID].UUIDString;
//            [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
        }

    }
}
-(void)dataflux_makeKeyWindow{
    [self dataflux_makeKeyWindow];
    if (!self.contentViewController && !self.windowController && ![self isKindOfClass:NSPanel.class]) {
        //window
        //记录 init - keyWindow 的时间差 作为window显示加载时长
        //只记录第一次 变成keyWindow
        if(self.dataflux_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.dataflux_viewLoadStartTime toDate:[NSDate date]];
            self.dataflux_loadDuration = loadTime;
            self.dataflux_viewLoadStartTime = nil;
            self.dataflux_viewUUID = [NSUUID UUID].UUIDString;
//            [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
        }

    }
}

-(void)dataflux_close{
    if (!self.contentViewController && !self.windowController && ![self isKindOfClass:NSPanel.class]) {
//        [[FTGlobalRumManager sharedInstance] trackViewDidDisappear:self];
    }
    [self dataflux_close];

}
@end
