//
//  FTNetworkTests.m
//  FTMacOSSDKTests
//
//  Created by 胡蕾蕾 on 2021/8/19.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FTDateUtil.h>
#import "FTTrackDataManger.h"
#import "FTRequest.h"
#import <FTMacOSSDK/FTSDKAgent.h>
#import "FTRecordModel.h"
#import "FTNetworkManager.h"
#import "FTTrackConfig.h"
@interface FTNetworkTests : XCTestCase

@end

@implementation FTNetworkTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *url = [processInfo environment][@"ACCESS_SERVER_URL"];
    FTTrackConfig *config = [[FTTrackConfig alloc]initWithMetricsUrl:url];
    [FTSDKAgent startWithConfigOptions:config];
}

- (void)testLoggingUpload{
    XCTestExpectation *expectation= [self expectationWithDescription:@"异步操作timeout"];

    FTRecordModel *model = [[FTRecordModel alloc]initWithSource:@"testUploading" op:FT_DATA_TYPE_LOGGING tags:@{@"name":@"testUpload"} field:@{@"event":@"testUpload"} tm:[FTDateUtil currentTimeNanosecond]];
    FTRequest *request = [[FTRequest alloc]initWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTNetworkManager sharedInstance] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
        XCTAssertTrue(httpResponse.statusCode == 200);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
