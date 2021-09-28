//
//  NSApplication+FTAutotrack.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "NSApplication+FTAutotrack.h"
#import "FTRumManager.h"
@implementation NSApplication (FTAutotrack)
- (BOOL)dataflux_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender{
    [self datafluxTrack:action to:target from:sender];
    return [self dataflux_sendAction:action to:target from:sender];
}
- (void)datafluxTrack:(SEL)action to:(id)target from:(id )sender{

    if (![sender  isKindOfClass:[NSView class]] && ![sender isKindOfClass:[NSMenuItem class]]) {
        return;
    }
    //拖拽事件不采集
    if (self.currentEvent.type != NSEventTypeLeftMouseUp &&  self.currentEvent.type != NSEventTypeLeftMouseDown ) {
        return;
    }
    //NSStepper点击触发 NSEventTypeLeftMouseDown
    if (self.currentEvent.type == NSEventTypeLeftMouseDown && ([sender isKindOfClass:NSDatePicker.class] || [sender isKindOfClass:NSStepper.class])) {
        if([sender isKindOfClass:NSDatePicker.class] && !(action && target)){
            return;
        }
        [[FTRumManager sharedInstance] addActionEventWithView:sender];
    }else{
    //NSMenu 不继承于 NSView
    if ([sender isKindOfClass:NSMenuItem.class]) {
        [[FTRumManager sharedInstance] addActionEventWithView:sender];
        return;
    }
    if([sender isKindOfClass:NSView.class]){
        [[FTRumManager sharedInstance] addActionEventWithView:sender];
    }
    }
    NSLog(@"action %@",NSStringFromSelector(action));
    NSLog(@"target %@",target);
    NSLog(@"sender %@",sender);
    NSLog(@"event %@",self.currentEvent);
}


@end
