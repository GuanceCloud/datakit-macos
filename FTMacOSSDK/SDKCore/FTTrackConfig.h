//
//  FTTrackConfig.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTTrackConfig : NSObject
/**
 * 数据上报地址，两种模式：
 * ①使用Dataflux的数据网关，可在控制台获取对应网址；
 * ②使用私有化部署的数据网关，填写对应网址即可。
*/
@property (nonatomic, copy) NSString *metricsUrl;
/**
 * 请求HTTP请求头X-Datakit-UUID 数据采集端  如果用户不设置会自动配置
 */
@property (nonatomic, copy) NSString *XDataKitUUID;
-(instancetype)initWithMetricsUrl:(NSString *)metricsUrl;
@end
@interface FTRumConfig : NSObject
/**
 * @method 指定初始化方法，设置 appid
 * @param appid 应用唯一ID 设置后 rum 数据才能正常上报
 * @return 配置对象
 */
- (instancetype)initWithAppid:(nonnull NSString *)appid;
/// 禁用 new 初始化
+ (instancetype)new NS_UNAVAILABLE;
/**
 * 应用唯一ID，在DataFlux控制台上面创建监控时自动生成。
 */
@property (nonatomic, copy) NSString *appid;
/**
 * 采样配置，属性值：0至100，100则表示百分百采集，不做数据样本压缩。
 */
@property (nonatomic, assign) int samplerate;
/**
 * 设置是否追踪用户操作，目前支持应用启动和点击操作
 */
@property (nonatomic, assign) BOOL enableTraceUserAction;
/**
 * 设置是否需要采集崩溃日志
 */
@property (nonatomic, assign) BOOL enableTrackAppCrash;
/**
 * 设置是否需要采集卡顿
 */
@property (nonatomic, assign) BOOL enableTrackAppFreeze;
/**
 * 设置是否需要采集卡顿
 * runloop采集主线程卡顿
*/
@property (nonatomic, assign) BOOL enableTrackAppANR;


@end
@interface FTLoggerConfig : NSObject
/// 禁用 new 初始化
+ (instancetype)new NS_UNAVAILABLE;
/**
 * 设置日志所属业务或服务的名称 默认：df_rum_ios
 */
@property (nonatomic, copy) NSString *service;
/**
 * 采样配置，属性值：0至100，100则表示百分百采集，不做数据样本压缩。
 */
@property (nonatomic, assign) int samplerate;
/**
 * 设置是否需要采集控制台日志 默认为NO
 */
@property (nonatomic, assign) BOOL enableConsoleLog;
/**
 * 设置采集控制台日志过滤字符串 包含该字符串控制台日志会被采集 默认为全采集
 */
@property (nonatomic, copy) NSString *prefix;
/**
 * 是否将 logger 数据与 rum 关联
 */
@property (nonatomic, assign) BOOL enableLinkRumData;
/**
 * 是否上传自定义 log
 */
@property (nonatomic, assign) BOOL enableCustomLog;
/**
 * 设置采集自定义日志的状态数组  默认为全采集
 * 例: @[@(FTStatusInfo),@(FTStatusError)]
 * 或 @[@0,@1]
 */
@property (nonatomic, strong) NSArray<NSNumber*> *logLevelFilter;

- (void)enableConsoleLog:(BOOL)enable prefix:(NSString *)prefix;
@end

NS_ASSUME_NONNULL_END
