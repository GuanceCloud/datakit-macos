//
//  FTPresetProperty.h
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTPresetProperty : NSObject
/**
 * 初始化方法
 * @param version 应用版本号
 * @param env     环境
 * @return 初始化对象
 */
- (instancetype)initWithVersion:(NSString *)version env:(NSString *)env;
/// 禁用 init 初始化
- (instancetype)init NS_UNAVAILABLE;

/// 禁用 new 初始化
+ (instancetype)new NS_UNAVAILABLE;
/**
 * 获取 Rum ES 公共Tag
*/
- (NSDictionary *)rumPropertyWithType:(NSString *)type terminal:(NSString *)terminal;
@end

NS_ASSUME_NONNULL_END
