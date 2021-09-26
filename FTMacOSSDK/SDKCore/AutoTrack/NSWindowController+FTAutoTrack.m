//
//  NSWindowController+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindowController+FTAutoTrack.h"

@implementation NSWindowController (FTAutoTrack)

-(void)dataflux_windowWillLoad{
    [self dataflux_windowWillLoad];
}
- (void)dataflux_windowDidLoad{

    [self dataflux_windowDidLoad];
    NSLog(@"ft_windowDidLoad contentViewController = %@",self.window.contentViewController);
    if(!self.window.contentViewController){
        // 记录 window 的生命周期
    }
    
}
- (void)dataflux_windowWillClose:(NSNotification *)notification{
    [self dataflux_windowWillClose:notification];
}

@end
