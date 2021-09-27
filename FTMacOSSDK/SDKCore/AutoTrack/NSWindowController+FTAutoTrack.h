//
//  NSWindowController+FTAutoTrack.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import <Cocoa/Cocoa.h>
#import "FTAutoTrackProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSWindowController (FTAutoTrack)
-(void)dataflux_windowWillLoad;
- (void)dataflux_windowDidLoad;
- (void)dataflux_windowWillClose:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
