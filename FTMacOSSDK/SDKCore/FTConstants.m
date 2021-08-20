//
//  FTConstants.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import "FTConstants.h"

@implementation FTConstants
+(NSString *)dataTypeStr:(FTDataType)type{
    NSString *request = nil;
    switch (type) {
        case FTDataTypeRUM:
            request = @"RUM";
            break;
        case FTDataTypeLOGGING:
            request = @"Logging";
            break;
        case FTDataTypeTRACING:
            request = @"Tracing";
            break;
        case FTDataTypeObject:
            request = @"Object";
            break;
    }
    return request;
}
@end
