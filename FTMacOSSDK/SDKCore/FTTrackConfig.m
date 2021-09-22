//
//  FTTrackConfig.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import "FTTrackConfig.h"
@interface FTTrackConfig()<NSCopying>
@end
@implementation FTTrackConfig
-(instancetype)initWithMetricsUrl:(NSString *)metricsUrl{
    if (self = [super init]) {
        _metricsUrl = metricsUrl;
        _XDataKitUUID = [FTTrackConfig XDataKitUUID];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    FTTrackConfig *options = [[[self class] allocWithZone:nil] init];
    options.metricsUrl = self.metricsUrl;
    options.XDataKitUUID = self.XDataKitUUID;
    return options;
}
+ (NSString *)XDataKitUUID{
    NSString *deviceId;
    deviceId = [[NSUserDefaults standardUserDefaults] valueForKey:@"FTSDKUUID"];
    if (!deviceId) {
        deviceId = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setValue:deviceId forKey:@"FTSDKUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return deviceId;
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
        _samplerate = 100;
        _enableTrackAppFreeze = NO;
        _enableTrackAppANR = NO;
        _enableTraceUserAction = NO;
    }
    return self;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    FTRumConfig *options = [[[self class] allocWithZone:zone] init];
    options.enableTrackAppCrash = self.enableTrackAppCrash;
    options.samplerate = self.samplerate;
    options.enableTrackAppFreeze = self.enableTrackAppFreeze;
    options.enableTrackAppANR = self.enableTrackAppANR;
    options.enableTraceUserAction = self.enableTraceUserAction;
    options.appid = self.appid;
    return options;
}
@end
@implementation FTLoggerConfig
-(instancetype)init{
    self = [super init];
    if (self) {
        _service = @"df_rum_macos";;
        _samplerate = 100;
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
    options.service = self.service;
    options.samplerate = self.samplerate;
    options.enableConsoleLog = self.enableConsoleLog;
    options.enableLinkRumData = self.enableLinkRumData;
    options.enableCustomLog = self.enableCustomLog;
    options.prefix = self.prefix;
    options.logLevelFilter = self.logLevelFilter;
    return options;
}
@end
