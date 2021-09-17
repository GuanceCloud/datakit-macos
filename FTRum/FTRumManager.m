//
//  FTRumManager.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "FTRumManager.h"
#import "FTTrackConfig.h"
#import "FTAutoTrackProtocol.h"
@interface FTRumManager ()
@property (nonatomic, strong) FTRumConfig *rumConfig;

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
    }
    return self;
}
- (void)addActionEventWithView:(NSView *)view{
    id<FTViewProperty> actionV = view;
    NSString *actionName = actionV.actionName;
    
}
@end
