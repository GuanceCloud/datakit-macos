//
//  NSViewController+FTAutoTrack.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import <Cocoa/Cocoa.h>
#import "FTAutoTrackProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSViewController (FTAutoTrack)<FTAutoTrackViewControllerProperty>
- (void)dataflux_viewDidLoad;
- (void)dataflux_viewDidAppear;
- (void)dataflux_viewDidDisappear;
@end

NS_ASSUME_NONNULL_END
