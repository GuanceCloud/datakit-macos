//
//  FTAutoTrackProtocol.h
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/16.
//

#ifndef FTAutoTrackProtocol_h
#define FTAutoTrackProtocol_h

@protocol FTRUMActionProperty <NSObject>
@optional
@property (nonatomic, copy, readonly) NSString *datakit_viewPath;
@property (nonatomic, copy, readonly) NSString *datakit_actionName;
@property (nonatomic, weak, readonly) id datakit_controller;

@end
@protocol FTRumViewProperty <NSObject>
@property (nonatomic, strong) NSDate *datakit_viewLoadStartTime;
@property (nonatomic, strong) NSNumber *datakit_loadDuration;
@property (nonatomic, copy) NSString *datakit_viewUUID;
@property (nonatomic, assign) BOOL datakit_viewLoaded;
@property (nonatomic, copy, readonly) NSString *datakit_parentVC;
@property (nonatomic, copy, readonly) NSString *datakit_windowName;
@property (nonatomic, assign, readonly) BOOL datakit_inMainWindow;
@property (nonatomic, assign, readonly) BOOL datakit_isKeyWindow;
@end



#endif /* FTAutoTrackProtocol_h */
