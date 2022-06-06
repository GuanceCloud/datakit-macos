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
#import "FTBaseInfoHandler.h"
#import "FTSDKAgent+Private.h"

@interface FTRUMViewHandler()<FTRUMSessionProtocol>
@property (nonatomic, strong) FTRUMContext *context;
@property (nonatomic, strong) FTRUMContext *sessionContext;
@property (nonatomic, strong) FTRUMActionHandler *actionHandler;
@property (nonatomic, strong) NSMutableDictionary *resourceHandlers;
@property (nonatomic, copy) NSString *view_id;
@property (nonatomic, copy) NSString *view_name;
@property (nonatomic, copy) NSString *view_referrer;
@property (nonatomic, strong) NSNumber *loading_time;
@property (nonatomic, assign,readwrite) BOOL isActiveView;
@property (nonatomic, assign,readwrite) BOOL isStopView;

@property (nonatomic, assign) NSInteger viewLongTaskCount;
@property (nonatomic, assign) NSInteger viewResourceCount;
@property (nonatomic, assign) NSInteger viewErrorCount;
@property (nonatomic, assign) NSInteger viewActionCount;
@property (nonatomic, assign) BOOL didReceiveStartData;
@property (nonatomic, strong) NSDate *viewStartTime;
@property (nonatomic, assign) BOOL needUpdateView;
@end
@implementation FTRUMViewHandler
-(instancetype)initWithModel:(FTRUMViewModel *)model context:(nonnull FTRUMContext *)context{
    self = [super init];
    if (self) {
        self.assistant = self;
        self.isActiveView = YES;
        self.view_id = model.view_id;
        self.view_name = model.view_name;
        self.view_referrer = model.view_referrer;
        self.loading_time = model.loading_time;
        self.didReceiveStartData = NO;
        self.viewStartTime = model.time;
        self.resourceHandlers = [NSMutableDictionary new];
        self.sessionContext = context;
        
    }
    return self;
}
- (FTRUMContext *)context{
    FTRUMContext *context = [self.sessionContext copy];
    context.view_name = self.view_name;
    context.view_id = self.view_id;
    context.view_referrer = self.view_referrer;
    context.action_id = self.actionHandler?self.actionHandler.action_id:nil;
    return context;
}
- (BOOL)process:(FTRUMDataModel *)model{
   
    self.needUpdateView = NO;
    self.actionHandler =(FTRUMActionHandler *)[self.assistant manage:(FTRUMHandler *)self.actionHandler byPropagatingData:model];
    switch (model.type) {
        case FTRUMDataViewStart:{
            FTRUMViewModel *viewModel = (FTRUMViewModel *)model;
            if (self.view_id && [self.view_id isEqualToString:viewModel.view_id]) {
                if (self.didReceiveStartData ) {
                    self.isActiveView = NO;
                }
                self.didReceiveStartData = YES;
            }else{
                self.needUpdateView = YES;
                self.isActiveView = NO;
                self.isStopView = YES;
            }
            break;
        }
        case FTRUMDataViewStop:{
            FTRUMViewModel *viewModel = (FTRUMViewModel *)model;
            if (self.view_id && [self.view_id isEqualToString:viewModel.view_id]) {
                self.needUpdateView = YES;
                self.isActiveView = NO;
                self.isStopView = YES;
            }
            break;
        }
        case FTRUMDataClick:{
            if (self.isActiveView && self.actionHandler == nil) {
                [self startAction:model];
            }
        }
            break;
        case FTRUMDataError:{
            if (self.isActiveView) {
                self.viewErrorCount++;
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
    if (model.type == FTRUMDataResourceStop || model.type == FTRUMDataResourceComplete) {
        FTRUMResourceDataModel *newModel = (FTRUMResourceDataModel *)model;
        FTRUMResourceHandler *handler =  self.resourceHandlers[newModel.identifier];
        self.resourceHandlers[newModel.identifier] =[handler.assistant manage:handler byPropagatingData:model];
    }
    
    BOOL hasNoPendingResources = self.resourceHandlers.count == 0;
    BOOL shouldComplete = self.isStopView && hasNoPendingResources;
    if (shouldComplete) {
        [self.actionHandler writeActionData:[NSDate date]];
    }
    if (self.needUpdateView) {
        [self writeViewData];
    }
    return !shouldComplete;
}
- (void)startAction:(FTRUMDataModel *)model{
    __weak typeof(self) weakSelf = self;
    FTRUMActionHandler *actionHandler = [[FTRUMActionHandler alloc]initWithModel:(FTRUMActionModel *)model context:self.context];
    actionHandler.handler = ^{
        weakSelf.viewActionCount +=1;
        weakSelf.needUpdateView = YES;
    };
    self.actionHandler = actionHandler;
}
- (void)startResource:(FTRUMResourceDataModel *)model{
    __weak typeof(self) weakSelf = self;
    FTRUMResourceHandler *resourceHandler = [[FTRUMResourceHandler alloc] initWithModel:model context:self.context];
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
    NSDictionary *sessionTag = @{FT_RUM_KEY_SESSION_ID:self.context.session_id,
                                 FT_RUM_KEY_SESSION_TYPE:self.context.session_type};
    NSMutableDictionary *tags = [NSMutableDictionary new];
    [tags addEntriesFromDictionary:data.tags];
    [tags addEntriesFromDictionary:sessionTag];
    [[FTSDKAgent sharedInstance] rumWrite:data.measurement terminal:@"web" tags:tags fields:data.fields tm:data.tm];
}
- (void)writeViewData{
    NSNumber *timeSpend = [FTDateUtil nanosecondTimeIntervalSinceDate:self.viewStartTime toDate:[NSDate date]];
    NSMutableDictionary *sessionViewTag = [NSMutableDictionary dictionaryWithDictionary:[self.context getGlobalSessionViewTags]];
    [sessionViewTag setValue:[FTBaseInfoHandler boolStr:self.isActiveView] forKey:FT_KEY_IS_ACTIVE];
    NSMutableDictionary *field = @{FT_KEY_VIEW_ERROR_COUNT:@(self.viewErrorCount),
                                   FT_KEY_VIEW_RESOURCE_COUNT:@(self.viewResourceCount),
                                   FT_KEY_VIEW_LONG_TASK_COUNT:@(self.viewLongTaskCount),
                                   FT_KEY_VIEW_ACTION_COUNT:@(self.viewActionCount),
                                   FT_KEY_TIME_SPEND:timeSpend,
                                   
    }.mutableCopy;
    if (![self.loading_time isEqual:@0]) {
        [field setValue:self.loading_time forKey:FT_RUM_KEY_Loading_time];
    }
    [[FTSDKAgent sharedInstance] rumWrite:FT_MEASUREMENT_RUM_VIEW terminal:FT_TERMINAL_APP tags:sessionViewTag fields:field];
}

@end
