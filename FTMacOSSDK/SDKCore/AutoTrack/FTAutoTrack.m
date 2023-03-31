//
//  FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "FTAutoTrack.h"
#import <FTLog.h>
#import <FTSwizzle.h>
#import "NSViewController+FTAutoTrack.h"
#import "NSWindowController+FTAutoTrack.h"
#import "NSWindow+FTAutoTrack.h"
#import "NSApplication+FTAutotrack.h"
#import "NSGestureRecognizer+FTAutoTrack.h"
#import "NSCollectionView+FTAutoTrack.h"
#import "NSTabView+FTAutoTrack.h"
@implementation FTAutoTrack

+ (instancetype)sharedInstance {
    static FTAutoTrack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)startHookView:(BOOL)enableView action:(BOOL)enableAction{
    if(enableView){
        [self logWindowLifeCycle];
//        [self logViewControllerLifeCycle];
    }
    if(enableAction){
        [self logTargetAction];
    }
}
- (void)logWindowLifeCycle{
    @try {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSError *error = NULL;
            [NSWindow ft_swizzleMethod:@selector(initWithCoder:) withMethod:@selector(datakit_initWithCoder:) error:&error];
            [NSWindow ft_swizzleMethod:@selector(initWithContentRect:styleMask:backing:defer:) withMethod:@selector(datakit_initWithContentRect:styleMask:backing:defer:) error:&error];
            [NSWindow ft_swizzleMethod:@selector(init) withMethod:@selector(datakit_init) error:&error];
            [NSWindow ft_swizzleMethod:@selector(close) withMethod:@selector(datakit_close) error:&error];
            [NSWindow ft_swizzleMethod:@selector(becomeKeyWindow) withMethod:@selector(datakit_becomeKeyWindow) error:&error];
            [NSWindow ft_swizzleMethod:@selector(makeKeyWindow) withMethod:@selector(datakit_makeKeyWindow) error:&error];
            [NSWindowController ft_swizzleMethod:@selector(windowWillLoad) withMethod:@selector(datakit_windowWillLoad) error:&error];
            [NSWindowController ft_swizzleMethod:@selector(windowDidLoad) withMethod:@selector(datakit_windowDidLoad) error:&error];
            [NSWindowController ft_swizzleMethod:@selector(windowWillClose:) withMethod:@selector(datakit_windowWillClose:) error:&error];
        });
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception: %@", self, exception);
    }
}
//- (void)logViewControllerLifeCycle{
//    @try {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            NSError *error = NULL;
//            [NSViewController ft_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(datakit_viewDidLoad) error:&error];
//            [NSViewController ft_swizzleMethod:@selector(viewDidAppear) withMethod:@selector(datakit_viewDidAppear) error:&error];
//            [NSViewController ft_swizzleMethod:@selector(viewDidDisappear) withMethod:@selector(datakit_viewDidDisappear) error:&error];
//        });
//    } @catch (NSException *exception) {
//        ZYErrorLog(@"exception: %@", self, exception);
//    }
//
//}
- (void)logTargetAction{
    @try {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSError *error = NULL;
            [NSApplication ft_swizzleMethod:@selector(sendAction:to:from:) withMethod:@selector(datakit_sendAction:to:from:) error:&error];
            [NSGestureRecognizer ft_swizzleMethod:@selector(setAction:) withMethod:@selector(datakit_setAction:) error:&error];
            [NSGestureRecognizer ft_swizzleMethod:@selector(setTarget:) withMethod:@selector(datakit_setTarget:) error:&error];
            [NSCollectionView ft_swizzleMethod:@selector(setDelegate:) withMethod:@selector(datakit_setDelegate:) error:&error];
            [NSTabView ft_swizzleMethod:@selector(setDelegate:) withMethod:@selector(datakit_setDelegate:) error:&error];
        });
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception: %@", self, exception);
    }
}
@end
