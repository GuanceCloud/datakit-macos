//
//  FTTrackConfig.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 Guance-cn. All rights reserved.
//

#import "FTSDKConfig.h"
#import "FTBaseInfoHandler.h"
@interface FTSDKConfig()<NSCopying>
@end
@implementation FTSDKConfig
-(instancetype)initWithMetricsUrl:(NSString *)metricsUrl{
    if (self = [super init]) {
        _metricsUrl = metricsUrl;
        _service = @"df_rum_macos";
        _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    FTSDKConfig *options = [[[self class] allocWithZone:nil] init];
    options.metricsUrl = self.metricsUrl;
    options.env = self.env;
    options.service = self.service;
    options.enableSDKDebugLog = self.enableSDKDebugLog;
    options.globalContext = self.globalContext;
    options.version = self.version;
    return options;
}
@end

@implementation FTRumConfig
- (instancetype)init{
    return [self initWithAppid:@""];
}
- (instancetype)initWithAppid:(nonnull NSString *)appid{
    self = [super init];
    if (self) {
        _appid = appid;
        _enableTrackAppCrash= NO;
        _sampleRate = 100;
    }
    return self;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    FTRumConfig *options = [[[self class] allocWithZone:zone] init];
    options.enableTrackAppCrash = self.enableTrackAppCrash;
    options.sampleRate = self.sampleRate;
    options.appid = self.appid;
    options.enableTrackAppANR = self.enableTrackAppANR;
    options.enableTraceUserView = self.enableTraceUserView;
    options.enableTrackAppFreeze = self.enableTrackAppFreeze;
    options.enableTraceUserAction = self.enableTraceUserAction;
    options.enableTraceUserResource = self.enableTraceUserResource;
    options.errorMonitorType = self.errorMonitorType;
    options.monitorFrequency = self.monitorFrequency;
    options.deviceMetricsMonitorType = self.deviceMetricsMonitorType;
    options.globalContext = self.globalContext;
    return options;
}
@end
@implementation FTLoggerConfig
-(instancetype)init{
    self = [super init];
    if (self) {
        _sampleRate = 100;
        _enableConsoleLog = NO;
        _enableLinkRumData = NO;
        _enableCustomLog = NO;
        _prefix = @"";
        _logLevelFilter = @[@0,@1,@2,@3,@4];
    }
    return self;
}
- (void)enableConsoleLog:(BOOL)enable prefix:(NSString *)prefix{
    _enableConsoleLog = enable;
    _prefix = prefix;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    FTLoggerConfig *options = [[[self class] allocWithZone:zone] init];
    options.sampleRate = self.sampleRate;
    options.enableConsoleLog = self.enableConsoleLog;
    options.enableLinkRumData = self.enableLinkRumData;
    options.enableCustomLog = self.enableCustomLog;
    options.prefix = self.prefix;
    options.logLevelFilter = self.logLevelFilter;
    options.discardType = self.discardType;
    options.globalContext = self.globalContext;
    return options;
}
@end
@implementation FTTraceConfig
-(instancetype)init{
    self = [super init];
    if (self) {
        _sampleRate= 100;
        _networkTraceType = FTNetworkTraceTypeDDtrace;
    }
    return self;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    FTTraceConfig *options = [[[self class] allocWithZone:zone] init];
    options.sampleRate = self.sampleRate;
    options.enableLinkRumData = self.enableLinkRumData;
    options.networkTraceType = self.networkTraceType;
    options.enableAutoTrace = self.enableAutoTrace;
    return options;
}
@end
