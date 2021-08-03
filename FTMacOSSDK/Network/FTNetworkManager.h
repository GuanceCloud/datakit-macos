//
//  FTNetworkManager.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^FTNetworkSuccessBlock)(NSHTTPURLResponse *response,NSData *data);
typedef void (^FTNetworkFailureBlock)(NSHTTPURLResponse *response,NSData *data,NSError *error);
@interface FTNetworkManager : NSObject

@end

NS_ASSUME_NONNULL_END

