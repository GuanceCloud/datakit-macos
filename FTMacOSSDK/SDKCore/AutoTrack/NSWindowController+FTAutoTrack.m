//
//  NSWindowController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindowController+FTAutoTrack.h"

@implementation NSWindowController (FTAutoTrack)
- (void)ft_windowDidLoad{

    [self ft_windowDidLoad];
    NSLog(@"ft_windowDidLoad %@",self);
}
- (void)ft_windowWillClose:(NSNotification *)notification{
    [self ft_windowWillClose:notification];
}

@end
