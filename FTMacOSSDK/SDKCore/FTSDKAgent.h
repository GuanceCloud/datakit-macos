//
//  FTSDKAgent.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FTTrackConfig,FTRumConfig,FTLoggerConfig;
NS_ASSUME_NONNULL_BEGIN
///事件等级和状态，info：提示，warning：警告，error：错误，critical：严重，ok：恢复，默认：info
typedef NS_ENUM(NSInteger, FTStatus) {
    FTStatusInfo         = 0,
    FTStatusWarning,
    FTStatusError,
    FTStatusCritical,
    FTStatusOk,
};
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
/**
 * @abstract
 * 配置 RUM Config 开启 RUM 功能
 *
 * @param rumConfigOptions   rum配置参数
 */
- (void)startRumWithConfigOptions:(FTRumConfig *)rumConfigOptions;
/**
 * @abstract
 * 配置 Logger Config 开启 Logger 功能
 *
 * @param loggerConfigOptions   logger配置参数
 */
- (void)startLoggerWithConfigOptions:(FTLoggerConfig *)loggerConfigOptions;
/**
 * @abstract
 * 日志上报
 *
 * @param content  日志内容，可为json字符串
 * @param status   事件等级和状态，info：提示，warning：警告，error：错误，critical：严重，ok：恢复，默认：info

 */
-(void)logging:(NSString *)content status:(FTStatus)status;
@end

NS_ASSUME_NONNULL_END
