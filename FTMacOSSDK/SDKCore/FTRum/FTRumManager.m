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
    
    id<FTAutoTrackViewProperty> clickView = view;
    
    
    NSString *actionName = clickView.actionName;
    NSString *actionType = @"click";
    dispatch_async(self.serialQueue, ^{
    FTRUMActionModel *action = [[FTRUMActionModel alloc]initWithActionID:[[NSUUID UUID]UUIDString] actionName:actionName actionType:actionType];
    });
    
}
- (void)addViewAppearEvent:(id)view{
    if (!self.traceOpen) {
        return;
    }
    id<FTAutoTrackViewControllerProperty> appearView = view;
    NSDate *time = appearView.ft_viewLoadStartTime?:[NSDate date];
    NSString *viewReferrer = appearView.ft_parentVC;
    NSString *viewID = appearView.ft_viewUUID;
    dispatch_async(self.serialQueue, ^{
        NSString *className = NSStringFromClass(appearView.class);
        //viewModel
        FTRUMViewModel *viewModel = [[FTRUMViewModel alloc]initWithViewID:viewID viewName:className viewReferrer:viewReferrer];
        viewModel.loading_time = appearView.ft_loadDuration;
        FTRUMDataModel *model = [[FTRUMDataModel alloc]initWithType:FTRUMDataViewStart time:time];
        model.baseViewData = viewModel;
        [self process:model];
    });
}
- (void)addViewDisappearEvent:(id)view{
    if (!self.traceOpen) {
        return;
    }
    id<FTAutoTrackViewControllerProperty> disAppearView = view;
    NSDate *time = [NSDate date];
    NSString *viewID = disAppearView.ft_viewUUID;
    dispatch_async(self.serialQueue, ^{
        FTRUMViewModel *viewModel = [[FTRUMViewModel alloc]init];
        viewModel.view_id = viewID;
        FTRUMDataModel *model = [[FTRUMDataModel alloc]initWithType:FTRUMDataViewStop time:time];
        model.baseViewData = viewModel;
        [self process:model];
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
@end
