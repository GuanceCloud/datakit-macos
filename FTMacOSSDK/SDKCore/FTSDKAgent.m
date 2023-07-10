//
//  FTSDKAgent.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 Guance-cn. All rights reserved.
//

#import "FTSDKAgent.h"
#import "FTSDKConfig.h"
#import "FTReachability.h"
#import "FTTrackDataManager.h"
#import "FTRecordModel.h"
#import "FTInternalLog.h"
#import "FTDateUtil.h"
#import "FTConstants.h"
#import "FTBaseInfoHandler.h"
#import "NSString+FTAdd.h"
#import "FTGlobalRumManager+Private.h"
#import "FTPresetProperty.h"
#import "FTEnumConstant.h"
#import "FTTrackerEventDBTool.h"
#import "FTMacOSSDKVersion.h"
#import "FTWKWebViewHandler.h"
#import "FTNetworkInfoManager.h"
#import "FTURLSessionAutoInstrumentation.h"
#import "FTUserInfo.h"
#import "FTAutoTrack.h"
#import "FTURLProtocol.h"
#import "FTLogger+Private.h"
@interface FTSDKAgent()<FTLoggerDataWriteProtocol>
@property (nonatomic, strong) FTLoggerConfig *loggerConfig;
@property (nonatomic, strong) FTPresetProperty *presetProperty;
@property (nonatomic, copy) NSString *netTraceStr;
@property (nonatomic, strong) FTAutoTrack *autotrack;
@end
@implementation FTSDKAgent
static FTSDKAgent *sharedInstance = nil;
static dispatch_once_t onceToken;

+ (void)startWithConfigOptions:(FTSDKConfig *)configOptions{
    NSAssert ((strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0),@"SDK 必须在主线程里进行初始化，否则会引发无法预料的问题（比如丢失 launch 事件）。");
    
    NSAssert((configOptions.metricsUrl.length!=0 ), @"请设置FT-GateWay metrics 写入地址");
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FTSDKAgent alloc] initWithConfig:configOptions];
    });
}
// 单例
+ (instancetype)sharedInstance {
    NSAssert(sharedInstance, @"请先使用 startWithConfigOptions: 初始化 SDK");
    return sharedInstance;
}
-(instancetype)initWithConfig:(FTSDKConfig *)config{
    self = [super init];
    if(self){
        [FTInternalLog enableLog:config.enableSDKDebugLog];
        NSString *serialLabel = [NSString stringWithFormat:@"ft.serialLabel.%p", self];
        //开启数据处理管理器
        NSString *bundleIdentifier = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleIdentifier"];
        [FTTrackerEventDBTool shareDatabaseWithPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] dbName:[NSString stringWithFormat:@"com.cloudcare.ft.macos.sdk-%@.sqlite",bundleIdentifier]];
        [FTTrackDataManager sharedInstance];
        _presetProperty = [[FTPresetProperty alloc] initWithVersion:config.version env:config.env service:config.service globalContext:config.globalContext];
        _presetProperty.sdkVersion = SDK_VERSION;
        [FTNetworkInfoManager sharedInstance].setMetricsUrl(config.metricsUrl)
            .setSdkVersion(SDK_VERSION);
        [[FTURLSessionAutoInstrumentation sharedInstance] setSdkUrlStr:config.metricsUrl];
    }
    return self;
}
-(void)startRumWithConfigOptions:(FTRumConfig *)rumConfigOptions{
    NSAssert((rumConfigOptions.appid.length!=0 ), @"请设置 appid 用户访问监测应用ID");
    [self.presetProperty setAppid:rumConfigOptions.appid];
    self.presetProperty.rumContext = [rumConfigOptions.globalContext copy];
    [[FTGlobalRumManager sharedManager] setRumConfig:rumConfigOptions];
    [[FTURLSessionAutoInstrumentation sharedInstance] setRUMEnableTraceUserResource:rumConfigOptions.enableTraceUserResource];
    [[FTURLSessionAutoInstrumentation sharedInstance] setRumResourceHandler:[FTGlobalRumManager sharedManager].rumManager];
    [FTAutoTrack sharedInstance].addRumDatasDelegate = [FTGlobalRumManager sharedManager];
    [[FTAutoTrack sharedInstance] startHookView:rumConfigOptions.enableTraceUserView action:rumConfigOptions.enableTraceUserAction];

}
- (void)startLoggerWithConfigOptions:(FTLoggerConfig *)loggerConfigOptions{
    if (!_loggerConfig) {
        self.loggerConfig = [loggerConfigOptions copy];
        self.presetProperty.logContext = [self.loggerConfig.globalContext copy];
        [FTTrackerEventDBTool sharedManger].discardNew = (loggerConfigOptions.discardType == FTDiscard);
        [FTLogger startWithEablePrintLogsToConsole:loggerConfigOptions.printLogsToConsole enableCustomLog:loggerConfigOptions.enableCustomLog logLevelFilter:loggerConfigOptions.logLevelFilter sampleRate:loggerConfigOptions.sampleRate writer:self];
    }
}
- (void)startTraceWithConfigOptions:(FTTraceConfig *)traceConfigOptions{
    _netTraceStr = FTNetworkTraceStringMap[traceConfigOptions.networkTraceType];
    [FTWKWebViewHandler sharedInstance].enableTrace = traceConfigOptions.enableAutoTrace;
    [FTWKWebViewHandler sharedInstance].interceptor = [FTURLSessionAutoInstrumentation sharedInstance].interceptor;
    [[FTURLSessionAutoInstrumentation sharedInstance] setTraceEnableAutoTrace:traceConfigOptions.enableAutoTrace enableLinkRumData:traceConfigOptions.enableLinkRumData sampleRate:traceConfigOptions.sampleRate traceType:(NetworkTraceType)traceConfigOptions.networkTraceType];
}
#pragma mark ========== publick method ==========
- (void)isIntakeUrl:(BOOL(^)(NSURL *url))handler{
    if(handler){
        [[FTURLSessionAutoInstrumentation sharedInstance] setIntakeUrlHandler:handler];
    }
}
-(void)logging:(NSString *)content status:(FTLogStatus)status{
    [self logging:content status:status property:nil];
}
-(void)logging:(NSString *)content status:(FTLogStatus)status property:(NSDictionary *)property{
    @try {
        if (!self.loggerConfig) {
            FTInnerLogError(@"[Logging] 请先设置 FTLoggerConfig");
            return;
        }
        if (!content || content.length == 0 ) {
            FTInnerLogError(@"[Logging] 传入的第数据格式有误");
            return;
        }
        [[FTLogger sharedInstance] log:content status:(LogStatus)status property:property];
    } @catch (NSException *exception) {
        FTInnerLogError(@"exception %@",exception);
    }
}
//用户绑定
- (void)bindUserWithUserID:(NSString *)Id{
    [self bindUserWithUserID:Id userName:nil userEmail:nil extra:nil];
}
-(void)bindUserWithUserID:(NSString *)Id userName:(NSString *)userName userEmail:(nullable NSString *)userEmail{
    [self bindUserWithUserID:Id userName:userName userEmail:userEmail extra:nil];
}
-(void)bindUserWithUserID:(NSString *)Id userName:(NSString *)userName userEmail:(nullable NSString *)userEmail extra:(NSDictionary *)extra{
    NSParameterAssert(Id);
    [self.presetProperty.userHelper concurrentWrite:^(FTUserInfo * _Nonnull value) {
        [value updateUser:Id name:userName email:userEmail extra:extra];
    }];
    FTInnerLogInfo(@"Bind User ID : %@ , Name : %@ , Email : %@ , Extra : %@",Id,userName,userEmail,extra);
}
//用户注销
- (void)unbindUser{
    [self.presetProperty.userHelper concurrentWrite:^(FTUserInfo * _Nonnull value) {
        [value clearUser];
    }];
    FTInnerLogInfo(@"User Logout");
}
- (void)shutDown{
    [[FTTrackerEventDBTool sharedManger] insertCacheToDB];
    [[FTGlobalRumManager sharedManager] rumDeinitialize];
    [[FTLogger sharedInstance] shutDown];
    [[FTURLSessionAutoInstrumentation sharedInstance] resetInstance];
    [FTURLProtocol stopMonitor];
    onceToken = 0;
    sharedInstance =nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    FTInnerLogInfo(@"[SDK] SHUT DOWN");
}
#pragma mark ========== private method ==========
-(void)logging:(NSString *)content status:(LogStatus)status tags:(nullable NSDictionary *)tags field:(nullable NSDictionary *)field tm:(long long)tm{
    @try {
        NSString *newContent = [content ft_subStringWithCharacterLength:FT_LOGGING_CONTENT_SIZE];
        NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:[self.presetProperty loggerPropertyWithStatus:(LogStatus)status]];
        if (tags) {
            [tagDict addEntriesFromDictionary:tags];
        }
        if (self.loggerConfig.enableLinkRumData) {
            [tagDict addEntriesFromDictionary:[self.presetProperty rumProperty]];
            if(![tags.allKeys containsObject:FT_RUM_KEY_SESSION_ID]){
                NSDictionary *rumTag = [[FTGlobalRumManager sharedManager].rumManager getCurrentSessionInfo];
                [tagDict addEntriesFromDictionary:rumTag];
            }
        }
        NSMutableDictionary *filedDict = @{FT_KEY_MESSAGE:newContent,
        }.mutableCopy;
        if (field) {
            [filedDict addEntriesFromDictionary:field];
        }
        FTRecordModel *model = [[FTRecordModel alloc]initWithSource:FT_LOGGER_SOURCE op:FT_DATA_TYPE_LOGGING tags:tagDict fields:filedDict tm:tm];
        [self insertDBWithItemData:model type:FTAddDataLogging];
    } @catch (NSException *exception) {
        FTInnerLogError(@"exception %@",exception);
    }
}
- (void)rumWrite:(NSString *)type  tags:(NSDictionary *)tags fields:(NSDictionary *)fields{
    [self rumWrite:type tags:tags fields:fields tm:[FTDateUtil currentTimeNanosecond]];
}
- (void)rumWrite:(NSString *)type tags:(NSDictionary *)tags fields:(NSDictionary *)fields tm:(long long)tm{
    
    @try {
        if (![type isKindOfClass:NSString.class] || type.length == 0) {
            return;
        }
        FTAddDataType dataType = FTAddDataImmediate;
        NSMutableDictionary *baseTags =[NSMutableDictionary dictionaryWithDictionary:tags];
        baseTags[@"network_type"] = [FTReachability sharedInstance].net;
        [baseTags addEntriesFromDictionary:[self.presetProperty rumProperty]];
        FTRecordModel *model = [[FTRecordModel alloc]initWithSource:type op:FT_DATA_TYPE_RUM tags:baseTags fields:fields tm:tm];
        [self insertDBWithItemData:model type:dataType];
    } @catch (NSException *exception) {
        FTInnerLogError(@"exception %@",exception);
    }
}
- (void)insertDBWithItemData:(FTRecordModel *)model type:(FTAddDataType)type{
    [[FTTrackDataManager sharedInstance] addTrackData:model type:type];
}
- (void)syncProcess{
    [[FTGlobalRumManager sharedManager].rumManager syncProcess];
    [[FTLogger sharedInstance] syncProcess];
}
@end
