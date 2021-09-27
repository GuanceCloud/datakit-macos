//
//  NSWindow+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindow+FTAutoTrack.h"
#import "FTSwizzler.h"
#import <objc/runtime.h>
#import "FTDateUtil.h"
#import "FTRumManager.h"
@implementation NSWindow (FTAutoTrack)
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
-(instancetype)dataflux_init{
    NSWindow *win = [self dataflux_init];
    NSLog(@"\n ==================\nNSWindow init= %@\n ==================",NSStringFromClass([win class]));
    return win;
}
-(instancetype)dataflux_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag{
    NSWindow *win = [self dataflux_initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    NSLog(@"\n ==================\nft_initWithContentRect init= %@\n ==================",NSStringFromClass([win class]));
    NSLog(@"\n ==================\n contentViewController = %@\n ==================",win.contentViewController);

    return win;
}
- (instancetype)dataflux_initWithCoder:(NSCoder *)coder{
    NSWindow *win = [self dataflux_initWithCoder:coder];
    NSLog(@"\n ==================\nft_initWithCoder init= %@\n ==================",NSStringFromClass([win class]));
   
    return win;
    
}
-(void)dataflux_makeKeyWindow{
    [self dataflux_makeKeyWindow];
    if (!self.contentViewController && !self.windowController && ![self isKindOfClass:NSPanel.class]) {
        //window
        //记录 init - keyWindow 的时间差 作为window显示加载时长
        //只记录第一次 变成keyWindow
        if(self.ft_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanotimeIntervalSinceDate:[NSDate date] toDate:self.ft_viewLoadStartTime];
            self.ft_loadDuration = loadTime;
            self.ft_viewLoadStartTime = nil;
            self.ft_viewUUID = [NSUUID UUID].UUIDString;
            [[FTRumManager sharedInstance] addViewAppearEvent:self];
        }

    }
}

-(void)dataflux_close{
    [self dataflux_close];
}
@end
