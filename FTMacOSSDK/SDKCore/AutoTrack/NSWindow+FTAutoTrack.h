//
//  NSWindow+FTAutoTrack.h
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (FTAutoTrack)
- (void)ft_makeKeyWindow;
- (void)ft_makeMainWindow;
- (void)ft_becomeKeyWindow;
- (void)ft_resignKeyWindow;
- (void)ft_becomeMainWindow;
- (void)ft_resignMainWindow;
- (void)ft_display;
-(instancetype)ft_init;
-(NSWindow *)ft_initWithWindowRef:(void *)windowRef;
-(instancetype)ft_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag;
- (instancetype)ft_initWithCoder:(NSCoder *)coder;
- (NSRect)ft_frameRectForContentRect:(NSRect)contentRect;
-(void)ft_beginSheet:(NSWindow *)sheetWindow completionHandler:(void (^)(NSModalResponse))handler;
@end

NS_ASSUME_NONNULL_END
