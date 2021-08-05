//
//  FTTrackDataManger.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/4.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 - FTAddDataConcurrent: 异步并行写入数据库
 - FTAddDataSerial: 异步串行写入数据库
 - FTAddDataCache:  事务写入数据库
 - FTAddDataImmediate: 同步写入数据库
 */
typedef NS_ENUM(NSInteger, FTAddDataType) {
    FTAddDataConcurrent,
    FTAddDataSerial,
    FTAddDataCache,
    FTAddDataImmediate,
};
NS_ASSUME_NONNULL_BEGIN
@class FTRecordModel;
///数据写入，数据上传 相关操作
@interface FTTrackDataManger : NSObject
///数据写入
- (void)addTrackData:(FTRecordModel *)data type:(FTAddDataType)type;

///上传数据
- (void)uploadTrackData;
@end

NS_ASSUME_NONNULL_END
