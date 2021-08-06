//
//  FTSDKAgent.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FTTrackConfig;
NS_ASSUME_NONNULL_BEGIN

@interface FTSDKAgent : NSObject
/**
 * @abstract
 * 返回之前所初始化好的单例
 *
 * @discussion
 * 调用这个方法之前，必须先调用 startWithConfigOptions 这个方法
 *
 * @return 返回的单例
*/
+ (instancetype)sharedInstance;
/**
 * @abstract
 * SDK 初始化方法
 * @param configOptions     配置参数
*/
+ (void)startWithConfigOptions:(FTTrackConfig *)configOptions;
@end

NS_ASSUME_NONNULL_END
