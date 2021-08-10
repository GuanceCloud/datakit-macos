//
//  FTTrackDataManger.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/4.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import "FTTrackDataManger.h"
#import "FTRecordModel.h"
#import "FTReachability.h"
#import "FTTrackerEventDBTool.h"
#import "FTReachability.h"
#import "FTLog.h"
#import "FTRequest.h"
#import "FTConstants.h"
#import "FTNetworkManager.h"
static const NSUInteger kOnceUploadDefaultCount = 10; // 一次上传数据数量

@interface FTTrackDataManger ()
@property (nonatomic, strong) FTReachability *reachability;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentLabel;
@property (nonatomic, assign) BOOL isUploading;
@property (nonatomic, assign) NSDate *lastAddDBDate;
@end
@implementation FTTrackDataManger{
    dispatch_semaphore_t _lock;
}
+(instancetype)sharedInstance{
    static  FTTrackDataManger *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:nil] init];
    });
    return sharedInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [FTTrackDataManger sharedInstance];
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.serialQueue = dispatch_queue_create("dataflux_track_data_serial", DISPATCH_QUEUE_SERIAL);
        self.concurrentLabel = dispatch_queue_create("dataflux_track_data_concurrent", DISPATCH_QUEUE_CONCURRENT);
        _lock = dispatch_semaphore_create(1);
        [self listenNetworkChange];
    }
    return self;
}
//监听网络状态 网络连接成功 触发一次上传操作
- (void)listenNetworkChange{
    __weak typeof(self) weakSelf = self;
    [FTReachability sharedInstance].networkChanged = ^(){
        [weakSelf uploadTrackData];
    };
}
- (void)addTrackData:(FTRecordModel *)data type:(FTAddDataType)type{
    switch (type) {
        case FTAddDataConcurrent:{
            dispatch_async(self.concurrentLabel, ^{
                [[FTTrackerEventDBTool sharedManger] insertItem:data];
            });
            break;
        }
        case FTAddDataSerial:{
            dispatch_async(self.serialQueue, ^{
                [[FTTrackerEventDBTool sharedManger] insertItem:data];
            });
            break;
        }
        case FTAddDataCache:{
            dispatch_async(self.concurrentLabel, ^{
                [[FTTrackerEventDBTool sharedManger] insertItemToCache:data];
            });
            break;
        }
        case FTAddDataImmediate:{
            [[FTTrackerEventDBTool sharedManger] insertItem:data];
            break;
        }
    }
    if (self.lastAddDBDate) {
        NSDate* now = [NSDate date];
        NSTimeInterval time = [now timeIntervalSinceDate:self.lastAddDBDate];
        if (time>10) {
            self.lastAddDBDate = [NSDate date];
            [self uploadTrackData];
        }
    }else{
        self.lastAddDBDate = [NSDate date];
    }
}

- (void)uploadTrackData{
    //无网 返回
    if(![FTReachability sharedInstance].isReachable){
        return;
    }
    dispatch_async(self.serialQueue, ^{
        [self privateUpload];
    });
   
}
- (void)privateUpload{
    if (self.isUploading) {
        return;
    }
    self.isUploading = YES;
    @try {
        [self flushWithType:FTDataTypeRUM];
        [self flushWithType:FTDataTypeLOGGING];
        [self flushWithType:FTDataTypeTRACING];
        self.isUploading = NO;
    } @catch (NSException *exception) {
        ZYErrorLog(@"执行上传操作失败 %@",exception);
    }
}
-(BOOL)flushWithType:(FTDataType )type{
    NSString *dataType = [FTConstants dataTypeStr:type];
    NSArray *events = [[FTTrackerEventDBTool sharedManger] getFirstRecords:kOnceUploadDefaultCount withType:dataType];
    if (events.count == 0 || ![self flushWithEvents:events type:type]) {
        return NO;
    }
    FTRecordModel *model = [events lastObject];
    if (![[FTTrackerEventDBTool sharedManger] deleteItemWithType:dataType tm:model.tm]) {
        ZYErrorLog(@"数据库删除已上传数据失败");
        return NO;
    }
   return [self flushWithType:type];
}
-(BOOL)flushWithEvents:(NSArray *)events type:(FTDataType)type{
    @try {
        ZYDebug(@"开始上报事件(本次上报事件数:%lu)", (unsigned long)[events count]);
        __block BOOL success = NO;
        dispatch_semaphore_t  flushSemaphore = dispatch_semaphore_create(0);
        FTRequest *request = [[FTRequest alloc]initWithEvents:events type:type];
        [[FTNetworkManager sharedInstance] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
            if (error || ![httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                ZYErrorLog(@"%@", [NSString stringWithFormat:@"Network failure: %@", error ? error : @"Unknown error"]);
                success = NO;
                dispatch_semaphore_signal(flushSemaphore);
                return;
            }
            NSInteger statusCode = httpResponse.statusCode;
            success = (statusCode >=200 && statusCode < 500);
            if (!success) {
                ZYErrorLog(@"服务器异常 稍后再试 response = %@",httpResponse);
            }
            dispatch_semaphore_signal(flushSemaphore);
        }];
        dispatch_semaphore_wait(flushSemaphore, DISPATCH_TIME_FOREVER);
        return success;
    }  @catch (NSException *exception) {
        ZYErrorLog(@"exception %@",exception);
    }
    
}
@end
