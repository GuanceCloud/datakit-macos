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
-(void)setFt_viewLoadStartTime:(NSDate  *)viewLoadStartTime{
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
-(NSString *)ft_viewControllerId{
    return [self.ft_viewControllerName ft_md5HashToUpper32Bit];
}
- (NSString *)ft_viewControllerName{
    return NSStringFromClass([self class]);
}
-(NSString *)ft_viewUUID{
    return objc_getAssociatedObject(self, &viewControllerUUID);
}
-(void)setFt_viewUUID:(NSString *)ft_viewUUID{
    objc_setAssociatedObject(self, &viewControllerUUID, ft_viewUUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)dataflux_viewDidLoad{
    self.ft_viewLoadStartTime =[NSDate date];
    [self dataflux_viewDidLoad];
}
-(void)dataflux_viewDidAppear{
    
    [self dataflux_viewDidAppear];
    

        if(self.ft_viewLoadStartTime){
            NSNumber *loadTime = [FTDateUtil nanotimeIntervalSinceDate:[NSDate date] toDate:self.ft_viewLoadStartTime];
            self.ft_loadDuration = loadTime;
            self.ft_viewLoadStartTime = nil;
        }else{
            NSNumber *loadTime = @0;
            self.ft_loadDuration = loadTime;
        }
        self.ft_viewUUID = [NSUUID UUID].UUIDString;
    [[FTRumManager sharedInstance] addViewAppearEvent:self];
    NSLog(@"dataflux_viewDidAppear = %@",self);
}
-(void)dataflux_viewDidDisappear{
    
    [self dataflux_viewDidDisappear];
    NSLog(@"dataflux_viewDidDisappear = %@",self);

     [[FTRumManager sharedInstance] addViewDisappearEvent:self];

    
}

@end
