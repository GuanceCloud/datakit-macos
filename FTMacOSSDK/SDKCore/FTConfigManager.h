//
//  FTConfigManager.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTTrackConfig.h"
NS_ASSUME_NONNULL_BEGIN
#define SDK_VERSION  @"1.0.0-alpha.1"

@interface FTConfigManager : NSObject
@property(nonatomic, strong) FTTrackConfig *trackConfig;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
