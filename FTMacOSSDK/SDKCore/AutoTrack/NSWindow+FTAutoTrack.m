//
//  NSWindow+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindow+FTAutoTrack.h"
#import "FTAutoTrackProtocol.h"
#import <FTSwizzler.h>
#import <FTDateUtil.h>
#import <FTLog.h>
#import <FTConstants.h>
#import <objc/runtime.h>
#import "FTGlobalRumManager.h"
#import "NSViewController+FTAutoTrack.h"
@interface NSWindow (FTAutoTrack)<FTRumViewProperty>
@end
@implementation NSWindow (FTAutoTrack)
#pragma mark - Rum Data -
static char *viewLoadStartTimeKey = "viewLoadStartTimeKey";
static char *viewLoadDuration = "viewLoadDuration";
static char *viewControllerUUID = "viewControllerUUID";
-(void)setDatakit_viewLoadStartTime:(NSDate *)datakit_viewLoadStartTime{
    objc_setAssociatedObject(self, &viewLoadStartTimeKey, datakit_viewLoadStartTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDate *)setDatakit_loadDuration{
    return objc_getAssociatedObject(self, &viewLoadStartTimeKey);
}
-(NSNumber *)datakit_loadDuration{
    return objc_getAssociatedObject(self, &viewLoadDuration);
}
-(void)setDatakit_loadDuration:(NSNumber *)datakit_loadDuration{
    objc_setAssociatedObject(self, &viewLoadDuration, datakit_loadDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)datakit_viewUUID{
    return objc_getAssociatedObject(self, &viewControllerUUID);
}
-(void)setDatakit_viewUUID:(NSString *)datakit_viewUUID{
    objc_setAssociatedObject(self, &viewControllerUUID, datakit_viewUUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)datakit_parentVC{
    return FT_NULL_VALUE;
}
-(BOOL)datakit_inMainWindow{
    return self.isMainWindow;
}
-(BOOL)datakit_isKeyWindow{
    return self.isKeyWindow;
}
-(NSString *)datakit_windowName{
    return NSStringFromClass(self.class);
}
#pragma mark - AutoTrack -

-(instancetype)datakit_init{
    NSWindow *win = [self datakit_init];
    return win;
}
-(instancetype)datakit_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag{
    NSWindow *win = [self datakit_initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];

    return win;
}
- (instancetype)datakit_initWithCoder:(NSCoder *)coder{
    NSWindow *win = [self datakit_initWithCoder:coder];
    return win;
    
}
-(void)datakit_makeMainWindow{
    [self datakit_makeMainWindow];
    if (!self.contentViewController && !self.windowController && ![self isKindOfClass:NSPanel.class]) {
        //window
        //记录 init - keyWindow 的时间差 作为window显示加载时长
        //只记录第一次 变成keyWindow
        if(self.datakit_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.datakit_viewLoadStartTime toDate:[NSDate date]];
            self.datakit_loadDuration = loadTime;
            self.datakit_viewLoadStartTime = nil;
            self.datakit_viewUUID = [NSUUID UUID].UUIDString;
//            [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
        }

    }
}
-(void)datakit_makeKeyWindow{
    ZYErrorLog(@"window KeyWindow:%@ \n viewcontroller: %@",self.class,self.contentViewController);
    [self datakit_makeKeyWindow];
    if (!self.contentViewController && !self.windowController && ![self isKindOfClass:NSPanel.class]) {
        //window
        //记录 init - keyWindow 的时间差 作为window显示加载时长
        //只记录第一次 变成keyWindow
        if(self.datakit_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.datakit_viewLoadStartTime toDate:[NSDate date]];
            self.datakit_loadDuration = loadTime;
            self.datakit_viewLoadStartTime = nil;
            self.datakit_viewUUID = [NSUUID UUID].UUIDString;
//            [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
        }

    }
}

-(void)datakit_close{
    ZYErrorLog(@"window close:%@ \n viewcontroller: %@",self.class,self.contentViewController);

    if (!self.contentViewController && !self.windowController && ![self isKindOfClass:NSPanel.class]) {
//        [[FTGlobalRumManager sharedInstance] trackViewDidDisappear:self];
    }
    [self datakit_close];

}
-(void)datakit_becomeKeyWindow{
    ZYErrorLog(@"window becomeKeyWindow:%@ \n viewcontroller: %@",self.class,self.contentViewController);
    [self datakit_becomeKeyWindow];
}
@end
