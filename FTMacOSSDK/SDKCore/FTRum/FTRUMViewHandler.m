//
//  FTRUMViewHandler.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2021/5/24.
//  Copyright © 2021 hll. All rights reserved.
//

#import "FTRUMViewHandler.h"
#import "FTRUMActionHandler.h"
#import "FTRUMResourceHandler.h"
#import "FTConstants.h"
#import "FTDateUtil.h"
#import "FTBaseInfoHander.h"
#import "FTSDKAgent+Private.h"
#import "FTAutoTrackProtocol.h"
@interface FTRUMViewHandler()<FTRUMSessionProtocol>
@property (nonatomic, strong) FTRUMActionHandler *actionHandler;
@property (nonatomic, strong) NSMutableDictionary *resourceHandlers;

@property (nonatomic, copy) NSString *viewid;
@property (nonatomic, assign,readwrite) BOOL isActiveView;
@property (nonatomic, weak) id<FTRumViewProperty> currentViewController;
@property (nonatomic, assign) NSInteger viewLongTaskCount;
@property (nonatomic, assign) NSInteger viewResourceCount;
@property (nonatomic, assign) NSInteger viewErrorCount;
@property (nonatomic, assign) NSInteger viewActionCount;
@property (nonatomic, assign) BOOL didReceiveStartData;
@property (nonatomic, strong) NSDate *viewStartTime;
@property (nonatomic, strong) NSNumber *loading_time;

@property (nonatomic, assign) BOOL needUpdateView;
@end
@implementation FTRUMViewHandler
-(instancetype)initWithModel:(FTRUMViewModel *)model context:(FTRUMContext *)context{
    self = [super init];
    if (self) {
        self.assistant = self;
        self.context = [context copy];
        self.isActiveView = YES;
        self.currentViewController = model.currentViewController;
        self.didReceiveStartData = NO;
        self.viewStartTime = model.time;
        self.loading_time = model.loading_time;
        self.resourceHandlers = [NSMutableDictionary new];
    }
    return self;
}

- (BOOL)process:(FTRUMDataModel *)model{
  
    self.needUpdateView = NO;
    self.actionHandler =(FTRUMActionHandler *)[self.assistant manage:(FTRUMHandler *)self.actionHandler byPropagatingData:model];
    switch (model.type) {
        case FTRUMDataViewStart:
            if (self.currentViewController && [self.currentViewController isEqual:model.currentViewController]) {
                if (self.didReceiveStartData ) {
                    self.isActiveView = NO;
                }
                self.didReceiveStartData = YES;
            }
            break;
        case FTRUMDataViewStop:
            if (self.currentViewController && [self.currentViewController isEqual:model.currentViewController]) {
                self.needUpdateView = YES;
                self.isActiveView = NO;
            }
            break;
        case FTRUMDataClick:{
            if (self.isActiveView && [self.currentViewController isEqual:model.currentViewController] && self.actionHandler == nil) {
                [self startAction:(FTRUMActionModel *)model];
            }
        }
            break;
        case FTRUMDataLaunchCold:{
            if (self.isActiveView && self.actionHandler == nil) {
                [self startAction:(FTRUMActionModel *)model];
            }
        }
            break;
        case FTRUMDataLaunchHot:{
            if (self.isActiveView && self.actionHandler == nil) {
                [self startAction:(FTRUMActionModel *)model];
            }
        }
            break;
        case FTRUMDataError:{
            if (self.isActiveView) {
                self.viewErrorCount++;
                [self writeErrorData:model];
                [self.actionHandler writeActionData:[NSDate date]];
                self.needUpdateView = YES;
            }
            break;
        }
        case FTRUMDataResourceStart:
            if (self.isActiveView) {
                [self startResource:(FTRUMResourceDataModel *)model];
            }
            break;
        case FTRUMDataLongTask:{
            if (self.isActiveView) {
                self.viewLongTaskCount++;
                [self writeErrorData:model];
                self.needUpdateView = YES;
            }
        }
            break;
        case FTRUMDataWebViewJSBData:{
            if (self.isActiveView) {
                [self writeWebViewJSBData:(FTRUMWebViewData *)model];
            }
        }
        default:
            break;
    }
    if (model.type == FTRUMDataResourceError || model.type == FTRUMDataResourceSuccess) {
        FTRUMResourceDataModel *newModel = (FTRUMResourceDataModel *)model;
        
        FTRUMResourceHandler *handler =  self.resourceHandlers[newModel.identifier];
        self.resourceHandlers[newModel.identifier] =[handler.assistant manage:handler byPropagatingData:model];
    }
    
    BOOL hasNoPendingResources = self.resourceHandlers.count == 0;
    BOOL shouldComplete = !self.isActiveView && hasNoPendingResources;
    if (shouldComplete) {
        [self.actionHandler writeActionData:[NSDate date]];
    }
    if (self.needUpdateView) {
        [self writeViewData];
    }
    return !shouldComplete;
}
- (void)startAction:(FTRUMActionModel *)model{
    __weak typeof(self) weakSelf = self;
    self.context.action_id = model.action_id;
    FTRUMActionHandler *actionHandler = [[FTRUMActionHandler alloc]initWithModel:model context:self.context];
    actionHandler.handler = ^{
        weakSelf.viewActionCount +=1;
        weakSelf.needUpdateView = YES;
    };
    self.actionHandler = actionHandler;
}
- (void)startResource:(FTRUMResourceDataModel *)model{
    __weak typeof(self) weakSelf = self;
    FTRUMResourceHandler *resourceHandler = [[FTRUMResourceHandler alloc]initWithModel:model context:self.context];
    resourceHandler.errorHandler = ^(){
        weakSelf.viewErrorCount +=1;
        weakSelf.needUpdateView = YES;
    };
    resourceHandler.resourceHandler = ^{
        weakSelf.viewResourceCount+=1;
        weakSelf.needUpdateView = YES;
    };
    self.resourceHandlers[model.identifier] =resourceHandler;
}
- (void)writeWebViewJSBData:(FTRUMWebViewData *)data{
    NSDictionary *sessionTag = @{@"session_id":self.context.session_id,
                                 @"session_type":self.context.session_type};
    NSMutableDictionary *tags = [NSMutableDictionary new];
    [tags addEntriesFromDictionary:data.tags];
    [tags addEntriesFromDictionary:sessionTag];
    [[FTSDKAgent sharedInstance] rumWrite:data.measurement terminal:@"web" tags:tags fields:data.fields tm:data.tm];
}
- (void)writeErrorData:(FTRUMDataModel *)model{
    
    NSMutableDictionary *tags = [NSMutableDictionary dictionaryWithDictionary:[self.context getGlobalSessionViewTags]];
    [tags addEntriesFromDictionary:model.tags];
    NSString *error = model.type == FTRUMDataLongTask?FT_TYPE_LONG_TASK :FT_TYPE_ERROR;
    
    [[FTSDKAgent sharedInstance] rumWrite:error terminal:@"app" tags:tags fields:model.fields];
}
- (void)writeViewData{
    //判断冷启动 冷启动可能没有viewModel
    if (!self.context.view_id) {
        return;
    }
    NSNumber *timeSpend = [FTDateUtil nanosecondtimeIntervalSinceDate:self.viewStartTime toDate:[NSDate date]];
    NSMutableDictionary *sessionViewTag = [NSMutableDictionary dictionaryWithDictionary:[self.context getGlobalSessionViewTags]];
    [sessionViewTag setValue:[FTBaseInfoHander boolStr:self.isActiveView] forKey:@"is_active"];
    [sessionViewTag setValue:[FTBaseInfoHander boolStr:self.currentViewController.dataflux_isKeyWindow] forKey:@"is_keyWindow"];

    NSMutableDictionary *field = @{@"view_error_count":@(self.viewErrorCount),
                                   @"view_resource_count":@(self.viewResourceCount),
                                   @"view_long_task_count":@(self.viewLongTaskCount),
                                   @"view_action_count":@(self.viewActionCount),
                                   @"time_spent":timeSpend,
                                   
    }.mutableCopy;
    if (![self.loading_time isEqual:@0]) {
        [field setValue:self.loading_time forKey:@"loading_time"];
    }
    [[FTSDKAgent sharedInstance] rumWrite:@"view" terminal:@"macos" tags:sessionViewTag fields:field tm:[FTDateUtil currentTimeNanosecond]];
}

@end
