//
//  NSViewController+FTAutoTrack.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FTAutoTrackViewControllerProperty <NSObject>
@property (nonatomic,strong)  NSDate * ft_viewLoadStartTime;
@property (nonatomic, copy, readonly) NSString *ft_viewControllerId;
//@property (nonatomic, copy, readonly) NSString *ft_parentVC;
@property (nonatomic,strong) NSNumber *ft_loadDuration;
@property (nonatomic, copy) NSString *ft_viewUUID;
@end
@interface NSViewController (FTAutoTrack)<FTAutoTrackViewControllerProperty>
- (void)dataflux_viewDidLoad;
- (void)dataflux_viewDidAppear;
- (void)dataflux_viewDidDisappear;
@end

NS_ASSUME_NONNULL_END
