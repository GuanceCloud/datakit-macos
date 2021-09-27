//
//  FTSDKAgent+Private.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/24.
//

#import "FTSDKAgent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTSDKAgent (Private)
- (void)rumWrite:(NSString *)type terminal:(NSString *)terminal tags:(NSDictionary *)tags fields:(NSDictionary *)fields;

- (void)rumWrite:(NSString *)type terminal:(NSString *)terminal tags:(NSDictionary *)tags fields:(NSDictionary *)fields tm:(long long)tm;
@end

NS_ASSUME_NONNULL_END
