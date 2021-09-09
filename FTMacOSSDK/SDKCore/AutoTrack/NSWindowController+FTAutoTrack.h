//
//  NSWindowController+FTAutoTrack.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindowController (FTAutoTrack)
- (void)ft_windowDidLoad;
- (void)ft_windowWillClose:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
