//
//  NSViewController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSViewController+FTAutoTrack.h"
#import "FTDateUtil.h"
#import <objc/runtime.h>
#import "NSString+FTAdd.h"
#import "FTRumManager.h"
#import "FTGlobalRumManager.h"
#import "FTConstants.h"
#import "FTBaseInfoHandler.h"
static char *viewLoadStartTimeKey = "viewLoadStartTimeKey";
static char *viewControllerUUID = "viewControllerUUID";
static char *viewLoadDuration = "viewLoadDuration";
static char *viewLoaded = "viewLoaded";

@implementation NSViewController (FTAutoTrack)
-(void)setDataflux_viewLoadStartTime:(NSDate  *)viewLoadStartTime{
    objc_setAssociatedObject(self, &viewLoadStartTimeKey, viewLoadStartTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDate *)dataflux_viewLoadStartTime{
    return objc_getAssociatedObject(self, &viewLoadStartTimeKey);
}
-(NSNumber *)dataflux_loadDuration{
    return objc_getAssociatedObject(self, &viewLoadDuration);
}
-(void)setDataflux_loadDuration:(NSNumber *)ft_loadDuration{
    objc_setAssociatedObject(self, &viewLoadDuration, ft_loadDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL )dataflux_viewLoaded{
    return [objc_getAssociatedObject(self, &viewLoaded) boolValue];
}
-(void)setDataflux_viewLoaded:(BOOL )dataflux_viewLoaded{
   objc_setAssociatedObject(self, &viewLoaded, [NSNumber numberWithBool:dataflux_viewLoaded], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)ft_viewControllerName{
    return NSStringFromClass([self class]);
}
-(NSString *)dataflux_viewUUID{
    return objc_getAssociatedObject(self, &viewControllerUUID);
}
-(void)setDataflux_viewUUID:(NSString *)ft_viewUUID{
    objc_setAssociatedObject(self, &viewControllerUUID, ft_viewUUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)dataflux_parentVC{
    if (self.parentViewController) {
        return NSStringFromClass(self.parentViewController.class);
    }
    return FT_NULL_VALUE;
}
-(BOOL)dataflux_inMainWindow{
    __block BOOL isMain = NO;
    [FTBaseInfoHandler performBlockDispatchMainSyncSafe:^{
        isMain = self.view.window.isMainWindow;
    }];
    return isMain;
}
-(BOOL)dataflux_isKeyWindow{
    __block BOOL isKey = NO;
    [FTBaseInfoHandler performBlockDispatchMainSyncSafe:^{
        isKey = self.view.window.isKeyWindow;
    }];
    return isKey;
}
-(NSString *)dataflux_windowName{
    return NSStringFromClass(self.view.window.class);
}
#pragma mark - AutoTrack -

- (void)dataflux_viewDidLoad{
    if (![self isKindOfClass:NSCollectionViewItem.class]) {
        self.dataflux_viewLoadStartTime =[NSDate date];
    }
    [self dataflux_viewDidLoad];
}
-(void)dataflux_viewDidAppear{
    
    [self dataflux_viewDidAppear];
    if ([self isKindOfClass:NSCollectionViewItem.class]) {
        return;
    }
    //NSTitlebarViewController、NSTitlebarAccessoryViewController
    if(!self.dataflux_viewLoaded){
        NSNumber *loadTime = [FTDateUtil nanosecondTimeIntervalSinceDate:self.dataflux_viewLoadStartTime toDate:[NSDate date]];
        self.dataflux_loadDuration = loadTime;
        self.dataflux_viewLoaded = YES;
    }else{
        NSNumber *loadTime = @0;
        self.dataflux_viewLoadStartTime = [NSDate date];
        self.dataflux_loadDuration = loadTime;
    }
    self.dataflux_viewUUID = [NSUUID UUID].UUIDString;
    [[FTGlobalRumManager sharedInstance] trackViewDidAppear:self];
}
-(void)dataflux_viewDidDisappear{
    
    [self dataflux_viewDidDisappear];
    if ([self isKindOfClass:NSCollectionViewItem.class]) {
        return;
    }    
    [[FTGlobalRumManager sharedInstance] trackViewDidDisappear:self];
}

@end
