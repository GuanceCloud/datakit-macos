//
//  FTRUMsessionHandler.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2021/5/26.
//  Copyright © 2021 hll. All rights reserved.
//

#import "FTRUMSessionHandler.h"
#import "FTRUMViewHandler.h"
#import "FTBaseInfoHander.h"
#import "FTConfigManager.h"
#import "FTLog.h"
static const NSTimeInterval sessionTimeoutDuration = 15 * 60; // 15 minutes
static const NSTimeInterval sessionMaxDuration = 4 * 60 * 60; // 4 hours
@interface FTRUMSessionHandler()<FTRUMSessionProtocol>
@property (nonatomic, strong) NSDate *sessionStartTime;
@property (nonatomic, strong) NSDate *lastInteractionTime;
@property (nonatomic, strong) NSMutableArray<FTRUMHandler*> *viewHandlers;
@property (nonatomic, assign) BOOL sampling;
@property (nonatomic, copy) NSString *session_id;
@end
@implementation FTRUMSessionHandler
-(instancetype)initWithModel:(FTRUMDataModel *)model{
    self = [super init];
    if (self) {
        self.assistant = self;
        self.viewHandlers = [NSMutableArray new];
        [self refreshSession];
    }
    return  self;
}
-(void)refreshSession{
    self.session_id = [[NSUUID UUID] UUIDString];
    self.sessionStartTime = [NSDate date];
    self.lastInteractionTime = [NSDate date];
    if ([FTBaseInfoHander randomSampling:[FTConfigManager sharedInstance].rumConfig.samplerate]) {
        self.sampling = YES;
    }else{
        self.sampling = NO;
        ZYDebug(@"根据采集算法得出，本次 session 不采集");
    }
}
- (BOOL)process:(FTRUMDataModel *)model {
    if ([self timedOutOrExpired:[NSDate date]]) {
        return NO;
    }
    if (!self.sampling) {
        return YES;
    }
    _lastInteractionTime = [NSDate date];
  
    switch (model.type) {
        case FTRUMDataViewStart:
            [self startView:model];
            break;
        case FTRUMDataLaunchCold:
            if (self.viewHandlers.count == 0) {
                [self startView:model];
            }
            break;
        case FTRUMDataError:
            if (self.viewHandlers.count == 0) {
                [self startView:model];
            }else{
                //最后一个action 的id 绑定model
            }
            break;
        case FTRUMDataResourceStart:
            
            break;
        default:
            break;
    }
    
    self.viewHandlers = [self.assistant manageChildHandlers:self.viewHandlers byPropagatingData:model];
    return  YES;
}
-(void)startView:(FTRUMDataModel *)model{
    FTRUMViewModel *viewModel =(FTRUMViewModel *)model;
    FTRUMContext *context = [[FTRUMContext alloc]init];
    context.session_id = self.session_id;
    context.session_type = @"user";
    context.view_id = viewModel.view_id;
    context.view_name = viewModel.view_name;
    context.view_referrer = viewModel.view_referrer;
    FTRUMViewHandler *viewHandler = [[FTRUMViewHandler alloc]initWithModel:viewModel context:context];
   
    [self.viewHandlers addObject:viewHandler];
}
-(BOOL)timedOutOrExpired:(NSDate*)currentTime{
    NSTimeInterval timeElapsedSinceLastInteraction = [currentTime timeIntervalSinceDate:_lastInteractionTime];
    BOOL timedOut = timeElapsedSinceLastInteraction >= sessionTimeoutDuration;

    NSTimeInterval sessionDuration = [currentTime  timeIntervalSinceDate:_sessionStartTime];
    BOOL expired = sessionDuration >= sessionMaxDuration;

    return timedOut || expired;
}
-(NSDictionary *)getCurrentSessionInfo{
    FTRUMViewHandler *view = (FTRUMViewHandler *)[self.viewHandlers lastObject];
    if (view) {
        return [view.context getGlobalSessionViewTags];
    }
    return @{};
}
@end
