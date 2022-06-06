//
//  FTConfigManager.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface FTConfigManager : NSObject
@property(nonatomic, strong) FTConfig *trackConfig;
@property(nonatomic, strong) FTRumConfig *rumConfig;
@property(nonatomic, strong) FTLoggerConfig *loggerConfig;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
