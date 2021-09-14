//
//  NSWindow+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindow+FTAutoTrack.h"

@implementation NSWindow (FTAutoTrack)
- (void)ft_makeKeyWindow{
    [self ft_makeKeyWindow];
    NSLog(@"ft_makeKeyWindow = %@",NSStringFromClass(self.class));

}
- (void)ft_makeMainWindow{
    [self ft_makeMainWindow];
}
- (void)ft_becomeKeyWindow{
    [self ft_becomeKeyWindow];
    NSLog(@"ft_becomeKeyWindow = %@",NSStringFromClass(self.class));

}
- (void)ft_resignKeyWindow{
    [self ft_resignKeyWindow];
}
- (void)ft_becomeMainWindow{
    [self ft_becomeMainWindow];
    NSLog(@"ft_becomeMainWindow = %@",NSStringFromClass(self.class));
}
- (void)ft_resignMainWindow{
    [self ft_resignMainWindow];
}
@end
