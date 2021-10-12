//
//  FTRUMDataModel.h
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2021/5/25.
//  Copyright © 2021 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTAutoTrackProtocol.h"
@class FTTaskInterceptionModel;
typedef NS_ENUM(NSUInteger, FTRUMDataType) {
    FTRUMDataLaunchHot,
    FTRUMDataLaunchCold,
    FTRUMDataClick,
    FTRUMDataViewStart,
    FTRUMDataViewStop,
    FTRUMDataLongTask,
    FTRUMDataError,
    FTRUMDataResourceStart,
    FTRUMDataResourceSuccess,
    FTRUMDataResourceError,
    FTRUMDataWebViewJSBData,
};

NS_ASSUME_NONNULL_BEGIN
@interface FTRUMDataModel : NSObject
@property (nonatomic, weak) id<FTRumViewProperty> currentViewController;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, assign) FTRUMDataType type;
@property (nonatomic, strong) NSDictionary *tags;
@property (nonatomic, strong) NSDictionary *fields;

-(instancetype)initWithType:(FTRUMDataType)type time:(NSDate *)time;
@end
//tags
@interface FTRUMActionModel : FTRUMDataModel
@property (nonatomic, copy) NSString *action_id;
@property (nonatomic, copy) NSString *action_name;
@property (nonatomic, copy) NSString *action_type;
@property (nonatomic, copy) NSString *actionView_id;

-(instancetype)initWithActionID:(NSString *)actionid actionName:(NSString *)actionName actionType:(NSString *)actionType;

-(NSDictionary *)getActionTags;

@end
//tags
@interface FTRUMViewModel : FTRUMDataModel
@property (nonatomic, copy) NSString *view_id;
@property (nonatomic, copy) NSString *view_name;
@property (nonatomic, copy) NSString *view_referrer;
@property (nonatomic, strong) NSNumber *loading_time;
@end


@interface FTRUMResourceDataModel : FTRUMDataModel
@property (nonatomic, copy) NSString *identifier;

-(instancetype)initWithType:(FTRUMDataType)type identifier:(NSString *)identifier;
@end
@interface FTRUMLaunchDataModel : FTRUMDataModel
@property (nonatomic, strong) NSNumber *duration;
-(instancetype)initWithType:(FTRUMDataType)type duration:(NSNumber *)duration;
@end
@interface FTRUMWebViewData : FTRUMDataModel
@property (nonatomic, assign) long long tm;
@property (nonatomic, copy) NSString *measurement;
-(instancetype)initWithMeasurement:(NSString *)measurement tm:(long long )tm;
@end
@interface FTRUMContext : NSObject
@property (nonatomic, copy) NSString *session_id;
@property (nonatomic, copy) NSString *session_type;
@property (nonatomic, copy) NSString *view_id;
@property (nonatomic, copy) NSString *view_name;
@property (nonatomic, copy) NSString *view_referrer;
@property (nonatomic, copy) NSString *action_id;

-(NSDictionary *)getGlobalSessionViewTags;
-(NSDictionary *)getGlobalSessionViewActionTags;
@end

NS_ASSUME_NONNULL_END
