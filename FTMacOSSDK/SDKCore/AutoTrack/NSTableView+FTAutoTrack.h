//
//  NSTableView+FTAutoTrack.h
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTableView (FTAutoTrack)
- (void)ft_tableViewSelectionDidChange:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
