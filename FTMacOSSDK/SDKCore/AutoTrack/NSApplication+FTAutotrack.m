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
    if (![sender  isKindOfClass:[NSView class]]) {
        return;
    }
    if([sender isKindOfClass:NSScroller.class]){
        if (self.currentEvent.type != NSEventTypeLeftMouseUp) {
            return;
        }
        //采集 NSScroller 拖拽
        
    }else if([sender isKindOfClass:NSDatePicker.class]){
        //采集日历相关
        if (action && target) {
         
        }else{
            
        }
        
    }else{
        //采集其他控件点击
        if([sender isKindOfClass:NSPopUpButton.class]){
            NSPopUpButton *pop = sender;
            NSLog(@"selectedItem.title %@", pop.selectedItem.title);
        }
    }
    
    NSLog(@"action %@",NSStringFromSelector(action));
    NSLog(@"target %@",target);
    NSLog(@"sender %@",sender);
    NSLog(@"event %@",self.currentEvent);
    
    
}


@end
