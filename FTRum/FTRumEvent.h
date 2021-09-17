//
//  FTRumEvent.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTRumEvent : NSObject
@property (nonatomic, strong) NSDate *time;
@end
@interface FTRumActionEvent : FTRumEvent

@property (nonatomic, copy) NSString *actionName;


@end
NS_ASSUME_NONNULL_END
