//
//  FTGlobalRumManager.h
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2020/4/14.
//  Copyright © 2020 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTEnumConstant.h"
NS_ASSUME_NONNULL_BEGIN
@class  FTRUMManager,FTRumConfig;
// 用于 开启各项数据的采集 
@interface FTGlobalRumManager : NSObject
@property (nonatomic, strong) FTRUMManager *rumManger;
// 仅在主线程使用 所以无多线程调用问题
@property (nonatomic, weak) NSViewController *currentController;
/**
 * 获取 FTMonitorManager 单例
 * @return 返回的单例
*/
+ (instancetype)sharedInstance;

-(void)setRumConfig:(FTRumConfig *)rumConfig;

- (void)trackViewDidDisappear:(NSViewController *)viewController;
- (void)trackViewDidAppear:(NSViewController *)viewController;

- (void)resetInstance;
@end

NS_ASSUME_NONNULL_END
