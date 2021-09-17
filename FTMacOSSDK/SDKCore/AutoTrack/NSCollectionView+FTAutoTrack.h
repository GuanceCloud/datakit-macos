//
//  NSCollectionView+FTAutoTrack.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCollectionView (FTAutoTrack)
-(void)dataflux_setDelegate:(id<NSCollectionViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
