//
//  NSMenuItem+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/28.
//

#import "NSMenuItem+FTAutoTrack.h"

@implementation NSMenuItem (FTAutoTrack)
-(NSString *)dataflux_actionName{
    return [NSString stringWithFormat:@"[NSMenuItem]%@",self.title];
}
-(id)dataflux_controller{
    return [NSApplication sharedApplication].keyWindow.contentViewController?:[NSApplication sharedApplication].keyWindow;
}
-(BOOL)inMainWindow{
    return [[NSApplication sharedApplication].keyWindow isMainWindow];
}
-(BOOL)isKeyWindow{
    return YES;
}
@end
