//
//  FTAutoTrackProtocol.h
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/16.
//

#ifndef FTAutoTrackProtocol_h
#define FTAutoTrackProtocol_h

@protocol FTViewProperty <NSObject>

@property (nonatomic, copy, readonly) NSString *viewPath;
@property (nonatomic, copy, readonly) NSString *actionName;
@property (nonatomic, weak) id ftController;
@property (nonatomic, assign, readonly) BOOL inMainWindow;


@end

#endif /* FTAutoTrackProtocol_h */
