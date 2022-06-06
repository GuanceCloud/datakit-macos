//
//  FTMacOSSDKTests.m
//  FTMacOSSDKTests
//
//  Created by 胡蕾蕾 on 2021/8/2.
//

#import <XCTest/XCTest.h>
#import <FTSDKAgent.h>
#import <FTConfig.h>
#import "FTDateUtil.h"
#import "FTRecordModel.h"
#import "FTTrackDataManger.h"
#import "FTRequest.h"
#import "FTNetworkManager.h"
#import "FTTrackerEventDBTool.h"

@interface FTMacOSSDKTests : XCTestCase

@end

@implementation FTMacOSSDKTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *url = [processInfo environment][@"ACCESS_SERVER_URL"];
    FTConfig *config = [[FTConfig alloc]initWithMetricsUrl:url];
    [FTSDKAgent startWithConfigOptions:config];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testCurrentDate{
   long long time = [FTDateUtil currentTimeMillisecond];
}

- (void)testEventUpload{
    XCTestExpectation *expectation= [self expectationWithDescription:@"异步操作timeout"];
    FTRecordModel *model = [[FTRecordModel alloc]initWithSource:@"testUploading" op:FT_DATA_TYPE_LOGGING tags:@{@"name":@"testEventUpload1"} field:@{@"event":@"testEventUpload"} tm:[FTDateUtil currentTimeNanosecond]];
    NSInteger oldCount = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    
    [[FTTrackDataManger sharedInstance] addTrackData:model type:FTAddDataNormal];
    [NSThread sleepForTimeInterval:2];
    NSInteger newCount = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(newCount>oldCount);
    [NSThread sleepForTimeInterval:10];
    FTRecordModel *model2 = [[FTRecordModel alloc]initWithSource:@"testUploading" op:FT_DATA_TYPE_LOGGING tags:@{@"name":@"testEventUpload2"} field:@{@"event":@"testEventUpload"} tm:[FTDateUtil currentTimeNanosecond]];
    [[FTTrackDataManger sharedInstance] addTrackData:model2 type:FTAddDataNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger uploadedCount = [[FTTrackerEventDBTool sharedManger] getDatasCount];
        XCTAssertTrue(uploadedCount == 0);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
