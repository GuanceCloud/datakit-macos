//
//  FTTestHelper.m
//  FTMacOSSDKTests
//
//  Created by hulilei on 2023/5/9.
//

#import "FTTestHelper.h"
#include <Carbon/Carbon.h>
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
 *
 *
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
@implementation FTTestHelper
- (void)clickAtView:(NSView *)view{
    NSRect rect = [NSScreen mainScreen].frame;
    NSWindow *window = view.window;
    CGFloat y =  rect.size.height - window.frame.origin.y - window.frame.size.height;
    CGPoint clickPoint = CGPointMake(window.frame.origin.x + view.frame.origin.x +view.frame.size.width/2, y+view.frame.origin.y+view.frame.size.height/2);
    XCTestExpectation *expectation= [self expectationWithDescription:@"异步操作timeout"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, clickPoint, 1);
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, clickPoint, 1);
}
@end
