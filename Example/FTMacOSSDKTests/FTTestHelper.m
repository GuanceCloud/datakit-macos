//
//  FTTestHelper.m
//  FTMacOSSDKTests
//
//  Created by hulilei on 2023/5/9.
//

#import "FTTestHelper.h"
#include <Carbon/Carbon.h>
#import "LoginWindow.h"
#import "SplitViewVC.h"
#import "SplitViewItemVC2.h"
#import "TabViewController.h"
#import "MainWindow.h"
/**
 * View Tags:
 * 登录页 NSSearchField ：50
 * 登录页 LoginBtn: 100
 * TableView Item:
 *  AutoTrack   : 200
 *  RUM数据采集  : 201
 *  日志输出     : 202
 *  网络链路追踪  : 203
 *  绑定用户     : 204
 *  解绑用户     : 205
 *  控制台日志采集: 206
 *  TabViewItem: 300
 *  CollectionViewItem:305-310
 *  NSPopUpButton: 320
 *  NSComboBox:    321
 *  NSButton-Check: 322
 */
void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point, int64_t clickCount)
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStatePrivate);
    CGEventRef theEvent = CGEventCreateMouseEvent(source, type, point, button);
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, clickCount);
    CGEventSetType(theEvent, type);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
    CFRelease(source);
}
void dPostKeyboardEvent(CGKeyCode virtualKey, bool keyDown, CGEventFlags flags)
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStatePrivate);
    CGEventRef push = CGEventCreateKeyboardEvent(source, virtualKey, keyDown);
    CGEventSetFlags(push, flags);
    CGEventPost(kCGHIDEventTap, push);
    CFRelease(push);
    CFRelease(source);
}
@interface FTTestHelper()<NSComboBoxDelegate>
@property (nonatomic, strong) XCTestExpectation *popBtnExpectation;
@end
@implementation FTTestHelper
- (void)clickView:(TestClickView)view{
    NSView *clickView;
    NSWindow *keyWindow = [NSApplication sharedApplication].keyWindow;
    if(!keyWindow){
        return;
    }
    CGPoint offset = CGPointZero;
    switch (view) {
        case ClickTabViewItem_First:
            clickView = [keyWindow.contentView viewWithTag:ClickTabViewItem_First];
            offset = CGPointMake(-60, 45);
            break;
        case ClickTabViewItem_Second:
            clickView = [keyWindow.contentView viewWithTag:ClickTabViewItem_First];
            offset = CGPointMake(0, 45);
            break;
        case ClickTabViewItem_Third:
            clickView = [keyWindow.contentView viewWithTag:ClickTabViewItem_First];
            offset = CGPointMake(60, 45);
            break;
        case ClickPopUpButton:
            clickView = [keyWindow.contentView viewWithTag:view];
            break;
        case ClickComboBox:
            clickView = [keyWindow.contentView viewWithTag:view];
            offset = CGPointMake(clickView.frame.size.width/2-10, 0);
            break;
        default:
            clickView = [keyWindow.contentView viewWithTag:view];
            break;
    }
    if(clickView){
        if(view == ClickPopUpButton){
            NSPopUpButton *button = (NSPopUpButton *)clickView;
            CGPoint point =  [self getViewPointInWindow:clickView offset:offset];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSelectPopBtn:) name:NSPopUpButtonWillPopUpNotification object:button];
            [self clickAtPoint:point];
            self.popBtnExpectation = [self expectationWithDescription:@"异步操作timeout"];
            [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
                XCTAssertNil(error);
            }];
        }else if(view == ClickComboBox){
//            NSComboBox *box = (NSComboBox *)clickView;
//            box.delegate = self;
            CGPoint point =  [self getViewPointInWindow:clickView offset:offset];
            [self clickAtPoint:point];
            [self clickAtPoint:point];

//            self.popBtnExpectation = [self expectationWithDescription:@"异步操作timeout"];
//            [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
//                XCTAssertNil(error);
//            }];
        }else{
            [self clickAtView:clickView offset:offset];
        }
    }
    
}
- (void)comboBoxWillPopUp:(NSNotification *)notification{
    CGPoint point =  [self getViewPointInWindow:notification.object offset:CGPointMake(0, 20)];
    [self.popBtnExpectation fulfill];
    self.popBtnExpectation = nil;
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point, 2);
}
- (void)handleSelectPopBtn:(NSNotification *)notification{
    CGPoint point =  [self getViewPointInWindow:notification.object offset:CGPointMake(0, 20)];
    [self.popBtnExpectation fulfill];
    self.popBtnExpectation = nil;
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point, 2);

}
- (CGPoint)getViewPointInWindow:(NSView *)view offset:(CGPoint)offset{
    NSRect rect = [NSScreen mainScreen].frame;
    NSWindow *window = view.window;
    NSRect viewRect = [view convertRect:view.bounds toView:window.contentViewController.view];
    CGFloat y =  rect.size.height - window.frame.origin.y - window.frame.size.height;
    if (![window.contentView isFlipped]){
        viewRect.origin.y = window.frame.size.height - viewRect.origin.y - viewRect.size.height;
    }
    CGPoint clickPoint = CGPointMake(window.frame.origin.x + viewRect.origin.x +viewRect.size.width/2+offset.x, y+viewRect.origin.y+viewRect.size.height/2+offset.y);
    return clickPoint;
}
- (void)clickAtView:(NSView *)view{
    [self clickAtView:view offset:CGPointZero];
}
- (void)clickAtView:(NSView *)view offset:(CGPoint)offset{
    CGPoint clickPoint = [self getViewPointInWindow:view offset:offset];
    [self sleep:0.5];
    [self clickAtPoint:clickPoint];
}
- (void)clickAtPoint:(CGPoint)clickPoint{
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, clickPoint, 1);
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, clickPoint, 1);
}
- (void)sleep:(NSInteger)time{
    XCTestExpectation *expectation= [self expectationWithDescription:@"异步操作timeout"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
- (void)jumpToMainTestWindow{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    NSArray *array = [NSApplication sharedApplication].windows;
    for (NSWindow *window in array) {
        if([window isKindOfClass:LoginWindow.class]){
            [window becomeKeyWindow];
            NSSearchField *search = [window.contentView viewWithTag:50];
            search.stringValue = @"asd";
            NSView *view = [window.contentView viewWithTag:100];
            [self clickAtView:view];
            [self sleep:1];
            break;
        }else if ([window.contentViewController isKindOfClass:[SplitViewVC class]]){
            [window becomeKeyWindow];
            break;
        }
    }
}
@end
