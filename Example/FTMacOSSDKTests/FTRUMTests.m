//
//  FTRUMTests.m
//  ExampleTests
//
//  Created by hulilei on 2023/4/11.
//

#import <XCTest/XCTest.h>
#import "FTSDKAgent+Private.h"
#import "FTMacOSSDK.h"
#import "FTConstants.h"
#import "FTTrackerEventDBTool.h"
#import "FTRUMManager.h"
#import "FTGlobalRumManager+Private.h"
#import "FTTrackerEventDBTool.h"
#import "FTDateUtil.h"
@interface FTRUMTests : XCTestCase
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *traceUrl;
@property (nonatomic, copy) NSString *appid;
@end

@implementation FTRUMTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    self.url = [processInfo environment][@"ACCESS_SERVER_URL"];
    self.traceUrl = [processInfo environment][@"TRACE_URL"];
    self.appid = [processInfo environment][@"APP_ID"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)setRumConfig{
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    [FTSDKAgent startWithConfigOptions:config];
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:self.appid];
    rumConfig.errorMonitorType = FTErrorMonitorAll;
    rumConfig.deviceMetricsMonitorType = FTDeviceMetricsMonitorAll;
    [[FTSDKAgent sharedInstance] startRumWithConfigOptions:rumConfig];
}
- (void)testSamplerate0{
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:self.appid];
    rumConfig.sampleRate = 0;
    [FTSDKAgent startWithConfigOptions:config];
    [[FTSDKAgent sharedInstance] startRumWithConfigOptions:rumConfig];
    
    NSArray *oldArray = [[FTTrackerEventDBTool sharedManger] getFirstRecords:100 withType:FT_DATA_TYPE_RUM];
    [[FTGlobalRumManager sharedManager] startViewWithName:@"TestSamplerate0"];
    [[FTGlobalRumManager sharedManager] addActionName:@"TestSamplerate0Click" actionType:@"click"];
    [[FTGlobalRumManager sharedManager] addActionName:@"TestSamplerate0Click" actionType:@"click"];
    [[FTGlobalRumManager sharedManager].rumManager syncProcess];
    NSArray *newArray = [[FTTrackerEventDBTool sharedManger] getFirstRecords:100 withType:FT_DATA_TYPE_RUM];
    XCTAssertTrue(newArray.count == oldArray.count);
    
    [[FTSDKAgent sharedInstance] sdkDeinitialize];
}
- (void)testSamplerate100{
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:self.appid];
    rumConfig.sampleRate = 100;
    [FTSDKAgent startWithConfigOptions:config];
    [[FTSDKAgent sharedInstance] startRumWithConfigOptions:rumConfig];
    NSArray *oldArray = [[FTTrackerEventDBTool sharedManger] getFirstRecords:100 withType:FT_DATA_TYPE_RUM];
    [[FTGlobalRumManager sharedManager] startViewWithName:@"TestSamplerate0"];
    [[FTGlobalRumManager sharedManager] addActionName:@"TestSamplerate0Click" actionType:@"click"];
    [[FTGlobalRumManager sharedManager] addActionName:@"TestSamplerate0Click" actionType:@"click"];
    [[FTGlobalRumManager sharedManager].rumManager syncProcess];
    NSArray *newArray = [[FTTrackerEventDBTool sharedManger] getFirstRecords:100 withType:FT_DATA_TYPE_RUM];
    XCTAssertTrue(newArray.count > oldArray.count);
    [[FTSDKAgent sharedInstance] sdkDeinitialize];
}
- (void)testAddViewEvent{
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:self.appid];
    [FTSDKAgent startWithConfigOptions:config];
    [[FTSDKAgent sharedInstance] startRumWithConfigOptions:rumConfig];
    [[FTTrackerEventDBTool sharedManger] deleteItemWithTm:[FTDateUtil currentTimeNanosecond]];
    [[FTGlobalRumManager sharedManager] startViewWithName:@"TestAddViewEvent"];
    [[FTGlobalRumManager sharedManager] startViewWithName:@"TestAddViewEvent2"];
    [[FTGlobalRumManager sharedManager].rumManager syncProcess];
    NSArray *newArray = [[FTTrackerEventDBTool sharedManger] getFirstRecords:100 withType:FT_DATA_TYPE_RUM];
     

}
- (void)testAddActionEvent{
    
}
- (void)testAddResourceEvent{
    
}
- (void)testAddErrorEvent{
    
}
- (void)testAddLongTaskEvent{
    
}
- (void)testBindUser{
    
}
- (void)testGlobalContext{
    
}
@end
