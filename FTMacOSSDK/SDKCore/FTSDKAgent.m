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
@interface FTSDKAgent()
@property (nonatomic, strong) FTAutoTrack *autoTrack;

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
        FTConfigManager.sharedInstance.trackConfig = config;
        _autoTrack = [[FTAutoTrack alloc]init];
        [FTLog enableLog:YES];
    }
    return self;
}
-(void)logging:(NSString *)content status:(FTStatus)status{
    if (![content isKindOfClass:[NSString class]] || content.length==0) {
        return;
    }
    @try {
        FTRecordModel *model = [[FTRecordModel alloc]initWithSource:@"df_rum_macos_log" op:FT_DATA_TYPE_LOGGING tags:@{@"sdk_name":@"df_macos_rum_sdk"} field:@{@"message":content} tm:[FTDateUtil currentTimeNanosecond]];
        [[FTTrackDataManger sharedInstance] addTrackData:model type:FTAddDataNormal];
    } @catch (NSException *exception) {
        ZYErrorLog(@"exception %@",exception);
    }
}
@end
