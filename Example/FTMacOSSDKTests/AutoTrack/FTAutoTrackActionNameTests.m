//
//  FTAutoTrackActionNameTests.m
//  FTMacOSSDKTests
//
//  Created by hulilei on 2023/5/5.
//

#import <XCTest/XCTest.h>
#import "NSCollectionView+FTAutoTrack.h"
#import "NSMenuItem+FTAutoTrack.h"
#import "NSTabView+FTAutoTrack.h"
#import "NSView+FTAutoTrack.h"

@interface FTAutoTrackActionNameTests : XCTestCase

@end

@implementation FTAutoTrackActionNameTests
// NSButton、NSPopUpButton、NSSegmentedControl
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testButtonActionName{
    NSButton *button = [[NSButton alloc]init];
    button.title = @"testActionName";
    NSString *actionName = [button datakit_actionName];
    XCTAssertTrue([actionName isEqualToString:@"[NSButton]testActionName"]);
    
    NSButton *checkButton = [NSButton checkboxWithTitle:@"check" target:self action:@selector(check)];
    checkButton.state = NSControlStateValueOn;
    XCTAssertTrue([[checkButton datakit_actionName] isEqualToString:@"[NSButton]check"]);
}
- (void)testPopUpButtonActionName{
    NSPopUpButton *popupButton = [[NSPopUpButton alloc]init];
    [popupButton addItemsWithTitles:@[@"常速", @"2倍速", @"4倍速", @"8倍速", @"16倍速"]];
    XCTAssertTrue([[popupButton datakit_actionName] isEqualToString:@"[NSPopUpButton]常速"]);
    [popupButton selectItemAtIndex:1];
    XCTAssertTrue([[popupButton datakit_actionName] isEqualToString:@"[NSPopUpButton]2倍速"]);
}
- (void)testSegmentedControlActionName{
    NSSegmentedControl *segmentedControl = [[NSSegmentedControl alloc]init];
    segmentedControl.segmentCount = 3;
    [segmentedControl setLabel:@"first" forSegment:0];
    [segmentedControl setLabel:@"second" forSegment:1];
    [segmentedControl setLabel:@"third" forSegment:2];
    [segmentedControl setSelectedSegment:1];
    XCTAssertTrue([[segmentedControl datakit_actionName] isEqualToString:@"[NSSegmentedControl]second"]);
}
- (void)testStepperActionName{
    NSStepper *stepper = [[NSStepper alloc]init];
    stepper.minValue = 0;
    stepper.maxValue = 100;
    XCTAssertTrue([[stepper datakit_actionName] isEqualToString:@"[NSStepper]0"]);
}
- (void)testSliderActionName{
    NSSlider *slider = [[NSSlider alloc]init];
    slider.minValue = 0;
    slider.maxValue = 100;
    XCTAssertTrue([[slider datakit_actionName] isEqualToString:@"[NSSlider]0"]);
}
- (void)testComboBoxActionName{
    NSComboBox *comboBox = [[NSComboBox alloc]init];
    [comboBox addItemWithObjectValue:@1];
    [comboBox addItemWithObjectValue:@2];
    [comboBox addItemsWithObjectValues:@[@3,@4,@5,@6]];
    [comboBox selectItemWithObjectValue:@2];
    XCTAssertTrue([[comboBox datakit_actionName] isEqualToString:@"[NSComboBox]2"]);
}
- (void)testSwitchActionName{
    if (@available(macOS 10.15, *)) {
        NSSwitch *mSwitch = [[NSSwitch alloc]init];
        mSwitch.state = NSControlStateValueOn;
        XCTAssertTrue([[mSwitch datakit_actionName] isEqualToString:@"[NSSwitch]On"]);
    }
}
// NSGestureRecognizer
// 
- (void)testLableActionName{
    NSTextField *lable = [[NSTextField alloc]init];
    lable.stringValue = @"test";
    XCTAssertTrue([[lable datakit_actionName] isEqualToString:@"[NSTextField]test"]);
}
- (void)testImageViewActionName{
    NSImageView *image = [[NSImageView alloc]init];
    image.image = [NSImage imageNamed:NSImageNameComputer];
    XCTAssertTrue([[image datakit_actionName] isEqualToString:@"[NSImageView]"]);
}
- (void)check{
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
