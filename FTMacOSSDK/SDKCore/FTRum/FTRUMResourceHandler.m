//
//  FTRUMResourceHandler.m
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2021/5/26.
//  Copyright © 2021 hll. All rights reserved.
//

#import "FTRUMResourceHandler.h"
#import "FTRUMViewHandler.h"
#import "FTRUMDataModel.h"
#import "FTConstants.h"
#import "FTDateUtil.h"
#import "FTBaseInfoHander.h"
#import "FTSDKAgent+Private.h"
@interface FTRUMResourceHandler()<FTRUMSessionProtocol>
@property (nonatomic, copy,readwrite) NSString *identifier;
@property (nonatomic, strong) NSDate *time;
@end
@implementation FTRUMResourceHandler
-(instancetype)initWithModel:(FTRUMResourceDataModel *)model context:(FTRUMContext *)context{
    self = [super init];
    if (self) {
        self.identifier = model.identifier;
        self.time = model.time;
        self.context = [context copy];
        self.assistant = self;
    }
    return self;
}

- (BOOL)process:(nonnull FTRUMDataModel *)data {
    if ([data isKindOfClass:FTRUMResourceDataModel.class]) {
        FTRUMResourceDataModel *newData = (FTRUMResourceDataModel *)data;
        if (newData.identifier == self.identifier) {
            switch (data.type) {
                case FTRUMDataResourceError:{
                    [self writeErrorData:data];
                    if (self.errorHandler) {
                        self.errorHandler();
                    }
                    return NO;
                }
                    break;
                case FTRUMDataResourceSuccess:{
                    [self writeResourceData:data];
                    if (self.resourceHandler) {
                        self.resourceHandler();
                    }
                    
                    return NO;
                }
                    break;
                default:
                    break;
            }
        }
    }

    return YES;
}
- (void)writeResourceData:(FTRUMDataModel *)data{
    NSDictionary *rumTag = [self.context getGlobalSessionViewActionTags];
    NSMutableDictionary *tags = [NSMutableDictionary dictionaryWithDictionary:rumTag];
    [tags addEntriesFromDictionary:data.tags];
    [[FTSDKAgent sharedInstance] rumWrite:FT_TYPE_RESOURCE terminal:@"app" tags:tags fields:data.fields tm:[FTDateUtil dateTimeNanosecond:self.time]];
    

}
- (void)writeErrorData:(FTRUMDataModel *)data{
    NSDictionary *rumTag = [self.context getGlobalSessionViewActionTags];

    NSMutableDictionary *tags = [NSMutableDictionary dictionaryWithDictionary:rumTag];
    [tags addEntriesFromDictionary:data.tags];
    [[FTSDKAgent sharedInstance] rumWrite:FT_TYPE_ERROR terminal:@"app" tags:tags fields:data.fields tm:[FTDateUtil dateTimeNanosecond:self.time]];
}
@end
