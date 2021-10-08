//
//  FTBaseInfoHander.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTBaseInfoHander : NSObject
+ (BOOL)randomSampling:(int)sampling;
+ (NSString *)boolStr:(BOOL)isTrue;
+ (void)performBlockDispatchMainSyncSafe:(DISPATCH_NOESCAPE dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
