//
//  FTGlobalRumManager.h
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2020/4/14.
//  Copyright © 2020 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FTResourceMetricsModel.h>
#import <FTResourceContentModel.h>

NS_ASSUME_NONNULL_BEGIN

// 用于 开启各项数据的采集 
@interface FTGlobalRumManager : NSObject
/**
 * 获取 FTMonitorManager 单例
 * @return 返回的单例
*/
+ (instancetype)sharedInstance;

/// 创建页面
///
/// 在 `-startViewWithName` 方法前调用，该方法用于记录页面的加载时间，如果无法获得加载时间该方法可以不调用。
/// - Parameters:
///   - viewName: 页面名称
///   - loadTime: 页面加载时间
-(void)onCreateView:(NSString *)viewName loadTime:(NSNumber *)loadTime;
/// 进入页面
///
/// - Parameters:
///   - viewName: 页面名称
-(void)startViewWithName:(NSString *)viewName;
/// 进入页面
/// - Parameters:
///   - viewName: 页面名称
///   - property: 事件自定义属性(可选)
-(void)startViewWithName:(NSString *)viewName property:(nullable NSDictionary *)property;

/// 离开页面
-(void)stopView;

/// 离开页面
/// - Parameter property: 事件自定义属性(可选)
-(void)stopViewWithProperty:(nullable NSDictionary *)property;

/// 添加 Action 事件
///
/// - Parameters:
///   - actionName: 事件名称
///   - actionType: 事件类型
- (void)addActionName:(NSString *)actionName actionType:(NSString *)actionType;
/// 添加 Action 事件
/// - Parameters:
///   - actionName: 事件名称
///   - actionType: 事件类型
///   - property: 事件自定义属性(可选)
- (void)addActionName:(NSString *)actionName actionType:(NSString *)actionType property:(nullable NSDictionary *)property;

/// 添加 Error 事件
///
/// - Parameters:
///   - type: error 类型
///   - message: 错误信息
///   - stack: 堆栈信息
- (void)addErrorWithType:(NSString *)type message:(NSString *)message stack:(NSString *)stack;
/// 添加 Error 事件
/// - Parameters:
///   - type: error 类型
///   - message: 错误信息
///   - stack: 堆栈信息
///   - property: 事件自定义属性(可选)
- (void)addErrorWithType:(NSString *)type message:(NSString *)message stack:(NSString *)stack property:(nullable NSDictionary *)property;

/// 添加 卡顿 事件
///
/// - Parameters:
///   - stack: 卡顿堆栈
///   - duration: 卡顿时长（纳秒）
- (void)addLongTaskWithStack:(NSString *)stack duration:(NSNumber *)duration;

/// 添加 卡顿 事件
/// - Parameters:
///   - stack: 卡顿堆栈
///   - duration: 卡顿时长（纳秒）
///   - property: 事件自定义属性(可选)
- (void)addLongTaskWithStack:(NSString *)stack duration:(NSNumber *)duration property:(nullable NSDictionary *)property;
/// HTTP 请求开始
///
/// - Parameters:
///   - key: 请求标识
- (void)startResourceWithKey:(NSString *)key;
/// HTTP 请求开始
/// - Parameters:
///   - key: 请求标识
///   - property: 事件自定义属性(可选)
- (void)startResourceWithKey:(NSString *)key property:(nullable NSDictionary *)property;

/// HTTP 请求数据
///
/// - Parameters:
///   - key: 请求标识
///   - metrics: 请求相关性能属性
///   - content: 请求相关数据
- (void)addResourceWithKey:(NSString *)key metrics:(nullable FTResourceMetricsModel *)metrics content:(FTResourceContentModel *)content;
/// HTTP 请求结束
///
/// - Parameters:
///   - key: 请求标识
- (void)stopResourceWithKey:(NSString *)key;
/// HTTP 请求结束
/// - Parameters:
///   - key: 请求标识
///   - property: 事件自定义属性(可选)
- (void)stopResourceWithKey:(NSString *)key property:(nullable NSDictionary *)property;

@end

NS_ASSUME_NONNULL_END
