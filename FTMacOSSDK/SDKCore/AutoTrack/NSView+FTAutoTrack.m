//
//  NSView+FTAutoTrack.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/15.
//

#import "NSView+FTAutoTrack.h"

@implementation NSView (FTAutoTrack)
-(NSString *)viewPath{
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
-(NSString *)actionName{
    return [NSString stringWithFormat:@"[%@]",NSStringFromClass(self.class)];
}
-(BOOL )inMainWindow{
    return self.window.isMainWindow;
}
@end

@implementation NSPopUpButton (FTAutoTrack)
-(NSString *)actionName{
    if (self.selectedItem.title.length>0) {
        return [NSString stringWithFormat:@"[NSPopUpButton]%@",self.selectedItem.title];
    }else{
        return @"[NSPopUpButton]";
    }
}
@end
@implementation NSButton (FTAutoTrack)
-(NSString *)actionName{
    if (self.title.length>0) {
        return [NSString stringWithFormat:@"[%@]%@",NSStringFromClass(self.class),self.title];
    }else{
        return [NSString stringWithFormat:@"[%@]",NSStringFromClass(self.class)];
    }
}
@end
