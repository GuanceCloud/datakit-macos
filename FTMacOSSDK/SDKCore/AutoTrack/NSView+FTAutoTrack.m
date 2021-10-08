//
//  NSView+FTAutoTrack.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/15.
//

#import "NSView+FTAutoTrack.h"

@implementation NSView (FTAutoTrack)
-(NSString *)dataflux_viewPath{
    NSMutableString *str = [NSMutableString new];
    [str appendString:NSStringFromClass([self class])];
    NSView *currentView = self;
    NSView *parentView = [currentView superview];
    __block NSInteger index = 0;
    [parentView.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqual:currentView]){
        index = idx;
        *stop = YES;
        }
    }];
    [str appendFormat:@"[%ld]",(long)index];

    while (![currentView isKindOfClass:[NSView class]]) {
        currentView = [currentView superview];
        if (!currentView) {
            break;
        }
        [str insertString:[NSString stringWithFormat:@"%@/",NSStringFromClass([currentView class])] atIndex:0];
    }

    NSWindow *window = self.window;
    window?[str insertString:[NSString stringWithFormat:@"%@/",NSStringFromClass(window.class)] atIndex:0]:nil;
    return str;
}
-(NSString *)dataflux_actionName{
    return [NSString stringWithFormat:@"[%@]",NSStringFromClass(self.class)];
}

-(id)dataflux_controller{
    NSResponder *nextResponder = self.nextResponder;
    while (nextResponder != nil) {
        //  获取 view 的 viewcontroller 时 不考虑 NSCollectionViewItem
       if ([nextResponder isKindOfClass:NSViewController.class]&&![nextResponder isKindOfClass:NSCollectionViewItem.class]) {
            break;
        }else if([nextResponder isKindOfClass:NSPanel.class]){
            nextResponder = [NSApplication sharedApplication].keyWindow.contentViewController?:[NSApplication sharedApplication].keyWindow;
        }else if([nextResponder isKindOfClass:NSWindow.class]){
            break;
        }else{
            nextResponder = nextResponder.nextResponder;
        }
    }
    return nextResponder;
}
@end

@implementation NSPopUpButton (FTAutoTrack)
-(NSString *)dataflux_actionName{
    if (self.selectedItem.title.length>0) {
        return [NSString stringWithFormat:@"[NSPopUpButton]%@",self.selectedItem.title];
    }else{
        return @"[NSPopUpButton]";
    }
}
@end
@implementation NSButton (FTAutoTrack)
-(NSString *)dataflux_actionName{
    if (self.title.length>0) {
        return [NSString stringWithFormat:@"[%@]%@",NSStringFromClass(self.class),self.title];
    }else{
        return [NSString stringWithFormat:@"[%@]",NSStringFromClass(self.class)];
    }
}
@end
