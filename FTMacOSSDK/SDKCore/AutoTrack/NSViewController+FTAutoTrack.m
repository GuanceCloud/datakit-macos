//
//  NSViewController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSViewController+FTAutoTrack.h"
#import <FTDateUtil.h>
#import <NSString+FTAdd.h>
#import <FTConstants.h>
#import <FTBaseInfoHandler.h>
#import <FTThreadDispatchManager.h>
#import <objc/runtime.h>
#import "FTGlobalRumManager.h"
#import "FTAutoTrack.h"
static char *viewLoadStartTimeKey = "viewLoadStartTimeKey";
static char *viewControllerUUID = "viewControllerUUID";
static char *viewLoadDuration = "viewLoadDuration";
static char *viewLoaded = "viewLoaded";

@implementation NSViewController (FTAutoTrack)
-(void)setDatakit_viewLoadStartTime:(NSDate  *)viewLoadStartTime{
    objc_setAssociatedObject(self, &viewLoadStartTimeKey, viewLoadStartTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDate *)datakit_viewLoadStartTime{
    return objc_getAssociatedObject(self, &viewLoadStartTimeKey);
}
-(NSNumber *)datakit_loadDuration{
    return objc_getAssociatedObject(self, &viewLoadDuration);
}
-(void)setDatakit_loadDuration:(NSNumber *)ft_loadDuration{
    objc_setAssociatedObject(self, &viewLoadDuration, ft_loadDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL )datakit_viewLoaded{
    return [objc_getAssociatedObject(self, &viewLoaded) boolValue];
}
-(void)setDatakit_viewLoaded:(BOOL )datakit_viewLoaded{
   objc_setAssociatedObject(self, &viewLoaded, [NSNumber numberWithBool:datakit_viewLoaded], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)ft_viewControllerName{
    return NSStringFromClass([self class]);
}
-(NSString *)datakit_viewUUID{
    return objc_getAssociatedObject(self, &viewControllerUUID);
}
-(void)setDatakit_viewUUID:(NSString *)ft_viewUUID{
    objc_setAssociatedObject(self, &viewControllerUUID, ft_viewUUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)datakit_parentVC{
    if (self.parentViewController) {
        return NSStringFromClass(self.parentViewController.class);
    }
    return FT_NULL_VALUE;
}
-(BOOL)datakit_inMainWindow{
    __block BOOL isMain = NO;
    [FTThreadDispatchManager performBlockDispatchMainSyncSafe:^{
        isMain = self.view.window.isMainWindow;
    }];
    return isMain;
}
-(BOOL)datakit_isKeyWindow{
    __block BOOL isKey = NO;
    [FTThreadDispatchManager performBlockDispatchMainSyncSafe:^{
        isKey = self.view.window.isKeyWindow;
    }];
    return isKey;
}
-(NSString *)datakit_windowName{
    return NSStringFromClass(self.view.window.class);
}
#pragma mark - AutoTrack -

- (void)datakit_viewDidLoad{
    if (![self isKindOfClass:NSCollectionViewItem.class]) {
        self.datakit_viewLoadStartTime =[NSDate date];
        ZYErrorLog(@"%@ viewDidLoad",self.class);
    }
    [self datakit_viewDidLoad];
}
-(void)datakit_viewDidAppear{

    [self datakit_viewDidAppear];
    // NSPanel 类型
    if ([self isKindOfClass:NSCollectionViewItem.class]||[self.view.window isKindOfClass:[NSPanel class]]) {
        return;
    }
    ZYErrorLog(@"%@ viewDidAppear",self.class);
    //NSTitlebarViewController、NSTitlebarAccessoryViewController
    if(!self.datakit_viewLoaded){
        NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.datakit_viewLoadStartTime toDate:[NSDate date]];
        self.datakit_loadDuration = loadTime;
        self.datakit_viewLoaded = YES;
    }else{
        NSNumber *loadTime = @0;
        self.datakit_viewLoadStartTime = [NSDate date];
        self.datakit_loadDuration = loadTime;
    }
    self.datakit_viewUUID = [NSUUID UUID].UUIDString;
//    [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
}
-(void)datakit_viewDidDisappear{

    [self datakit_viewDidDisappear];
    if ([self isKindOfClass:NSCollectionViewItem.class]) {
        return;
    }
    ZYDebug(@"%@ viewDidDisappear",self.class);

//    [[FTGlobalRumManager sharedInstance] trackViewDidDisappear:self];
}

@end
