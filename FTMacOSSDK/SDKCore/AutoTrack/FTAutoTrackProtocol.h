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
@property (nonatomic, copy, readonly) NSString *dataflux_viewPath;
@property (nonatomic, copy, readonly) NSString *dataflux_actionName;
@property (nonatomic, weak, readonly) id dataflux_controller;


@end
@protocol FTRumViewProperty <NSObject>
@property (nonatomic, strong) NSDate *dataflux_viewLoadStartTime;
@property (nonatomic, strong) NSNumber *dataflux_loadDuration;
@property (nonatomic, copy) NSString *dataflux_viewUUID;

@property (nonatomic, copy, readonly) NSString *dataflux_parentVC;

@property (nonatomic, copy, readonly) NSString *dataflux_windowName;
@property (nonatomic, assign, readonly) BOOL dataflux_inMainWindow;
@property (nonatomic, assign, readonly) BOOL dataflux_isKeyWindow;
@end



#endif /* FTAutoTrackProtocol_h */
