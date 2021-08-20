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
