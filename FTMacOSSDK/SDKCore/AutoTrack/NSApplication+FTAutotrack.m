//
//  NSApplication+FTAutotrack.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "NSApplication+FTAutotrack.h"
#import "FTGlobalRumManager.h"
#import "NSView+FTAutoTrack.h"
#import "FTAutoTrack.h"
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
        NSView *view = sender;
        if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
            [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:view.dataflux_actionName];
        }
    }else{
        //NSMenu 不继承于 NSView
        if ([sender isKindOfClass:NSMenuItem.class]) {
            if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
                [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:@"[NSMenuItem]"];
            }
            return;
        }
        //过滤 NSSearchField 取消按钮一次点击多次sendAction
        if ([sender isKindOfClass:NSSearchField.class] && action == nil) {
            return;
        }
        if([sender isKindOfClass:NSView.class]){
            NSView *view = sender;
            if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
                [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:view.dataflux_actionName];
            }
        }
    }
}


@end
