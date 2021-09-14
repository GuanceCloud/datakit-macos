//
//  NSApplication+FTAutotrack.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "NSApplication+FTAutotrack.h"

@implementation NSApplication (FTAutotrack)
- (BOOL)dataflux_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender{
    [self datafluxTrack:action to:target from:sender];
    return [self dataflux_sendAction:action to:target from:sender];
}
- (void)datafluxTrack:(SEL)action to:(id)target from:(id )sender{
    if (![sender  isKindOfClass:[NSView class]]) {
        return;
    }
    //拖拽事件不采集
    if (self.currentEvent.type == NSEventTypeLeftMouseDragged ) {
        return;
    }
    //Colors Panel 滑动条 过滤滑动状态 以及NSEventTypeLeftMouseDown
    if ([sender isKindOfClass:NSSlider.class]) {
        if (self.currentEvent.type != NSEventTypeLeftMouseUp) {
            return;
        }
        //采集滑动条滑动停止事件
        
    }
    else if([sender isKindOfClass:NSDatePicker.class]){
            //采集日历相关
            //右上角的箭头与圆形按钮 与 stepper
            if (action && target) {
               
                
            }else{
                //日期 textfiled 填写
                if (self.currentEvent.type == NSEventTypeLeftMouseUp ||self.currentEvent.type == NSEventTypeKeyDown) {
                   
                }else{
                    return;
                }
            }
        
    }else{
        //采集其他控件点击
        if([sender isKindOfClass:NSPopUpButton.class]){
            NSPopUpButton *pop = sender;
            NSLog(@"selectedItem.title %@", pop.selectedItem.title);
        }
    }
    if([sender isKindOfClass:NSTableView.class]){
        NSTableView *tableView = sender;
        NSLog(@"\n tableView clickedRow = %ld \n tableView clickedColumn = %ld",(long)tableView.clickedRow,(long)tableView.clickedColumn);

        
    }
    
    NSLog(@"action %@",NSStringFromSelector(action));
    NSLog(@"target %@",target);
    NSLog(@"sender %@",sender);
    NSLog(@"event %@",self.currentEvent);
    
    
}


@end
