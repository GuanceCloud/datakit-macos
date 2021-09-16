//
//  NSWindow+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindow+FTAutoTrack.h"

@implementation NSWindow (FTAutoTrack)
-(instancetype)ft_init{
    NSWindow *win = [self ft_init];
    NSLog(@"\n ==================\nNSWindow init= %@\n ==================",NSStringFromClass([win class]));
    return win;
}
-(NSWindow *)ft_initWithWindowRef:(void *)windowRef{
    NSWindow *win = [self ft_initWithWindowRef:windowRef];
    NSLog(@"\n ==================\nft_initWithWindowRef init= %@\n ==================",NSStringFromClass([win class]));

    return win;
}
-(instancetype)ft_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag{
    NSWindow *win = [self ft_initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    NSLog(@"\n ==================\nft_initWithContentRect init= %@\n ==================",NSStringFromClass([win class]));

    return win;
}
- (instancetype)ft_initWithCoder:(NSCoder *)coder{
    NSWindow *win = [self ft_initWithCoder:coder];
    NSLog(@"\n ==================\nft_initWithCoder init= %@\n ==================",NSStringFromClass([win class]));

    return win;
    
}

- (NSRect)ft_frameRectForContentRect:(NSRect)contentRect{
    NSRect rect = [self ft_frameRectForContentRect:contentRect];
    NSLog(@"\n ==================\nft_frameRectForContentRect init= %@\n ==================",NSStringFromClass([self class]));
    return rect;
}
- (void)ft_makeKeyWindow{
    [self ft_makeKeyWindow];
    NSLog(@"ft_makeKeyWindow = %@",NSStringFromClass(self.class));

}
- (void)ft_makeMainWindow{
    [self ft_makeMainWindow];
}
- (void)ft_becomeKeyWindow{
    [self ft_becomeKeyWindow];
    NSLog(@"ft_becomeKeyWindow = %@",NSStringFromClass(self.class));

}
- (void)ft_resignKeyWindow{
    [self ft_resignKeyWindow];
}
- (void)ft_becomeMainWindow{
    [self ft_becomeMainWindow];
    NSLog(@"ft_becomeMainWindow = %@",NSStringFromClass(self.class));
}
- (void)ft_resignMainWindow{
    [self ft_resignMainWindow];
}
- (void)ft_display{
    [self ft_display];
    NSLog(@"ft_display = %@",NSStringFromClass(self.class));

}
-(void)ft_beginSheet:(NSWindow *)sheetWindow completionHandler:(void (^)(NSModalResponse))handler{
    NSLog(@"ft_beginSheet = %@",NSStringFromClass(self.class));

    [self ft_beginSheet:sheetWindow completionHandler:handler];
}
@end
