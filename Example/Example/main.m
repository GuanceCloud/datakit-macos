//
//  main.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/8/31.
//

#import <Cocoa/Cocoa.h>
#import "FTMacOSSDK.h"
//Target -> Build Settings -> GCC_PREPROCESSOR_DEFINITIONS 进行配置预设定义
#if PRE
#define Track_id       @"0000000001"
#define STATIC_TAG     @"preprod"
#elif  DEVELOP
#define Track_id       @"0000000002"
#define STATIC_TAG     @"common"
#else
#define Track_id       @"0000000003"
#define STATIC_TAG     @"prod"
#endif
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSString *url = [processInfo environment][@"ACCESS_SERVER_URL"];
        NSString *appid = [processInfo environment][@"APP_ID"];
        BOOL isRuningUnitTest = [[processInfo environment][@"isUnitTests"] boolValue];
        if(!isRuningUnitTest){
            FTSDKConfig *config = [[FTSDKConfig alloc]initWithMetricsUrl:url];
            config.enableSDKDebugLog = YES;
            [FTSDKAgent startWithConfigOptions:config];
            FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:appid];
            rumConfig.enableTrackAppANR = YES;
            rumConfig.enableTrackAppCrash = YES;
            rumConfig.enableTrackAppFreeze = YES;
            rumConfig.enableTraceUserView = YES;
            rumConfig.enableTraceUserAction = YES;
            rumConfig.enableTraceUserResource = YES;
            rumConfig.errorMonitorType = FTErrorMonitorAll;
            rumConfig.deviceMetricsMonitorType = FTDeviceMetricsMonitorAll;
            rumConfig.globalContext = @{@"track_id":Track_id,@"static_tag":STATIC_TAG};
            [[FTSDKAgent sharedInstance]startRumWithConfigOptions:rumConfig];
            FTLoggerConfig *logger = [[FTLoggerConfig alloc]init];
            logger.enableCustomLog = YES;
            logger.enableLinkRumData = YES;
            [[FTSDKAgent sharedInstance] startLoggerWithConfigOptions:logger];
            FTTraceConfig *trace = [[FTTraceConfig alloc]init];
            trace.enableAutoTrace = YES;
            trace.enableLinkRumData = YES;
            [[FTSDKAgent sharedInstance] startTraceWithConfigOptions:trace];
            [[FTSDKAgent sharedInstance] logging:@"main" status:FTStatusInfo];
        }
    }
    return NSApplicationMain(argc, argv);
}
