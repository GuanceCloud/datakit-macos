//
//  FTRumManager.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import <Foundation/Foundation.h>
#import "FTRUMHandler.h"
NS_ASSUME_NONNULL_BEGIN
@class FTRumConfig,FTRumEvent;

@interface FTRumManager : FTRUMHandler
+ (instancetype)sharedInstance;

- (void)addViewAppearEvent:(id)view;
- (void)addViewDisappearEvent:(id)view;

- (void)addActionEventWithView:(id )view;

@end

NS_ASSUME_NONNULL_END
