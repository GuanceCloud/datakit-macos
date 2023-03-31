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
-(void)datakit_windowWillLoad;
- (void)datakit_windowDidLoad;
- (void)datakit_windowWillClose:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
