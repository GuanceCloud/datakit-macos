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
static char *viewLoadStartTimeKey = "viewLoadStartTimeKey";
static char *viewControllerUUID = "viewControllerUUID";
static char *viewLoadDuration = "viewLoadDuration";
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
-(NSString *)ft_viewControllerId{
    return [self.ft_viewControllerName ft_md5HashToUpper32Bit];
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
    return nil;
}
-(BOOL)dataflux_inMainWindow{
    return self.view.window.isMainWindow;
}
-(BOOL)dataflux_isKeyWindow{
    return self.view.window.isKeyWindow;
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
    
    if(self.dataflux_viewLoadStartTime){
        NSNumber *loadTime = [FTDateUtil nanotimeIntervalSinceDate:[NSDate date] toDate:self.dataflux_viewLoadStartTime];
        self.dataflux_loadDuration = loadTime;
        self.dataflux_viewLoadStartTime = nil;
    }else{
        NSNumber *loadTime = @0;
        self.dataflux_loadDuration = loadTime;
    }
    self.dataflux_viewUUID = [NSUUID UUID].UUIDString;
    [[FTRumManager sharedInstance] addViewAppearEvent:self];
    NSLog(@"dataflux_viewDidAppear = %@",self);
}
-(void)dataflux_viewDidDisappear{
    
    [self dataflux_viewDidDisappear];
    if ([self isKindOfClass:NSCollectionViewItem.class]) {
        return;
    }
    NSLog(@"dataflux_viewDidDisappear = %@",self);
    
    [[FTRumManager sharedInstance] addViewDisappearEvent:self];
    
    
}

@end
