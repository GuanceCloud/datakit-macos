//
//  FTSDKAgent.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import "FTSDKAgent.h"
#import "FTTrackConfig.h"
#import "FTReachability.h"
#import "FTConfigManager.h"
#import "FTTrackDataManger.h"
#import "FTRecordModel.h"
#import "FTLog.h"
#import "FTDateUtil.h"
#import "FTAutoTrack.h"
#import "FTRumManager.h"
#import "FTPresetProperty.h"
#import "FTConstants.h"
#import "FTBaseInfoHander.h"
#import "NSString+FTAdd.h"
#import "FTDateUtil.h"
@interface FTSDKAgent()
@property (nonatomic, strong) FTAutoTrack *autoTrack;
@property (nonatomic, strong) FTLoggerConfig *loggerConfig;
@end
@implementation FTSDKAgent
static FTSDKAgent *sharedInstance = nil;

+ (void)startWithConfigOptions:(FTTrackConfig *)configOptions{
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
-(instancetype)initWithConfig:(FTTrackConfig *)config{
    self = [super init];
    if(self){
        //开启网络监听
        [[FTReachability sharedInstance] startNotifier];
        FTConfigManager.sharedInstance.trackConfig = [config copy];
        [FTLog enableLog:YES];
    }
    return self;
}
-(void)startRumWithConfigOptions:(FTRumConfig *)rumConfigOptions{
    FTConfigManager.sharedInstance.rumConfig = [rumConfigOptions copy];
    if(!_autoTrack){
        _autoTrack = [[FTAutoTrack alloc]init];
    }
    [FTRumManager sharedInstance];
}
static NSSet *logLevelFilterSet;
- (void)startLoggerWithConfigOptions:(FTLoggerConfig *)loggerConfigOptions{
    self.loggerConfig = [loggerConfigOptions copy];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logLevelFilterSet = [NSSet setWithArray:loggerConfigOptions.logLevelFilter];
    });
}
#pragma mark - 数据写入 -

-(void)logging:(NSString *)content status:(FTStatus)status{
    @try {
        if (!self.loggerConfig) {
            ZYErrorLog(@"请先设置 FTLoggerConfig");
            return;
        }
        if (!content || content.length == 0 || [content ft_charactorNumber]>FT_LOGGING_CONTENT_SIZE) {
            ZYErrorLog(@"传入的第数据格式有误，或content超过30kb");
            return;
        }
        if (![logLevelFilterSet containsObject:@(status)]) {
            ZYDebug(@"经过过滤算法判断-此条日志不采集");
            return;
        }
        if (![FTBaseInfoHander randomSampling:self.loggerConfig.samplerate]){
            ZYDebug(@"经过采集算法判断-此条日志不采集");
            return;
        }
      
        FTRecordModel *model = [[FTRecordModel alloc]initWithSource:FT_LOGGER_SOURCE op:FT_DATA_TYPE_LOGGING tags:@{@"sdk_name":@"df_macos_rum_sdk"} field:@{@"message":content} tm:[FTDateUtil currentTimeNanosecond]];
        [[FTTrackDataManger sharedInstance] addTrackData:model type:FTAddDataNormal];
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
        baseTags[@"network_type"] = @"";
//        [baseTags addEntriesFromDictionary:[self.presetProperty rumPropertyWithType:type terminal:terminal]];
        FTRecordModel *model = [[FTRecordModel alloc]initWithSource:type op:FT_DATA_TYPE_RUM tags:baseTags field:fields tm:tm];
//        [self insertDBWithItemData:model type:dataType];
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception %@",exception);
    }
    
    
    
}
@end
