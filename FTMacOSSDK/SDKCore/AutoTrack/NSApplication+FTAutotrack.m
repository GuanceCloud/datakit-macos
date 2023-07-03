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
#import "NSMenuItem+FTAutoTrack.h"
@implementation NSApplication (FTAutotrack)
- (BOOL)datakit_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender{
    [self datakitTrack:action to:target from:sender];
    return [self datakit_sendAction:action to:target from:sender];
}
- (void)datakitTrack:(SEL)action to:(id)target from:(id )sender{

    if (![sender isKindOfClass:[NSView class]] && ![sender isKindOfClass:[NSMenuItem class]] && ![sender isKindOfClass:[NSGestureRecognizer class]]) {
        return;
    }
    //拖拽事件不采集
    if (self.currentEvent.type != NSEventTypeLeftMouseUp &&  self.currentEvent.type != NSEventTypeLeftMouseDown ) {
        return;
    }
    //处理手势事件
    if ([sender isKindOfClass:NSGestureRecognizer.class]) {
        NSGestureRecognizer *ges = (NSGestureRecognizer *)sender;
        if (ges.state != NSGestureRecognizerStateEnded) {
            return;
        }
        NSView *view = ges.view;
        if([view isKindOfClass:[NSImageView class]]||[view isKindOfClass:[NSTextField class]]){
            if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
                [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:view.datakit_actionName];
            }
        }
        return;
    }
    //NSMenu 不继承于 NSView
    if ([sender isKindOfClass:NSMenuItem.class]) {
        // 排除 NSPopUpButton 弹出的 NSMenuItem 点击避免重复
        if(target != NULL && [target isKindOfClass:[NSPopUpButtonCell class]]){
            return;
        }
        NSMenuItem *menu = (NSMenuItem *)sender;
        if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
            [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:menu.datakit_actionName];
        }
        return;
    }
    //滚动条上点击事件不采集
    if ([sender isKindOfClass:NSScroller.class]){
        return;
    }
    //过滤 NSTableView doubleAction
    if([sender isKindOfClass:NSTableView.class]){
        NSTableView *tableView = (NSTableView *)sender;
        if(action && tableView.doubleAction != tableView.action && tableView.doubleAction == action){
            return;
        }
    }
    NSView *view = sender;
    //view 没有 window，点击事件不采集
    if(!view.window){
        return;
    }
    NSString *actionName = view.datakit_actionName;
    // NSDatePicker
    if([sender isKindOfClass:NSDatePicker.class]){
        // NSEventTypeLeftMouseDown 且 没有 action 的过滤掉
        if( self.currentEvent.type == NSEventTypeLeftMouseDown && !action){
            return;
        }
        NSDatePicker *datePicker = (NSDatePicker *)view;
        if (action && datePicker.datePickerStyle == NSDatePickerStyleClockAndCalendar){
            actionName = [NSString stringWithFormat:@"[%@]%@",NSStringFromClass([sender class]),NSStringFromSelector(action)];
        }
    }
    //过滤 NSComboBox 下拉选择框的点击事件，避免重复
    if ([sender isKindOfClass:NSClassFromString(@"NSComboTableView")]){
        return;
    }
    //过滤 NSSearchField 取消按钮一次点击多次sendAction，并区分搜索按钮和取消按钮
    if ([sender isKindOfClass:NSSearchField.class]) {
        if(!action){
            return;
        }
        actionName = [NSString stringWithFormat:@"[%@]%@",NSStringFromClass([sender class]),NSStringFromSelector(action)];
    }
    if([sender isKindOfClass:NSDatePicker.class] && action){
        actionName = [NSString stringWithFormat:@"[%@]%@",NSStringFromClass([sender class]),NSStringFromSelector(action)];
    }
    
    if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
        [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:actionName];
    }
    
}
@end
