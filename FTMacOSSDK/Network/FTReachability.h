//
//  FTReachability.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/4.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
NS_ASSUME_NONNULL_BEGIN
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif
typedef NS_ENUM(NSInteger, FTNetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    FTNotReachable = 0,
    FTReachableViaWiFi = 2,
    FTReachableViaWWAN = 1
};

@interface FTReachability : NSObject
+(instancetype)reachabilityWithHostname:(NSString*)hostname;

+(instancetype)reachabilityWithAddress:(void *)hostAddress;

+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;
- (void)stopNotifier;
- (BOOL)isReachable;
-(FTNetworkStatus)currentReachabilityStatus;
- (BOOL)connectionRequired;

@end

NS_ASSUME_NONNULL_END
