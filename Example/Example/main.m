//
//  main.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/8/31.
//

#import <Cocoa/Cocoa.h>
#import <FTMacOSSDK/FTMacOSSDK.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSString *url = @"aaa";
        //[processInfo environment][@"ACCESS_SERVER_URL"];
        NSString *appid = [processInfo environment][@"APP_ID"];

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
        rumConfig.deviceMetricsMonitorType = FTDeviceMetricsMonitorAll;
        [[FTSDKAgent sharedInstance]startRumWithConfigOptions:rumConfig];
        FTLoggerConfig *logger = [[FTLoggerConfig alloc]init];
        logger.enableCustomLog = YES;
        [[FTSDKAgent sharedInstance] startLoggerWithConfigOptions:logger];
        FTTraceConfig *trace = [[FTTraceConfig alloc]init];
        trace.enableAutoTrace = YES;
        trace.enableLinkRumData = YES;
        [[FTSDKAgent sharedInstance] startTraceWithConfigOptions:trace];
        [[FTSDKAgent sharedInstance] logging:@"main" status:FTStatusInfo];
        
    }
    return NSApplicationMain(argc, argv);
}
