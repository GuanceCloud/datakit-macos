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
@interface FTTrackDataManger ()
@property (nonatomic, strong) FTReachability *reachability;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t concurrentLabel;
@property (nonatomic, assign) BOOL isUploading;
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
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.serialQueue = dispatch_queue_create("dataflux_track_data_serial", DISPATCH_QUEUE_SERIAL);
        self.concurrentLabel = dispatch_queue_create("dataflux_track_data_concurrent", DISPATCH_QUEUE_CONCURRENT);
        _lock = dispatch_semaphore_create(1);

    }
    return self;
}
- (void)addTrackData:(FTRecordModel *)data type:(FTAddDataType)type{
    switch (type) {
        case FTAddDataConcurrent:{
            dispatch_async(self.concurrentLabel, ^{
                [[FTTrackerEventDBTool sharedManger] insertItemWithItemData:data];
            });
            break;
        }
        case FTAddDataSerial:{
            dispatch_async(self.serialQueue, ^{
                [[FTTrackerEventDBTool sharedManger] insertItemWithItemData:data];
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
            [[FTTrackerEventDBTool sharedManger] insertItemToCache:data];
            break;
        }
    }
    
}


- (void)uploadTrackData{
    if (self.isUploading) {
        return;
    }
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    self.isUploading = YES;
    dispatch_semaphore_signal(_lock);
    
    
    
    
}
@end
