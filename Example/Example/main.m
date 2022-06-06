//
//  main.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/8/31.
//

#import <Cocoa/Cocoa.h>
#import <FTSDKAgent.h>
#import <FTConfig.h>
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSString *url = [processInfo environment][@"ACCESS_SERVER_URL"];
        NSString *appid = [processInfo environment][@"APP_ID"];

        FTConfig *config = [[FTConfig alloc]initWithMetricsUrl:url];
        [FTSDKAgent startWithConfigOptions:config];
        FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:appid];
        rumConfig.enableTraceUserAction = YES;
        [[FTSDKAgent sharedInstance]startRumWithConfigOptions:rumConfig];
        FTLoggerConfig *logger = [[FTLoggerConfig alloc]init];
        logger.enableCustomLog = YES;
        [[FTSDKAgent sharedInstance] startLoggerWithConfigOptions:logger];
        [[FTSDKAgent sharedInstance] logging:@"main" status:FTStatusInfo];
    }
    return NSApplicationMain(argc, argv);
}
