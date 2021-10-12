//
//  FTRUMDataModel.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2021/5/25.
//  Copyright © 2021 hll. All rights reserved.
//

#import "FTRUMDataModel.h"
#import "FTBaseInfoHander.h"


@implementation FTRUMDataModel
-(instancetype)initWithType:(FTRUMDataType)type time:(NSDate *)time{
    self = [super init];
    if (self) {
        self.time = time;
        self.type = type;
    }
    return self;
}
@end
@implementation FTRUMViewModel
-(instancetype)initWithViewID:(NSString *)viewid viewName:(NSString *)viewName viewReferrer:(NSString *)viewReferrer{
    self = [super init];
    if (self) {
        self.view_id = viewid;
        self.view_name = viewName;
        self.view_referrer = viewReferrer;
    }
    return self;
}

@end
@implementation FTRUMActionModel

-(instancetype)initWithActionID:(NSString *)actionid actionName:(NSString *)actionName actionType:(nonnull NSString *)actionType{
    self = [super initWithType:FTRUMDataClick time:[NSDate date]];
    if (self) {
        self.action_id = actionid;
        self.action_name = actionName;
        self.action_type = actionType;
    }
    return self;
}
-(NSDictionary *)getActionTags{
    return @{@"action_id":self.action_id,
             @"action_name":self.action_name,
             @"action_type":self.action_type
    };
}
@end
@implementation FTRUMResourceDataModel

-(instancetype)initWithType:(FTRUMDataType)type identifier:(NSString *)identifier{
    self = [super initWithType:type time:[NSDate date]];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}
    
@end
@implementation FTRUMLaunchDataModel
-(instancetype)initWithType:(FTRUMDataType)type duration:(NSNumber *)duration{
    self = [super initWithType:type time:[NSDate date]];
    if (self) {
        self.duration = duration;
    }
    return self;
}
@end

@implementation FTRUMWebViewData

-(instancetype)initWithMeasurement:(NSString *)measurement tm:(long long )tm{
    self = [super initWithType:FTRUMDataWebViewJSBData time:[NSDate date]];
    if (self) {
        self.measurement = measurement;
        self.tm = tm;
    }
    return self;
}

@end
@implementation FTRUMContext
- (instancetype)copyWithZone:(NSZone *)zone {
    FTRUMContext *context = [[[self class] allocWithZone:zone] init];
    context.action_id = self.action_id;
    context.session_id = self.session_id;
    context.session_type = self.session_type;
    context.view_id = self.view_id;
    context.view_referrer = self.view_referrer;
    context.view_name = self.view_name;
    return context;
}
-(NSDictionary *)getGlobalSessionViewTags{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"session_id":self.session_id,
        @"session_type":self.session_type,
    }];
    [dict setValue:self.view_id forKey:@"view_id"];
    [dict setValue:self.view_referrer forKey:@"view_referrer"];
    [dict setValue:self.view_name forKey:@"view_name"];
    return dict;
}
-(NSDictionary *)getGlobalSessionViewActionTags{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getGlobalSessionViewTags]];
    [dict setValue:self.action_id forKey:@"action_id"];
    return dict;
}

@end
