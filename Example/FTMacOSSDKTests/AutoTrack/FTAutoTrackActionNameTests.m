//
//  FTAutoTrackActionNameTests.m
//  FTMacOSSDKTests
//
//  Created by hulilei on 2023/5/5.
//

#import <XCTest/XCTest.h>
#import "FTTestHelper.h"
#import "NSCollectionView+FTAutoTrack.h"
#import "NSMenuItem+FTAutoTrack.h"
#import "NSTabView+FTAutoTrack.h"
#import "NSView+FTAutoTrack.h"
#import "FTMacOSSDK.h"
#import "FTTrackerEventDBTool.h"
#import "LoginWindow.h"
#import "FTSDKAgent+Private.h"
#import "FTRUMManager.h"
#import "FTGlobalRumManager+Private.h"
@interface FTAutoTrackActionNameTests : FTTestHelper
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *appid;
@end

@implementation FTAutoTrackActionNameTests
// NSButton、NSPopUpButton、NSSegmentedControl
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    self.url = [processInfo environment][@"ACCESS_SERVER_URL"];
    self.appid = [processInfo environment][@"APP_ID"];
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
    NSSegmentedControl *menuControl = [[NSSegmentedControl alloc]init];
    menuControl.segmentCount = 3;
    [menuControl setMenu:[[NSMenu alloc]initWithTitle:@"one"] forSegment:0];
    [menuControl setMenu:[[NSMenu alloc]initWithTitle:@"two"] forSegment:1];
    [menuControl setMenu:[[NSMenu alloc]initWithTitle:@"three"] forSegment:2];
    [menuControl setSelectedSegment:2];
    
    XCTAssertTrue([[menuControl datakit_actionName] isEqualToString:@"[NSSegmentedControl]three"]);

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
    NSSecureTextField *secureLable = [[NSSecureTextField alloc]init];
    secureLable.stringValue = @"secureTest";
    XCTAssertTrue([[secureLable datakit_actionName] isEqualToString:@"[NSSecureTextField]"]);

}
- (void)testImageViewActionName{
    NSImageView *image = [[NSImageView alloc]init];
    image.image = [NSImage imageNamed:NSImageNameComputer];
    XCTAssertTrue([[image datakit_actionName] isEqualToString:@"[NSImageView]"]);
}
- (void)testLaunchAction{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [self setRumConfig];
    XCTestExpectation *expectation= [self expectationWithDescription:@"异步操作timeout"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    [[FTGlobalRumManager sharedManager].rumManager syncProcess];
    NSArray *array = [[FTTrackerEventDBTool sharedManger] getFirstRecords:10 withType:FT_DATA_TYPE_RUM];
    BOOL hasLaunchData = NO;
    for (FTRecordModel *model in array) {
        NSDictionary *dict = [FTJSONUtil dictionaryWithJsonString:model.data];
         if([dict[FT_OP] isEqualToString:FT_DATA_TYPE_RUM]){
             NSDictionary *data = dict[FT_OPDATA];
             if([data[FT_KEY_SOURCE] isEqualToString:FT_RUM_SOURCE_ACTION]){
                 NSDictionary *tags = data[FT_TAGS];
                 NSString *actionName = tags[FT_KEY_ACTION_NAME];
                 XCTAssertTrue([actionName isEqualToString:@"app_cold_start"]);
                 hasLaunchData = YES;
                 break;
             }
         }
     }
     XCTAssertTrue(hasLaunchData == YES);
     [[FTSDKAgent sharedInstance] sdkDeinitialize];
}
- (void)testClick{
    [self setRumConfig];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    NSArray *array = [NSApplication sharedApplication].windows;
    for (NSWindow *window in array) {
        if([window isKindOfClass:LoginWindow.class]){
            NSSearchField *search = [window.contentView viewWithTag:50];
            search.stringValue = @"asd";
            NSView *view = [window.contentView viewWithTag:100];
            [self clickAtView:view];
        }
    }
    XCTestExpectation *expectation2= [self expectationWithDescription:@"异步操作timeout"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation2 fulfill];
    });
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}


- (void)setRumConfig{
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    config.enableSDKDebugLog = YES;
    [FTSDKAgent startWithConfigOptions:config];
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:self.appid];
    rumConfig.errorMonitorType = FTErrorMonitorAll;
    rumConfig.enableTraceUserView = YES;
    rumConfig.enableTraceUserAction = YES;
    rumConfig.deviceMetricsMonitorType = FTDeviceMetricsMonitorAll;
    rumConfig.monitorFrequency = FTMonitorFrequencyFrequent;
    [[FTSDKAgent sharedInstance] startRumWithConfigOptions:rumConfig];
    [[FTTrackerEventDBTool sharedManger] deleteItemWithTm:[FTDateUtil currentTimeNanosecond]];
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
