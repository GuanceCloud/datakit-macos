//
//  FTMacOSSDKTests.m
//  FTMacOSSDKTests
//
//  Created by 胡蕾蕾 on 2021/8/2.
//

#import <XCTest/XCTest.h>
#import "FTDateUtil.h"
#import "FTRecordModel.h"
#import "FTTrackDataManager.h"
#import "FTTrackerEventDBTool.h"
#import "FTConstants.h"
#import "FTMacOSSDK.h"
#import "FTSDKAgent+Private.h"
#import "FTJSONUtil.h"
@interface FTMacOSSDKTests : XCTestCase
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *traceUrl;
@end

@implementation FTMacOSSDKTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    self.url = [processInfo environment][@"ACCESS_SERVER_URL"];
    self.traceUrl = [processInfo environment][@"TRACE_URL"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testSDKInit{
    XCTAssertThrows([FTSDKAgent sharedInstance]);
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    config.enableSDKDebugLog = YES;
    [FTSDKAgent startWithConfigOptions:config];
    XCTAssertNoThrow([FTSDKAgent sharedInstance]);
    [[FTSDKAgent sharedInstance] sdkDeinitialize];
}
- (void)testSDKConfigService{
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    [FTSDKAgent startWithConfigOptions:config];
    FTLoggerConfig *logger = [[FTLoggerConfig alloc]init];
    logger.enableCustomLog = YES;
    [[FTSDKAgent sharedInstance] startLoggerWithConfigOptions:logger];
    [[FTSDKAgent sharedInstance] logging:@"testSDKConfigService" status:FTStatusOk];
    [[FTSDKAgent sharedInstance] syncProcess];
    [[FTTrackerEventDBTool sharedManger]insertCacheToDB];
    NSArray *datas = [[FTTrackerEventDBTool sharedManger] getFirstRecords:1 withType:FT_DATA_TYPE_LOGGING];
    FTRecordModel *model = [datas firstObject];
    NSDictionary *dict = [FTJSONUtil dictionaryWithJsonString:model.data];
    NSDictionary *op = dict[@"opdata"];
    NSDictionary *tags = op[FT_TAGS];
    XCTAssertTrue([tags[FT_KEY_SERVICE] isEqualToString:@"df_rum_macos"]);
    XCTAssertTrue([tags[FT_KEY_SERVICE] isEqualToString:@"df_rum_macos"]);

    [[FTSDKAgent sharedInstance] sdkDeinitialize];
}
- (void)testSDKConfigCopy{
    FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:self.url];
    config.enableSDKDebugLog = YES;
    config.globalContext = @{@"aa":@"bb"};
    config.service = @"testsdk";
    config.version = @"1.1.1";
    config.env = FTEnvLocal;
    FTSDKConfig *copyConfig = [config copy];
    XCTAssertTrue(copyConfig.enableSDKDebugLog == config.enableSDKDebugLog);
    XCTAssertTrue(copyConfig.env == config.env);
    XCTAssertTrue([copyConfig.service isEqualTo:config.service]);
    XCTAssertTrue([copyConfig.version isEqualTo:config.version]);
    XCTAssertTrue([copyConfig.globalContext isEqual:config.globalContext]);
}
- (void)testRUMConfigCopy{
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:@"app_id1111"];
    rumConfig.sampleRate = 50;
    rumConfig.enableTraceUserAction = YES;
    rumConfig.enableTraceUserView = YES;
    rumConfig.enableTraceUserResource = YES;
    rumConfig.enableTrackAppANR = YES;
    rumConfig.enableTrackAppCrash = YES;
    rumConfig.enableTrackAppFreeze = YES;
    rumConfig.errorMonitorType = FTErrorMonitorMemory;
    rumConfig.deviceMetricsMonitorType = FTDeviceMetricsMonitorCpu;
    rumConfig.monitorFrequency = FTMonitorFrequencyFrequent;
    rumConfig.globalContext = @{@"aa":@"bb"};
    FTRumConfig *copyRumConfig = [rumConfig copy];
    XCTAssertTrue(copyRumConfig.sampleRate == rumConfig.sampleRate);
    XCTAssertTrue(copyRumConfig.enableTraceUserAction == rumConfig.enableTraceUserAction);
    XCTAssertTrue(copyRumConfig.enableTraceUserView == rumConfig.enableTraceUserView);
    XCTAssertTrue(copyRumConfig.enableTraceUserResource == rumConfig.enableTraceUserResource);
    XCTAssertTrue(copyRumConfig.enableTrackAppANR == rumConfig.enableTrackAppANR);
    XCTAssertTrue(copyRumConfig.enableTrackAppCrash == rumConfig.enableTrackAppCrash);
    XCTAssertTrue(copyRumConfig.enableTrackAppFreeze == rumConfig.enableTrackAppFreeze);
    XCTAssertTrue(copyRumConfig.errorMonitorType == rumConfig.errorMonitorType);
    XCTAssertTrue(copyRumConfig.deviceMetricsMonitorType == rumConfig.deviceMetricsMonitorType);
    XCTAssertTrue(copyRumConfig.monitorFrequency == rumConfig.monitorFrequency);
    XCTAssertTrue([copyRumConfig.globalContext isEqual:rumConfig.globalContext]);

}
- (void)testTraceConfigCopy{
    FTTraceConfig *traceConfig = [[FTTraceConfig alloc]init];
    traceConfig.enableAutoTrace = YES;
    traceConfig.enableLinkRumData = YES;
    traceConfig.sampleRate = 50;
    traceConfig.networkTraceType = FTNetworkTraceTypeTraceparent;
    FTTraceConfig *copyTraceConfig = [traceConfig copy];
    XCTAssertTrue(copyTraceConfig.enableAutoTrace == traceConfig.enableAutoTrace);
    XCTAssertTrue(copyTraceConfig.enableLinkRumData == traceConfig.enableLinkRumData);
    XCTAssertTrue(copyTraceConfig.sampleRate == traceConfig.sampleRate);
    XCTAssertTrue(copyTraceConfig.networkTraceType == traceConfig.networkTraceType);
}
- (void)testLoggerConfigCopy{
    FTLoggerConfig *loggerConfig = [[FTLoggerConfig alloc]init];
    loggerConfig.enableCustomLog = YES;
    [loggerConfig enableConsoleLog:YES prefix:@"test"];
    loggerConfig.sampleRate = 50;
    loggerConfig.discardType = FTDiscard;
    loggerConfig.enableLinkRumData = YES;
    loggerConfig.logLevelFilter = @[@(FTStatusOk)];
    loggerConfig.globalContext = @{@"aa":@"bb"};
    FTLoggerConfig *copyLoggerConfig = [loggerConfig copy];
    XCTAssertTrue(copyLoggerConfig.enableCustomLog == loggerConfig.enableCustomLog);
    XCTAssertTrue(copyLoggerConfig.enableConsoleLog == loggerConfig.enableConsoleLog);
    XCTAssertTrue(copyLoggerConfig.sampleRate == loggerConfig.sampleRate);
    XCTAssertTrue(copyLoggerConfig.discardType == loggerConfig.discardType);
    XCTAssertTrue([copyLoggerConfig.prefix isEqualToString:loggerConfig.prefix]);
    XCTAssertTrue(copyLoggerConfig.enableLinkRumData == loggerConfig.enableLinkRumData);
    XCTAssertTrue([copyLoggerConfig.logLevelFilter isEqual: loggerConfig.logLevelFilter]);
    XCTAssertTrue([copyLoggerConfig.globalContext isEqual: loggerConfig.globalContext]);


}


@end
