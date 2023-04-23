//
//  FTGlobalRumManager.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2020/4/14.
//  Copyright © 2020 hll. All rights reserved.
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif
#import "FTResourceMetricsModel.h"
#import "FTResourceContentModel.h"
#import "FTSDKAgent+Private.h"
#import "FTGlobalRumManager+Private.h"
#import "FTLog.h"
#import "FTDateUtil.h"
#import "FTJSONUtil.h"
#import "FTUncaughtExceptionHandler.h"
#import "FTAppLifeCycle.h"
#import "FTRUMMonitor.h"
#import "FTWKWebViewHandler.h"
#import "FTANRDetector.h"
#import "FTAppLaunchTracker.h"
#import "FTConstants.h"
#import "FTPingThread.h"
#import "FTURLSessionAutoInstrumentation.h"

@interface FTGlobalRumManager ()<FTAppLifeCycleDelegate,FTWKWebViewRumDelegate,FTAppLaunchDataDelegate,FTANRDetectorDelegate>
@property (nonatomic, strong) FTSDKConfig *config;
@property (nonatomic, strong) FTRumConfig *rumConfig;
@property (nonatomic, assign) CFTimeInterval launch;
@property (nonatomic, strong) NSDate *launchTime;
@property (nonatomic, strong) FTRUMMonitor *monitor;
@property (nonatomic, strong) FTPingThread *pingThread;
@property (nonatomic, strong) FTAppLaunchTracker *launchTracker;

@end

@implementation FTGlobalRumManager
static FTGlobalRumManager *sharedManager = nil;
static dispatch_once_t onceToken;
-(instancetype)init{
    self = [super init];
    if (self) {
        _launchTime = [NSDate date];
        [[FTAppLifeCycle sharedInstance] addAppLifecycleDelegate:self];
    }
    return self;
}
+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:NULL] init];
    });
    return sharedManager;
}
-(void)setRumConfig:(FTRumConfig *)rumConfig{
    _rumConfig = rumConfig;
    if (self.rumConfig.appid.length<=0) {
        ZYErrorLog(@"RumConfig appid 数据格式有误，未能开启 RUM");
        return;
    }
    self.monitor = [[FTRUMMonitor alloc]initWithMonitorType:(DeviceMetricsMonitorType)rumConfig.deviceMetricsMonitorType frequency:(MonitorFrequency)rumConfig.monitorFrequency];
    self.rumManager = [[FTRUMManager alloc]initWithRumSampleRate:rumConfig.sampleRate errorMonitorType:(ErrorMonitorType)rumConfig.errorMonitorType monitor:self.monitor wirter:[FTSDKAgent sharedInstance]];
    if(rumConfig.enableTrackAppCrash){
        [[FTUncaughtExceptionHandler sharedHandler] addErrorDataDelegate:self.rumManager];
    }

    if(rumConfig.enableTrackAppCrash){
        [[FTUncaughtExceptionHandler sharedHandler] addErrorDataDelegate:self.rumManager];
    }
    self.launchTracker = [[FTAppLaunchTracker alloc]initWithDelegate:self];
    //采集view、resource、jsBridge
    dispatch_async(dispatch_get_main_queue(), ^{
        if (rumConfig.enableTrackAppFreeze) {
            [self startPingThread];
        }else{
            [self stopPingThread];
        }
        if (rumConfig.enableTrackAppANR) {
            [FTANRDetector sharedInstance].delegate = self;
            [[FTANRDetector sharedInstance] startDetecting];
        }else{
            [[FTANRDetector sharedInstance] stopDetecting];
        }
    });
    [FTWKWebViewHandler sharedInstance].rumTrackDelegate = self;
}

-(FTPingThread *)pingThread{
    if (!_pingThread || _pingThread.isCancelled) {
        _pingThread = [[FTPingThread alloc]init];
        __weak typeof(self) weakSelf = self;
        _pingThread.block = ^(NSString * _Nonnull stackStr, NSDate * _Nonnull startDate, NSDate * _Nonnull endDate) {
            [weakSelf trackAppFreeze:stackStr duration:[FTDateUtil nanosecondTimeIntervalSinceDate:startDate toDate:endDate]];
        };
    }
    return _pingThread;
}
-(void)startPingThread{
    if (!self.pingThread.isExecuting) {
        [self.pingThread start];
    }
}
-(void)stopPingThread{
    if (_pingThread && _pingThread.isExecuting) {
        [self.pingThread cancel];
    }
}
- (void)trackAppFreeze:(NSString *)stack duration:(NSNumber *)duration{
    [self.rumManager addLongTaskWithStack:stack duration:duration property:nil];
}
-(void)stopMonitor{
    [self stopPingThread];
}
#pragma mark ========== AUTO TRACK ==========
- (void)applicationWillTerminate{
    @try {
        [self.rumManager applicationWillTerminate];
    }@catch (NSException *exception) {
        ZYErrorLog(@"applicationWillResignActive exception %@",exception);
    }
}
-(void)addClickActionWithName:(NSString *)actionName{
    [self.rumManager addActionName:actionName actionType:@"click"];
}
- (void)addActionName:(nonnull NSString *)actionName actionType:(nonnull NSString *)actionType {
    [self.rumManager addActionName:actionName actionType:actionType];
}

- (void)addActionName:(nonnull NSString *)actionName actionType:(nonnull NSString *)actionType property:(nullable NSDictionary *)property {
    [self.rumManager addActionName:actionName actionType:actionType property:property];
}

- (void)addErrorWithType:(nonnull NSString *)type message:(nonnull NSString *)message stack:(nonnull NSString *)stack {
    [self.rumManager addErrorWithType:type message:message stack:stack];
}

- (void)addErrorWithType:(nonnull NSString *)type message:(nonnull NSString *)message stack:(nonnull NSString *)stack property:(nullable NSDictionary *)property {
    [self.rumManager addErrorWithType:type message:message stack:stack property:property];
}
- (void)addLongTaskWithStack:(nonnull NSString *)stack duration:(nonnull NSNumber *)duration {
    [self.rumManager addLongTaskWithStack:stack duration:duration];
}
- (void)addLongTaskWithStack:(nonnull NSString *)stack duration:(nonnull NSNumber *)duration property:(nullable NSDictionary *)property {
    [self.rumManager addLongTaskWithStack:stack duration:duration property:property];
}
- (void)onCreateView:(nonnull NSString *)viewName loadTime:(nonnull NSNumber *)loadTime {
    [self.rumManager onCreateView:viewName loadTime:loadTime];
}
- (void)startViewWithName:(nonnull NSString *)viewName {
    [self.rumManager startViewWithName:viewName];
}
- (void)startViewWithName:(nonnull NSString *)viewName property:(nullable NSDictionary *)property {
    [self.rumManager startViewWithName:viewName property:property];
}
- (void)stopView {
    [self.rumManager stopView];
}
- (void)stopViewWithProperty:(nullable NSDictionary *)property {
    [self.rumManager stopViewWithProperty:property];
}

- (void)startResourceWithKey:(nonnull NSString *)key {
    [[FTURLSessionAutoInstrumentation sharedInstance].externalResourceHandler startResourceWithKey:key];
}

- (void)startResourceWithKey:(nonnull NSString *)key property:(nullable NSDictionary *)property {
    [[FTURLSessionAutoInstrumentation sharedInstance].externalResourceHandler startResourceWithKey:key property:property];

}

- (void)stopResourceWithKey:(nonnull NSString *)key {
    [[FTURLSessionAutoInstrumentation sharedInstance].externalResourceHandler stopResourceWithKey:key];
}

- (void)stopResourceWithKey:(nonnull NSString *)key property:(nullable NSDictionary *)property {
    [[FTURLSessionAutoInstrumentation sharedInstance].externalResourceHandler stopResourceWithKey:key property:property];
}
- (void)addResourceWithKey:(nonnull NSString *)key metrics:(nullable FTResourceMetricsModel *)metrics content:(nonnull FTResourceContentModel *)content {
    [[FTURLSessionAutoInstrumentation sharedInstance].externalResourceHandler addResourceWithKey:key metrics:metrics content:content];
}
#pragma mark ========== APP LAUNCH ==========
-(void)ftAppHotStart:(NSNumber *)duration{
    [self.rumManager addLaunch:FTLaunchHot duration:duration];
    if (self.rumManager.viewReferrer) {
        NSString *viewid = [NSUUID UUID].UUIDString;
        NSString *viewReferrer =self.rumManager.viewReferrer;
        self.rumManager.viewReferrer = @"";
        [self.rumManager onCreateView:viewReferrer loadTime:@0];
        [self.rumManager startViewWithViewID:viewid viewName:viewReferrer property:nil];
    }
}
-(void)ftAppColdStart:(NSNumber *)duration isPreWarming:(BOOL)isPreWarming{
    [self.rumManager addLaunch:isPreWarming?FTLaunchWarm:FTLaunchCold duration:duration];
}
#pragma mark ========== FTANRDetectorDelegate ==========
- (void)onMainThreadSlowStackDetected:(NSString*)slowStack{
    [self.rumManager addLongTaskWithStack:slowStack duration:[NSNumber numberWithLongLong:MXRMonitorRunloopOneStandstillMillisecond*MXRMonitorRunloopStandstillCount*1000000]];
}
#pragma mark ========== 注销 ==========
-(void)rumDeinitialize{
    _rumManager = nil;
    onceToken = 0;
    sharedManager =nil;
    [[FTAppLifeCycle sharedInstance] removeAppLifecycleDelegate:self];
}
@end
