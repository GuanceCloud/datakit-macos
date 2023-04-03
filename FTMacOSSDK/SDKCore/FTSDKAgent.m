//
//  FTSDKAgent.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 Guance-cn. All rights reserved.
//

#import "FTSDKAgent.h"
#import "FTSDKConfig.h"
#import <FTReachability.h>
#import <FTTrackDataManager.h>
#import <FTRecordModel.h>
#import <FTLog.h>
#import <FTDateUtil.h>
#import <FTConstants.h>
#import <FTBaseInfoHandler.h>
#import <NSString+FTAdd.h>
#import "FTGlobalRumManager+Private.h"
#import <FTPresetProperty.h>
#import <FTEnumConstant.h>
#import <FTTrackerEventDBTool.h>
#import "FTMacOSSDKVersion.h"
#import <FTWKWebViewHandler.h>
#import <FTLogHook.h>
#import "FTAutoTrack.h"
@interface FTSDKAgent()
@property (nonatomic, strong) FTLoggerConfig *loggerConfig;
@property (nonatomic, strong) FTPresetProperty *presetProperty;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSSet *logLevelFilterSet;
@property (nonatomic, copy) NSString *netTraceStr;
@property (nonatomic, strong) FTAutoTrack *autotrack;
@end
@implementation FTSDKAgent
static FTSDKAgent *sharedInstance = nil;

+ (void)startWithConfigOptions:(FTSDKConfig *)configOptions{
    NSAssert ((strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0),@"SDK 必须在主线程里进行初始化，否则会引发无法预料的问题（比如丢失 launch 事件）。");
    
    NSAssert((configOptions.metricsUrl.length!=0 ), @"请设置FT-GateWay metrics 写入地址");
    static dispatch_once_t onceToken;
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
        [FTLog enableLog:config.enableSDKDebugLog];
        NSString *serialLabel = [NSString stringWithFormat:@"ft.serialLabel.%p", self];
        _serialQueue = dispatch_queue_create([serialLabel UTF8String], DISPATCH_QUEUE_SERIAL);
        //开启数据处理管理器
        [FTTrackDataManager sharedInstance];
        _presetProperty = [[FTPresetProperty alloc] initWithVersion:config.version env:(Env)config.env service:config.service globalContext:config.globalContext];
        _presetProperty.sdkVersion = SDK_VERSION;
        [FTNetworkInfoManager sharedInstance].setMetricsUrl(config.metricsUrl)
        .setSdkVersion(SDK_VERSION)
        .setXDataKitUUID(config.XDataKitUUID);
        [[FTURLSessionAutoInstrumentation sharedInstance] setSdkUrlStr:config.metricsUrl];
    }
    return self;
}
-(void)startRumWithConfigOptions:(FTRumConfig *)rumConfigOptions{
    NSAssert((rumConfigOptions.appid.length!=0 ), @"请设置 appid 用户访问监测应用ID");
    [self.presetProperty setAppid:rumConfigOptions.appid];
    self.presetProperty.rumContext = [rumConfigOptions.globalContext copy];
    [[FTGlobalRumManager sharedInstance] setRumConfig:rumConfigOptions];
    [[FTURLSessionAutoInstrumentation sharedInstance] setRUMEnableTraceUserResource:rumConfigOptions.enableTraceUserResource];
    [[FTURLSessionAutoInstrumentation sharedInstance] setRumResourceHandler:[FTGlobalRumManager sharedInstance].rumManager];
    [FTAutoTrack sharedInstance].addRumDatasDelegate = [FTGlobalRumManager sharedInstance];
    [[FTAutoTrack sharedInstance] startHookView:rumConfigOptions.enableTraceUserView action:rumConfigOptions.enableTraceUserAction];

}
- (void)startLoggerWithConfigOptions:(FTLoggerConfig *)loggerConfigOptions{
    if (!_loggerConfig) {
        self.loggerConfig = [loggerConfigOptions copy];
        self.presetProperty.logContext = [self.loggerConfig.globalContext copy];
        self.logLevelFilterSet = [NSSet setWithArray:self.loggerConfig.logLevelFilter];
        [FTTrackerEventDBTool sharedManger].discardNew = (loggerConfigOptions.discardType == FTDiscard);
        if(self.loggerConfig.enableConsoleLog){
            [self _traceConsoleLog];
        }
    }
    self.loggerConfig = [loggerConfigOptions copy];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.logLevelFilterSet = [NSSet setWithArray:loggerConfigOptions.logLevelFilter];
    });
}
- (void)startTraceWithConfigOptions:(FTTraceConfig *)traceConfigOptions{
    _netTraceStr = FTNetworkTraceStringMap[traceConfigOptions.networkTraceType];
    [FTWKWebViewHandler sharedInstance].enableTrace = traceConfigOptions.enableAutoTrace;
    [FTWKWebViewHandler sharedInstance].interceptor = [FTURLSessionAutoInstrumentation sharedInstance].interceptor;
    [[FTURLSessionAutoInstrumentation sharedInstance] setTraceEnableAutoTrace:traceConfigOptions.enableAutoTrace enableLinkRumData:traceConfigOptions.enableLinkRumData sampleRate:traceConfigOptions.sampleRate traceType:(NetworkTraceType)traceConfigOptions.networkTraceType];
}
- (void)isIntakeUrl:(BOOL(^)(NSURL *url))handler{
    if(handler){
        [[FTURLSessionAutoInstrumentation sharedInstance] setIntakeUrlHandler:handler];
    }
}
//控制台日志采集
- (void)_traceConsoleLog{
    __weak typeof(self) weakSelf = self;
    [FTLogHook hookWithBlock:^(NSString * _Nonnull logStr,long long tm) {
            if (!weakSelf.loggerConfig.enableConsoleLog ) {
                return;
            }
            if (weakSelf.loggerConfig.prefix.length>0) {
                if([logStr containsString:weakSelf.loggerConfig.prefix]){
                    [weakSelf logging:logStr status:FTStatusInfo tags:nil field:nil tm:tm];
                }
            }else{
                [weakSelf logging:logStr status:FTStatusInfo tags:nil field:nil tm:tm];
            }
    }];
}
#pragma mark - 数据写入 -

-(void)logging:(NSString *)content status:(FTLogStatus)status{
    [self logging:content status:status property:nil];
}
-(void)logging:(NSString *)content status:(FTLogStatus)status property:(NSDictionary *)property{
    @try {
        if (!self.loggerConfig) {
            ZYErrorLog(@"请先设置 FTLoggerConfig");
            return;
        }
        if (!self.loggerConfig.enableCustomLog) {
            ZYLog(@"enableCustomLog 未开启，数据不进行采集");
            return;
        }
        [self logging:content status:status tags:nil field:property tm:[FTDateUtil currentTimeNanosecond]];
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception %@",exception);
    }
}
// FT_DATA_TYPE_LOGGING
-(void)logging:(NSString *)content status:(FTLogStatus)status tags:(NSDictionary *)tags field:(NSDictionary *)field tm:(long long)tm{
    @try {
        if (!self.loggerConfig) {
            ZYErrorLog(@"请先设置 FTLoggerConfig");
            return;
        }
        if (!self.loggerConfig.enableCustomLog) {
            ZYLog(@"enableCustomLog 未开启，数据不进行采集");
            return;
        }
        if (!content || content.length == 0 || [content ft_characterNumber]>FT_LOGGING_CONTENT_SIZE) {
            ZYErrorLog(@"传入的第数据格式有误，或content超过30kb");
            return;
        }
        if (![self.logLevelFilterSet containsObject:@(status)]) {
            ZYDebug(@"经过过滤算法判断-此条日志不采集");
            return;
        }
        if (![FTBaseInfoHandler randomSampling:self.loggerConfig.sampleRate]){
            ZYDebug(@"经过采集算法判断-此条日志不采集");
            return;
        }
        
        dispatch_async(self.serialQueue, ^{
            NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithDictionary:[self.presetProperty loggerPropertyWithStatus:(LogStatus)status]];
            if (tags) {
                [tagDict addEntriesFromDictionary:tags];
            }
            if (self.loggerConfig.enableLinkRumData) {
                [tagDict addEntriesFromDictionary:[self.presetProperty rumPropertyWithTerminal:FT_TERMINAL_APP]];
                if(![tags.allKeys containsObject:FT_RUM_KEY_SESSION_ID]){
                    NSDictionary *rumTag = [[FTGlobalRumManager sharedInstance].rumManager getCurrentSessionInfo];
                    [tagDict addEntriesFromDictionary:rumTag];
                }
            }
            NSMutableDictionary *filedDict = @{FT_KEY_MESSAGE:content,
            }.mutableCopy;
            if (field) {
                [filedDict addEntriesFromDictionary:field];
            }
            FTRecordModel *model = [[FTRecordModel alloc]initWithSource:FT_LOGGER_SOURCE op:FT_DATA_TYPE_LOGGING tags:tagDict fields:filedDict tm:tm];
            [self insertDBWithItemData:model type:FTAddDataLogging];
        });
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception %@",exception);
    }
}
- (void)rumWrite:(NSString *)type terminal:(NSString *)terminal tags:(NSDictionary *)tags fields:(NSDictionary *)fields{
    [self rumWrite:type terminal:terminal tags:tags fields:fields tm:[FTDateUtil currentTimeNanosecond]];
}

- (void)rumWrite:(NSString *)type terminal:(NSString *)terminal tags:(NSDictionary *)tags fields:(NSDictionary *)fields tm:(long long)tm{
    
    @try {
        if (![type isKindOfClass:NSString.class] || type.length == 0 || terminal.length == 0) {
            return;
        }
        FTAddDataType dataType = FTAddDataImmediate;
        NSMutableDictionary *baseTags =[NSMutableDictionary dictionaryWithDictionary:tags];
        baseTags[@"network_type"] = [FTReachability sharedInstance].net;
        [baseTags addEntriesFromDictionary:[self.presetProperty rumPropertyWithTerminal:terminal]];
        FTRecordModel *model = [[FTRecordModel alloc]initWithSource:type op:FT_DATA_TYPE_RUM tags:baseTags fields:fields tm:tm];
        [self insertDBWithItemData:model type:dataType];
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception %@",exception);
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
    ZYDebug(@"Bind User ID : %@",Id);
    if (userName) {
        ZYDebug(@"Bind User Name : %@",userName);
    }
    if (userEmail) {
        ZYDebug(@"Bind User Email : %@",userEmail);
    }
    if (extra) {
        ZYDebug(@"Bind User Extra : %@",extra);
    }
}
- (void)insertDBWithItemData:(FTRecordModel *)model type:(FTAddDataType)type{
    [[FTTrackDataManager sharedInstance] addTrackData:model type:type];
}
//用户注销
- (void)unbindUser{
    [self.presetProperty.userHelper concurrentWrite:^(FTUserInfo * _Nonnull value) {
        [value clearUser];
    }];
    ZYDebug(@"User Logout");
}
@end
