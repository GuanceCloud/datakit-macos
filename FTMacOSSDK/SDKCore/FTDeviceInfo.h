//
//  FTDeviceInfo.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTDeviceInfo : NSObject

@property (nonatomic, copy ,readonly) NSString *osVersion;
@property (nonatomic, copy ,readonly) NSString *screenSize;
@property (nonatomic, copy ,readonly) NSString *deviceUUID;
@property (nonatomic, copy ,readonly) NSString *device;
@property (nonatomic, copy ,readonly) NSString *os;
@property (nonatomic, copy ,readonly) NSString *model;

+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
