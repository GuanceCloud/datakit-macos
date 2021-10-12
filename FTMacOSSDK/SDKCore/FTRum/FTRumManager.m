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
#import "FTRUMSessionHandler.h"
@interface FTRumManager ()<FTAppLifeCycleDelegate,FTRUMSessionProtocol>
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, assign) BOOL traceOpen;
@property (nonatomic, strong) FTRUMSessionHandler *sessionHandler;
@property (nonatomic, strong) NSSet *ignoredPrivateControllers;

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

- (void)addActionEventWithView:(id)view{
    if (!self.traceOpen) {
        return;
    }
    if(![FTConfigManager sharedInstance].rumConfig.enableTraceUserAction){
        return;
    }
    NSDate *time = [NSDate date];
    id<FTRUMActionProperty> clickView = view;
    NSString *actionName = clickView.dataflux_actionName;
    NSString *actionType = @"click";
    id<FTRumViewProperty> controller = clickView.dataflux_controller;
    NSString *view_id = controller.dataflux_viewUUID;
    if(!view_id){
        return;
    }
    dispatch_async(self.serialQueue, ^{
        FTRUMActionModel *action = [[FTRUMActionModel alloc]initWithActionID:[[NSUUID UUID]UUIDString] actionName:actionName actionType:actionType];
        action.actionView_id = view_id;
        action.time = time;
        action.currentViewController = controller;
        [self process:action];
    });
    
}
- (void)addViewAppearEvent:(id)view{
    if (!self.traceOpen) {
        return;
    }
    if ([self.ignoredPrivateControllers containsObject:NSStringFromClass([view class])]) {
        return;
    }
    id<FTRumViewProperty> appearView = view;
    NSDate *time = appearView.dataflux_viewLoadStartTime?:[NSDate date];
    NSString *viewReferrer = appearView.dataflux_parentVC;
    NSString *viewID = appearView.dataflux_viewUUID;
    dispatch_async(self.serialQueue, ^{
        NSString *className = NSStringFromClass(appearView.class);
        //viewModel
        FTRUMViewModel *viewModel = [[FTRUMViewModel alloc]initWithType:FTRUMDataViewStart time:time];
        viewModel.loading_time = appearView.dataflux_loadDuration;
        viewModel.currentViewController = appearView;
        viewModel.view_referrer = viewReferrer;
        viewModel.view_id = viewID;
        viewModel.view_name = className;
        [self process:viewModel];
    });
}
- (void)addViewDisappearEvent:(id)view{
    if (!self.traceOpen) {
        return;
    }
    if ([self.ignoredPrivateControllers containsObject:NSStringFromClass([view class])]) {
        return;
    }
    id<FTRumViewProperty> disAppearView = view;
    NSDate *time = [NSDate date];
    NSString *viewID = disAppearView.dataflux_viewUUID;
    dispatch_async(self.serialQueue, ^{
        FTRUMViewModel *viewModel = [[FTRUMViewModel alloc]initWithType:FTRUMDataViewStop time:time];
        viewModel.view_id = viewID;
        viewModel.time = time;
        viewModel.currentViewController = disAppearView;
        [self process:viewModel];
    });
}

- (void)applicationDidBecomeActive{
    
}

- (void)applicationWillTerminate{
    dispatch_sync(self.serialQueue, ^{
        
    });
}


#pragma mark - FTRUMSessionProtocol -
-(BOOL)process:(FTRUMDataModel *)model{
    FTRUMSessionHandler *current  = self.sessionHandler;
    if (current) {
        if ([self manage:self.sessionHandler byPropagatingData:model] == nil) {
            //刷新
            [self.sessionHandler refreshSession];
            [self.sessionHandler.assistant process:model];
        }
    }else{
        //初始化
        self.sessionHandler = [[FTRUMSessionHandler alloc]initWithModel:model];
        [self.sessionHandler.assistant process:model];
    }
    
    return YES;
}
- (NSSet *)ignoredPrivateControllers {
    if (!_ignoredPrivateControllers) {
        _ignoredPrivateControllers = [NSSet setWithArray:@[@"NSTitlebarAccessoryViewController",@"NSTitlebarViewController"]];
    }
    return _ignoredPrivateControllers;
}
-(NSDictionary *)getGlobalSessionViewTags{
    if (self.sessionHandler) {
        return [self.sessionHandler getCurrentSessionInfo];
    }else{
        return @{};
    }
}
@end
