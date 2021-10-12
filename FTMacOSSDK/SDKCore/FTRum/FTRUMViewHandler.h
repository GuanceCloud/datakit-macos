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
@property (nonatomic, strong) FTRUMContext *context;
@property (nonatomic, strong, readonly) FTRUMDataModel *model;
@property (nonatomic, copy)  FTAddActionEvent addActionBlock;
-(instancetype)initWithModel:(FTRUMViewModel *)model context:(FTRUMContext *)context;
@end

NS_ASSUME_NONNULL_END
