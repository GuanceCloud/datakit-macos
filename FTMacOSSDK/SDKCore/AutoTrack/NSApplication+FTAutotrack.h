//
//  NSApplication+FTAutotrack.h
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (FTAutotrack)
- (BOOL)ft_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender;
@end

NS_ASSUME_NONNULL_END
