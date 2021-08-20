//
//  FTConstants.h
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/6.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FTDataType) {
    FTDataTypeRUM,
    FTDataTypeLOGGING,
    FTDataTypeTRACING,
    FTDataTypeObject
};
@interface FTConstants : NSObject
+(NSString *)dataTypeStr:(FTDataType)type;
@end

NS_ASSUME_NONNULL_END
