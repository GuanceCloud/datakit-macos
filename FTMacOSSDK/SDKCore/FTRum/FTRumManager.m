//
//  FTRumManager.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "FTRumManager.h"
#import "FTConfigManager.h"
#import "FTAutoTrackProtocol.h"
#import "NSView+FTAutoTrack.h"
#import "FTLog.h"
#import "FTAppLifeCycle.h"
#import "FTRUMDataModel.h"
@interface FTRumManager ()<FTAppLifeCycleDelegate>
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, assign) BOOL traceOpen;
@end
@implementation FTRumManager


+(instancetype)sharedInstance{
    static FTRumManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FTRumManager alloc]init];
    });
    
    return manager;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _serialQueue= dispatch_queue_create([@"io.serialQueue.rum" UTF8String], DISPATCH_QUEUE_SERIAL);
        if([FTConfigManager sharedInstance].rumConfig.appid.length>0){
            _traceOpen = YES;
        }else{
            _traceOpen = NO;
            ZYDebug(@"【FTRumConfig appid】 is disabled ");
        }
        [[FTAppLifeCycle sharedInstance] addAppLifecycleDelegate:self];
    }
    return self;
}

- (void)addActionEventWithView:(NSView *)view{
    if (!self.traceOpen) {
        return;
    }
    if(![FTConfigManager sharedInstance].rumConfig.enableTraceUserAction){
        return;
    }
    
    id<FTViewProperty> clickView = view;
    
    
    NSString *actionName = clickView.actionName;
    NSString *actionType = @"click";
    dispatch_async(self.serialQueue, ^{
    FTRUMActionModel *action = [[FTRUMActionModel alloc]initWithActionID:[[NSUUID UUID]UUIDString] actionName:actionName actionType:actionType];
    });
    
}
- (void)addViewAppearEvent:(NSViewController *)view{
    if (!self.traceOpen) {
        return;
    }
    dispatch_async(self.serialQueue, ^{
        
    });
}
- (void)addViewDisappearEvent:(NSViewController *)view{
    if (!self.traceOpen) {
        return;
    }
    dispatch_async(self.serialQueue, ^{
        
    });
}

- (void)applicationDidBecomeActive{
    
}

- (void)applicationWillTerminate{
    dispatch_sync(self.serialQueue, ^{
        
    });
}
@end
