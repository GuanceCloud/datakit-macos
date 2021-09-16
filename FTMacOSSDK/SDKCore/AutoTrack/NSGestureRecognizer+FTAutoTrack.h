//
//  NSGestureRecognizer+FTAutoTrack.h
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSGestureRecognizer (FTAutoTrack)
-(void)dataflux_setAction:(SEL)action;
-(void)dataflux_setTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
