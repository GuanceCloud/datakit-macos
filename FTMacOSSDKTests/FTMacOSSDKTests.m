//
//  FTMacOSSDKTests.m
//  FTMacOSSDKTests
//
//  Created by 胡蕾蕾 on 2021/8/2.
//

#import <XCTest/XCTest.h>
#import <Utils/FTDateUtil.h>
@interface FTMacOSSDKTests : XCTestCase

@end

@implementation FTMacOSSDKTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testCurrentDate{
   long long time = [FTDateUtil currentTimeMillisecond];
}
- (void)testExample {
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
