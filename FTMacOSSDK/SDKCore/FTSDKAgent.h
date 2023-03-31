//
//  FTSDKAgent.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 Guance-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FTMacOSSDK/FTSDKConfig.h>
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
/// SDK 初始化方法
///
/// 在启动 SDK 的同时配置基础的配置项，必要的配置项有 FT-GateWay metrics 写入地址。
///
/// SDK 必须在主线程里进行初始化，否则会引发无法预料的问题（比如丢失 launch 事件）。
/// - Parameter configOptions: SDK 基础配置项.
+ (void)startWithConfigOptions:(FTSDKConfig *)configOptions;
/// 配置 RUM Config 开启 RUM 功能
///
/// RUM 用户监测，采集用户的行为数据，支持采集 View、Action、Resource、LongTask、Error。支持自动采集和手动添加。
/// - Parameter rumConfigOptions: rum 配置项.
- (void)startRumWithConfigOptions:(FTRumConfig *)rumConfigOptions;
/// 配置 Logger Config 开启 Logger 功能
///
/// - Parameters:
///   - loggerConfigOptions: logger 配置项.
- (void)startLoggerWithConfigOptions:(FTLoggerConfig *)loggerConfigOptions;

/// 设置过滤 Trace Resource 域名
/// - Parameter handler: 判断是否采集回调，返回 YES 采集， NO 过滤掉
- (void)isIntakeUrl:(BOOL(^)(NSURL *url))handler;
/// 配置 Trace Config 开启 Trace 功能
///
/// - Parameters:
///   - traceConfigOptions: trace 配置项.
- (void)startTraceWithConfigOptions:(FTTraceConfig *)traceConfigOptions;
/// 添加自定义日志
///
/// - Parameters:
///   - content: 日志内容，可为 json 字符串
///   - status: 事件等级和状态
-(void)logging:(NSString *)content status:(FTLogStatus)status;

/// 添加自定义日志
/// - Parameters:
///   - content: 日志内容，可为 json 字符串
///   - status: 事件等级和状态
///   - property: 事件自定义属性(可选)
-(void)logging:(NSString *)content status:(FTLogStatus)status property:(nullable NSDictionary *)property;;
/// 绑定用户信息
///
/// - Parameters:
///   - Id:  用户Id
- (void)bindUserWithUserID:(NSString *)userId;

/// 绑定用户信息
///
/// - Parameters:
///   - Id:  用户Id
///   - userName: 用户名称
///   - userEmailL: 用户邮箱
- (void)bindUserWithUserID:(NSString *)Id userName:(nullable NSString *)userName userEmail:(nullable NSString *)userEmail;
/// 绑定用户信息
///
/// - Parameters:
///   - Id:  用户Id
///   - userName: 用户名称
///   - userEmail: 用户邮箱
///   - extra: 用户的额外信息
- (void)bindUserWithUserID:(NSString *)Id userName:(nullable NSString *)userName userEmail:(nullable NSString *)userEmail extra:(nullable NSDictionary *)extra;

/// 注销当前用户
- (void)unbindUser;
@end

NS_ASSUME_NONNULL_END
