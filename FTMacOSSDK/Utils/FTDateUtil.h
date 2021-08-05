//
//  FTDateUtil.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/5.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTDateUtil : NSObject
+ (long long)currentTimeMillisecond;
+ (long long)currentTimeNanosecond;
+ (NSString *)currentTimeGMT;
@end

NS_ASSUME_NONNULL_END
