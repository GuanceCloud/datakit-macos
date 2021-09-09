//
//  FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "FTAutoTrack.h"
#import "FTLog.h"
#import "FTSwizzle.h"
#import "NSViewController+FTAutoTrack.h"
#import "NSWindowController+FTAutoTrack.h"
#import "NSWindow+FTAutoTrack.h"
@implementation FTAutoTrack

-(instancetype)init{
    self = [super init];
    if (self) {
        [self startHook];
    }
    return self;
}

- (void)startHook{
    [self logWindowLifeCycle];
    [self logViewControllerLifeCycle];
    [self logTargetAction];
}
- (void)logWindowLifeCycle{
    @try {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSError *error = NULL;
            [NSWindowController ft_swizzleMethod:@selector(windowDidLoad) withMethod:@selector(ft_windowDidLoad) error:&error];
            [NSWindowController ft_swizzleMethod:@selector(windowWillClose:) withMethod:@selector(ft_windowWillClose:) error:&error];
        });
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception: %@", self, exception);
    }
}
- (void)logViewControllerLifeCycle{
    @try {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSError *error = NULL;
            [NSViewController ft_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(dataflux_viewDidLoad) error:&error];
            [NSViewController ft_swizzleMethod:@selector(viewDidAppear) withMethod:@selector(dataflux_viewDidAppear) error:&error];
            [NSViewController ft_swizzleMethod:@selector(viewDidDisappear) withMethod:@selector(dataflux_viewDidDisappear) error:&error];
        });
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception: %@", self, exception);
    }
    
}
- (void)logTargetAction{
    @try {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception: %@", self, exception);
    }
}
@end
