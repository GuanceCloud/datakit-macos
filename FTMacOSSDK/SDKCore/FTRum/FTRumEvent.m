//
//  FTRumBaseEvent.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "FTRumEvent.h"

@implementation FTRumEvent

@end
@implementation FTRumActionEvent
-(instancetype)initWithActionID:(NSString *)actionid actionName:(NSString *)actionName actionType:(NSString *)actionType{
    self = [super init];
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
