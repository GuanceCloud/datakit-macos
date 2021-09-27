//
//  FTAutoTrackProtocol.h
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/16.
//

#ifndef FTAutoTrackProtocol_h
#define FTAutoTrackProtocol_h

@protocol FTAutoTrackViewProperty <NSObject>

@property (nonatomic, copy, readonly) NSString *viewPath;
@property (nonatomic, copy, readonly) NSString *actionName;
@property (nonatomic, weak) id ftController;
@property (nonatomic, assign, readonly) BOOL inMainWindow;
@property (nonatomic, assign, readonly) BOOL isKeyWindow;


@end
@protocol FTAutoTrackViewControllerProperty <NSObject>
@property (nonatomic, strong) NSDate *ft_viewLoadStartTime;
@property (nonatomic, strong) NSNumber *ft_loadDuration;
@property (nonatomic, copy, readonly) NSString *ft_viewControllerId;
@property (nonatomic, copy, readonly) NSString *ft_parentVC;
@property (nonatomic, copy) NSString *ft_viewUUID;
@end

@protocol FTAutoTrackWindowProperty <NSObject>
@property (nonatomic, strong) NSDate *ft_viewLoadStartTime;
@property (nonatomic, strong) NSNumber *ft_loadDuration;
@property (nonatomic, copy) NSString *ft_viewUUID;


@property (nonatomic, assign, readonly) BOOL inMainWindow;
@property (nonatomic, assign, readonly) BOOL isKeyWindow;


@end


#endif /* FTAutoTrackProtocol_h */
