//
//  FTRumManager.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FTRumConfig,FTRumEvent;

@interface FTRumManager : NSObject
+ (instancetype)sharedInstance;

- (void)addActionEventWithView:(NSView *)view;
@end

NS_ASSUME_NONNULL_END
