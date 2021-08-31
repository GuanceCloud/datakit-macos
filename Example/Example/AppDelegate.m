//
//  AppDelegate.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/8/31.
//

#import "AppDelegate.h"
#import <FTSDKAgent.h>
#import <FTTrackConfig.h>
@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *url = [processInfo environment][@"ACCESS_SERVER_URL"];
    FTTrackConfig *config = [[FTTrackConfig alloc]initWithMetricsUrl:url];
    [FTSDKAgent startWithConfigOptions:config];
    [[FTSDKAgent sharedInstance] logging:@"applicationDidFinishLaunching" status:FTStatusInfo];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
