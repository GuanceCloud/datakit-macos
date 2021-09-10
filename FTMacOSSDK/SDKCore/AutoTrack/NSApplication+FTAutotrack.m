//
//  NSApplication+FTAutotrack.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "NSApplication+FTAutotrack.h"

@implementation NSApplication (FTAutotrack)
- (BOOL)ft_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender{
    [self ftTrack:action to:target from:sender];
    return [self ft_sendAction:action to:target from:sender];
}
- (void)ftTrack:(SEL)action to:(id)target from:(id )sender{
    
}


@end
