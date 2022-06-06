//
//  FTRUMsessionHandler.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2021/5/26.
//  Copyright © 2021 hll. All rights reserved.
//

#import "FTRUMSessionHandler.h"
#import "FTRUMViewHandler.h"
#import "FTBaseInfoHandler.h"
#import "FTDateUtil.h"
#import "FTConstants.h"
#import "FTSDKAgent+Private.h"
static const NSTimeInterval sessionTimeoutDuration = 15 * 60; // 15 minutes
static const NSTimeInterval sessionMaxDuration = 4 * 60 * 60; // 4 hours
@interface FTRUMSessionHandler()<FTRUMSessionProtocol>
@property (nonatomic, strong) FTRUMContext *context;
@property (nonatomic, strong) NSDate *sessionStartTime;
@property (nonatomic, strong) NSDate *lastInteractionTime;
@property (nonatomic, strong) NSMutableArray<FTRUMHandler*> *viewHandlers;

@property (nonatomic, strong) FTRumConfig *rumConfig;
@property (nonatomic, assign) BOOL sampling;
@end
@implementation FTRUMSessionHandler
-(instancetype)initWithModel:(FTRUMDataModel *)model rumConfig:(FTRumConfig *)rumConfig{
    self = [super init];
    if (self) {
        self.assistant = self;
        self.rumConfig = rumConfig;
//        self.sampling = [FTBaseInfoHandler randomSampling:rumConfig.samplerate];
        self.sessionStartTime = model.time;
        self.viewHandlers = [NSMutableArray new];
        self.context = [FTRUMContext new];
    }
    return  self;
}
-(void)refreshWithDate:(NSDate *)date{
    self.context.session_id = [NSUUID UUID].UUIDString;
    self.sessionStartTime = date;
    self.lastInteractionTime = date;
//    self.sampling = [FTBaseInfoHandler randomSampling:self.rumConfig.samplerate];
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
        case FTRUMDataError:
            [self writeErrorData:model];
            break;
        case FTRUMDataLongTask:
            [self writeErrorData:model];
            break;
        case FTRUMDataLaunchHot:
            [self writeLaunchData:(FTRUMLaunchDataModel*)model];
            break;
        case FTRUMDataLaunchCold:
            [self writeLaunchData:(FTRUMLaunchDataModel*)model];
            break;
        default:
            break;
    }
    self.viewHandlers = [self.assistant manageChildHandlers:self.viewHandlers byPropagatingData:model];
    return  YES;
}
-(void)startView:(FTRUMDataModel *)model{
    
    FTRUMViewHandler *viewHandler = [[FTRUMViewHandler alloc]initWithModel:(FTRUMViewModel *)model context:self.context];
    [self.viewHandlers addObject:viewHandler];
}
-(BOOL)timedOutOrExpired:(NSDate*)currentTime{
    NSTimeInterval timeElapsedSinceLastInteraction = [currentTime timeIntervalSinceDate:_lastInteractionTime];
    BOOL timedOut = timeElapsedSinceLastInteraction >= sessionTimeoutDuration;

    NSTimeInterval sessionDuration = [currentTime  timeIntervalSinceDate:_sessionStartTime];
    BOOL expired = sessionDuration >= sessionMaxDuration;

    return timedOut || expired;
}
/**
 * launch action
 * 实际意义上 与 click action 不同，action附加resource、error、long task不进行统计
 */
- (void)writeLaunchData:(FTRUMLaunchDataModel *)model{
    NSDictionary *sessionViewTag = [self getCurrentSessionInfo];
    NSMutableDictionary *tags = [NSMutableDictionary dictionaryWithDictionary:sessionViewTag];
    NSDictionary *actiontags = @{FT_RUM_KEY_ACTION_ID:[NSUUID UUID].UUIDString,
                                 FT_RUM_KEY_ACTION_NAME:model.action_name,
                                 FT_RUM_KEY_ACTION_TYPE:model.action_type
    };
    NSDictionary *fields = @{FT_DURATION:model.duration,
                             FT_RUM_KEY_ACTION_LONG_TASK_COUNT:@(0),
                             FT_RUM_KEY_ACTION_RESOURCE_COUNT:@(0),
                             FT_RUM_KEY_ACTION_ERROR_COUNT:@(0),
    };
    [tags addEntriesFromDictionary:actiontags];
    
    [[FTSDKAgent sharedInstance] rumWrite:FT_MEASUREMENT_RUM_ACTION terminal:FT_TERMINAL_APP tags:tags fields:fields tm:[FTDateUtil dateTimeNanosecond:model.time]];

}
- (void)writeErrorData:(FTRUMDataModel *)model{
    NSDictionary *sessionViewTag = [self getCurrentSessionInfo];
    NSMutableDictionary *tags = [NSMutableDictionary dictionaryWithDictionary:sessionViewTag];
    [tags addEntriesFromDictionary:model.tags];
    NSString *error = model.type == FTRUMDataLongTask?FT_MEASUREMENT_RUM_LONG_TASK :FT_MEASUREMENT_RUM_ERROR;
    
    [[FTSDKAgent sharedInstance] rumWrite:error terminal:FT_TERMINAL_APP tags:tags fields:model.fields];
}
-(NSString *)getCurrentViewID{
    FTRUMViewHandler *view = (FTRUMViewHandler *)[self.viewHandlers lastObject];
    if (view) {
        return view.context.view_id;
    }
    return nil;
}
-(NSDictionary *)getCurrentSessionInfo{
    FTRUMViewHandler *view = (FTRUMViewHandler *)[self.viewHandlers lastObject];
    if (view) {
        return [view.context getGlobalSessionViewTags];
    }
    return [self.context getGlobalSessionViewTags];
}
@end
