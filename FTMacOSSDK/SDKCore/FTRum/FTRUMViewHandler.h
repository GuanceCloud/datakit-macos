//
//  FTRUMViewHandler.h
//  FTMobileAgent
//
//  Created by 胡蕾蕾 on 2021/5/24.
//  Copyright © 2021 hll. All rights reserved.
//

#import "FTRUMHandler.h"
NS_ASSUME_NONNULL_BEGIN
@class FTRUMActionHandler;
typedef void(^FTAddActionEvent)(FTRUMActionHandler *handler);

@interface FTRUMViewHandler : FTRUMHandler
@property (nonatomic, strong, readonly) FTRUMDataModel *model;
@property (nonatomic, copy)  FTAddActionEvent addActionBlock;
-(instancetype)initWithModel:(FTRUMDataModel *)model;
@end

NS_ASSUME_NONNULL_END
