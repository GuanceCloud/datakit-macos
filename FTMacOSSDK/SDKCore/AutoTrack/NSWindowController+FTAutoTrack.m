//
//  NSWindowController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindowController+FTAutoTrack.h"
#import "FTAutoTrackProtocol.h"
#import <objc/runtime.h>
#import <FTDateUtil.h>
#import <FTConstants.h>
#import "FTGlobalRumManager.h"
#import "NSView+FTAutoTrack.h"
@interface NSWindowController(FTAutoTrack)<FTRumViewProperty>
@end

@implementation NSWindowController (FTAutoTrack)
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
    return self.window.isMainWindow;
}
-(BOOL)datakit_isKeyWindow{
    return self.window.isKeyWindow;
}
-(NSString *)datakit_windowName{
    return NSStringFromClass(self.window.class);
}
#pragma mark - AutoTrack -

//即将加载nib
-(void)datakit_windowWillLoad{
    self.datakit_viewLoadStartTime =[NSDate date];
    [self datakit_windowWillLoad];
}
//加载nib之后
- (void)datakit_windowDidLoad{
    [self datakit_windowDidLoad];
    if(!self.window.contentViewController){
        // 记录 window 的生命周期
        if(self.datakit_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.datakit_viewLoadStartTime toDate:[NSDate date]];
            self.datakit_loadDuration = loadTime;
            self.datakit_viewLoadStartTime = nil;
            self.datakit_viewUUID = [NSUUID UUID].UUIDString;
//            [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
            ZYErrorLog(@"NSWindowController windowDidLoad:%@ \n viewcontroller: %@",self.window,self.contentViewController);

        }
    }
    
}
- (void)datakit_windowWillClose:(NSNotification *)notification{
    if(!self.window.contentViewController){
        ZYErrorLog(@"NSWindowController WillClose:%@ \n viewcontroller: %@",self.window,self.contentViewController);

//        [[FTGlobalRumManager sharedInstance] trackViewDidDisappear:self];
    }
    [self datakit_windowWillClose:notification];
}

@end
