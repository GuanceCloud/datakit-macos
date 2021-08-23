//
//  FTConfigManager.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import "FTConfigManager.h"
#import "FTMacOSSDKVersion.h"
@implementation FTConfigManager
+ (instancetype)sharedInstance{
    static FTConfigManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}
-(void)setTrackConfig:(FTTrackConfig *)trackConfig{
    _trackConfig = [trackConfig copy];
}
-(NSString *)sdkVersion{
    return SDK_VERSION;
}
@end
