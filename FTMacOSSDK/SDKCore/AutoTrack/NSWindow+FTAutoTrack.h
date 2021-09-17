//
//  NSWindow+FTAutoTrack.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (FTAutoTrack)

- (void)ft_becomeKeyWindow;
- (void)ft_resignKeyWindow;
- (void)ft_becomeMainWindow;
- (void)ft_resignMainWindow;
-(void)dataflux_close;
-(instancetype)ft_init;
-(instancetype)ft_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag;
- (instancetype)ft_initWithCoder:(NSCoder *)coder;
@end

NS_ASSUME_NONNULL_END
